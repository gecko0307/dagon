
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftgzip;

import bindbc.freetype.bind.ftsystem,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Stream_OpenGzip(FT_Stream,FT_Stream);
        FT_Error FT_Gzip_Uncompress(FT_Memory,FT_Byte*,FT_ULong*,const(FT_Byte)*,FT_ULong);
    }
}
else {
    extern(C) @nogc nothrow {
        alias da_FT_Stream_OpenGzip = FT_Error function(FT_Stream,FT_Stream);
        alias da_FT_Gzip_Uncompress = FT_Error function(FT_Memory,FT_Byte*,FT_ULong*,const(FT_Byte)*,FT_ULong);
    }

    __gshared {
        da_FT_Stream_OpenGzip FT_Stream_OpenGzip;
        da_FT_Gzip_Uncompress FT_Gzip_Uncompress;
    }
}