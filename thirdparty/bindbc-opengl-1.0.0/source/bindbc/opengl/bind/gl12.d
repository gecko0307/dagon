
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl12;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl11;
version(GL_AllowDeprecated)
    public import bindbc.opengl.bind.dep.dep12;

enum : uint {
    GL_UNSIGNED_BYTE_3_3_2            = 0x8032,
    GL_UNSIGNED_SHORT_4_4_4_4         = 0x8033,
    GL_UNSIGNED_SHORT_5_5_5_1         = 0x8034,
    GL_UNSIGNED_INT_8_8_8_8           = 0x8035,
    GL_UNSIGNED_INT_10_10_10_2        = 0x8036,
    GL_TEXTURE_BINDING_3D             = 0x806A,
    GL_PACK_SKIP_IMAGES               = 0x806B,
    GL_PACK_IMAGE_HEIGHT              = 0x806C,
    GL_UNPACK_SKIP_IMAGES             = 0x806D,
    GL_UNPACK_IMAGE_HEIGHT            = 0x806E,
    GL_TEXTURE_3D                     = 0x806F,
    GL_PROXY_TEXTURE_3D               = 0x8070,
    GL_TEXTURE_DEPTH                  = 0x8071,
    GL_TEXTURE_WRAP_R                 = 0x8072,
    GL_MAX_3D_TEXTURE_SIZE            = 0x8073,
    GL_UNSIGNED_BYTE_2_3_3_REV        = 0x8362,
    GL_UNSIGNED_SHORT_5_6_5           = 0x8363,
    GL_UNSIGNED_SHORT_5_6_5_REV       = 0x8364,
    GL_UNSIGNED_SHORT_4_4_4_4_REV     = 0x8365,
    GL_UNSIGNED_SHORT_1_5_5_5_REV     = 0x8366,
    GL_UNSIGNED_INT_8_8_8_8_REV       = 0x8367,
    GL_UNSIGNED_INT_2_10_10_10_REV    = 0x8368,
    GL_BGR                            = 0x80E0,
    GL_BGRA                           = 0x80E1,
    GL_MAX_ELEMENTS_VERTICES          = 0x80E8,
    GL_MAX_ELEMENTS_INDICES           = 0x80E9,
    GL_CLAMP_TO_EDGE                  = 0x812F,
    GL_TEXTURE_MIN_LOD                = 0x813A,
    GL_TEXTURE_MAX_LOD                = 0x813B,
    GL_TEXTURE_BASE_LEVEL             = 0x813C,
    GL_TEXTURE_MAX_LEVEL              = 0x813D,
    GL_SMOOTH_POINT_SIZE_RANGE        = 0x0B12,
    GL_SMOOTH_POINT_SIZE_GRANULARITY  = 0x0B13,
    GL_SMOOTH_LINE_WIDTH_RANGE        = 0x0B22,
    GL_SMOOTH_LINE_WIDTH_GRANULARITY  = 0x0B23,
    GL_ALIASED_LINE_WIDTH_RANGE       = 0x846E,
}

extern(System) @nogc nothrow {
    alias pglDrawRangeElements = void function(GLenum,GLuint,GLuint,GLsizei,GLenum,const(GLvoid)*);
    alias pglTexImage3D = void function(GLenum,GLint,GLint,GLsizei,GLsizei,GLsizei,GLint,GLenum,GLenum,const(GLvoid)*);
    alias pglTexSubImage3D = void function(GLenum,GLint,GLint,GLint,GLint,GLsizei,GLsizei,GLsizei,GLenum,GLenum,const(GLvoid)*);
    alias pglCopyTexSubImage3D = void function(GLenum,GLint,GLint,GLint,GLint,GLint,GLint,GLsizei,GLsizei);
}

__gshared {
    pglDrawRangeElements glDrawRangeElements;
    pglTexImage3D glTexImage3D;
    pglTexSubImage3D glTexSubImage3D;
    pglCopyTexSubImage3D glCopyTexSubImage3D;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL12(SharedLib lib, GLSupport contextVersion)
{
    if(contextVersion > GLSupport.gl11) {
        lib.bindGLSymbol(cast(void**)&glDrawRangeElements, "glDrawRangeElements");
        lib.bindGLSymbol(cast(void**)&glTexImage3D, "glTexImage3D");
        lib.bindGLSymbol(cast(void**)&glTexSubImage3D, "glTexSubImage3D");
        lib.bindGLSymbol(cast(void**)&glCopyTexSubImage3D, "glCopyTexSubImage3D");

        if(errorCountGL() == 0) {
            version(GL_AllowDeprecated) return loadDeprecatedGL12(lib);
            else return true;
        }
    }
    return false;
}