
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep14;

import bindbc.loader;
import bindbc.opengl.context;
import bindbc.opengl.bind.types;

version(GL_AllowDeprecated) {
    enum : uint  {
        GL_POINT_SIZE_MIN                 = 0x8126,
        GL_POINT_SIZE_MAX                 = 0x8127,
        GL_POINT_DISTANCE_ATTENUATION     = 0x8129,
        GL_GENERATE_MIPMAP                = 0x8191,
        GL_GENERATE_MIPMAP_HINT           = 0x8192,
        GL_FOG_COORDINATE_SOURCE          = 0x8450,
        GL_FOG_COORDINATE                 = 0x8451,
        GL_FRAGMENT_DEPTH                 = 0x8452,
        GL_CURRENT_FOG_COORDINATE         = 0x8453,
        GL_FOG_COORDINATE_ARRAY_TYPE      = 0x8454,
        GL_FOG_COORDINATE_ARRAY_STRIDE    = 0x8455,
        GL_FOG_COORDINATE_ARRAY_POINTER   = 0x8456,
        GL_FOG_COORDINATE_ARRAY           = 0x8457,
        GL_COLOR_SUM                      = 0x8458,
        GL_CURRENT_SECONDARY_COLOR        = 0x8459,
        GL_SECONDARY_COLOR_ARRAY_SIZE     = 0x845A,
        GL_SECONDARY_COLOR_ARRAY_TYPE     = 0x845B,
        GL_SECONDARY_COLOR_ARRAY_STRIDE   = 0x845C,
        GL_SECONDARY_COLOR_ARRAY_POINTER  = 0x845D,
        GL_SECONDARY_COLOR_ARRAY          = 0x845E,
        GL_TEXTURE_FILTER_CONTROL         = 0x8500,
        GL_DEPTH_TEXTURE_MODE             = 0x884B,
        GL_COMPARE_R_TO_TEXTURE           = 0x884E,
    }

    extern(System) @nogc nothrow {
        alias pglFogCoordf = void function(GLfloat);
        alias pglFogCoordfv = void function(const(GLfloat)*);
        alias pglFogCoordd = void function(GLdouble);
        alias pglFogCoorddv = void function(const(GLdouble)*);
        alias pglFogCoordPointer = void function(GLenum, GLsizei,const(void)*);
        alias pglSecondaryColor3b = void function(GLbyte, GLbyte, GLbyte);
        alias pglSecondaryColor3bv = void function(const(GLbyte)*);
        alias pglSecondaryColor3d = void function(GLdouble, GLdouble, GLdouble);
        alias pglSecondaryColor3dv = void function(const(GLdouble)*);
        alias pglSecondaryColor3f = void function(GLfloat, GLfloat, GLfloat);
        alias pglSecondaryColor3fv = void function(const(GLfloat)*);
        alias pglSecondaryColor3i = void function(GLint, GLint, GLint);
        alias pglSecondaryColor3iv = void function(const(GLint)*);
        alias pglSecondaryColor3s = void function(GLshort, GLshort, GLshort);
        alias pglSecondaryColor3sv = void function(const(GLshort)*);
        alias pglSecondaryColor3ub = void function(GLubyte, GLubyte, GLubyte);
        alias pglSecondaryColor3ubv = void function(const(GLubyte)*);
        alias pglSecondaryColor3ui = void function(GLuint, GLuint, GLuint);
        alias pglSecondaryColor3uiv = void function(const(GLuint)*);
        alias pglSecondaryColor3us = void function(GLushort, GLushort, GLushort);
        alias pglSecondaryColor3usv = void function(const(GLushort)*);
        alias pglSecondaryColorPointer = void function(GLint, GLenum, GLsizei, void*);
        alias pglWindowPos2d = void function(GLdouble, GLdouble);
        alias pglWindowPos2dv = void function(const(GLdouble)*);
        alias pglWindowPos2f = void function(GLfloat, GLfloat);
        alias pglWindowPos2fv = void function(const(GLfloat)*);
        alias pglWindowPos2i = void function(GLint, GLint);
        alias pglWindowPos2iv = void function(const(GLint)*);
        alias pglWindowPos2s = void function(GLshort, GLshort);
        alias pglWindowPos2sv = void function(const(GLshort)*);
        alias pglWindowPos3d = void function(GLdouble, GLdouble, GLdouble);
        alias pglWindowPos3dv = void function(const(GLdouble)*);
        alias pglWindowPos3f = void function(GLfloat, GLfloat, GLfloat);
        alias pglWindowPos3fv = void function(const(GLfloat)*);
        alias pglWindowPos3i = void function(GLint, GLint, GLint);
        alias pglWindowPos3iv = void function(const(GLint)*);
        alias pglWindowPos3s = void function(GLshort, GLshort, GLshort);
        alias pglWindowPos3sv = void function(const(GLshort)*);
    }

    __gshared {
        pglFogCoordf glFogCoordf;
        pglFogCoordfv glFogCoordfv;
        pglFogCoordd glFogCoordd;
        pglFogCoorddv glFogCoorddv;
        pglFogCoordPointer glFogCoordPointer;
        pglSecondaryColor3b glSecondaryColor3b;
        pglSecondaryColor3bv glSecondaryColor3bv;
        pglSecondaryColor3d glSecondaryColor3d;
        pglSecondaryColor3dv glSecondaryColor3dv;
        pglSecondaryColor3f glSecondaryColor3f;
        pglSecondaryColor3fv glSecondaryColor3fv;
        pglSecondaryColor3i glSecondaryColor3i;
        pglSecondaryColor3iv glSecondaryColor3iv;
        pglSecondaryColor3s glSecondaryColor3s;
        pglSecondaryColor3sv glSecondaryColor3sv;
        pglSecondaryColor3ub glSecondaryColor3ub;
        pglSecondaryColor3ubv glSecondaryColor3ubv;
        pglSecondaryColor3ui glSecondaryColor3ui;
        pglSecondaryColor3uiv glSecondaryColor3uiv;
        pglSecondaryColor3us glSecondaryColor3us;
        pglSecondaryColor3usv glSecondaryColor3usv;
        pglSecondaryColorPointer glSecondaryColorPointer;
        pglWindowPos2d glWindowPos2d;
        pglWindowPos2dv glWindowPos2dv;
        pglWindowPos2f glWindowPos2f;
        pglWindowPos2fv glWindowPos2fv;
        pglWindowPos2i glWindowPos2i;
        pglWindowPos2iv glWindowPos2iv;
        pglWindowPos2s glWindowPos2s;
        pglWindowPos2sv glWindowPos2sv;
        pglWindowPos3d glWindowPos3d;
        pglWindowPos3dv glWindowPos3dv;
        pglWindowPos3f glWindowPos3f;
        pglWindowPos3fv glWindowPos3fv;
        pglWindowPos3i glWindowPos3i;
        pglWindowPos3iv glWindowPos3iv;
        pglWindowPos3s glWindowPos3s;
        pglWindowPos3sv glWindowPos3sv;
    }

    package(bindbc.opengl.bind) @nogc nothrow
    bool loadDeprecatedGL14(SharedLib lib)
    {
        lib.bindGLSymbol(cast(void**)&glFogCoordf, "glFogCoordf");
        lib.bindGLSymbol(cast(void**)&glFogCoordfv, "glFogCoordfv");
        lib.bindGLSymbol(cast(void**)&glFogCoordd, "glFogCoordd");
        lib.bindGLSymbol(cast(void**)&glFogCoorddv, "glFogCoorddv");
        lib.bindGLSymbol(cast(void**)&glFogCoordPointer, "glFogCoordPointer");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3b, "glSecondaryColor3b");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3bv, "glSecondaryColor3bv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3d, "glSecondaryColor3d");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3dv, "glSecondaryColor3dv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3f, "glSecondaryColor3f");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3fv, "glSecondaryColor3fv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3i, "glSecondaryColor3i");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3iv, "glSecondaryColor3iv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3s, "glSecondaryColor3s");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3sv, "glSecondaryColor3sv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3ub, "glSecondaryColor3ub");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3ubv, "glSecondaryColor3ubv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3ui, "glSecondaryColor3ui");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3uiv, "glSecondaryColor3uiv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3us, "glSecondaryColor3us");
        lib.bindGLSymbol(cast(void**)&glSecondaryColor3usv, "glSecondaryColor3usv");
        lib.bindGLSymbol(cast(void**)&glSecondaryColorPointer, "glSecondaryColorPointer");
        lib.bindGLSymbol(cast(void**)&glWindowPos2d, "glWindowPos2d");
        lib.bindGLSymbol(cast(void**)&glWindowPos2dv, "glWindowPos2dv");
        lib.bindGLSymbol(cast(void**)&glWindowPos2f, "glWindowPos2f");
        lib.bindGLSymbol(cast(void**)&glWindowPos2fv, "glWindowPos2fv");
        lib.bindGLSymbol(cast(void**)&glWindowPos2i, "glWindowPos2i");
        lib.bindGLSymbol(cast(void**)&glWindowPos2iv, "glWindowPos2iv");
        lib.bindGLSymbol(cast(void**)&glWindowPos2s, "glWindowPos2s");
        lib.bindGLSymbol(cast(void**)&glWindowPos2sv, "glWindowPos2sv");
        lib.bindGLSymbol(cast(void**)&glWindowPos3d, "glWindowPos3d");
        lib.bindGLSymbol(cast(void**)&glWindowPos3dv, "glWindowPos3dv");
        lib.bindGLSymbol(cast(void**)&glWindowPos3f, "glWindowPos3f");
        lib.bindGLSymbol(cast(void**)&glWindowPos3fv, "glWindowPos3fv");
        lib.bindGLSymbol(cast(void**)&glWindowPos3i, "glWindowPos3i");
        lib.bindGLSymbol(cast(void**)&glWindowPos3iv, "glWindowPos3iv");
        lib.bindGLSymbol(cast(void**)&glWindowPos3s, "glWindowPos3s");
        lib.bindGLSymbol(cast(void**)&glWindowPos3sv, "glWindowPos3sv");

        return errorCountGL() == 0;
    }
}