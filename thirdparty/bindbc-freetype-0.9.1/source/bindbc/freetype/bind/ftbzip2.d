
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftbzip2;

import bindbc.freetype.config;

static if(enableBZIP2) {
    import bindbc.freetype.bind.ftsystem,
        bindbc.freetype.bind.fttypes;

    version(BindFT_Static) {
        extern(C) @nogc nothrow {
            FT_Error FT_Stream_OpenBzip2(FT_Stream,FT_Stream);
        }
    }
    else {
        extern(C) @nogc nothrow {
            alias pFT_Stream_OpenBzip2 = FT_Error function(FT_Stream,FT_Stream);
        }

        __gshared {
            pFT_Stream_OpenBzip2 FT_Stream_OpenBzip2;
        }
    }
}