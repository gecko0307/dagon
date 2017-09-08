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
    
    CascadedShadowMap shadowMap;
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
        
        uniform sampler2DArrayShadow shadowTextureArray;
        uniform float shadowMapSize;
        uniform bool useShadows;
        
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
        
        float shadowLookup(sampler2DArrayShadow depths, float layer, vec4 coord, vec2 offset)
        {
            float texelSize = 1.0 / shadowMapSize;
            vec2 v = offset * texelSize * coord.w;
            vec4 c = (coord + vec4(v.x, v.y, 0.0, 0.0)) / coord.w;
            c.w = c.z;
            c.z = layer;
            float s = shadow2DArray(depths, c).w;
            // For sampler2DShadow:
            //float s = shadow2DProj(depths, coord + vec4(v.x, v.y, 0.0, 0.0)).w;
            return s;
        }
        
        float pcf(sampler2DArrayShadow depths, float layer, vec4 coord, float radius, float yshift)
        {
            float s = 0.0;
            float x, y;
	        for (y = -radius ; y < radius ; y += 1.0)
	        for (x = -radius ; x < radius ; x += 1.0)
            {
	            s += shadowLookup(depths, layer, coord, vec2(x, y + yshift));
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
            
            // Calculate shadow from 3 cascades
            float s1, s2, s3;
            if (useShadows)
            {
                s1 = pcf(shadowTextureArray, 0.0, shadowCoord1, 3.0, 0.0);
                s2 = pcf(shadowTextureArray, 1.0, shadowCoord2, 2.0, 0.0);
                s3 = pcf(shadowTextureArray, 2.0, shadowCoord3, 1.0, 0.0);
                float w1 = weight(shadowCoord1);
                float w2 = weight(shadowCoord2);
                float w3 = weight(shadowCoord3);
                s3 = mix(1.0, s3, w3);           
                s2 = mix(s3, s2, w2);
                s1 = mix(s2, s1, w1); // s1 stores resulting shadow value
            }
            else
            {
                s1 = 1.0f;
            }
            
            // Fetch light cluster slice
            vec2 clusterCoord = (positionWorld.xz + sceneSize * 0.5) / sceneSize;
            uint clusterIndex = texture2D(lightClusterTexture, clusterCoord).r;
            uint offset = (clusterIndex << 16) >> 16;
            uint size = (clusterIndex >> 16);

            vec3 pointDiffSum = vec3(0.0, 0.0, 0.0);
            vec3 pointSpecSum = vec3(0.0, 0.0, 0.0);
            for (uint i = 0u; i < size; i++)
            {
                // Read light data
                uint u = texelFetch1D(lightIndexTexture, int(offset + i), 0).r;
                vec3 lightPos = texelFetch2D(lightsTexture, ivec2(u, 0), 0).xyz; 
                vec3 lightColor = texelFetch2D(lightsTexture, ivec2(u, 1), 0).xyz; 
                float lightRadius = texelFetch2D(lightsTexture, ivec2(u, 2), 0).x;
                
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
    
    GLint locShadowTextureArray;    
    GLint locShadowMatrix1;
    GLint locShadowMatrix2; 
    GLint locShadowMatrix3;
    GLint locUseShadows;
    
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
        
        locShadowTextureArray = glGetUniformLocationARB(shaderProg, "shadowTextureArray");
        locShadowMatrix1 = glGetUniformLocationARB(shaderProg, "shadowMatrix1");
        locShadowMatrix2 = glGetUniformLocationARB(shaderProg, "shadowMatrix2");
        locShadowMatrix3 = glGetUniformLocationARB(shaderProg, "shadowMatrix3");
        locUseShadows = glGetUniformLocationARB(shaderProg, "useShadows");
        
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
        bool fogEnabled = boolProp(mat, "fogEnabled");
        bool parallaxEnabled = boolProp(mat, "parallaxEnabled");
        bool shadowsEnabled = boolProp(mat, "shadowsEnabled");
        auto ishadowFilter = "shadowFilter" in mat.inputs;
        
        glUseProgramObjectARB(shaderProg);
        
        // Matrices
        glUniformMatrix4fv(locInvViewMatrix, 1, 0, rc.invViewMatrix.arrayof.ptr);
        
        // Environment parameters
        Color4f one = Color4f(1, 1, 1, 1);
        glLightModelfv(GL_LIGHT_MODEL_AMBIENT, one.arrayof.ptr);
        Color4f environmentColor = Color4f(0.0f, 0.0f, 0.0f, 1.0f);
        Vector4f sunHGVector = Vector4f(0.0f, 1.0f, 0.0, 0.0f);
        Vector3f sunColor = Vector3f(1.0f, 1.0f, 1.0f);
        if (rc.environment)
        {
            environmentColor = rc.environment.ambientConstant;
            sunHGVector = Vector4f(rc.environment.sunDirection);
            sunHGVector.w = 0.0;
            sunColor = rc.environment.sunColor;
        }
        glUniform4fvARB(locEnvironmentColor, 1, environmentColor.arrayof.ptr);
        Vector3f sunDirectionEye = sunHGVector * rc.viewMatrix;
        glUniform3fvARB(locSunDirection, 1, sunDirectionEye.arrayof.ptr);
        glUniform3fvARB(locSunColor, 1, sunColor.arrayof.ptr);
        if (fogEnabled)
        {
            if (rc.environment)
            {
                glEnable(GL_FOG);
                glFogfv(GL_FOG_COLOR, rc.environment.fogColor.arrayof.ptr);
                glFogi(GL_FOG_MODE, GL_LINEAR);
                glHint(GL_FOG_HINT, GL_DONT_CARE);
                glFogf(GL_FOG_START, rc.environment.fogStart);
                glFogf(GL_FOG_END, rc.environment.fogEnd);
            }
        }
        else
        {
            glFogf(GL_FOG_START, float.max);
            glFogf(GL_FOG_END, float.max);
        }
        
        // Parallax mapping parameters
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
        glUniform1fARB(locParallaxScale, parallaxScale);
        glUniform1fARB(locParallaxBias, parallaxBias);
        
        // PBR parameters
        glUniform1fARB(locRoughness, iroughness.asFloat);
        
        // Textures
        
        // Texture 0 - diffuse texture
        if (idiffuse.texture is null)
        {
            Color4f color = Color4f(idiffuse.asVector4f);
            idiffuse.texture = makeOnePixelTexture(mat, color);
        }
        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.bind();
        glUniform1iARB(locDiffuseTexture, 0);
        
        // Texture 1 - normal map
        if (inormal.texture is null)
        {
            Color4f color = Color4f(0.5f, 0.5f, 1.0f); // default normal pointing upwards
            inormal.texture = makeOnePixelTexture(mat, color);
        }
        glActiveTextureARB(GL_TEXTURE1_ARB);
        inormal.texture.bind();
        glUniform1iARB(locNormalTexture, 1);
        
        // Texture 2 - height map
        // TODO: pass height data as an alpha channel of normap map, 
        // thus releasing space for some additional texture
        glActiveTextureARB(GL_TEXTURE2_ARB);
        iheight.texture.bind();
        glUniform1iARB(locHeightTexture, 2);
        
        // Texture 3 - shadow map cascades (3 layer texture array)
        if (shadowMap && shadowsEnabled)
        {
            glActiveTextureARB(GL_TEXTURE3_ARB);
            glBindTexture(GL_TEXTURE_2D_ARRAY, shadowMap.depthTexture.tex);

            glUniform1iARB(locShadowTextureArray, 3);
            glUniform1fARB(locShadowSize, cast(float)shadowMap.size);
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, shadowMap.area1.shadowMatrix.arrayof.ptr);
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, shadowMap.area2.shadowMatrix.arrayof.ptr);
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, shadowMap.area3.shadowMatrix.arrayof.ptr);
            glUniform1iARB(locUseShadows, 1);
            
            // TODO: shadowFilter
        }
        else
        {        
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, defaultShadowMat.arrayof.ptr);
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, defaultShadowMat.arrayof.ptr);
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, defaultShadowMat.arrayof.ptr);
            glUniform1iARB(locUseShadows, 0);
        }
        
        // Texture 4 is reserved for PBR maps (roughness + metallic)
        // Texture 5 is reserved for environment map
        
        // Texture 6 - light clusters
        glActiveTextureARB(GL_TEXTURE6_ARB);
        lightManager.bindClusterTexture();
        glUniform1iARB(locClusterTexture, 6);
        glUniform1fARB(locSceneSize, lightManager.sceneSize);
        
        // Texture 7 - light data
        glActiveTextureARB(GL_TEXTURE7_ARB);
        lightManager.bindLightTexture();
        glUniform1iARB(locLightsTexture, 7);
        glUniform1fARB(locLightTextureWidth, lightManager.maxNumLights);
        
        // Texture 8 - light indices per cluster
        glActiveTextureARB(GL_TEXTURE8_ARB);
        lightManager.bindIndexTexture();
        glUniform1iARB(locIndexTexture, 8);   
        glUniform1fARB(locIndexTextureWidth, lightManager.maxNumIndices);

        // Done with textures
        glActiveTextureARB(GL_TEXTURE0_ARB);
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
        
        if (shadowMap)
        {
            glActiveTextureARB(GL_TEXTURE3_ARB);
            glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
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
