
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl31;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl31) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;
    import bindbc.opengl.bind.types;

    enum : uint {
        GL_SAMPLER_2D_RECT                = 0x8B63,
        GL_SAMPLER_2D_RECT_SHADOW         = 0x8B64,
        GL_SAMPLER_BUFFER                 = 0x8DC2,
        GL_INT_SAMPLER_2D_RECT            = 0x8DCD,
        GL_INT_SAMPLER_BUFFER             = 0x8DD0,
        GL_UNSIGNED_INT_SAMPLER_2D_RECT   = 0x8DD5,
        GL_UNSIGNED_INT_SAMPLER_BUFFER    = 0x8DD8,
        GL_TEXTURE_BUFFER                 = 0x8C2A,
        GL_MAX_TEXTURE_BUFFER_SIZE        = 0x8C2B,
        GL_TEXTURE_BINDING_BUFFER         = 0x8C2C,
        GL_TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2D,
        GL_TEXTURE_BUFFER_FORMAT          = 0x8C2E,
        GL_TEXTURE_RECTANGLE              = 0x84F5,
        GL_TEXTURE_BINDING_RECTANGLE      = 0x84F6,
        GL_PROXY_TEXTURE_RECTANGLE        = 0x84F7,
        GL_MAX_RECTANGLE_TEXTURE_SIZE     = 0x84F8,
        GL_RED_SNORM                      = 0x8F90,
        GL_RG_SNORM                       = 0x8F91,
        GL_RGB_SNORM                      = 0x8F92,
        GL_RGBA_SNORM                     = 0x8F93,
        GL_R8_SNORM                       = 0x8F94,
        GL_RG8_SNORM                      = 0x8F95,
        GL_RGB8_SNORM                     = 0x8F96,
        GL_RGBA8_SNORM                    = 0x8F97,
        GL_R16_SNORM                      = 0x8F98,
        GL_RG16_SNORM                     = 0x8F99,
        GL_RGB16_SNORM                    = 0x8F9A,
        GL_RGBA16_SNORM                   = 0x8F9B,
        GL_SIGNED_NORMALIZED              = 0x8F9C,
        GL_PRIMITIVE_RESTART              = 0x8F9D,
        GL_PRIMITIVE_RESTART_INDEX        = 0x8F9E,
    }

    extern(System) @nogc nothrow {
        alias pglDrawArraysInstanced = void function(GLenum,GLint,GLsizei,GLsizei);
        alias pglDrawElementsInstanced = void function(GLenum,GLsizei,GLenum,const(GLvoid)*,GLsizei);
        alias pglTexBuffer = void function(GLenum,GLenum,GLuint);
        alias pglPrimitiveRestartIndex = void function(GLuint);
    }

    __gshared {
        pglDrawArraysInstanced glDrawArraysInstanced;
        pglDrawElementsInstanced glDrawElementsInstanced;
        pglTexBuffer glTexBuffer;
        pglPrimitiveRestartIndex glPrimitiveRestartIndex;
    }

    package(bindbc.opengl) @nogc nothrow
    bool loadGL31(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB31;

        if(contextVersion >= GLSupport.gl31) {
            lib.bindGLSymbol(cast(void**)&glDrawArraysInstanced, "glDrawArraysInstanced");
            lib.bindGLSymbol(cast(void**)&glDrawElementsInstanced, "glDrawElementsInstanced");
            lib.bindGLSymbol(cast(void**)&glTexBuffer, "glTexBuffer");
            lib.bindGLSymbol(cast(void**)&glPrimitiveRestartIndex, "glPrimitiveRestartIndex");

            if(errorCountGL() == 0 && loadARB31(lib, contextVersion)) return true;
        }
        return false;
    }
}