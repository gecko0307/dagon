
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl11;

import bindbc.loader;
import bindbc.opengl.bind.types;

version(GL_AllowDeprecated)
    public import bindbc.opengl.bind.dep.dep11;

enum : ubyte {
    GL_FALSE                          = 0,
    GL_TRUE                           = 1,
}

enum : uint {
    GL_DEPTH_BUFFER_BIT               = 0x00000100,
    GL_STENCIL_BUFFER_BIT             = 0x00000400,
    GL_COLOR_BUFFER_BIT               = 0x00004000,
    GL_POINTS                         = 0x0000,
    GL_LINES                          = 0x0001,
    GL_LINE_LOOP                      = 0x0002,
    GL_LINE_STRIP                     = 0x0003,
    GL_TRIANGLES                      = 0x0004,
    GL_TRIANGLE_STRIP                 = 0x0005,
    GL_TRIANGLE_FAN                   = 0x0006,
    GL_NEVER                          = 0x0200,
    GL_LESS                           = 0x0201,
    GL_EQUAL                          = 0x0202,
    GL_LEQUAL                         = 0x0203,
    GL_GREATER                        = 0x0204,
    GL_NOTEQUAL                       = 0x0205,
    GL_GEQUAL                         = 0x0206,
    GL_ALWAYS                         = 0x0207,
    GL_ZERO                           = 0,
    GL_ONE                            = 1,
    GL_SRC_COLOR                      = 0x0300,
    GL_ONE_MINUS_SRC_COLOR            = 0x0301,
    GL_SRC_ALPHA                      = 0x0302,
    GL_ONE_MINUS_SRC_ALPHA            = 0x0303,
    GL_DST_ALPHA                      = 0x0304,
    GL_ONE_MINUS_DST_ALPHA            = 0x0305,
    GL_DST_COLOR                      = 0x0306,
    GL_ONE_MINUS_DST_COLOR            = 0x0307,
    GL_SRC_ALPHA_SATURATE             = 0x0308,
    GL_NONE                           = 0,
    GL_FRONT_LEFT                     = 0x0400,
    GL_FRONT_RIGHT                    = 0x0401,
    GL_BACK_LEFT                      = 0x0402,
    GL_BACK_RIGHT                     = 0x0403,
    GL_FRONT                          = 0x0404,
    GL_BACK                           = 0x0405,
    GL_LEFT                           = 0x0406,
    GL_RIGHT                          = 0x0407,
    GL_FRONT_AND_BACK                 = 0x0408,
    GL_NO_ERROR                       = 0,
    GL_INVALID_ENUM                   = 0x0500,
    GL_INVALID_VALUE                  = 0x0501,
    GL_INVALID_OPERATION              = 0x0502,
    GL_OUT_OF_MEMORY                  = 0x0505,
    GL_CW                             = 0x0900,
    GL_CCW                            = 0x0901,
    GL_POINT_SIZE                     = 0x0B11,
    GL_POINT_SIZE_RANGE               = 0x0B12,
    GL_POINT_SIZE_GRANULARITY         = 0x0B13,
    GL_LINE_SMOOTH                    = 0x0B20,
    GL_LINE_WIDTH                     = 0x0B21,
    GL_LINE_WIDTH_RANGE               = 0x0B22,
    GL_LINE_WIDTH_GRANULARITY         = 0x0B23,
    GL_POLYGON_MODE                   = 0x0B40,
    GL_POLYGON_SMOOTH                 = 0x0B41,
    GL_CULL_FACE                      = 0x0B44,
    GL_CULL_FACE_MODE                 = 0x0B45,
    GL_FRONT_FACE                     = 0x0B46,
    GL_DEPTH_RANGE                    = 0x0B70,
    GL_DEPTH_TEST                     = 0x0B71,
    GL_DEPTH_WRITEMASK                = 0x0B72,
    GL_DEPTH_CLEAR_VALUE              = 0x0B73,
    GL_DEPTH_FUNC                     = 0x0B74,
    GL_STENCIL_TEST                   = 0x0B90,
    GL_STENCIL_CLEAR_VALUE            = 0x0B91,
    GL_STENCIL_FUNC                   = 0x0B92,
    GL_STENCIL_VALUE_MASK             = 0x0B93,
    GL_STENCIL_FAIL                   = 0x0B94,
    GL_STENCIL_PASS_DEPTH_FAIL        = 0x0B95,
    GL_STENCIL_PASS_DEPTH_PASS        = 0x0B96,
    GL_STENCIL_REF                    = 0x0B97,
    GL_STENCIL_WRITEMASK              = 0x0B98,
    GL_VIEWPORT                       = 0x0BA2,
    GL_DITHER                         = 0x0BD0,
    GL_BLEND_DST                      = 0x0BE0,
    GL_BLEND_SRC                      = 0x0BE1,
    GL_BLEND                          = 0x0BE2,
    GL_LOGIC_OP_MODE                  = 0x0BF0,
    GL_COLOR_LOGIC_OP                 = 0x0BF2,
    GL_DRAW_BUFFER                    = 0x0C01,
    GL_READ_BUFFER                    = 0x0C02,
    GL_SCISSOR_BOX                    = 0x0C10,
    GL_SCISSOR_TEST                   = 0x0C11,
    GL_COLOR_CLEAR_VALUE              = 0x0C22,
    GL_COLOR_WRITEMASK                = 0x0C23,
    GL_DOUBLEBUFFER                   = 0x0C32,
    GL_STEREO                         = 0x0C33,
    GL_LINE_SMOOTH_HINT               = 0x0C52,
    GL_POLYGON_SMOOTH_HINT            = 0x0C53,
    GL_UNPACK_SWAP_BYTES              = 0x0CF0,
    GL_UNPACK_LSB_FIRST               = 0x0CF1,
    GL_UNPACK_ROW_LENGTH              = 0x0CF2,
    GL_UNPACK_SKIP_ROWS               = 0x0CF3,
    GL_UNPACK_SKIP_PIXELS             = 0x0CF4,
    GL_UNPACK_ALIGNMENT               = 0x0CF5,
    GL_PACK_SWAP_BYTES                = 0x0D00,
    GL_PACK_LSB_FIRST                 = 0x0D01,
    GL_PACK_ROW_LENGTH                = 0x0D02,
    GL_PACK_SKIP_ROWS                 = 0x0D03,
    GL_PACK_SKIP_PIXELS               = 0x0D04,
    GL_PACK_ALIGNMENT                 = 0x0D05,
    GL_MAX_TEXTURE_SIZE               = 0x0D33,
    GL_MAX_VIEWPORT_DIMS              = 0x0D3A,
    GL_SUBPIXEL_BITS                  = 0x0D50,
    GL_TEXTURE_1D                     = 0x0DE0,
    GL_TEXTURE_2D                     = 0x0DE1,
    GL_POLYGON_OFFSET_UNITS           = 0x2A00,
    GL_POLYGON_OFFSET_POINT           = 0x2A01,
    GL_POLYGON_OFFSET_LINE            = 0x2A02,
    GL_POLYGON_OFFSET_FILL            = 0x8037,
    GL_POLYGON_OFFSET_FACTOR          = 0x8038,
    GL_TEXTURE_BINDING_1D             = 0x8068,
    GL_TEXTURE_BINDING_2D             = 0x8069,
    GL_TEXTURE_WIDTH                  = 0x1000,
    GL_TEXTURE_HEIGHT                 = 0x1001,
    GL_TEXTURE_INTERNAL_FORMAT        = 0x1003,
    GL_TEXTURE_BORDER_COLOR           = 0x1004,
    GL_TEXTURE_RED_SIZE               = 0x805C,
    GL_TEXTURE_GREEN_SIZE             = 0x805D,
    GL_TEXTURE_BLUE_SIZE              = 0x805E,
    GL_TEXTURE_ALPHA_SIZE             = 0x805F,
    GL_DONT_CARE                      = 0x1100,
    GL_FASTEST                        = 0x1101,
    GL_NICEST                         = 0x1102,
    GL_BYTE                           = 0x1400,
    GL_UNSIGNED_BYTE                  = 0x1401,
    GL_SHORT                          = 0x1402,
    GL_UNSIGNED_SHORT                 = 0x1403,
    GL_INT                            = 0x1404,
    GL_UNSIGNED_INT                   = 0x1405,
    GL_FLOAT                          = 0x1406,
    GL_DOUBLE                         = 0x140A,
    GL_CLEAR                          = 0x1500,
    GL_AND                            = 0x1501,
    GL_AND_REVERSE                    = 0x1502,
    GL_COPY                           = 0x1503,
    GL_AND_INVERTED                   = 0x1504,
    GL_NOOP                           = 0x1505,
    GL_XOR                            = 0x1506,
    GL_OR                             = 0x1507,
    GL_NOR                            = 0x1508,
    GL_EQUIV                          = 0x1509,
    GL_INVERT                         = 0x150A,
    GL_OR_REVERSE                     = 0x150B,
    GL_COPY_INVERTED                  = 0x150C,
    GL_OR_INVERTED                    = 0x150D,
    GL_NAND                           = 0x150E,
    GL_SET                            = 0x150F,
    GL_TEXTURE                        = 0x1702,
    GL_COLOR                          = 0x1800,
    GL_DEPTH                          = 0x1801,
    GL_STENCIL                        = 0x1802,
    GL_STENCIL_INDEX                  = 0x1901,
    GL_DEPTH_COMPONENT                = 0x1902,
    GL_RED                            = 0x1903,
    GL_GREEN                          = 0x1904,
    GL_BLUE                           = 0x1905,
    GL_ALPHA                          = 0x1906,
    GL_RGB                            = 0x1907,
    GL_RGBA                           = 0x1908,
    GL_POINT                          = 0x1B00,
    GL_LINE                           = 0x1B01,
    GL_FILL                           = 0x1B02,
    GL_KEEP                           = 0x1E00,
    GL_REPLACE                        = 0x1E01,
    GL_INCR                           = 0x1E02,
    GL_DECR                           = 0x1E03,
    GL_VENDOR                         = 0x1F00,
    GL_RENDERER                       = 0x1F01,
    GL_VERSION                        = 0x1F02,
    GL_EXTENSIONS                     = 0x1F03,
    GL_NEAREST                        = 0x2600,
    GL_LINEAR                         = 0x2601,
    GL_NEAREST_MIPMAP_NEAREST         = 0x2700,
    GL_LINEAR_MIPMAP_NEAREST          = 0x2701,
    GL_NEAREST_MIPMAP_LINEAR          = 0x2702,
    GL_LINEAR_MIPMAP_LINEAR           = 0x2703,
    GL_TEXTURE_MAG_FILTER             = 0x2800,
    GL_TEXTURE_MIN_FILTER             = 0x2801,
    GL_TEXTURE_WRAP_S                 = 0x2802,
    GL_TEXTURE_WRAP_T                 = 0x2803,
    GL_PROXY_TEXTURE_1D               = 0x8063,
    GL_PROXY_TEXTURE_2D               = 0x8064,
    GL_REPEAT                         = 0x2901,
    GL_R3_G3_B2                       = 0x2A10,
    GL_RGB4                           = 0x804F,
    GL_RGB5                           = 0x8050,
    GL_RGB8                           = 0x8051,
    GL_RGB10                          = 0x8052,
    GL_RGB12                          = 0x8053,
    GL_RGB16                          = 0x8054,
    GL_RGBA2                          = 0x8055,
    GL_RGBA4                          = 0x8056,
    GL_RGB5_A1                        = 0x8057,
    GL_RGBA8                          = 0x8058,
    GL_RGB10_A2                       = 0x8059,
    GL_RGBA12                         = 0x805A,
    GL_RGBA16                         = 0x805B,
    GL_VERTEX_ARRAY                   = 0x8074,
}

extern(System) @nogc nothrow {
    // OpenGL 1.0
    alias pglCullFace = void function(GLenum);
    alias pglFrontFace = void function(GLenum);
    alias pglHint = void function(GLenum,GLenum);
    alias pglLineWidth = void function(GLfloat);
    alias pglPointSize = void function(GLfloat);
    alias pglPolygonMode = void function(GLenum,GLenum);
    alias pglScissor = void function(GLint,GLint,GLsizei,GLsizei);
    alias pglTexParameterf = void function(GLenum,GLenum,GLfloat);
    alias pglTexParameterfv = void function(GLenum,GLenum,const(GLfloat)*);
    alias pglTexParameteri = void function(GLenum,GLenum,GLint);
    alias pglTexParameteriv = void function(GLenum,GLenum,const(GLint)*);
    alias pglTexImage1D = void function(GLenum,GLint,GLint,GLsizei,GLint,GLenum,GLenum,const(GLvoid)*);
    alias pglTexImage2D = void function(GLenum,GLint,GLint,GLsizei,GLsizei,GLint,GLenum,GLenum,const(GLvoid)*);
    alias pglDrawBuffer = void function(GLenum);
    alias pglClear = void function(GLbitfield);
    alias pglClearColor = void function(GLclampf,GLclampf,GLclampf,GLclampf);
    alias pglClearStencil = void function(GLint);
    alias pglClearDepth = void function(GLclampd);
    alias pglStencilMask = void function(GLuint);
    alias pglColorMask = void function(GLboolean,GLboolean,GLboolean,GLboolean);
    alias pglDepthMask = void function(GLboolean);
    alias pglDisable = void function(GLenum);
    alias pglEnable = void function(GLenum);
    alias pglFinish = void function();
    alias pglFlush = void function();
    alias pglBlendFunc = void function(GLenum,GLenum);
    alias pglLogicOp = void function(GLenum);
    alias pglStencilFunc = void function(GLenum,GLint,GLuint);
    alias pglStencilOp = void function(GLenum,GLenum,GLenum);
    alias pglDepthFunc = void function(GLenum);
    alias pglPixelStoref = void function(GLenum,GLfloat);
    alias pglPixelStorei = void function(GLenum,GLint);
    alias pglReadBuffer = void function(GLenum);
    alias pglReadPixels = void function(GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,GLvoid*);
    alias pglGetBooleanv = void function(GLenum,GLboolean*);
    alias pglGetDoublev = void function(GLenum,GLdouble*);
    alias pglGetError = GLenum function();
    alias pglGetFloatv = void function(GLenum,GLfloat*);
    alias pglGetIntegerv = void function(GLenum,GLint*);
    alias pglGetString = const(char*) function(GLenum);
    alias pglGetTexImage = void function(GLenum,GLint,GLenum,GLenum,GLvoid*);
    alias pglGetTexParameterfv = void function(GLenum,GLenum,GLfloat*);
    alias pglGetTexParameteriv = void function(GLenum,GLenum,GLint*);
    alias pglGetTexLevelParameterfv = void function(GLenum,GLint,GLenum,GLfloat*);
    alias pglGetTexLevelParameteriv = void function(GLenum,GLint,GLenum,GLint*);
    alias pglIsEnabled = GLboolean function(GLenum);
    alias pglDepthRange = void function(GLclampd,GLclampd);
    alias pglViewport = void function(GLint,GLint,GLsizei,GLsizei);

    // OpenGL 1.1
    alias pglDrawArrays = void function(GLenum,GLint,GLsizei);
    alias pglDrawElements = void function(GLenum,GLsizei,GLenum,const(GLvoid)*);
    alias pglGetPointerv = void function(GLenum,GLvoid*);
    alias pglPolygonOffset = void function(GLfloat,GLfloat);
    alias pglCopyTexImage1D = void function(GLenum,GLint,GLenum,GLint,GLint,GLsizei,GLint);
    alias pglCopyTexImage2D = void function(GLenum,GLint,GLenum,GLint,GLint,GLsizei,GLsizei,GLint);
    alias pglCopyTexSubImage1D = void function(GLenum,GLint,GLint,GLint,GLint,GLsizei);
    alias pglCopyTexSubImage2D = void function(GLenum,GLint,GLint,GLint,GLint,GLint,GLsizei,GLsizei);
    alias pglTexSubImage1D = void function(GLenum,GLint,GLint,GLsizei,GLenum,GLenum,const(GLvoid)*);
    alias pglTexSubImage2D = void function(GLenum,GLint,GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,const(GLvoid)*);
    alias pglBindTexture = void function(GLenum,GLuint);
    alias pglDeleteTextures = void function(GLsizei,const(GLuint)*);
    alias pglGenTextures = void function(GLsizei,GLuint*);
    alias pglIsTexture = GLboolean function(GLuint);
}

__gshared {
    pglCullFace glCullFace;
    pglFrontFace glFrontFace;
    pglHint glHint;
    pglLineWidth glLineWidth;
    pglPointSize glPointSize;
    pglPolygonMode glPolygonMode;
    pglScissor glScissor;
    pglTexParameterf glTexParameterf;
    pglTexParameterfv glTexParameterfv;
    pglTexParameteri glTexParameteri;
    pglTexParameteriv glTexParameteriv;
    pglTexImage1D glTexImage1D;
    pglTexImage2D glTexImage2D;
    pglDrawBuffer glDrawBuffer;
    pglClear glClear;
    pglClearColor glClearColor;
    pglClearStencil glClearStencil;
    pglClearDepth glClearDepth;
    pglStencilMask glStencilMask;
    pglColorMask glColorMask;
    pglDepthMask glDepthMask;
    pglDisable glDisable;
    pglEnable glEnable;
    pglFinish glFinish;
    pglFlush glFlush;
    pglBlendFunc glBlendFunc;
    pglLogicOp glLogicOp;
    pglStencilFunc glStencilFunc;
    pglStencilOp glStencilOp;
    pglDepthFunc glDepthFunc;
    pglPixelStoref glPixelStoref;
    pglPixelStorei glPixelStorei;
    pglReadBuffer glReadBuffer;
    pglReadPixels glReadPixels;
    pglGetBooleanv glGetBooleanv;
    pglGetDoublev glGetDoublev;
    pglGetError glGetError;
    pglGetFloatv glGetFloatv;
    pglGetIntegerv glGetIntegerv;
    pglGetString glGetString;
    pglGetTexImage glGetTexImage;
    pglGetTexParameterfv glGetTexParameterfv;
    pglGetTexParameteriv glGetTexParameteriv;
    pglGetTexLevelParameterfv glGetTexLevelParameterfv;
    pglGetTexLevelParameteriv glGetTexLevelParameteriv;
    pglIsEnabled glIsEnabled;
    pglDepthRange glDepthRange;
    pglViewport glViewport;
    pglDrawArrays glDrawArrays;
    pglDrawElements glDrawElements;
    pglGetPointerv glGetPointerv;
    pglPolygonOffset glPolygonOffset;
    pglCopyTexImage1D glCopyTexImage1D;
    pglCopyTexImage2D glCopyTexImage2D;
    pglCopyTexSubImage1D glCopyTexSubImage1D;
    pglCopyTexSubImage2D glCopyTexSubImage2D;
    pglTexSubImage1D glTexSubImage1D;
    pglTexSubImage2D glTexSubImage2D;
    pglBindTexture glBindTexture;
    pglDeleteTextures glDeleteTextures;
    pglGenTextures glGenTextures;
    pglIsTexture glIsTexture;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL11(SharedLib lib)
{
    auto startErrorCount = errorCount();

    // OpenGL 1.0
    lib.bindSymbol(cast(void**)&glCullFace, "glCullFace");
    lib.bindSymbol(cast(void**)&glFrontFace, "glFrontFace");
    lib.bindSymbol(cast(void**)&glHint, "glHint");
    lib.bindSymbol(cast(void**)&glLineWidth, "glLineWidth");
    lib.bindSymbol(cast(void**)&glPointSize, "glPointSize");
    lib.bindSymbol(cast(void**)&glPolygonMode, "glPolygonMode");
    lib.bindSymbol(cast(void**)&glScissor, "glScissor");
    lib.bindSymbol(cast(void**)&glTexParameterf, "glTexParameterf");
    lib.bindSymbol(cast(void**)&glTexParameterfv, "glTexParameterfv");
    lib.bindSymbol(cast(void**)&glTexParameteri, "glTexParameteri");
    lib.bindSymbol(cast(void**)&glTexParameteriv, "glTexParameteriv");
    lib.bindSymbol(cast(void**)&glTexImage1D, "glTexImage1D");
    lib.bindSymbol(cast(void**)&glTexImage2D, "glTexImage2D");
    lib.bindSymbol(cast(void**)&glDrawBuffer, "glDrawBuffer");
    lib.bindSymbol(cast(void**)&glClear, "glClear");
    lib.bindSymbol(cast(void**)&glClearColor, "glClearColor");
    lib.bindSymbol(cast(void**)&glClearStencil, "glClearStencil");
    lib.bindSymbol(cast(void**)&glClearDepth, "glClearDepth");
    lib.bindSymbol(cast(void**)&glStencilMask, "glStencilMask");
    lib.bindSymbol(cast(void**)&glColorMask, "glColorMask");
    lib.bindSymbol(cast(void**)&glDepthMask, "glDepthMask");
    lib.bindSymbol(cast(void**)&glDisable, "glDisable");
    lib.bindSymbol(cast(void**)&glEnable, "glEnable");
    lib.bindSymbol(cast(void**)&glFinish, "glFinish");
    lib.bindSymbol(cast(void**)&glFlush, "glFlush");
    lib.bindSymbol(cast(void**)&glBlendFunc, "glBlendFunc");
    lib.bindSymbol(cast(void**)&glLogicOp, "glLogicOp");
    lib.bindSymbol(cast(void**)&glStencilFunc, "glStencilFunc");
    lib.bindSymbol(cast(void**)&glStencilOp, "glStencilOp");
    lib.bindSymbol(cast(void**)&glDepthFunc, "glDepthFunc");
    lib.bindSymbol(cast(void**)&glPixelStoref, "glPixelStoref");
    lib.bindSymbol(cast(void**)&glPixelStorei, "glPixelStorei");
    lib.bindSymbol(cast(void**)&glReadBuffer, "glReadBuffer");
    lib.bindSymbol(cast(void**)&glReadPixels, "glReadPixels");
    lib.bindSymbol(cast(void**)&glGetBooleanv, "glGetBooleanv");
    lib.bindSymbol(cast(void**)&glGetDoublev, "glGetDoublev");
    lib.bindSymbol(cast(void**)&glGetError, "glGetError");
    lib.bindSymbol(cast(void**)&glGetFloatv, "glGetFloatv");
    lib.bindSymbol(cast(void**)&glGetIntegerv, "glGetIntegerv");
    lib.bindSymbol(cast(void**)&glGetString, "glGetString");
    lib.bindSymbol(cast(void**)&glGetTexImage, "glGetTexImage");
    lib.bindSymbol(cast(void**)&glGetTexParameterfv, "glGetTexParameterfv");
    lib.bindSymbol(cast(void**)&glGetTexParameteriv, "glGetTexParameteriv");
    lib.bindSymbol(cast(void**)&glGetTexLevelParameterfv, "glGetTexLevelParameterfv");
    lib.bindSymbol(cast(void**)&glGetTexLevelParameteriv, "glGetTexLevelParameteriv");
    lib.bindSymbol(cast(void**)&glIsEnabled, "glIsEnabled");
    lib.bindSymbol(cast(void**)&glDepthRange, "glDepthRange");
    lib.bindSymbol(cast(void**)&glViewport, "glViewport");

    // OpenGL 1.1
    lib.bindSymbol(cast(void**)&glDrawArrays, "glDrawArrays");
    lib.bindSymbol(cast(void**)&glDrawElements, "glDrawElements");
    lib.bindSymbol(cast(void**)&glPolygonOffset, "glPolygonOffset");
    lib.bindSymbol(cast(void**)&glCopyTexImage1D, "glCopyTexImage1D");
    lib.bindSymbol(cast(void**)&glCopyTexImage2D, "glCopyTexImage2D");
    lib.bindSymbol(cast(void**)&glCopyTexSubImage1D, "glCopyTexSubImage1D");
    lib.bindSymbol(cast(void**)&glCopyTexSubImage2D, "glCopyTexSubImage2D");
    lib.bindSymbol(cast(void**)&glTexSubImage1D, "glTexSubImage1D");
    lib.bindSymbol(cast(void**)&glTexSubImage2D, "glTexSubImage2D");
    lib.bindSymbol(cast(void**)&glBindTexture, "glBindTexture");
    lib.bindSymbol(cast(void**)&glDeleteTextures, "glDeleteTextures");
    lib.bindSymbol(cast(void**)&glGenTextures, "glGenTextures");
    lib.bindSymbol(cast(void**)&glIsTexture, "glIsTexture");

    immutable ret = errorCount() == startErrorCount;
    version(GL_AllowDeprecated) return ret && loadDeprecatedGL11(lib);
    else return ret;
}