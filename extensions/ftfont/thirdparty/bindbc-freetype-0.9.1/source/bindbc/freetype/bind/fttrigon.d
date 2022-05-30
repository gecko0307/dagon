
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.fttrigon;

import bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

alias FT_Angle = FT_Fixed;

enum {
    FT_ANGLE_PI     = 180 << 16,
    FT_ANGLE_2PI    = FT_ANGLE_PI * 2,
    FT_ANGLE_PI2    = FT_ANGLE_PI / 2,
    FT_ANGLE_PI4    = FT_ANGLE_PI / 4
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Fixed FT_Sin(FT_Angle);
        FT_Fixed FT_Cos(FT_Angle);
        FT_Fixed FT_Tan(FT_Angle);
        FT_Angle FT_Atan2(FT_Fixed,FT_Fixed);
        FT_Angle FT_Angle_Diff(FT_Angle,FT_Angle);
        void FT_Vector_Unit(FT_Vector*,FT_Angle);
        void FT_Vector_Rotate(FT_Vector*,FT_Angle);
        FT_Fixed FT_Vector_Length(FT_Vector*);
        void FT_Vector_Polarize(FT_Vector*,FT_Fixed*,FT_Angle*);
        void FT_Vector_From_Polar(FT_Vector*,FT_Fixed,FT_Angle);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Sin = FT_Fixed function(FT_Angle);
        alias pFT_Cos = FT_Fixed function(FT_Angle);
        alias pFT_Tan = FT_Fixed function(FT_Angle);
        alias pFT_Atan2 = FT_Angle function(FT_Fixed,FT_Fixed);
        alias pFT_Angle_Diff = FT_Angle function(FT_Angle,FT_Angle);
        alias pFT_Vector_Unit = void function(FT_Vector*,FT_Angle);
        alias pFT_Vector_Rotate = void function(FT_Vector*,FT_Angle);
        alias pFT_Vector_Length = FT_Fixed function(FT_Vector*);
        alias pFT_Vector_Polarize = void function(FT_Vector*,FT_Fixed*,FT_Angle*);
        alias pFT_Vector_From_Polar = void function(FT_Vector*,FT_Fixed,FT_Angle);
    }

    __gshared {
        pFT_Sin FT_Sin;
        pFT_Cos FT_Cos;
        pFT_Tan FT_Tan;
        pFT_Atan2 FT_Atan2;
        pFT_Angle_Diff FT_Angle_Diff;
        pFT_Vector_Unit FT_Vector_Unit;
        pFT_Vector_Rotate FT_Vector_Rotate;
        pFT_Vector_Length FT_Vector_Length;
        pFT_Vector_Polarize FT_Vector_Polarize;
        pFT_Vector_From_Polar FT_Vector_From_Polar;
    }
}