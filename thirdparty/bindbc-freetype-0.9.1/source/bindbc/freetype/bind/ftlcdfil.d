
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftlcdfil;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

alias FT_LcdFilter = int;
enum {
    FT_LCD_FILTER_NONE    = 0,
    FT_LCD_FILTER_DEFAULT = 1,
    FT_LCD_FILTER_LIGHT   = 2,
    FT_LCD_FILTER_LEGACY1 = 3,
    FT_LCD_FILTER_LEGACY  = 16,
    FT_LCD_FILTER_MAX
}

// Added in Freetype 2.8
enum FT_LCD_FILTER_FIVE_TAPS = 5;
alias FT_LcdFiveTapFilter = FT_Byte[FT_LCD_FILTER_FIVE_TAPS];

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Library_SetLcdFilter(FT_Library,FT_LcdFilter);
        FT_Error FT_Library_SetLcdFilterWeights(FT_Library,ubyte*);
        FT_Error FT_Library_SetLcdGeometry(FT_Library, ref FT_Vector[3]);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Library_SetLcdFilter = FT_Error function(FT_Library,FT_LcdFilter);
        alias pFT_Library_SetLcdFilterWeights = FT_Error function(FT_Library,ubyte*);
        alias pFT_Library_SetLcdGeometry = FT_Error function(FT_Library, ref FT_Vector[3]);
    }

    __gshared {
        pFT_Library_SetLcdFilter FT_Library_SetLcdFilter;
        pFT_Library_SetLcdFilterWeights FT_Library_SetLcdFilterWeights;
        pFT_Library_SetLcdGeometry FT_Library_SetLcdGeometry;
    }
}