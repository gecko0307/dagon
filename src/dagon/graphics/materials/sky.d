module dagon.graphics.materials.sky;

import std.stdio;
import std.math;
import std.conv;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.image.color;
import dlib.image.unmanaged;

import derelict.opengl.gl;
import derelict.opengl.glext;

import dagon.core.ownership;
import dagon.graphics.rc;
import dagon.graphics.material;
import dagon.graphics.materials.generic;

class SkyBackend: Owner, GenericMaterialBackend
{
    GLenum shaderVert;
    GLenum shaderFrag;
    GLenum shaderProg;
    
    string vertexProgram = q{
        varying vec3 normalWorld;
        uniform mat4 invViewMatrix;
    
        void main()
        {
            gl_TexCoord[0] = gl_MultiTexCoord0;
            vec3 normalEye = gl_NormalMatrix * gl_Normal;
            normalWorld = (invViewMatrix * vec4(normalEye, 0.0)).xyz;
            gl_Position = ftransform();
        }
    };
    
    string fragmentProgram = q{
        varying vec3 normalWorld;
        uniform vec3 sunDirection;
        
        uniform vec3 skyZenithColor;
        uniform vec3 skyHorizonColor;
        uniform vec3 sunColor;

        void main()
        {
            vec3 normalWorldN = normalize(normalWorld);
            float sun = pow(max(0.0, dot(sunDirection, normalWorldN)), 2048.0);
            vec3 skyColor = mix(skyZenithColor, skyHorizonColor, pow(length(normalWorldN.xz), 96.0) );
            gl_FragColor = vec4(skyColor + sunColor * sun, 1.0);
        }
    };

    GLint locInvViewMatrix;
    GLint locSunDirection;
    GLint locSkyZenithColor;
    GLint locSkyHorizonColor;
    GLint locSunColor;
    
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
            
        locInvViewMatrix = glGetUniformLocationARB(shaderProg, "invViewMatrix");
        locSunDirection = glGetUniformLocationARB(shaderProg, "sunDirection");
        locSkyZenithColor = glGetUniformLocationARB(shaderProg, "skyZenithColor");
        locSkyHorizonColor = glGetUniformLocationARB(shaderProg, "skyHorizonColor");
        locSunColor = glGetUniformLocationARB(shaderProg, "sunColor");
    }
    
    void bind(GenericMaterial mat, RenderingContext* rc)
    {
        glDepthMask(0);
    
        glUseProgramObjectARB(shaderProg);
        glUniformMatrix4fv(locInvViewMatrix, 1, 0, rc.invViewMatrix.arrayof.ptr);
        
        Vector3f sunVector = Vector4f(rc.environment.sunDirection);
            
        glUniform3fvARB(locSunDirection, 1, sunVector.arrayof.ptr);
        
        Vector3f sunColor = rc.environment.sunColor;
        glUniform3fvARB(locSunColor, 1, sunColor.arrayof.ptr);
        
        glUniform3fvARB(locSkyZenithColor, 1, rc.environment.skyZenithColor.arrayof.ptr);
        glUniform3fvARB(locSkyHorizonColor, 1, rc.environment.skyHorizonColor.arrayof.ptr);
    }
    
    void unbind(GenericMaterial mat)
    {
        glUseProgramObjectARB(0);
        
        glDepthMask(1);
    }
}
