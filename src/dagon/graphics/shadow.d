module dagon.graphics.shadow;

import std.stdio;
import std.math;
import std.conv;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.image.color;
import dlib.image.unmanaged;
import dlib.image.render.shapes;

import derelict.opengl.gl;
import derelict.opengl.glext;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.logics.entity;
import dagon.logics.behaviour;
import dagon.graphics.shapes;
import dagon.graphics.texture;
import dagon.graphics.view;
import dagon.graphics.rc;
import dagon.graphics.material;
import dagon.graphics.genericmaterial;

import dagon.templates.basescene;

class ShadowArea: Behaviour
{
    Matrix4x4f biasMatrix;
    Matrix4x4f projectionMatrix;
    Matrix4x4f viewMatrix;
    Matrix4x4f invViewMatrix;
    Matrix4x4f shadowMatrix;
    Vector3f sunDirection;
    float width;
    float height;
    float depth;
    float start;
    float end;
    float scale = 1.0f; //1.01f;
    ShapeBox box;
    View view;

    this(Entity e, View view, float w, float h, float start, float end)
    {
        super(e);   
        this.width = w;
        this.height = h;
        this.start = start;
        this.end = end; 

        this.view = view;

        depth = abs(start) + abs(end);
        this.box = New!ShapeBox(w * 0.5f, h * 0.5f, depth * 0.5f, this);

        this.biasMatrix = matrixf(
            0.5f, 0.0f, 0.0f, 0.5f,
            0.0f, 0.5f, 0.0f, 0.5f,
            0.0f, 0.0f, 0.5f, 0.5f,
            0.0f, 0.0f, 0.0f, 1.0f,
        );

        float hw = w * 0.5f;
        float hh = h * 0.5f;
        this.projectionMatrix = orthoMatrix(-hw, hw, -hh, hh, start, end);
        
        this.shadowMatrix = Matrix4x4f.identity;
        this.viewMatrix = Matrix4x4f.identity;
        this.invViewMatrix = Matrix4x4f.identity;

        sunDirection = Vector3f(0.0f, 0.0f, 1.0f);
    }

    override void update(double dt)
    {
        viewMatrix = entity.invTransformation;
        invViewMatrix = entity.transformation;
        shadowMatrix = scaleMatrix(Vector3f(scale, scale, 1.0f)) * biasMatrix * projectionMatrix * viewMatrix * view.invViewMatrix;
        sunDirection = invViewMatrix.forward;
    }

    override void render(RenderingContext* rc)
    {
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        glEnable(GL_LINE_STIPPLE);
        glLineStipple(1, 0xF0F0);

        glColor4f(1.0f, 1.0f, 0.0f, 1.0f);

        glPointSize(5.0f);
        glBegin(GL_POINTS);
        glVertex3f(0, 0, 0);
        glEnd();
        glPointSize(1.0f);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

        glPushMatrix();
        glTranslatef(0, 0, -depth * 0.5f - start);
        box.render(rc);

        glColor4f(1.0f, 1.0f, 0.0f, 1.0f);
        glBegin(GL_LINES);
        glVertex3f(0, 0, -depth * 0.5f);
        glVertex3f(0, 0, depth * 0.5f);
        glEnd();
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

        glPopMatrix();
        glLineStipple(1, 1);
        glDisable(GL_LINE_STIPPLE);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }
}

class ShadowMap: Owner
{
    uint size;
    BaseScene3D scene;
    ShadowArea area;

    Texture depthTexture;
    GLuint framebuffer;

    bool useFBO = false;

    this(uint size, BaseScene3D scene, ShadowArea area, Owner o)
    {
        super(o);
        this.size = size;
        this.scene = scene;
        this.area = area;
        
        depthTexture = New!Texture(this);
        
        glGenTextures(1, &depthTexture.tex);
        glBindTexture(GL_TEXTURE_2D, depthTexture.tex);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
        
        Color4f borderColor = Color4f(1, 1, 1, 1);
        
        glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor.arrayof.ptr);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
	    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        
        glTexParameteri(GL_TEXTURE_2D, GL_DEPTH_TEXTURE_MODE, GL_INTENSITY);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, size, size, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, null);
        
        glBindTexture(GL_TEXTURE_2D, 0);

        glGenFramebuffers(1, &framebuffer);
	    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glDrawBuffer(GL_NONE);
	    glReadBuffer(GL_NONE);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTexture.tex, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
    
    ~this()
    {
        //Delete(depthTexture);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glDeleteFramebuffers(1, &framebuffer);
    }

    void render(RenderingContext* rc)
    {
        glEnable(GL_DEPTH_TEST);
        
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

        glViewport(0, 0, size, size);
        glScissor(0, 0, size, size);
        glClear(GL_DEPTH_BUFFER_BIT);

        auto rcLocal = *rc;
        rcLocal.projectionMatrix = area.projectionMatrix;
        rcLocal.viewMatrix = area.viewMatrix;
        rcLocal.invViewMatrix = area.invViewMatrix;
        rcLocal.normalMatrix = matrix4x4to3x3(rcLocal.invViewMatrix).transposed;
        rcLocal.apply();
        
        glShadeModel(GL_FLAT);
        glColorMask(0, 0, 0, 0);
        glCullFace(GL_FRONT);
        glPolygonOffset(3.0, 0.0);

        scene.renderEntities3D(&rcLocal);
        
        glPolygonOffset(0.0, 0.0);
        glCullFace(GL_BACK);
        glShadeModel(GL_SMOOTH);
        glColorMask(1, 1, 1, 1);
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        glDisable(GL_DEPTH_TEST);
/*
        glBindTexture(GL_TEXTURE_2D, depthTexture.tex);
        glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, size, size);
        glBindTexture(GL_TEXTURE_2D, 0);
*/
    }
}

class NonPBRBackend: Owner, GenericMaterialBackend
{
    Color4f environmentColor;
    ShadowMap shadowMap1;
    ShadowMap shadowMap2;
    ShadowMap shadowMap3;
    Matrix4x4f defaultShadowMat;
    Vector3f defaultLightDir;

    GLenum shaderVert;
    GLenum shaderFrag;
    GLenum shaderProg;
    
    GLint locDiffuseTexture;
    GLint locEmitTexture;
    GLint locEnvironmentColor;
    GLint locRoughness; 
    GLint locShadowTexture1;    
    GLint locShadowMatrix1;
    GLint locShadowTexture2;    
    GLint locShadowMatrix2;
    GLint locShadowTexture3;    
    GLint locShadowMatrix3;
    GLint locSunDirection;
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
    
        void main()
        {
            gl_TexCoord[0] = gl_MultiTexCoord0;
            normalEye = gl_NormalMatrix * gl_Normal;
            vec4 pos = gl_ModelViewMatrix * gl_Vertex;
            vec4 posShifted = pos + vec4(normalEye * 0.05, 0.0);
            positionEye = pos.xyz;
            shadowCoord1 = shadowMatrix1 * posShifted;
            shadowCoord2 = shadowMatrix2 * posShifted;
            shadowCoord3 = shadowMatrix3 * posShifted;
            viewEye = -pos.xyz;
            gl_Position = ftransform();
        }
    };
    
    string fragmentProgram = q{
        varying vec3 positionEye;
        varying vec4 shadowCoord1;
        varying vec4 shadowCoord2;
        varying vec4 shadowCoord3;
        varying vec3 normalEye;
        varying vec3 viewEye;
        
        uniform vec3 sunDirection;

        uniform sampler2D diffuseMap;
        uniform sampler2D emitMap;

        uniform vec4 environmentColor;

        uniform sampler2DShadow shadowMap1;
        uniform sampler2DShadow shadowMap2;
        uniform sampler2DShadow shadowMap3;
        uniform float shadowMapSize;

        uniform float roughness;

        float shadowLookup(sampler2DShadow depths, vec4 coord, vec2 offset)
        {
            float texelSize = 1.0 / shadowMapSize;
            vec2 v = offset * texelSize * coord.w;
            float s = shadow2DProj(depths, coord + vec4(v.x, v.y, 0.0, 0.0)).w;            
            return s;
        }
        
        float pcf(sampler2DShadow depths, vec4 coord, float radius)
        {
            float s = 0.0;
            float x, y;
	        for (y = -radius ; y < radius ; y += 1.0)
	        for (x = -radius ; x < radius ; x += 1.0)
            {
	            s += shadowLookup(depths, coord, vec2(x, y));
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
            vec3 sunColor = vec3(0.5, 0.5, 0.5); // TODO: move to Environment
            
            vec3 globalAmbient = gl_LightModel.ambient.rgb;

            float gloss = 1.0 - roughness;
            float shininess = gloss * 128.0;

            float sunDiffBrightness = clamp(dot(normalEyeN, sunDirection), 0.0, 1.0);

            vec3 halfEye = normalize(sunDirection + viewEyeN);
            float NH = dot(normalEyeN, halfEye);
            float sunSpecBrightness = pow(max(NH, 0.0), shininess) * gloss;
            
            float s1, s2, s3;
            
            s1 = pcf(shadowMap1, shadowCoord1, 3.0);
            s2 = pcf(shadowMap2, shadowCoord2, 2.0);
            s3 = pcf(shadowMap3, shadowCoord3, 1.0);
            
            float w1 = weight(shadowCoord1);
            float w2 = weight(shadowCoord2);
            float w3 = weight(shadowCoord3);

            s3 = mix(1.0, s3, w3);           
            s2 = mix(s3, s2, w2);
            s1 = mix(s2, s1, w1);
            
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
        locShadowTexture1 = glGetUniformLocationARB(shaderProg, "shadowMap1");
        locShadowMatrix1 = glGetUniformLocationARB(shaderProg, "shadowMatrix1");
        locShadowTexture2 = glGetUniformLocationARB(shaderProg, "shadowMap2");
        locShadowMatrix2 = glGetUniformLocationARB(shaderProg, "shadowMatrix2");
        locShadowTexture3 = glGetUniformLocationARB(shaderProg, "shadowMap3");
        locShadowMatrix3 = glGetUniformLocationARB(shaderProg, "shadowMatrix3");
        locSunDirection = glGetUniformLocationARB(shaderProg, "sunDirection");
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
        auto ifogEnabled = "fogEnabled" in mat.inputs;

        environmentColor = Color4f(0.0f, 0.0f, 0.0f, 1.0f);
        if (rc.environment)
            environmentColor = rc.environment.ambientConstant;

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

        glUseProgramObjectARB(shaderProg);

        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.bind();
        glUniform1iARB(locDiffuseTexture, 0);

        glActiveTextureARB(GL_TEXTURE1_ARB);
        iemit.texture.bind();
        glUniform1iARB(locEmitTexture, 1);

        glUniform4fvARB(locEnvironmentColor, 1, environmentColor.arrayof.ptr);

        glUniform1fARB(locRoughness, iroughness.asFloat);
                
        if (shadowMap1)
        {
            glActiveTextureARB(GL_TEXTURE4_ARB);
            shadowMap1.depthTexture.bind();

            glUniform1iARB(locShadowTexture1, 4);
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, shadowMap1.area.shadowMatrix.arrayof.ptr);
            
            Vector4f sunVector = Vector4f(shadowMap1.area.sunDirection);
            sunVector.w = 0.0;
            Vector3f sunDirection = (sunVector * rc.viewMatrix).xyz;
            
            glUniform3fvARB(locSunDirection, 1, sunDirection.arrayof.ptr);
            glUniform1fARB(locShadowSize, cast(float)shadowMap1.size);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix1, 1, 0, defaultShadowMat.arrayof.ptr);
            glUniform3fvARB(locSunDirection, 1, defaultLightDir.arrayof.ptr);
        }
        
        if (shadowMap2)
        {
            glActiveTextureARB(GL_TEXTURE5_ARB);
            shadowMap2.depthTexture.bind();

            glUniform1iARB(locShadowTexture2, 5);
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, shadowMap2.area.shadowMatrix.arrayof.ptr);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix2, 1, 0, defaultShadowMat.arrayof.ptr);
        }
        
        if (shadowMap3)
        {
            glActiveTextureARB(GL_TEXTURE6_ARB);
            shadowMap3.depthTexture.bind();

            glUniform1iARB(locShadowTexture3, 6);
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, shadowMap3.area.shadowMatrix.arrayof.ptr);
        }
        else
        {
            glUniformMatrix4fv(locShadowMatrix3, 1, 0, defaultShadowMat.arrayof.ptr);
        }
        
        if (ifogEnabled.type == MaterialInputType.Bool ||
            ifogEnabled.type == MaterialInputType.Integer)
        {
            if (ifogEnabled.asBool && rc.environment)
            {
                glEnable(GL_FOG);
                glFogfv(GL_FOG_COLOR, rc.environment.fogColor.arrayof.ptr);
                glFogi(GL_FOG_MODE, GL_LINEAR);
                glHint(GL_FOG_HINT, GL_DONT_CARE);
                glFogf(GL_FOG_START, rc.environment.fogStart);
                glFogf(GL_FOG_END, rc.environment.fogEnd);
            }
        }
    }

    void unbind(GenericMaterial mat)
    {
        auto idiffuse = "diffuse" in mat.inputs;
        auto iemit = "emit" in mat.inputs;

        if (shadowMap1)
        {
            glActiveTextureARB(GL_TEXTURE4_ARB);
            shadowMap1.depthTexture.unbind();
        }
        
        if (shadowMap2)
        {
            glActiveTextureARB(GL_TEXTURE5_ARB);
            shadowMap2.depthTexture.unbind();
        }
        
        if (shadowMap3)
        {
            glActiveTextureARB(GL_TEXTURE6_ARB);
            shadowMap3.depthTexture.unbind();
        }
        
        glActiveTextureARB(GL_TEXTURE0_ARB);
        idiffuse.texture.unbind();
        glActiveTextureARB(GL_TEXTURE1_ARB);
        iemit.texture.unbind();
        glActiveTextureARB(GL_TEXTURE0_ARB);
        
        glUseProgramObjectARB(0);
    }
}
