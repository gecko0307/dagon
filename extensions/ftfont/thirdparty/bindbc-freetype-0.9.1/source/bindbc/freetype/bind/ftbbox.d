
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftbbox;

import bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Outline_Get_BBox(FT_Outline*,FT_BBox);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Outline_Get_BBox = FT_Error function(FT_Outline*,FT_BBox);
    }

    __gshared {
        pFT_Outline_Get_BBox FT_Outline_Get_BBox;
    }
}