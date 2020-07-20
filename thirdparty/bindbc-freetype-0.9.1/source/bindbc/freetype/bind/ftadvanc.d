
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftadvanc;

enum FT_ADVANCE_FLAG_FAST_ONLY = 0x20000000;

import bindbc.freetype.config;
import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Get_Advance(FT_Face,FT_UInt,FT_Int32,FT_Fixed*);
        FT_Error FT_Get_Advances(FT_Face,FT_UInt,FT_UInt,FT_Int32,FT_Fixed*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_Advance = FT_Error function(FT_Face,FT_UInt,FT_Int32,FT_Fixed*);
        alias pFT_Get_Advances = FT_Error function(FT_Face,FT_UInt,FT_UInt,FT_Int32,FT_Fixed*);
    }

    __gshared {
        pFT_Get_Advance FT_Get_Advance;
        pFT_Get_Advances FT_Get_Advances;
    }
}