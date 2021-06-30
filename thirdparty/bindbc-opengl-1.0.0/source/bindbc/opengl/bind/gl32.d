
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl32;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl32) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;
    import bindbc.opengl.bind.types;

    enum : uint {
        GL_CONTEXT_CORE_PROFILE_BIT       = 0x00000001,
        GL_CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002,
        GL_LINES_ADJACENCY                = 0x000A,
        GL_LINE_STRIP_ADJACENCY           = 0x000B,
        GL_TRIANGLES_ADJACENCY            = 0x000C,
        GL_TRIANGLE_STRIP_ADJACENCY       = 0x000D,
        GL_PROGRAM_POINT_SIZE             = 0x8642,
        GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29,
        GL_FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7,
        GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8,
        GL_GEOMETRY_SHADER                = 0x8DD9,
        GL_GEOMETRY_VERTICES_OUT          = 0x8916,
        GL_GEOMETRY_INPUT_TYPE            = 0x8917,
        GL_GEOMETRY_OUTPUT_TYPE           = 0x8918,
        GL_MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDF,
        GL_MAX_GEOMETRY_OUTPUT_VERTICES   = 0x8DE0,
        GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1,
        GL_MAX_VERTEX_OUTPUT_COMPONENTS   = 0x9122,
        GL_MAX_GEOMETRY_INPUT_COMPONENTS  = 0x9123,
        GL_MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124,
        GL_MAX_FRAGMENT_INPUT_COMPONENTS  = 0x9125,
        GL_CONTEXT_PROFILE_MASK           = 0x9126,
    }

    extern(System) @nogc nothrow {
        alias pglGetInteger64i_v = void function(GLenum,GLuint,GLint64*);
        alias pglGetBufferParameteri64v = void function(GLenum,GLenum,GLint64*);
        alias pglFramebufferTexture = void function(GLenum,GLenum,GLuint,GLint);
    }

    __gshared {
        pglGetInteger64i_v glGetInteger64i_v;
        pglGetBufferParameteri64v glGetBufferParameteri64v;
        pglFramebufferTexture glFramebufferTexture;
    }

    package(bindbc.opengl) @nogc nothrow
    bool loadGL32(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB32;

        if(contextVersion >= GLSupport.gl32) {
            lib.bindGLSymbol(cast(void**)&glGetInteger64i_v, "glGetInteger64i_v");
            lib.bindGLSymbol(cast(void**)&glGetBufferParameteri64v, "glGetBufferParameteri64v");
            lib.bindGLSymbol(cast(void**)&glFramebufferTexture, "glFramebufferTexture");

            if(errorCountGL() == 0 && loadARB32(lib, contextVersion)) return true;
        }
        return false;
    }
}