
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftcid;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

version(BindFT_Static) {
	extern(C) @nogc nothrow {
		FT_Error FT_Get_CID_Registry_Ordering_Supplement(FT_Face,const(char*)*,const(char*)*,FT_Int*);
		FT_Error FT_Get_CID_Is_Internally_CID_Keyed(FT_Face,FT_Bool*);
		FT_Error FT_Get_CID_From_Glyph_Index(FT_Face,FT_UInt,FT_UInt*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Get_CID_Registry_Ordering_Supplement = FT_Error function(FT_Face,const(char*)*,const(char*)*,FT_Int*);
        alias pFT_Get_CID_Is_Internally_CID_Keyed = FT_Error function(FT_Face,FT_Bool*);
        alias pFT_Get_CID_From_Glyph_Index = FT_Error function(FT_Face,FT_UInt,FT_UInt*);
    }

    __gshared {
        pFT_Get_CID_Registry_Ordering_Supplement FT_Get_CID_Registry_Ordering_Supplement;
        pFT_Get_CID_Is_Internally_CID_Keyed FT_Get_CID_Is_Internally_CID_Keyed;
        pFT_Get_CID_From_Glyph_Index FT_Get_CID_From_Glyph_Index;
    }
}