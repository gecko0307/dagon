
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftgxval;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.fttypes;

enum {
    FT_VALIDATE_feat_INDEX = 0,
    FT_VALIDATE_mort_INDEX = 1,
    FT_VALIDATE_morx_INDEX = 2,
    FT_VALIDATE_bsln_INDEX = 3,
    FT_VALIDATE_just_INDEX = 4,
    FT_VALIDATE_kern_INDEX = 5,
    FT_VALIDATE_opbd_INDEX = 6,
    FT_VALIDATE_trak_INDEX = 7,
    FT_VALIDATE_prop_INDEX = 8,
    FT_VALIDATE_lcar_INDEX = 9,
    FT_VALIDATE_GX_LAST_INDEX = FT_VALIDATE_lcar_INDEX,
    FT_VALIDATE_GX_LENGTH = FT_VALIDATE_GX_LAST_INDEX + 1,

    FT_VALIDATE_GX_START = 0x4000,
    FT_VALIDATE_feat = FT_VALIDATE_GX_START << FT_VALIDATE_feat_INDEX,
    FT_VALIDATE_mort = FT_VALIDATE_GX_START << FT_VALIDATE_mort_INDEX,
    FT_VALIDATE_morx = FT_VALIDATE_GX_START << FT_VALIDATE_morx_INDEX,
    FT_VALIDATE_bsln = FT_VALIDATE_GX_START << FT_VALIDATE_bsln_INDEX,
    FT_VALIDATE_just = FT_VALIDATE_GX_START << FT_VALIDATE_just_INDEX,
    FT_VALIDATE_kern = FT_VALIDATE_GX_START << FT_VALIDATE_kern_INDEX,
    FT_VALIDATE_opbd = FT_VALIDATE_GX_START << FT_VALIDATE_opbd_INDEX,
    FT_VALIDATE_trak = FT_VALIDATE_GX_START << FT_VALIDATE_trak_INDEX,
    FT_VALIDATE_prop = FT_VALIDATE_GX_START << FT_VALIDATE_prop_INDEX,
    FT_VALIDATE_lcar = FT_VALIDATE_GX_START << FT_VALIDATE_lcar_INDEX,

    FT_VALIDATE_GX = (FT_VALIDATE_feat |
                       FT_VALIDATE_mort |
                       FT_VALIDATE_morx |
                       FT_VALIDATE_bsln |
                       FT_VALIDATE_just |
                       FT_VALIDATE_kern |
                       FT_VALIDATE_opbd |
                       FT_VALIDATE_trak |
                       FT_VALIDATE_prop |
                       FT_VALIDATE_lcar),

    FT_VALIDATE_MS = FT_VALIDATE_GX_START << 0,
    FT_VALIDATE_APPLE = FT_VALIDATE_GX_START << 1,
    FT_VALIDATE_CKERN = FT_VALIDATE_MS | FT_VALIDATE_APPLE,
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_TrueTypeGX_Validate(FT_Face,FT_UInt,FT_Bytes,FT_UInt);
        void FT_TrueTypeGX_Free(FT_Face,FT_Bytes);
        FT_Error FT_ClassicKern_Validate(FT_Face,FT_UInt,FT_Bytes*);
        void FT_ClassicKern_Free(FT_Face,FT_Bytes);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_TrueTypeGX_Validate = FT_Error function(FT_Face,FT_UInt,FT_Bytes,FT_UInt);
        alias pFT_TrueTypeGX_Free = void function(FT_Face,FT_Bytes);
        alias pFT_ClassicKern_Validate = FT_Error function(FT_Face,FT_UInt,FT_Bytes*);
        alias pFT_ClassicKern_Free = void function(FT_Face,FT_Bytes);
    }

    __gshared {
        pFT_TrueTypeGX_Validate FT_TrueTypeGX_Validate;
        pFT_TrueTypeGX_Free FT_TrueTypeGX_Free;
        pFT_ClassicKern_Validate FT_ClassicKern_Validate;
        pFT_ClassicKern_Free FT_ClassicKern_Free;
    }
}