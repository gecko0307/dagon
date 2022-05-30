
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftbitmap;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.ftmodapi,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        void FT_Bitmap_Init(FT_Bitmap*);
        FT_Error FT_Bitmap_Copy(FT_Library,const(FT_Bitmap)*,FT_Bitmap*);
        FT_Error FT_Bitmap_Embolden(FT_Library,FT_Bitmap*,FT_Pos,FT_Pos);
        FT_Error FT_Bitmap_Convert(FT_Library,const(FT_Bitmap)*,FT_Bitmap*,FT_Int);
        FT_Error FT_GlyphSlot_Own_Bitmap(FT_GlyphSlot);
        FT_Error FT_Bitmap_Done(FT_Library,FT_Bitmap*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Bitmap_Init = void function(FT_Bitmap*);
        alias pFT_Bitmap_Copy = FT_Error function(FT_Library,const(FT_Bitmap)*,FT_Bitmap*);
        alias pFT_Bitmap_Embolden = FT_Error function(FT_Library,FT_Bitmap*,FT_Pos,FT_Pos);
        alias pFT_Bitmap_Convert = FT_Error function(FT_Library,const(FT_Bitmap)*,FT_Bitmap*,FT_Int);
        alias pFT_GlyphSlot_Own_Bitmap = FT_Error function(FT_GlyphSlot);
        alias pFT_Bitmap_Done = FT_Error function(FT_Library,FT_Bitmap*);
    }

    __gshared {
        pFT_Bitmap_Init FT_Bitmap_Init;
        pFT_Bitmap_Copy FT_Bitmap_Copy;
        pFT_Bitmap_Embolden FT_Bitmap_Embolden;
        pFT_Bitmap_Convert FT_Bitmap_Convert;
        pFT_GlyphSlot_Own_Bitmap FT_GlyphSlot_Own_Bitmap;
        pFT_Bitmap_Done FT_Bitmap_Done;
    }
}