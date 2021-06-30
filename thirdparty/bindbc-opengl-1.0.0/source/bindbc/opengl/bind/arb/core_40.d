
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_40;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl40) {
    enum has40 = true;
}
else enum has40 = false;
/+
// ARB_occlusion_query2
version(GL_ARB) enum useARBOcclusionQuery2 = true;
else version(GL_ARB_occlusion_query2) enum useARBOcclusionQuery2 = true;
else enum useARBOcclusionQuery2 = has33;

static if(useARBOcclusionQuery2) {
    private bool _hasARBOcclusionQuery2;
    @nogc nothrow bool hasARBOcclusionQuery2() { return _hasARBOcclusionQuery2; }
}
else enum hasARBOcclusionQuery2 = false;

+/
// ARB_gpu_shader5
version(GL_ARB) enum useARBGPUShader5 = true;
else version(GL_ARB_gpu_shader5) enum useARBGPUShader5 = true;
else enum useARBGPUShader5 = has40;

static if(useARBGPUShader5) {
    private bool _hasARBGPUShader5;
    @nogc nothrow bool hasARBGPUShader5() { return _hasARBGPUShader5; }

    enum : uint {
        GL_GEOMETRY_SHADER_INVOCATIONS    = 0x887F,
        GL_MAX_GEOMETRY_SHADER_INVOCATIONS = 0x8E5A,
        GL_MIN_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5B,
        GL_MAX_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5C,
        GL_FRAGMENT_INTERPOLATION_OFFSET_BITS = 0x8E5D,
    }
}
else enum hasARBGPUShader5 = false;

// ARB_draw_indirect
version(GL_ARB) enum useARBDrawIndirect = true;
else version(GL_ARB_draw_indirect) enum useARBDrawIndirect = true;
else enum useARBDrawIndirect = has40;

static if(useARBDrawIndirect) {
    private bool _hasARBDrawIndirect;
    @nogc nothrow bool hasARBDrawIndirect() { return _hasARBDrawIndirect; }

    enum : uint {
        GL_DRAW_INDIRECT_BUFFER           = 0x8F3F,
        GL_DRAW_INDIRECT_BUFFER_BINDING   = 0x8F43,
    }

    extern(System) @nogc nothrow {
        alias pglDrawArraysIndirect = void function(GLenum, const(GLvoid)*);
        alias pglDrawElementsIndirect = void function(GLenum, GLenum, const(GLvoid)*);
    }

    __gshared {
        pglDrawArraysIndirect glDrawArraysIndirect;
        pglDrawElementsIndirect glDrawElementsIndirect;
    }

    private @nogc nothrow
    bool loadARBDrawIndirect(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glDrawArraysIndirect, "glDrawArraysIndirect");
        lib.bindGLSymbol(cast(void**)&glDrawElementsIndirect, "glDrawElementsIndirect");
        return resetErrorCountGL();
    }
}
else enum hasARBDrawIndirect = false;

// ARB_gpu_shader_fp64
version(GL_ARB) enum useARBGPUShaderFP64 = true;
else version(GL_ARB_gpu_shader_fp64) enum useARBGPUShaderFP64 = true;
else enum useARBGPUShaderFP64 = has40;

static if(useARBGPUShaderFP64) {
    private bool _hasARBGPUShaderFP64;
    @nogc nothrow bool hasARBGPUShaderFP64() { return _hasARBGPUShaderFP64; }

    enum : uint {
        GL_DOUBLE_VEC2                    = 0x8FFC,
        GL_DOUBLE_VEC3                    = 0x8FFD,
        GL_DOUBLE_VEC4                    = 0x8FFE,
        GL_DOUBLE_MAT2                    = 0x8F46,
        GL_DOUBLE_MAT3                    = 0x8F47,
        GL_DOUBLE_MAT4                    = 0x8F48,
        GL_DOUBLE_MAT2x3                  = 0x8F49,
        GL_DOUBLE_MAT2x4                  = 0x8F4A,
        GL_DOUBLE_MAT3x2                  = 0x8F4B,
        GL_DOUBLE_MAT3x4                  = 0x8F4C,
        GL_DOUBLE_MAT4x2                  = 0x8F4D,
        GL_DOUBLE_MAT4x3                  = 0x8F4E,
    }

    extern(System) @nogc nothrow {
        alias pglUniform1d = void function(GLint,GLdouble);
        alias pglUniform2d = void function(GLint,GLdouble,GLdouble);
        alias pglUniform3d = void function(GLint,GLdouble,GLdouble,GLdouble);
        alias pglUniform4d = void function(GLint,GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglUniform1dv = void function(GLint,GLsizei,const(GLdouble)*);
        alias pglUniform2dv = void function(GLint,GLsizei,const(GLdouble)*);
        alias pglUniform3dv = void function(GLint,GLsizei,const(GLdouble)*);
        alias pglUniform4dv = void function(GLint,GLsizei,const(GLdouble)*);
        alias pglUniformMatrix2dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix3dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix4dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix2x3dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix2x4dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix3x2dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix3x4dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix4x2dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglUniformMatrix4x3dv = void function(GLint,GLsizei,GLboolean,const(GLdouble)*);
        alias pglGetUniformdv = void function(GLuint,GLint,GLdouble*);
    }

    __gshared {
        pglUniform1d glUniform1d;
        pglUniform2d glUniform2d;
        pglUniform3d glUniform3d;
        pglUniform4d glUniform4d;
        pglUniform1dv glUniform1dv;
        pglUniform2dv glUniform2dv;
        pglUniform3dv glUniform3dv;
        pglUniform4dv glUniform4dv;
        pglUniformMatrix2dv glUniformMatrix2dv;
        pglUniformMatrix3dv glUniformMatrix3dv;
        pglUniformMatrix4dv glUniformMatrix4dv;
        pglUniformMatrix2x3dv glUniformMatrix2x3dv;
        pglUniformMatrix2x4dv glUniformMatrix2x4dv;
        pglUniformMatrix3x2dv glUniformMatrix3x2dv;
        pglUniformMatrix3x4dv glUniformMatrix3x4dv;
        pglUniformMatrix4x2dv glUniformMatrix4x2dv;
        pglUniformMatrix4x3dv glUniformMatrix4x3dv;
        pglGetUniformdv glGetUniformdv;
    }

    private @nogc nothrow
    bool loadARBGPUShaderFP64(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glUniform1d,"glUniform1d");
        lib.bindGLSymbol(cast(void**)&glUniform2d,"glUniform2d");
        lib.bindGLSymbol(cast(void**)&glUniform3d,"glUniform3d");
        lib.bindGLSymbol(cast(void**)&glUniform4d,"glUniform4d");
        lib.bindGLSymbol(cast(void**)&glUniform1dv,"glUniform1dv");
        lib.bindGLSymbol(cast(void**)&glUniform2dv,"glUniform2dv");
        lib.bindGLSymbol(cast(void**)&glUniform3dv,"glUniform3dv");
        lib.bindGLSymbol(cast(void**)&glUniform4dv,"glUniform4dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2dv,"glUniformMatrix2dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3dv,"glUniformMatrix3dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4dv,"glUniformMatrix4dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2x3dv,"glUniformMatrix2x3dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2x4dv,"glUniformMatrix2x4dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3x2dv,"glUniformMatrix3x2dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3x4dv,"glUniformMatrix3x4dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4x2dv,"glUniformMatrix4x2dv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4x3dv,"glUniformMatrix4x3dv");
        lib.bindGLSymbol(cast(void**)&glGetUniformdv,"glGetUniformdv");
        return resetErrorCountGL();
    }
}
else enum hasARBGPUShaderFP64 = false;

// ARB_shader_subroutine
version(GL_ARB) enum useARBShaderSubroutine = true;
else version(GL_ARB_shader_subroutine) enum useARBShaderSubroutine = true;
else enum useARBShaderSubroutine = has40;

static if(useARBShaderSubroutine) {
    private bool _hasARBShaderSubroutine;
    @nogc nothrow bool hasARBShaderSubroutine() { return _hasARBShaderSubroutine; }

    enum : uint {
        GL_ACTIVE_SUBROUTINES             = 0x8DE5,
        GL_ACTIVE_SUBROUTINE_UNIFORMS     = 0x8DE6,
        GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = 0x8E47,
        GL_ACTIVE_SUBROUTINE_MAX_LENGTH   = 0x8E48,
        GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = 0x8E49,
        GL_MAX_SUBROUTINES                = 0x8DE7,
        GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS = 0x8DE8,
        GL_NUM_COMPATIBLE_SUBROUTINES     = 0x8E4A,
        GL_COMPATIBLE_SUBROUTINES         = 0x8E4B,
    }

    extern(System) @nogc nothrow {
        alias pglGetSubroutineUniformLocation = GLint function(GLuint, GLenum, const(GLchar)*);
        alias pglGetSubroutineIndex = GLuint function(GLuint, GLenum, const(GLchar)*);
        alias pglGetActiveSubroutineUniformiv = void function(GLuint, GLenum, GLuint, GLenum, GLint*);
        alias pglGetActiveSubroutineUniformName = void function(GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
        alias pglGetActiveSubroutineName = void function(GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
        alias pglUniformSubroutinesuiv = void function(GLenum, GLsizei, const(GLuint)*);
        alias pglGetUniformSubroutineuiv = void function(GLenum, GLint, GLuint*);
        alias pglGetProgramStageiv = void function(GLuint, GLenum, GLenum, GLint*);
    }

    __gshared {
        pglGetSubroutineUniformLocation glGetSubroutineUniformLocation;
        pglGetSubroutineIndex glGetSubroutineIndex;
        pglGetActiveSubroutineUniformiv glGetActiveSubroutineUniformiv;
        pglGetActiveSubroutineUniformName glGetActiveSubroutineUniformName;
        pglGetActiveSubroutineName glGetActiveSubroutineName;
        pglUniformSubroutinesuiv glUniformSubroutinesuiv;
        pglGetUniformSubroutineuiv glGetUniformSubroutineuiv;
        pglGetProgramStageiv glGetProgramStageiv;
    }

    private @nogc nothrow
    bool loadARBShaderSubroutine(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glGetSubroutineUniformLocation, "glGetSubroutineUniformLocation");
        lib.bindGLSymbol(cast(void**)&glGetSubroutineIndex, "glGetSubroutineIndex");
        lib.bindGLSymbol(cast(void**)&glGetActiveSubroutineUniformiv, "glGetActiveSubroutineUniformiv");
        lib.bindGLSymbol(cast(void**)&glGetActiveSubroutineUniformName, "glGetActiveSubroutineUniformName");
        lib.bindGLSymbol(cast(void**)&glGetActiveSubroutineName, "glGetActiveSubroutineName");
        lib.bindGLSymbol(cast(void**)&glUniformSubroutinesuiv, "glUniformSubroutinesuiv");
        lib.bindGLSymbol(cast(void**)&glGetUniformSubroutineuiv, "glGetUniformSubroutineuiv");
        lib.bindGLSymbol(cast(void**)&glGetProgramStageiv, "glGetProgramStageiv");
        return resetErrorCountGL();
    }
}
else enum hasARBShaderSubroutine = false;

// ARB_tessellation_shader
version(GL_ARB) enum useARBTesselationShader = true;
else version(GL_ARB_tessellation_shader) enum useARBTesselationShader = true;
else enum useARBTesselationShader = has40;

static if(useARBTesselationShader) {
    private bool _hasARBTesselationShader;
    @nogc nothrow bool hasARBTesselationShader() { return _hasARBTesselationShader; }

    enum : uint {
        GL_PATCHES                        = 0x000E,
        GL_PATCH_VERTICES                 = 0x8E72,
        GL_PATCH_DEFAULT_INNER_LEVEL      = 0x8E73,
        GL_PATCH_DEFAULT_OUTER_LEVEL      = 0x8E74,
        GL_TESS_CONTROL_OUTPUT_VERTICES   = 0x8E75,
        GL_TESS_GEN_MODE                  = 0x8E76,
        GL_TESS_GEN_SPACING               = 0x8E77,
        GL_TESS_GEN_VERTEX_ORDER          = 0x8E78,
        GL_TESS_GEN_POINT_MODE            = 0x8E79,
        GL_ISOLINES                       = 0x8E7A,
        GL_FRACTIONAL_ODD                 = 0x8E7B,
        GL_FRACTIONAL_EVEN                = 0x8E7C,
        GL_MAX_PATCH_VERTICES             = 0x8E7D,
        GL_MAX_TESS_GEN_LEVEL             = 0x8E7E,
        GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E7F,
        GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E80,
        GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS = 0x8E81,
        GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS = 0x8E82,
        GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS = 0x8E83,
        GL_MAX_TESS_PATCH_COMPONENTS      = 0x8E84,
        GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS = 0x8E85,
        GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS = 0x8E86,
        GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS = 0x8E89,
        GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS = 0x8E8A,
        GL_MAX_TESS_CONTROL_INPUT_COMPONENTS = 0x886C,
        GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS = 0x886D,
        GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E1E,
        GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E1F,
        GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER = 0x84F0,
        GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x84F1,
        GL_TESS_EVALUATION_SHADER         = 0x8E87,
        GL_TESS_CONTROL_SHADER            = 0x8E88,
    }

    extern(System) @nogc nothrow {
        alias pglPatchParameteri = void function(GLenum, GLint);
        alias pglPatchParameterfv = void function(GLenum, const(GLfloat)*);
    }

    __gshared {
        pglPatchParameteri glPatchParameteri;
        pglPatchParameterfv glPatchParameterfv;
    }

    private @nogc nothrow
    bool loadARBTesselationShader(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glPatchParameteri, "glPatchParameteri");
        lib.bindGLSymbol(cast(void**)&glPatchParameterfv, "glPatchParameterfv");
        return resetErrorCountGL();
    }
}
else enum hasARBTesselationShader = false;

// ARB_transform_feedback2
version(GL_ARB) enum useARBTransformFeedback2 = true;
else version(GL_ARB_transform_feedback2) enum useARBTransformFeedback2 = true;
else enum useARBTransformFeedback2 = has40;

static if(useARBTransformFeedback2) {
    private bool _hasARBTransformFeedback2;
    @nogc nothrow bool hasARBTransformFeedback2() { return _hasARBTransformFeedback2; }

    enum : uint {
        GL_TRANSFORM_FEEDBACK             = 0x8E22,
        GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED = 0x8E23,
        GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE = 0x8E24,
        GL_TRANSFORM_FEEDBACK_BINDING     = 0x8E25,
    }

    extern(System) @nogc nothrow {
        alias pglBindTransformFeedback = void function(GLenum, GLuint);
        alias pglDeleteTransformFeedbacks = void function(GLsizei, const(GLuint)*);
        alias pglGenTransformFeedbacks = void function(GLsizei, GLuint*);
        alias pglIsTransformFeedback = GLboolean function(GLuint);
        alias pglPauseTransformFeedback = void function();
        alias pglResumeTransformFeedback = void function();
        alias pglDrawTransformFeedback = void function(GLenum, GLuint);
    }

    __gshared {
        pglBindTransformFeedback glBindTransformFeedback;
        pglDeleteTransformFeedbacks glDeleteTransformFeedbacks;
        pglGenTransformFeedbacks glGenTransformFeedbacks;
        pglIsTransformFeedback glIsTransformFeedback;
        pglPauseTransformFeedback glPauseTransformFeedback;
        pglResumeTransformFeedback glResumeTransformFeedback;
        pglDrawTransformFeedback glDrawTransformFeedback;
    }

    private @nogc nothrow
    bool loadARBTransformFeedback2(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glBindTransformFeedback, "glBindTransformFeedback");
        lib.bindGLSymbol(cast(void**)&glDeleteTransformFeedbacks, "glDeleteTransformFeedbacks");
        lib.bindGLSymbol(cast(void**)&glGenTransformFeedbacks, "glGenTransformFeedbacks");
        lib.bindGLSymbol(cast(void**)&glIsTransformFeedback, "glIsTransformFeedback");
        lib.bindGLSymbol(cast(void**)&glPauseTransformFeedback, "glPauseTransformFeedback");
        lib.bindGLSymbol(cast(void**)&glResumeTransformFeedback, "glResumeTransformFeedback");
        lib.bindGLSymbol(cast(void**)&glDrawTransformFeedback, "glDrawTransformFeedback");
        return resetErrorCountGL();
    }
}
else enum hasARBTransformFeedback2 = false;

// ARB_transform_feedback3
version(GL_ARB) enum useARBTransformFeedback3 = true;
else version(GL_ARB_transform_feedback3) enum useARBTransformFeedback3 = true;
else enum useARBTransformFeedback3 = has40;

static if(useARBTransformFeedback3) {
    private bool _hasARBTransformFeedback3;
    @nogc nothrow bool hasARBTransformFeedback3() { return _hasARBTransformFeedback3; }

    enum : uint {
        GL_MAX_TRANSFORM_FEEDBACK_BUFFERS = 0x8E70,
        GL_MAX_VERTEX_STREAMS             = 0x8E71,
    }

    extern(System) @nogc nothrow {
        alias pglDrawTransformFeedbackStream = void function(GLenum, GLuint, GLuint);
        alias pglBeginQueryIndexed = void function(GLenum, GLuint, GLuint);
        alias pglEndQueryIndexed = void function(GLenum, GLuint);
        alias pglGetQueryIndexediv = void function(GLenum, GLuint, GLenum, GLint*);
    }

    __gshared {
        pglDrawTransformFeedbackStream glDrawTransformFeedbackStream;
        pglBeginQueryIndexed glBeginQueryIndexed;
        pglEndQueryIndexed glEndQueryIndexed;
        pglGetQueryIndexediv glGetQueryIndexediv;
    }

    private @nogc nothrow
    bool loadARBTransformFeedback3(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glDrawTransformFeedbackStream, "glDrawTransformFeedbackStream");
        lib.bindGLSymbol(cast(void**)&glBeginQueryIndexed, "glBeginQueryIndexed");
        lib.bindGLSymbol(cast(void**)&glEndQueryIndexed, "glEndQueryIndexed");
        lib.bindGLSymbol(cast(void**)&glGetQueryIndexediv, "glGetQueryIndexediv");
        return resetErrorCountGL();
    }
}
else enum hasARBTransformFeedback3 = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB40(SharedLib lib, GLSupport contextVersion)
{
    static if(has40) {
        if(contextVersion >= GLSupport.gl40) {
            _hasARBGPUShader5 = true;

            bool ret = true;
            ret = _hasARBDrawIndirect = lib.loadARBDrawIndirect(contextVersion);
            ret = _hasARBGPUShaderFP64 = lib.loadARBGPUShaderFP64(contextVersion);
            ret = _hasARBShaderSubroutine = lib.loadARBShaderSubroutine(contextVersion);
            ret = _hasARBTesselationShader = lib.loadARBTesselationShader(contextVersion);
            ret = _hasARBTransformFeedback2 = lib.loadARBTransformFeedback2(contextVersion);
            ret = _hasARBTransformFeedback3 = lib.loadARBTransformFeedback3(contextVersion);
            return ret;
        }
    }

    static if(useARBGPUShader5) _hasARBGPUShader5 =
            hasExtension(contextVersion, "GL_ARB_gpu_shader5");

    static if(useARBDrawIndirect) _hasARBDrawIndirect =
            hasExtension(contextVersion, "GL_ARB_draw_indirect") &&
            lib.loadARBDrawIndirect(contextVersion);

    static if(useARBGPUShaderFP64) _hasARBGPUShaderFP64 =
            hasExtension(contextVersion, "GL_ARB_gpu_shader_fp64") &&
            lib.loadARBGPUShaderFP64(contextVersion);

    static if(useARBShaderSubroutine) _hasARBShaderSubroutine =
            hasExtension(contextVersion, "GL_ARB_shader_subroutine") &&
            lib.loadARBShaderSubroutine(contextVersion);

    static if(useARBTesselationShader) _hasARBTesselationShader =
            hasExtension(contextVersion, "GL_ARB_tessellation_shader") &&
            lib.loadARBTesselationShader(contextVersion);

    static if(useARBTransformFeedback2) _hasARBTransformFeedback2 =
            hasExtension(contextVersion, "GL_ARB_transform_feedback2") &&
            lib.loadARBTransformFeedback2(contextVersion);

    static if(useARBTransformFeedback3) _hasARBTransformFeedback3 =
            hasExtension(contextVersion, "GL_ARB_transform_feedback3") &&
            lib.loadARBTransformFeedback3(contextVersion);

    return true;
}