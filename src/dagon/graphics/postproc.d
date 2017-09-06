module dagon.graphics.postproc;

import std.stdio;
import std.conv;

import dlib.math.vector;

import derelict.opengl.gl;
import derelict.opengl.glext;

import dagon.core.ownership;
import dagon.graphics.framebuffer;

abstract class PostFilter: Owner
{
    Framebuffer fb;
    
    GLenum shaderVert;
    GLenum shaderFrag;
    GLenum shaderProg;
    
    GLint locFbColor;
    GLint locFbDepth;
    GLint locViewportSize;
    
    string vertexShader();
    string fragmentShader();

    this(Framebuffer fb, Owner o)
    {
        super(o);
        
        this.fb = fb;
        
        string vertexProgram = vertexShader();
        string fragmentProgram = fragmentShader();
        
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

        locFbColor = glGetUniformLocationARB(shaderProg, "fbColor");
        locFbDepth = glGetUniformLocationARB(shaderProg, "fbDepth");
        locViewportSize = glGetUniformLocationARB(shaderProg, "viewSize");
    }
    
    void render()
    {
        glUseProgramObjectARB(shaderProg);
        
        glActiveTextureARB(GL_TEXTURE1_ARB);
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, fb.depthTexture);
        glUniform1iARB(locFbDepth, 1);

        glActiveTextureARB(GL_TEXTURE0_ARB);
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, fb.colorTexture);
        glUniform1iARB(locFbColor, 0);
        
        Vector2f viewportSize = Vector2f(fb.width, fb.height);
        glUniform2fvARB(locViewportSize, 1, viewportSize.arrayof.ptr);
 
        fb.render();
 
        glActiveTextureARB(GL_TEXTURE1_ARB);
        glBindTexture(GL_TEXTURE_2D, 0);
        glActiveTextureARB(GL_TEXTURE0_ARB);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glUseProgramObjectARB(0);
    }
}
