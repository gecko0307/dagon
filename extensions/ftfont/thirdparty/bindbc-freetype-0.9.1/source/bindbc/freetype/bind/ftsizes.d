
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftsizes;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_New_Size(FT_Face,FT_Size*);
        FT_Error FT_Done_Size(FT_Size);
        FT_Error FT_Activate_Size(FT_Size);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_New_Size = FT_Error function(FT_Face,FT_Size*);
        alias pFT_Done_Size = FT_Error function(FT_Size);
        alias pFT_Activate_Size = FT_Error function(FT_Size);
    }

    __gshared {
        pFT_New_Size FT_New_Size;
        pFT_Done_Size FT_Done_Size;
        pFT_Activate_Size FT_Activate_Size;
    }
}