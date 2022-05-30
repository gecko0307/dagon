
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftcolor;

import bindbc.freetype.config;
import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

static if(ftSupport >= FTSupport.ft210) {
    import bindbc.freetype.bind.fttypes;

    struct FT_Color {
        FT_Byte blue;
        FT_Byte green;
        FT_Byte red;
        FT_Byte alpha;
    }

    struct FT_Palette_Data {
        FT_UShort num_palettes;
        const(FT_UShort)* palette_name_ids;
        const(FT_UShort)* palette_flags;
        FT_UShort num_palette_entries;
        const(FT_UShort)* palette_entry_name_ids;
    }

    version(BindFT_Static) {
        extern(C) @nogc nothrow {
            FT_Error FT_Palette_Data_Get(FT_Face,FT_Palette_Data*);
            FT_Error FT_Palette_Select(FT_Face,FT_UShort,FT_Color*);
            FT_Error FT_Palette_Set_Foreground_Color(FT_Face,FT_Color);
        }
    }
    else {
        extern(C) @nogc nothrow {
            alias pFT_Palette_Data_Get = FT_Error function(FT_Face,FT_Palette_Data*);
            alias pFT_Palette_Select = FT_Error function(FT_Face,FT_UShort,FT_Color*);
            alias pFT_Palette_Set_Foreground_Color = FT_Error function(FT_Face,FT_Color);
        }

        __gshared {
            pFT_Palette_Data_Get FT_Palette_Data_Get;
            pFT_Palette_Select FT_Palette_Select;
            pFT_Palette_Set_Foreground_Color FT_Palette_Set_Foreground_Color;
        }
    }
}