
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftsystem;

import core.stdc.config;

alias FT_Memory = FT_MemoryRec*;

extern(C) nothrow {
    alias FT_Alloc_Func = void* function(FT_Memory, c_long);
    alias FT_Free_Func = void  function(FT_Memory, void*);
    alias FT_Realloc_Func = void* function(FT_Memory, c_long, c_long, void*);
}

struct FT_MemoryRec {
    void* user;
    FT_Alloc_Func alloc;
    FT_Free_Func free;
    FT_Realloc_Func realloc;
}

alias FT_Stream = FT_StreamRec*;

union FT_StreamDesc {
    int value;
    void* pointer;
}

extern(C) nothrow {
    alias FT_Stream_IoFunc = c_ulong function(FT_Stream, c_ulong, ubyte*, c_ulong);
    alias FT_Stream_CloseFunc = void function(FT_Stream);
}

struct FT_StreamRec {
    ubyte* base;
    c_ulong size;
    c_ulong pos;
    FT_StreamDesc descriptor;
    FT_StreamDesc pathname;
    FT_Stream_IoFunc read;
    FT_Stream_CloseFunc close;
    FT_Memory memory;
    ubyte* cursor;
    ubyte* limit;
}