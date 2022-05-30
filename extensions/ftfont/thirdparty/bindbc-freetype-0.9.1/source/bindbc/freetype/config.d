
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.config;

enum FTSupport {
    noLibrary,
    badLibrary,
    ft26    = 26,
    ft27    = 27,
    ft28    = 28,
    ft29    = 29,
    ft210   = 210,
}

enum FREETYPE_MAJOR = 2;

version(Posix) enum enableBZIP2 = true;
else version(FT_BZIP2) enum enableBZIP2 = true;
else enum enableBZIP2 = false;

version(FT_27) {
    enum FREETYPE_MINOR = 7;
    enum FREETYPE_PATCH = 1;
    enum ftSupport = FTSupport.ft27;
}
else version(FT_28) {
    enum FREETYPE_MINOR = 8;
    enum FREETYPE_PATCH = 1;
    enum ftSupport = FTSupport.ft28;
}
else version(FT_29) {
    enum FREETYPE_MINOR = 9;
    enum FREETYPE_PATCH = 1;
    enum ftSupport = FTSupport.ft29;
}
else version(FT_210) {
    enum FREETYPE_MINOR = 10;
    enum FREETYPE_PATCH = 2;
    enum ftSupport = FTSupport.ft210;
}
else { // default
    enum FREETYPE_MINOR = 6;
    enum FREETYPE_PATCH = 4;
    enum ftSupport = FTSupport.ft26;
}

// config/ftconfg.h
alias FT_Int16 = short;
alias FT_UInt16 = ushort;
alias FT_Int32 = int;
alias FT_UInt32 = uint;
alias FT_Fast = int;
alias FT_UFast = uint;
alias FT_Int64 = long;
alias FT_Uint64 = ulong;