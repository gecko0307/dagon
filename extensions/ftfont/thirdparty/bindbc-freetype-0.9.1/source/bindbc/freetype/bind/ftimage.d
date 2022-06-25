
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftimage;

import core.stdc.config;
import bindbc.freetype.bind.fttypes;

alias FT_Pos = c_long;

struct FT_Vector {
    FT_Pos x;
    FT_Pos y;
}

struct FT_BBox {
    FT_Pos xMin, yMin;
    FT_Pos xMax, yMax;
}

alias FT_Pixel_Mode = int;
enum {
    FT_PIXEL_MODE_NONE = 0,
    FT_PIXEL_MODE_MONO,
    FT_PIXEL_MODE_GRAY,
    FT_PIXEL_MODE_GRAY2,
    FT_PIXEL_MODE_GRAY4,
    FT_PIXEL_MODE_LCD,
    FT_PIXEL_MODE_LCD_V,
    FT_PIXEL_MODE_MAX
}

struct FT_Bitmap {
    uint rows;
    uint width;
    int pitch;
    ubyte* buffer;
    ushort num_grays;
    ubyte pixel_mode;
    ubyte palette_mode;
    void* palette;
}

struct FT_Outline {
    short n_contours;
    short n_points;
    FT_Vector* points;
    byte* tags;
    short* contours;
    int flags;
}

enum FT_OUTLINE_CONTOURS_MAX = short.max;
enum FT_OUTLINE_POINTS_MAX = short.max;

enum : uint {
    FT_OUTLINE_NONE            = 0x0,
    FT_OUTLINE_OWNER           = 0x1,
    FT_OUTLINE_EVEN_ODD_FILL   = 0x2,
    FT_OUTLINE_REVERSE_FILL    = 0x4,
    FT_OUTLINE_IGNORE_DROPOUTS = 0x8,
    FT_OUTLINE_HIGH_PRECISION  = 0x100,
    FT_OUTLINE_SINGLE_PASS     = 0x200,
}

enum {
    FT_CURVE_TAG_ON          = 1,
    FT_CURVE_TAG_CONIC       = 0,
    FT_CURVE_TAG_CUBIC       = 2,
    FT_CURVE_TAG_TOUCH_X     = 8,
    FT_CURVE_TAG_TOUCH_Y     = 16,
    FT_CURVE_TAG_TOUCH_BOTH  = FT_CURVE_TAG_TOUCH_X | FT_CURVE_TAG_TOUCH_Y,
}

extern(C) nothrow {
    alias FT_Outline_MoveToFunc = int function(const(FT_Vector)*, void*);
    alias FT_Outline_LineToFunc = int function(const(FT_Vector)*, void*);
    alias FT_Outline_ConicToFunc = int function(const(FT_Vector)*, const(FT_Vector)*, void*);
    alias FT_Outline_CubicToFunc = int function(const(FT_Vector)*, const(FT_Vector)*, const(FT_Vector)*, void*);
}

struct FT_Outline_Funcs {
    FT_Outline_MoveToFunc move_to;
    FT_Outline_LineToFunc line_to;
    FT_Outline_ConicToFunc conic_to;
    FT_Outline_CubicToFunc cubic_to;
    int shift;
    FT_Pos delta;
}

alias FT_Glyph_Format = FT_Tag;
enum : FT_Tag {
    FT_GLYPH_FORMAT_NONE = 0,
    FT_GLYPH_FORMAT_COMPOSITE = FT_MAKE_TAG('c','o','m','p'),
    FT_GLYPH_FORMAT_BITMAP = FT_MAKE_TAG('b','i','t','s'),
    FT_GLYPH_FORMAT_OUTLINE = FT_MAKE_TAG('o','u','t','l'),
    FT_GLYPH_FORMAT_PLOTTER = FT_MAKE_TAG('p','l','o','t'),
}

struct FT_RasterRec;
alias FT_Raster = FT_RasterRec*;

struct FT_Span {
    short x;
    ushort len;
    ubyte coverage;
}

extern(C) nothrow alias FT_SpanFunc = void function(int, int, FT_Span*, void*);

enum {
    FT_RASTER_FLAG_DEFAULT  = 0x0,
    FT_RASTER_FLAG_AA       = 0x1,
    FT_RASTER_FLAG_DIRECT   = 0x2,
    FT_RASTER_FLAG_CLIP     = 0x4
}

struct FT_Raster_Params {
    const(FT_Bitmap)* target;
    const(void)* source;
    int flags;
    FT_SpanFunc gray_spans;
    void* black_spans;
    void* bit_test;
    void* bit_set;
    void* user;
    FT_BBox clip_box;
}

extern(C) nothrow {
    alias FT_Raster_NewFunc = int function(void*, FT_Raster*);
    alias FT_Raster_DoneFunc = void function(FT_Raster);
    alias FT_Raster_ResetFunc = void function(FT_Raster, ubyte*, uint);
    alias FT_Raster_SetModeFunc = int function(FT_Raster, uint, void*);
    alias FT_Raster_RenderFunc = int function(FT_Raster, FT_Raster_Params*);
}


struct FT_Raster_Funcs {
    FT_Glyph_Format glyph_format;
    FT_Raster_NewFunc raster_new;
    FT_Raster_ResetFunc raster_reset;
    FT_Raster_SetModeFunc raster_set_mode;
    FT_Raster_RenderFunc raster_render;
    FT_Raster_DoneFunc raster_done;
}