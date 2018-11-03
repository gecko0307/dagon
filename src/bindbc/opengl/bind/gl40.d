
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl40;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl40) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;
    import bindbc.opengl.bind.types;

    enum : uint {
        GL_SAMPLE_SHADING                 = 0x8C36,
        GL_MIN_SAMPLE_SHADING_VALUE       = 0x8C37,
        GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5E,
        GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5F,
        GL_TEXTURE_CUBE_MAP_ARRAY         = 0x9009,
        GL_TEXTURE_BINDING_CUBE_MAP_ARRAY = 0x900A,
        GL_PROXY_TEXTURE_CUBE_MAP_ARRAY   = 0x900B,
        GL_SAMPLER_CUBE_MAP_ARRAY         = 0x900C,
        GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW  = 0x900D,
        GL_INT_SAMPLER_CUBE_MAP_ARRAY     = 0x900E,
        GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY = 0x900F,
    }

    extern(System) @nogc nothrow {
        alias pglBlendEquationi = void function(GLuint,GLenum);
        alias pglBlendEquationSeparatei = void function(GLuint,GLenum,GLenum);
        alias pglBlendFunci = void function(GLuint,GLenum,GLenum);
        alias pglBlendFuncSeparatei = void function(GLuint,GLenum,GLenum,GLenum,GLenum);
        alias pglMinSampleShading = void function(GLclampf);
    }

    __gshared {
        pglBlendEquationi glBlendEquationi;
        pglBlendEquationSeparatei glBlendEquationSeparatei;
        pglBlendFunci glBlendFunci;
        pglBlendFuncSeparatei glBlendFuncSeparatei;
        pglMinSampleShading glMinSampleShading;
    }

    package(bindbc.opengl) @nogc nothrow
    GLSupport loadGL40(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB40;

        if(contextVersion >= GLSupport.gl40) {
            lib.bindGLSymbol(cast(void**)&glMinSampleShading, "glMinSampleShading");
            lib.bindGLSymbol(cast(void**)&glBlendEquationi, "glBlendEquationi");
            lib.bindGLSymbol(cast(void**)&glBlendEquationSeparatei, "glBlendEquationSeparatei");
            lib.bindGLSymbol(cast(void**)&glBlendFunci, "glBlendFunci");
            lib.bindGLSymbol(cast(void**)&glBlendFuncSeparatei, "glBlendFuncSeparatei");

            if(errorCountGL() == 0 && loadARB40(lib, contextVersion)) return GLSupport.gl40;
        }
        return GLSupport.gl33;
    }
}