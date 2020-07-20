
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl20;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl15;
version(GL_AllowDeprecated)
    public import bindbc.opengl.bind.dep.dep20;

enum : uint {
    GL_BLEND_EQUATION_RGB             = 0x8009,
    GL_VERTEX_ATTRIB_ARRAY_ENABLED    = 0x8622,
    GL_VERTEX_ATTRIB_ARRAY_SIZE       = 0x8623,
    GL_VERTEX_ATTRIB_ARRAY_STRIDE     = 0x8624,
    GL_VERTEX_ATTRIB_ARRAY_TYPE       = 0x8625,
    GL_CURRENT_VERTEX_ATTRIB          = 0x8626,
    GL_VERTEX_PROGRAM_POINT_SIZE      = 0x8642,
    GL_VERTEX_ATTRIB_ARRAY_POINTER    = 0x8645,
    GL_STENCIL_BACK_FUNC              = 0x8800,
    GL_STENCIL_BACK_FAIL              = 0x8801,
    GL_STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802,
    GL_STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803,
    GL_MAX_DRAW_BUFFERS               = 0x8824,
    GL_DRAW_BUFFER0                   = 0x8825,
    GL_DRAW_BUFFER1                   = 0x8826,
    GL_DRAW_BUFFER2                   = 0x8827,
    GL_DRAW_BUFFER3                   = 0x8828,
    GL_DRAW_BUFFER4                   = 0x8829,
    GL_DRAW_BUFFER5                   = 0x882A,
    GL_DRAW_BUFFER6                   = 0x882B,
    GL_DRAW_BUFFER7                   = 0x882C,
    GL_DRAW_BUFFER8                   = 0x882D,
    GL_DRAW_BUFFER9                   = 0x882E,
    GL_DRAW_BUFFER10                  = 0x882F,
    GL_DRAW_BUFFER11                  = 0x8830,
    GL_DRAW_BUFFER12                  = 0x8831,
    GL_DRAW_BUFFER13                  = 0x8832,
    GL_DRAW_BUFFER14                  = 0x8833,
    GL_DRAW_BUFFER15                  = 0x8834,
    GL_BLEND_EQUATION_ALPHA           = 0x883D,
    GL_MAX_VERTEX_ATTRIBS             = 0x8869,
    GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A,
    GL_MAX_TEXTURE_IMAGE_UNITS        = 0x8872,
    GL_FRAGMENT_SHADER                = 0x8B30,
    GL_VERTEX_SHADER                  = 0x8B31,
    GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49,
    GL_MAX_VERTEX_UNIFORM_COMPONENTS  = 0x8B4A,
    GL_MAX_VARYING_FLOATS             = 0x8B4B,
    GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C,
    GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D,
    GL_SHADER_TYPE                    = 0x8B4F,
    GL_FLOAT_VEC2                     = 0x8B50,
    GL_FLOAT_VEC3                     = 0x8B51,
    GL_FLOAT_VEC4                     = 0x8B52,
    GL_INT_VEC2                       = 0x8B53,
    GL_INT_VEC3                       = 0x8B54,
    GL_INT_VEC4                       = 0x8B55,
    GL_BOOL                           = 0x8B56,
    GL_BOOL_VEC2                      = 0x8B57,
    GL_BOOL_VEC3                      = 0x8B58,
    GL_BOOL_VEC4                      = 0x8B59,
    GL_FLOAT_MAT2                     = 0x8B5A,
    GL_FLOAT_MAT3                     = 0x8B5B,
    GL_FLOAT_MAT4                     = 0x8B5C,
    GL_SAMPLER_1D                     = 0x8B5D,
    GL_SAMPLER_2D                     = 0x8B5E,
    GL_SAMPLER_3D                     = 0x8B5F,
    GL_SAMPLER_CUBE                   = 0x8B60,
    GL_SAMPLER_1D_SHADOW              = 0x8B61,
    GL_SAMPLER_2D_SHADOW              = 0x8B62,
    GL_DELETE_STATUS                  = 0x8B80,
    GL_COMPILE_STATUS                 = 0x8B81,
    GL_LINK_STATUS                    = 0x8B82,
    GL_VALIDATE_STATUS                = 0x8B83,
    GL_INFO_LOG_LENGTH                = 0x8B84,
    GL_ATTACHED_SHADERS               = 0x8B85,
    GL_ACTIVE_UNIFORMS                = 0x8B86,
    GL_ACTIVE_UNIFORM_MAX_LENGTH      = 0x8B87,
    GL_SHADER_SOURCE_LENGTH           = 0x8B88,
    GL_ACTIVE_ATTRIBUTES              = 0x8B89,
    GL_ACTIVE_ATTRIBUTE_MAX_LENGTH    = 0x8B8A,
    GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B,
    GL_SHADING_LANGUAGE_VERSION       = 0x8B8C,
    GL_CURRENT_PROGRAM                = 0x8B8D,
    GL_POINT_SPRITE_COORD_ORIGIN      = 0x8CA0,
    GL_LOWER_LEFT                     = 0x8CA1,
    GL_UPPER_LEFT                     = 0x8CA2,
    GL_STENCIL_BACK_REF               = 0x8CA3,
    GL_STENCIL_BACK_VALUE_MASK        = 0x8CA4,
    GL_STENCIL_BACK_WRITEMASK         = 0x8CA5,
}

extern(System) @nogc nothrow {
    alias pglBlendEquationSeparate = void function(GLenum,GLenum);
    alias pglDrawBuffers = void function(GLsizei,const(GLenum)*);
    alias pglStencilOpSeparate = void function(GLenum,GLenum,GLenum,GLenum);
    alias pglStencilFuncSeparate = void function(GLenum,GLenum,GLint,GLuint);
    alias pglStencilMaskSeparate = void function(GLenum,GLuint);
    alias pglAttachShader = void function(GLuint,GLuint);
    alias pglBindAttribLocation = void function(GLuint,GLuint,const(GLchar)*);
    alias pglCompileShader = void function(GLuint);
    alias pglCreateProgram = GLuint function();
    alias pglCreateShader = GLuint function(GLenum);
    alias pglDeleteProgram = void function(GLuint);
    alias pglDeleteShader = void function(GLuint);
    alias pglDetachShader = void function(GLuint,GLuint);
    alias pglDisableVertexAttribArray = void function(GLuint);
    alias pglEnableVertexAttribArray = void function(GLuint);
    alias pglGetActiveAttrib = void function(GLuint,GLuint,GLsizei,GLsizei*,GLint*,GLenum*,GLchar*);
    alias pglGetActiveUniform = void function(GLuint,GLuint,GLsizei,GLsizei*,GLint*,GLenum*,GLchar*);
    alias pglGetAttachedShaders = void function(GLuint,GLsizei,GLsizei*,GLuint*);
    alias pglGetAttribLocation = GLint function(GLuint,const(GLchar)*);
    alias pglGetProgramiv = void function(GLuint,GLenum,GLint*);
    alias pglGetProgramInfoLog = void function(GLuint,GLsizei,GLsizei*,GLchar*);
    alias pglGetShaderiv = void function(GLuint,GLenum,GLint*);
    alias pglGetShaderInfoLog = void function(GLuint,GLsizei,GLsizei*,GLchar*);
    alias pglGetShaderSource = void function(GLuint,GLsizei,GLsizei*,GLchar*);
    alias pglGetUniformLocation = GLint function(GLuint,const(GLchar)*);
    alias pglGetUniformfv = void function(GLuint,GLint,GLfloat*);
    alias pglGetUniformiv = void function(GLuint,GLint,GLint*);
    alias pglGetVertexAttribdv = void function(GLuint,GLenum,GLdouble*);
    alias pglGetVertexAttribfv = void function(GLuint,GLenum,GLfloat*);
    alias pglGetVertexAttribiv = void function(GLuint,GLenum,GLint*);
    alias pglGetVertexAttribPointerv = void function(GLuint,GLenum,GLvoid*);
    alias pglIsProgram = GLboolean function(GLuint);
    alias pglIsShader = GLboolean function(GLuint);
    alias pglLinkProgram = void function(GLuint);
    alias pglShaderSource = void function(GLuint,GLsizei,const(GLchar*)*,const(GLint)*);
    alias pglUseProgram = void function(GLuint);
    alias pglUniform1f = void function(GLint,GLfloat);
    alias pglUniform2f = void function(GLint,GLfloat,GLfloat);
    alias pglUniform3f = void function(GLint,GLfloat,GLfloat,GLfloat);
    alias pglUniform4f = void function(GLint,GLfloat,GLfloat,GLfloat,GLfloat);
    alias pglUniform1i = void function(GLint,GLint);
    alias pglUniform2i = void function(GLint,GLint,GLint);
    alias pglUniform3i = void function(GLint,GLint,GLint,GLint);
    alias pglUniform4i = void function(GLint,GLint,GLint,GLint,GLint);
    alias pglUniform1fv = void function(GLint,GLsizei,const(GLfloat)*);
    alias pglUniform2fv = void function(GLint,GLsizei,const(GLfloat)*);
    alias pglUniform3fv = void function(GLint,GLsizei,const(GLfloat)*);
    alias pglUniform4fv = void function(GLint,GLsizei,const(GLfloat)*);
    alias pglUniform1iv = void function(GLint,GLsizei,const(GLint)*);
    alias pglUniform2iv = void function(GLint,GLsizei,const(GLint)*);
    alias pglUniform3iv = void function(GLint,GLsizei,const(GLint)*);
    alias pglUniform4iv = void function(GLint,GLsizei,const(GLint)*);
    alias pglUniformMatrix2fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix3fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglUniformMatrix4fv = void function(GLint,GLsizei,GLboolean,const(GLfloat)*);
    alias pglValidateProgram = void function(GLuint);
    alias pglVertexAttrib1d = void function(GLuint,GLdouble);
    alias pglVertexAttrib1dv = void function(GLuint,const(GLdouble)*);
    alias pglVertexAttrib1f = void function(GLuint,GLfloat);
    alias pglVertexAttrib1fv = void function(GLuint,const(GLfloat)*);
    alias pglVertexAttrib1s = void function(GLuint,GLshort);
    alias pglVertexAttrib1sv = void function(GLuint,const(GLshort)*);
    alias pglVertexAttrib2d = void function(GLuint,GLdouble,GLdouble);
    alias pglVertexAttrib2dv = void function(GLuint,const(GLdouble)*);
    alias pglVertexAttrib2f = void function(GLuint,GLfloat,GLfloat);
    alias pglVertexAttrib2fv = void function(GLuint,const(GLfloat)*);
    alias pglVertexAttrib2s = void function(GLuint,GLshort,GLshort);
    alias pglVertexAttrib2sv = void function(GLuint,const(GLshort)*);
    alias pglVertexAttrib3d = void function(GLuint,GLdouble,GLdouble,GLdouble);
    alias pglVertexAttrib3dv = void function(GLuint,const(GLdouble)*);
    alias pglVertexAttrib3f = void function(GLuint,GLfloat,GLfloat,GLfloat);
    alias pglVertexAttrib3fv = void function(GLuint,const(GLfloat)*);
    alias pglVertexAttrib3s = void function(GLuint,GLshort,GLshort,GLshort);
    alias pglVertexAttrib3sv = void function(GLuint,const(GLshort)*);
    alias pglVertexAttrib4Nbv = void function(GLuint,const(GLbyte)*);
    alias pglVertexAttrib4Niv = void function(GLuint,const(GLint)*);
    alias pglVertexAttrib4Nsv = void function(GLuint,const(GLshort)*);
    alias pglVertexAttrib4Nub = void function(GLuint,GLubyte,GLubyte,GLubyte,GLubyte);
    alias pglVertexAttrib4Nubv = void function(GLuint,const(GLubyte)*);
    alias pglVertexAttrib4Nuiv = void function(GLuint,const(GLuint)*);
    alias pglVertexAttrib4Nusv = void function(GLuint,const(GLushort)*);
    alias pglVertexAttrib4bv = void function(GLuint,const(GLbyte)*);
    alias pglVertexAttrib4d = void function(GLuint,GLdouble,GLdouble,GLdouble,GLdouble);
    alias pglVertexAttrib4dv = void function(GLuint,const(GLdouble)*);
    alias pglVertexAttrib4f = void function(GLuint,GLfloat,GLfloat,GLfloat,GLfloat);
    alias pglVertexAttrib4fv = void function(GLuint,const(GLfloat)*);
    alias pglVertexAttrib4iv = void function(GLuint,const(GLint)*);
    alias pglVertexAttrib4s = void function(GLuint,GLshort,GLshort,GLshort,GLshort);
    alias pglVertexAttrib4sv = void function(GLuint,const(GLshort)*);
    alias pglVertexAttrib4ubv = void function(GLuint,const(GLubyte)*);
    alias pglVertexAttrib4uiv = void function(GLuint,const(GLuint)*);
    alias pglVertexAttrib4usv = void function(GLuint,const(GLushort)*);
    alias pglVertexAttribPointer = void function(GLuint,GLint,GLenum,GLboolean,GLsizei,const(GLvoid)*);
}

__gshared {
    pglBlendEquationSeparate glBlendEquationSeparate;
    pglDrawBuffers glDrawBuffers;
    pglStencilOpSeparate glStencilOpSeparate;
    pglStencilFuncSeparate glStencilFuncSeparate;
    pglStencilMaskSeparate glStencilMaskSeparate;
    pglAttachShader glAttachShader;
    pglBindAttribLocation glBindAttribLocation;
    pglCompileShader glCompileShader;
    pglCreateProgram glCreateProgram;
    pglCreateShader glCreateShader;
    pglDeleteProgram glDeleteProgram;
    pglDeleteShader glDeleteShader;
    pglDetachShader glDetachShader;
    pglDisableVertexAttribArray glDisableVertexAttribArray;
    pglEnableVertexAttribArray glEnableVertexAttribArray;
    pglGetActiveAttrib glGetActiveAttrib;
    pglGetActiveUniform glGetActiveUniform;
    pglGetAttachedShaders glGetAttachedShaders;
    pglGetAttribLocation glGetAttribLocation;
    pglGetProgramiv glGetProgramiv;
    pglGetProgramInfoLog glGetProgramInfoLog;
    pglGetShaderiv glGetShaderiv;
    pglGetShaderInfoLog glGetShaderInfoLog;
    pglGetShaderSource glGetShaderSource;
    pglGetUniformLocation glGetUniformLocation;
    pglGetUniformfv glGetUniformfv;
    pglGetUniformiv glGetUniformiv;
    pglGetVertexAttribdv glGetVertexAttribdv;
    pglGetVertexAttribfv glGetVertexAttribfv;
    pglGetVertexAttribiv glGetVertexAttribiv;
    pglGetVertexAttribPointerv glGetVertexAttribPointerv;
    pglIsProgram glIsProgram;
    pglIsShader glIsShader;
    pglLinkProgram glLinkProgram;
    pglShaderSource glShaderSource;
    pglUseProgram glUseProgram;
    pglUniform1f glUniform1f;
    pglUniform2f glUniform2f;
    pglUniform3f glUniform3f;
    pglUniform4f glUniform4f;
    pglUniform1i glUniform1i;
    pglUniform2i glUniform2i;
    pglUniform3i glUniform3i;
    pglUniform4i glUniform4i;
    pglUniform1fv glUniform1fv;
    pglUniform2fv glUniform2fv;
    pglUniform3fv glUniform3fv;
    pglUniform4fv glUniform4fv;
    pglUniform1iv glUniform1iv;
    pglUniform2iv glUniform2iv;
    pglUniform3iv glUniform3iv;
    pglUniform4iv glUniform4iv;
    pglUniformMatrix2fv glUniformMatrix2fv;
    pglUniformMatrix3fv glUniformMatrix3fv;
    pglUniformMatrix4fv glUniformMatrix4fv;
    pglValidateProgram glValidateProgram;
    pglVertexAttrib1d glVertexAttrib1d;
    pglVertexAttrib1dv glVertexAttrib1dv;
    pglVertexAttrib1f glVertexAttrib1f;
    pglVertexAttrib1fv glVertexAttrib1fv;
    pglVertexAttrib1s glVertexAttrib1s;
    pglVertexAttrib1sv glVertexAttrib1sv;
    pglVertexAttrib2d glVertexAttrib2d;
    pglVertexAttrib2dv glVertexAttrib2dv;
    pglVertexAttrib2f glVertexAttrib2f;
    pglVertexAttrib2fv glVertexAttrib2fv;
    pglVertexAttrib2s glVertexAttrib2s;
    pglVertexAttrib2sv glVertexAttrib2sv;
    pglVertexAttrib3d glVertexAttrib3d;
    pglVertexAttrib3dv glVertexAttrib3dv;
    pglVertexAttrib3f glVertexAttrib3f;
    pglVertexAttrib3fv glVertexAttrib3fv;
    pglVertexAttrib3s glVertexAttrib3s;
    pglVertexAttrib3sv glVertexAttrib3sv;
    pglVertexAttrib4Nbv glVertexAttrib4Nbv;
    pglVertexAttrib4Niv glVertexAttrib4Niv;
    pglVertexAttrib4Nsv glVertexAttrib4Nsv;
    pglVertexAttrib4Nub glVertexAttrib4Nub;
    pglVertexAttrib4Nubv glVertexAttrib4Nubv;
    pglVertexAttrib4Nuiv glVertexAttrib4Nuiv;
    pglVertexAttrib4Nusv glVertexAttrib4Nusv;
    pglVertexAttrib4bv glVertexAttrib4bv;
    pglVertexAttrib4d glVertexAttrib4d;
    pglVertexAttrib4dv glVertexAttrib4dv;
    pglVertexAttrib4f glVertexAttrib4f;
    pglVertexAttrib4fv glVertexAttrib4fv;
    pglVertexAttrib4iv glVertexAttrib4iv;
    pglVertexAttrib4s glVertexAttrib4s;
    pglVertexAttrib4sv glVertexAttrib4sv;
    pglVertexAttrib4ubv glVertexAttrib4ubv;
    pglVertexAttrib4uiv glVertexAttrib4uiv;
    pglVertexAttrib4usv glVertexAttrib4usv;
    pglVertexAttribPointer glVertexAttribPointer;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL20(SharedLib lib, GLSupport contextVersion)
{
    if(contextVersion > GLSupport.gl15) {
        lib.bindGLSymbol(cast(void**)&glBlendEquationSeparate, "glBlendEquationSeparate");
        lib.bindGLSymbol(cast(void**)&glDrawBuffers, "glDrawBuffers");
        lib.bindGLSymbol(cast(void**)&glStencilOpSeparate, "glStencilOpSeparate");
        lib.bindGLSymbol(cast(void**)&glStencilFuncSeparate, "glStencilFuncSeparate");
        lib.bindGLSymbol(cast(void**)&glStencilMaskSeparate, "glStencilMaskSeparate");
        lib.bindGLSymbol(cast(void**)&glAttachShader, "glAttachShader");
        lib.bindGLSymbol(cast(void**)&glBindAttribLocation, "glBindAttribLocation");
        lib.bindGLSymbol(cast(void**)&glCompileShader, "glCompileShader");
        lib.bindGLSymbol(cast(void**)&glCreateProgram, "glCreateProgram");
        lib.bindGLSymbol(cast(void**)&glCreateShader, "glCreateShader");
        lib.bindGLSymbol(cast(void**)&glDeleteProgram, "glDeleteProgram");
        lib.bindGLSymbol(cast(void**)&glDeleteShader, "glDeleteShader");
        lib.bindGLSymbol(cast(void**)&glDetachShader, "glDetachShader");
        lib.bindGLSymbol(cast(void**)&glDisableVertexAttribArray, "glDisableVertexAttribArray");
        lib.bindGLSymbol(cast(void**)&glEnableVertexAttribArray, "glEnableVertexAttribArray");
        lib.bindGLSymbol(cast(void**)&glGetActiveAttrib, "glGetActiveAttrib");
        lib.bindGLSymbol(cast(void**)&glGetActiveUniform, "glGetActiveUniform");
        lib.bindGLSymbol(cast(void**)&glGetAttachedShaders, "glGetAttachedShaders");
        lib.bindGLSymbol(cast(void**)&glGetAttribLocation, "glGetAttribLocation");
        lib.bindGLSymbol(cast(void**)&glGetProgramiv, "glGetProgramiv");
        lib.bindGLSymbol(cast(void**)&glGetProgramInfoLog, "glGetProgramInfoLog");
        lib.bindGLSymbol(cast(void**)&glGetShaderiv, "glGetShaderiv");
        lib.bindGLSymbol(cast(void**)&glGetShaderInfoLog, "glGetShaderInfoLog");
        lib.bindGLSymbol(cast(void**)&glGetShaderSource, "glGetShaderSource");
        lib.bindGLSymbol(cast(void**)&glGetUniformLocation, "glGetUniformLocation");
        lib.bindGLSymbol(cast(void**)&glGetUniformfv, "glGetUniformfv");
        lib.bindGLSymbol(cast(void**)&glGetUniformiv, "glGetUniformiv");
        lib.bindGLSymbol(cast(void**)&glGetVertexAttribdv, "glGetVertexAttribdv");
        lib.bindGLSymbol(cast(void**)&glGetVertexAttribfv, "glGetVertexAttribfv");
        lib.bindGLSymbol(cast(void**)&glGetVertexAttribiv, "glGetVertexAttribiv");
        lib.bindGLSymbol(cast(void**)&glGetVertexAttribPointerv, "glGetVertexAttribPointerv");
        lib.bindGLSymbol(cast(void**)&glIsProgram, "glIsProgram");
        lib.bindGLSymbol(cast(void**)&glIsShader, "glIsShader");
        lib.bindGLSymbol(cast(void**)&glLinkProgram, "glLinkProgram");
        lib.bindGLSymbol(cast(void**)&glShaderSource, "glShaderSource");
        lib.bindGLSymbol(cast(void**)&glUseProgram, "glUseProgram");
        lib.bindGLSymbol(cast(void**)&glUniform1f, "glUniform1f");
        lib.bindGLSymbol(cast(void**)&glUniform2f, "glUniform2f");
        lib.bindGLSymbol(cast(void**)&glUniform3f, "glUniform3f");
        lib.bindGLSymbol(cast(void**)&glUniform4f, "glUniform4f");
        lib.bindGLSymbol(cast(void**)&glUniform1i, "glUniform1i");
        lib.bindGLSymbol(cast(void**)&glUniform2i, "glUniform2i");
        lib.bindGLSymbol(cast(void**)&glUniform3i, "glUniform3i");
        lib.bindGLSymbol(cast(void**)&glUniform4i, "glUniform4i");
        lib.bindGLSymbol(cast(void**)&glUniform1fv, "glUniform1fv");
        lib.bindGLSymbol(cast(void**)&glUniform2fv, "glUniform2fv");
        lib.bindGLSymbol(cast(void**)&glUniform3fv, "glUniform3fv");
        lib.bindGLSymbol(cast(void**)&glUniform4fv, "glUniform4fv");
        lib.bindGLSymbol(cast(void**)&glUniform1iv, "glUniform1iv");
        lib.bindGLSymbol(cast(void**)&glUniform2iv, "glUniform2iv");
        lib.bindGLSymbol(cast(void**)&glUniform3iv, "glUniform3iv");
        lib.bindGLSymbol(cast(void**)&glUniform4iv, "glUniform4iv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix2fv, "glUniformMatrix2fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix3fv, "glUniformMatrix3fv");
        lib.bindGLSymbol(cast(void**)&glUniformMatrix4fv, "glUniformMatrix4fv");
        lib.bindGLSymbol(cast(void**)&glValidateProgram, "glValidateProgram");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1d, "glVertexAttrib1d");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1dv, "glVertexAttrib1dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1f, "glVertexAttrib1f");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1fv, "glVertexAttrib1fv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1s, "glVertexAttrib1s");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib1sv, "glVertexAttrib1sv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2d, "glVertexAttrib2d");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2dv, "glVertexAttrib2dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2f, "glVertexAttrib2f");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2fv, "glVertexAttrib2fv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2s, "glVertexAttrib2s");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib2sv, "glVertexAttrib2sv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3d, "glVertexAttrib3d");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3dv, "glVertexAttrib3dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3f, "glVertexAttrib3f");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3fv, "glVertexAttrib3fv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3s, "glVertexAttrib3s");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib3sv, "glVertexAttrib3sv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nbv, "glVertexAttrib4Nbv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Niv, "glVertexAttrib4Niv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nsv, "glVertexAttrib4Nsv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nub, "glVertexAttrib4Nub");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nubv, "glVertexAttrib4Nubv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nuiv, "glVertexAttrib4Nuiv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4Nusv, "glVertexAttrib4Nusv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4bv, "glVertexAttrib4bv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4d, "glVertexAttrib4d");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4dv, "glVertexAttrib4dv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4f, "glVertexAttrib4f");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4fv, "glVertexAttrib4fv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4iv, "glVertexAttrib4iv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4s, "glVertexAttrib4s");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4sv, "glVertexAttrib4sv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4ubv, "glVertexAttrib4ubv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4uiv, "glVertexAttrib4uiv");
        lib.bindGLSymbol(cast(void**)&glVertexAttrib4usv, "glVertexAttrib4usv");
        lib.bindGLSymbol(cast(void**)&glVertexAttribPointer, "glVertexAttribPointer");
        if(errorCountGL() == 0) return true;
    }
    return false;
}