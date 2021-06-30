
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_44;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl44) {
    enum has44 = true;
}
else enum has44 = false;

// ARB_buffer_storage
version(GL_ARB) enum useARBBufferStorage = true;
else version(GL_ARB_buffer_storage) enum useARBBufferStorage = true;
else enum useARBBufferStorage = has44;

static if(useARBBufferStorage) {
    private bool _hasARBBufferStorage;
    @nogc nothrow bool hasARBBufferStorage() { return _hasARBBufferStorage; }

    enum : uint {
        GL_MAP_PERSISTENT_BIT             = 0x0040,
        GL_MAP_COHERENT_BIT               = 0x0080,
        GL_DYNAMIC_STORAGE_BIT            = 0x0100,
        GL_CLIENT_STORAGE_BIT             = 0x0200,
        GL_CLIENT_MAPPED_BUFFER_BARRIER_BIT = 0x00004000,
        GL_BUFFER_IMMUTABLE_STORAGE       = 0x821F,
        GL_BUFFER_STORAGE_FLAGS           = 0x8220,
    }

    extern(System) @nogc nothrow {
        alias pglBufferStorage = void function(GLenum,GLsizeiptr,const(void)*,GLbitfield);
        alias pglNamedBufferStorageEXT = void function(GLuint,GLsizeiptr,const(void)*,GLbitfield);
    }

    __gshared {
        pglBufferStorage glBufferStorage;
        pglNamedBufferStorageEXT glNamedBufferStorageEXT;
    }

    private @nogc nothrow
    bool loadARBBufferStorage(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glBufferStorage, "glBufferStorage");

        // The previous function is required when loading GL 4.3,
        // the next one is not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glNamedBufferStorageEXT, "glNamedBufferStorageEXT");

            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBBufferStorage = false;

// ARB_clear_texture
version(GL_ARB) enum useARBClearTexture = true;
else version(GL_ARB_clear_texture) enum useARBClearTexture = true;
else enum useARBClearTexture = has44;

static if(useARBClearTexture) {
    private bool _hasARBClearTexture;
    @nogc nothrow bool hasARBClearTexture() { return _hasARBClearTexture; }

    enum uint GL_CLEAR_TEXTURE = 0x9365;

    extern(System) @nogc nothrow {
        alias pglClearTexImage = void function(GLuint,GLint,GLenum,GLenum,const(void)*);
        alias pglClearTexSubImage = void function(GLuint,GLint,GLint,GLint,GLint,GLsizei,GLsizei,GLsizei,GLenum,GLenum,const(void)*);
    }

    __gshared {
        pglClearTexImage glClearTexImage;
        pglClearTexSubImage glClearTexSubImage;
    }

    private @nogc nothrow
    bool loadARBClearTexture(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glClearTexImage, "glClearTexImage");
        lib.bindGLSymbol(cast(void**)&glClearTexSubImage, "glClearTexSubImage");
        return resetErrorCountGL();
    }
}
else enum hasARBClearTexture = false;

// ARB_enhanced_layouts
version(GL_ARB) enum useARBEnhancedLayouts = true;
else version(GL_ARB_enhanced_layouts) enum useARBEnhancedLayouts = true;
else enum useARBEnhancedLayouts = has44;

static if(useARBEnhancedLayouts) {
    private bool _hasARBEnhancedLayouts;
    @nogc nothrow bool hasARBEnhancedLayouts() { return _hasARBEnhancedLayouts; }

    enum : uint  {
        GL_LOCATION_COMPONENT             = 0x934A,
        GL_TRANSFORM_FEEDBACK_BUFFER_INDEX = 0x934B,
        GL_TRANSFORM_FEEDBACK_BUFFER_STRIDE = 0x934C,
    }
}
else enum hasARBEnhancedLayouts = false;

// ARB_multi_bind
version(GL_ARB) enum useARBMultBind = true;
else version(GL_ARB_multi_bind) enum useARBMultBind = true;
else enum useARBMultBind = has44;

static if(useARBMultBind) {
    private bool _hasARBMultBind;
    @nogc nothrow bool hasARBMultBind() { return _hasARBMultBind; }

    extern(System) @nogc nothrow {
        alias pglBindBuffersBase = void function(GLenum,GLuint,GLsizei,const(GLuint)*);
        alias pglBindBuffersRange = void function(GLenum,GLuint,GLsizei,const(GLuint)*,const(GLintptr)*,const(GLsizeiptr)*);
        alias pglBindTextures = void function(GLuint,GLsizei,const(GLuint)*);
        alias pglBindSamplers = void function(GLuint,GLsizei,const(GLuint)*);
        alias pglBindImageTextures = void function(GLuint,GLsizei,const(GLuint)*);
        alias pglBindVertexBuffers = void function(GLuint,GLsizei,const(GLuint)*,const(GLintptr)*,const(GLsizei)*);
    }

    __gshared {
        pglBindBuffersBase glBindBuffersBase;
        pglBindBuffersRange glBindBuffersRange;
        pglBindTextures glBindTextures;
        pglBindSamplers glBindSamplers;
        pglBindImageTextures glBindImageTextures;
        pglBindVertexBuffers glBindVertexBuffers;
    }

    private @nogc nothrow
    bool loadARBMultBind(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glBindBuffersBase, "glBindBuffersBase");
        lib.bindGLSymbol(cast(void**)&glBindBuffersRange, "glBindBuffersRange");
        lib.bindGLSymbol(cast(void**)&glBindTextures, "glBindTextures");
        lib.bindGLSymbol(cast(void**)&glBindSamplers, "glBindSamplers");
        lib.bindGLSymbol(cast(void**)&glBindImageTextures, "glBindImageTextures");
        lib.bindGLSymbol(cast(void**)&glBindVertexBuffers, "glBindVertexBuffers");
        return resetErrorCountGL();
    }
}
else enum hasARBMultBind = false;

// ARB_query_buffer_object
version(GL_ARB) enum useARBQueryBufferObject = true;
else version(GL_ARB_query_buffer_object) enum useARBQueryBufferObject = true;
else enum useARBQueryBufferObject = has44;

static if(useARBQueryBufferObject) {
    private bool _hasARBQueryBufferObject;
    @nogc nothrow bool hasARBQueryBufferObject() { return _hasARBQueryBufferObject; }

    enum : uint  {
        GL_QUERY_BUFFER                   = 0x9192,
        GL_QUERY_BUFFER_BARRIER_BIT       = 0x00008000,
        GL_QUERY_BUFFER_BINDING           = 0x9193,
        GL_QUERY_RESULT_NO_WAIT           = 0x9194,
    }
}
else enum hasARBQueryBufferObject = false;

// ARB_texture_mirror_clamp_to_edge
version(GL_ARB) enum useARBTextureMirrorClampToEdge = true;
else version(GL_ARB_texture_mirror_clamp_to_edge) enum useARBTextureMirrorClampToEdge = true;
else enum useARBTextureMirrorClampToEdge = has44;

static if(useARBTextureMirrorClampToEdge) {
    private bool _hasARBTextureMirrorClampToEdge;
    @nogc nothrow bool hasARBTextureMirrorClampToEdge() { return _hasARBTextureMirrorClampToEdge; }

    enum uint GL_MIRROR_CLAMP_TO_EDGE = 0x8743;
}
else enum hasARBTextureMirrorClampToEdge = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB44(SharedLib lib, GLSupport contextVersion)
{
    static if(has44) {
        if(contextVersion >= GLSupport.gl44) {
            _hasARBEnhancedLayouts = true;
            _hasARBQueryBufferObject = true;
            _hasARBTextureMirrorClampToEdge = true;

            bool ret = true;
            ret = _hasARBBufferStorage = lib.loadARBBufferStorage(contextVersion);
            ret = _hasARBClearTexture = lib.loadARBClearTexture(contextVersion);
            ret = _hasARBMultBind = lib.loadARBMultBind(contextVersion);
            return ret;
        }
    }

    static if(useARBEnhancedLayouts) _hasARBEnhancedLayouts =
            hasExtension(contextVersion, "GL_ARB_enhanced_layouts");

    static if(useARBQueryBufferObject) _hasARBQueryBufferObject =
            hasExtension(contextVersion, "GL_ARB_query_buffer_object");

    static if(useARBTextureMirrorClampToEdge) _hasARBTextureMirrorClampToEdge =
            hasExtension(contextVersion, "GL_ARB_texture_mirror_clamp_to_edge");

    static if(useARBBufferStorage) _hasARBBufferStorage =
            hasExtension(contextVersion, "GL_ARB_buffer_storage") &&
            lib.loadARBBufferStorage(contextVersion);

    static if(useARBClearTexture) _hasARBClearTexture =
            hasExtension(contextVersion, "GL_ARB_clear_texture") &&
            lib.loadARBClearTexture(contextVersion);

    static if(useARBMultBind) _hasARBMultBind =
            hasExtension(contextVersion, "GL_ARB_multi_bind") &&
            lib.loadARBMultBind(contextVersion);

    return true;
}