
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.fttypes;

import core.stdc.config;
import bindbc.freetype.config;

alias FT_Bool = ubyte;
alias FT_FWord = short;
alias FT_UFWord = ushort;
alias FT_Char = char;
alias FT_Byte = ubyte;
alias FT_Bytes = FT_Byte*;
alias FT_Tag = FT_UInt32;
alias FT_String = char;
alias FT_Short = short;
alias FT_UShort = ushort;
alias FT_Int = int;
alias FT_UInt = uint;
alias FT_Long = c_long;
alias FT_ULong = c_ulong;
alias FT_F2Dot14 = short;
alias FT_F26Dot6 = c_long;
alias FT_Fixed = c_long;
alias FT_Error = int;
alias FT_Pointer = void*;
alias FT_Offset = size_t;
alias FT_PtrDist = ptrdiff_t;

struct FT_UnitVector {
    FT_F2Dot14 x;
    FT_F2Dot14 y;
}

struct FT_Matrix {
    FT_Fixed xx, xy;
    FT_Fixed yx, yy;
}

struct FT_Data {
    const(FT_Byte)* pointer;
    FT_Int length;
}

extern(C) nothrow alias FT_Generic_Finalizer = void function(void*);

struct FT_Generic {
    void* data;
    FT_Generic_Finalizer finalizer;
}

FT_Tag FT_MAKE_TAG(char x1, char x2, char x3, char x4) {
    return cast(FT_UInt32)((x1 << 24) | (x2 << 16) | (x3 << 8) | x4);
}

alias FT_ListNode = FT_ListNodeRec*;
alias FT_List = FT_ListRec*;

struct FT_ListNodeRec {
    FT_ListNode prev;
    FT_ListNode next;
    void* data;
}

struct FT_ListRec {
    FT_ListNode head;
    FT_ListNode tail;
}