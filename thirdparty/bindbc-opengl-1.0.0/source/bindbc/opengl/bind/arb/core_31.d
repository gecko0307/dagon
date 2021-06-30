
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_31;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl31) {
    enum has31 = true;
}
else enum has31 = false;

// ARB_copy_buffer
version(GL_ARB) enum useARBCopyBuffer = true;
else version(GL_ARB_copy_buffer) enum useARBCopyBuffer = true;
else enum useARBCopyBuffer = has31;

static if(useARBCopyBuffer) {
    private bool _hasARBCopyBuffer;
    @nogc nothrow bool hasARBCopyBuffer() { return _hasARBCopyBuffer; }

    enum : uint {
        GL_COPY_READ_BUFFER               = 0x8F36,
        GL_COPY_WRITE_BUFFER              = 0x8F37,
    }

    extern(System) @nogc nothrow {
        alias pglCopyBufferSubData = void function(GLenum, GLenum, GLintptr, GLintptr, GLsizeiptr);
    }

    __gshared {
        pglCopyBufferSubData glCopyBufferSubData;
    }

    private @nogc nothrow
    bool loadARBCopyBuffer(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glCopyBufferSubData, "glCopyBufferSubData");
        return resetErrorCountGL();
    }
}
else enum hasARBCopyBuffer = false;

// ARB_uniform_buffer_object
version(GL_ARB) enum useARBUniformBufferObject = true;
else version(GL_ARB_uniform_buffer_object) enum useARBUniformBufferObject = true;
else enum useARBUniformBufferObject = has31;

static if(useARBUniformBufferObject) {
    private bool _hasARBUniformBufferObject;
    @nogc nothrow bool hasARBUniformBufferObject() { return _hasARBUniformBufferObject; }

    enum : uint {
        GL_UNIFORM_BUFFER                 = 0x8A11,
        GL_UNIFORM_BUFFER_BINDING         = 0x8A28,
        GL_UNIFORM_BUFFER_START           = 0x8A29,
        GL_UNIFORM_BUFFER_SIZE            = 0x8A2A,
        GL_MAX_VERTEX_UNIFORM_BLOCKS      = 0x8A2B,
        GL_MAX_GEOMETRY_UNIFORM_BLOCKS    = 0x8A2C,
        GL_MAX_FRAGMENT_UNIFORM_BLOCKS    = 0x8A2D,
        GL_MAX_COMBINED_UNIFORM_BLOCKS    = 0x8A2E,
        GL_MAX_UNIFORM_BUFFER_BINDINGS    = 0x8A2F,
        GL_MAX_UNIFORM_BLOCK_SIZE         = 0x8A30,
        GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31,
        GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32,
        GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33,
        GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34,
        GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35,
        GL_ACTIVE_UNIFORM_BLOCKS          = 0x8A36,
        GL_UNIFORM_TYPE                   = 0x8A37,
        GL_UNIFORM_SIZE                   = 0x8A38,
        GL_UNIFORM_NAME_LENGTH            = 0x8A39,
        GL_UNIFORM_BLOCK_INDEX            = 0x8A3A,
        GL_UNIFORM_OFFSET                 = 0x8A3B,
        GL_UNIFORM_ARRAY_STRIDE           = 0x8A3C,
        GL_UNIFORM_MATRIX_STRIDE          = 0x8A3D,
        GL_UNIFORM_IS_ROW_MAJOR           = 0x8A3E,
        GL_UNIFORM_BLOCK_BINDING          = 0x8A3F,
        GL_UNIFORM_BLOCK_DATA_SIZE        = 0x8A40,
        GL_UNIFORM_BLOCK_NAME_LENGTH      = 0x8A41,
        GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS  = 0x8A42,
        GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43,
        GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44,
        GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45,
        GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46,
        GL_INVALID_INDEX                  = 0xFFFFFFFFu,
    }

    extern(System) @nogc nothrow {
        alias pglGetUniformIndices = void function(GLuint, GLsizei, const(GLchar*)*, GLuint*);
        alias pglGetActiveUniformsiv = void function(GLuint, GLsizei, const(GLuint)*, GLenum, GLint*);
        alias pglGetActiveUniformName = void function(GLuint, GLuint, GLsizei, GLsizei*, GLchar*);
        alias pglGetUniformBlockIndex = GLuint function(GLuint, const(GLchar)*);
        alias pglGetActiveUniformBlockiv = void function(GLuint, GLuint, GLenum, GLint*);
        alias pglGetActiveUniformBlockName = void function(GLuint, GLuint, GLsizei, GLsizei*, GLchar*);
        alias pglUniformBlockBinding = void function(GLuint, GLuint, GLuint);
    }

    __gshared {
        pglGetUniformIndices glGetUniformIndices;
        pglGetActiveUniformsiv glGetActiveUniformsiv;
        pglGetActiveUniformName glGetActiveUniformName;
        pglGetUniformBlockIndex glGetUniformBlockIndex;
        pglGetActiveUniformBlockiv glGetActiveUniformBlockiv;
        pglGetActiveUniformBlockName glGetActiveUniformBlockName;
        pglUniformBlockBinding glUniformBlockBinding;
    }

    private @nogc nothrow
    bool loadARBUniformBufferObject(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glGetUniformIndices, "glGetUniformIndices");
        lib.bindGLSymbol(cast(void**)&glGetActiveUniformsiv, "glGetActiveUniformsiv");
        lib.bindGLSymbol(cast(void**)&glGetActiveUniformName, "glGetActiveUniformName");
        lib.bindGLSymbol(cast(void**)&glGetUniformBlockIndex, "glGetUniformBlockIndex");
        lib.bindGLSymbol(cast(void**)&glGetActiveUniformBlockiv, "glGetActiveUniformBlockiv");
        lib.bindGLSymbol(cast(void**)&glGetActiveUniformBlockName, "glGetActiveUniformBlockName");
        lib.bindGLSymbol(cast(void**)&glUniformBlockBinding, "glUniformBlockBinding");
        return resetErrorCountGL();
    }
}
else enum hasARBUniformBufferObject = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB31(SharedLib lib, GLSupport contextVersion)
{
    static if(has31) {
        if(contextVersion >= GLSupport.gl31) {
            bool ret = true;
            ret = _hasARBCopyBuffer = lib.loadARBCopyBuffer(contextVersion);
            ret = _hasARBUniformBufferObject = lib.loadARBUniformBufferObject(contextVersion);
            return ret;
        }
    }

    static if(useARBCopyBuffer) _hasARBCopyBuffer =
            hasExtension(contextVersion, "GL_ARB_copy_buffer") &&
            lib.loadARBCopyBuffer(contextVersion);

    static if(useARBUniformBufferObject) _hasARBUniformBufferObject =
            hasExtension(contextVersion, "GL_ARB_uniform_buffer_object") &&
            lib.loadARBUniformBufferObject(contextVersion);

    return true;
}