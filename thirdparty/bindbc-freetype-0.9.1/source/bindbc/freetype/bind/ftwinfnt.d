
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftwinfnt;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

enum {
    FT_WinFNT_ID_CP1252 = 0,
    FT_WinFNT_ID_DEFAULT = 1,
    FT_WinFNT_ID_SYMBOL = 2,
    FT_WinFNT_ID_MAC = 77,
    FT_WinFNT_ID_CP932 = 128,
    FT_WinFNT_ID_CP949 = 129,
    FT_WinFNT_ID_CP1361 = 130,
    FT_WinFNT_ID_CP936 = 134,
    FT_WinFNT_ID_CP950 = 136,
    FT_WinFNT_ID_CP1253 = 161,
    FT_WinFNT_ID_CP1254 = 162,
    FT_WinFNT_ID_CP1258 = 163,
    FT_WinFNT_ID_CP1255 = 177,
    FT_WinFNT_ID_CP1256 = 178,
    FT_WinFNT_ID_CP1257 = 186,
    FT_WinFNT_ID_CP1251 = 204,
    FT_WinFNT_ID_CP874 = 222,
    FT_WinFNT_ID_CP1250 = 238,
    FT_WinFNT_ID_OEM = 255,
}


struct FT_WinFNT_HeaderRec {
    FT_UShort _version;
    FT_ULong file_size;
    FT_Byte[60] copyright;
    FT_UShort file_type;
    FT_UShort nominal_point_size;
    FT_UShort vertical_resolution;
    FT_UShort horizontal_resolution;
    FT_UShort ascent;
    FT_UShort internal_leading;
    FT_UShort external_leading;
    FT_Byte italic;
    FT_Byte underline;
    FT_Byte strike_out;
    FT_UShort weight;
    FT_Byte charset;
    FT_UShort pixel_width;
    FT_UShort pixel_height;
    FT_Byte pitch_and_family;
    FT_UShort avg_width;
    FT_UShort max_width;
    FT_Byte first_char;
    FT_Byte last_char;
    FT_Byte default_char;
    FT_Byte break_char;
    FT_UShort bytes_per_row;
    FT_ULong device_offset;
    FT_ULong face_name_offset;
    FT_ULong bits_pointer;
    FT_ULong bits_offset;
    FT_Byte reserved;
    FT_ULong flags;
    FT_UShort A_space;
    FT_UShort B_space;
    FT_UShort C_space;
    FT_UShort color_table_offset;
    FT_ULong[4] reserved1;
}

alias FT_WinFNT_Header = FT_WinFNT_HeaderRec*;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Get_WinFNT_Header(FT_Face,FT_WinFNT_HeaderRec*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_WinFNT_Header = FT_Error function(FT_Face,FT_WinFNT_HeaderRec*);
    }

    __gshared {
         pFT_Get_WinFNT_Header FT_Get_WinFNT_Header;
    }
}