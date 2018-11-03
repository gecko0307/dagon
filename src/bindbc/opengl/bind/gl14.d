
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl14;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl13;

enum : uint {
    GL_BLEND_DST_RGB                  = 0x80C8,
    GL_BLEND_SRC_RGB                  = 0x80C9,
    GL_BLEND_DST_ALPHA                = 0x80CA,
    GL_BLEND_SRC_ALPHA                = 0x80CB,
    GL_POINT_FADE_THRESHOLD_SIZE      = 0x8128,
    GL_DEPTH_COMPONENT16              = 0x81A5,
    GL_DEPTH_COMPONENT24              = 0x81A6,
    GL_DEPTH_COMPONENT32              = 0x81A7,
    GL_MIRRORED_REPEAT                = 0x8370,
    GL_MAX_TEXTURE_LOD_BIAS           = 0x84FD,
    GL_TEXTURE_LOD_BIAS               = 0x8501,
    GL_INCR_WRAP                      = 0x8507,
    GL_DECR_WRAP                      = 0x8508,
    GL_TEXTURE_DEPTH_SIZE             = 0x884A,
    GL_TEXTURE_COMPARE_MODE           = 0x884C,
    GL_TEXTURE_COMPARE_FUNC           = 0x884D,
    GL_CONSTANT_COLOR                 = 0x8001,
    GL_ONE_MINUS_CONSTANT_COLOR       = 0x8002,
    GL_CONSTANT_ALPHA                 = 0x8003,
    GL_ONE_MINUS_CONSTANT_ALPHA       = 0x8004,
    GL_FUNC_ADD                       = 0x8006,
    GL_MIN                            = 0x8007,
    GL_MAX                            = 0x8008,
    GL_FUNC_SUBTRACT                  = 0x800A,
    GL_FUNC_REVERSE_SUBTRACT          = 0x800B,
}

extern(System) @nogc nothrow {
    alias pglBlendFuncSeparate = void function(GLenum,GLenum,GLenum,GLenum);
    alias pglMultiDrawArrays = void function(GLenum,const(GLint)*,const(GLsizei)*,GLsizei);
    alias pglMultiDrawElements = void function(GLenum,const(GLsizei)*,GLenum,const(GLvoid)*,GLsizei);
    alias pglPointParameterf = void function(GLenum,GLfloat);
    alias pglPointParameterfv = void function(GLenum,const(GLfloat)*);
    alias pglPointParameteri = void function(GLenum,GLint);
    alias pglPointParameteriv = void function(GLenum,const(GLint)*);
    alias pglBlendColor = void function(GLclampf,GLclampf,GLclampf,GLclampf);
    alias pglBlendEquation = void function(GLenum);
}

__gshared {
    pglBlendFuncSeparate glBlendFuncSeparate;
    pglMultiDrawArrays glMultiDrawArrays;
    pglMultiDrawElements glMultiDrawElements;
    pglPointParameterf glPointParameterf;
    pglPointParameterfv glPointParameterfv;
    pglPointParameteri glPointParameteri;
    pglPointParameteriv glPointParameteriv;
    pglBlendColor glBlendColor;
    pglBlendEquation glBlendEquation;
}

package(bindbc.opengl) @nogc nothrow
GLSupport loadGL14(SharedLib lib, GLSupport contextVersion)
{
    auto loadedVersion = loadGL13(lib, contextVersion);
    if(loadedVersion == GLSupport.gl13 && contextVersion > GLSupport.gl13) {
        lib.bindGLSymbol(cast(void**)&glBlendFuncSeparate, "glBlendFuncSeparate");
        lib.bindGLSymbol(cast(void**)&glMultiDrawArrays, "glMultiDrawArrays");
        lib.bindGLSymbol(cast(void**)&glMultiDrawElements, "glMultiDrawElements");
        lib.bindGLSymbol(cast(void**)&glPointParameterf, "glPointParameterf");
        lib.bindGLSymbol(cast(void**)&glPointParameterfv, "glPointParameterfv");
        lib.bindGLSymbol(cast(void**)&glPointParameteri, "glPointParameteri");
        lib.bindGLSymbol(cast(void**)&glPointParameteriv, "glPointParameteriv");
        lib.bindGLSymbol(cast(void**)&glBlendColor, "glBlendColor");
        lib.bindGLSymbol(cast(void**)&glBlendEquation, "glBlendEquation");
        if(errorCountGL() == 0) loadedVersion = GLSupport.gl14;
    }
    return loadedVersion;
}