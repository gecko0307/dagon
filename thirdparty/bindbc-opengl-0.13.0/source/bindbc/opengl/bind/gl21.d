
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl21;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl20;
version(GL_AllowDeprecated)
    public import bindbc.opengl.bind.dep.dep21;

enum : uint {
    GL_PIXEL_PACK_BUFFER              = 0x88EB,
    GL_PIXEL_UNPACK_BUFFER            = 0x88EC,
    GL_PIXEL_PACK_BUFFER_BINDING      = 0x88ED,
    GL_PIXEL_UNPACK_BUFFER_BINDING    = 0x88EF,
    GL_FLOAT_MAT2x3                   = 0x8B65,
    GL_FLOAT_MAT2x4                   = 0x8B66,
    GL_FLOAT_MAT3x2                   = 0x8B67,
    GL_FLOAT_MAT3x4                   = 0x8B68,
    GL_FLOAT_MAT4x2                   = 0x8B69,
    GL_FLOAT_MAT4x3                   = 0x8B6A,
    GL_SRGB                           = 0x8C40,
    GL_SRGB8                          = 0x8C41,
    GL_SRGB_ALPHA                     = 0x8C42,
    GL_SRGB8_ALPHA8                   = 0x8C43,
    GL_COMPRESSED_SRGB                = 0x8C48,
    GL_COMPRESSED_SRGB_ALPHA          = 0x8C49,
}

extern(System) @nogc nothrow {
    alias pglUniformMatrix2x3fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix3x2fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix2x4fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix4x2fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix3x4fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix4x3fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
}

__gshared {
    pglUniformMatrix2x3fv glUniformMatrix2x3fv;
    pglUniformMatrix3x2fv glUniformMatrix3x2fv;
    pglUniformMatrix2x4fv glUniformMatrix2x4fv;
    pglUniformMatrix4x2fv glUniformMatrix4x2fv;
    pglUniformMatrix3x4fv glUniformMatrix3x4fv;
    pglUniformMatrix4x3fv glUniformMatrix4x3fv;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL21(SharedLib lib, GLSupport contextVersion)
{
    if(contextVersion > GLSupport.gl20) {
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2x3fv, "glUniformMatrix2x3fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3x2fv, "glUniformMatrix3x2fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2x4fv, "glUniformMatrix2x4fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4x2fv, "glUniformMatrix4x2fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3x4fv, "glUniformMatrix3x4fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4x3fv, "glUniformMatrix4x3fv");
        if(errorCountGL() == 0) return true;
    }
    return false;
}