
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftoutln;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

alias FT_Orientation = int;
enum {
    FT_ORIENTATION_TRUETYPE = 0,
    FT_ORIENTATION_POSTSCRIPT = 1,
    FT_ORIENTATION_FILL_RIGHT = FT_ORIENTATION_TRUETYPE,
    FT_ORIENTATION_FILL_LEFT = FT_ORIENTATION_POSTSCRIPT
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Outline_Decompose(FT_Outline*,const(FT_Outline_Funcs)*,void*);
        FT_Error FT_Outline_New(FT_Library,FT_UInt,FT_Int,FT_Outline*);
        FT_Error FT_Outline_Done(FT_Library,FT_Outline*);
        FT_Error FT_Outline_Check(FT_Outline*);
        void FT_Outline_Get_CBox(const(FT_Outline)*,FT_BBox*);
        void FT_Outline_Translate(const(FT_Outline)*,FT_Pos,FT_Pos);
        FT_Error FT_Outline_Copy(const(FT_Outline)*,FT_Outline*);
        void FT_Outline_Transform(const(FT_Outline)*,const(FT_Matrix)*);
        FT_Error FT_Outline_Embolden(FT_Outline*,FT_Pos);
        FT_Error FT_Outline_EmboldenXY(FT_Outline*,FT_Pos,FT_Pos);
        void FT_Outline_Reverse(FT_Outline*);
        FT_Error FT_Outline_Get_Bitmap(FT_Library,FT_Outline*,const(FT_Bitmap)*);
        FT_Error FT_Outline_Render(FT_Library,FT_Outline*,FT_Raster_Params*);
        FT_Orientation FT_Outline_Get_Orientation(FT_Outline*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Outline_Decompose = FT_Error function(FT_Outline*,const(FT_Outline_Funcs)*,void*);
        alias pFT_Outline_New = FT_Error function(FT_Library,FT_UInt,FT_Int,FT_Outline*);
        alias pFT_Outline_Done = FT_Error function(FT_Library,FT_Outline*);
        alias pFT_Outline_Check = FT_Error function(FT_Outline*);
        alias pFT_Outline_Get_CBox = void function(const(FT_Outline)*,FT_BBox*);
        alias pFT_Outline_Translate = void function(const(FT_Outline)*,FT_Pos,FT_Pos);
        alias pFT_Outline_Copy = FT_Error function(const(FT_Outline)*,FT_Outline*);
        alias pFT_Outline_Transform = void function(const(FT_Outline)*,const(FT_Matrix)*);
        alias pFT_Outline_Embolden = FT_Error function(FT_Outline*,FT_Pos);
        alias pFT_Outline_EmboldenXY = FT_Error function(FT_Outline*,FT_Pos,FT_Pos);
        alias pFT_Outline_Reverse = void function(FT_Outline*);
        alias pFT_Outline_Get_Bitmap = FT_Error function(FT_Library,FT_Outline*,const(FT_Bitmap)*);
        alias pFT_Outline_Render = FT_Error function(FT_Library,FT_Outline*,FT_Raster_Params*);
        alias pFT_Outline_Get_Orientation = FT_Orientation function(FT_Outline*);
    }

    __gshared {
        pFT_Outline_Decompose FT_Outline_Decompose;
        pFT_Outline_New FT_Outline_New;
        pFT_Outline_Done FT_Outline_Done;
        pFT_Outline_Check FT_Outline_Check;
        pFT_Outline_Get_CBox FT_Outline_Get_CBox;
        pFT_Outline_Translate FT_Outline_Translate;
        pFT_Outline_Copy FT_Outline_Copy;
        pFT_Outline_Transform FT_Outline_Transform;
        pFT_Outline_Embolden FT_Outline_Embolden;
        pFT_Outline_EmboldenXY FT_Outline_EmboldenXY;
        pFT_Outline_Reverse FT_Outline_Reverse;
        pFT_Outline_Get_Bitmap FT_Outline_Get_Bitmap;
        pFT_Outline_Render FT_Outline_Render;
        pFT_Outline_Get_Orientation FT_Outline_Get_Orientation;
    }
}