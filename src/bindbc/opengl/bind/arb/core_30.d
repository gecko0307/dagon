
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_30;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl30) {
    enum has30 = true;
}
else enum has30 = false;

// ARB_depth_buffer_float
version(GL_ARB) enum useARBDepthBufferFloat = true;
else version(GL_ARB_depth_buffer_float) enum useARBDepthBufferFloat = true;
else enum useARBDepthBufferFloat = has30;

static if(useARBDepthBufferFloat) {
    private bool _hasARBDepthBufferFloat;
    bool hasARBDepthBufferFloat() { return _hasARBDepthBufferFloat; }

    enum : uint {
        GL_DEPTH_COMPONENT32F             = 0x8CAC,
        GL_DEPTH32F_STENCIL8              = 0x8CAD,
        GL_FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD,
    }
}
else enum hasARBDepthBufferFloat = false;

// ARB_half_float_vertex
version(GL_ARB) enum useARBHalfFloatVertex = true;
else version(GL_ARB_half_float_vertex) enum useARBHalfFloatVertex = true;
else enum useARBHalfFloatVertex = has30;
static if(useARBHalfFloatVertex) {
    private bool _hasARBHalfFloatVertex;
    bool hasARBHalfFloatVertex() { return _hasARBHalfFloatVertex; }

    enum uint GL_HALF_FLOAT = 0x140B;
}
else enum hasARBHalfFloatVertex = false;

// ARB_texture_compression_rgtc
version(GL_ARB) enum useARBTextureCompressionRGTC = true;
else version(GL_ARB_texture_compression_rgtc) enum useARBTextureCompressionRGTC = true;
else enum useARBTextureCompressionRGTC = has30;

static if(useARBTextureCompressionRGTC) {
    private bool _hasARBTextureCompressionRGTC;
    bool hasARBTextureCompressionRGTC() { return _hasARBTextureCompressionRGTC; }

    enum : uint {
        GL_COMPRESSED_RED_RGTC1           = 0x8DBB,
        GL_COMPRESSED_SIGNED_RED_RGTC1    = 0x8DBC,
        GL_COMPRESSED_RG_RGTC2            = 0x8DBD,
        GL_COMPRESSED_SIGNED_RG_RGTC2     = 0x8DBE,
    }
}
else enum hasARBTextureCompressionRGTC = false;

// ARB_texture_rg
version(GL_ARB) enum useARBTextureRG = true;
else version(GL_ARB_texture_rg) enum useARBTextureRG = true;
else enum useARBTextureRG = has30;

static if(useARBTextureRG) {
    private bool _hasARBTextureRG;
    bool hasARBTextureRG() { return _hasARBTextureRG; }

    enum : uint {
        GL_RG                             = 0x8227,
        GL_RG_INTEGER                     = 0x8228,
        GL_R8                             = 0x8229,
        GL_R16                            = 0x822A,
        GL_RG8                            = 0x822B,
        GL_RG16                           = 0x822C,
        GL_R16F                           = 0x822D,
        GL_R32F                           = 0x822E,
        GL_RG16F                          = 0x822F,
        GL_RG32F                          = 0x8230,
        GL_R8I                            = 0x8231,
        GL_R8UI                           = 0x8232,
        GL_R16I                           = 0x8233,
        GL_R16UI                          = 0x8234,
        GL_R32I                           = 0x8235,
        GL_R32UI                          = 0x8236,
        GL_RG8I                           = 0x8237,
        GL_RG8UI                          = 0x8238,
        GL_RG16I                          = 0x8239,
        GL_RG16UI                         = 0x823A,
        GL_RG32I                          = 0x823B,
        GL_RG32UI                         = 0x823C,
    }
}
else enum hasARBTextureRG = false;

// ARB_framebuffer_object
version(GL_ARB) enum useARBFramebufferObject = true;
else version(GL_ARB_framebuffer_object) enum useARBFramebufferObject = true;
else enum useARBFramebufferObject = has30;

static if(useARBFramebufferObject) {
    private bool _hasARBFramebufferObject;
    bool hasARBFramebufferObject() { return _hasARBFramebufferObject; }

    enum : uint {
        GL_INVALID_FRAMEBUFFER_OPERATION  = 0x0506,
        GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210,
        GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211,
        GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212,
        GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213,
        GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214,
        GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215,
        GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216,
        GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217,
        GL_FRAMEBUFFER_DEFAULT            = 0x8218,
        GL_FRAMEBUFFER_UNDEFINED          = 0x8219,
        GL_DEPTH_STENCIL_ATTACHMENT       = 0x821A,
        GL_MAX_RENDERBUFFER_SIZE          = 0x84E8,
        GL_DEPTH_STENCIL                  = 0x84F9,
        GL_UNSIGNED_INT_24_8              = 0x84FA,
        GL_DEPTH24_STENCIL8               = 0x88F0,
        GL_TEXTURE_STENCIL_SIZE           = 0x88F1,
        GL_TEXTURE_RED_TYPE               = 0x8C10,
        GL_TEXTURE_GREEN_TYPE             = 0x8C11,
        GL_TEXTURE_BLUE_TYPE              = 0x8C12,
        GL_TEXTURE_ALPHA_TYPE             = 0x8C13,
        GL_TEXTURE_DEPTH_TYPE             = 0x8C16,
        GL_UNSIGNED_NORMALIZED            = 0x8C17,
        GL_FRAMEBUFFER_BINDING            = 0x8CA6,
        GL_DRAW_FRAMEBUFFER_BINDING       = GL_FRAMEBUFFER_BINDING,
        GL_RENDERBUFFER_BINDING           = 0x8CA7,
        GL_READ_FRAMEBUFFER               = 0x8CA8,
        GL_DRAW_FRAMEBUFFER               = 0x8CA9,
        GL_READ_FRAMEBUFFER_BINDING       = 0x8CAA,
        GL_RENDERBUFFER_SAMPLES           = 0x8CAB,
        GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0,
        GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1,
        GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2,
        GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3,
        GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4,
        GL_FRAMEBUFFER_COMPLETE           = 0x8CD5,
        GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6,
        GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7,
        GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDB,
        GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDC,
        GL_FRAMEBUFFER_UNSUPPORTED        = 0x8CDD,
        GL_MAX_COLOR_ATTACHMENTS          = 0x8CDF,
        GL_COLOR_ATTACHMENT0              = 0x8CE0,
        GL_COLOR_ATTACHMENT1              = 0x8CE1,
        GL_COLOR_ATTACHMENT2              = 0x8CE2,
        GL_COLOR_ATTACHMENT3              = 0x8CE3,
        GL_COLOR_ATTACHMENT4              = 0x8CE4,
        GL_COLOR_ATTACHMENT5              = 0x8CE5,
        GL_COLOR_ATTACHMENT6              = 0x8CE6,
        GL_COLOR_ATTACHMENT7              = 0x8CE7,
        GL_COLOR_ATTACHMENT8              = 0x8CE8,
        GL_COLOR_ATTACHMENT9              = 0x8CE9,
        GL_COLOR_ATTACHMENT10             = 0x8CEA,
        GL_COLOR_ATTACHMENT11             = 0x8CEB,
        GL_COLOR_ATTACHMENT12             = 0x8CEC,
        GL_COLOR_ATTACHMENT13             = 0x8CED,
        GL_COLOR_ATTACHMENT14             = 0x8CEE,
        GL_COLOR_ATTACHMENT15             = 0x8CEF,
        GL_DEPTH_ATTACHMENT               = 0x8D00,
        GL_STENCIL_ATTACHMENT             = 0x8D20,
        GL_FRAMEBUFFER                    = 0x8D40,
        GL_RENDERBUFFER                   = 0x8D41,
        GL_RENDERBUFFER_WIDTH             = 0x8D42,
        GL_RENDERBUFFER_HEIGHT            = 0x8D43,
        GL_RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44,
        GL_STENCIL_INDEX1                 = 0x8D46,
        GL_STENCIL_INDEX4                 = 0x8D47,
        GL_STENCIL_INDEX8                 = 0x8D48,
        GL_STENCIL_INDEX16                = 0x8D49,
        GL_RENDERBUFFER_RED_SIZE          = 0x8D50,
        GL_RENDERBUFFER_GREEN_SIZE        = 0x8D51,
        GL_RENDERBUFFER_BLUE_SIZE         = 0x8D52,
        GL_RENDERBUFFER_ALPHA_SIZE        = 0x8D53,
        GL_RENDERBUFFER_DEPTH_SIZE        = 0x8D54,
        GL_RENDERBUFFER_STENCIL_SIZE      = 0x8D55,
        GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56,
        GL_MAX_SAMPLES                    = 0x8D57,
    }

    extern(System) @nogc nothrow {
        alias pglIsRenderbuffer = GLboolean function(GLuint);
        alias pglBindRenderbuffer = void function(GLenum, GLuint);
        alias pglDeleteRenderbuffers = void function(GLsizei, const(GLuint)*);
        alias pglGenRenderbuffers = void function(GLsizei, GLuint*);
        alias pglRenderbufferStorage = void function(GLenum, GLenum, GLsizei, GLsizei);
        alias pglGetRenderbufferParameteriv = void function(GLenum, GLenum, GLint*);
        alias pglIsFramebuffer = GLboolean function(GLuint);
        alias pglBindFramebuffer = void function(GLenum, GLuint);
        alias pglDeleteFramebuffers = void function(GLsizei, const(GLuint)*);
        alias pglGenFramebuffers = void function(GLsizei, GLuint*);
        alias pglCheckFramebufferStatus = GLenum function(GLenum);
        alias pglFramebufferTexture1D = void function(GLenum, GLenum, GLenum, GLuint, GLint);
        alias pglFramebufferTexture2D = void function(GLenum, GLenum, GLenum, GLuint, GLint);
        alias pglFramebufferTexture3D = void function(GLenum, GLenum, GLenum, GLuint, GLint, GLint);
        alias pglFramebufferRenderbuffer = void function(GLenum, GLenum, GLenum, GLuint);
        alias pglGetFramebufferAttachmentParameteriv = void function(GLenum, GLenum, GLenum, GLint*);
        alias pglGenerateMipmap = void function(GLenum);
        alias pglBlitFramebuffer = void function(GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLbitfield, GLenum);
        alias pglRenderbufferStorageMultisample = void function(GLenum, GLsizei, GLenum, GLsizei, GLsizei);
        alias pglFramebufferTextureLayer = void function(GLenum, GLenum, GLuint, GLint, GLint);
    }

    __gshared {
        pglIsRenderbuffer glIsRenderbuffer;
        pglBindRenderbuffer glBindRenderbuffer;
        pglDeleteRenderbuffers glDeleteRenderbuffers;
        pglGenRenderbuffers glGenRenderbuffers;
        pglRenderbufferStorage glRenderbufferStorage;
        pglGetRenderbufferParameteriv glGetRenderbufferParameteriv;
        pglIsFramebuffer glIsFramebuffer;
        pglBindFramebuffer glBindFramebuffer;
        pglDeleteFramebuffers glDeleteFramebuffers;
        pglGenFramebuffers glGenFramebuffers;
        pglCheckFramebufferStatus glCheckFramebufferStatus;
        pglFramebufferTexture1D glFramebufferTexture1D;
        pglFramebufferTexture2D glFramebufferTexture2D;
        pglFramebufferTexture3D glFramebufferTexture3D;
        pglFramebufferRenderbuffer glFramebufferRenderbuffer;
        pglGetFramebufferAttachmentParameteriv glGetFramebufferAttachmentParameteriv;
        pglGenerateMipmap glGenerateMipmap;
        pglBlitFramebuffer glBlitFramebuffer;
        pglRenderbufferStorageMultisample glRenderbufferStorageMultisample;
        pglFramebufferTextureLayer glFramebufferTextureLayer;
    }

    private @nogc nothrow
    bool loadARBFramebufferObject(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glIsRenderbuffer, "glIsRenderbuffer");
        lib.bindGLSymbol(cast(void**)&glBindRenderbuffer, "glBindRenderbuffer");
        lib.bindGLSymbol(cast(void**)&glDeleteRenderbuffers, "glDeleteRenderbuffers");
        lib.bindGLSymbol(cast(void**)&glGenRenderbuffers, "glGenRenderbuffers");
        lib.bindGLSymbol(cast(void**)&glRenderbufferStorage, "glRenderbufferStorage");
        lib.bindGLSymbol(cast(void**)&glGetRenderbufferParameteriv, "glGetRenderbufferParameteriv");
        lib.bindGLSymbol(cast(void**)&glIsFramebuffer, "glIsFramebuffer");
        lib.bindGLSymbol(cast(void**)&glBindFramebuffer, "glBindFramebuffer");
        lib.bindGLSymbol(cast(void**)&glDeleteFramebuffers, "glDeleteFramebuffers");
        lib.bindGLSymbol(cast(void**)&glGenFramebuffers, "glGenFramebuffers");
        lib.bindGLSymbol(cast(void**)&glCheckFramebufferStatus, "glCheckFramebufferStatus");
        lib.bindGLSymbol(cast(void**)&glFramebufferTexture1D, "glFramebufferTexture1D");
        lib.bindGLSymbol(cast(void**)&glFramebufferTexture2D, "glFramebufferTexture2D");
        lib.bindGLSymbol(cast(void**)&glFramebufferTexture3D, "glFramebufferTexture3D");
        lib.bindGLSymbol(cast(void**)&glFramebufferRenderbuffer, "glFramebufferRenderbuffer");
        lib.bindGLSymbol(cast(void**)&glGetFramebufferAttachmentParameteriv, "glGetFramebufferAttachmentParameteriv");
        lib.bindGLSymbol(cast(void**)&glGenerateMipmap, "glGenerateMipmap");
        lib.bindGLSymbol(cast(void**)&glBlitFramebuffer, "glBlitFramebuffer");
        lib.bindGLSymbol(cast(void**)&glRenderbufferStorageMultisample, "glRenderbufferStorageMultisample");
        lib.bindGLSymbol(cast(void**)&glFramebufferTextureLayer, "glFramebufferTextureLayer");
        return resetErrorCountGL();
    }
}
else enum hasARBFramebufferObject = false;

// ARB_map_buffer_range
version(GL_ARB) enum useARBMapBufferRange = true;
else version(GL_ARB_map_buffer_range) enum useARBMapBufferRange = true;
else enum useARBMapBufferRange = has30;

static if(useARBMapBufferRange) {
    private bool _hasARBMapBufferRange;
    bool hasARBMapBufferRange() { return _hasARBMapBufferRange; }

    enum : uint {
        GL_MAP_READ_BIT                   = 0x0001,
        GL_MAP_WRITE_BIT                  = 0x0002,
        GL_MAP_INVALIDATE_RANGE_BIT       = 0x0004,
        GL_MAP_INVALIDATE_BUFFER_BIT      = 0x0008,
        GL_MAP_FLUSH_EXPLICIT_BIT         = 0x0010,
        GL_MAP_UNSYNCHRONIZED_BIT         = 0x0020,
    }

    extern(System) @nogc nothrow {
        alias pglMapBufferRange = GLvoid* function(GLenum, GLintptr, GLsizeiptr, GLbitfield);
        alias pglFlushMappedBufferRange = void function(GLenum, GLintptr, GLsizeiptr);
    }

    __gshared {
        pglMapBufferRange glMapBufferRange;
        pglFlushMappedBufferRange glFlushMappedBufferRange;
    }

    private @nogc nothrow
    bool loadARBMapBufferRange(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glMapBufferRange, "glMapBufferRange");
        lib.bindGLSymbol(cast(void**)&glFlushMappedBufferRange, "glFlushMappedBufferRange");
        return resetErrorCountGL();
    }
}
else enum hasARBMapBufferRange = false;

// ARB_vertex_array_object
version(GL_ARB) enum useARBVertexArrayObject = true;
else version(GL_ARB_vertex_array_object) enum useARBVertexArrayObject = true;
else enum useARBVertexArrayObject = has30;

static if(useARBVertexArrayObject) {
    private bool _hasARBVertexArrayObject;
    bool hasARBVertexArrayObject() { return _hasARBVertexArrayObject; }

    extern(System) @nogc nothrow {
        alias pglBindVertexArray = void function(GLuint);
        alias pglDeleteVertexArrays = void function(GLsizei, const(GLuint)*);
        alias pglGenVertexArrays = void function(GLsizei, GLuint*);
        alias pglIsVertexArray = GLboolean function(GLuint);
    }

    __gshared {
        pglBindVertexArray glBindVertexArray;
        pglDeleteVertexArrays glDeleteVertexArrays;
        pglGenVertexArrays glGenVertexArrays;
        pglIsVertexArray glIsVertexArray;
    }

    private @nogc nothrow
    bool loadARBVertexArrayObject(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glBindVertexArray, "glBindVertexArray");
        lib.bindGLSymbol(cast(void**)&glDeleteVertexArrays, "glDeleteVertexArrays");
        lib.bindGLSymbol(cast(void**)&glGenVertexArrays, "glGenVertexArrays");
        lib.bindGLSymbol(cast(void**)&glIsVertexArray, "glIsVertexArray");
        return resetErrorCountGL();
    }
}
else enum hasARBVertexArrayObject = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB30(SharedLib lib, GLSupport contextVersion)
{
    static if(has30) {
        if(contextVersion >= GLSupport.gl30) {
            _hasARBDepthBufferFloat = true;
            _hasARBHalfFloatVertex = true;
            _hasARBTextureCompressionRGTC = true;
            _hasARBTextureRG = true;

            bool ret = true;
            ret = _hasARBFramebufferObject = lib.loadARBFramebufferObject(contextVersion);
            ret = _hasARBMapBufferRange = lib.loadARBMapBufferRange(contextVersion);
            ret = _hasARBVertexArrayObject = lib.loadARBVertexArrayObject(contextVersion);
            return ret;
        }
    }

    static if(useARBDepthBufferFloat) _hasARBDepthBufferFloat =
            hasExtension(contextVersion, "GL_ARB_depth_buffer_float");

    static if(useARBHalfFloatVertex) _hasARBHalfFloatVertex =
            hasExtension(contextVersion, "GL_ARB_half_float_vertex");

    static if(useARBTextureCompressionRGTC) _hasARBTextureCompressionRGTC =
            hasExtension(contextVersion, "GL_ARB_texture_compression_rgtc");

    static if(useARBTextureRG) _hasARBTextureRG=
            hasExtension(contextVersion, "GL_ARB_texture_rg");

    static if(useARBFramebufferObject) _hasARBFramebufferObject =
            hasExtension(contextVersion, "GL_ARB_framebuffer_object") &&
            lib.loadARBFramebufferObject(contextVersion);

    static if(useARBMapBufferRange) _hasARBMapBufferRange =
            hasExtension(contextVersion, "GL_ARB_map_buffer_range") &&
            lib.loadARBMapBufferRange(contextVersion);

    static if(useARBVertexArrayObject) _hasARBVertexArrayObject =
            hasExtension(contextVersion, "GL_ARB_vertex_array_object") &&
            lib.loadARBVertexArrayObject(contextVersion);

    return true;
}