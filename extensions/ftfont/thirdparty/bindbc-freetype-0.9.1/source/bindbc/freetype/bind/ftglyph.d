
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftglyph;

alias FT_Glyph = FT_GlyphRec*;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.ftrender,
       bindbc.freetype.bind.fttypes;

struct FT_GlyphRec {
    FT_Library library;
    FT_Glyph_Class* clazz;
    FT_Glyph_Format format;
    FT_Vector advance;
}

alias FT_BitmapGlyph = FT_BitmapGlyphRec*;

struct FT_BitmapGlyphRec {
    FT_GlyphRec root;
    FT_Int left;
    FT_Int top;
    FT_Bitmap bitmap;
}

alias FT_OutlineGlyph = FT_OutlineGlyphRec*;

struct FT_OutlineGlyphRec {
    FT_GlyphRec root;
    FT_Outline outline;
}

alias FT_Glyph_BBox_Mode = int;
enum {
    FT_GLYPH_BBOX_UNSCALED = 0,
    FT_GLYPH_BBOX_SUBPIXELS = 0,
    FT_GLYPH_BBOX_GRIDFIT = 1,
    FT_GLYPH_BBOX_TRUNCATE = 2,
    FT_GLYPH_BBOX_PIXELS = 3
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Get_Glyph(FT_GlyphSlot,FT_Glyph*);
        FT_Error FT_Glyph_Copy(FT_Glyph,FT_Glyph*);
        FT_Error FT_Glyph_Transform(FT_Glyph,FT_Matrix*,FT_Vector*);
        void FT_Glyph_Get_CBox(FT_Glyph,FT_UInt,FT_BBox*);
        FT_Error FT_Glyph_To_Bitmap(FT_Glyph*,FT_Render_Mode,FT_Vector*,FT_Bool);
        void FT_Done_Glyph(FT_Glyph);
        void FT_Matrix_Multiply(const(FT_Matrix)*,FT_Matrix*);
        FT_Error FT_Matrix_Invert(FT_Matrix*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_Glyph = FT_Error function(FT_GlyphSlot,FT_Glyph*);
        alias pFT_Glyph_Copy = FT_Error function(FT_Glyph,FT_Glyph*);
        alias pFT_Glyph_Transform = FT_Error function(FT_Glyph,FT_Matrix*,FT_Vector*);
        alias pFT_Glyph_Get_CBox = void function(FT_Glyph,FT_UInt,FT_BBox*);
        alias pFT_Glyph_To_Bitmap = FT_Error function(FT_Glyph*,FT_Render_Mode,FT_Vector*,FT_Bool);
        alias pFT_Done_Glyph = void function(FT_Glyph);
        alias pFT_Matrix_Multiply = void function(const(FT_Matrix)*,FT_Matrix*);
        alias pFT_Matrix_Invert = FT_Error function(FT_Matrix*);
    }

    __gshared {
        pFT_Get_Glyph FT_Get_Glyph;
        pFT_Glyph_Copy FT_Glyph_Copy;
        pFT_Glyph_Transform FT_Glyph_Transform;
        pFT_Glyph_Get_CBox FT_Glyph_Get_CBox;
        pFT_Glyph_To_Bitmap FT_Glyph_To_Bitmap;
        pFT_Done_Glyph FT_Done_Glyph;
        pFT_Matrix_Multiply FT_Matrix_Multiply;
        pFT_Matrix_Invert FT_Matrix_Invert;
    }
}