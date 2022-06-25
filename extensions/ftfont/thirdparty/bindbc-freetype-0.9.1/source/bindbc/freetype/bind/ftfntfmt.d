
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftfntfmt;

import bindbc.freetype.bind.freetype;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        const(char)* FT_Get_Font_Format(FT_Face);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_Font_Format = const(char)* function(FT_Face);
    }

    __gshared {
        pFT_Get_Font_Format FT_Get_Font_Format;
    }
}