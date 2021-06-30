
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl30;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl30) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;
    import bindbc.opengl.bind.types;

    version(GL_AllowDeprecated)
        public import bindbc.opengl.bind.dep.dep30;

    enum : uint {
        GL_COMPARE_REF_TO_TEXTURE         = 0x884E,
        GL_CLIP_DISTANCE0                 = 0x3000,
        GL_CLIP_DISTANCE1                 = 0x3001,
        GL_CLIP_DISTANCE2                 = 0x3002,
        GL_CLIP_DISTANCE3                 = 0x3003,
        GL_CLIP_DISTANCE4                 = 0x3004,
        GL_CLIP_DISTANCE5                 = 0x3005,
        GL_CLIP_DISTANCE6                 = 0x3006,
        GL_CLIP_DISTANCE7                 = 0x3007,
        GL_MAX_CLIP_DISTANCES             = 0x0D32,
        GL_MAJOR_VERSION                  = 0x821B,
        GL_MINOR_VERSION                  = 0x821C,
        GL_NUM_EXTENSIONS                 = 0x821D,
        GL_CONTEXT_FLAGS                  = 0x821E,
        GL_COMPRESSED_RED                 = 0x8225,
        GL_COMPRESSED_RG                  = 0x8226,
        GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x0001,
        GL_RGBA32F                        = 0x8814,
        GL_RGB32F                         = 0x8815,
        GL_RGBA16F                        = 0x881A,
        GL_RGB16F                         = 0x881B,
        GL_VERTEX_ATTRIB_ARRAY_INTEGER    = 0x88FD,
        GL_MAX_ARRAY_TEXTURE_LAYERS       = 0x88FF,
        GL_MIN_PROGRAM_TEXEL_OFFSET       = 0x8904,
        GL_MAX_PROGRAM_TEXEL_OFFSET       = 0x8905,
        GL_CLAMP_READ_COLOR               = 0x891C,
        GL_FIXED_ONLY                     = 0x891D,
        GL_MAX_VARYING_COMPONENTS         = 0x8B4B,
        GL_TEXTURE_1D_ARRAY               = 0x8C18,
        GL_PROXY_TEXTURE_1D_ARRAY         = 0x8C19,
        GL_TEXTURE_2D_ARRAY               = 0x8C1A,
        GL_PROXY_TEXTURE_2D_ARRAY         = 0x8C1B,
        GL_TEXTURE_BINDING_1D_ARRAY       = 0x8C1C,
        GL_TEXTURE_BINDING_2D_ARRAY       = 0x8C1D,
        GL_R11F_G11F_B10F                 = 0x8C3A,
        GL_UNSIGNED_INT_10F_11F_11F_REV   = 0x8C3B,
        GL_RGB9_E5                        = 0x8C3D,
        GL_UNSIGNED_INT_5_9_9_9_REV       = 0x8C3E,
        GL_TEXTURE_SHARED_SIZE            = 0x8C3F,
        GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76,
        GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F,
        GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80,
        GL_TRANSFORM_FEEDBACK_VARYINGS    = 0x8C83,
        GL_TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84,
        GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85,
        GL_PRIMITIVES_GENERATED           = 0x8C87,
        GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88,
        GL_RASTERIZER_DISCARD             = 0x8C89,
        GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A,
        GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B,
        GL_INTERLEAVED_ATTRIBS            = 0x8C8C,
        GL_SEPARATE_ATTRIBS               = 0x8C8D,
        GL_TRANSFORM_FEEDBACK_BUFFER      = 0x8C8E,
        GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F,
        GL_RGBA32UI                       = 0x8D70,
        GL_RGB32UI                        = 0x8D71,
        GL_RGBA16UI                       = 0x8D76,
        GL_RGB16UI                        = 0x8D77,
        GL_RGBA8UI                        = 0x8D7C,
        GL_RGB8UI                         = 0x8D7D,
        GL_RGBA32I                        = 0x8D82,
        GL_RGB32I                         = 0x8D83,
        GL_RGBA16I                        = 0x8D88,
        GL_RGB16I                         = 0x8D89,
        GL_RGBA8I                         = 0x8D8E,
        GL_RGB8I                          = 0x8D8F,
        GL_RED_INTEGER                    = 0x8D94,
        GL_GREEN_INTEGER                  = 0x8D95,
        GL_BLUE_INTEGER                   = 0x8D96,
        GL_RGB_INTEGER                    = 0x8D98,
        GL_RGBA_INTEGER                   = 0x8D99,
        GL_BGR_INTEGER                    = 0x8D9A,
        GL_BGRA_INTEGER                   = 0x8D9B,
        GL_SAMPLER_1D_ARRAY               = 0x8DC0,
        GL_SAMPLER_2D_ARRAY               = 0x8DC1,
        GL_SAMPLER_1D_ARRAY_SHADOW        = 0x8DC3,
        GL_SAMPLER_2D_ARRAY_SHADOW        = 0x8DC4,
        GL_SAMPLER_CUBE_SHADOW            = 0x8DC5,
        GL_UNSIGNED_INT_VEC2              = 0x8DC6,
        GL_UNSIGNED_INT_VEC3              = 0x8DC7,
        GL_UNSIGNED_INT_VEC4              = 0x8DC8,
        GL_INT_SAMPLER_1D                 = 0x8DC9,
        GL_INT_SAMPLER_2D                 = 0x8DCA,
        GL_INT_SAMPLER_3D                 = 0x8DCB,
        GL_INT_SAMPLER_CUBE               = 0x8DCC,
        GL_INT_SAMPLER_1D_ARRAY           = 0x8DCE,
        GL_INT_SAMPLER_2D_ARRAY           = 0x8DCF,
        GL_UNSIGNED_INT_SAMPLER_1D        = 0x8DD1,
        GL_UNSIGNED_INT_SAMPLER_2D        = 0x8DD2,
        GL_UNSIGNED_INT_SAMPLER_3D        = 0x8DD3,
        GL_UNSIGNED_INT_SAMPLER_CUBE      = 0x8DD4,
        GL_UNSIGNED_INT_SAMPLER_1D_ARRAY  = 0x8DD6,
        GL_UNSIGNED_INT_SAMPLER_2D_ARRAY  = 0x8DD7,
        GL_QUERY_WAIT                     = 0x8E13,
        GL_QUERY_NO_WAIT                  = 0x8E14,
        GL_QUERY_BY_REGION_WAIT           = 0x8E15,
        GL_QUERY_BY_REGION_NO_WAIT        = 0x8E16,
        GL_BUFFER_ACCESS_FLAGS            = 0x911F,
        GL_BUFFER_MAP_LENGTH              = 0x9120,
        GL_BUFFER_MAP_OFFSET              = 0x9121,
    }

    extern(System) @nogc nothrow {
        alias pglColorMaski = void function(GLuint,GLboolean,GLboolean,GLboolean,GLboolean);
        alias pglGetBooleani_v = void function(GLenum,GLuint,GLboolean*);
        alias pglGetIntegeri_v = void function(GLenum,GLuint,GLint*);
        alias pglEnablei = void function(GLenum,GLuint);
        alias pglDisablei = void function(GLenum,GLuint);
        alias pglIsEnabledi = GLboolean function(GLenum,GLuint);
        alias pglBeginTransformFeedback = void function(GLenum);
        alias pglEndTransformFeedback = void function();
        alias pglBindBufferRange = void function(GLenum,GLuint,GLuint,GLintptr,GLsizeiptr);
        alias pglBindBufferBase = void function(GLenum,GLuint,GLuint);
        alias pglTransformFeedbackVaryings = void function(GLuint,GLsizei,const(GLchar*)*,GLenum);
        alias pglGetTransformFeedbackVarying = void function(GLuint,GLuint,GLsizei,GLsizei*,GLsizei*,GLenum*,GLchar*);
        alias pglClampColor = void function(GLenum,GLenum);
        alias pglBeginConditionalRender = void function(GLuint,GLenum);
        alias pglEndConditionalRender = void function();
        alias pglVertexAttribIPointer = void function(GLuint,GLint,GLenum,GLsizei,const(GLvoid)*);
        alias pglGetVertexAttribIiv = void function(GLuint,GLenum,GLint*);
        alias pglGetVertexAttribIuiv = void function(GLuint,GLenum,GLuint*);
        alias pglVertexAttribI1i = void function(GLuint,GLint);
        alias pglVertexAttribI2i = void function(GLuint,GLint,GLint);
        alias pglVertexAttribI3i = void function(GLuint,GLint,GLint,GLint);
        alias pglVertexAttribI4i = void function(GLuint,GLint,GLint,GLint,GLint);
        alias pglVertexAttribI1ui = void function(GLuint,GLuint);
        alias pglVertexAttribI2ui = void function(GLuint,GLuint,GLuint);
        alias pglVertexAttribI3ui = void function(GLuint,GLuint,GLuint,GLuint);
        alias pglVertexAttribI4ui = void function(GLuint,GLuint,GLuint,GLuint,GLuint);
        alias pglVertexAttribI1iv = void function(GLuint,const(GLint)*);
        alias pglVertexAttribI2iv = void function(GLuint,const(GLint)*);
        alias pglVertexAttribI3iv = void function(GLuint,const(GLint)*);
        alias pglVertexAttribI4iv = void function(GLuint,const(GLint)*);
        alias pglVertexAttribI1uiv = void function(GLuint,const(GLuint)*);
        alias pglVertexAttribI2uiv = void function(GLuint,const(GLuint)*);
        alias pglVertexAttribI3uiv = void function(GLuint,const(GLuint)*);
        alias pglVertexAttribI4uiv = void function(GLuint,const(GLuint)*);
        alias pglVertexAttribI4bv = void function(GLuint,const(GLbyte)*);
        alias pglVertexAttribI4sv = void function(GLuint,const(GLshort)*);
        alias pglVertexAttribI4ubv = void function(GLuint,const(GLubyte)*);
        alias pglVertexAttribI4usv = void function(GLuint,const(GLushort)*);
        alias pglGetUniformuiv = void function(GLuint,GLint,GLuint*);
        alias pglBindFragDataLocation = void function(GLuint,GLuint,const(GLchar)*);
        alias pglGetFragDataLocation = GLint function(GLuint,const(GLchar)*);
        alias pglUniform1ui = void function(GLint,GLuint);
        alias pglUniform2ui = void function(GLint,GLuint,GLuint);
        alias pglUniform3ui = void function(GLint,GLuint,GLuint,GLuint);
        alias pglUniform4ui = void function(GLint,GLuint,GLuint,GLuint,GLuint);
        alias pglUniform1uiv = void function(GLint,GLsizei,const(GLuint)*);
        alias pglUniform2uiv = void function(GLint,GLsizei,const(GLuint)*);
        alias pglUniform3uiv = void function(GLint,GLsizei,const(GLuint)*);
        alias pglUniform4uiv = void function(GLint,GLsizei,const(GLuint)*);
        alias pglTexParameterIiv = void function(GLenum,GLenum,const(GLint)*);
        alias pglTexParameterIuiv = void function(GLenum,GLenum,const(GLuint)*);
        alias pglGetTexParameterIiv = void function(GLenum,GLenum,GLint*);
        alias pglGetTexParameterIuiv = void function(GLenum,GLenum,GLuint*);
        alias pglClearBufferiv = void function(GLenum,GLint,const(GLint)*);
        alias pglClearBufferuiv = void function(GLenum,GLint,const(GLuint)*);
        alias pglClearBufferfv = void function(GLenum,GLint,const(GLfloat)*);
        alias pglClearBufferfi = void function(GLenum,GLint,GLfloat,GLint);
        alias pglGetStringi = const(char)* function(GLenum,GLuint);
    }

    __gshared {
        pglColorMaski glColorMaski;
        pglGetBooleani_v glGetBooleani_v;
        pglGetIntegeri_v glGetIntegeri_v;
        pglEnablei glEnablei;
        pglDisablei glDisablei;
        pglIsEnabledi glIsEnabledi;
        pglBeginTransformFeedback glBeginTransformFeedback;
        pglEndTransformFeedback glEndTransformFeedback;
        pglBindBufferRange glBindBufferRange;
        pglBindBufferBase glBindBufferBase;
        pglTransformFeedbackVaryings glTransformFeedbackVaryings;
        pglGetTransformFeedbackVarying glGetTransformFeedbackVarying;
        pglClampColor glClampColor;
        pglBeginConditionalRender glBeginConditionalRender;
        pglEndConditionalRender glEndConditionalRender;
        pglVertexAttribIPointer glVertexAttribIPointer;
        pglGetVertexAttribIiv glGetVertexAttribIiv;
        pglGetVertexAttribIuiv glGetVertexAttribIuiv;
        pglVertexAttribI1i glVertexAttribI1i;
        pglVertexAttribI2i glVertexAttribI2i;
        pglVertexAttribI3i glVertexAttribI3i;
        pglVertexAttribI4i glVertexAttribI4i;
        pglVertexAttribI1ui glVertexAttribI1ui;
        pglVertexAttribI2ui glVertexAttribI2ui;
        pglVertexAttribI3ui glVertexAttribI3ui;
        pglVertexAttribI4ui glVertexAttribI4ui;
        pglVertexAttribI1iv glVertexAttribI1iv;
        pglVertexAttribI2iv glVertexAttribI2iv;
        pglVertexAttribI3iv glVertexAttribI3iv;
        pglVertexAttribI4iv glVertexAttribI4iv;
        pglVertexAttribI1uiv glVertexAttribI1uiv;
        pglVertexAttribI2uiv glVertexAttribI2uiv;
        pglVertexAttribI3uiv glVertexAttribI3uiv;
        pglVertexAttribI4uiv glVertexAttribI4uiv;
        pglVertexAttribI4bv glVertexAttribI4bv;
        pglVertexAttribI4sv glVertexAttribI4sv;
        pglVertexAttribI4ubv glVertexAttribI4ubv;
        pglVertexAttribI4usv glVertexAttribI4usv;
        pglGetUniformuiv glGetUniformuiv;
        pglBindFragDataLocation glBindFragDataLocation;
        pglGetFragDataLocation glGetFragDataLocation;
        pglUniform1ui glUniform1ui;
        pglUniform2ui glUniform2ui;
        pglUniform3ui glUniform3ui;
        pglUniform4ui glUniform4ui;
        pglUniform1uiv glUniform1uiv;
        pglUniform2uiv glUniform2uiv;
        pglUniform3uiv glUniform3uiv;
        pglUniform4uiv glUniform4uiv;
        pglTexParameterIiv glTexParameterIiv;
        pglTexParameterIuiv glTexParameterIuiv;
        pglGetTexParameterIiv glGetTexParameterIiv;
        pglGetTexParameterIuiv glGetTexParameterIuiv;
        pglClearBufferiv glClearBufferiv;
        pglClearBufferuiv glClearBufferuiv;
        pglClearBufferfv glClearBufferfv;
        pglClearBufferfi glClearBufferfi;
        pglGetStringi glGetStringi;
    }

    package(bindbc.opengl) @nogc nothrow
    bool loadGL30(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB30;

        if(contextVersion >= GLSupport.gl30) {
            lib.bindGLSymbol(cast(void**)&glColorMaski, "glColorMaski");
            lib.bindGLSymbol(cast(void**)&glGetBooleani_v, "glGetBooleani_v");
            lib.bindGLSymbol(cast(void**)&glGetIntegeri_v, "glGetIntegeri_v");
            lib.bindGLSymbol(cast(void**)&glEnablei, "glEnablei");
            lib.bindGLSymbol(cast(void**)&glDisablei, "glDisablei");
            lib.bindGLSymbol(cast(void**)&glIsEnabledi, "glIsEnabledi");
            lib.bindGLSymbol(cast(void**)&glBeginTransformFeedback, "glBeginTransformFeedback");
            lib.bindGLSymbol(cast(void**)&glEndTransformFeedback, "glEndTransformFeedback");
            lib.bindGLSymbol(cast(void**)&glBindBufferRange, "glBindBufferRange");
            lib.bindGLSymbol(cast(void**)&glBindBufferBase, "glBindBufferBase");
            lib.bindGLSymbol(cast(void**)&glTransformFeedbackVaryings, "glTransformFeedbackVaryings");
            lib.bindGLSymbol(cast(void**)&glGetTransformFeedbackVarying, "glGetTransformFeedbackVarying");
            lib.bindGLSymbol(cast(void**)&glClampColor, "glClampColor");
            lib.bindGLSymbol(cast(void**)&glBeginConditionalRender, "glBeginConditionalRender");
            lib.bindGLSymbol(cast(void**)&glEndConditionalRender, "glEndConditionalRender");
            lib.bindGLSymbol(cast(void**)&glVertexAttribIPointer, "glVertexAttribIPointer");
            lib.bindGLSymbol(cast(void**)&glGetVertexAttribIiv, "glGetVertexAttribIiv");
            lib.bindGLSymbol(cast(void**)&glGetVertexAttribIuiv, "glGetVertexAttribIuiv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI1i, "glVertexAttribI1i");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI2i, "glVertexAttribI2i");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI3i, "glVertexAttribI3i");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4i, "glVertexAttribI4i");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI1ui, "glVertexAttribI1ui");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI2ui, "glVertexAttribI2ui");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI3ui, "glVertexAttribI3ui");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4ui, "glVertexAttribI4ui");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI1iv, "glVertexAttribI1iv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI2iv, "glVertexAttribI2iv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI3iv, "glVertexAttribI3iv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4iv, "glVertexAttribI4iv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI1uiv, "glVertexAttribI1uiv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI2uiv, "glVertexAttribI2uiv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI3uiv, "glVertexAttribI3uiv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4uiv, "glVertexAttribI4uiv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4bv, "glVertexAttribI4bv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4sv, "glVertexAttribI4sv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4ubv, "glVertexAttribI4ubv");
            lib.bindGLSymbol(cast(void**)&glVertexAttribI4usv, "glVertexAttribI4usv");
            lib.bindGLSymbol(cast(void**)&glGetUniformuiv, "glGetUniformuiv");
            lib.bindGLSymbol(cast(void**)&glBindFragDataLocation, "glBindFragDataLocation");
            lib.bindGLSymbol(cast(void**)&glGetFragDataLocation, "glGetFragDataLocation");
            lib.bindGLSymbol(cast(void**)&glUniform1ui, "glUniform1ui");
            lib.bindGLSymbol(cast(void**)&glUniform2ui, "glUniform2ui");
            lib.bindGLSymbol(cast(void**)&glUniform3ui, "glUniform3ui");
            lib.bindGLSymbol(cast(void**)&glUniform4ui, "glUniform4ui");
            lib.bindGLSymbol(cast(void**)&glUniform1uiv, "glUniform1uiv");
            lib.bindGLSymbol(cast(void**)&glUniform2uiv, "glUniform2uiv");
            lib.bindGLSymbol(cast(void**)&glUniform3uiv, "glUniform3uiv");
            lib.bindGLSymbol(cast(void**)&glUniform4uiv, "glUniform4uiv");
            lib.bindGLSymbol(cast(void**)&glTexParameterIiv, "glTexParameterIiv");
            lib.bindGLSymbol(cast(void**)&glTexParameterIuiv, "glTexParameterIuiv");
            lib.bindGLSymbol(cast(void**)&glGetTexParameterIiv, "glGetTexParameterIiv");
            lib.bindGLSymbol(cast(void**)&glGetTexParameterIuiv, "glGetTexParameterIuiv");
            lib.bindGLSymbol(cast(void**)&glClearBufferiv, "glClearBufferiv");
            lib.bindGLSymbol(cast(void**)&glClearBufferuiv, "glClearBufferuiv");
            lib.bindGLSymbol(cast(void**)&glClearBufferfv, "glClearBufferfv");
            lib.bindGLSymbol(cast(void**)&glClearBufferfi, "glClearBufferfi");
            lib.bindGLSymbol(cast(void**)&glGetStringi, "glGetStringi");

            if(errorCountGL() == 0 && loadARB30(lib, contextVersion)) return true;
        }
        return false;
    }
}