
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl43;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl43) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;
    import bindbc.opengl.bind.types;
/*
    enum : uint {
        GL_NUM_SHADING_LANGUAGE_VERSIONS = 0x82E9,
        GL_VERTEX_ATTRIB_ARRAY_LONG = 0x874E,
        GL_VERTEX_BINDING_BUFFER = 0x8F4F,
        GL_DEBUG_OUTPUT_SYNCHRONOUS   = 0x8242,
        GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH = 0x8243,
        GL_DEBUG_CALLBACK_FUNCTION    = 0x8244,
        GL_DEBUG_CALLBACK_USER_PARAM  = 0x8245,
        GL_DEBUG_SOURCE_API           = 0x8246,
        GL_DEBUG_SOURCE_WINDOW_SYSTEM = 0x8247,
        GL_DEBUG_SOURCE_SHADER_COMPILER = 0x8248,
        GL_DEBUG_SOURCE_THIRD_PARTY   = 0x8249,
        GL_DEBUG_SOURCE_APPLICATION   = 0x824A,
        GL_DEBUG_SOURCE_OTHER         = 0x824B,
        GL_DEBUG_TYPE_ERROR           = 0x824C,
        GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR = 0x824D,
        GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR = 0x824E,
        GL_DEBUG_TYPE_PORTABILITY     = 0x824F,
        GL_DEBUG_TYPE_PERFORMANCE     = 0x8250,
        GL_DEBUG_TYPE_OTHER           = 0x8251,
        GL_MAX_DEBUG_MESSAGE_LENGTH   = 0x9143,
        GL_MAX_DEBUG_LOGGED_MESSAGES  = 0x9144,
        GL_DEBUG_LOGGED_MESSAGES      = 0x9145,
        GL_DEBUG_SEVERITY_HIGH        = 0x9146,
        GL_DEBUG_SEVERITY_MEDIUM      = 0x9147,
        GL_DEBUG_SEVERITY_LOW         = 0x9148,
    }

    extern(System) nothrow {
        alias GLDEBUGPROC = void function(GLenum, GLenum, GLuint, GLenum, GLsizei, in GLchar*, GLvoid*);
    }

    extern(System) @nogc nothrow {
        alias pglDebugMessageControl = void function(GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean);
        alias pglDebugMessageInsert = void function(GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*);
        alias pglGetDebugMessageLog = void function(GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*);
        alias pglDebugMessageCallback = void function(GLDEBUGPROC, const(GLvoid)*);
    }

    __gshared {
        pglDebugMessageControl glDebugMessageControl;
        pglDebugMessageInsert glDebugMessageInsert;
        pglDebugMessageCallback glDebugMessageCallback;
        pglGetDebugMessageLog glGetDebugMessageLog;
    }
*/
    package(bindbc.opengl) @nogc nothrow
    bool loadGL43(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB43;

        if(contextVersion >= GLSupport.gl43) {
        /*
            lib.bindGLSymbol(cast(void**)&glDebugMessageControl, "glDebugMessageControl");
            lib.bindGLSymbol(cast(void**)&glDebugMessageInsert, "glDebugMessageInsert");
            lib.bindGLSymbol(cast(void**)&glDebugMessageCallback, "glDebugMessageCallback");
            lib.bindGLSymbol(cast(void**)&glGetDebugMessageLog, "glGetDebugMessageLog");
        */

            if(errorCountGL() == 0 && loadARB43(lib, contextVersion)) return true;
        }
        return false;
    }
}