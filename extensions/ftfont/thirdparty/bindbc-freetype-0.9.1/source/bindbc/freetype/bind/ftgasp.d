
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftgasp;

import bindbc.freetype.config;
import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

static if(ftSupport >= FTSupport.ft28) {
    enum {
        FT_GASP_NO_TABLE = -1,
        FT_GASP_DO_GRIDFIT = 0x01,
        FT_GASP_DO_GRAY = 0x02,
        FT_GASP_SYMMETRIC_GRIDFIT = 0x04,
        FT_GASP_SYMMETRIC_SMOOTHING = 0x08,
    }
}
else {
    enum {
        FT_GASP_NO_TABLE = -1,
        FT_GASP_DO_GRIDFIT = 0x01,
        FT_GASP_DO_GRAY = 0x02,
        FT_GASP_SYMMETRIC_SMOOTHING = 0x08,
        FT_GASP_SYMMETRIC_GRIDFIT = 0x10
    }
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Int FT_Get_Gasp(FT_Face,FT_UInt);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_Gasp = FT_Int function(FT_Face,FT_UInt);
    }

    __gshared {
        pFT_Get_Gasp FT_Get_Gasp;
    }
}