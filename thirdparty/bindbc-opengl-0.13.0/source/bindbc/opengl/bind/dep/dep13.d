
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep13;

import bindbc.loader;
import bindbc.opengl.context;
import bindbc.opengl.bind.types;

version(GL_AllowDeprecated) {
    enum : uint  {
        GL_CLIENT_ACTIVE_TEXTURE          = 0x84E1,
        GL_MAX_TEXTURE_UNITS              = 0x84E2,
        GL_TRANSPOSE_MODELVIEW_MATRIX     = 0x84E3,
        GL_TRANSPOSE_PROJECTION_MATRIX    = 0x84E4,
        GL_TRANSPOSE_TEXTURE_MATRIX       = 0x84E5,
        GL_TRANSPOSE_COLOR_MATRIX         = 0x84E6,
        GL_MULTISAMPLE_BIT                = 0x20000000,
        GL_NORMAL_MAP                     = 0x8511,
        GL_REFLECTION_MAP                 = 0x8512,
        GL_COMPRESSED_ALPHA               = 0x84E9,
        GL_COMPRESSED_LUMINANCE           = 0x84EA,
        GL_COMPRESSED_LUMINANCE_ALPHA     = 0x84EB,
        GL_COMPRESSED_INTENSITY           = 0x84EC,
        GL_COMBINE                        = 0x8570,
        GL_COMBINE_RGB                    = 0x8571,
        GL_COMBINE_ALPHA                  = 0x8572,
        GL_SOURCE0_RGB                    = 0x8580,
        GL_SOURCE1_RGB                    = 0x8581,
        GL_SOURCE2_RGB                    = 0x8582,
        GL_SOURCE0_ALPHA                  = 0x8588,
        GL_SOURCE1_ALPHA                  = 0x8589,
        GL_SOURCE2_ALPHA                  = 0x858A,
        GL_OPERAND0_RGB                   = 0x8590,
        GL_OPERAND1_RGB                   = 0x8591,
        GL_OPERAND2_RGB                   = 0x8592,
        GL_OPERAND0_ALPHA                 = 0x8598,
        GL_OPERAND1_ALPHA                 = 0x8599,
        GL_OPERAND2_ALPHA                 = 0x859A,
        GL_RGB_SCALE                      = 0x8573,
        GL_ADD_SIGNED                     = 0x8574,
        GL_INTERPOLATE                    = 0x8575,
        GL_SUBTRACT                       = 0x84E7,
        GL_CONSTANT                       = 0x8576,
        GL_PRIMARY_COLOR                  = 0x8577,
        GL_PREVIOUS                       = 0x8578,
        GL_DOT3_RGB                       = 0x86AE,
        GL_DOT3_RGBA                      = 0x86AF,
    }

    extern(System) @nogc nothrow {
        alias pglClientActiveTexture = void function(GLenum);
        alias pglMultiTexCoord1d = void function(GLenum, GLdouble);
        alias pglMultiTexCoord1dv = void function(GLenum, const(GLdouble)*);
        alias pglMultiTexCoord1f = void function(GLenum, GLfloat);
        alias pglMultiTexCoord1fv = void function(GLenum, const(GLfloat)*);
        alias pglMultiTexCoord1i = void function(GLenum, GLint);
        alias pglMultiTexCoord1iv = void function(GLenum, const(GLint)*);
        alias pglMultiTexCoord1s = void function(GLenum, GLshort);
        alias pglMultiTexCoord1sv = void function(GLenum, const(GLshort)*);
        alias pglMultiTexCoord2d = void function(GLenum, GLdouble, GLdouble);
        alias pglMultiTexCoord2dv = void function(GLenum, const(GLdouble)*);
        alias pglMultiTexCoord2f = void function(GLenum, GLfloat, GLfloat);
        alias pglMultiTexCoord2fv = void function(GLenum, const(GLfloat)*);
        alias pglMultiTexCoord2i = void function(GLenum, GLint, GLint);
        alias pglMultiTexCoord2iv = void function(GLenum, const(GLint)*);
        alias pglMultiTexCoord2s = void function(GLenum, GLshort, GLshort);
        alias pglMultiTexCoord2sv = void function(GLenum, const(GLshort)*);
        alias pglMultiTexCoord3d = void function(GLenum, GLdouble, GLdouble, GLdouble);
        alias pglMultiTexCoord3dv = void function(GLenum, const(GLdouble)*);
        alias pglMultiTexCoord3f = void function(GLenum, GLfloat, GLfloat, GLfloat);
        alias pglMultiTexCoord3fv = void function(GLenum, const(GLfloat)*);
        alias pglMultiTexCoord3i = void function(GLenum, GLint, GLint, GLint);
        alias pglMultiTexCoord3iv = void function(GLenum, const(GLint)*);
        alias pglMultiTexCoord3s = void function(GLenum, GLshort, GLshort, GLshort);
        alias pglMultiTexCoord3sv = void function(GLenum, const(GLshort)*);
        alias pglMultiTexCoord4d = void function(GLenum, GLdouble, GLdouble, GLdouble, GLdouble);
        alias pglMultiTexCoord4dv = void function(GLenum, const(GLdouble)*);
        alias pglMultiTexCoord4f = void function(GLenum, GLfloat, GLfloat, GLfloat, GLfloat);
        alias pglMultiTexCoord4fv = void function(GLenum, const(GLfloat)*);
        alias pglMultiTexCoord4i = void function(GLenum, GLint, GLint, GLint, GLint);
        alias pglMultiTexCoord4iv = void function(GLenum, const(GLint)*);
        alias pglMultiTexCoord4s = void function(GLenum, GLshort, GLshort, GLshort, GLshort);
        alias pglMultiTexCoord4sv = void function(GLenum, const(GLshort)*);
        alias pglLoadTransposeMatrixd = void function(GLdouble*);
        alias pglLoadTransposeMatrixf = void function(const(GLfloat)*);
        alias pglMultTransposeMatrixd = void function(const(GLdouble)*);
        alias pglMultTransposeMatrixf = void function(const(GLfloat)*);
    }

    __gshared {
        pglClientActiveTexture glClientActiveTexture;
        pglMultiTexCoord1d glMultiTexCoord1d;
        pglMultiTexCoord1dv glMultiTexCoord1dv;
        pglMultiTexCoord1f glMultiTexCoord1f;
        pglMultiTexCoord1fv glMultiTexCoord1fv;
        pglMultiTexCoord1i glMultiTexCoord1i;
        pglMultiTexCoord1iv glMultiTexCoord1iv;
        pglMultiTexCoord1s glMultiTexCoord1s;
        pglMultiTexCoord1sv glMultiTexCoord1sv;
        pglMultiTexCoord2d glMultiTexCoord2d;
        pglMultiTexCoord2dv glMultiTexCoord2dv;
        pglMultiTexCoord2f glMultiTexCoord2f;
        pglMultiTexCoord2fv glMultiTexCoord2fv;
        pglMultiTexCoord2i glMultiTexCoord2i;
        pglMultiTexCoord2iv glMultiTexCoord2iv;
        pglMultiTexCoord2s glMultiTexCoord2s;
        pglMultiTexCoord2sv glMultiTexCoord2sv;
        pglMultiTexCoord3d glMultiTexCoord3d;
        pglMultiTexCoord3dv glMultiTexCoord3dv;
        pglMultiTexCoord3f glMultiTexCoord3f;
        pglMultiTexCoord3fv glMultiTexCoord3fv;
        pglMultiTexCoord3i glMultiTexCoord3i;
        pglMultiTexCoord3iv glMultiTexCoord3iv;
        pglMultiTexCoord3s glMultiTexCoord3s;
        pglMultiTexCoord3sv glMultiTexCoord3sv;
        pglMultiTexCoord4d glMultiTexCoord4d;
        pglMultiTexCoord4dv glMultiTexCoord4dv;
        pglMultiTexCoord4f glMultiTexCoord4f;
        pglMultiTexCoord4fv glMultiTexCoord4fv;
        pglMultiTexCoord4i glMultiTexCoord4i;
        pglMultiTexCoord4iv glMultiTexCoord4iv;
        pglMultiTexCoord4s glMultiTexCoord4s;
        pglMultiTexCoord4sv glMultiTexCoord4sv;
        pglLoadTransposeMatrixd glLoadTransposeMatrixd;
        pglLoadTransposeMatrixf glLoadTransposeMatrixf;
        pglMultTransposeMatrixd glMultTransposeMatrixd;
        pglMultTransposeMatrixf glMultTransposeMatrixf;
    }

    package(bindbc.opengl.bind) @nogc nothrow
    bool loadDeprecatedGL13(SharedLib lib)
    {
        lib.bindGLSymbol(cast(void**)&glClientActiveTexture, "glClientActiveTexture");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1d, "glMultiTexCoord1d");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1dv, "glMultiTexCoord1dv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1f, "glMultiTexCoord1f");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1fv, "glMultiTexCoord1fv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1i, "glMultiTexCoord1i");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1iv, "glMultiTexCoord1iv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1s, "glMultiTexCoord1s");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord1sv, "glMultiTexCoord1sv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2d, "glMultiTexCoord2d");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2dv, "glMultiTexCoord2dv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2f, "glMultiTexCoord2f");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2fv, "glMultiTexCoord2fv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2i, "glMultiTexCoord2i");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2iv, "glMultiTexCoord2iv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2s, "glMultiTexCoord2s");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord2sv, "glMultiTexCoord2sv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3d, "glMultiTexCoord3d");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3dv, "glMultiTexCoord3dv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3f, "glMultiTexCoord3f");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3fv, "glMultiTexCoord3fv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3i, "glMultiTexCoord3i");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3iv, "glMultiTexCoord3iv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3s, "glMultiTexCoord3s");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord3sv, "glMultiTexCoord3sv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4d, "glMultiTexCoord4d");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4dv, "glMultiTexCoord4dv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4f, "glMultiTexCoord4f");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4fv, "glMultiTexCoord4fv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4i, "glMultiTexCoord4i");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4iv, "glMultiTexCoord4iv");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4s, "glMultiTexCoord4s");
        lib.bindGLSymbol(cast(void**)&glMultiTexCoord4sv, "glMultiTexCoord4sv");
        lib.bindGLSymbol(cast(void**)&glLoadTransposeMatrixd, "glLoadTransposeMatrixd");
        lib.bindGLSymbol(cast(void**)&glLoadTransposeMatrixf, "glLoadTransposeMatrixf");
        lib.bindGLSymbol(cast(void**)&glMultTransposeMatrixd, "glMultTransposeMatrixd");
        lib.bindGLSymbol(cast(void**)&glMultTransposeMatrixf, "glMultTransposeMatrixf");

        return errorCountGL() == 0;
    }
}