
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftpfr;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Get_PFR_Metrics(FT_Face,FT_UInt*,FT_UInt*,FT_Fixed*,FT_Fixed*);
        FT_Error FT_Get_PFR_Kerning(FT_Face,FT_UInt,FT_UInt,FT_Vector*);
        FT_Error FT_Get_PFR_Advance(FT_Face,FT_UInt,FT_Pos*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias da_FT_Get_PFR_Metrics = FT_Error function(FT_Face,FT_UInt*,FT_UInt*,FT_Fixed*,FT_Fixed*);
        alias da_FT_Get_PFR_Kerning = FT_Error function(FT_Face,FT_UInt,FT_UInt,FT_Vector*);
        alias da_FT_Get_PFR_Advance = FT_Error function(FT_Face,FT_UInt,FT_Pos*);
    }

    __gshared {
        da_FT_Get_PFR_Metrics FT_Get_PFR_Metrics;
        da_FT_Get_PFR_Kerning FT_Get_PFR_Kerning;
        da_FT_Get_PFR_Advance FT_Get_PFR_Advance;
    }
}