
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_41;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl41) {
    enum has41 = true;
}
else enum has41 = false;

// ARB_ES2_compatibility
version(GL_ARB) enum useARBES2Compatibility = true;
else version(GL_ARB_ES2_compatibility) enum useARBES2Compatibility = true;
else enum useARBES2Compatibility = has41;

static if(useARBES2Compatibility) {
    private bool _hasARBES2Compatibility;
    bool hasARBES2Compatibility() { return _hasARBES2Compatibility; }

    enum : uint {
        GL_FIXED                          = 0x140C,
        GL_IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A,
        GL_IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B,
        GL_LOW_FLOAT                      = 0x8DF0,
        GL_MEDIUM_FLOAT                   = 0x8DF1,
        GL_HIGH_FLOAT                     = 0x8DF2,
        GL_LOW_INT                        = 0x8DF3,
        GL_MEDIUM_INT                     = 0x8DF4,
        GL_HIGH_INT                       = 0x8DF5,
        GL_SHADER_COMPILER                = 0x8DFA,
        GL_NUM_SHADER_BINARY_FORMATS      = 0x8DF9,
        GL_MAX_VERTEX_UNIFORM_VECTORS     = 0x8DFB,
        GL_MAX_VARYING_VECTORS            = 0x8DFC,
        GL_MAX_FRAGMENT_UNIFORM_VECTORS   = 0x8DFD,
    }

    extern(System) @nogc nothrow {
        alias pglReleaseShaderCompiler = void function();
        alias pglShaderBinary = void function(GLsizei, const(GLuint)*, GLenum, const(GLvoid)*, GLsizei);
        alias pglGetShaderPrecisionFormat = void function(GLenum, GLenum, GLint*, GLint*);
        alias pglDepthRangef = void function(GLclampf, GLclampf);
        alias pglClearDepthf = void function(GLclampf);
    }

    __gshared {
        pglReleaseShaderCompiler glReleaseShaderCompiler;
        pglShaderBinary glShaderBinary;
        pglGetShaderPrecisionFormat glGetShaderPrecisionFormat;
        pglDepthRangef glDepthRangef;
        pglClearDepthf glClearDepthf;
    }

    private @nogc nothrow
    bool loadARBES2Compatibility(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glReleaseShaderCompiler, "glReleaseShaderCompiler");
        lib.bindGLSymbol(cast(void**)&glShaderBinary, "glShaderBinary");
        lib.bindGLSymbol(cast(void**)&glGetShaderPrecisionFormat, "glGetShaderPrecisionFormat");
        lib.bindGLSymbol(cast(void**)&glDepthRangef, "glDepthRangef");
        lib.bindGLSymbol(cast(void**)&glClearDepthf, "glClearDepthf");
        return resetErrorCountGL();
    }
}
else enum hasARBES2Compatibility = false;

// ARB_get_program_binary
version(GL_ARB) enum useARBGetProgramBinary = true;
else version(GL_ARB_get_program_binary) enum useARBGetProgramBinary = true;
else enum useARBGetProgramBinary = has41;

static if(useARBGetProgramBinary) {
    private bool _hasARBGetProgramBinary;
    bool hasARBGetProgramBinary() { return _hasARBGetProgramBinary; }

    enum : uint {
        GL_PROGRAM_BINARY_RETRIEVABLE_HINT = 0x8257,
        GL_PROGRAM_BINARY_LENGTH          = 0x8741,
        GL_NUM_PROGRAM_BINARY_FORMATS     = 0x87FE,
        GL_PROGRAM_BINARY_FORMATS         = 0x87FF,
    }

    extern(System) @nogc nothrow {
        alias pglGetProgramBinary = void function(GLuint,GLsizei,GLsizei*,GLenum*,GLvoid*);
        alias pglProgramBinary = void function(GLuint,GLenum,const(GLvoid)*,GLsizei);
        alias pglProgramParameteri = void function(GLuint,GLenum,GLint);
    }

    __gshared {
        pglGetProgramBinary glGetProgramBinary;
        pglProgramBinary glProgramBinary;
        pglProgramParameteri glProgramParameteri;
    }

    private @nogc nothrow
    bool loadARBGetProgramBinary(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glGetProgramBinary,"glGetProgramBinary");
        lib.bindGLSymbol(cast(void**)&glProgramBinary,"glProgramBinary");
        lib.bindGLSymbol(cast(void**)&glProgramParameteri,"glProgramParameteri");
        return resetErrorCountGL();
    }
}
else enum hasARBGetProgramBinary = false;

// ARB_separate_shader_objects
version(GL_ARB) enum useARBSeparateShaderObjects = true;
else version(GL_ARB_separate_shader_objects) enum useARBSeparateShaderObjects = true;
else enum useARBSeparateShaderObjects = has41;

static if(useARBSeparateShaderObjects) {
    private bool _hasARBSeparateShaderObjects;
    bool hasARBSeparateShaderObjects() { return _hasARBSeparateShaderObjects; }

    enum : uint {
        GL_VERTEX_SHADER_BIT              = 0x00000001,
        GL_FRAGMENT_SHADER_BIT            = 0x00000002,
        GL_GEOMETRY_SHADER_BIT            = 0x00000004,
        GL_TESS_CONTROL_SHADER_BIT        = 0x00000008,
        GL_TESS_EVALUATION_SHADER_BIT     = 0x00000010,
        GL_ALL_SHADER_BITS                = 0xFFFFFFFF,
        GL_PROGRAM_SEPARABLE              = 0x8258,
        GL_ACTIVE_PROGRAM                 = 0x8259,
        GL_PROGRAM_PIPELINE_BINDING       = 0x825A,
    }

    extern(System) @nogc nothrow {
        alias pglUseProgramStages = void function(GLuint, GLbitfield, GLuint);
        alias pglActiveShaderProgram = void function(GLuint, GLuint);
        alias pglCreateShaderProgramv = GLuint function(GLenum, GLsizei, const(GLchar*)*);
        alias pglBindProgramPipeline = void function(GLuint);
        alias pglDeleteProgramPipelines = void function(GLsizei, const(GLuint)*);
        alias pglGenProgramPipelines = void function(GLsizei, GLuint*);
        alias pglIsProgramPipeline = GLboolean function(GLuint);
        alias pglGetProgramPipelineiv = void function(GLuint, GLenum, GLint*);
        alias pglProgramUniform1i = void function(GLuint, GLint, GLint);
        alias pglProgramUniform1iv = void function(GLuint, GLint, GLsizei, const(GLint)*);
        alias pglProgramUniform1f = void function(GLuint, GLint, GLfloat);
        alias pglProgramUniform1fv = void function(GLuint, GLint, GLsizei, const(GLfloat)*);
        alias pglProgramUniform1d = void function(GLuint, GLint, GLdouble);
        alias pglProgramUniform1dv = void function(GLuint, GLint, GLsizei, const(GLdouble)*);
        alias pglProgramUniform1ui = void function(GLuint, GLint, GLuint);
        alias pglProgramUniform1uiv = void function(GLuint, GLint, GLsizei, const(GLuint)*);
        alias pglProgramUniform2i = void function(GLuint, GLint, GLint, GLint);
        alias pglProgramUniform2iv = void function(GLuint, GLint, GLsizei, const(GLint)*);
        alias pglProgramUniform2f = void function(GLuint, GLint, GLfloat, GLfloat);
        alias pglProgramUniform2fv = void function(GLuint, GLint, GLsizei, const(GLfloat)*);
        alias pglProgramUniform2d = void function(GLuint, GLint, GLdouble, GLdouble);
        alias pglProgramUniform2dv = void function(GLuint, GLint, GLsizei, const(GLdouble)*);
        alias pglProgramUniform2ui = void function(GLuint, GLint, GLuint, GLuint);
        alias pglProgramUniform2uiv = void function(GLuint, GLint, GLsizei, const(GLuint)*);
        alias pglProgramUniform3i = void function(GLuint, GLint, GLint, GLint, GLint);
        alias pglProgramUniform3iv = void function(GLuint, GLint, GLsizei, const(GLint)*);
        alias pglProgramUniform3f = void function(GLuint, GLint, GLfloat, GLfloat, GLfloat);
        alias pglProgramUniform3fv = void function(GLuint, GLint, GLsizei, const(GLfloat)*);
        alias pglProgramUniform3d = void function(GLuint, GLint, GLdouble, GLdouble, GLdouble);
        alias pglProgramUniform3dv = void function(GLuint, GLint, GLsizei, const(GLdouble)*);
        alias pglProgramUniform3ui = void function(GLuint, GLint, GLuint, GLuint, GLuint);
        alias pglProgramUniform3uiv = void function(GLuint, GLint, GLsizei, const(GLuint)*);
        alias pglProgramUniform4i = void function(GLuint, GLint, GLint, GLint, GLint, GLint);
        alias pglProgramUniform4iv = void function(GLuint, GLint, GLsizei, const(GLint)*);
        alias pglProgramUniform4f = void function(GLuint, GLint, GLfloat, GLfloat, GLfloat, GLfloat);
        alias pglProgramUniform4fv = void function(GLuint, GLint, GLsizei, const(GLfloat)*);
        alias pglProgramUniform4d = void function(GLuint, GLint, GLdouble, GLdouble, GLdouble, GLdouble);
        alias pglProgramUniform4dv = void function(GLuint, GLint, GLsizei, const(GLdouble)*);
        alias pglProgramUniform4ui = void function(GLuint, GLint, GLuint, GLuint, GLuint, GLuint);
        alias pglProgramUniform4uiv = void function(GLuint, GLint, GLsizei, const(GLuint)*);
        alias pglProgramUniformMatrix2fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix3fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix4fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix2dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix3dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix4dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix2x3fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix3x2fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix2x4fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix4x2fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix3x4fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix4x3fv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
        alias pglProgramUniformMatrix2x3dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix3x2dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix2x4dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix4x2dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix3x4dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglProgramUniformMatrix4x3dv = void function(GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
        alias pglValidateProgramPipeline = void function(GLuint);
        alias pglGetProgramPipelineInfoLog = void function(GLuint, GLsizei, GLsizei*, GLchar*);
    }

    __gshared {
        pglUseProgramStages glUseProgramStages;
        pglActiveShaderProgram glActiveShaderProgram;
        pglCreateShaderProgramv glCreateShaderProgramv;
        pglBindProgramPipeline glBindProgramPipeline;
        pglDeleteProgramPipelines glDeleteProgramPipelines;
        pglGenProgramPipelines glGenProgramPipelines;
        pglIsProgramPipeline glIsProgramPipeline;
        pglGetProgramPipelineiv glGetProgramPipelineiv;
        pglProgramUniform1i glProgramUniform1i;
        pglProgramUniform1iv glProgramUniform1iv;
        pglProgramUniform1f glProgramUniform1f;
        pglProgramUniform1fv glProgramUniform1fv;
        pglProgramUniform1d glProgramUniform1d;
        pglProgramUniform1dv glProgramUniform1dv;
        pglProgramUniform1ui glProgramUniform1ui;
        pglProgramUniform1uiv glProgramUniform1uiv;
        pglProgramUniform2i glProgramUniform2i;
        pglProgramUniform2iv glProgramUniform2iv;
        pglProgramUniform2f glProgramUniform2f;
        pglProgramUniform2fv glProgramUniform2fv;
        pglProgramUniform2d glProgramUniform2d;
        pglProgramUniform2dv glProgramUniform2dv;
        pglProgramUniform2ui glProgramUniform2ui;
        pglProgramUniform2uiv glProgramUniform2uiv;
        pglProgramUniform3i glProgramUniform3i;
        pglProgramUniform3iv glProgramUniform3iv;
        pglProgramUniform3f glProgramUniform3f;
        pglProgramUniform3fv glProgramUniform3fv;
        pglProgramUniform3d glProgramUniform3d;
        pglProgramUniform3dv glProgramUniform3dv;
        pglProgramUniform3ui glProgramUniform3ui;
        pglProgramUniform3uiv glProgramUniform3uiv;
        pglProgramUniform4i glProgramUniform4i;
        pglProgramUniform4iv glProgramUniform4iv;
        pglProgramUniform4f glProgramUniform4f;
        pglProgramUniform4fv glProgramUniform4fv;
        pglProgramUniform4d glProgramUniform4d;
        pglProgramUniform4dv glProgramUniform4dv;
        pglProgramUniform4ui glProgramUniform4ui;
        pglProgramUniform4uiv glProgramUniform4uiv;
        pglProgramUniformMatrix2fv glProgramUniformMatrix2fv;
        pglProgramUniformMatrix3fv glProgramUniformMatrix3fv;
        pglProgramUniformMatrix4fv glProgramUniformMatrix4fv;
        pglProgramUniformMatrix2dv glProgramUniformMatrix2dv;
        pglProgramUniformMatrix3dv glProgramUniformMatrix3dv;
        pglProgramUniformMatrix4dv glProgramUniformMatrix4dv;
        pglProgramUniformMatrix2x3fv glProgramUniformMatrix2x3fv;
        pglProgramUniformMatrix3x2fv glProgramUniformMatrix3x2fv;
        pglProgramUniformMatrix2x4fv glProgramUniformMatrix2x4fv;
        pglProgramUniformMatrix4x2fv glProgramUniformMatrix4x2fv;
        pglProgramUniformMatrix3x4fv glProgramUniformMatrix3x4fv;
        pglProgramUniformMatrix4x3fv glProgramUniformMatrix4x3fv;
        pglProgramUniformMatrix2x3dv glProgramUniformMatrix2x3dv;
        pglProgramUniformMatrix3x2dv glProgramUniformMatrix3x2dv;
        pglProgramUniformMatrix2x4dv glProgramUniformMatrix2x4dv;
        pglProgramUniformMatrix4x2dv glProgramUniformMatrix4x2dv;
        pglProgramUniformMatrix3x4dv glProgramUniformMatrix3x4dv;
        pglProgramUniformMatrix4x3dv glProgramUniformMatrix4x3dv;
        pglValidateProgramPipeline glValidateProgramPipeline;
        pglGetProgramPipelineInfoLog glGetProgramPipelineInfoLog;
    }

    private @nogc nothrow
    bool loadARBSeparateShaderObjects(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glUseProgramStages, "glUseProgramStages");
        lib.bindGLSymbol(cast(void**)&glActiveShaderProgram, "glActiveShaderProgram");
        lib.bindGLSymbol(cast(void**)&glCreateShaderProgramv, "glCreateShaderProgramv");
        lib.bindGLSymbol(cast(void**)&glBindProgramPipeline, "glBindProgramPipeline");
        lib.bindGLSymbol(cast(void**)&glDeleteProgramPipelines, "glDeleteProgramPipelines");
        lib.bindGLSymbol(cast(void**)&glGenProgramPipelines, "glGenProgramPipelines");
        lib.bindGLSymbol(cast(void**)&glIsProgramPipeline, "glIsProgramPipeline");
        lib.bindGLSymbol(cast(void**)&glGetProgramPipelineiv, "glGetProgramPipelineiv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1i, "glProgramUniform1i");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1iv, "glProgramUniform1iv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1f, "glProgramUniform1f");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1fv, "glProgramUniform1fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1d, "glProgramUniform1d");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1dv, "glProgramUniform1dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1ui, "glProgramUniform1ui");
        lib.bindGLSymbol(cast(void**)&glProgramUniform1uiv, "glProgramUniform1uiv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2i, "glProgramUniform2i");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2iv, "glProgramUniform2iv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2f, "glProgramUniform2f");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2fv, "glProgramUniform2fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2d, "glProgramUniform2d");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2dv, "glProgramUniform2dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2ui, "glProgramUniform2ui");
        lib.bindGLSymbol(cast(void**)&glProgramUniform2uiv, "glProgramUniform2uiv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3i, "glProgramUniform3i");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3iv, "glProgramUniform3iv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3f, "glProgramUniform3f");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3fv, "glProgramUniform3fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3d, "glProgramUniform3d");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3dv, "glProgramUniform3dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3ui, "glProgramUniform3ui");
        lib.bindGLSymbol(cast(void**)&glProgramUniform3uiv, "glProgramUniform3uiv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4i, "glProgramUniform4i");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4iv, "glProgramUniform4iv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4f, "glProgramUniform4f");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4fv, "glProgramUniform4fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4d, "glProgramUniform4d");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4dv, "glProgramUniform4dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4ui, "glProgramUniform4ui");
        lib.bindGLSymbol(cast(void**)&glProgramUniform4uiv, "glProgramUniform4uiv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2fv, "glProgramUniformMatrix2fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3fv, "glProgramUniformMatrix3fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4fv, "glProgramUniformMatrix4fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2dv, "glProgramUniformMatrix2dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3dv, "glProgramUniformMatrix3dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4dv, "glProgramUniformMatrix4dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2x3fv, "glProgramUniformMatrix2x3fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3x2fv, "glProgramUniformMatrix3x2fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2x4fv, "glProgramUniformMatrix2x4fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4x2fv, "glProgramUniformMatrix4x2fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3x4fv, "glProgramUniformMatrix3x4fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4x3fv, "glProgramUniformMatrix4x3fv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2x3dv, "glProgramUniformMatrix2x3dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3x2dv, "glProgramUniformMatrix3x2dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix2x4dv, "glProgramUniformMatrix2x4dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4x2dv, "glProgramUniformMatrix4x2dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix3x4dv, "glProgramUniformMatrix3x4dv");
        lib.bindGLSymbol(cast(void**)&glProgramUniformMatrix4x3dv, "glProgramUniformMatrix4x3dv");
        lib.bindGLSymbol(cast(void**)&glValidateProgramPipeline, "glValidateProgramPipeline");
        lib.bindGLSymbol(cast(void**)&glGetProgramPipelineInfoLog, "glGetProgramPipelineInfoLog");
        return resetErrorCountGL();
    }
}
else enum hasARBSeparateShaderObjects = false;

// ARB_vertex_attrib_64bit
version(GL_ARB) enum useARBVertexAttrib64Bit = true;
else version(GL_ARB_vertex_attrib_64bit) enum useARBVertexAttrib64Bit = true;
else enum useARBVertexAttrib64Bit = has41;

static if(useARBVertexAttrib64Bit) {
    private bool _hasARBVertexAttrib64Bit;
    bool hasARBVertexAttrib64Bit() { return _hasARBVertexAttrib64Bit; }

    extern(System) @nogc nothrow {
        alias pglVertexAttribL1d = void function(GLuint, GLdouble);
        alias pglVertexAttribL2d = void function(GLuint, GLdouble, GLdouble);
        alias pglVertexAttribL3d = void function(GLuint, GLdouble, GLdouble, GLdouble);
        alias pglVertexAttribL4d = void function(GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
        alias pglVertexAttribL1dv = void function(GLuint, const(GLdouble)*);
        alias pglVertexAttribL2dv = void function(GLuint, const(GLdouble)*);
        alias pglVertexAttribL3dv = void function(GLuint, const(GLdouble)*);
        alias pglVertexAttribL4dv = void function(GLuint, const(GLdouble)*);
        alias pglVertexAttribLPointer = void function(GLuint, GLint, GLenum, GLsizei, const(GLvoid)*);
        alias pglGetVertexAttribLdv = void function(GLuint, GLenum, GLdouble*);
    }

    __gshared {
        pglVertexAttribL1d glVertexAttribL1d;
        pglVertexAttribL2d glVertexAttribL2d;
        pglVertexAttribL3d glVertexAttribL3d;
        pglVertexAttribL4d glVertexAttribL4d;
        pglVertexAttribL1dv glVertexAttribL1dv;
        pglVertexAttribL2dv glVertexAttribL2dv;
        pglVertexAttribL3dv glVertexAttribL3dv;
        pglVertexAttribL4dv glVertexAttribL4dv;
        pglVertexAttribLPointer glVertexAttribLPointer;
        pglGetVertexAttribLdv glGetVertexAttribLdv;
    }

    private @nogc nothrow
    bool loadARBVertexAttrib64Bit(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glVertexAttribL1d, "glVertexAttribL1d");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL2d, "glVertexAttribL2d");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL3d, "glVertexAttribL3d");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL4d, "glVertexAttribL4d");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL1dv, "glVertexAttribL1dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL2dv, "glVertexAttribL2dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL3dv, "glVertexAttribL3dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttribL4dv, "glVertexAttribL4dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttribLPointer, "glVertexAttribLPointer");
        lib.bindGLSymbol(cast(void**)&glGetVertexAttribLdv, "glGetVertexAttribLdv");
        return resetErrorCountGL();
    }
}
else enum hasARBVertexAttrib64Bit = false;

// ARB_viewport_array
version(GL_ARB) enum useARBViewportArray = true;
else version(GL_ARB_viewport_array) enum useARBViewportArray = true;
else enum useARBViewportArray = has41;

static if(useARBViewportArray) {
    private bool _hasARBViewportArray;
    bool hasARBViewportArray() { return _hasARBViewportArray; }

    enum : uint {
        GL_MAX_VIEWPORTS                  = 0x825B,
        GL_VIEWPORT_SUBPIXEL_BITS         = 0x825C,
        GL_VIEWPORT_BOUNDS_RANGE          = 0x825D,
        GL_LAYER_PROVOKING_VERTEX         = 0x825E,
        GL_VIEWPORT_INDEX_PROVOKING_VERTEX = 0x825F,
        GL_UNDEFINED_VERTEX               = 0x8260,
    }

    extern(System) @nogc nothrow {
        alias pglViewportArrayv = void function(GLuint, GLsizei, const(GLfloat)*);
        alias pglViewportIndexedf = void function(GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
        alias pglViewportIndexedfv = void function(GLuint, const(GLfloat)*);
        alias pglScissorArrayv = void function(GLuint, GLsizei, const(GLint)*);
        alias pglScissorIndexed = void function(GLuint, GLint, GLint, GLsizei, GLsizei);
        alias pglScissorIndexedv = void function(GLuint, const(GLint)*);
        alias pglDepthRangeArrayv = void function(GLuint, GLsizei, const(GLclampd)*);
        alias pglDepthRangeIndexed = void function(GLuint, GLclampd, GLclampd);
        alias pglGetFloati_v = void function(GLenum, GLuint, GLfloat*);
        alias pglGetDoublei_v = void function(GLenum, GLuint, GLdouble*);
    }

    __gshared {
        pglViewportArrayv glViewportArrayv;
        pglViewportIndexedf glViewportIndexedf;
        pglViewportIndexedfv glViewportIndexedfv;
        pglScissorArrayv glScissorArrayv;
        pglScissorIndexed glScissorIndexed;
        pglScissorIndexedv glScissorIndexedv;
        pglDepthRangeArrayv glDepthRangeArrayv;
        pglDepthRangeIndexed glDepthRangeIndexed;
        pglGetFloati_v glGetFloati_v;
        pglGetDoublei_v glGetDoublei_v;
    }

    private @nogc nothrow
    bool loadARBViewportArray(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glViewportArrayv, "glViewportArrayv");
        lib.bindGLSymbol(cast(void**)&glViewportIndexedf, "glViewportIndexedf");
        lib.bindGLSymbol(cast(void**)&glViewportIndexedfv, "glViewportIndexedfv");
        lib.bindGLSymbol(cast(void**)&glScissorArrayv, "glScissorArrayv");
        lib.bindGLSymbol(cast(void**)&glScissorIndexed, "glScissorIndexed");
        lib.bindGLSymbol(cast(void**)&glScissorIndexedv, "glScissorIndexedv");
        lib.bindGLSymbol(cast(void**)&glDepthRangeArrayv, "glDepthRangeArrayv");
        lib.bindGLSymbol(cast(void**)&glDepthRangeIndexed, "glDepthRangeIndexed");
        lib.bindGLSymbol(cast(void**)&glGetFloati_v, "glGetFloati_v");
        lib.bindGLSymbol(cast(void**)&glGetDoublei_v, "glGetDoublei_v");
        return resetErrorCountGL();
    }
}
else enum hasARBViewportArray = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB41(SharedLib lib, GLSupport contextVersion)
{
    static if(has41) {
        if(contextVersion >= GLSupport.gl41) {
            bool ret = true;
            ret = _hasARBES2Compatibility = lib.loadARBES2Compatibility(contextVersion);
            ret = _hasARBGetProgramBinary = lib.loadARBGetProgramBinary(contextVersion);
            ret = _hasARBSeparateShaderObjects = lib.loadARBSeparateShaderObjects(contextVersion);
            ret = _hasARBVertexAttrib64Bit = lib.loadARBVertexAttrib64Bit(contextVersion);
            ret = _hasARBViewportArray = lib.loadARBViewportArray(contextVersion);
            return ret;
        }
    }

    static if(useARBES2Compatibility) _hasARBES2Compatibility =
            hasExtension(contextVersion, "GL_ARB_ES2_compatibility") &&
            lib.loadARBES2Compatibility(contextVersion);

    static if(useARBGetProgramBinary) _hasARBGetProgramBinary =
            hasExtension(contextVersion, "GL_ARB_get_program_binary") &&
            lib.loadARBGetProgramBinary(contextVersion);

    static if(useARBSeparateShaderObjects) _hasARBSeparateShaderObjects =
            hasExtension(contextVersion, "GL_ARB_separate_shader_objects") &&
            lib.loadARBSeparateShaderObjects(contextVersion);

    static if(useARBVertexAttrib64Bit) _hasARBVertexAttrib64Bit =
            hasExtension(contextVersion, "GL_ARB_vertex_attrib_64bit") &&
            lib.loadARBVertexAttrib64Bit(contextVersion);

    static if(useARBViewportArray) _hasARBViewportArray =
            hasExtension(contextVersion, "GL_ARB_viewport_array") &&
            lib.loadARBViewportArray(contextVersion);

    return true;
}