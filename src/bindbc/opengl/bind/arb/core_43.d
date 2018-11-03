
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_43;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl43) {
    enum has43 = true;
}
else enum has43 = false;

// ARB_clear_buffer_object
version(GL_ARB) enum useARBClearBufferObject = true;
else version(GL_ARB_clear_buffer_object) enum useARBClearBufferObject = true;
else enum useARBClearBufferObject = has43;

static if(useARBClearBufferObject) {
    private bool _hasARBClearBufferObject;
    bool hasARBClearBufferObject() { return _hasARBClearBufferObject; }

    extern(System) @nogc nothrow {
        alias pglClearBufferData = void function(GLenum,GLenum,GLenum,GLenum,const(void)*);
        alias pglClearBufferSubData = void function(GLenum,GLenum,GLintptr,GLsizeiptr,GLenum,GLenum,const(void)*);
        alias pglClearNamedBufferDataEXT = void function(GLuint,GLenum,GLenum,GLenum,const(void)*);
        alias pglClearNamedBufferSubDataEXT = void function(GLuint,GLenum,GLenum,GLenum,GLsizeiptr,GLsizeiptr,const(void)*);
    }

    __gshared {
        pglClearBufferData glClearBufferData;
        pglClearBufferSubData glClearBufferSubData;
        pglClearNamedBufferDataEXT glClearNamedBufferDataEXT;
        pglClearNamedBufferSubDataEXT glClearNamedBufferSubDataEXT;
    }

    private @nogc nothrow
    bool loadARBClearBufferObject(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glClearBufferData, "glClearBufferData");
        lib.bindGLSymbol(cast(void**)&glClearBufferSubData, "glClearBufferSubData");

        // The previous two functions are required when loading GL 4.3,
        // the next two are not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glClearNamedBufferDataEXT, "glClearNamedBufferDataEXT");
            lib.bindGLSymbol(cast(void**)&glClearNamedBufferSubDataEXT, "glClearNamedBufferSubDataEXT");

            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBClearBufferObject = false;

// ARB_compute_shader
version(GL_ARB) enum useARBComputeShader = true;
else version(GL_ARB_compute_shader) enum useARBComputeShader = true;
else enum useARBComputeShader = has43;

static if(useARBComputeShader) {
    private bool _hasARBComputeShader;
    bool hasARBComputeShader() { return _hasARBComputeShader; }

    enum : uint {
        GL_COMPUTE_SHADER                 = 0x91B9,
        GL_MAX_COMPUTE_UNIFORM_BLOCKS     = 0x91BB,
        GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS = 0x91BC,
        GL_MAX_COMPUTE_IMAGE_UNIFORMS     = 0x91BD,
        GL_MAX_COMPUTE_SHARED_MEMORY_SIZE = 0x8262,
        GL_MAX_COMPUTE_UNIFORM_COMPONENTS = 0x8263,
        GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS = 0x8264,
        GL_MAX_COMPUTE_ATOMIC_COUNTERS    = 0x8265,
        GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS = 0x8266,
        GL_MAX_COMPUTE_WORK_GROUP_INVOCATIONS  = 0x90EB,
        GL_MAX_COMPUTE_WORK_GROUP_COUNT   = 0x91BE,
        GL_MAX_COMPUTE_WORK_GROUP_SIZE    = 0x91BF,
        GL_COMPUTE_WORK_GROUP_SIZE        = 0x8267,
        GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER = 0x90EC,
        GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER = 0x90ED,
        GL_DISPATCH_INDIRECT_BUFFER       = 0x90EE,
        GL_DISPATCH_INDIRECT_BUFFER_BINDING = 0x90EF,
        GL_COMPUTE_SHADER_BIT             = 0x00000020,
    }

    extern(System) @nogc nothrow {
        alias pglDispatchCompute = void function(GLuint,GLuint,GLuint);
        alias pglDispatchComputeIndirect = void function(GLintptr);
    }

    __gshared {
        pglDispatchCompute glDispatchCompute;
        pglDispatchComputeIndirect glDispatchComputeIndirect;
    }

    private @nogc nothrow
    bool loadARBComputeShader(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glDispatchCompute, "glDispatchCompute");
        lib.bindGLSymbol(cast(void**)&glDispatchComputeIndirect, "glDispatchComputeIndirect");
        return resetErrorCountGL();
    }
}
else enum hasARBComputeShader = false;

// ARB_copy_image
version(GL_ARB) enum useARBCopyImage = true;
else version(GL_ARB_copy_image) enum useARBCopyImage = true;
else enum useARBCopyImage = 4;

static if(useARBCopyImage) {
    private bool _hasARBCopyImage;
    bool hasARBCopyImage() { return _hasARBCopyImage; }

    extern(System) @nogc nothrow alias pglCopyImageSubData = void function(GLuint,GLenum,GLint,GLint,GLint,GLint,GLuint,GLenum,GLint,GLint,GLint,GLint,GLsizei,GLsizei,GLsizei);
    __gshared pglCopyImageSubData glCopyImageSubData;

    private @nogc nothrow
    bool loadARBCopyImage(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glCopyImageSubData, "glCopyImageSubData");
        return resetErrorCountGL();
    }
}
else enum hasARBCopyImage = false;

// ARB_ES3_compatibility
version(GL_ARB) enum useARBES3Compatibility = true;
else version(GL_ARB_ES3_compatibility) enum useARBES3Compatibility = true;
else enum useARBES3Compatibility = 4;

static if(useARBES3Compatibility) {
    private bool _hasARBES3Compatibility;
    bool hasARBES3Compatibility() { return _hasARBES3Compatibility; }

    enum : uint {
        GL_COMPRESSED_RGB8_ETC2           = 0x9274,
        GL_COMPRESSED_SRGB8_ETC2          = 0x9275,
        GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 0x9276,
        GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 0x9277,
        GL_COMPRESSED_RGBA8_ETC2_EAC      = 0x9278,
        GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC = 0x9279,
        GL_COMPRESSED_R11_EAC             = 0x9270,
        GL_COMPRESSED_SIGNED_R11_EAC      = 0x9271,
        GL_COMPRESSED_RG11_EAC            = 0x9272,
        GL_COMPRESSED_SIGNED_RG11_EAC     = 0x9273,
        GL_PRIMITIVE_RESTART_FIXED_INDEX  = 0x8D69,
        GL_ANY_SAMPLES_PASSED_CONSERVATIVE = 0x8D6A,
        GL_MAX_ELEMENT_INDEX              = 0x8D6B,
    }
}
else enum hasARBES3Compatibility = false;

// ARB_explicit_uniform_location
version(GL_ARB) enum useARBExplicitUniformLocation = true;
else version(GL_ARB_explicit_uniform_location) enum useARBExplicitUniformLocation = true;
else enum useARBExplicitUniformLocation = 4;

static if(useARBExplicitUniformLocation) {
    private bool _hasARBExplicitUniformLocation;
    bool hasARBExplicitUniformLocation() { return _hasARBExplicitUniformLocation; }

    enum uint GL_MAX_UNIFORM_LOCATIONS = 0x826E;
}
else enum hasARBExplicitUniformLocation = false;

// ARB_framebuffer_no_attachments
version(GL_ARB) enum useARBFramebufferNoAttachments = true;
else version(GL_ARB_framebuffer_no_attachments) enum useARBFramebufferNoAttachments = true;
else enum useARBFramebufferNoAttachments = 4;

static if(useARBFramebufferNoAttachments) {
    private bool _hasARBFramebufferNoAttachments;
    bool hasARBFramebufferNoAttachments() { return _hasARBFramebufferNoAttachments; }

    enum : uint {
        GL_FRAMEBUFFER_DEFAULT_WIDTH      = 0x9310,
        GL_FRAMEBUFFER_DEFAULT_HEIGHT     = 0x9311,
        GL_FRAMEBUFFER_DEFAULT_LAYERS     = 0x9312,
        GL_FRAMEBUFFER_DEFAULT_SAMPLES    = 0x9313,
        GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS = 0x9314,
        GL_MAX_FRAMEBUFFER_WIDTH          = 0x9315,
        GL_MAX_FRAMEBUFFER_HEIGHT         = 0x9316,
        GL_MAX_FRAMEBUFFER_LAYERS         = 0x9317,
        GL_MAX_FRAMEBUFFER_SAMPLES        = 0x9318,
    }

    extern(System) @nogc nothrow {
        alias pglFramebufferParameteri = void function(GLenum,GLenum,GLint);
        alias pglGetFramebufferParameteriv = void function(GLenum,GLenum,GLint*);
        alias pglNamedFramebufferParameteriEXT = void function(GLuint,GLenum,GLint);
        alias pglGetNamedFramebufferParameterivEXT = void function(GLuint,GLenum,GLint*);
    }

    __gshared {
        pglFramebufferParameteri glFramebufferParameteri;
        pglGetFramebufferParameteriv glGetFramebufferParameteriv;
        pglNamedFramebufferParameteriEXT glNamedFramebufferParameteriEXT;
        pglGetNamedFramebufferParameterivEXT glGetNamedFramebufferParameterivEXT;
    }

    private @nogc nothrow
    bool loadARBFramebufferNoAttachments(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glFramebufferParameteri, "glFramebufferParameteri");
        lib.bindGLSymbol(cast(void**)&glGetFramebufferParameteriv, "glGetFramebufferParameteriv");

        // The previous two functions are required when loading GL 4.3,
        // the next two are not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glNamedFramebufferParameteriEXT, "glNamedFramebufferParameteriEXT");
            lib.bindGLSymbol(cast(void**)&glGetNamedFramebufferParameterivEXT, "glGetNamedFramebufferParameterivEXT");

            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBFramebufferNoAttachments = false;

// ARB_internalformat_query2
version(GL_ARB) enum useARBInternalFormatQuery2 = true;
else version(GL_ARB_internalformat_query2) enum useARBInternalFormatQuery2 = true;
else enum useARBInternalFormatQuery2 = has43;

static if(useARBInternalFormatQuery2) {
    private bool _hasARBInternalFormatQuery2;
    bool hasARBInternalFormatQuery2() { return _hasARBInternalFormatQuery2; }

    enum : uint {
        GL_INTERNALFORMAT_SUPPORTED       = 0x826F,
        GL_INTERNALFORMAT_PREFERRED       = 0x8270,
        GL_INTERNALFORMAT_RED_SIZE        = 0x8271,
        GL_INTERNALFORMAT_GREEN_SIZE      = 0x8272,
        GL_INTERNALFORMAT_BLUE_SIZE       = 0x8273,
        GL_INTERNALFORMAT_ALPHA_SIZE      = 0x8274,
        GL_INTERNALFORMAT_DEPTH_SIZE      = 0x8275,
        GL_INTERNALFORMAT_STENCIL_SIZE    = 0x8276,
        GL_INTERNALFORMAT_SHARED_SIZE     = 0x8277,
        GL_INTERNALFORMAT_RED_TYPE        = 0x8278,
        GL_INTERNALFORMAT_GREEN_TYPE      = 0x8279,
        GL_INTERNALFORMAT_BLUE_TYPE       = 0x827A,
        GL_INTERNALFORMAT_ALPHA_TYPE      = 0x827B,
        GL_INTERNALFORMAT_DEPTH_TYPE      = 0x827C,
        GL_INTERNALFORMAT_STENCIL_TYPE    = 0x827D,
        GL_MAX_WIDTH                      = 0x827E,
        GL_MAX_HEIGHT                     = 0x827F,
        GL_MAX_DEPTH                      = 0x8280,
        GL_MAX_LAYERS                     = 0x8281,
        GL_MAX_COMBINED_DIMENSIONS        = 0x8282,
        GL_COLOR_COMPONENTS               = 0x8283,
        GL_DEPTH_COMPONENTS               = 0x8284,
        GL_STENCIL_COMPONENTS             = 0x8285,
        GL_COLOR_RENDERABLE               = 0x8286,
        GL_DEPTH_RENDERABLE               = 0x8287,
        GL_STENCIL_RENDERABLE             = 0x8288,
        GL_FRAMEBUFFER_RENDERABLE         = 0x8289,
        GL_FRAMEBUFFER_RENDERABLE_LAYERED = 0x828A,
        GL_FRAMEBUFFER_BLEND              = 0x828B,
        GL_READ_PIXELS                    = 0x828C,
        GL_READ_PIXELS_FORMAT             = 0x828D,
        GL_READ_PIXELS_TYPE               = 0x828E,
        GL_TEXTURE_IMAGE_FORMAT           = 0x828F,
        GL_TEXTURE_IMAGE_TYPE             = 0x8290,
        GL_GET_TEXTURE_IMAGE_FORMAT       = 0x8291,
        GL_GET_TEXTURE_IMAGE_TYPE         = 0x8292,
        GL_MIPMAP                         = 0x8293,
        GL_MANUAL_GENERATE_MIPMAP         = 0x8294,
        GL_AUTO_GENERATE_MIPMAP           = 0x8295,
        GL_COLOR_ENCODING                 = 0x8296,
        GL_SRGB_READ                      = 0x8297,
        GL_SRGB_WRITE                     = 0x8298,
        GL_SRGB_DECODE_ARB                = 0x8299,
        GL_FILTER                         = 0x829A,
        GL_VERTEX_TEXTURE                 = 0x829B,
        GL_TESS_CONTROL_TEXTURE           = 0x829C,
        GL_TESS_EVALUATION_TEXTURE        = 0x829D,
        GL_GEOMETRY_TEXTURE               = 0x829E,
        GL_FRAGMENT_TEXTURE               = 0x829F,
        GL_COMPUTE_TEXTURE                = 0x82A0,
        GL_TEXTURE_SHADOW                 = 0x82A1,
        GL_TEXTURE_GATHER                 = 0x82A2,
        GL_TEXTURE_GATHER_SHADOW          = 0x82A3,
        GL_SHADER_IMAGE_LOAD              = 0x82A4,
        GL_SHADER_IMAGE_STORE             = 0x82A5,
        GL_SHADER_IMAGE_ATOMIC            = 0x82A6,
        GL_IMAGE_TEXEL_SIZE               = 0x82A7,
        GL_IMAGE_COMPATIBILITY_CLASS      = 0x82A8,
        GL_IMAGE_PIXEL_FORMAT             = 0x82A9,
        GL_IMAGE_PIXEL_TYPE               = 0x82AA,
        GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST = 0x82AC,
        GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST = 0x82AD,
        GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE = 0x82AE,
        GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE = 0x82AF,
        GL_TEXTURE_COMPRESSED_BLOCK_WIDTH = 0x82B1,
        GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT = 0x82B2,
        GL_TEXTURE_COMPRESSED_BLOCK_SIZE  = 0x82B3,
        GL_CLEAR_BUFFER                   = 0x82B4,
        GL_TEXTURE_VIEW                   = 0x82B5,
        GL_VIEW_COMPATIBILITY_CLASS       = 0x82B6,
        GL_FULL_SUPPORT                   = 0x82B7,
        GL_CAVEAT_SUPPORT                 = 0x82B8,
        GL_IMAGE_CLASS_4_X_32             = 0x82B9,
        GL_IMAGE_CLASS_2_X_32             = 0x82BA,
        GL_IMAGE_CLASS_1_X_32             = 0x82BB,
        GL_IMAGE_CLASS_4_X_16             = 0x82BC,
        GL_IMAGE_CLASS_2_X_16             = 0x82BD,
        GL_IMAGE_CLASS_1_X_16             = 0x82BE,
        GL_IMAGE_CLASS_4_X_8              = 0x82BF,
        GL_IMAGE_CLASS_2_X_8              = 0x82C0,
        GL_IMAGE_CLASS_1_X_8              = 0x82C1,
        GL_IMAGE_CLASS_11_11_10           = 0x82C2,
        GL_IMAGE_CLASS_10_10_10_2         = 0x82C3,
        GL_VIEW_CLASS_128_BITS            = 0x82C4,
        GL_VIEW_CLASS_96_BITS             = 0x82C5,
        GL_VIEW_CLASS_64_BITS             = 0x82C6,
        GL_VIEW_CLASS_48_BITS             = 0x82C7,
        GL_VIEW_CLASS_32_BITS             = 0x82C8,
        GL_VIEW_CLASS_24_BITS             = 0x82C9,
        GL_VIEW_CLASS_16_BITS             = 0x82CA,
        GL_VIEW_CLASS_8_BITS              = 0x82CB,
        GL_VIEW_CLASS_S3TC_DXT1_RGB       = 0x82CC,
        GL_VIEW_CLASS_S3TC_DXT1_RGBA      = 0x82CD,
        GL_VIEW_CLASS_S3TC_DXT3_RGBA      = 0x82CE,
        GL_VIEW_CLASS_S3TC_DXT5_RGBA      = 0x82CF,
        GL_VIEW_CLASS_RGTC1_RED           = 0x82D0,
        GL_VIEW_CLASS_RGTC2_RG            = 0x82D1,
        GL_VIEW_CLASS_BPTC_UNORM          = 0x82D2,
        GL_VIEW_CLASS_BPTC_FLOAT          = 0x82D3,
    }

    extern(System) @nogc nothrow alias pglGetInternalformati64v = void function(GLenum,GLenum,GLenum,GLsizei,GLint64*);
    __gshared pglGetInternalformati64v glGetInternalformati64v;

    private @nogc nothrow
    bool loadARBInternalFormatQuery2(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glGetInternalformati64v, "glGetInternalformati64v");
        return resetErrorCountGL();
    }
}
else enum hasARBInternalFormatQuery2 = false;

// ARB_invalidate_subdata
version(GL_ARB) enum useARBInvalidateSubdata = true;
else version(GL_ARB_invalidate_subdata) enum useARBInvalidateSubdata = true;
else enum useARBInvalidateSubdata = has43;

static if(useARBInvalidateSubdata) {
    private bool _hasARBInvalidateSubdata;
    bool hasARBInvalidateSubdata() { return _hasARBInvalidateSubdata; }

    extern(System) @nogc nothrow {
        alias pglInvalidateTexSubImage = void function(GLuint,GLint,GLint,GLint,GLint,GLsizei,GLsizei,GLsizei);
        alias pglInvalidateTexImage = void function(GLuint,GLint);
        alias pglInvalidateBufferSubData = void function(GLuint,GLintptr,GLsizeiptr);
        alias pglInvalidateBufferData = void function(GLuint);
        alias pglInvalidateFramebuffer = void function(GLenum,GLsizei,const(GLenum)*);
        alias pglInvalidateSubFramebuffer = void function(GLenum,GLsizei,const(GLenum)*,GLint,GLint,GLsizei,GLsizei);
    }

    __gshared {
        pglInvalidateTexSubImage glInvalidateTexSubImage;
        pglInvalidateTexImage glInvalidateTexImage;
        pglInvalidateBufferSubData glInvalidateBufferSubData;
        pglInvalidateBufferData glInvalidateBufferData;
        pglInvalidateFramebuffer glInvalidateFramebuffer;
        pglInvalidateSubFramebuffer glInvalidateSubFramebuffer;
    }

    private @nogc nothrow
    bool loadARBInvalidateSubdata(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glInvalidateTexSubImage, "glInvalidateTexSubImage");
        lib.bindGLSymbol(cast(void**)&glInvalidateTexImage, "glInvalidateTexImage");
        lib.bindGLSymbol(cast(void**)&glInvalidateBufferSubData, "glInvalidateBufferSubData");
        lib.bindGLSymbol(cast(void**)&glInvalidateBufferData, "glInvalidateBufferData");
        lib.bindGLSymbol(cast(void**)&glInvalidateFramebuffer, "glInvalidateFramebuffer");
        lib.bindGLSymbol(cast(void**)&glInvalidateSubFramebuffer, "glInvalidateSubFramebuffer");
        return resetErrorCountGL();
    }
}
else enum hasARBInvalidateSubdata = false;

// ARB_multi_draw_indirect
version(GL_ARB) enum useARBMultiDrawIndirect = true;
else version(GL_ARB_multi_draw_indirect) enum useARBMultiDrawIndirect = true;
else enum useARBMultiDrawIndirect = has43;

static if(useARBMultiDrawIndirect) {
    private bool _hasARBMultiDrawIndirect;
    bool hasARBMultiDrawIndirect() { return _hasARBMultiDrawIndirect; }

    extern(System) @nogc nothrow {
        alias pglMultiDrawArraysIndirect = void function(GLenum,const(void)*,GLsizei,GLsizei);
        alias pglMultiDrawElementsIndirect = void function(GLenum,GLenum,const(void)*,GLsizei,GLsizei);
    }

    __gshared {
        pglMultiDrawArraysIndirect glMultiDrawArraysIndirect;
        pglMultiDrawElementsIndirect glMultiDrawElementsIndirect;
    }

    private @nogc nothrow
    bool loadARBMultiDrawIndirect(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glMultiDrawArraysIndirect, "glMultiDrawArraysIndirect");
        lib.bindGLSymbol(cast(void**)&glMultiDrawElementsIndirect, "glMultiDrawElementsIndirect");
        return resetErrorCountGL();
    }
}
else enum hasARBMultiDrawIndirect = false;

// ARB_program_interface_query
version(GL_ARB) enum useARBProgramInterfaceQuery = true;
else version(GL_ARB_program_interface_query) enum useARBProgramInterfaceQuery = true;
else enum useARBProgramInterfaceQuery = has43;

static if(useARBProgramInterfaceQuery) {
    private bool _hasARBProgramInterfaceQuery;
    bool hasARBProgramInterfaceQuery() { return _hasARBProgramInterfaceQuery; }

    enum : uint {
        GL_UNIFORM                        = 0x92E1,
        GL_UNIFORM_BLOCK                  = 0x92E2,
        GL_PROGRAM_INPUT                  = 0x92E3,
        GL_PROGRAM_OUTPUT                 = 0x92E4,
        GL_BUFFER_VARIABLE                = 0x92E5,
        GL_SHADER_STORAGE_BLOCK           = 0x92E6,
        GL_VERTEX_SUBROUTINE              = 0x92E8,
        GL_TESS_CONTROL_SUBROUTINE        = 0x92E9,
        GL_TESS_EVALUATION_SUBROUTINE     = 0x92EA,
        GL_GEOMETRY_SUBROUTINE            = 0x92EB,
        GL_FRAGMENT_SUBROUTINE            = 0x92EC,
        GL_COMPUTE_SUBROUTINE             = 0x92ED,
        GL_VERTEX_SUBROUTINE_UNIFORM      = 0x92EE,
        GL_TESS_CONTROL_SUBROUTINE_UNIFORM = 0x92EF,
        GL_TESS_EVALUATION_SUBROUTINE_UNIFORM = 0x92F0,
        GL_GEOMETRY_SUBROUTINE_UNIFORM    = 0x92F1,
        GL_FRAGMENT_SUBROUTINE_UNIFORM    = 0x92F2,
        GL_COMPUTE_SUBROUTINE_UNIFORM     = 0x92F3,
        GL_TRANSFORM_FEEDBACK_VARYING     = 0x92F4,
        GL_ACTIVE_RESOURCES               = 0x92F5,
        GL_MAX_NAME_LENGTH                = 0x92F6,
        GL_MAX_NUM_ACTIVE_VARIABLES       = 0x92F7,
        GL_MAX_NUM_COMPATIBLE_SUBROUTINES = 0x92F8,
        GL_NAME_LENGTH                    = 0x92F9,
        GL_TYPE                           = 0x92FA,
        GL_ARRAY_SIZE                     = 0x92FB,
        GL_OFFSET                         = 0x92FC,
        GL_BLOCK_INDEX                    = 0x92FD,
        GL_ARRAY_STRIDE                   = 0x92FE,
        GL_MATRIX_STRIDE                  = 0x92FF,
        GL_IS_ROW_MAJOR                   = 0x9300,
        GL_ATOMIC_COUNTER_BUFFER_INDEX    = 0x9301,
        GL_BUFFER_BINDING                 = 0x9302,
        GL_BUFFER_DATA_SIZE               = 0x9303,
        GL_NUM_ACTIVE_VARIABLES           = 0x9304,
        GL_ACTIVE_VARIABLES               = 0x9305,
        GL_REFERENCED_BY_VERTEX_SHADER    = 0x9306,
        GL_REFERENCED_BY_TESS_CONTROL_SHADER = 0x9307,
        GL_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x9308,
        GL_REFERENCED_BY_GEOMETRY_SHADER  = 0x9309,
        GL_REFERENCED_BY_FRAGMENT_SHADER  = 0x930A,
        GL_REFERENCED_BY_COMPUTE_SHADER   = 0x930B,
        GL_TOP_LEVEL_ARRAY_SIZE           = 0x930C,
        GL_TOP_LEVEL_ARRAY_STRIDE         = 0x930D,
        GL_LOCATION                       = 0x930E,
        GL_LOCATION_INDEX                 = 0x930F,
        GL_IS_PER_PATCH                   = 0x92E7,
    }

    extern(System) @nogc nothrow {
        alias pglGetProgramInterfaceiv = void function(GLuint,GLenum,GLenum,GLint*);
        alias pglGetProgramResourceIndex = GLuint function(GLuint,GLenum,const(GLchar)*);
        alias pglGetProgramResourceName = void function(GLuint,GLenum,GLuint,GLsizei,GLsizei*,GLchar*);
        alias pglGetProgramResourceiv = void function(GLuint,GLenum,GLuint,GLsizei,const(GLenum)*,GLsizei,GLsizei*,GLint*);
        alias pglGetProgramResourceLocation = GLint function(GLuint,GLenum,const(GLchar)*);
        alias pglGetProgramResourceLocationIndex = GLint function(GLuint,GLenum,const(GLchar)*);
    }

    __gshared {
        pglGetProgramInterfaceiv glGetProgramInterfaceiv;
        pglGetProgramResourceIndex glGetProgramResourceIndex;
        pglGetProgramResourceName glGetProgramResourceName;
        pglGetProgramResourceiv glGetProgramResourceiv;
        pglGetProgramResourceLocation glGetProgramResourceLocation;
        pglGetProgramResourceLocationIndex glGetProgramResourceLocationIndex;
    }

    private @nogc nothrow
    bool loadARBProgramInterfaceQuery(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glGetProgramInterfaceiv, "glGetProgramInterfaceiv");
        lib.bindGLSymbol(cast(void**)&glGetProgramResourceIndex, "glGetProgramResourceIndex");
        lib.bindGLSymbol(cast(void**)&glGetProgramResourceName, "glGetProgramResourceName");
        lib.bindGLSymbol(cast(void**)&glGetProgramResourceiv, "glGetProgramResourceiv");
        lib.bindGLSymbol(cast(void**)&glGetProgramResourceLocation, "glGetProgramResourceLocation");
        lib.bindGLSymbol(cast(void**)&glGetProgramResourceLocationIndex, "glGetProgramResourceLocationIndex");
        return resetErrorCountGL();
    }
}
else enum hasARBProgramInterfaceQuery = false;

// ARB_shader_storage_buffer_object
version(GL_ARB) enum useARBShaderStorageBufferObject = true;
else version(GL_ARB_shader_storage_buffer_object) enum useARBShaderStorageBufferObject = true;
else enum useARBShaderStorageBufferObject = has43;

static if(useARBShaderStorageBufferObject) {
    private bool _hasARBShaderStorageBufferObject;
    bool hasARBShaderStorageBufferObject() { return _hasARBShaderStorageBufferObject; }

    enum : uint {
        GL_SHADER_STORAGE_BUFFER          = 0x90D2,
        GL_SHADER_STORAGE_BUFFER_BINDING  = 0x90D3,
        GL_SHADER_STORAGE_BUFFER_START    = 0x90D4,
        GL_SHADER_STORAGE_BUFFER_SIZE     = 0x90D5,
        GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS = 0x90D6,
        GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS = 0x90D7,
        GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS = 0x90D8,
        GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS = 0x90D9,
        GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS = 0x90DA,
        GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS = 0x90DB,
        GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS = 0x90DC,
        GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS = 0x90DD,
        GL_MAX_SHADER_STORAGE_BLOCK_SIZE  = 0x90DE,
        GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT = 0x90DF,
        GL_SHADER_STORAGE_BARRIER_BIT     = 0x2000,
        GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES = 0x8F39,
    }

    extern(System) @nogc nothrow alias pglShaderStorageBlockBinding = void function(GLuint,GLuint,GLuint);
    __gshared pglShaderStorageBlockBinding glShaderStorageBlockBinding;

    private @nogc nothrow
    bool loadARBShaderStorageBufferObject(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glShaderStorageBlockBinding, "glShaderStorageBlockBinding");
        return resetErrorCountGL();
    }
}
else enum hasARBShaderStorageBufferObject = false;

// ARB_stencil_texturing
version(GL_ARB) enum useARBStencilTexturing = true;
else version(GL_ARB_stencil_texturing) enum useARBStencilTexturing = true;
else enum useARBStencilTexturing = has43;

static if(useARBStencilTexturing) {
    private bool _hasARBStencilTexturing;
    bool hasARBStencilTexturing() { return _hasARBStencilTexturing; }

    enum uint GL_DEPTH_STENCIL_TEXTURE_MODE = 0x90EA;
}
else enum hasARBStencilTexturing = false;

// ARB_texture_buffer_range
version(GL_ARB) enum useARBTextureBufferRange = true;
else version(GL_ARB_texture_buffer_range) enum useARBTextureBufferRange = true;
else enum useARBTextureBufferRange = has43;

static if(useARBTextureBufferRange) {
    private bool _hasARBTextureBufferRange;
    bool hasARBTextureBufferRange() { return _hasARBTextureBufferRange; }

    enum : uint {
        GL_TEXTURE_BUFFER_OFFSET = 0x919D,
        GL_TEXTURE_BUFFER_SIZE = 0x919E,
        GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT = 0x919F,
    }

    extern(System) @nogc nothrow {
        alias da_glTexBufferRange = void function(GLenum,GLenum,GLuint,GLintptr,GLsizeiptr);
        alias da_glTextureBufferRangeEXT = void function(GLuint,GLenum,GLenum,GLuint,GLintptr,GLsizeiptr);
    }

    __gshared {
        da_glTexBufferRange glTexBufferRange;
        da_glTextureBufferRangeEXT glTextureBufferRangeEXT;
    }

    private @nogc nothrow
    bool loadARBTextureBufferRange(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glTexBufferRange, "glTexBufferRange");

        // The previous function is required when loading GL 4.3,
        // the next one is not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glTextureBufferRangeEXT, "glTextureBufferRangeEXT");

            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBTextureBufferRange = false;

// ARB_texture_storage_multisample
version(GL_ARB) enum useARBTextureStorageMultisample = true;
else version(GL_ARB_texture_storage_multisample) enum useARBTextureStorageMultisample = true;
else enum useARBTextureStorageMultisample = has43;

static if(useARBTextureStorageMultisample) {
    private bool _hasARBTextureStorageMultisample;
    bool hasARBTextureStorageMultisample() { return _hasARBTextureStorageMultisample; }

    extern(System) @nogc nothrow {
        alias pglTexStorage2DMultisample = void function(GLenum,GLsizei,GLenum,GLsizei,GLsizei,GLboolean);
        alias pglTexStorage3DMultisample = void function(GLenum,GLsizei,GLenum,GLsizei,GLsizei,GLsizei,GLboolean);
        alias pglTextureStorage2DMultisampleEXT = void function(GLuint,GLenum,GLsizei,GLenum,GLsizei,GLsizei,GLboolean);
        alias pglTextureStorage3DMultisampleEXT = void function(GLuint,GLenum,GLsizei,GLenum,GLsizei,GLsizei,GLsizei,GLboolean);
    }

    __gshared {
        pglTexStorage2DMultisample glTexStorage2DMultisample;
        pglTexStorage3DMultisample glTexStorage3DMultisample;
        pglTextureStorage2DMultisampleEXT glTextureStorage2DMultisampleEXT;
        pglTextureStorage3DMultisampleEXT glTextureStorage3DMultisampleEXT;
    }

    private @nogc nothrow
    bool loadARBTextureStorageMultisample(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glTexStorage2DMultisample, "glTexStorage2DMultisample");
        lib.bindGLSymbol(cast(void**)&glTexStorage3DMultisample, "glTexStorage3DMultisample");

        // The previous two functions are required when loading GL 4.3,
        // the next two are not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glTextureStorage2DMultisampleEXT, "glTextureStorage2DMultisampleEXT");
            lib.bindGLSymbol(cast(void**)&glTextureStorage3DMultisampleEXT, "glTextureStorage3DMultisampleEXT");

            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBTextureStorageMultisample = false;

// ARB_texture_view
version(GL_ARB) enum useARBTextureView = true;
else version(GL_ARB_texture_view) enum useARBTextureView = true;
else enum useARBTextureView = has43;

static if(useARBTextureView) {
    private bool _hasARBTextureView;
    bool hasARBTextureView() { return _hasARBTextureView; }

    enum : uint {
        GL_TEXTURE_VIEW_MIN_LEVEL         = 0x82DB,
        GL_TEXTURE_VIEW_NUM_LEVELS        = 0x82DC,
        GL_TEXTURE_VIEW_MIN_LAYER         = 0x82DD,
        GL_TEXTURE_VIEW_NUM_LAYERS        = 0x82DE,
        GL_TEXTURE_IMMUTABLE_LEVELS       = 0x82DF,
    }

    extern(System) @nogc nothrow alias pglTextureView = void function(GLuint,GLenum,GLuint,GLenum,GLuint,GLuint,GLuint,GLuint);
    __gshared pglTextureView glTextureView;

    private @nogc nothrow
    bool loadARBTextureView(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glTextureView, "glTextureView");
        return resetErrorCountGL();
    }
}
else enum hasARBTextureView = false;

// ARB_vertex_attrib_binding
version(GL_ARB) enum useARBVertexAttribBinding = true;
else version(GL_ARB_vertex_attrib_binding) enum useARBVertexAttribBinding = true;
else enum useARBVertexAttribBinding = has43;

static if(useARBVertexAttribBinding) {
    private bool _hasARBVertexAttribBinding;
    bool hasARBVertexAttribBinding() { return _hasARBVertexAttribBinding; }

    enum : uint {
        GL_VERTEX_ATTRIB_BINDING          = 0x82D4,
        GL_VERTEX_ATTRIB_RELATIVE_OFFSET  = 0x82D5,
        GL_VERTEX_BINDING_DIVISOR         = 0x82D6,
        GL_VERTEX_BINDING_OFFSET          = 0x82D7,
        GL_VERTEX_BINDING_STRIDE          = 0x82D8,
        GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET = 0x82D9,
        GL_MAX_VERTEX_ATTRIB_BINDINGS     = 0x82DA,
    }

    extern(System) @nogc nothrow {
        alias pglBindVertexBuffer = void function(GLuint,GLuint,GLintptr,GLsizei);
        alias pglVertexAttribFormat = void function(GLuint,GLint,GLenum,GLboolean,GLuint);
        alias pglVertexAttribIFormat = void function(GLuint,GLint,GLenum,GLuint);
        alias pglVertexAttribLFormat = void function(GLuint,GLint,GLenum,GLuint);
        alias pglVertexAttribBinding = void function(GLuint,GLuint);
        alias pglVertexBindingDivisor = void function(GLuint,GLuint);
        alias pglVertexArrayBindVertexBufferEXT = void function(GLuint,GLuint,GLuint,GLintptr,GLsizei);
        alias pglVertexArrayVertexAttribFormatEXT = void function(GLuint,GLuint,GLint,GLenum,GLboolean,GLuint);
        alias pglVertexArrayVertexAttribIFormatEXT = void function(GLuint,GLuint,GLint,GLenum,GLuint);
        alias pglVertexArrayVertexAttribLFormatEXT = void function(GLuint,GLuint,GLint,GLenum,GLuint);
        alias pglVertexArrayVertexAttribBindingEXT = void function(GLuint,GLuint,GLuint);
        alias pglVertexArrayVertexBindingDivisorEXT = void function(GLuint,GLuint,GLuint);
    }

    __gshared {
        pglBindVertexBuffer glBindVertexBuffer;
        pglVertexAttribFormat glVertexAttribFormat;
        pglVertexAttribIFormat glVertexAttribIFormat;
        pglVertexAttribLFormat glVertexAttribLFormat;
        pglVertexAttribBinding glVertexAttribBinding;
        pglVertexBindingDivisor glVertexBindingDivisor;
        pglVertexArrayBindVertexBufferEXT glVertexArrayBindVertexBufferEXT;
        pglVertexArrayVertexAttribFormatEXT glVertexArrayVertexAttribFormatEXT;
        pglVertexArrayVertexAttribIFormatEXT glVertexArrayVertexAttribIFormatEXT;
        pglVertexArrayVertexAttribLFormatEXT glVertexArrayVertexAttribLFormatEXT;
        pglVertexArrayVertexAttribBindingEXT glVertexArrayVertexAttribBindingEXT;
        pglVertexArrayVertexBindingDivisorEXT glVertexArrayVertexBindingDivisorEXT;
    }

    private @nogc nothrow
    bool loadARBVertexAttribBinding(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glBindVertexBuffer, "glBindVertexBuffer");
        lib.bindGLSymbol(cast(void**)&glVertexAttribFormat, "glVertexAttribFormat");
        lib.bindGLSymbol(cast(void**)&glVertexAttribIFormat, "glVertexAttribIFormat");
        lib.bindGLSymbol(cast(void**)&glVertexAttribLFormat, "glVertexAttribLFormat");
        lib.bindGLSymbol(cast(void**)&glVertexAttribBinding, "glVertexAttribBinding");
        lib.bindGLSymbol(cast(void**)&glVertexBindingDivisor, "glVertexBindingDivisor");

        // The previous six functions are required when loading GL 4.3,
        // the next six are not. Save the result of resetErrorCountGL and
        // use that for the return value.
        bool ret = resetErrorCountGL();
        if(hasExtension(contextVersion, "GL_EXT_direct_state_access ")) {
            lib.bindGLSymbol(cast(void**)&glVertexArrayBindVertexBufferEXT, "glVertexArrayBindVertexBufferEXT");
            lib.bindGLSymbol(cast(void**)&glVertexArrayVertexAttribFormatEXT, "glVertexArrayVertexAttribFormatEXT");
            lib.bindGLSymbol(cast(void**)&glVertexArrayVertexAttribIFormatEXT, "glVertexArrayVertexAttribIFormatEXT");
            lib.bindGLSymbol(cast(void**)&glVertexArrayVertexAttribLFormatEXT, "glVertexArrayVertexAttribLFormatEXT");
            lib.bindGLSymbol(cast(void**)&glVertexArrayVertexAttribBindingEXT, "glVertexArrayVertexAttribBindingEXT");
            lib.bindGLSymbol(cast(void**)&glVertexArrayVertexBindingDivisorEXT, "glVertexArrayVertexBindingDivisorEXT");
            // Ignore errors.
            resetErrorCountGL();
        }
        return ret;
    }
}
else enum hasARBVertexAttribBinding = false;

// KHR_debug
version(GL_ARB) enum useKHRDebug = true;
else version(GL_KHR_debug) enum useKHRDebug = true;
else enum useKHRDebug = has43;

static if(useKHRDebug) {
    private bool _hasKHRDebug;
    bool hasKHRDebug() { return _hasKHRDebug; }

    enum : uint {
        GL_DEBUG_OUTPUT_SYNCHRONOUS       = 0x8242,
        GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH = 0x8243,
        GL_DEBUG_CALLBACK_FUNCTION        = 0x8244,
        GL_DEBUG_CALLBACK_USER_PARAM      = 0x8245,
        GL_DEBUG_SOURCE_API               = 0x8246,
        GL_DEBUG_SOURCE_WINDOW_SYSTEM     = 0x8247,
        GL_DEBUG_SOURCE_SHADER_COMPILER   = 0x8248,
        GL_DEBUG_SOURCE_THIRD_PARTY       = 0x8249,
        GL_DEBUG_SOURCE_APPLICATION       = 0x824A,
        GL_DEBUG_SOURCE_OTHER             = 0x824B,
        GL_DEBUG_TYPE_ERROR               = 0x824C,
        GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR = 0x824D,
        GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR  = 0x824E,
        GL_DEBUG_TYPE_PORTABILITY         = 0x824F,
        GL_DEBUG_TYPE_PERFORMANCE         = 0x8250,
        GL_DEBUG_TYPE_OTHER               = 0x8251,
        GL_DEBUG_TYPE_MARKER              = 0x8268,
        GL_DEBUG_TYPE_PUSH_GROUP          = 0x8269,
        GL_DEBUG_TYPE_POP_GROUP           = 0x826A,
        GL_DEBUG_SEVERITY_NOTIFICATION    = 0x826B,
        GL_MAX_DEBUG_GROUP_STACK_DEPTH    = 0x826C,
        GL_DEBUG_GROUP_STACK_DEPTH        = 0x826D,
        GL_BUFFER                         = 0x82E0,
        GL_SHADER                         = 0x82E1,
        GL_PROGRAM                        = 0x82E2,
        GL_QUERY                          = 0x82E3,
        GL_PROGRAM_PIPELINE               = 0x82E4,
        GL_SAMPLER                        = 0x82E6,
        GL_DISPLAY_LIST                   = 0x82E7,
        GL_MAX_LABEL_LENGTH               = 0x82E8,
        GL_MAX_DEBUG_MESSAGE_LENGTH       = 0x9143,
        GL_MAX_DEBUG_LOGGED_MESSAGES      = 0x9144,
        GL_DEBUG_LOGGED_MESSAGES          = 0x9145,
        GL_DEBUG_SEVERITY_HIGH            = 0x9146,
        GL_DEBUG_SEVERITY_MEDIUM          = 0x9147,
        GL_DEBUG_SEVERITY_LOW             = 0x9148,
        GL_DEBUG_OUTPUT                   = 0x92E0,
        GL_CONTEXT_FLAG_DEBUG_BIT         = 0x00000002,
    }

    extern(System) nothrow alias GLDEBUGPROC = void function(GLenum,GLenum,GLuint,GLenum,GLsizei,const(GLchar)*,GLvoid*);

    extern(System) @nogc nothrow {
        alias pglDebugMessageControl = void function(GLenum,GLenum,GLenum,GLsizei,const(GLuint*),GLboolean);
        alias pglDebugMessageInsert = void function(GLenum,GLenum,GLuint,GLenum,GLsizei,const(GLchar)*);
        alias pglDebugMessageCallback = void function(GLDEBUGPROC,const(void)*);
        alias pglGetDebugMessageLog = GLuint function(GLuint,GLsizei,GLenum*,GLenum*,GLuint*,GLenum*,GLsizei*,GLchar*);
        alias pglPushDebugGroup = void function(GLenum,GLuint,GLsizei,const(GLchar)*);
        alias pglPopDebugGroup = void function();
        alias pglObjectLabel = void function(GLenum,GLuint,GLsizei,const(GLchar)*);
        alias pglGetObjectLabel = void function(GLenum,GLuint,GLsizei,GLsizei*,GLchar*);
        alias pglObjectPtrLabel = void function(const(void)*,GLsizei,const(GLchar)*);
        alias pglGetObjectPtrLabel = void function(const(void)*,GLsizei,GLsizei*,GLchar*);
    }

    __gshared {
        pglDebugMessageControl glDebugMessageControl;
        pglDebugMessageInsert glDebugMessageInsert;
        pglDebugMessageCallback glDebugMessageCallback;
        pglGetDebugMessageLog glGetDebugMessageLog;
        pglPushDebugGroup glPushDebugGroup;
        pglPopDebugGroup glPopDebugGroup;
        pglObjectLabel glObjectLabel;
        pglGetObjectLabel glGetObjectLabel;
        pglObjectPtrLabel glObjectPtrLabel;
        pglGetObjectPtrLabel glGetObjectPtrLabel;
    }

    private @nogc nothrow
    bool loadKHRDebug(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glDebugMessageControl, "glDebugMessageControl");
        lib.bindGLSymbol(cast(void**)&glDebugMessageInsert, "glDebugMessageInsert");
        lib.bindGLSymbol(cast(void**)&glDebugMessageCallback, "glDebugMessageCallback");
        lib.bindGLSymbol(cast(void**)&glGetDebugMessageLog, "glGetDebugMessageLog");
        lib.bindGLSymbol(cast(void**)&glPushDebugGroup, "glPushDebugGroup");
        lib.bindGLSymbol(cast(void**)&glPopDebugGroup, "glPopDebugGroup");
        lib.bindGLSymbol(cast(void**)&glObjectLabel, "glObjectLabel");
        lib.bindGLSymbol(cast(void**)&glGetObjectLabel, "glGetObjectLabel");
        lib.bindGLSymbol(cast(void**)&glObjectPtrLabel, "glObjectPtrLabel");
        lib.bindGLSymbol(cast(void**)&glGetObjectPtrLabel, "glGetObjectPtrLabel");
        return resetErrorCountGL();
    }
}
else enum hasKHRDebug = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB43(SharedLib lib, GLSupport contextVersion)
{
    static if(has43) {
        if(contextVersion >= GLSupport.gl43) {
            _hasARBES3Compatibility = true;
            _hasARBExplicitUniformLocation = true;
            _hasARBStencilTexturing = true;

            bool ret = true;
            ret = _hasARBClearBufferObject = lib.loadARBClearBufferObject(contextVersion);
            ret = _hasARBComputeShader = lib.loadARBComputeShader(contextVersion);
            ret = _hasARBCopyImage = lib.loadARBCopyImage(contextVersion);
            ret = _hasARBFramebufferNoAttachments = lib.loadARBFramebufferNoAttachments(contextVersion);
            ret = _hasARBInternalFormatQuery2 = lib.loadARBInternalFormatQuery2(contextVersion);
            ret = _hasARBInvalidateSubdata = lib.loadARBInvalidateSubdata(contextVersion);
            ret = _hasARBMultiDrawIndirect = lib.loadARBMultiDrawIndirect(contextVersion);
            ret = _hasARBProgramInterfaceQuery = lib.loadARBProgramInterfaceQuery(contextVersion);
            ret = _hasARBShaderStorageBufferObject = lib.loadARBShaderStorageBufferObject(contextVersion);
            ret = _hasARBTextureBufferRange = lib.loadARBTextureBufferRange(contextVersion);
            ret = _hasARBTextureStorageMultisample = lib.loadARBTextureStorageMultisample(contextVersion);
            ret = _hasARBTextureView = lib.loadARBTextureView(contextVersion);
            ret = _hasARBVertexAttribBinding = lib.loadARBVertexAttribBinding(contextVersion);
            ret = _hasKHRDebug = lib.loadKHRDebug(contextVersion);
            return ret;
        }
    }

    static if(useARBES3Compatibility) _hasARBES3Compatibility =
            hasExtension(contextVersion, "GL_ARB_ES3_compatibility");

    static if(useARBExplicitUniformLocation) _hasARBExplicitUniformLocation =
            hasExtension(contextVersion, "GL_ARB_explicit_uniform_location");

    static if(useARBStencilTexturing) _hasARBStencilTexturing =
            hasExtension(contextVersion, "GL_ARB_stencil_texturing");

    static if(useARBClearBufferObject) _hasARBClearBufferObject =
            hasExtension(contextVersion, "GL_ARB_clear_buffer_object") &&
            lib.loadARBClearBufferObject(contextVersion);

    static if(useARBComputeShader) _hasARBComputeShader =
            hasExtension(contextVersion, "GL_ARB_compute_shader") &&
            lib.loadARBComputeShader(contextVersion);

    static if(useARBCopyImage) _hasARBCopyImage =
            hasExtension(contextVersion, "GL_ARB_copy_image") &&
            lib.loadARBCopyImage(contextVersion);

    static if(useARBFramebufferNoAttachments) _hasARBFramebufferNoAttachments =
            hasExtension(contextVersion, "GL_ARB_framebuffer_no_attachments") &&
            lib.loadARBFramebufferNoAttachments(contextVersion);

    static if(useARBInternalFormatQuery2) _hasARBInternalFormatQuery2 =
            hasExtension(contextVersion, "GL_ARB_internalformat_query2") &&
            lib.loadARBInternalFormatQuery2(contextVersion);

    static if(useARBInvalidateSubdata) _hasARBInvalidateSubdata =
            hasExtension(contextVersion, "GL_ARB_invalidate_subdata") &&
            lib.loadARBInvalidateSubdata(contextVersion);

    static if(useARBMultiDrawIndirect) _hasARBMultiDrawIndirect =
            hasExtension(contextVersion, "GL_ARB_multi_draw_indirect") &&
            lib.loadARBMultiDrawIndirect(contextVersion);

    static if(useARBProgramInterfaceQuery) _hasARBProgramInterfaceQuery =
            hasExtension(contextVersion, "GL_ARB_program_interface_query") &&
            lib.loadARBProgramInterfaceQuery(contextVersion);

    static if(useARBShaderStorageBufferObject) _hasARBShaderStorageBufferObject =
            hasExtension(contextVersion, "GL_ARB_shader_storage_buffer_object") &&
            lib.loadARBShaderStorageBufferObject(contextVersion);

    static if(useARBTextureBufferRange) _hasARBTextureBufferRange =
            hasExtension(contextVersion, "GL_ARB_texture_buffer_range") &&
            lib.loadARBTextureBufferRange(contextVersion);

    static if(useARBTextureStorageMultisample) _hasARBTextureStorageMultisample =
            hasExtension(contextVersion, "GL_ARB_texture_storage_multisample") &&
            lib.loadARBTextureStorageMultisample(contextVersion);

    static if(useARBTextureView) _hasARBTextureView =
            hasExtension(contextVersion, "GL_ARB_texture_view") &&
            lib.loadARBTextureView(contextVersion);

    static if(useARBVertexAttribBinding) _hasARBVertexAttribBinding =
            hasExtension(contextVersion, "GL_ARB_vertex_attrib_binding") &&
            lib.loadARBVertexAttribBinding(contextVersion);

    static if(useKHRDebug) _hasKHRDebug =
            hasExtension(contextVersion, "GL_KHR_debug") &&
            lib.loadKHRDebug(contextVersion);

    return true;
}