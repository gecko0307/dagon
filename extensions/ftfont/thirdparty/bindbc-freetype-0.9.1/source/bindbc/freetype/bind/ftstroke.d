
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftstroke;

import bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.ftglyph,
       bindbc.freetype.bind.ftsystem,
       bindbc.freetype.bind.fttypes;

struct FT_StrokerRec;
alias FT_Stroker = FT_StrokerRec*;

alias FT_Stroker_LineJoin = int;
enum {
    FT_STROKER_LINEJOIN_ROUND = 0,
    FT_STROKER_LINEJOIN_BEVEL,
    FT_STROKER_LINEJOIN_MITER
}

alias FT_Stroker_LineCap = int;
enum {
    FT_STROKER_LINECAP_BUTT = 0,
    FT_STROKER_LINECAP_ROUND,
    FT_STROKER_LINECAP_SQUARE
}

alias FT_StrokerBorder = int;
enum {
    FT_STROKER_BORDER_LEFT = 0,
    FT_STROKER_BORDER_RIGHT
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_StrokerBorder FT_Outline_GetInsideBorder(FT_Outline*);
        FT_StrokerBorder FT_Outline_GetOutsideBorder(FT_Outline*);
        FT_Error FT_Stroker_New(FT_Memory,FT_Stroker*);
        void FT_Stroker_Set(FT_Stroker,FT_Fixed,FT_Stroker_LineCap,FT_Stroker_LineJoin,FT_Fixed);
        void FT_Stroker_Rewind(FT_Stroker);
        FT_Error FT_Stroker_ParseOutline(FT_Stroker,FT_Outline*,FT_Bool);
        FT_Error FT_Stroker_BeginSubPath(FT_Stroker,FT_Vector*,FT_Bool);
        FT_Error FT_Stroker_EndSubPath(FT_Stroker);
        FT_Error FT_Stroker_LineTo(FT_Stroker,FT_Vector*);
        FT_Error FT_Stroker_ConicTo(FT_Stroker,FT_Vector*,FT_Vector*);
        FT_Error FT_Stroker_CubicTo(FT_Stroker,FT_Vector*,FT_Vector*,FT_Vector*);
        FT_Error FT_Stroker_GetBorderCounts(FT_Stroker,FT_StrokerBorder,FT_UInt*,FT_UInt*);
        void FT_Stroker_ExportBorder(FT_Stroker,FT_StrokerBorder,FT_Outline*);
        FT_Error FT_Stroker_GetCounts(FT_Stroker,FT_UInt*,FT_UInt*);
        void FT_Stroker_Export(FT_Stroker,FT_Outline*);
        void FT_Stroker_Done(FT_Stroker);
        FT_Error FT_Glyph_Stroke(FT_Glyph*,FT_Stroker,FT_Bool);
        FT_Error FT_Glyph_StrokeBorder(FT_Glyph*,FT_Stroker,FT_Bool,FT_Bool);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Outline_GetInsideBorder = FT_StrokerBorder function(FT_Outline*);
        alias pFT_Outline_GetOutsideBorder = FT_StrokerBorder function(FT_Outline*);
        alias pFT_Stroker_New = FT_Error function(FT_Memory,FT_Stroker*);
        alias pFT_Stroker_Set = void function(FT_Stroker,FT_Fixed,FT_Stroker_LineCap,FT_Stroker_LineJoin,FT_Fixed);
        alias pFT_Stroker_Rewind = void function(FT_Stroker);
        alias pFT_Stroker_ParseOutline = FT_Error function(FT_Stroker,FT_Outline*,FT_Bool);
        alias pFT_Stroker_BeginSubPath = FT_Error function(FT_Stroker,FT_Vector*,FT_Bool);
        alias pFT_Stroker_EndSubPath = FT_Error function(FT_Stroker);
        alias pFT_Stroker_LineTo = FT_Error function(FT_Stroker,FT_Vector*);
        alias pFT_Stroker_ConicTo = FT_Error function(FT_Stroker,FT_Vector*,FT_Vector*);
        alias pFT_Stroker_CubicTo = FT_Error function(FT_Stroker,FT_Vector*,FT_Vector*,FT_Vector*);
        alias pFT_Stroker_GetBorderCounts = FT_Error function(FT_Stroker,FT_StrokerBorder,FT_UInt*,FT_UInt*);
        alias pFT_Stroker_ExportBorder = void function(FT_Stroker,FT_StrokerBorder,FT_Outline*);
        alias pFT_Stroker_GetCounts = FT_Error function(FT_Stroker,FT_UInt*,FT_UInt*);
        alias pFT_Stroker_Export = void function(FT_Stroker,FT_Outline*);
        alias pFT_Stroker_Done = void function(FT_Stroker);
        alias pFT_Glyph_Stroke = FT_Error function(FT_Glyph*,FT_Stroker,FT_Bool);
        alias pFT_Glyph_StrokeBorder = FT_Error function(FT_Glyph*,FT_Stroker,FT_Bool,FT_Bool);
    }

    __gshared {
        pFT_Outline_GetInsideBorder FT_Outline_GetInsideBorder;
        pFT_Outline_GetOutsideBorder FT_Outline_GetOutsideBorder;
        pFT_Stroker_New FT_Stroker_New;
        pFT_Stroker_Set FT_Stroker_Set;
        pFT_Stroker_Rewind FT_Stroker_Rewind;
        pFT_Stroker_ParseOutline FT_Stroker_ParseOutline;
        pFT_Stroker_BeginSubPath FT_Stroker_BeginSubPath;
        pFT_Stroker_EndSubPath FT_Stroker_EndSubPath;
        pFT_Stroker_LineTo FT_Stroker_LineTo;
        pFT_Stroker_ConicTo FT_Stroker_ConicTo;
        pFT_Stroker_CubicTo FT_Stroker_CubicTo;
        pFT_Stroker_GetBorderCounts FT_Stroker_GetBorderCounts;
        pFT_Stroker_ExportBorder FT_Stroker_ExportBorder;
        pFT_Stroker_GetCounts FT_Stroker_GetCounts;
        pFT_Stroker_Export FT_Stroker_Export;
        pFT_Stroker_Done FT_Stroker_Done;
        pFT_Glyph_Stroke FT_Glyph_Stroke;
        pFT_Glyph_StrokeBorder FT_Glyph_StrokeBorder;
    }
}