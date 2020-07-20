
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftotval;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;


enum {
    FT_VALIDATE_BASE = 0x0100,
    FT_VALIDATE_GDEF = 0x0200,
    FT_VALIDATE_GPOS = 0x0400,
    FT_VALIDATE_GSUB = 0x0800,
    FT_VALIDATE_JSTF = 0x1000,
    FT_VALIDATE_MATH = 0x2000,
    FT_VALIDATE_OT   = FT_VALIDATE_BASE |
                       FT_VALIDATE_GDEF |
                       FT_VALIDATE_GPOS |
                       FT_VALIDATE_GSUB |
                       FT_VALIDATE_JSTF |
                       FT_VALIDATE_MATH,
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error da_FT_OpenType_Validate(FT_Face,FT_UInt,FT_Bytes*,FT_Bytes*,FT_Bytes*,FT_Bytes*,FT_Bytes*);
        void da_FT_OpenType_Free(FT_Face,FT_Bytes);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_OpenType_Validate = FT_Error function(FT_Face,FT_UInt,FT_Bytes*,FT_Bytes*,FT_Bytes*,FT_Bytes*,FT_Bytes*);
        alias pFT_OpenType_Free = void function (FT_Face,FT_Bytes);
    }

    __gshared {
        pFT_OpenType_Validate FT_OpenType_Validate;
        pFT_OpenType_Free FT_OpenType_Free;
    }
}