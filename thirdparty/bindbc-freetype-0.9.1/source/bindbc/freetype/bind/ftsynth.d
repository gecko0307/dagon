
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftsynth;

import bindbc.freetype.bind.freetype;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        void FT_GlyphSlot_Embolden(FT_GlyphSlot);
        void FT_GlyphSlot_Oblique(FT_GlyphSlot);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_GlyphSlot_Embolden = void function(FT_GlyphSlot);
        alias pFT_GlyphSlot_Oblique = void function(FT_GlyphSlot);
    }

    __gshared {
        pFT_GlyphSlot_Embolden FT_GlyphSlot_Embolden;
        pFT_GlyphSlot_Oblique FT_GlyphSlot_Oblique;
    }
}