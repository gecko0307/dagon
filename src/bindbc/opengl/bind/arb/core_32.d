
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_32;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl32) {
    enum has32 = true;
}
else enum has32 = false;

// ARB_depth_clamp
version(GL_ARB) enum useARBDepthClamp = true;
else version(GL_ARB_depth_clamp) enum useARBDepthClamp = true;
else enum useARBDepthClamp = has32;

static if(useARBDepthClamp) {
    private bool _hasARBDepthClamp;
    bool hasARBDepthClamp() { return _hasARBDepthClamp; }

    enum uint GL_DEPTH_CLAMP = 0x864F;
}
else enum hasARBDepthClamp = false;

// ARB_provoking_vertex
version(GL_ARB) enum useARBProvokingVertex = true;
else version(GL_ARB_provoking_vertex) enum useARBProvokingVertex = true;
else enum useARBProvokingVertex = has32;

static if(useARBProvokingVertex) {
    private bool _hasARBProvokingVertex;
    bool hasARBProvokingVertex() { return _hasARBProvokingVertex; }

    enum : uint {
        GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4C,
        GL_FIRST_VERTEX_CONVENTION        = 0x8E4D,
        GL_LAST_VERTEX_CONVENTION         = 0x8E4E,
        GL_PROVOKING_VERTEX               = 0x8E4F,
    }
}
else enum hasARBProvokingVertex = false;

// ARB_seamless_cube_map
version(GL_ARB) enum useARBSeamlessCubeMap = true;
else version(GL_ARB_seamless_cube_map) enum useARBSeamlessCubeMap = true;
else enum useARBSeamlessCubeMap = has32;

static if(useARBSeamlessCubeMap) {
    private bool _hasARBSeamlessCubeMap;
    bool hasARBSeamlessCubeMap() { return _hasARBSeamlessCubeMap; }

    enum uint GL_TEXTURE_CUBE_MAP_SEAMLESS = 0x884F;
}
else enum hasARBSeamlessCubeMap = false;

// ARB_draw_elements_base_vertex
version(GL_ARB) enum useARBDrawElementsBaseVertex = true;
else version(GL_ARB_draw_elements_base_vertex) enum useARBDrawElementsBaseVertex = true;
else enum useARBDrawElementsBaseVertex = has32;

static if(useARBDrawElementsBaseVertex) {
    private bool _hasARBDrawElementsBaseVertex;
    bool hasARBDrawElementsBaseVertex() { return _hasARBDrawElementsBaseVertex; }

    extern(System) @nogc nothrow {
        alias pglDrawElementsBaseVertex = void function(GLenum, GLsizei, GLenum, const(GLvoid)*, GLint);
        alias pglDrawRangeElementsBaseVertex = void function(GLenum, GLuint, GLuint, GLsizei, GLenum, const(GLvoid)*, GLint);
        alias pglDrawElementsInstancedBaseVertex = void function(GLenum, GLsizei, GLenum, const(GLvoid)*, GLsizei, GLint);
        alias pglMultiDrawElementsBaseVertex = void function(GLenum, const(GLsizei)*, GLenum, const(GLvoid*)*, GLsizei, const(GLint)*);
    }

    __gshared {
        pglDrawElementsBaseVertex glDrawElementsBaseVertex;
        pglDrawRangeElementsBaseVertex glDrawRangeElementsBaseVertex;
        pglDrawElementsInstancedBaseVertex glDrawElementsInstancedBaseVertex;
        pglMultiDrawElementsBaseVertex glMultiDrawElementsBaseVertex;
    }

    private @nogc nothrow
    bool loadARBDrawElementsBaseVertex(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glDrawElementsBaseVertex, "glDrawElementsBaseVertex");
        lib.bindGLSymbol(cast(void**)&glDrawRangeElementsBaseVertex, "glDrawRangeElementsBaseVertex");
        lib.bindGLSymbol(cast(void**)&glDrawElementsInstancedBaseVertex, "glDrawElementsInstancedBaseVertex");
        lib.bindGLSymbol(cast(void**)&glMultiDrawElementsBaseVertex, "glMultiDrawElementsBaseVertex");
        return resetErrorCountGL();
    }
}
else enum hasARBDrawElementsBaseVertex = false;

// ARB_geometry_shader4
version(GL_ARB) enum useARBGeometryShader4 = true;
else version(GL_ARB_geometry_shader4) enum useARBGeometryShader4 = true;
else enum useARBGeometryShader4 = has32;

static if(useARBGeometryShader4) {
    private bool _hasARBGeometryShader4;
    bool hasARBGeometryShader4() { return _hasARBGeometryShader4; }

    enum : uint {
        GL_LINES_ADJACENCY_ARB            = 0x000A,
        GL_LINE_STRIP_ADJACENCY_ARB       = 0x000B,
        GL_TRIANGLES_ADJACENCY_ARB        = 0x000C,
        GL_TRIANGLE_STRIP_ADJACENCY_ARB   = 0x000D,
        GL_PROGRAM_POINT_SIZE_ARB         = 0x8642,
        GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_ARB = 0x8C29,
        GL_FRAMEBUFFER_ATTACHMENT_LAYERED_ARB = 0x8DA7,
        GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_ARB = 0x8DA8,
        GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_ARB = 0x8DA9,
        GL_GEOMETRY_SHADER_ARB            = 0x8DD9,
        GL_GEOMETRY_VERTICES_OUT_ARB      = 0x8DDA,
        GL_GEOMETRY_INPUT_TYPE_ARB        = 0x8DDB,
        GL_GEOMETRY_OUTPUT_TYPE_ARB       = 0x8DDC,
        GL_MAX_GEOMETRY_VARYING_COMPONENTS_ARB = 0x8DDD,
        GL_MAX_VERTEX_VARYING_COMPONENTS_ARB = 0x8DDE,
        GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_ARB = 0x8DDF,
        GL_MAX_GEOMETRY_OUTPUT_VERTICES_ARB = 0x8DE0,
        GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_ARB = 0x8DE1,
    }

    extern(System) @nogc nothrow {
        alias pglProgramParameteriARB = void function(GLuint,GLenum,GLint);
        alias pglFramebufferTextureARB = void function(GLuint,GLenum,GLuint,GLint);
        alias pglFramebufferTextureLayerARB = void function(GLuint,GLenum,GLuint,GLint,GLint);
        alias pglFramebufferTextureFaceARB = void function(GLuint,GLenum,GLuint,GLint,GLenum);
    }

    __gshared {
        pglProgramParameteriARB glProgramParameteriARB;
        pglFramebufferTextureARB glFramebufferTextureARB;
        pglFramebufferTextureLayerARB glFramebufferTextureLayerARB;
        pglFramebufferTextureFaceARB glFramebufferTextureFaceARB;
    }

    private @nogc nothrow
    bool loadARBGeometryShader4(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glProgramParameteriARB,"glProgramParameteriARB");
        lib.bindGLSymbol(cast(void**)&glFramebufferTextureARB,"glFramebufferTextureARB");
        lib.bindGLSymbol(cast(void**)&glFramebufferTextureLayerARB,"glFramebufferTextureLayerARB");
        lib.bindGLSymbol(cast(void**)&glFramebufferTextureFaceARB,"glFramebufferTextureFaceARB");
        return resetErrorCountGL();
    }
}
else enum hasARBGeometryShader4 = false;

// ARB_sync
version(GL_ARB) enum useARBSync = true;
else version(GL_ARB_sync) enum useARBSync = true;
else enum useARBSync = has32;

alias GLint64 = long;
alias GLuint64 = ulong;
struct __GLsync;
alias __GLsync* GLsync;

static if(useARBSync) {
    private bool _hasARBSync;
    bool hasARBSync() { return _hasARBSync; }

    enum : uint {
        GL_MAX_SERVER_WAIT_TIMEOUT        = 0x9111,
        GL_OBJECT_TYPE                    = 0x9112,
        GL_SYNC_CONDITION                 = 0x9113,
        GL_SYNC_STATUS                    = 0x9114,
        GL_SYNC_FLAGS                     = 0x9115,
        GL_SYNC_FENCE                     = 0x9116,
        GL_SYNC_GPU_COMMANDS_COMPLETE     = 0x9117,
        GL_UNSIGNALED                     = 0x9118,
        GL_SIGNALED                       = 0x9119,
        GL_ALREADY_SIGNALED               = 0x911A,
        GL_TIMEOUT_EXPIRED                = 0x911B,
        GL_CONDITION_SATISFIED            = 0x911C,
        GL_WAIT_FAILED                    = 0x911D,
        GL_SYNC_FLUSH_COMMANDS_BIT        = 0x00000001,
    }

    extern(System) @nogc nothrow {
        alias pglFenceSync = GLsync function(GLenum, GLbitfield);
        alias pglIsSync = GLboolean function(GLsync);
        alias pglDeleteSync = void function(GLsync);
        alias pglClientWaitSync = GLenum function(GLsync, GLbitfield, GLuint64);
        alias pglWaitSync = void function(GLsync, GLbitfield, GLuint64);
        alias pglGetInteger64v = void function(GLsync, GLint64*);
        alias pglGetSynciv = void function(GLsync, GLenum, GLsizei, GLsizei*, GLint*);
    }

    __gshared {
        pglFenceSync glFenceSync;
        pglIsSync glIsSync;
        pglDeleteSync glDeleteSync;
        pglClientWaitSync glClientWaitSync;
        pglWaitSync glWaitSync;
        pglGetInteger64v glGetInteger64v;
        pglGetSynciv glGetSynciv;
    }

    private @nogc nothrow
    bool loadARBSync(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glFenceSync, "glFenceSync");
        lib.bindGLSymbol(cast(void**)&glIsSync, "glIsSync");
        lib.bindGLSymbol(cast(void**)&glDeleteSync, "glDeleteSync");
        lib.bindGLSymbol(cast(void**)&glClientWaitSync, "glClientWaitSync");
        lib.bindGLSymbol(cast(void**)&glWaitSync, "glWaitSync");
        lib.bindGLSymbol(cast(void**)&glGetInteger64v, "glGetInteger64v");
        lib.bindGLSymbol(cast(void**)&glGetSynciv, "glGetSynciv");
        return resetErrorCountGL();
    }
}
else enum hasARBSync = false;

// ARB_texture_multisample
version(GL_ARB) enum useARBTextureMultiSample = true;
else version(GL_ARB_texture_multisample) enum useARBTextureMultiSample = true;
else enum useARBTextureMultiSample = has32;

static if(useARBTextureMultiSample) {
    private bool _hasARBTextureMultiSample;
    bool hasARBTextureMultiSample() { return _hasARBTextureMultiSample; }

    enum : uint {
        GL_SAMPLE_POSITION                = 0x8E50,
        GL_SAMPLE_MASK                    = 0x8E51,
        GL_SAMPLE_MASK_VALUE              = 0x8E52,
        GL_MAX_SAMPLE_MASK_WORDS          = 0x8E59,
        GL_TEXTURE_2D_MULTISAMPLE         = 0x9100,
        GL_PROXY_TEXTURE_2D_MULTISAMPLE   = 0x9101,
        GL_TEXTURE_2D_MULTISAMPLE_ARRAY   = 0x9102,
        GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103,
        GL_TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104,
        GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105,
        GL_TEXTURE_SAMPLES                = 0x9106,
        GL_TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107,
        GL_SAMPLER_2D_MULTISAMPLE         = 0x9108,
        GL_INT_SAMPLER_2D_MULTISAMPLE     = 0x9109,
        GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910A,
        GL_SAMPLER_2D_MULTISAMPLE_ARRAY   = 0x910B,
        GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910C,
        GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D,
        GL_MAX_COLOR_TEXTURE_SAMPLES      = 0x910E,
        GL_MAX_DEPTH_TEXTURE_SAMPLES      = 0x910F,
        GL_MAX_INTEGER_SAMPLES            = 0x9110,
    }

    extern(System) @nogc nothrow {
        alias pglTexImage2DMultisample = void function(GLenum, GLsizei, GLint, GLsizei, GLsizei, GLboolean);
        alias pglTexImage3DMultisample = void function(GLenum, GLsizei, GLint, GLsizei, GLsizei, GLsizei, GLboolean);
        alias pglGetMultisamplefv = void function(GLenum, GLuint, GLfloat*);
        alias pglSampleMaski = void function(GLuint, GLbitfield);
    }

    __gshared {
        pglTexImage2DMultisample glTexImage2DMultisample;
        pglTexImage3DMultisample glTexImage3DMultisample;
        pglGetMultisamplefv glGetMultisamplefv;
        pglSampleMaski glSampleMaski;
    }

    private @nogc nothrow
    bool loadTextureMultiSample(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glTexImage2DMultisample, "glTexImage2DMultisample");
        lib.bindGLSymbol(cast(void**)&glTexImage3DMultisample, "glTexImage3DMultisample");
        lib.bindGLSymbol(cast(void**)&glGetMultisamplefv, "glGetMultisamplefv");
        lib.bindGLSymbol(cast(void**)&glSampleMaski, "glSampleMaski");
        return resetErrorCountGL();
    }
}
else enum hasARBTextureMultiSample = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB32(SharedLib lib, GLSupport contextVersion)
{
    static if(has32) {
        if(contextVersion >= GLSupport.gl32) {
            _hasARBDepthClamp = true;
            _hasARBProvokingVertex = true;
            _hasARBSeamlessCubeMap = true;

            bool ret = true;
            ret = _hasARBDrawElementsBaseVertex = lib.loadARBDrawElementsBaseVertex(contextVersion);
            ret = _hasARBGeometryShader4 = lib.loadARBGeometryShader4(contextVersion);
            ret = _hasARBSync = lib.loadARBSync(contextVersion);
            ret = _hasARBTextureMultiSample = lib.loadTextureMultiSample(contextVersion);
            return ret;
        }
    }

    static if(useARBDepthClamp) _hasARBDepthClamp =
            hasExtension(contextVersion, "GL_ARB_depth_clamp");

    static if(useARBProvokingVertex) _hasARBProvokingVertex =
            hasExtension(contextVersion, "GL_ARB_provoking_vertex");

    static if(useARBSeamlessCubeMap) _hasARBSeamlessCubeMap =
            hasExtension(contextVersion, "GL_ARB_seamless_cube_map");

    static if(useARBDrawElementsBaseVertex) _hasARBDrawElementsBaseVertex =
            hasExtension(contextVersion, "GL_ARB_draw_elements_base_vertex") &&
            lib.loadARBDrawElementsBaseVertex(contextVersion);

    static if(useARBGeometryShader4) _hasARBGeometryShader4 =
            hasExtension(contextVersion, "GL_ARB_geometry_shader4") &&
            lib.loadARBGeometryShader4(contextVersion);

    static if(useARBSync) _hasARBSync =
            hasExtension(contextVersion, "GL_ARB_sync") &&
            lib.loadARBSync(contextVersion);

    static if(useARBTextureMultiSample) _hasARBTextureMultiSample =
            hasExtension(contextVersion, "GL_ARB_texture_multisample") &&
            lib.loadTextureMultiSample(contextVersion);

    return true;
}