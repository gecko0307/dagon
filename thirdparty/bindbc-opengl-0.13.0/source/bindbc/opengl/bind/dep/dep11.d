
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep11;

import bindbc.loader;
import bindbc.opengl.bind.types;

version(GL_AllowDeprecated) {
    enum : uint {
        GL_2_BYTES                              = 0x1407,
        GL_3_BYTES                              = 0x1408,
        GL_4_BYTES                              = 0x1409,
        GL_QUADS                                = 0x0007,
        GL_QUAD_STRIP                           = 0x0008,
        GL_POLYGON                              = 0x0009,
        GL_NORMAL_ARRAY                         = 0x8075,
        GL_COLOR_ARRAY                          = 0x8076,
        GL_INDEX_ARRAY                          = 0x8077,
        GL_TEXTURE_COORD_ARRAY                  = 0x8078,
        GL_EDGE_FLAG_ARRAY                      = 0x8079,
        GL_VERTEX_ARRAY_SIZE                    = 0x807A,
        GL_VERTEX_ARRAY_TYPE                    = 0x807B,
        GL_VERTEX_ARRAY_STRIDE                  = 0x807C,
        GL_NORMAL_ARRAY_TYPE                    = 0x807E,
        GL_NORMAL_ARRAY_STRIDE                  = 0x807F,
        GL_COLOR_ARRAY_SIZE                     = 0x8081,
        GL_COLOR_ARRAY_TYPE                     = 0x8082,
        GL_COLOR_ARRAY_STRIDE                   = 0x8083,
        GL_INDEX_ARRAY_TYPE                     = 0x8085,
        GL_INDEX_ARRAY_STRIDE                   = 0x8086,
        GL_TEXTURE_COORD_ARRAY_SIZE             = 0x8088,
        GL_TEXTURE_COORD_ARRAY_TYPE             = 0x8089,
        GL_TEXTURE_COORD_ARRAY_STRIDE           = 0x808A,
        GL_EDGE_FLAG_ARRAY_STRIDE               = 0x808C,
        GL_VERTEX_ARRAY_POINTER                 = 0x808E,
        GL_NORMAL_ARRAY_POINTER                 = 0x808F,
        GL_COLOR_ARRAY_POINTER                  = 0x8090,
        GL_INDEX_ARRAY_POINTER                  = 0x8091,
        GL_TEXTURE_COORD_ARRAY_POINTER          = 0x8092,
        GL_EDGE_FLAG_ARRAY_POINTER              = 0x8093,
        GL_V2F                                  = 0x2A20,
        GL_V3F                                  = 0x2A21,
        GL_C4UB_V2F                             = 0x2A22,
        GL_C4UB_V3F                             = 0x2A23,
        GL_C3F_V3F                              = 0x2A24,
        GL_N3F_V3F                              = 0x2A25,
        GL_C4F_N3F_V3F                          = 0x2A26,
        GL_T2F_V3F                              = 0x2A27,
        GL_T4F_V4F                              = 0x2A28,
        GL_T2F_C4UB_V3F                         = 0x2A29,
        GL_T2F_C3F_V3F                          = 0x2A2A,
        GL_T2F_N3F_V3F                          = 0x2A2B,
        GL_T2F_C4F_N3F_V3F                      = 0x2A2C,
        GL_T4F_C4F_N3F_V4F                      = 0x2A2D,
        GL_MATRIX_MODE                          = 0x0BA0,
        GL_MODELVIEW                            = 0x1700,
        GL_PROJECTION                           = 0x1701,
        GL_POINT_SMOOTH                         = 0x0B10,
        GL_LINE_STIPPLE                         = 0x0B24,
        GL_LINE_STIPPLE_PATTERN                 = 0x0B25,
        GL_LINE_STIPPLE_REPEAT                  = 0x0B26,
        GL_POLYGON_STIPPLE                      = 0x0B42,
        GL_EDGE_FLAG                            = 0x0B43,
        GL_COMPILE                              = 0x1300,
        GL_COMPILE_AND_EXECUTE                  = 0x1301,
        GL_LIST_BASE                            = 0x0B32,
        GL_LIST_INDEX                           = 0x0B33,
        GL_LIST_MODE                            = 0x0B30,
        GL_DEPTH_BITS                           = 0x0D56,
        GL_LIGHTING                             = 0x0B50,
        GL_LIGHT0                               = 0x4000,
        GL_LIGHT1                               = 0x4001,
        GL_LIGHT2                               = 0x4002,
        GL_LIGHT3                               = 0x4003,
        GL_LIGHT4                               = 0x4004,
        GL_LIGHT5                               = 0x4005,
        GL_LIGHT6                               = 0x4006,
        GL_LIGHT7                               = 0x4007,
        GL_SPOT_EXPONENT                        = 0x1205,
        GL_SPOT_CUTOFF                          = 0x1206,
        GL_CONSTANT_ATTENUATION                 = 0x1207,
        GL_LINEAR_ATTENUATION                   = 0x1208,
        GL_QUADRATIC_ATTENUATION                = 0x1209,
        GL_AMBIENT                              = 0x1200,
        GL_DIFFUSE                              = 0x1201,
        GL_SPECULAR                             = 0x1202,
        GL_SHININESS                            = 0x1601,
        GL_EMISSION                             = 0x1600,
        GL_POSITION                             = 0x1203,
        GL_SPOT_DIRECTION                       = 0x1204,
        GL_AMBIENT_AND_DIFFUSE                  = 0x1602,
        GL_COLOR_INDEXES                        = 0x1603,
        GL_LIGHT_MODEL_TWO_SIDE                 = 0x0B52,
        GL_LIGHT_MODEL_LOCAL_VIEWER             = 0x0B51,
        GL_LIGHT_MODEL_AMBIENT                  = 0x0B53,
        GL_SHADE_MODEL                          = 0x0B54,
        GL_FLAT                                 = 0x1D00,
        GL_SMOOTH                               = 0x1D01,
        GL_COLOR_MATERIAL                       = 0x0B57,
        GL_COLOR_MATERIAL_FACE                  = 0x0B55,
        GL_COLOR_MATERIAL_PARAMETER             = 0x0B56,
        GL_NORMALIZE                            = 0x0BA1,
        GL_ACCUM_RED_BITS                       = 0x0D58,
        GL_ACCUM_GREEN_BITS                     = 0x0D59,
        GL_ACCUM_BLUE_BITS                      = 0x0D5A,
        GL_ACCUM_ALPHA_BITS                     = 0x0D5B,
        GL_ACCUM_CLEAR_VALUE                    = 0x0B80,
        GL_ACCUM                                = 0x0100,
        GL_ADD                                  = 0x0104,
        GL_LOAD                                 = 0x0101,
        GL_MULT                                 = 0x0103,
        GL_RETURN                               = 0x0102,
        GL_ALPHA_TEST                           = 0x0BC0,
        GL_ALPHA_TEST_REF                       = 0x0BC2,
        GL_ALPHA_TEST_FUNC                      = 0x0BC1,
        GL_FEEDBACK                             = 0x1C01,
        GL_RENDER                               = 0x1C00,
        GL_SELECT                               = 0x1C02,
        GL_2D                                   = 0x0600,
        GL_3D                                   = 0x0601,
        GL_3D_COLOR                             = 0x0602,
        GL_3D_COLOR_TEXTURE                     = 0x0603,
        GL_4D_COLOR_TEXTURE                     = 0x0604,
        GL_POINT_TOKEN                          = 0x0701,
        GL_LINE_TOKEN                           = 0x0702,
        GL_LINE_RESET_TOKEN                     = 0x0707,
        GL_POLYGON_TOKEN                        = 0x0703,
        GL_BITMAP_TOKEN                         = 0x0704,
        GL_DRAW_PIXEL_TOKEN                     = 0x0705,
        GL_COPY_PIXEL_TOKEN                     = 0x0706,
        GL_PASS_THROUGH_TOKEN                   = 0x0700,
        GL_FEEDBACK_BUFFER_POINTER              = 0x0DF0,
        GL_FEEDBACK_BUFFER_SIZE                 = 0x0DF1,
        GL_FEEDBACK_BUFFER_TYPE                 = 0x0DF2,
        GL_SELECTION_BUFFER_POINTER             = 0x0DF3,
        GL_SELECTION_BUFFER_SIZE                = 0x0DF4,
        GL_FOG                                  = 0x0B60,
        GL_FOG_MODE                             = 0x0B65,
        GL_FOG_DENSITY                          = 0x0B62,
        GL_FOG_COLOR                            = 0x0B66,
        GL_FOG_INDEX                            = 0x0B61,
        GL_FOG_START                            = 0x0B63,
        GL_FOG_END                              = 0x0B64,
        GL_EXP                                  = 0x0800,
        GL_EXP2                                 = 0x0801,
        GL_LOGIC_OP                             = 0x0BF1,
        GL_INDEX_LOGIC_OP                       = 0x0BF1,
        GL_STENCIL_BITS                         = 0x0D57,
        GL_AUX0                                 = 0x0409,
        GL_AUX1                                 = 0x040A,
        GL_AUX2                                 = 0x040B,
        GL_AUX3                                 = 0x040C,
        GL_COLOR_INDEX                          = 0x1900,
        GL_LUMINANCE                            = 0x1909,
        GL_LUMINANCE_ALPHA                      = 0x190A,
        GL_ALPHA_BITS                           = 0x0D55,
        GL_RED_BITS                             = 0x0D52,
        GL_GREEN_BITS                           = 0x0D53,
        GL_BLUE_BITS                            = 0x0D54,
        GL_INDEX_BITS                           = 0x0D51,
        GL_AUX_BUFFERS                          = 0x0C00,
        GL_BITMAP                               = 0x1A00,
        GL_MAX_LIST_NESTING                     = 0x0B31,
        GL_MAX_ATTRIB_STACK_DEPTH               = 0x0D35,
        GL_MAX_MODELVIEW_STACK_DEPTH            = 0x0D36,
        GL_MAX_NAME_STACK_DEPTH                 = 0x0D37,
        GL_MAX_PROJECTION_STACK_DEPTH           = 0x0D38,
        GL_MAX_TEXTURE_STACK_DEPTH              = 0x0D39,
        GL_MAX_EVAL_ORDER                       = 0x0D30,
        GL_MAX_LIGHTS                           = 0x0D31,
        GL_MAX_PIXEL_MAP_TABLE                  = 0x0D34,
        GL_MAX_CLIENT_ATTRIB_STACK_DEPTH        = 0x0D3B,
        GL_ATTRIB_STACK_DEPTH                   = 0x0BB0,
        GL_CLIENT_ATTRIB_STACK_DEPTH            = 0x0BB1,
        GL_CURRENT_INDEX                        = 0x0B01,
        GL_CURRENT_COLOR                        = 0x0B00,
        GL_CURRENT_NORMAL                       = 0x0B02,
        GL_CURRENT_RASTER_COLOR                 = 0x0B04,
        GL_CURRENT_RASTER_DISTANCE              = 0x0B09,
        GL_CURRENT_RASTER_INDEX                 = 0x0B05,
        GL_CURRENT_RASTER_POSITION              = 0x0B07,
        GL_CURRENT_RASTER_TEXTURE_COORDS        = 0x0B06,
        GL_CURRENT_RASTER_POSITION_VALID        = 0x0B08,
        GL_CURRENT_TEXTURE_COORDS               = 0x0B03,
        GL_INDEX_CLEAR_VALUE                    = 0x0C20,
        GL_INDEX_MODE                           = 0x0C30,
        GL_INDEX_WRITEMASK                      = 0x0C21,
        GL_MODELVIEW_MATRIX                     = 0x0BA6,
        GL_MODELVIEW_STACK_DEPTH                = 0x0BA3,
        GL_NAME_STACK_DEPTH                     = 0x0D70,
        GL_PROJECTION_MATRIX                    = 0x0BA7,
        GL_PROJECTION_STACK_DEPTH               = 0x0BA4,
        GL_RENDER_MODE                          = 0x0C40,
        GL_RGBA_MODE                            = 0x0C31,
        GL_TEXTURE_MATRIX                       = 0x0BA8,
        GL_TEXTURE_STACK_DEPTH                  = 0x0BA5,
        GL_AUTO_NORMAL                          = 0x0D80,
        GL_MAP1_COLOR_4                         = 0x0D90,
        GL_MAP1_GRID_DOMAIN                     = 0x0DD0,
        GL_MAP1_GRID_SEGMENTS                   = 0x0DD1,
        GL_MAP1_INDEX                           = 0x0D91,
        GL_MAP1_NORMAL                          = 0x0D92,
        GL_MAP1_TEXTURE_COORD_1                 = 0x0D93,
        GL_MAP1_TEXTURE_COORD_2                 = 0x0D94,
        GL_MAP1_TEXTURE_COORD_3                 = 0x0D95,
        GL_MAP1_TEXTURE_COORD_4                 = 0x0D96,
        GL_MAP1_VERTEX_3                        = 0x0D97,
        GL_MAP1_VERTEX_4                        = 0x0D98,
        GL_MAP2_COLOR_4                         = 0x0DB0,
        GL_MAP2_GRID_DOMAIN                     = 0x0DD2,
        GL_MAP2_GRID_SEGMENTS                   = 0x0DD3,
        GL_MAP2_INDEX                           = 0x0DB1,
        GL_MAP2_NORMAL                          = 0x0DB2,
        GL_MAP2_TEXTURE_COORD_1                 = 0x0DB3,
        GL_MAP2_TEXTURE_COORD_2                 = 0x0DB4,
        GL_MAP2_TEXTURE_COORD_3                 = 0x0DB5,
        GL_MAP2_TEXTURE_COORD_4                 = 0x0DB6,
        GL_MAP2_VERTEX_3                        = 0x0DB7,
        GL_MAP2_VERTEX_4                        = 0x0DB8,
        GL_COEFF                                = 0x0A00,
        GL_DOMAIN                               = 0x0A02,
        GL_ORDER                                = 0x0A01,
        GL_FOG_HINT                             = 0x0C54,
        GL_PERSPECTIVE_CORRECTION_HINT          = 0x0C50,
        GL_POINT_SMOOTH_HINT                    = 0x0C51,
        GL_MAP_COLOR                            = 0x0D10,
        GL_MAP_STENCIL                          = 0x0D11,
        GL_INDEX_SHIFT                          = 0x0D12,
        GL_INDEX_OFFSET                         = 0x0D13,
        GL_RED_SCALE                            = 0x0D14,
        GL_RED_BIAS                             = 0x0D15,
        GL_GREEN_SCALE                          = 0x0D18,
        GL_GREEN_BIAS                           = 0x0D19,
        GL_BLUE_SCALE                           = 0x0D1A,
        GL_BLUE_BIAS                            = 0x0D1B,
        GL_ALPHA_SCALE                          = 0x0D1C,
        GL_ALPHA_BIAS                           = 0x0D1D,
        GL_DEPTH_SCALE                          = 0x0D1E,
        GL_DEPTH_BIAS                           = 0x0D1F,
        GL_PIXEL_MAP_S_TO_S_SIZE                = 0x0CB1,
        GL_PIXEL_MAP_I_TO_I_SIZE                = 0x0CB0,
        GL_PIXEL_MAP_I_TO_R_SIZE                = 0x0CB2,
        GL_PIXEL_MAP_I_TO_G_SIZE                = 0x0CB3,
        GL_PIXEL_MAP_I_TO_B_SIZE                = 0x0CB4,
        GL_PIXEL_MAP_I_TO_A_SIZE                = 0x0CB5,
        GL_PIXEL_MAP_R_TO_R_SIZE                = 0x0CB6,
        GL_PIXEL_MAP_G_TO_G_SIZE                = 0x0CB7,
        GL_PIXEL_MAP_B_TO_B_SIZE                = 0x0CB8,
        GL_PIXEL_MAP_A_TO_A_SIZE                = 0x0CB9,
        GL_PIXEL_MAP_S_TO_S                     = 0x0C71,
        GL_PIXEL_MAP_I_TO_I                     = 0x0C70,
        GL_PIXEL_MAP_I_TO_R                     = 0x0C72,
        GL_PIXEL_MAP_I_TO_G                     = 0x0C73,
        GL_PIXEL_MAP_I_TO_B                     = 0x0C74,
        GL_PIXEL_MAP_I_TO_A                     = 0x0C75,
        GL_PIXEL_MAP_R_TO_R                     = 0x0C76,
        GL_PIXEL_MAP_G_TO_G                     = 0x0C77,
        GL_PIXEL_MAP_B_TO_B                     = 0x0C78,
        GL_PIXEL_MAP_A_TO_A                     = 0x0C79,
        GL_ZOOM_X                               = 0x0D16,
        GL_ZOOM_Y                               = 0x0D17,
        GL_TEXTURE_ENV                          = 0x2300,
        GL_TEXTURE_ENV_MODE                     = 0x2200,
        GL_TEXTURE_ENV_COLOR                    = 0x2201,
        GL_TEXTURE_GEN_S                        = 0x0C60,
        GL_TEXTURE_GEN_T                        = 0x0C61,
        GL_TEXTURE_GEN_MODE                     = 0x2500,
        GL_TEXTURE_BORDER                       = 0x1005,
        GL_TEXTURE_LUMINANCE_SIZE               = 0x8060,
        GL_TEXTURE_INTENSITY_SIZE               = 0x8061,
        GL_OBJECT_LINEAR                        = 0x2401,
        GL_OBJECT_PLANE                         = 0x2501,
        GL_EYE_LINEAR                           = 0x2400,
        GL_EYE_PLANE                            = 0x2502,
        GL_SPHERE_MAP                           = 0x2402,
        GL_DECAL                                = 0x2101,
        GL_MODULATE                             = 0x2100,
        GL_CLAMP                                = 0x2900,
        GL_S                                    = 0x2000,
        GL_T                                    = 0x2001,
        GL_R                                    = 0x2002,
        GL_Q                                    = 0x2003,
        GL_TEXTURE_GEN_R                        = 0x0C62,
        GL_TEXTURE_GEN_Q                        = 0x0C63,
        GL_STACK_OVERFLOW                       = 0x0503,
        GL_STACK_UNDERFLOW                      = 0x0504,
        GL_CURRENT_BIT                          = 0x00000001,
        GL_POINT_BIT                            = 0x00000002,
        GL_LINE_BIT                             = 0x00000004,
        GL_POLYGON_BIT                          = 0x00000008,
        GL_POLYGON_STIPPLE_BIT                  = 0x00000010,
        GL_PIXEL_MODE_BIT                       = 0x00000020,
        GL_LIGHTING_BIT                         = 0x00000040,
        GL_FOG_BIT                              = 0x00000080,
        GL_ACCUM_BUFFER_BIT                     = 0x00000200,
        GL_VIEWPORT_BIT                         = 0x00000800,
        GL_TRANSFORM_BIT                        = 0x00001000,
        GL_ENABLE_BIT                           = 0x00002000,
        GL_HINT_BIT                             = 0x00008000,
        GL_EVAL_BIT                             = 0x00010000,
        GL_LIST_BIT                             = 0x00020000,
        GL_TEXTURE_BIT                          = 0x00040000,
        GL_SCISSOR_BIT                          = 0x00080000,
        GL_ALL_ATTRIB_BITS                      = 0x000FFFFF,
        GL_TEXTURE_PRIORITY                     = 0x8066,
        GL_TEXTURE_RESIDENT                     = 0x8067,
        GL_ALPHA4                               = 0x803B,
        GL_ALPHA8                               = 0x803C,
        GL_ALPHA12                              = 0x803D,
        GL_ALPHA16                              = 0x803E,
        GL_LUMINANCE4                           = 0x803F,
        GL_LUMINANCE8                           = 0x8040,
        GL_LUMINANCE12                          = 0x8041,
        GL_LUMINANCE16                          = 0x8042,
        GL_LUMINANCE4_ALPHA4                    = 0x8043,
        GL_LUMINANCE6_ALPHA2                    = 0x8044,
        GL_LUMINANCE8_ALPHA8                    = 0x8045,
        GL_LUMINANCE12_ALPHA4                   = 0x8046,
        GL_LUMINANCE12_ALPHA12                  = 0x8047,
        GL_LUMINANCE16_ALPHA16                  = 0x8048,
        GL_INTENSITY                            = 0x8049,
        GL_INTENSITY4                           = 0x804A,
        GL_INTENSITY8                           = 0x804B,
        GL_INTENSITY12                          = 0x804C,
        GL_INTENSITY16                          = 0x804D,
        GL_ALL_CLIENT_ATTRIB_BITS               = 0xFFFFFFFF,
        GL_CLIENT_ALL_ATTRIB_BITS               = 0xFFFFFFFF,
    }

    extern(System) @nogc nothrow {
        alias pglIsList = GLboolean function(GLuint);
        alias pglDeleteLists = void function(GLuint,GLsizei);
        alias pglGenLists = GLuint function(GLsizei);
        alias pglNewList = void function(GLuint,GLenum);
        alias pglEndList = void function();
        alias pglCallList = void function(GLuint);
        alias pglCallLists = void function(GLsizei,GLenum,const(void)*);
        alias pglListBase = void function(GLuint);
        alias pglBegin = void function(GLenum);
        alias pglEnd = void function();
        alias pglVertex2d = void function(GLdouble,GLdouble);
        alias pglVertex2f = void function(GLfloat,GLfloat);
        alias pglVertex2i = void function(GLint,GLint);
        alias pglVertex2s = void function(GLshort,GLshort);
        alias pglVertex3d = void function(GLdouble,GLdouble,GLdouble);
        alias pglVertex3f = void function(GLfloat,GLfloat,GLfloat);
        alias pglVertex3i = void function(GLint,GLint,GLint);
        alias pglVertex3s = void function(GLshort,GLshort,GLshort);
        alias pglVertex4d = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglVertex4f = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglVertex4i = void function(GLint,GLint,GLint,GLint);
        alias pglVertex4s = void function(GLshort,GLshort,GLshort,GLshort);
        alias pglVertex2dv = void function(const(GLdouble)*);
        alias pglVertex2fv = void function(const(GLfloat)*);
        alias pglVertex2iv = void function(const(GLint)*);
        alias pglVertex2sv = void function(const(GLshort)*);
        alias pglVertex3dv = void function(const(GLdouble)*);
        alias pglVertex3fv = void function(const(GLfloat)*);
        alias pglVertex3iv = void function(const(GLint)*);
        alias pglVertex3sv = void function(const(GLshort)*);
        alias pglVertex4dv = void function(const(GLdouble)*);
        alias pglVertex4fv = void function(const(GLfloat)*);
        alias pglVertex4iv = void function(const(GLint)*);
        alias pglVertex4sv = void function(const(GLshort)*);
        alias pglNormal3b = void function(GLbyte,GLbyte,GLbyte);
        alias pglNormal3d = void function(GLdouble,GLdouble,GLdouble);
        alias pglNormal3f = void function(GLfloat,GLfloat,GLfloat);
        alias pglNormal3i = void function(GLint,GLint,GLint);
        alias pglNormal3s = void function(GLshort,GLshort,GLshort);
        alias pglNormal3bv = void function(const(GLbyte)*);
        alias pglNormal3dv = void function(const(GLdouble)*);
        alias pglNormal3fv = void function(const(GLfloat)*);
        alias pglNormal3iv = void function(const(GLint)*);
        alias pglNormal3sv = void function(const(GLshort)*);
        alias pglIndexd = void function(GLdouble);
        alias pglIndexf = void function(GLfloat);
        alias pglIndexi = void function(GLint);
        alias pglIndexs = void function(GLshort);
        alias pglIndexub = void function(GLubyte);
        alias pglIndexdv = void function(const(GLdouble)*);
        alias pglIndexfv = void function(const(GLfloat)*);
        alias pglIndexiv = void function(const(GLint)*);
        alias pglIndexsv = void function(const(GLshort)*);
        alias pglIndexubv = void function(const(GLubyte)*);
        alias pglColor3b = void function(GLbyte,GLbyte,GLbyte);
        alias pglColor3d = void function(GLdouble,GLdouble,GLdouble);
        alias pglColor3f = void function(GLfloat,GLfloat,GLfloat);
        alias pglColor3i = void function(GLint,GLint,GLint);
        alias pglColor3s = void function(GLshort,GLshort,GLshort);
        alias pglColor3ub = void function(GLubyte,GLubyte,GLubyte);
        alias pglColor3ui = void function(GLuint,GLuint,GLuint);
        alias pglColor3us = void function(GLushort,GLushort,GLushort);
        alias pglColor4b = void function(GLbyte,GLbyte,GLbyte,GLbyte);
        alias pglColor4d = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglColor4f = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglColor4i = void function(GLint,GLint,GLint,GLint);
        alias pglColor4s = void function(GLshort,GLshort,GLshort,GLshort);
        alias pglColor4ub = void function(GLubyte,GLubyte,GLubyte,GLubyte);
        alias pglColor4ui = void function(GLuint,GLuint,GLuint,GLuint);
        alias pglColor4us = void function(GLushort,GLushort,GLushort,GLushort);
        alias pglColor3bv = void function(const(GLbyte)*);
        alias pglColor3dv = void function(const(GLdouble)*);
        alias pglColor3fv = void function(const(GLfloat)*);
        alias pglColor3iv = void function(const(GLint)*);
        alias pglColor3sv = void function(const(GLshort)*);
        alias pglColor3ubv = void function(const(GLubyte)*);
        alias pglColor3uiv = void function(const(GLuint)*);
        alias pglColor3usv = void function(const(GLushort)*);
        alias pglColor4bv = void function(const(GLbyte)*);
        alias pglColor4dv = void function(const(GLdouble)*);
        alias pglColor4fv = void function(const(GLfloat)*);
        alias pglColor4iv = void function(const(GLint)*);
        alias pglColor4sv = void function(const(GLshort)*);
        alias pglColor4ubv = void function(const(GLubyte)*);
        alias pglColor4uiv = void function(const(GLuint)*);
        alias pglColor4usv = void function(const(GLushort)*);
        alias pglTexCoord1d = void function(GLdouble);
        alias pglTexCoord1f = void function(GLfloat);
        alias pglTexCoord1i = void function(GLint);
        alias pglTexCoord1s = void function(GLshort);
        alias pglTexCoord2d = void function(GLdouble,GLdouble);
        alias pglTexCoord2f = void function(GLfloat,GLfloat);
        alias pglTexCoord2i = void function(GLint,GLint);
        alias pglTexCoord2s = void function(GLshort,GLshort);
        alias pglTexCoord3d = void function(GLdouble,GLdouble,GLdouble);
        alias pglTexCoord3f = void function(GLfloat,GLfloat,GLfloat);
        alias pglTexCoord3i = void function(GLint,GLint,GLint);
        alias pglTexCoord3s = void function(GLshort,GLshort,GLshort);
        alias pglTexCoord4d = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglTexCoord4f = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglTexCoord4i = void function(GLint,GLint,GLint,GLint);
        alias pglTexCoord4s = void function(GLshort,GLshort,GLshort,GLshort);
        alias pglTexCoord1dv = void function(const(GLdouble)*);
        alias pglTexCoord1fv = void function(const(GLfloat)*);
        alias pglTexCoord1iv = void function(const(GLint)*);
        alias pglTexCoord1sv = void function(const(GLshort)*);
        alias pglTexCoord2dv = void function(const(GLdouble)*);
        alias pglTexCoord2fv = void function(const(GLfloat)*);
        alias pglTexCoord2iv = void function(const(GLint)*);
        alias pglTexCoord2sv = void function(const(GLshort)*);
        alias pglTexCoord3dv = void function(const(GLdouble)*);
        alias pglTexCoord3fv = void function(const(GLfloat)*);
        alias pglTexCoord3iv = void function(const(GLint)*);
        alias pglTexCoord3sv = void function(const(GLshort)*);
        alias pglTexCoord4dv = void function(const(GLdouble)*);
        alias pglTexCoord4fv = void function(const(GLfloat)*);
        alias pglTexCoord4iv = void function(const(GLint)*);
        alias pglTexCoord4sv = void function(const(GLshort)*);
        alias pglRasterPos2d = void function(GLdouble,GLdouble);
        alias pglRasterPos2f = void function(GLfloat,GLfloat);
        alias pglRasterPos2i = void function(GLint,GLint);
        alias pglRasterPos2s = void function(GLshort,GLshort);
        alias pglRasterPos3d = void function(GLdouble,GLdouble,GLdouble);
        alias pglRasterPos3f = void function(GLfloat,GLfloat,GLfloat);
        alias pglRasterPos3i = void function(GLint,GLint,GLint);
        alias pglRasterPos3s = void function(GLshort,GLshort,GLshort);
        alias pglRasterPos4d = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglRasterPos4f = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglRasterPos4i = void function(GLint,GLint,GLint,GLint);
        alias pglRasterPos4s = void function(GLshort,GLshort,GLshort,GLshort);
        alias pglRasterPos2dv = void function(const(GLdouble)*);
        alias pglRasterPos2fv = void function(const(GLfloat)*);
        alias pglRasterPos2iv = void function(const(GLint)*);
        alias pglRasterPos2sv = void function(const(GLshort)*);
        alias pglRasterPos3dv = void function(const(GLdouble)*);
        alias pglRasterPos3fv = void function(const(GLfloat)*);
        alias pglRasterPos3iv = void function(const(GLint)*);
        alias pglRasterPos3sv = void function(const(GLshort)*);
        alias pglRasterPos4dv = void function(const(GLdouble)*);
        alias pglRasterPos4fv = void function(const(GLfloat)*);
        alias pglRasterPos4iv = void function(const(GLint)*);
        alias pglRasterPos4sv = void function(const(GLshort)*);
        alias pglRectd = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglRectf = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglRecti = void function(GLint,GLint,GLint,GLint);
        alias pglRects = void function(GLshort,GLshort,GLshort,GLshort);
        alias pglRectdv = void function(const(GLdouble)*, const(GLdouble)*);
        alias pglRectfv = void function(const(GLfloat)*, const(GLfloat)*);
        alias pglRectiv = void function(const(GLint)*, const(GLint)*);
        alias pglRectsv = void function(const(GLshort)*, const(GLshort)*);
        alias pglClipPlane = void function(GLenum,const(GLdouble)*);
        alias pglGetClipPlane = void function(GLenum,GLdouble*);
        alias pglShadeModel = void function(GLenum);
        alias pglLightf = void function(GLenum,GLenum,GLfloat);
        alias pglLighti = void function(GLenum,GLenum,GLint);
        alias pglLightfv = void function(GLenum,GLenum,const(GLfloat)*);
        alias pglLightiv = void function(GLenum,GLenum,const(GLint)*);
        alias pglGetLightfv = void function(GLenum,GLenum,GLfloat*);
        alias pglGetLightiv = void function(GLenum,GLenum,GLint*);
        alias pglLightModelf = void function(GLenum,GLfloat);
        alias pglLightModeli = void function(GLenum,GLint);
        alias pglLightModelfv = void function(GLenum,const(GLfloat)*);
        alias pglLightModeliv = void function(GLenum,const(GLint)*);
        alias pglMaterialf = void function(GLenum,GLenum,GLfloat);
        alias pglMateriali = void function(GLenum,GLenum,GLint);
        alias pglMaterialfv = void function(GLenum,GLenum,const(GLfloat)*);
        alias pglMaterialiv = void function(GLenum,GLenum,const(GLint)*);
        alias pglGetMaterialfv = void function(GLenum,GLenum,GLfloat*);
        alias pglGetMaterialiv = void function(GLenum,GLenum,GLint*);
        alias pglColorMaterial = void function(GLenum,GLenum);
        alias pglFogf = void function(GLenum,GLfloat);
        alias pglFogi = void function(GLenum,GLint);
        alias pglFogfv = void function(GLenum,const(GLfloat)*);
        alias pglFogiv = void function(GLenum,const(GLint)*);
        alias pglLineStipple = void function(GLint,GLushort);
        alias pglPolygonStipple = void function(const(GLubyte)*);
        alias pglGetPolygonStipple = void function(GLubyte*);
        alias pglTexGend = void function(GLenum,GLenum,GLdouble);
        alias pglTexGenf = void function(GLenum,GLenum,GLfloat);
        alias pglTexGeni = void function(GLenum,GLenum,GLint);
        alias pglTexGendv = void function(GLenum,GLenum,const(GLdouble)*);
        alias pglTexGenfv = void function(GLenum,GLenum,const(GLfloat)*);
        alias pglTexGeniv = void function(GLenum,GLenum,const(GLint)*);
        alias pglGetTexGendv = void function(GLenum,GLenum,GLdouble*);
        alias pglGetTexGenfv = void function(GLenum,GLenum,GLfloat*);
        alias pglGetTexGeniv = void function(GLenum,GLenum,GLint*);
        alias pglTexEnvf = void function(GLenum,GLenum,GLfloat);
        alias pglTexEnvi = void function(GLenum,GLenum,GLint);
        alias pglTexEnvfv = void function(GLenum,GLenum,const(GLfloat)*);
        alias pglTexEnviv = void function(GLenum,GLenum,const(GLint)*);
        alias pglGetTexEnvfv = void function(GLenum,GLenum,GLfloat*);
        alias pglGetTexEnviv = void function(GLenum,GLenum,GLint*);
        alias pglFeedbackBuffer = void function(GLsizei,GLenum,GLfloat*);
        alias pglPassThrough = void function(GLfloat);
        alias pglSelectBuffer = void function(GLsizei,GLuint*);
        alias pglInitNames = void function();
        alias pglLoadName = void function(GLuint);
        alias pglPushName = void function(GLuint);
        alias pglPopName = void function();
        alias pglRenderMode = GLint function(GLenum);
        alias pglClearAccum = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglAccum = void function(GLenum,GLfloat);
        alias pglClearIndex = void function(GLfloat c);
        alias pglIndexMask = void function(GLuint);
        alias pglPushAttrib = void function(GLbitfield);
        alias pglPopAttrib = void function();
        alias pglMap1d = void function(GLenum,GLdouble,GLdouble,GLint,GLint,const(GLdouble)*);
        alias pglMap1f = void function(GLenum,GLfloat,GLfloat,GLint,GLint,const(GLfloat)*);
        alias pglMap2d = void function(GLenum,GLdouble,GLdouble,GLint,GLint,GLdouble,GLdouble,GLint,GLint,GLdouble*);
        alias pglMap2f = void function(GLenum,GLfloat,GLfloat,GLint,GLint,GLfloat,GLfloat,GLint,GLint,GLfloat*);
        alias pglGetMapdv = void function(GLenum,GLenum,GLdouble*);
        alias pglGetMapfv = void function(GLenum,GLenum,GLfloat*);
        alias pglGetMapiv = void function(GLenum,GLenum,GLint*);
        alias pglEvalCoord1d = void function(GLdouble);
        alias pglEvalCoord1f = void function(GLfloat);
        alias pglEvalCoord1dv = void function(const(GLdouble)*);
        alias pglEvalCoord1fv = void function(const(GLfloat)*);
        alias pglEvalCoord2d = void function(GLdouble,GLdouble);
        alias pglEvalCoord2f = void function(GLfloat,GLfloat);
        alias pglEvalCoord2dv = void function(const(GLdouble)*);
        alias pglEvalCoord2fv = void function(const(GLfloat)*);
        alias pglMapGrid1d = void function(GLint,GLdouble,GLdouble);
        alias pglMapGrid1f = void function(GLint,GLfloat,GLfloat);
        alias pglMapGrid2d = void function(GLint,GLdouble,GLdouble,GLint,GLdouble,GLdouble);
        alias pglMapGrid2f = void function(GLint,GLfloat,GLfloat,GLint,GLfloat,GLfloat);
        alias pglEvalPoint1 = void function(GLint);
        alias pglEvalPoint2 = void function(GLint,GLint);
        alias pglEvalMesh1 = void function(GLenum,GLint,GLint);
        alias pglEvalMesh2 = void function(GLenum,GLint,GLint,GLint,GLint);
        alias pglAlphaFunc = void function(GLenum,GLclampf);
        alias pglPixelZoom = void function(GLfloat,GLfloat);
        alias pglPixelTransferf = void function(GLenum,GLfloat);
        alias pglPixelTransferi = void function(GLenum,GLint);
        alias pglPixelMapfv = void function(GLenum,GLint,const(GLfloat)*);
        alias pglPixelMapuiv = void function(GLenum,GLint,const(GLuint)*);
        alias pglPixelMapusv = void function(GLenum,GLint,const(GLushort)*);
        alias pglGetPixelMapfv = void function(GLenum,GLfloat*);
        alias pglGetPixelMapuiv = void function(GLenum,GLuint*);
        alias pglGetPixelMapusv = void function(GLenum,GLushort*);
        alias pglDrawPixels = void function(GLsizei,GLsizei,GLenum,GLenum,const(void)*);
        alias pglCopyPixels = void function(GLint,GLint,GLsizei,GLsizei,GLenum);
        alias pglFrustum = void function(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglMatrixMode = void function(GLenum);
        alias pglOrtho = void function(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglPushMatrix = void function();
        alias pglPopMatrix = void function();
        alias pglLoadIdentity = void function();
        alias pglLoadMatrixd = void function(const(GLdouble)*);
        alias pglLoadMatrixf = void function(const(GLfloat)*);
        alias pglMultMatrixd = void function(const(GLdouble)*);
        alias pglMultMatrixf = void function(const(GLfloat)*);
        alias pglRotated = void function(GLdouble,GLdouble,GLdouble,GLdouble);
        alias pglRotatef = void function(GLfloat,GLfloat,GLfloat,GLfloat);
        alias pglScaled = void function(GLdouble,GLdouble,GLdouble);
        alias pglScalef = void function(GLfloat,GLfloat,GLfloat);
        alias pglTranslated = void function(GLdouble,GLdouble,GLdouble);
        alias pglTranslatef = void function(GLfloat,GLfloat,GLfloat);
        alias pglVertexPointer = void function(GLint,GLenum,GLsizei,const(void)*);
        alias pglNormalPointer = void function(GLenum,GLsizei,const(void)*);
        alias pglColorPointer = void function(GLint,GLenum,GLsizei,const(void)*);
        alias pglIndexPointer = void function(GLenum,GLsizei,const(void)*);
        alias pglTexCoordPointer = void function(GLint,GLenum,GLsizei,const(void)*);
        alias pglEdgeFlagPointer = void function(GLsizei,const(void)*);
        alias pglArrayElement = void function(GLint);
        alias pglInterleavedArrays = void function(GLenum,GLsizei,const(void)*);
        alias pglEnableClientState = void function(GLenum);
        alias pglDisableClientState = void function(GLenum);
        alias pglPrioritizeTextures = void function(GLsizei,const(GLuint)*,const(GLclampf)*);
        alias pglAreTexturesResident = GLboolean function(GLsizei,const(GLuint)*,GLboolean*);
        alias pglPushClientAttrib = void function(GLbitfield);
        alias pglPopClientAttrib = void function();
    }

    __gshared {
        pglIsList glIsList;
        pglDeleteLists glDeleteLists;
        pglGenLists glGenLists;
        pglNewList glNewList;
        pglEndList glEndList;
        pglCallList glCallList;
        pglCallLists glCallLists;
        pglListBase glListBase;
        pglBegin glBegin;
        pglEnd glEnd;
        pglVertex2d glVertex2d;
        pglVertex2f glVertex2f;
        pglVertex2i glVertex2i;
        pglVertex2s glVertex2s;
        pglVertex3d glVertex3d;
        pglVertex3f glVertex3f;
        pglVertex3i glVertex3i;
        pglVertex3s glVertex3s;
        pglVertex4d glVertex4d;
        pglVertex4f glVertex4f;
        pglVertex4i glVertex4i;
        pglVertex4s glVertex4s;
        pglVertex2dv glVertex2dv;
        pglVertex2fv glVertex2fv;
        pglVertex2iv glVertex2iv;
        pglVertex2sv glVertex2sv;
        pglVertex3dv glVertex3dv;
        pglVertex3fv glVertex3fv;
        pglVertex3iv glVertex3iv;
        pglVertex3sv glVertex3sv;
        pglVertex4dv glVertex4dv;
        pglVertex4fv glVertex4fv;
        pglVertex4iv glVertex4iv;
        pglVertex4sv glVertex4sv;
        pglNormal3b glNormal3b;
        pglNormal3d glNormal3d;
        pglNormal3f glNormal3f;
        pglNormal3i glNormal3i;
        pglNormal3s glNormal3s;
        pglNormal3bv glNormal3bv;
        pglNormal3dv glNormal3dv;
        pglNormal3fv glNormal3fv;
        pglNormal3iv glNormal3iv;
        pglNormal3sv glNormal3sv;
        pglIndexd glIndexd;
        pglIndexf glIndexf;
        pglIndexi glIndexi;
        pglIndexs glIndexs;
        pglIndexub glIndexub;
        pglIndexdv glIndexdv;
        pglIndexfv glIndexfv;
        pglIndexiv glIndexiv;
        pglIndexsv glIndexsv;
        pglIndexubv glIndexubv;
        pglColor3b glColor3b;
        pglColor3d glColor3d;
        pglColor3f glColor3f;
        pglColor3i glColor3i;
        pglColor3s glColor3s;
        pglColor3ub glColor3ub;
        pglColor3ui glColor3ui;
        pglColor3us glColor3us;
        pglColor4b glColor4b;
        pglColor4d glColor4d;
        pglColor4f glColor4f;
        pglColor4i glColor4i;
        pglColor4s glColor4s;
        pglColor4ub glColor4ub;
        pglColor4ui glColor4ui;
        pglColor4us glColor4us;
        pglColor3bv glColor3bv;
        pglColor3dv glColor3dv;
        pglColor3fv glColor3fv;
        pglColor3iv glColor3iv;
        pglColor3sv glColor3sv;
        pglColor3ubv glColor3ubv;
        pglColor3uiv glColor3uiv;
        pglColor3usv glColor3usv;
        pglColor4bv glColor4bv;
        pglColor4dv glColor4dv;
        pglColor4fv glColor4fv;
        pglColor4iv glColor4iv;
        pglColor4sv glColor4sv;
        pglColor4ubv glColor4ubv;
        pglColor4uiv glColor4uiv;
        pglColor4usv glColor4usv;
        pglTexCoord1d glTexCoord1d;
        pglTexCoord1f glTexCoord1f;
        pglTexCoord1i glTexCoord1i;
        pglTexCoord1s glTexCoord1s;
        pglTexCoord2d glTexCoord2d;
        pglTexCoord2f glTexCoord2f;
        pglTexCoord2i glTexCoord2i;
        pglTexCoord2s glTexCoord2s;
        pglTexCoord3d glTexCoord3d;
        pglTexCoord3f glTexCoord3f;
        pglTexCoord3i glTexCoord3i;
        pglTexCoord3s glTexCoord3s;
        pglTexCoord4d glTexCoord4d;
        pglTexCoord4f glTexCoord4f;
        pglTexCoord4i glTexCoord4i;
        pglTexCoord4s glTexCoord4s;
        pglTexCoord1dv glTexCoord1dv;
        pglTexCoord1fv glTexCoord1fv;
        pglTexCoord1iv glTexCoord1iv;
        pglTexCoord1sv glTexCoord1sv;
        pglTexCoord2dv glTexCoord2dv;
        pglTexCoord2fv glTexCoord2fv;
        pglTexCoord2iv glTexCoord2iv;
        pglTexCoord2sv glTexCoord2sv;
        pglTexCoord3dv glTexCoord3dv;
        pglTexCoord3fv glTexCoord3fv;
        pglTexCoord3iv glTexCoord3iv;
        pglTexCoord3sv glTexCoord3sv;
        pglTexCoord4dv glTexCoord4dv;
        pglTexCoord4fv glTexCoord4fv;
        pglTexCoord4iv glTexCoord4iv;
        pglTexCoord4sv glTexCoord4sv;
        pglRasterPos2d glRasterPos2d;
        pglRasterPos2f glRasterPos2f;
        pglRasterPos2i glRasterPos2i;
        pglRasterPos2s glRasterPos2s;
        pglRasterPos3d glRasterPos3d;
        pglRasterPos3f glRasterPos3f;
        pglRasterPos3i glRasterPos3i;
        pglRasterPos3s glRasterPos3s;
        pglRasterPos4d glRasterPos4d;
        pglRasterPos4f glRasterPos4f;
        pglRasterPos4i glRasterPos4i;
        pglRasterPos4s glRasterPos4s;
        pglRasterPos2dv glRasterPos2dv;
        pglRasterPos2fv glRasterPos2fv;
        pglRasterPos2iv glRasterPos2iv;
        pglRasterPos2sv glRasterPos2sv;
        pglRasterPos3dv glRasterPos3dv;
        pglRasterPos3fv glRasterPos3fv;
        pglRasterPos3iv glRasterPos3iv;
        pglRasterPos3sv glRasterPos3sv;
        pglRasterPos4dv glRasterPos4dv;
        pglRasterPos4fv glRasterPos4fv;
        pglRasterPos4iv glRasterPos4iv;
        pglRasterPos4sv glRasterPos4sv;
        pglRectd glRectd;
        pglRectf glRectf;
        pglRecti glRecti;
        pglRects glRects;
        pglRectdv glRectdv;
        pglRectfv glRectfv;
        pglRectiv glRectiv;
        pglRectsv glRectsv;
        pglClipPlane glClipPlane;
        pglGetClipPlane glGetClipPlane;
        pglShadeModel glShadeModel;
        pglLightf glLightf;
        pglLighti glLighti;
        pglLightfv glLightfv;
        pglLightiv glLightiv;
        pglGetLightfv glGetLightfv;
        pglGetLightiv glGetLightiv;
        pglLightModelf glLightModelf;
        pglLightModeli glLightModeli;
        pglLightModelfv glLightModelfv;
        pglLightModeliv glLightModeliv;
        pglMaterialf glMaterialf;
        pglMateriali glMateriali;
        pglMaterialfv glMaterialfv;
        pglMaterialiv glMaterialiv;
        pglGetMaterialfv glGetMaterialfv;
        pglGetMaterialiv glGetMaterialiv;
        pglColorMaterial glColorMaterial;
        pglFogf glFogf;
        pglFogi glFogi;
        pglFogfv glFogfv;
        pglFogiv glFogiv;
        pglLineStipple glLineStipple;
        pglPolygonStipple glPolygonStipple;
        pglGetPolygonStipple glGetPolygonStipple;
        pglTexGend glTexGend;
        pglTexGenf glTexGenf;
        pglTexGeni glTexGeni;
        pglTexGendv glTexGendv;
        pglTexGenfv glTexGenfv;
        pglTexGeniv glTexGeniv;
        pglGetTexGendv glGetTexGendv;
        pglGetTexGenfv glGetTexGenfv;
        pglGetTexGeniv glGetTexGeniv;
        pglTexEnvf glTexEnvf;
        pglTexEnvi glTexEnvi;
        pglTexEnvfv glTexEnvfv;
        pglTexEnviv glTexEnviv;
        pglGetTexEnvfv glGetTexEnvfv;
        pglGetTexEnviv glGetTexEnviv;
        pglFeedbackBuffer glFeedbackBuffer;
        pglPassThrough glPassThrough;
        pglSelectBuffer glSelectBuffer;
        pglInitNames glInitNames;
        pglLoadName glLoadName;
        pglPushName glPushName;
        pglPopName glPopName;
        pglRenderMode glRenderMode;
        pglClearAccum glClearAccum;
        pglAccum glAccum;
        pglClearIndex glClearIndex;
        pglIndexMask glIndexMask;
        pglPushAttrib glPushAttrib;
        pglPopAttrib glPopAttrib;
        pglMap1d glMap1d;
        pglMap1f glMap1f;
        pglMap2d glMap2d;
        pglMap2f glMap2f;
        pglGetMapdv glGetMapdv;
        pglGetMapfv glGetMapfv;
        pglGetMapiv glGetMapiv;
        pglEvalCoord1d glEvalCoord1d;
        pglEvalCoord1f glEvalCoord1f;
        pglEvalCoord1dv glEvalCoord1dv;
        pglEvalCoord1fv glEvalCoord1fv;
        pglEvalCoord2d glEvalCoord2d;
        pglEvalCoord2f glEvalCoord2f;
        pglEvalCoord2dv glEvalCoord2dv;
        pglEvalCoord2fv glEvalCoord2fv;
        pglMapGrid1d glMapGrid1d;
        pglMapGrid1f glMapGrid1f;
        pglMapGrid2d glMapGrid2d;
        pglMapGrid2f glMapGrid2f;
        pglEvalPoint1 glEvalPoint1;
        pglEvalPoint2 glEvalPoint2;
        pglEvalMesh1 glEvalMesh1;
        pglEvalMesh2 glEvalMesh2;
        pglAlphaFunc glAlphaFunc;
        pglPixelZoom glPixelZoom;
        pglPixelTransferf glPixelTransferf;
        pglPixelTransferi glPixelTransferi;
        pglPixelMapfv glPixelMapfv;
        pglPixelMapuiv glPixelMapuiv;
        pglPixelMapusv glPixelMapusv;
        pglGetPixelMapfv glGetPixelMapfv;
        pglGetPixelMapuiv glGetPixelMapuiv;
        pglGetPixelMapusv glGetPixelMapusv;
        pglDrawPixels glDrawPixels;
        pglCopyPixels glCopyPixels;
        pglFrustum glFrustum;
        pglMatrixMode glMatrixMode;
        pglOrtho glOrtho;
        pglPushMatrix glPushMatrix;
        pglPopMatrix glPopMatrix;
        pglLoadIdentity glLoadIdentity;
        pglLoadMatrixd glLoadMatrixd;
        pglLoadMatrixf glLoadMatrixf;
        pglMultMatrixd glMultMatrixd;
        pglMultMatrixf glMultMatrixf;
        pglRotated glRotated;
        pglRotatef glRotatef;
        pglScaled glScaled;
        pglScalef glScalef;
        pglTranslated glTranslated;
        pglTranslatef glTranslatef;
        pglVertexPointer glVertexPointer;
        pglNormalPointer glNormalPointer;
        pglColorPointer glColorPointer;
        pglIndexPointer glIndexPointer;
        pglTexCoordPointer glTexCoordPointer;
        pglEdgeFlagPointer glEdgeFlagPointer;
        pglArrayElement glArrayElement;
        pglInterleavedArrays glInterleavedArrays;
        pglEnableClientState glEnableClientState;
        pglDisableClientState glDisableClientState;
        pglPrioritizeTextures glPrioritizeTextures;
        pglAreTexturesResident glAreTexturesResident;
        pglPushClientAttrib glPushClientAttrib;
        pglPopClientAttrib glPopClientAttrib;
    }

    package(bindbc.opengl.bind) @nogc nothrow
    bool loadDeprecatedGL11(SharedLib lib)
    {
        auto startErrorCount = errorCount();

        lib.bindSymbol(cast(void**)&glIsList, "glIsList");
        lib.bindSymbol(cast(void**)&glDeleteLists, "glDeleteLists");
        lib.bindSymbol(cast(void**)&glGenLists, "glGenLists");
        lib.bindSymbol(cast(void**)&glNewList, "glNewList");
        lib.bindSymbol(cast(void**)&glEndList, "glEndList");
        lib.bindSymbol(cast(void**)&glCallList, "glCallList");
        lib.bindSymbol(cast(void**)&glCallLists, "glCallLists");
        lib.bindSymbol(cast(void**)&glListBase, "glListBase");
        lib.bindSymbol(cast(void**)&glBegin, "glBegin");
        lib.bindSymbol(cast(void**)&glEnd, "glEnd");
        lib.bindSymbol(cast(void**)&glVertex2d, "glVertex2d");
        lib.bindSymbol(cast(void**)&glVertex2f, "glVertex2f");
        lib.bindSymbol(cast(void**)&glVertex2i, "glVertex2i");
        lib.bindSymbol(cast(void**)&glVertex2s, "glVertex2s");
        lib.bindSymbol(cast(void**)&glVertex3d, "glVertex3d");
        lib.bindSymbol(cast(void**)&glVertex3f, "glVertex3f");
        lib.bindSymbol(cast(void**)&glVertex3i, "glVertex3i");
        lib.bindSymbol(cast(void**)&glVertex3s, "glVertex3s");
        lib.bindSymbol(cast(void**)&glVertex4d, "glVertex4d");
        lib.bindSymbol(cast(void**)&glVertex4f, "glVertex4f");
        lib.bindSymbol(cast(void**)&glVertex4i, "glVertex4i");
        lib.bindSymbol(cast(void**)&glVertex4s, "glVertex4s");
        lib.bindSymbol(cast(void**)&glVertex2dv, "glVertex2dv");
        lib.bindSymbol(cast(void**)&glVertex2fv, "glVertex2fv");
        lib.bindSymbol(cast(void**)&glVertex2iv, "glVertex2iv");
        lib.bindSymbol(cast(void**)&glVertex2sv, "glVertex2sv");
        lib.bindSymbol(cast(void**)&glVertex3dv, "glVertex3dv");
        lib.bindSymbol(cast(void**)&glVertex3fv, "glVertex3fv");
        lib.bindSymbol(cast(void**)&glVertex3iv, "glVertex3iv");
        lib.bindSymbol(cast(void**)&glVertex3sv, "glVertex3sv");
        lib.bindSymbol(cast(void**)&glVertex4dv, "glVertex4dv");
        lib.bindSymbol(cast(void**)&glVertex4fv, "glVertex4fv");
        lib.bindSymbol(cast(void**)&glVertex4iv, "glVertex4iv");
        lib.bindSymbol(cast(void**)&glVertex4sv, "glVertex4sv");
        lib.bindSymbol(cast(void**)&glNormal3b, "glNormal3b");
        lib.bindSymbol(cast(void**)&glNormal3d, "glNormal3d");
        lib.bindSymbol(cast(void**)&glNormal3f, "glNormal3f");
        lib.bindSymbol(cast(void**)&glNormal3i, "glNormal3i");
        lib.bindSymbol(cast(void**)&glNormal3s, "glNormal3s");
        lib.bindSymbol(cast(void**)&glNormal3bv, "glNormal3bv");
        lib.bindSymbol(cast(void**)&glNormal3dv, "glNormal3dv");
        lib.bindSymbol(cast(void**)&glNormal3fv, "glNormal3fv");
        lib.bindSymbol(cast(void**)&glNormal3iv, "glNormal3iv");
        lib.bindSymbol(cast(void**)&glNormal3sv, "glNormal3sv");
        lib.bindSymbol(cast(void**)&glIndexd, "glIndexd");
        lib.bindSymbol(cast(void**)&glIndexf, "glIndexf");
        lib.bindSymbol(cast(void**)&glIndexi, "glIndexi");
        lib.bindSymbol(cast(void**)&glIndexs, "glIndexs");
        lib.bindSymbol(cast(void**)&glIndexub, "glIndexub");
        lib.bindSymbol(cast(void**)&glIndexdv, "glIndexdv");
        lib.bindSymbol(cast(void**)&glIndexfv, "glIndexfv");
        lib.bindSymbol(cast(void**)&glIndexiv, "glIndexiv");
        lib.bindSymbol(cast(void**)&glIndexsv, "glIndexsv");
        lib.bindSymbol(cast(void**)&glIndexubv, "glIndexubv");
        lib.bindSymbol(cast(void**)&glColor3b, "glColor3b");
        lib.bindSymbol(cast(void**)&glColor3d, "glColor3d");
        lib.bindSymbol(cast(void**)&glColor3f, "glColor3f");
        lib.bindSymbol(cast(void**)&glColor3i, "glColor3i");
        lib.bindSymbol(cast(void**)&glColor3s, "glColor3s");
        lib.bindSymbol(cast(void**)&glColor3ub, "glColor3ub");
        lib.bindSymbol(cast(void**)&glColor3ui, "glColor3ui");
        lib.bindSymbol(cast(void**)&glColor3us, "glColor3us");
        lib.bindSymbol(cast(void**)&glColor4b, "glColor4b");
        lib.bindSymbol(cast(void**)&glColor4d, "glColor4d");
        lib.bindSymbol(cast(void**)&glColor4f, "glColor4f");
        lib.bindSymbol(cast(void**)&glColor4i, "glColor4i");
        lib.bindSymbol(cast(void**)&glColor4s, "glColor4s");
        lib.bindSymbol(cast(void**)&glColor4ub, "glColor4ub");
        lib.bindSymbol(cast(void**)&glColor4ui, "glColor4ui");
        lib.bindSymbol(cast(void**)&glColor4us, "glColor4us");
        lib.bindSymbol(cast(void**)&glColor3bv, "glColor3bv");
        lib.bindSymbol(cast(void**)&glColor3dv, "glColor3dv");
        lib.bindSymbol(cast(void**)&glColor3fv, "glColor3fv");
        lib.bindSymbol(cast(void**)&glColor3iv, "glColor3iv");
        lib.bindSymbol(cast(void**)&glColor3sv, "glColor3sv");
        lib.bindSymbol(cast(void**)&glColor3ubv, "glColor3ubv");
        lib.bindSymbol(cast(void**)&glColor3uiv, "glColor3uiv");
        lib.bindSymbol(cast(void**)&glColor3usv, "glColor3usv");
        lib.bindSymbol(cast(void**)&glColor4bv, "glColor4bv");
        lib.bindSymbol(cast(void**)&glColor4dv, "glColor4dv");
        lib.bindSymbol(cast(void**)&glColor4fv, "glColor4fv");
        lib.bindSymbol(cast(void**)&glColor4iv, "glColor4iv");
        lib.bindSymbol(cast(void**)&glColor4sv, "glColor4sv");
        lib.bindSymbol(cast(void**)&glColor4ubv, "glColor4ubv");
        lib.bindSymbol(cast(void**)&glColor4uiv, "glColor4uiv");
        lib.bindSymbol(cast(void**)&glColor4usv, "glColor4usv");
        lib.bindSymbol(cast(void**)&glTexCoord1d, "glTexCoord1d");
        lib.bindSymbol(cast(void**)&glTexCoord1f, "glTexCoord1f");
        lib.bindSymbol(cast(void**)&glTexCoord1i, "glTexCoord1i");
        lib.bindSymbol(cast(void**)&glTexCoord1s, "glTexCoord1s");
        lib.bindSymbol(cast(void**)&glTexCoord2d, "glTexCoord2d");
        lib.bindSymbol(cast(void**)&glTexCoord2f, "glTexCoord2f");
        lib.bindSymbol(cast(void**)&glTexCoord2i, "glTexCoord2i");
        lib.bindSymbol(cast(void**)&glTexCoord2s, "glTexCoord2s");
        lib.bindSymbol(cast(void**)&glTexCoord3d, "glTexCoord3d");
        lib.bindSymbol(cast(void**)&glTexCoord3f, "glTexCoord3f");
        lib.bindSymbol(cast(void**)&glTexCoord3i, "glTexCoord3i");
        lib.bindSymbol(cast(void**)&glTexCoord3s, "glTexCoord3s");
        lib.bindSymbol(cast(void**)&glTexCoord4d, "glTexCoord4d");
        lib.bindSymbol(cast(void**)&glTexCoord4f, "glTexCoord4f");
        lib.bindSymbol(cast(void**)&glTexCoord4i, "glTexCoord4i");
        lib.bindSymbol(cast(void**)&glTexCoord4s, "glTexCoord4s");
        lib.bindSymbol(cast(void**)&glTexCoord1dv, "glTexCoord1dv");
        lib.bindSymbol(cast(void**)&glTexCoord1fv, "glTexCoord1fv");
        lib.bindSymbol(cast(void**)&glTexCoord1iv, "glTexCoord1iv");
        lib.bindSymbol(cast(void**)&glTexCoord1sv, "glTexCoord1sv");
        lib.bindSymbol(cast(void**)&glTexCoord2dv, "glTexCoord2dv");
        lib.bindSymbol(cast(void**)&glTexCoord2fv, "glTexCoord2fv");
        lib.bindSymbol(cast(void**)&glTexCoord2iv, "glTexCoord2iv");
        lib.bindSymbol(cast(void**)&glTexCoord2sv, "glTexCoord2sv");
        lib.bindSymbol(cast(void**)&glTexCoord3dv, "glTexCoord3dv");
        lib.bindSymbol(cast(void**)&glTexCoord3fv, "glTexCoord3fv");
        lib.bindSymbol(cast(void**)&glTexCoord3iv, "glTexCoord3iv");
        lib.bindSymbol(cast(void**)&glTexCoord3sv, "glTexCoord3sv");
        lib.bindSymbol(cast(void**)&glTexCoord4dv, "glTexCoord4dv");
        lib.bindSymbol(cast(void**)&glTexCoord4fv, "glTexCoord4fv");
        lib.bindSymbol(cast(void**)&glTexCoord4iv, "glTexCoord4iv");
        lib.bindSymbol(cast(void**)&glTexCoord4sv, "glTexCoord4sv");
        lib.bindSymbol(cast(void**)&glRasterPos2d, "glRasterPos2d");
        lib.bindSymbol(cast(void**)&glRasterPos2f, "glRasterPos2f");
        lib.bindSymbol(cast(void**)&glRasterPos2i, "glRasterPos2i");
        lib.bindSymbol(cast(void**)&glRasterPos2s, "glRasterPos2s");
        lib.bindSymbol(cast(void**)&glRasterPos3d, "glRasterPos3d");
        lib.bindSymbol(cast(void**)&glRasterPos3f, "glRasterPos3f");
        lib.bindSymbol(cast(void**)&glRasterPos3i, "glRasterPos3i");
        lib.bindSymbol(cast(void**)&glRasterPos3s, "glRasterPos3s");
        lib.bindSymbol(cast(void**)&glRasterPos4d, "glRasterPos4d");
        lib.bindSymbol(cast(void**)&glRasterPos4f, "glRasterPos4f");
        lib.bindSymbol(cast(void**)&glRasterPos4i, "glRasterPos4i");
        lib.bindSymbol(cast(void**)&glRasterPos4s, "glRasterPos4s");
        lib.bindSymbol(cast(void**)&glRasterPos2dv, "glRasterPos2dv");
        lib.bindSymbol(cast(void**)&glRasterPos2fv, "glRasterPos2fv");
        lib.bindSymbol(cast(void**)&glRasterPos2iv, "glRasterPos2iv");
        lib.bindSymbol(cast(void**)&glRasterPos2sv, "glRasterPos2sv");
        lib.bindSymbol(cast(void**)&glRasterPos3dv, "glRasterPos3dv");
        lib.bindSymbol(cast(void**)&glRasterPos3fv, "glRasterPos3fv");
        lib.bindSymbol(cast(void**)&glRasterPos3iv, "glRasterPos3iv");
        lib.bindSymbol(cast(void**)&glRasterPos3sv, "glRasterPos3sv");
        lib.bindSymbol(cast(void**)&glRasterPos4dv, "glRasterPos4dv");
        lib.bindSymbol(cast(void**)&glRasterPos4fv, "glRasterPos4fv");
        lib.bindSymbol(cast(void**)&glRasterPos4iv, "glRasterPos4iv");
        lib.bindSymbol(cast(void**)&glRasterPos4sv, "glRasterPos4sv");
        lib.bindSymbol(cast(void**)&glRectd, "glRectd");
        lib.bindSymbol(cast(void**)&glRectf, "glRectf");
        lib.bindSymbol(cast(void**)&glRecti, "glRecti");
        lib.bindSymbol(cast(void**)&glRects, "glRects");
        lib.bindSymbol(cast(void**)&glRectdv, "glRectdv");
        lib.bindSymbol(cast(void**)&glRectfv, "glRectfv");
        lib.bindSymbol(cast(void**)&glRectiv, "glRectiv");
        lib.bindSymbol(cast(void**)&glRectsv, "glRectsv");
        lib.bindSymbol(cast(void**)&glClipPlane, "glClipPlane");
        lib.bindSymbol(cast(void**)&glGetClipPlane, "glGetClipPlane");
        lib.bindSymbol(cast(void**)&glShadeModel, "glShadeModel");
        lib.bindSymbol(cast(void**)&glLightf, "glLightf");
        lib.bindSymbol(cast(void**)&glLighti, "glLighti");
        lib.bindSymbol(cast(void**)&glLightfv, "glLightfv");
        lib.bindSymbol(cast(void**)&glLightiv, "glLightiv");
        lib.bindSymbol(cast(void**)&glGetLightfv, "glGetLightfv");
        lib.bindSymbol(cast(void**)&glGetLightiv, "glGetLightiv");
        lib.bindSymbol(cast(void**)&glLightModelf, "glLightModelf");
        lib.bindSymbol(cast(void**)&glLightModeli, "glLightModeli");
        lib.bindSymbol(cast(void**)&glLightModelfv, "glLightModelfv");
        lib.bindSymbol(cast(void**)&glLightModeliv, "glLightModeliv");
        lib.bindSymbol(cast(void**)&glMaterialf, "glMaterialf");
        lib.bindSymbol(cast(void**)&glMateriali, "glMateriali");
        lib.bindSymbol(cast(void**)&glMaterialfv, "glMaterialfv");
        lib.bindSymbol(cast(void**)&glMaterialiv, "glMaterialiv");
        lib.bindSymbol(cast(void**)&glGetMaterialfv, "glGetMaterialfv");
        lib.bindSymbol(cast(void**)&glGetMaterialiv, "glGetMaterialiv");
        lib.bindSymbol(cast(void**)&glColorMaterial, "glColorMaterial");
        lib.bindSymbol(cast(void**)&glColorMaterial, "glColorMaterial");
        lib.bindSymbol(cast(void**)&glFogf, "glFogf");
        lib.bindSymbol(cast(void**)&glFogi, "glFogi");
        lib.bindSymbol(cast(void**)&glFogfv, "glFogfv");
        lib.bindSymbol(cast(void**)&glFogiv, "glFogiv");
        lib.bindSymbol(cast(void**)&glLineStipple, "glLineStipple");
        lib.bindSymbol(cast(void**)&glPolygonStipple, "glPolygonStipple");
        lib.bindSymbol(cast(void**)&glGetPolygonStipple, "glGetPolygonStipple");
        lib.bindSymbol(cast(void**)&glTexGend, "glTexGend");
        lib.bindSymbol(cast(void**)&glTexGenf, "glTexGenf");
        lib.bindSymbol(cast(void**)&glTexGeni, "glTexGeni");
        lib.bindSymbol(cast(void**)&glTexGendv, "glTexGendv");
        lib.bindSymbol(cast(void**)&glTexGenfv, "glTexGenfv");
        lib.bindSymbol(cast(void**)&glTexGeniv, "glTexGeniv");
        lib.bindSymbol(cast(void**)&glGetTexGendv, "glGetTexGendv");
        lib.bindSymbol(cast(void**)&glGetTexGenfv, "glGetTexGenfv");
        lib.bindSymbol(cast(void**)&glGetTexGeniv, "glGetTexGeniv");
        lib.bindSymbol(cast(void**)&glTexEnvf, "glTexEnvf");
        lib.bindSymbol(cast(void**)&glTexEnvi, "glTexEnvi");
        lib.bindSymbol(cast(void**)&glTexEnvfv, "glTexEnvfv");
        lib.bindSymbol(cast(void**)&glTexEnviv, "glTexEnviv");
        lib.bindSymbol(cast(void**)&glGetTexEnvfv, "glGetTexEnvfv");
        lib.bindSymbol(cast(void**)&glGetTexEnviv, "glGetTexEnviv");
        lib.bindSymbol(cast(void**)&glFeedbackBuffer, "glFeedbackBuffer");
        lib.bindSymbol(cast(void**)&glPassThrough, "glPassThrough");
        lib.bindSymbol(cast(void**)&glSelectBuffer, "glSelectBuffer");
        lib.bindSymbol(cast(void**)&glInitNames, "glInitNames");
        lib.bindSymbol(cast(void**)&glLoadName, "glLoadName");
        lib.bindSymbol(cast(void**)&glPushName, "glPushName");
        lib.bindSymbol(cast(void**)&glPopName, "glPopName");
        lib.bindSymbol(cast(void**)&glRenderMode, "glRenderMode");
        lib.bindSymbol(cast(void**)&glClearAccum, "glClearAccum");
        lib.bindSymbol(cast(void**)&glAccum, "glAccum");
        lib.bindSymbol(cast(void**)&glClearIndex, "glClearIndex");
        lib.bindSymbol(cast(void**)&glIndexMask, "glIndexMask");
        lib.bindSymbol(cast(void**)&glPushAttrib, "glPushAttrib");
        lib.bindSymbol(cast(void**)&glPopAttrib, "glPopAttrib");
        lib.bindSymbol(cast(void**)&glMap1d, "glMap1d");
        lib.bindSymbol(cast(void**)&glMap1f, "glMap1f");
        lib.bindSymbol(cast(void**)&glMap2d, "glMap2d");
        lib.bindSymbol(cast(void**)&glMap2f, "glMap2f");
        lib.bindSymbol(cast(void**)&glGetMapdv, "glGetMapdv");
        lib.bindSymbol(cast(void**)&glGetMapfv, "glGetMapfv");
        lib.bindSymbol(cast(void**)&glGetMapiv, "glGetMapiv");
        lib.bindSymbol(cast(void**)&glEvalCoord1d, "glEvalCoord1d");
        lib.bindSymbol(cast(void**)&glEvalCoord1f, "glEvalCoord1f");
        lib.bindSymbol(cast(void**)&glEvalCoord1dv, "glEvalCoord1dv");
        lib.bindSymbol(cast(void**)&glEvalCoord1fv, "glEvalCoord1fv");
        lib.bindSymbol(cast(void**)&glEvalCoord2d, "glEvalCoord2d");
        lib.bindSymbol(cast(void**)&glEvalCoord2f, "glEvalCoord2f");
        lib.bindSymbol(cast(void**)&glEvalCoord2dv, "glEvalCoord2dv");
        lib.bindSymbol(cast(void**)&glEvalCoord2fv, "glEvalCoord2fv");
        lib.bindSymbol(cast(void**)&glMapGrid1d, "glMapGrid1d");
        lib.bindSymbol(cast(void**)&glMapGrid1f, "glMapGrid1f");
        lib.bindSymbol(cast(void**)&glMapGrid2d, "glMapGrid2d");
        lib.bindSymbol(cast(void**)&glMapGrid2f, "glMapGrid2f");
        lib.bindSymbol(cast(void**)&glEvalPoint1, "glEvalPoint1");
        lib.bindSymbol(cast(void**)&glEvalPoint2, "glEvalPoint2");
        lib.bindSymbol(cast(void**)&glEvalMesh1, "glEvalMesh1");
        lib.bindSymbol(cast(void**)&glEvalMesh2, "glEvalMesh2");
        lib.bindSymbol(cast(void**)&glAlphaFunc, "glAlphaFunc");
        lib.bindSymbol(cast(void**)&glPixelZoom, "glPixelZoom");
        lib.bindSymbol(cast(void**)&glPixelTransferf, "glPixelTransferf");
        lib.bindSymbol(cast(void**)&glPixelTransferi, "glPixelTransferi");
        lib.bindSymbol(cast(void**)&glPixelMapfv, "glPixelMapfv");
        lib.bindSymbol(cast(void**)&glPixelMapuiv, "glPixelMapuiv");
        lib.bindSymbol(cast(void**)&glPixelMapusv, "glPixelMapusv");
        lib.bindSymbol(cast(void**)&glGetPixelMapfv, "glGetPixelMapfv");
        lib.bindSymbol(cast(void**)&glGetPixelMapuiv, "glGetPixelMapuiv");
        lib.bindSymbol(cast(void**)&glGetPixelMapusv, "glGetPixelMapusv");
        lib.bindSymbol(cast(void**)&glDrawPixels, "glDrawPixels");
        lib.bindSymbol(cast(void**)&glCopyPixels, "glCopyPixels");
        lib.bindSymbol(cast(void**)&glFrustum, "glFrustum");
        lib.bindSymbol(cast(void**)&glMatrixMode, "glMatrixMode");
        lib.bindSymbol(cast(void**)&glOrtho, "glOrtho");
        lib.bindSymbol(cast(void**)&glFrustum, "glFrustum");
        lib.bindSymbol(cast(void**)&glPushMatrix, "glPushMatrix");
        lib.bindSymbol(cast(void**)&glPopMatrix, "glPopMatrix");
        lib.bindSymbol(cast(void**)&glLoadIdentity, "glLoadIdentity");
        lib.bindSymbol(cast(void**)&glLoadMatrixd, "glLoadMatrixd");
        lib.bindSymbol(cast(void**)&glLoadMatrixf, "glLoadMatrixf");
        lib.bindSymbol(cast(void**)&glMultMatrixd, "glMultMatrixd");
        lib.bindSymbol(cast(void**)&glMultMatrixf, "glMultMatrixf");
        lib.bindSymbol(cast(void**)&glRotated, "glRotated");
        lib.bindSymbol(cast(void**)&glRotatef, "glRotatef");
        lib.bindSymbol(cast(void**)&glScaled, "glScaled");
        lib.bindSymbol(cast(void**)&glScalef, "glScalef");
        lib.bindSymbol(cast(void**)&glTranslated, "glTranslated");
        lib.bindSymbol(cast(void**)&glTranslatef, "glTranslatef");
        lib.bindSymbol(cast(void**)&glVertexPointer, "glVertexPointer");
        lib.bindSymbol(cast(void**)&glNormalPointer, "glNormalPointer");
        lib.bindSymbol(cast(void**)&glColorPointer, "glColorPointer");
        lib.bindSymbol(cast(void**)&glIndexPointer, "glIndexPointer");
        lib.bindSymbol(cast(void**)&glTexCoordPointer, "glTexCoordPointer");
        lib.bindSymbol(cast(void**)&glEdgeFlagPointer, "glEdgeFlagPointer");
        lib.bindSymbol(cast(void**)&glArrayElement, "glArrayElement");
        lib.bindSymbol(cast(void**)&glInterleavedArrays, "glInterleavedArrays");
        lib.bindSymbol(cast(void**)&glEnableClientState, "glEnableClientState");
        lib.bindSymbol(cast(void**)&glDisableClientState, "glDisableClientState");
        lib.bindSymbol(cast(void**)&glPrioritizeTextures, "glPrioritizeTextures");
        lib.bindSymbol(cast(void**)&glAreTexturesResident, "glAreTexturesResident");
        lib.bindSymbol(cast(void**)&glPushClientAttrib, "glPushClientAttrib");
        lib.bindSymbol(cast(void**)&glPopClientAttrib, "glPopClientAttrib");

        return errorCount() == startErrorCount;
    }
}