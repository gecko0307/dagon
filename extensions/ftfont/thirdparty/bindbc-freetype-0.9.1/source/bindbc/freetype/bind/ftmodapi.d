
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftmodapi;

import bindbc.freetype.config;
import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftsystem,
       bindbc.freetype.bind.fttypes;

enum {
    FT_MODULE_FONT_DRIVER       = 1,
    FT_MODULE_RENDERER          = 2,
    FT_MODULE_HINTER            = 4,
    FT_MODULE_STYLER            = 8,
    FT_MODULE_DRIVER_SCALABLE   = 0x100,
    FT_MODULE_DRIVER_NO_OUTLINES= 0x200,
    FT_MODULE_DRIVER_HAS_HINTER = 0x400,
    FT_MODULE_DRIVER_HINTS_LIGHTLY = 0x800,
}

alias FT_Module_Interface = FT_Pointer;

extern(C) nothrow {
    alias FT_Module_Constructor = FT_Error function(FT_Module);
    alias FT_Module_Destructor = void function(FT_Module);
    alias FT_Module_Requester = FT_Module_Interface function(FT_Module, const(char)*);
}

struct FT_Module_Class {
    FT_ULong module_flags;
    FT_Long module_size;
    FT_String* module_name;
    FT_Fixed module_version;
    FT_Fixed module_requires;
    void* module_interface;
    FT_Module_Constructor module_init;
    FT_Module_Destructor module_done;
    FT_Module_Requester get_interface;
}

static if((ftSupport == FTSupport.ft210 && FREETYPE_PATCH > 0) || ftSupport > FTSupport.ft210)
    extern(C) nothrow alias FT_DebugHook_Func = FT_Error function(void*);
else
    extern(C) nothrow alias FT_DebugHook_Func = void function(void*);

alias FT_TrueTypeEngineType = int;
enum {
    FT_TRUETYPE_ENGINE_TYPE_NONE = 0,
    FT_TRUETYPE_ENGINE_TYPE_UNPATENTED,
    FT_TRUETYPE_ENGINE_TYPE_PATENTED
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Error FT_Add_Module(FT_Library,const(FT_Module_Class)*);
        FT_Module FT_Get_Module(FT_Library,const(char)*);
        FT_Error FT_Remove_Module(FT_Library,FT_Module);
        FT_Error FT_Property_Set(FT_Library,const(FT_String)*,const(FT_String)*,const(void)*);
        FT_Error FT_Property_Get(FT_Library,const(FT_String)*,const(FT_String)*,void*);
        FT_Error FT_Reference_Library(FT_Library);
        FT_Error FT_New_Library(FT_Memory,FT_Library*);
        FT_Error FT_Done_Library(FT_Library);
        void FT_Set_Debug_Hook(FT_Library,FT_UInt,FT_DebugHook_Func);
        void FT_Add_Default_Modules(FT_Library);
        FT_TrueTypeEngineType FT_Get_TrueType_Engine_Type(FT_Library);

        static if(ftSupport >= FTSupport.ft28) {
            void FT_Set_Default_Properties(FT_Library);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pFT_Add_Module = FT_Error function(FT_Library,const(FT_Module_Class)*);
        alias pFT_Get_Module = FT_Module function(FT_Library,const(char)*);
        alias pFT_Remove_Module = FT_Error function(FT_Library,FT_Module);
        alias pFT_Property_Set = FT_Error function(FT_Library,const(FT_String)*,const(FT_String)*,const(void)*);
        alias pFT_Property_Get = FT_Error function(FT_Library,const(FT_String)*,const(FT_String)*,void*);
        alias pFT_Reference_Library = FT_Error function(FT_Library);
        alias pFT_New_Library = FT_Error function(FT_Memory,FT_Library*);
        alias pFT_Done_Library = FT_Error function(FT_Library);
        alias pFT_Set_Debug_Hook = void function(FT_Library,FT_UInt,FT_DebugHook_Func);
        alias pFT_Add_Default_Modules = void function(FT_Library);
        alias pFT_Get_TrueType_Engine_Type = FT_TrueTypeEngineType function(FT_Library);

        static if(ftSupport >= FTSupport.ft28) {
            alias pFT_Set_Default_Properties = void function(FT_Library);
        }
    }

    __gshared {
        pFT_Add_Module FT_Add_Module;
        pFT_Get_Module FT_Get_Module;
        pFT_Remove_Module FT_Remove_Module;
        pFT_Property_Set FT_Property_Set;
        pFT_Property_Get FT_Property_Get;
        pFT_Reference_Library FT_Reference_Library;
        pFT_New_Library FT_New_Library;
        pFT_Done_Library FT_Done_Library;
        pFT_Set_Debug_Hook FT_Set_Debug_Hook;
        pFT_Add_Default_Modules FT_Add_Default_Modules;
        pFT_Get_TrueType_Engine_Type FT_Get_TrueType_Engine_Type;

        static if(ftSupport >= FTSupport.ft28) {
            pFT_Set_Default_Properties FT_Set_Default_Properties;
        }
    }
}