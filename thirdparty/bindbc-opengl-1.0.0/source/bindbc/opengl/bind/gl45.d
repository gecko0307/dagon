
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl45;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl45) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context,
           bindbc.opengl.bind.types;

    enum uint GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT = 0x00000004;

    extern(System) @nogc nothrow {
        alias pglGetnCompressedTexImage = void function( GLenum,GLint,GLsizei,void* );
        alias pglGetnTexImage = void function( GLenum,GLint,GLenum,GLenum,GLsizei,void* );
        alias pglGetnUniformdv = void function( GLuint,GLint,GLsizei,GLdouble* );
    }

    __gshared {
        pglGetnTexImage glGetnTexImage;
        pglGetnCompressedTexImage glGetnCompressedTexImage;
        pglGetnUniformdv glGetnUniformdv;
    }

    package(bindbc.opengl) @nogc nothrow
    bool loadGL45(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB45;

        if(contextVersion >= GLSupport.gl45) {
            lib.bindGLSymbol(cast(void**)&glGetnTexImage, "glGetnTexImage");
            lib.bindGLSymbol(cast(void**)&glGetnCompressedTexImage, "glGetnCompressedTexImage");
            lib.bindGLSymbol(cast(void**)&glGetnUniformdv, "glGetnUniformdv");

            if(errorCountGL() == 0 && loadARB45(lib, contextVersion)) return true;
        }
        return false;
    }
}