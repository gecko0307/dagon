
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftlist;

import bindbc.freetype.bind.ftsystem,
       bindbc.freetype.bind.fttypes;

extern(C) nothrow {
    alias FT_List_Iterator = FT_Error function(FT_ListNode, void*);
    alias FT_List_Destructor = void function(FT_Memory, void*, void*);
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_ListNode FT_List_Find(FT_List,void*);
        void FT_List_Add(FT_List,FT_ListNode);
        void FT_List_Insert(FT_List,FT_ListNode);
        void FT_List_Remove(FT_List,FT_ListNode);
        void FT_List_Up(FT_List,FT_ListNode);
        FT_Error FT_List_Iterate(FT_List,FT_List_Iterator,void*);
        void FT_List_Finalize(FT_List,FT_List_Destructor,FT_Memory,void*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias da_FT_List_Find = FT_ListNode function(FT_List,void*);
        alias da_FT_List_Add = void function(FT_List,FT_ListNode);
        alias da_FT_List_Insert = void function(FT_List,FT_ListNode);
        alias da_FT_List_Remove = void function(FT_List,FT_ListNode);
        alias da_FT_List_Up = void function(FT_List,FT_ListNode);
        alias da_FT_List_Iterate = FT_Error function(FT_List,FT_List_Iterator,void*);
        alias da_FT_List_Finalize = void function(FT_List,FT_List_Destructor,FT_Memory,void*);
    }

    __gshared {
        da_FT_List_Find FT_List_Find;
        da_FT_List_Add FT_List_Add;
        da_FT_List_Insert FT_List_Insert;
        da_FT_List_Remove FT_List_Remove;
        da_FT_List_Up FT_List_Up;
        da_FT_List_Iterate FT_List_Iterate;
        da_FT_List_Finalize FT_List_Finalize;
    }
}