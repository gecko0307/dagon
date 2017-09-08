module dagon.graphics.materials.bp;

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
import dagon.graphics.material;
import dagon.graphics.materials.generic;

// TODO: use CascadedShadowMap instead of ShadowMap

class BlinnPhongBackend: Owner, GenericMaterialBackend
{
    //Color4f environmentColor;
    CascadedShadowMap shadowMap;
    Matrix4x4f defaultShadowMat;
    Vector3f defaultLightDir;

    GLenum shaderVert;
    GLenum shaderFrag;
    GLenum shaderProg;
    
    GLint locDiffuseTexture;
    GLint locEmitTexture;
    GLint locEnvironmentColor;
    GLint locRoughness; 
    GLint locShadowTextureArray;    
    GLint locShadowMatrix1;   
    GLint locShadowMatrix2; 
    GLint locShadowMatrix3;
    GLint locUseShadows;
    GLint locSunDirection;
    GLint locSunColor;
    GLint locShadowSize;
    
    string vertexProgram = q{
        varying vec3 positionEye;
        varying vec4 shadowCoord1;
        varying vec4 shadowCoord2;
        varying vec4 shadowCoord3;
        varying vec3 normalEye;
        varying vec3 viewEye;
        varying vec3 sunEye;

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
            shadowCoord1 = shadowMatrix1 * posShifted;
            shadowCoord2 = shadowMatrix2 * posShifted;
            shadowCoord3 = shadowMatrix3 * posShifted;
            viewEye = -pos.xyz;
            gl_Position = ftransform();
        }
    };
    
    string fragmentProgram = q{
        #extension GL_EXT_gpu_shader4: enable
        
        varying vec3 positionEye;
        varying vec4 shadowCoord1;
        varying vec4 shadowCoord2;
        varying vec4 shadowCoord3;
        varying vec3 normalEye;
        varying vec3 viewEye;
        
        uniform vec3 sunDirection;
        uniform vec3 sunColor;

        uniform sampler2D diffuseMap;
        uniform sampler2D emitMap;

        uniform vec4 environmentColor;

        uniform sampler2DArrayShadow shadowTextureArray;
        uniform float shadowMapSize;
        uniform bool useShadows;

        uniform float roughness;
        
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

            vec4 diffuseColor = texture2D(diffuseMap, texCoord);
            vec3 emitColor = texture2D(emitMap, texCoord).rgb;
            
            vec3 globalAmbient = gl_LightModel.ambient.rgb;

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
            
            vec3 pointDiffSum = vec3(0.0, 0.0, 0.0);
            vec3 pointSpecSum = vec3(0.0, 0.0, 0.0);
            
            const int maxNumLights = 5;
            
            vec3 directionToLight;
            float attenuation;
            
            for (int i = 0; i < maxNumLights; i++)
            {
                vec3 diffLightContrib = vec3(0.0, 0.0, 0.0);
                vec3 specLightContrib = vec3(0.0, 0.0, 0.0);
            
                float spotEffect = 1.0;        
                if (gl_LightSource[i].position.w < 2.0)
                {
                    vec3 positionToLightSource = vec3(gl_LightSource[i].position.xyz - positionEye);
                    float distanceToLight = length(positionToLightSource);
                    directionToLight = normalize(positionToLightSource);
                    attenuation =
                              gl_LightSource[i].constantAttenuation /
                      ((1.0 + gl_LightSource[i].linearAttenuation * distanceToLight) *
                       (1.0 + gl_LightSource[i].quadraticAttenuation * distanceToLight * distanceToLight));
                       
                    if (gl_LightSource[i].spotCutoff <= 90.0)
                    {
                        float spotCos = dot(directionToLight, normalize(gl_LightSource[i].spotDirection));
                        spotEffect = clamp(pow(spotCos, gl_LightSource[i].spotExponent) * step(gl_LightSource[i].spotCosCutoff, spotCos), 0.0, 1.0);
                    }
                    
                    diffLightContrib = (gl_LightSource[i].ambient.rgb * environmentColor.rgb + gl_LightSource[i].diffuse.rgb * clamp(dot(normalEyeN, directionToLight), 0.0, 1.0)) * attenuation;
                    NH = dot(normalEyeN, normalize(directionToLight + viewEyeN));
                    specLightContrib = gl_LightSource[i].specular.rgb * pow(max(NH, 0.0), shininess) * gloss * attenuation;
                }
                else if (gl_LightSource[i].position.w < 1.0)
                {
                    directionToLight = gl_LightSource[i].position.xyz;
                    attenuation = 1.0;
                    
                    diffLightContrib = (gl_LightSource[i].ambient.rgb * environmentColor.rgb + gl_LightSource[i].diffuse.rgb * clamp(dot(normalEyeN, directionToLight), 0.0, 1.0)) * attenuation;
                    
                    NH = dot(normalEyeN, normalize(directionToLight + viewEyeN));
                    specLightContrib = gl_LightSource[i].specular.rgb * pow(max(NH, 0.0), shininess) * gloss * attenuation;
                }
                
                pointDiffSum += diffLightContrib;
                pointSpecSum += specLightContrib;
            }
            
            float fogDistance = gl_FragCoord.z / gl_FragCoord.w;
            float fogFactor = clamp((gl_Fog.end - fogDistance) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0);
            
            vec3 objColor = diffuseColor.rgb * (globalAmbient * environmentColor.rgb + pointDiffSum + sunColor * sunDiffBrightness * s1) + 
                            pointSpecSum + sunColor * sunSpecBrightness * s1 + 
                            emitColor;
            vec3 fragColor = mix(gl_Fog.color.rgb, objColor, fogFactor);

            gl_FragColor = vec4(fragColor, diffuseColor.a);
        }
    };

    this(Owner o)
    {
        super(o);
        
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

        locDiffuseTexture = glGetUniformLocationARB(shaderProg, "diffuseMap");
        locEmitTexture = glGetUniformLocationARB(shaderProg, "emitMap");
        locEnvironmentColor = glGetUniformLocationARB(shaderProg, "environmentColor");
        locRoughness = glGetUniformLocationARB(shaderProg, "roughness");
        locShadowTextureArray = glGetUniformLocationARB(shaderProg, "shadowTextureArray");
        locShadowMatrix1 = glGetUniformLocationARB(shaderProg, "shadowMatrix1");
        locShadowMatrix2 = glGetUniformLocationARB(shaderProg, "shadowMatrix2");
        locShadowMatrix3 = glGetUniformLocationARB(shaderProg, "shadowMatrix3");
        locUseShadows = glGetUniformLocationARB(shaderProg, "useShadows");
        locSunDirection = glGetUniformLocationARB(shaderProg, "sunDirection");
        locSunColor = glGetUniformLocationARB(shaderProg, "sunColor");
        locShadowSize = glGetUniformLocationARB(shaderProg, "shadowMapSize");

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
        auto iemit = "emit" in mat.inputs;
        auto iroughness = "roughness" in mat.inputs;
        bool fogEnabled = boolProp(mat, "fogEnabled");
        bool shadowsEnabled = boolProp(mat, "shadowsEnabled");
        auto ishadowFilter = "shadowFilter" in mat.inputs;
        
        glUseProgramObjectARB(shaderProg);
        
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

        if (idiffuse.texture is null)
        {
            Color4f color = Color4f(idiffuse.asVector4f);
            idiffuse.texture = makeOnePixelTexture(mat, color);
        }

        if (iemit.texture is null)
        {
            Color4f color = Color4f(iemit.asVector4f);
            iemit.texture = makeOnePixelTexture(mat, color);
        }

        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.bind();
        glUniform1iARB(locDiffuseTexture, 0);

        glActiveTextureARB(GL_TEXTURE1_ARB);
        iemit.texture.bind();
        glUniform1iARB(locEmitTexture, 1);

        glUniform1fARB(locRoughness, iroughness.asFloat);
                
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
    }

    void unbind(GenericMaterial mat)
    {
        auto idiffuse = "diffuse" in mat.inputs;
        auto iemit = "emit" in mat.inputs;

        if (shadowMap)
        {
            glActiveTextureARB(GL_TEXTURE3_ARB);
            glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
        }
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.unbind();
        
        glActiveTextureARB(GL_TEXTURE1_ARB);
        iemit.texture.unbind();
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        
        glUseProgramObjectARB(0);
    }
}
