
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl46;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl46) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context,
           bindbc.opengl.bind.types;

    enum : uint {
        GL_SHADER_BINARY_FORMAT_SPIR_V          = 0x9551,
        GL_SPIR_V_BINARY                        = 0x9552,
        GL_PARAMETER_BUFFER                     = 0x80EE,
        GL_PARAMETER_BUFFER_BINDING             = 0x80EF,
        GL_CONTEXT_FLAG_NO_ERROR_BIT            = 0x00000008,
        GL_VERTICES_SUBMITTED                   = 0x82EE,
        GL_PRIMITIVES_SUBMITTED                 = 0x82EF,
        GL_VERTEX_SHADER_INVOCATIONS            = 0x82F0,
        GL_TESS_CONTROL_SHADER_PATCHES          = 0x82F1,
        GL_TESS_EVALUATION_SHADER_INVOCATIONS   = 0x82F2,
        GL_GEOMETRY_SHADER_PRIMITIVES_EMITTED   = 0x82F3,
        GL_FRAGMENT_SHADER_INVOCATIONS          = 0x82F4,
        GL_COMPUTE_SHADER_INVOCATIONS           = 0x82F5,
        GL_CLIPPING_INPUT_PRIMITIVES            = 0x82F6,
        GL_CLIPPING_OUTPUT_PRIMITIVES           = 0x82F7,
        GL_SPIR_V_EXTENSIONS                    = 0x9553,
        GL_NUM_SPIR_V_EXTENSIONS                = 0x9554,
        GL_TRANSFORM_FEEDBACK_OVERFLOW          = 0x82EC,
        GL_TRANSFORM_FEEDBACK_STREAM_OVERFLOW   = 0x82ED,
    }

    extern(System) @nogc nothrow {
        alias pglSpecializeShader = void function( GLuint,const(GLchar)*,GLuint,const(GLuint)*,const(GLuint)* );
        alias pglMultiDrawArraysIndirectCount = void function( GLenum,const(void)*,GLintptr,GLsizei,GLsizei );
        alias pglMultiDrawElementsIndirectCount = void function( GLenum,const(void)*,GLintptr,GLsizei,GLsizei );
    }

    __gshared {
        pglSpecializeShader glSpecializeShader;
        pglMultiDrawArraysIndirectCount glMultiDrawArraysIndirectCount;
        pglMultiDrawElementsIndirectCount glMultiDrawElementsIndirectCount;
    }

    package(bindbc.opengl) @nogc nothrow
    GLSupport loadGL46(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB46;

        if(contextVersion >= GLSupport.gl46) {
            lib.bindGLSymbol(cast(void**)&glSpecializeShader, "glSpecializeShader");
            lib.bindGLSymbol(cast(void**)&glMultiDrawArraysIndirectCount, "glMultiDrawArraysIndirectCount");
            lib.bindGLSymbol(cast(void**)&glMultiDrawElementsIndirectCount, "glMultiDrawElementsIndirectCount");

            if(errorCountGL() == 0 && loadARB46(lib, contextVersion)) return GLSupport.gl46;
        }
        return GLSupport.gl45;
    }
}