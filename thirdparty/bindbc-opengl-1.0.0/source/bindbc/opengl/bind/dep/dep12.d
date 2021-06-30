
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep12;

import bindbc.loader;
import bindbc.opengl.context;
import bindbc.opengl.bind.types;

version(GL_AllowDeprecated) {
    enum : uint {
        GL_RESCALE_NORMAL                 = 0x803A,
        GL_LIGHT_MODEL_COLOR_CONTROL      = 0x81F8,
        GL_SINGLE_COLOR                   = 0x81F9,
        GL_SEPARATE_SPECULAR_COLOR        = 0x81FA,
        GL_ALIASED_POINT_SIZE_RANGE       = 0x846D,
        GL_CONVOLUTION_1D                 = 0x8010,
        GL_CONVOLUTION_2D                 = 0x8011,
        GL_SEPARABLE_2D                   = 0x8012,
        GL_CONVOLUTION_BORDER_MODE        = 0x8013,
        GL_CONVOLUTION_FILTER_SCALE       = 0x8014,
        GL_CONVOLUTION_FILTER_BIAS        = 0x8015,
        GL_REDUCE                         = 0x8016,
        GL_CONVOLUTION_FORMAT             = 0x8017,
        GL_CONVOLUTION_WIDTH              = 0x8018,
        GL_CONVOLUTION_HEIGHT             = 0x8019,
        GL_MAX_CONVOLUTION_WIDTH          = 0x801A,
        GL_MAX_CONVOLUTION_HEIGHT         = 0x801B,
        GL_POST_CONVOLUTION_RED_SCALE     = 0x801C,
        GL_POST_CONVOLUTION_GREEN_SCALE   = 0x801D,
        GL_POST_CONVOLUTION_BLUE_SCALE    = 0x801E,
        GL_POST_CONVOLUTION_ALPHA_SCALE   = 0x801F,
        GL_POST_CONVOLUTION_RED_BIAS      = 0x8020,
        GL_POST_CONVOLUTION_GREEN_BIAS    = 0x8021,
        GL_POST_CONVOLUTION_BLUE_BIAS     = 0x8022,
        GL_POST_CONVOLUTION_ALPHA_BIAS    = 0x8023,
        GL_HISTOGRAM                      = 0x8024,
        GL_PROXY_HISTOGRAM                = 0x8025,
        GL_HISTOGRAM_WIDTH                = 0x8026,
        GL_HISTOGRAM_FORMAT               = 0x8027,
        GL_HISTOGRAM_RED_SIZE             = 0x8028,
        GL_HISTOGRAM_GREEN_SIZE           = 0x8029,
        GL_HISTOGRAM_BLUE_SIZE            = 0x802A,
        GL_HISTOGRAM_ALPHA_SIZE           = 0x802B,
        GL_HISTOGRAM_LUMINANCE_SIZE       = 0x802C,
        GL_HISTOGRAM_SINK                 = 0x802D,
        GL_MINMAX                         = 0x802E,
        GL_MINMAX_FORMAT                  = 0x802F,
        GL_MINMAX_SINK                    = 0x8030,
        GL_TABLE_TOO_LARGE                = 0x8031,
        GL_COLOR_MATRIX                   = 0x80B1,
        GL_COLOR_MATRIX_STACK_DEPTH       = 0x80B2,
        GL_MAX_COLOR_MATRIX_STACK_DEPTH   = 0x80B3,
        GL_POST_COLOR_MATRIX_RED_SCALE    = 0x80B4,
        GL_POST_COLOR_MATRIX_GREEN_SCALE  = 0x80B5,
        GL_POST_COLOR_MATRIX_BLUE_SCALE   = 0x80B6,
        GL_POST_COLOR_MATRIX_ALPHA_SCALE  = 0x80B7,
        GL_POST_COLOR_MATRIX_RED_BIAS     = 0x80B8,
        GL_POST_COLOR_MATRIX_GREEN_BIAS   = 0x80B9,
        GL_POST_COLOR_MATRIX_BLUE_BIAS    = 0x80BA,
        GL_POST_COLOR_MATRIX_ALPHA_BIAS   = 0x80BB,
        GL_COLOR_TABLE                    = 0x80D0,
        GL_POST_CONVOLUTION_COLOR_TABLE   = 0x80D1,
        GL_POST_COLOR_MATRIX_COLOR_TABLE  = 0x80D2,
        GL_PROXY_COLOR_TABLE              = 0x80D3,
        GL_PROXY_POST_CONVOLUTION_COLOR_TABLE = 0x80D4,
        GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE = 0x80D5,
        GL_COLOR_TABLE_SCALE              = 0x80D6,
        GL_COLOR_TABLE_BIAS               = 0x80D7,
        GL_COLOR_TABLE_FORMAT             = 0x80D8,
        GL_COLOR_TABLE_WIDTH              = 0x80D9,
        GL_COLOR_TABLE_RED_SIZE           = 0x80DA,
        GL_COLOR_TABLE_GREEN_SIZE         = 0x80DB,
        GL_COLOR_TABLE_BLUE_SIZE          = 0x80DC,
        GL_COLOR_TABLE_ALPHA_SIZE         = 0x80DD,
        GL_COLOR_TABLE_LUMINANCE_SIZE     = 0x80DE,
        GL_COLOR_TABLE_INTENSITY_SIZE     = 0x80DF,
        GL_CONSTANT_BORDER                = 0x8151,
        GL_REPLICATE_BORDER               = 0x8153,
        GL_CONVOLUTION_BORDER_COLOR       = 0x8154,
    }

    extern(System) @nogc nothrow {
        alias pglColorTable = void function(GLenum, GLenum, GLsizei, GLenum, GLenum, const(void)*);
        alias pglColorSubTable = void function(GLenum, GLsizei, GLsizei, GLenum, GLenum, const(void)*);
        alias pglColorTableParameteriv = void function(GLenum, GLenum, const(GLint)*);
        alias pglColorTableParameterfv = void function(GLenum, GLenum, const(GLfloat)*);
        alias pglCopyColorSubTable = void function(GLenum, GLsizei, GLint, GLint, GLsizei);
        alias pglCopyColorTable = void function(GLenum, GLenum, GLint, GLint, GLsizei);
        alias pglGetColorTable = void function(GLenum, GLenum, GLenum, void*);
        alias pglGetColorTableParameterfv = void function(GLenum, GLenum, GLfloat*);
        alias pglGetColorTableParameteriv = void function(GLenum, GLenum, GLint*);
        alias pglHistogram = void function(GLenum, GLsizei, GLenum, GLboolean);
        alias pglResetHistogram = void function(GLenum);
        alias pglGetHistogram = void function(GLenum, GLboolean, GLenum, GLenum, void*);
        alias pglGetHistogramParameterfv = void function(GLenum, GLenum, GLfloat*);
        alias pglGetHistogramParameteriv = void function(GLenum, GLenum, GLint*);
        alias pglMinmax = void function(GLenum, GLenum, GLboolean);
        alias pglResetMinmax = void function(GLenum);
        alias pglGetMinmax = void function(GLenum, GLboolean, GLenum, GLenum, void*);
        alias pglGetMinmaxParameterfv = void function(GLenum, GLenum, GLfloat*);
        alias pglGetMinmaxParameteriv = void function(GLenum, GLenum, GLint*);
        alias pglConvolutionFilter1D = void function(GLenum, GLenum, GLsizei, GLenum, GLenum, const(void)*);
        alias pglConvolutionFilter2D = void function(GLenum, GLenum, GLsizei, GLsizei, GLenum, GLenum, const(void)*);
        alias pglConvolutionParameterf = void function(GLenum, GLenum, GLfloat);
        alias pglConvolutionParameterfv = void function(GLenum, GLenum, const(GLfloat)*);
        alias pglConvolutionParameteri = void function(GLenum, GLenum, GLint);
        alias pglConvolutionParameteriv = void function(GLenum, GLenum, const(GLint)*);
        alias pglCopyConvolutionFilter1D = void function(GLenum, GLenum, GLint, GLint, GLsizei);
        alias pglCopyConvolutionFilter2D = void function(GLenum, GLenum, GLint, GLint, GLsizei, GLsizei);
        alias pglGetConvolutionFilter = void function(GLenum, GLenum, GLenum, void*);
        alias pglGetConvolutionParameterfv = void function(GLenum, GLenum, GLfloat*);
        alias pglGetConvolutionParameteriv = void function(GLenum, GLenum, GLint*);
        alias pglSeparableFilter2D = void function(GLenum, GLenum, GLsizei, GLsizei, GLenum, GLenum, const(void)*, const(void)*);
        alias pglGetSeparableFilter = void function(GLenum, GLenum, GLenum, void*, void*, void*);
    }

    __gshared {
        pglColorTable glColorTable;
        pglColorSubTable glColorSubTable;
        pglColorTableParameteriv glColorTableParameteriv;
        pglColorTableParameterfv glColorTableParameterfv;
        pglCopyColorSubTable glCopyColorSubTable;
        pglCopyColorTable glCopyColorTable;
        pglGetColorTable glGetColorTable;
        pglGetColorTableParameterfv glGetColorTableParameterfv;
        pglGetColorTableParameteriv glGetColorTableParameteriv;
        pglHistogram glHistogram;
        pglResetHistogram glResetHistogram;
        pglGetHistogram glGetHistogram;
        pglGetHistogramParameterfv glGetHistogramParameterfv;
        pglGetHistogramParameteriv glGetHistogramParameteriv;
        pglMinmax glMinmax;
        pglResetMinmax glResetMinmax;
        pglGetMinmax glGetMinmax;
        pglGetMinmaxParameterfv glGetMinmaxParameterfv;
        pglGetMinmaxParameteriv glGetMinmaxParameteriv;
        pglConvolutionFilter1D glConvolutionFilter1D;
        pglConvolutionFilter2D glConvolutionFilter2D;
        pglConvolutionParameterf glConvolutionParameterf;
        pglConvolutionParameterfv glConvolutionParameterfv;
        pglConvolutionParameteri glConvolutionParameteri;
        pglConvolutionParameteriv glConvolutionParameteriv;
        pglCopyConvolutionFilter1D glCopyConvolutionFilter1D;
        pglCopyConvolutionFilter2D glCopyConvolutionFilter2D;
        pglGetConvolutionFilter glGetConvolutionFilter;
        pglGetConvolutionParameterfv glGetConvolutionParameterfv;
        pglGetConvolutionParameteriv glGetConvolutionParameteriv;
        pglSeparableFilter2D glSeparableFilter2D;
        pglGetSeparableFilter glGetSeparableFilter;
    }

    package(bindbc.opengl.bind) @nogc nothrow
    bool loadDeprecatedGL12(SharedLib lib)
    {
        lib.bindGLSymbol(cast(void**)&glColorTable, "glColorTable");
        lib.bindGLSymbol(cast(void**)&glColorSubTable, "glColorSubTable");
        lib.bindGLSymbol(cast(void**)&glColorTableParameteriv, "glColorTableParameteriv");
        lib.bindGLSymbol(cast(void**)&glColorTableParameterfv, "glColorTableParameterfv");
        lib.bindGLSymbol(cast(void**)&glCopyColorSubTable, "glCopyColorSubTable");
        lib.bindGLSymbol(cast(void**)&glCopyColorTable, "glCopyColorTable");
        lib.bindGLSymbol(cast(void**)&glGetColorTable, "glGetColorTable");
        lib.bindGLSymbol(cast(void**)&glGetColorTableParameterfv, "glGetColorTableParameterfv");
        lib.bindGLSymbol(cast(void**)&glGetColorTableParameteriv, "glGetColorTableParameteriv");
        lib.bindGLSymbol(cast(void**)&glHistogram, "glHistogram");
        lib.bindGLSymbol(cast(void**)&glResetHistogram, "glResetHistogram");
        lib.bindGLSymbol(cast(void**)&glGetHistogram, "glGetHistogram");
        lib.bindGLSymbol(cast(void**)&glGetHistogramParameterfv, "glGetHistogramParameterfv");
        lib.bindGLSymbol(cast(void**)&glGetHistogramParameteriv, "glGetHistogramParameteriv");
        lib.bindGLSymbol(cast(void**)&glMinmax, "glMinmax");
        lib.bindGLSymbol(cast(void**)&glResetMinmax, "glResetMinmax");
        lib.bindGLSymbol(cast(void**)&glGetMinmax, "glGetMinmax");
        lib.bindGLSymbol(cast(void**)&glGetMinmaxParameterfv, "glGetMinmaxParameterfv");
        lib.bindGLSymbol(cast(void**)&glGetMinmaxParameteriv, "glGetMinmaxParameteriv");
        lib.bindGLSymbol(cast(void**)&glConvolutionFilter1D, "glConvolutionFilter1D");
        lib.bindGLSymbol(cast(void**)&glConvolutionFilter2D, "glConvolutionFilter2D");
        lib.bindGLSymbol(cast(void**)&glConvolutionParameterf, "glConvolutionParameterf");
        lib.bindGLSymbol(cast(void**)&glConvolutionParameterfv, "glConvolutionParameterfv");
        lib.bindGLSymbol(cast(void**)&glConvolutionParameteri, "glConvolutionParameteri");
        lib.bindGLSymbol(cast(void**)&glConvolutionParameteriv, "glConvolutionParameteriv");
        lib.bindGLSymbol(cast(void**)&glCopyConvolutionFilter1D, "glCopyConvolutionFilter1D");
        lib.bindGLSymbol(cast(void**)&glCopyConvolutionFilter2D, "glCopyConvolutionFilter2D");
        lib.bindGLSymbol(cast(void**)&glGetConvolutionFilter, "glGetConvolutionFilter");
        lib.bindGLSymbol(cast(void**)&glGetConvolutionParameterfv, "glGetConvolutionParameterfv");
        lib.bindGLSymbol(cast(void**)&glGetConvolutionParameteriv, "glGetConvolutionParameteriv");
        lib.bindGLSymbol(cast(void**)&glSeparableFilter2D, "glSeparableFilter2D");
        lib.bindGLSymbol(cast(void**)&glGetSeparableFilter, "glGetSeparableFilter");

        return errorCountGL() == 0;
    }
}