
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftmoderr;

enum {
    FT_Mod_Err_Base = 0x000,
    FT_Mod_Err_Autofit = 0x100,
    FT_Mod_Err_BDF = 0x200,
    FT_Mod_Err_Bzip2 = 0x300,
    FT_Mod_Err_Cache = 0x400,
    FT_Mod_Err_CFF = 0x500,
    FT_Mod_Err_CID = 0x600,
    FT_Mod_Err_Gzip = 0x700,
    FT_Mod_Err_LZW = 0x800,
    FT_Mod_Err_OTvalid = 0x900,
    FT_Mod_Err_PCF = 0xA00,
    FT_Mod_Err_PFR = 0xB00,
    FT_Mod_Err_PSaux = 0xC00,
    FT_Mod_Err_PShinter = 0xD00,
    FT_Mod_Err_PSnames = 0xE00,
    FT_Mod_Err_Raster = 0xF00,
    FT_Mod_Err_SFNT = 0x1000,
    FT_Mod_Err_Smooth = 0x1100,
    FT_Mod_Err_TrueType = 0x1200,
    FT_Mod_Err_Type1 = 0x1300,
    FT_Mod_Err_Type42 = 0x1400,
    FT_Mod_Err_Winfonts = 0x1500,
    FT_Mod_Err_GXvalid = 0x1600,
    FT_Mod_Err_Max,
}