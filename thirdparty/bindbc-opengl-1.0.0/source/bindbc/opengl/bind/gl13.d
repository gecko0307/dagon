
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl13;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl12;
version(GL_AllowDeprecated)
    public import bindbc.opengl.bind.dep.dep13;


enum : uint {
    GL_TEXTURE0                       = 0x84C0,
    GL_TEXTURE1                       = 0x84C1,
    GL_TEXTURE2                       = 0x84C2,
    GL_TEXTURE3                       = 0x84C3,
    GL_TEXTURE4                       = 0x84C4,
    GL_TEXTURE5                       = 0x84C5,
    GL_TEXTURE6                       = 0x84C6,
    GL_TEXTURE7                       = 0x84C7,
    GL_TEXTURE8                       = 0x84C8,
    GL_TEXTURE9                       = 0x84C9,
    GL_TEXTURE10                      = 0x84CA,
    GL_TEXTURE11                      = 0x84CB,
    GL_TEXTURE12                      = 0x84CC,
    GL_TEXTURE13                      = 0x84CD,
    GL_TEXTURE14                      = 0x84CE,
    GL_TEXTURE15                      = 0x84CF,
    GL_TEXTURE16                      = 0x84D0,
    GL_TEXTURE17                      = 0x84D1,
    GL_TEXTURE18                      = 0x84D2,
    GL_TEXTURE19                      = 0x84D3,
    GL_TEXTURE20                      = 0x84D4,
    GL_TEXTURE21                      = 0x84D5,
    GL_TEXTURE22                      = 0x84D6,
    GL_TEXTURE23                      = 0x84D7,
    GL_TEXTURE24                      = 0x84D8,
    GL_TEXTURE25                      = 0x84D9,
    GL_TEXTURE26                      = 0x84DA,
    GL_TEXTURE27                      = 0x84DB,
    GL_TEXTURE28                      = 0x84DC,
    GL_TEXTURE29                      = 0x84DD,
    GL_TEXTURE30                      = 0x84DE,
    GL_TEXTURE31                      = 0x84DF,
    GL_ACTIVE_TEXTURE                 = 0x84E0,
    GL_MULTISAMPLE                    = 0x809D,
    GL_SAMPLE_ALPHA_TO_COVERAGE       = 0x809E,
    GL_SAMPLE_ALPHA_TO_ONE            = 0x809F,
    GL_SAMPLE_COVERAGE                = 0x80A0,
    GL_SAMPLE_BUFFERS                 = 0x80A8,
    GL_SAMPLES                        = 0x80A9,
    GL_SAMPLE_COVERAGE_VALUE          = 0x80AA,
    GL_SAMPLE_COVERAGE_INVERT         = 0x80AB,
    GL_TEXTURE_CUBE_MAP               = 0x8513,
    GL_TEXTURE_BINDING_CUBE_MAP       = 0x8514,
    GL_TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A,
    GL_PROXY_TEXTURE_CUBE_MAP         = 0x851B,
    GL_MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C,
    GL_COMPRESSED_RGB                 = 0x84ED,
    GL_COMPRESSED_RGBA                = 0x84EE,
    GL_TEXTURE_COMPRESSION_HINT       = 0x84EF,
    GL_TEXTURE_COMPRESSED_IMAGE_SIZE  = 0x86A0,
    GL_TEXTURE_COMPRESSED             = 0x86A1,
    GL_NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2,
    GL_COMPRESSED_TEXTURE_FORMATS     = 0x86A3,
    GL_CLAMP_TO_BORDER                = 0x812D,
}

extern(System) @nogc nothrow {
    alias pglActiveTexture = void function(GLenum);
    alias pglSampleCoverage = void function(GLclampf,GLboolean);
    alias pglCompressedTexImage3D = void function(GLenum,GLint,GLenum,GLsizei,GLsizei,GLsizei,GLint,GLsizei,const(GLvoid)*);
    alias pglCompressedTexImage2D = void function(GLenum,GLint,GLenum,GLsizei,GLsizei,GLint,GLsizei,const(GLvoid)*);
    alias pglCompressedTexImage1D = void function(GLenum,GLint,GLenum,GLsizei,GLint,GLsizei,const(GLvoid)*);
    alias pglCompressedTexSubImage3D = void function(GLenum,GLint,GLint,GLint,GLint,GLsizei,GLsizei,GLsizei,GLenum,GLsizei,const(GLvoid)*);
    alias pglCompressedTexSubImage2D = void function(GLenum,GLint,GLint,GLint,GLsizei,GLsizei,GLenum,GLsizei,const(GLvoid)*);
    alias pglCompressedTexSubImage1D = void function(GLenum,GLint,GLint,GLsizei,GLenum,GLsizei,const(GLvoid)*);
    alias pglGetCompressedTexImage = void function(GLenum,GLint,GLvoid*);
}

__gshared {
    pglActiveTexture glActiveTexture;
    pglSampleCoverage glSampleCoverage;
    pglCompressedTexImage3D glCompressedTexImage3D;
    pglCompressedTexImage2D glCompressedTexImage2D;
    pglCompressedTexImage1D glCompressedTexImage1D;
    pglCompressedTexSubImage3D glCompressedTexSubImage3D;
    pglCompressedTexSubImage2D glCompressedTexSubImage2D;
    pglCompressedTexSubImage1D glCompressedTexSubImage1D;
    pglGetCompressedTexImage glGetCompressedTexImage;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL13(SharedLib lib, GLSupport contextVersion)
{
    if(contextVersion > GLSupport.gl12) {
        lib.bindGLSymbol(cast(void**)&glActiveTexture, "glActiveTexture");
        lib.bindGLSymbol(cast(void**)&glSampleCoverage, "glSampleCoverage");
        lib.bindGLSymbol(cast(void**)&glCompressedTexImage3D, "glCompressedTexImage3D");
        lib.bindGLSymbol(cast(void**)&glCompressedTexImage2D, "glCompressedTexImage2D");
        lib.bindGLSymbol(cast(void**)&glCompressedTexImage1D, "glCompressedTexImage1D");
        lib.bindGLSymbol(cast(void**)&glCompressedTexSubImage3D, "glCompressedTexSubImage3D");
        lib.bindGLSymbol(cast(void**)&glCompressedTexSubImage2D, "glCompressedTexSubImage2D");
        lib.bindGLSymbol(cast(void**)&glCompressedTexSubImage1D, "glCompressedTexSubImage1D");
        lib.bindGLSymbol(cast(void**)&glGetCompressedTexImage, "glGetCompressedTexImage");

        if(errorCountGL() == 0) {
            version(GL_AllowDeprecated) return loadDeprecatedGL13(lib);
            else return true;
        }
    }
    return false;
}