module dagon.graphics.materials.bpclustered;

import std.stdio;
import std.math;
import std.conv;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.image.color;
import dlib.image.unmanaged;
import dlib.image.render.shapes;

import derelict.opengl.gl;
import derelict.opengl.glext;

import dagon.core.ownership;
import dagon.graphics.rc;
import dagon.graphics.shadow;
import dagon.graphics.texture;
import dagon.graphics.clustered;
import dagon.graphics.material;
import dagon.graphics.materials.generic;

/*
 * Material backend for clustered forward shading
 * (variable number if lights per fragment).
 * Requires GL_EXT_gpu_shader4.
 */

class BlinnPhongClusteredBackend: Owner, GenericMaterialBackend
{
    ClusteredLightManager lightManager;
    
    ShadowMap shadowMap1;
    ShadowMap shadowMap2;
    ShadowMap shadowMap3;
    Matrix4x4f defaultShadowMat;
    Vector3f defaultLightDir;

    GLenum shaderVert;
    GLenum shaderFrag;
    GLenum shaderProg;
    
    string vertexProgram = q{
        varying vec3 positionEye;
        varying vec3 normalEye;
        varying vec3 viewEye;
        varying vec3 positionWorld;
        
        varying vec4 shadowCoord1;
        varying vec4 shadowCoord2;
        varying vec4 shadowCoord3;
        
        uniform mat4 invViewMatrix;
        
        uniform mat4 shadowMatrix1;
        uniform mat4 shadowMatrix2;
        uniform mat4 shadowMatrix3;
        
        const float eyeSpaceNormalShift = 0.05;
        
        void main()
        {
            gl_TexCoord[0] = gl_MultiTexCoord0;
            normalEye = gl_NormalMatrix * gl_Normal;
            vec4 pos = gl_ModelViewMatrix * gl_Vertex;
            vec4 posShifted = pos + vec4(normalEye * eyeSpaceNormalShift, 0.0);
            positionEye = pos.xyz;
            positionWorld = (invViewMatrix * pos).xyz;
            viewEye = -positionEye;
            shadowCoord1 = shadowMatrix1 * posShifted;
            shadowCoord2 = shadowMatrix2 * posShifted;
            shadowCoord3 = shadowMatrix3 * posShifted;
            gl_Position = ftransform();
        }
    };
    
    string fragmentProgram = q{ 
        #extension GL_EXT_gpu_shader4: enable
   
        varying vec3 positionEye;
        varying vec3 normalEye;
        varying vec3 viewEye;
        varying vec3 positionWorld;
        
        varying vec4 shadowCoord1;
        varying vec4 shadowCoord2;
        varying vec4 shadowCoord3;
        
        uniform sampler2D diffuseTexture;
        uniform sampler2D normalTexture;
        uniform sampler2D heightTexture;

        uniform float sceneSize;
        
        uniform usampler2D lightClusterTexture;
        
        uniform usampler1D lightIndexTexture;
        uniform float lightIndexTextureWidth;
        
        uniform sampler2D lightsTexture;
        uniform float lightTextureWidth;
        
        uniform vec4 environmentColor;
        
        uniform sampler2DShadow shadowMap1;
        uniform sampler2DShadow shadowMap2;
        uniform sampler2DShadow shadowMap3;
        uniform float shadowMapSize;
        
        uniform vec3 sunDirection;
        uniform vec3 sunColor;
        
        uniform float roughness;
        
        #define PI 3.14159265
        
        uniform float parallaxScale;
        uniform float parallaxBias;
        
        mat3 cotangentFrame(vec3 N, vec3 p, vec2 uv)
        {
            vec3 dp1 = dFdx(p);
            vec3 dp2 = dFdy(p);
            vec2 duv1 = dFdx(uv);
            vec2 duv2 = dFdy(uv);
            vec3 dp2perp = cross(dp2, N);
            vec3 dp1perp = cross(N, dp1);
            vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
            vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
            float invmax = inversesqrt(max(dot(T, T), dot(B, B)));
            return mat3(T * invmax, B * invmax, N);
        }
        
        float shadowLookup(sampler2DShadow depths, vec4 coord, vec2 offset)
        {
            float texelSize = 1.0 / shadowMapSize;
            vec2 v = offset * texelSize * coord.w;
            float s = shadow2DProj(depths, coord + vec4(v.x, v.y, 0.0, 0.0)).w;            
            return s;
        }
        
        float pcf(sampler2DShadow depths, vec4 coord, float radius, float yshift)
        {
            float s = 0.0;
            float x, y;
	        for (y = -radius ; y < radius ; y += 1.0)
	        for (x = -radius ; x < radius ; x += 1.0)
            {
	            s += shadowLookup(depths, coord, vec2(x, y + yshift));
            }
	        s /= radius * radius * 4.0;
            return s;
        }
        
        float weight(vec4 tc)
        {
            vec2 proj = vec2(tc.x / tc.w, tc.y / tc.w);
            proj = (1.0 - abs(proj * 2.0 - 1.0)) * 8.0;
            proj = clamp(proj, 0.0, 1.0);
            return min(proj.x, proj.y);
        }

        void main()
        {
            vec2 texCoord = gl_TexCoord[0].xy;
            
            vec3 normalEyeN = normalize(normalEye);
            vec3 viewEyeN = normalize(viewEye);
            
            mat3 TBN = cotangentFrame(normalEyeN, positionEye, texCoord);
            
            float height = texture2D(heightTexture, texCoord).r;
            height = height * parallaxScale + parallaxBias;
            vec3 Ee = normalize(viewEyeN * TBN);
            texCoord = texCoord + (height * Ee.xy);
            
            vec3 tN = normalize(texture2D(normalTexture, texCoord).rgb * 2.0 - 1.0);
            tN.y = -tN.y;
            normalEyeN = normalize(TBN * tN);
            
            float gloss = 1.0 - roughness;
            float shininess = gloss * 128.0;
            
            float sunDiffBrightness = clamp(dot(normalEyeN, sunDirection), 0.0, 1.0);

            vec3 halfEye = normalize(sunDirection + viewEyeN);
            float NH = dot(normalEyeN, halfEye);
            float sunSpecBrightness = pow(max(NH, 0.0), shininess) * gloss;
            
            float s1, s2, s3;
            
            s1 = pcf(shadowMap1, shadowCoord1, 3.0, 0.0);
            s2 = pcf(shadowMap2, shadowCoord2, 2.0, 0.0);
            s3 = pcf(shadowMap3, shadowCoord3, 1.0, 0.0);
            
            float w1 = weight(shadowCoord1);
            float w2 = weight(shadowCoord2);
            float w3 = weight(shadowCoord3);

            s3 = mix(1.0, s3, w3);           
            s2 = mix(s3, s2, w2);
            s1 = mix(s2, s1, w1);
            
            vec2 clusterCoord = (positionWorld.xz + sceneSize * 0.5) / sceneSize;
            uint clusterIndex = texture2D(lightClusterTexture, clusterCoord).r;
            uint offset = (clusterIndex << 16) >> 16;
            uint size = (clusterIndex >> 16);
            
            float invLightTextureWidth = 1.0 / lightTextureWidth;
            float invLightIndexTextureWidth = 1.0 / lightIndexTextureWidth;

            vec3 pointDiffSum = vec3(0.0, 0.0, 0.0);
            vec3 pointSpecSum = vec3(0.0, 0.0, 0.0);
            for (uint i = 0u; i < size; i++)
            {
                float u = float(texture1D(lightIndexTexture, float(offset + i) * invLightIndexTextureWidth).r) * invLightTextureWidth;
                
                vec3 lightPos = texture2D(lightsTexture, vec2(u, 0.0 / 4.0)).xyz;
                vec3 lightColor = texture2D(lightsTexture, vec2(u, 1.0 / 4.0)).xyz;
                float lightRadius = texture2D(lightsTexture, vec2(u, 2.0 / 4.0)).x;
                
                vec3 positionToLightSource = vec3(lightPos - positionEye);
                float distanceToLight = length(positionToLightSource);
                vec3 directionToLight = normalize(positionToLightSource);

                float attenuation = clamp(1.0 - (distanceToLight / lightRadius), 0.0, 1.0);
                
                pointDiffSum += lightColor * clamp(dot(normalEyeN, directionToLight), 0.0, 1.0) * attenuation;
                
                float NH = dot(normalEyeN, normalize(directionToLight + viewEyeN));
                pointSpecSum += lightColor * pow(max(NH, 0.0), shininess) * gloss * attenuation;
            }
            
            vec3 globalAmbient = gl_LightModel.ambient.rgb;
            
            vec4 diffuseColor = texture2D(diffuseTexture, texCoord);
            
            float fogDistance = gl_FragCoord.z / gl_FragCoord.w;
            float fogFactor = clamp((gl_Fog.end - fogDistance) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0);

            vec3 objColor = vec3(
                diffuseColor.rgb * (globalAmbient * environmentColor.rgb + pointDiffSum + sunColor * sunDiffBrightness * s1) + 
                pointSpecSum + sunColor * sunSpecBrightness * s1);
                
            vec3 fragColor = mix(gl_Fog.color.rgb, objColor, fogFactor);

            gl_FragColor = vec4(fragColor, diffuseColor.a);
        }
    };
    
    GLint locInvViewMatrix;
    GLint locClusterTexture;
    GLint locSceneSize;
    GLint locLightsTexture;
    GLint locLightTextureWidth;
    GLint locIndexTexture;
    GLint locIndexTextureWidth;
    GLint locDiffuseTexture;
    GLint locHeightTexture;
    GLint locNormalTexture;
    GLint locEnvironmentColor;
    
    GLint locShadowTexture1;    
    GLint locShadowMatrix1;
    GLint locShadowTexture2;    
    GLint locShadowMatrix2;
    GLint locShadowTexture3;    
    GLint locShadowMatrix3;
    GLint locSunDirection;
    GLint locSunColor;
    GLint locShadowSize;
    
    GLint locRoughness;

    GLint locParallaxScale;
    GLint locParallaxBias; 
    
    this(ClusteredLightManager clm, Owner o)
    {
        super(o);
        
        lightManager = clm;
        
        shaderProg = glCreateProgramObjectARB();
        shaderVert = glCreateShaderObjectARB(GL_VERTEX_SHADER_ARB);
        shaderFrag = glCreateShaderObjectARB(GL_FRAGMENT_SHADER_ARB);
        
        int len;
        char* srcptr;

        len = cast(int)vertexProgram.length;
        srcptr = cast(char*)vertexProgram.ptr;
        glShaderSource(shaderVert, 1, &srcptr, &len);
        
        len = cast(int)fragmentProgram.length;
        srcptr = cast(char*)fragmentProgram.ptr;
        glShaderSourceARB(shaderFrag, 1, &srcptr, &len);
        
        glCompileShaderARB(shaderVert);
        glCompileShaderARB(shaderFrag);
        glAttachObjectARB(shaderProg, shaderVert);
        glAttachObjectARB(shaderProg, shaderFrag);
        glLinkProgramARB(shaderProg);
        
        char[1000] infobuffer = 0;
        int infobufferlen = 0;

        glGetInfoLogARB(shaderVert, 999, &infobufferlen, infobuffer.ptr);
        if (infobuffer[0] != 0)
            writefln("GLSL: error in vertex shader:\n%s\n", infobuffer.ptr.to!string);

        glGetInfoLogARB(shaderFrag, 999, &infobufferlen, infobuffer.ptr);
        if (infobuffer[0] != 0)
            writefln("GLSL: error in fragment shader:\n%s\n", infobuffer.ptr.to!string);
        
        locInvViewMatrix = glGetUniformLocationARB(shaderProg, "invViewMatrix");
        
        locClusterTexture = glGetUniformLocationARB(shaderProg, "lightClusterTexture");
        locSceneSize = glGetUniformLocationARB(shaderProg, "sceneSize");
        
        locLightsTexture = glGetUniformLocationARB(shaderProg, "lightsTexture");
        locLightTextureWidth = glGetUniformLocationARB(shaderProg, "lightTextureWidth");
        locIndexTexture = glGetUniformLocationARB(shaderProg, "lightIndexTexture");
        locIndexTextureWidth = glGetUniformLocationARB(shaderProg, "lightIndexTextureWidth");
        
        locDiffuseTexture = glGetUniformLocationARB(shaderProg, "diffuseTexture");
        locNormalTexture = glGetUniformLocationARB(shaderProg, "normalTexture");
        locHeightTexture = glGetUniformLocationARB(shaderProg, "heightTexture");
        locEnvironmentColor = glGetUniformLocationARB(shaderProg, "environmentColor");
        
        locShadowTexture1 = glGetUniformLocationARB(shaderProg, "shadowMap1");
        locShadowMatrix1 = glGetUniformLocationARB(shaderProg, "shadowMatrix1");
        locShadowTexture2 = glGetUniformLocationARB(shaderProg, "shadowMap2");
        locShadowMatrix2 = glGetUniformLocationARB(shaderProg, "shadowMatrix2");
        locShadowTexture3 = glGetUniformLocationARB(shaderProg, "shadowMap3");
        locShadowMatrix3 = glGetUniformLocationARB(shaderProg, "shadowMatrix3");
        
        locSunDirection = glGetUniformLocationARB(shaderProg, "sunDirection");
        locSunColor = glGetUniformLocationARB(shaderProg, "sunColor");
        
        locShadowSize = glGetUniformLocationARB(shaderProg, "shadowMapSize");
        
        locRoughness = glGetUniformLocationARB(shaderProg, "roughness");
        
        locParallaxScale = glGetUniformLocationARB(shaderProg, "parallaxScale");
        locParallaxBias = glGetUniformLocationARB(shaderProg, "parallaxBias");

        defaultShadowMat = Matrix4x4f.zero; // zero shadow matrix is used when there's no shadow map
        defaultLightDir = Vector3f(0.0f, 1.0f, 0.0f);
    }
    
    Texture makeOnePixelTexture(Material mat, Color4f color)
    {
        auto img = New!UnmanagedImageRGBA8(8, 8);
        img.fillColor(color);
        auto tex = New!Texture(img, mat, false);
        Delete(img);
        return tex;
    }
    
    void bind(GenericMaterial mat, RenderingContext* rc)
    {
        auto idiffuse = "diffuse" in mat.inputs;
        auto inormal = "normal" in mat.inputs;
        auto iheight = "height" in mat.inputs;
        auto iroughness = "roughness" in mat.inputs;
        auto ifogEnabled = "fogEnabled" in mat.inputs;
        
        Color4f environmentColor = Color4f(0.0f, 0.0f, 0.0f, 1.0f);
        if (rc.environment)
            environmentColor = rc.environment.ambientConstant;
        
        Color4f one = Color4f(1, 1, 1, 1);
        glLightModelfv(GL_LIGHT_MODEL_AMBIENT, one.arrayof.ptr);
        
        if (idiffuse.texture is null)
        {
            Color4f color = Color4f(idiffuse.asVector4f);
            idiffuse.texture = makeOnePixelTexture(mat, color);
        }
        
        if (inormal.texture is null)
        {
            Color4f color = Color4f(0.5f, 0.5f, 1.0f); // default normal pointing upwards
            inormal.texture = makeOnePixelTexture(mat, color);
        }
        
        float parallaxScale = 0.0f;
        float parallaxBias = 0.0f;
        if (iheight.texture is null)
        {
            Color4f color = Color4f(0.3, 0.3, 0.3, 0);
            iheight.texture = makeOnePixelTexture(mat, color);
        }
        else
        {
            parallaxScale = 0.03f;
            parallaxBias = -0.01f;
        }
    
        glUseProgramObjectARB(shaderProg);
        
        glUniform1fARB(locParallaxScale, parallaxScale);
        glUniform1fARB(locParallaxBias, parallaxBias);
        
        glUniform1fARB(locRoughness, iroughness.asFloat);
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.bind();
        glUniform1iARB(locDiffuseTexture, 0);
        
        glActiveTextureARB(GL_TEXTURE1_ARB);
        inormal.texture.bind();
        glUniform1iARB(locNormalTexture, 1);
        
        glActiveTextureARB(GL_TEXTURE2_ARB);
        iheight.texture.bind();
        glUniform1iARB(locHeightTexture, 2);
        
        glUniform4fvARB(locEnvironmentColor, 1, environmentColor.arrayof.ptr);
        
        glUniformMatrix4fv(locInvViewMatrix, 1, 0, rc.invViewMatrix.arrayof.ptr);
        
        if (shadowMap1)
        {
            glActiveTextureARB(GL_TEXTURE3_ARB);
            shadowMap1.depthTexture.bind();

            glUniform1iARB(locShadowTexture1, 3);
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, shadowMap1.area.shadowMatrix.arrayof.ptr);
            
            Vector4f sunVector = Vector4f(rc.environment.sunDirection);
            sunVector.w = 0.0;
            Vector3f sunDirectionEye = (sunVector * rc.viewMatrix);
            
            glUniform3fvARB(locSunDirection, 1, sunDirectionEye.arrayof.ptr);
            glUniform1fARB(locShadowSize, cast(float)shadowMap1.size);

            Vector3f sunColor = Vector3f(1, 1, 1);
            if (rc.environment)
            {
                sunColor = rc.environment.sunColor;
            }
            glUniform3fvARB(locSunColor, 1, sunColor.arrayof.ptr);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, defaultShadowMat.arrayof.ptr);
            glUniform3fvARB(locSunDirection, 1, defaultLightDir.arrayof.ptr);
        }
        
        if (shadowMap2)
        {
            glActiveTextureARB(GL_TEXTURE4_ARB);
            shadowMap2.depthTexture.bind();

            glUniform1iARB(locShadowTexture2, 4);
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, shadowMap2.area.shadowMatrix.arrayof.ptr);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, defaultShadowMat.arrayof.ptr);
        }
        
        if (shadowMap3)
        {
            glActiveTextureARB(GL_TEXTURE5_ARB);
            shadowMap3.depthTexture.bind();

            glUniform1iARB(locShadowTexture3, 5);
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, shadowMap3.area.shadowMatrix.arrayof.ptr);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, defaultShadowMat.arrayof.ptr);
        }
        
        glActiveTextureARB(GL_TEXTURE6_ARB);
        lightManager.bindClusterTexture();
        glUniform1iARB(locClusterTexture, 6);
        
        glActiveTextureARB(GL_TEXTURE7_ARB);
        lightManager.bindLightTexture();
        glUniform1iARB(locLightsTexture, 7);
        
        glActiveTextureARB(GL_TEXTURE8_ARB);
        lightManager.bindIndexTexture();
        glUniform1iARB(locIndexTexture, 8);
                
        glUniform1fARB(locLightTextureWidth, lightManager.maxNumLights);
        glUniform1fARB(locIndexTextureWidth, lightManager.maxNumIndices);

        glUniform1fARB(locSceneSize, lightManager.sceneSize);
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        
        if (ifogEnabled.type == MaterialInputType.Bool ||
            ifogEnabled.type == MaterialInputType.Integer)
        {
            if (rc.environment)
            {
                glEnable(GL_FOG);
                glFogfv(GL_FOG_COLOR, rc.environment.fogColor.arrayof.ptr);
                glFogi(GL_FOG_MODE, GL_LINEAR);
                glHint(GL_FOG_HINT, GL_DONT_CARE);
                
                if (ifogEnabled.asBool)
                {
                    glFogf(GL_FOG_START, rc.environment.fogStart);
                    glFogf(GL_FOG_END, rc.environment.fogEnd);
                }
                else
                {
                    glFogf(GL_FOG_START, float.max);
                    glFogf(GL_FOG_END, float.max);
                }
            }
        }
    }
    
    void unbind(GenericMaterial mat)
    {
        auto idiffuse = "diffuse" in mat.inputs;
        auto inormal = "normal" in mat.inputs;
        auto iheight = "height" in mat.inputs;
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.unbind();
        
        glActiveTextureARB(GL_TEXTURE1_ARB);
        inormal.texture.unbind();
        
        glActiveTextureARB(GL_TEXTURE2_ARB);
        iheight.texture.unbind();
        
        if (shadowMap1)
        {
            glActiveTextureARB(GL_TEXTURE3_ARB);
            shadowMap1.depthTexture.unbind();
        }
        
        if (shadowMap2)
        {
            glActiveTextureARB(GL_TEXTURE4_ARB);
            shadowMap2.depthTexture.unbind();
        }
        
        if (shadowMap3)
        {
            glActiveTextureARB(GL_TEXTURE5_ARB);
            shadowMap3.depthTexture.unbind();
        }
        
        glActiveTextureARB(GL_TEXTURE6_ARB);
        lightManager.unbindClusterTexture();
        
        glActiveTextureARB(GL_TEXTURE7_ARB);
        lightManager.unbindLightTexture();
        
        glActiveTextureARB(GL_TEXTURE8_ARB);
        lightManager.unbindIndexTexture();
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
    
        glUseProgramObjectARB(0);
    }
}
