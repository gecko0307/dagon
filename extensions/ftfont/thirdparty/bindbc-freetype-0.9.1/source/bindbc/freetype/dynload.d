
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.dynload;

version(BindFT_Static) {}
else:

import bindbc.loader;
import bindbc.freetype.config,
       bindbc.freetype.bind;

private {
    SharedLib lib;
    FTSupport loadedVersion;
}

void unloadFreeType()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

FTSupport loadedFreeTypeVersion() { return loadedVersion; }

bool isFreeTypeLoaded()
{
    return  lib != invalidHandle;
}

FTSupport loadFreeType()
{
    // #1778 prevents me from using static arrays here :(
    version(Windows) {
        const(char)[][3] libNames = [
            "freetype.dll",
            "libfreetype.dll",
            "libfreetype-6.dll"
        ];
    }
    else version(OSX) {
        const(char)[][6] libNames = [
            "libfreetype.dylib",
            "libfreetype.6.dylib",
            "/usr/X11/lib/libfreetype.dylib",
            "/usr/X11/lib/libfreetype.6.dylib",
            "/opt/X11/lib/libfreetype.dylib",
            "/opt/X11/lib/libfreetype.6.dylib"
        ];
    }
    else version(Posix) {
        const(char)[][2] libNames = [
            "libfreetype.so.6",
            "libfreetype.so"
        ];
    }
    else static assert(0, "bindbc-freetype is not yet supported on this platform.");

    FTSupport ret;
    foreach(name; libNames) {
        ret = loadFreeType(name.ptr);
        if(ret != FTSupport.noLibrary) break;
    }
    return ret;
}

FTSupport loadFreeType(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle) {
        return FTSupport.noLibrary;
    }

    auto errCount = errorCount();
    loadedVersion = FTSupport.badLibrary;

    lib.bindSymbol(cast(void**)&FT_Init_FreeType, "FT_Init_FreeType");
    lib.bindSymbol(cast(void**)&FT_Done_FreeType, "FT_Done_FreeType");
    lib.bindSymbol(cast(void**)&FT_New_Face, "FT_New_Face");
    lib.bindSymbol(cast(void**)&FT_New_Memory_Face, "FT_New_Memory_Face");
    lib.bindSymbol(cast(void**)&FT_Open_Face, "FT_Open_Face");
    lib.bindSymbol(cast(void**)&FT_Attach_File, "FT_Attach_File");
    lib.bindSymbol(cast(void**)&FT_Attach_Stream, "FT_Attach_Stream");
    lib.bindSymbol(cast(void**)&FT_Reference_Face, "FT_Reference_Face");
    lib.bindSymbol(cast(void**)&FT_Done_Face, "FT_Done_Face");
    lib.bindSymbol(cast(void**)&FT_Select_Size, "FT_Select_Size");
    lib.bindSymbol(cast(void**)&FT_Request_Size, "FT_Request_Size");
    lib.bindSymbol(cast(void**)&FT_Set_Char_Size, "FT_Set_Char_Size");
    lib.bindSymbol(cast(void**)&FT_Set_Pixel_Sizes, "FT_Set_Pixel_Sizes");
    lib.bindSymbol(cast(void**)&FT_Load_Glyph, "FT_Load_Glyph");
    lib.bindSymbol(cast(void**)&FT_Load_Char, "FT_Load_Char");
    lib.bindSymbol(cast(void**)&FT_Set_Transform, "FT_Set_Transform");
    lib.bindSymbol(cast(void**)&FT_Render_Glyph, "FT_Render_Glyph");
    lib.bindSymbol(cast(void**)&FT_Get_Kerning, "FT_Get_Kerning");
    lib.bindSymbol(cast(void**)&FT_Get_Track_Kerning, "FT_Get_Track_Kerning");
    lib.bindSymbol(cast(void**)&FT_Get_Glyph_Name, "FT_Get_Glyph_Name");
    lib.bindSymbol(cast(void**)&FT_Get_Postscript_Name, "FT_Get_Postscript_Name");
    lib.bindSymbol(cast(void**)&FT_Select_Charmap, "FT_Select_Charmap");
    lib.bindSymbol(cast(void**)&FT_Set_Charmap, "FT_Set_Charmap");
    lib.bindSymbol(cast(void**)&FT_Get_Charmap_Index, "FT_Get_Charmap_Index");
    lib.bindSymbol(cast(void**)&FT_Get_Char_Index, "FT_Get_Char_Index");
    lib.bindSymbol(cast(void**)&FT_Get_First_Char, "FT_Get_First_Char");
    lib.bindSymbol(cast(void**)&FT_Get_Next_Char, "FT_Get_Next_Char");
    lib.bindSymbol(cast(void**)&FT_Get_Name_Index, "FT_Get_Name_Index");
    lib.bindSymbol(cast(void**)&FT_Get_SubGlyph_Info, "FT_Get_SubGlyph_Info");
    lib.bindSymbol(cast(void**)&FT_Get_FSType_Flags, "FT_Get_FSType_Flags");
    lib.bindSymbol(cast(void**)&FT_Face_GetCharVariantIndex, "FT_Face_GetCharVariantIndex");
    lib.bindSymbol(cast(void**)&FT_Face_GetCharVariantIsDefault, "FT_Face_GetCharVariantIsDefault");
    lib.bindSymbol(cast(void**)&FT_Face_GetVariantSelectors, "FT_Face_GetVariantSelectors");
    lib.bindSymbol(cast(void**)&FT_Face_GetVariantsOfChar, "FT_Face_GetVariantsOfChar");
    lib.bindSymbol(cast(void**)&FT_Face_GetCharsOfVariant, "FT_Face_GetCharsOfVariant");
    lib.bindSymbol(cast(void**)&FT_MulDiv, "FT_MulDiv");
    lib.bindSymbol(cast(void**)&FT_MulFix, "FT_MulFix");
    lib.bindSymbol(cast(void**)&FT_DivFix, "FT_DivFix");
    lib.bindSymbol(cast(void**)&FT_RoundFix, "FT_RoundFix");
    lib.bindSymbol(cast(void**)&FT_CeilFix, "FT_CeilFix");
    lib.bindSymbol(cast(void**)&FT_FloorFix, "FT_FloorFix");
    lib.bindSymbol(cast(void**)&FT_Vector_Transform, "FT_Vector_Transform");
    lib.bindSymbol(cast(void**)&FT_Library_Version, "FT_Library_Version");
    lib.bindSymbol(cast(void**)&FT_Face_CheckTrueTypePatents, "FT_Face_CheckTrueTypePatents");
    lib.bindSymbol(cast(void**)&FT_Face_SetUnpatentedHinting, "FT_Face_SetUnpatentedHinting");

    lib.bindSymbol(cast(void**)&FT_Get_Advance, "FT_Get_Advance");
    lib.bindSymbol(cast(void**)&FT_Get_Advances, "FT_Get_Advances");

    lib.bindSymbol(cast(void**)&FT_Outline_Get_BBox, "FT_Outline_Get_BBox");

    version(linux) {
        lib.bindSymbol(cast(void**)&FT_Get_BDF_Charset_ID, "FT_Get_BDF_Charset_ID");
        lib.bindSymbol(cast(void**)&FT_Get_BDF_Property, "FT_Get_BDF_Property");
    }

    lib.bindSymbol(cast(void**)&FT_Bitmap_Init, "FT_Bitmap_Init");
    lib.bindSymbol(cast(void**)&FT_Bitmap_Copy, "FT_Bitmap_Copy");
    lib.bindSymbol(cast(void**)&FT_Bitmap_Embolden, "FT_Bitmap_Embolden");
    lib.bindSymbol(cast(void**)&FT_Bitmap_Convert, "FT_Bitmap_Convert");
    lib.bindSymbol(cast(void**)&FT_Bitmap_Done, "FT_Bitmap_Done");
    lib.bindSymbol(cast(void**)&FT_GlyphSlot_Own_Bitmap, "FT_GlyphSlot_Own_Bitmap");

    static if(enableBZIP2) {
        lib.bindSymbol(cast(void**)&FT_Stream_OpenBzip2, "FT_Stream_OpenBzip2");
    }

    lib.bindSymbol(cast(void**)&FTC_Manager_New, "FTC_Manager_New");
    lib.bindSymbol(cast(void**)&FTC_Manager_Reset, "FTC_Manager_Reset");
    lib.bindSymbol(cast(void**)&FTC_Manager_Done, "FTC_Manager_Done");
    lib.bindSymbol(cast(void**)&FTC_Manager_LookupFace, "FTC_Manager_LookupFace");
    lib.bindSymbol(cast(void**)&FTC_Manager_LookupSize, "FTC_Manager_LookupSize");
    lib.bindSymbol(cast(void**)&FTC_Node_Unref, "FTC_Node_Unref");
    lib.bindSymbol(cast(void**)&FTC_Manager_RemoveFaceID, "FTC_Manager_RemoveFaceID");
    lib.bindSymbol(cast(void**)&FTC_CMapCache_New, "FTC_CMapCache_New");
    lib.bindSymbol(cast(void**)&FTC_CMapCache_Lookup, "FTC_CMapCache_Lookup");
    lib.bindSymbol(cast(void**)&FTC_ImageCache_New, "FTC_ImageCache_New");
    lib.bindSymbol(cast(void**)&FTC_ImageCache_Lookup, "FTC_ImageCache_Lookup");
    lib.bindSymbol(cast(void**)&FTC_ImageCache_LookupScaler, "FTC_ImageCache_LookupScaler");
    lib.bindSymbol(cast(void**)&FTC_SBitCache_New, "FTC_SBitCache_New");
    lib.bindSymbol(cast(void**)&FTC_SBitCache_Lookup, "FTC_SBitCache_Lookup");
    lib.bindSymbol(cast(void**)&FTC_SBitCache_LookupScaler, "FTC_SBitCache_LookupScaler");

    lib.bindSymbol(cast(void**)&FT_Get_CID_Registry_Ordering_Supplement, "FT_Get_CID_Registry_Ordering_Supplement");
    lib.bindSymbol(cast(void**)&FT_Get_CID_Is_Internally_CID_Keyed, "FT_Get_CID_Is_Internally_CID_Keyed");
    lib.bindSymbol(cast(void**)&FT_Get_CID_From_Glyph_Index, "FT_Get_CID_From_Glyph_Index");

    lib.bindSymbol(cast(void**)&FT_Get_Font_Format, "FT_Get_Font_Format");

    lib.bindSymbol(cast(void**)&FT_Get_Gasp, "FT_Get_Gasp");

    lib.bindSymbol(cast(void**)&FT_Get_Glyph, "FT_Get_Glyph");
    lib.bindSymbol(cast(void**)&FT_Glyph_Copy, "FT_Glyph_Copy");
    lib.bindSymbol(cast(void**)&FT_Glyph_Transform, "FT_Glyph_Transform");
    lib.bindSymbol(cast(void**)&FT_Glyph_Get_CBox, "FT_Glyph_Get_CBox");
    lib.bindSymbol(cast(void**)&FT_Glyph_To_Bitmap, "FT_Glyph_To_Bitmap");
    lib.bindSymbol(cast(void**)&FT_Done_Glyph, "FT_Done_Glyph");
    lib.bindSymbol(cast(void**)&FT_Matrix_Multiply, "FT_Matrix_Multiply");
    lib.bindSymbol(cast(void**)&FT_Matrix_Invert, "FT_Matrix_Invert");

    lib.bindSymbol(cast(void**)&FT_TrueTypeGX_Validate, "FT_TrueTypeGX_Validate");
    lib.bindSymbol(cast(void**)&FT_TrueTypeGX_Free, "FT_TrueTypeGX_Free");
    lib.bindSymbol(cast(void**)&FT_ClassicKern_Validate, "FT_ClassicKern_Validate");
    lib.bindSymbol(cast(void**)&FT_ClassicKern_Free, "FT_ClassicKern_Free");

    lib.bindSymbol(cast(void**)&FT_Stream_OpenGzip, "FT_Stream_OpenGzip");
    lib.bindSymbol(cast(void**)&FT_Gzip_Uncompress, "FT_Gzip_Uncompress");

    lib.bindSymbol(cast(void**)&FT_Library_SetLcdFilter, "FT_Library_SetLcdFilter");
    lib.bindSymbol(cast(void**)&FT_Library_SetLcdFilterWeights, "FT_Library_SetLcdFilterWeights");

    lib.bindSymbol(cast(void**)&FT_List_Find, "FT_List_Find");
    lib.bindSymbol(cast(void**)&FT_List_Add, "FT_List_Add");
    lib.bindSymbol(cast(void**)&FT_List_Insert, "FT_List_Insert");
    lib.bindSymbol(cast(void**)&FT_List_Remove, "FT_List_Remove");
    lib.bindSymbol(cast(void**)&FT_List_Up, "FT_List_Up");
    lib.bindSymbol(cast(void**)&FT_List_Iterate, "FT_List_Iterate");
    lib.bindSymbol(cast(void**)&FT_List_Finalize, "FT_List_Finalize");

    lib.bindSymbol(cast(void**)&FT_Stream_OpenLZW, "FT_Stream_OpenLZW");

    lib.bindSymbol(cast(void**)&FT_Get_Multi_Master, "FT_Get_Multi_Master");
    lib.bindSymbol(cast(void**)&FT_Get_MM_Var, "FT_Get_MM_Var");
    lib.bindSymbol(cast(void**)&FT_Set_MM_Design_Coordinates, "FT_Set_MM_Design_Coordinates");
    lib.bindSymbol(cast(void**)&FT_Set_Var_Design_Coordinates, "FT_Set_Var_Design_Coordinates");
    lib.bindSymbol(cast(void**)&FT_Set_MM_Blend_Coordinates, "FT_Set_MM_Blend_Coordinates");
    lib.bindSymbol(cast(void**)&FT_Set_Var_Blend_Coordinates, "FT_Set_Var_Blend_Coordinates");

    lib.bindSymbol(cast(void**)&FT_Add_Module, "FT_Add_Module");
    lib.bindSymbol(cast(void**)&FT_Get_Module, "FT_Get_Module");
    lib.bindSymbol(cast(void**)&FT_Remove_Module, "FT_Remove_Module");
    lib.bindSymbol(cast(void**)&FT_Property_Set, "FT_Property_Set");
    lib.bindSymbol(cast(void**)&FT_Property_Get, "FT_Property_Get");
    lib.bindSymbol(cast(void**)&FT_Reference_Library, "FT_Reference_Library");
    lib.bindSymbol(cast(void**)&FT_New_Library, "FT_New_Library");
    lib.bindSymbol(cast(void**)&FT_Done_Library, "FT_Done_Library");
    lib.bindSymbol(cast(void**)&FT_Set_Debug_Hook, "FT_Set_Debug_Hook");
    lib.bindSymbol(cast(void**)&FT_Add_Default_Modules, "FT_Add_Default_Modules");
    lib.bindSymbol(cast(void**)&FT_Get_TrueType_Engine_Type, "FT_Get_TrueType_Engine_Type");

    lib.bindSymbol(cast(void**)&FT_OpenType_Validate, "FT_OpenType_Validate");
    lib.bindSymbol(cast(void**)&FT_OpenType_Free, "FT_OpenType_Free");

    lib.bindSymbol(cast(void**)&FT_Outline_Decompose, "FT_Outline_Decompose");
    lib.bindSymbol(cast(void**)&FT_Outline_New, "FT_Outline_New");
    lib.bindSymbol(cast(void**)&FT_Outline_Done, "FT_Outline_Done");
    lib.bindSymbol(cast(void**)&FT_Outline_Check, "FT_Outline_Check");
    lib.bindSymbol(cast(void**)&FT_Outline_Get_CBox, "FT_Outline_Get_CBox");
    lib.bindSymbol(cast(void**)&FT_Outline_Translate, "FT_Outline_Translate");
    lib.bindSymbol(cast(void**)&FT_Outline_Copy, "FT_Outline_Copy");
    lib.bindSymbol(cast(void**)&FT_Outline_Transform, "FT_Outline_Transform");
    lib.bindSymbol(cast(void**)&FT_Outline_Embolden, "FT_Outline_Embolden");
    lib.bindSymbol(cast(void**)&FT_Outline_EmboldenXY, "FT_Outline_EmboldenXY");
    lib.bindSymbol(cast(void**)&FT_Outline_Reverse, "FT_Outline_Reverse");
    lib.bindSymbol(cast(void**)&FT_Outline_Get_Bitmap, "FT_Outline_Get_Bitmap");
    lib.bindSymbol(cast(void**)&FT_Outline_Render, "FT_Outline_Render");
    lib.bindSymbol(cast(void**)&FT_Outline_Get_Orientation, "FT_Outline_Get_Orientation");

    lib.bindSymbol(cast(void**)&FT_Get_PFR_Metrics, "FT_Get_PFR_Metrics");
    lib.bindSymbol(cast(void**)&FT_Get_PFR_Kerning, "FT_Get_PFR_Kerning");
    lib.bindSymbol(cast(void**)&FT_Get_PFR_Advance, "FT_Get_PFR_Advance");

    lib.bindSymbol(cast(void**)&FT_Get_Renderer, "FT_Get_Renderer");
    lib.bindSymbol(cast(void**)&FT_Set_Renderer, "FT_Set_Renderer");

    lib.bindSymbol(cast(void**)&FT_New_Size, "FT_New_Size");
    lib.bindSymbol(cast(void**)&FT_Done_Size, "FT_Done_Size");
    lib.bindSymbol(cast(void**)&FT_Activate_Size, "FT_Activate_Size");

    lib.bindSymbol(cast(void**)&FT_Get_Sfnt_Name_Count, "FT_Get_Sfnt_Name_Count");
    lib.bindSymbol(cast(void**)&FT_Get_Sfnt_Name, "FT_Get_Sfnt_Name");

    lib.bindSymbol(cast(void**)&FT_Outline_GetInsideBorder, "FT_Outline_GetInsideBorder");
    lib.bindSymbol(cast(void**)&FT_Outline_GetOutsideBorder, "FT_Outline_GetOutsideBorder");
    lib.bindSymbol(cast(void**)&FT_Stroker_New, "FT_Stroker_New");
    lib.bindSymbol(cast(void**)&FT_Stroker_Set, "FT_Stroker_Set");
    lib.bindSymbol(cast(void**)&FT_Stroker_Rewind, "FT_Stroker_Rewind");
    lib.bindSymbol(cast(void**)&FT_Stroker_ParseOutline, "FT_Stroker_ParseOutline");
    lib.bindSymbol(cast(void**)&FT_Stroker_BeginSubPath, "FT_Stroker_BeginSubPath");
    lib.bindSymbol(cast(void**)&FT_Stroker_EndSubPath, "FT_Stroker_EndSubPath");
    lib.bindSymbol(cast(void**)&FT_Stroker_LineTo, "FT_Stroker_LineTo");
    lib.bindSymbol(cast(void**)&FT_Stroker_ConicTo, "FT_Stroker_ConicTo");
    lib.bindSymbol(cast(void**)&FT_Stroker_CubicTo, "FT_Stroker_CubicTo");
    lib.bindSymbol(cast(void**)&FT_Stroker_GetBorderCounts, "FT_Stroker_GetBorderCounts");
    lib.bindSymbol(cast(void**)&FT_Stroker_ExportBorder, "FT_Stroker_ExportBorder");
    lib.bindSymbol(cast(void**)&FT_Stroker_GetCounts, "FT_Stroker_GetCounts");
    lib.bindSymbol(cast(void**)&FT_Stroker_Export, "FT_Stroker_Export");
    lib.bindSymbol(cast(void**)&FT_Stroker_Done, "FT_Stroker_Done");
    lib.bindSymbol(cast(void**)&FT_Glyph_Stroke, "FT_Glyph_Stroke");
    lib.bindSymbol(cast(void**)&FT_Glyph_StrokeBorder, "FT_Glyph_StrokeBorder");

    lib.bindSymbol(cast(void**)&FT_GlyphSlot_Embolden, "FT_GlyphSlot_Embolden");
    lib.bindSymbol(cast(void**)&FT_GlyphSlot_Oblique, "FT_GlyphSlot_Oblique");

    lib.bindSymbol(cast(void**)&FT_Sin, "FT_Sin");
    lib.bindSymbol(cast(void**)&FT_Cos, "FT_Cos");
    lib.bindSymbol(cast(void**)&FT_Tan, "FT_Tan");
    lib.bindSymbol(cast(void**)&FT_Atan2, "FT_Atan2");
    lib.bindSymbol(cast(void**)&FT_Angle_Diff, "FT_Angle_Diff");
    lib.bindSymbol(cast(void**)&FT_Vector_Unit, "FT_Vector_Unit");
    lib.bindSymbol(cast(void**)&FT_Vector_Rotate, "FT_Vector_Rotate");
    lib.bindSymbol(cast(void**)&FT_Vector_Length, "FT_Vector_Length");
    lib.bindSymbol(cast(void**)&FT_Vector_Polarize, "FT_Vector_Polarize");
    lib.bindSymbol(cast(void**)&FT_Vector_From_Polar, "FT_Vector_From_Polar");

    lib.bindSymbol(cast(void**)&FT_Get_WinFNT_Header, "FT_Get_WinFNT_Header");

    lib.bindSymbol(cast(void**)&FT_Has_PS_Glyph_Names, "FT_Has_PS_Glyph_Names");
    lib.bindSymbol(cast(void**)&FT_Get_PS_Font_Info, "FT_Get_PS_Font_Info");
    lib.bindSymbol(cast(void**)&FT_Get_PS_Font_Private, "FT_Get_PS_Font_Private");
    lib.bindSymbol(cast(void**)&FT_Get_PS_Font_Value, "FT_Get_PS_Font_Value");

    lib.bindSymbol(cast(void**)&FT_Get_Sfnt_Table, "FT_Get_Sfnt_Table");
    lib.bindSymbol(cast(void**)&FT_Load_Sfnt_Table, "FT_Load_Sfnt_Table");
    lib.bindSymbol(cast(void**)&FT_Sfnt_Table_Info, "FT_Sfnt_Table_Info");
    lib.bindSymbol(cast(void**)&FT_Get_CMap_Language_ID, "FT_Get_CMap_Language_ID");
    lib.bindSymbol(cast(void**)&FT_Get_CMap_Format, "FT_Get_CMap_Format");

    if(errorCount() != errCount) return FTSupport.badLibrary;
    else loadedVersion = FTSupport.ft26;

    static if(ftSupport >= FTSupport.ft27) {
        lib.bindSymbol(cast(void**)&FT_Get_Var_Design_Coordinates, "FT_Get_Var_Design_Coordinates");
        lib.bindSymbol(cast(void**)&FT_Get_MM_Blend_Coordinates, "FT_Get_MM_Blend_Coordinates");
        lib.bindSymbol(cast(void**)&FT_Get_Var_Blend_Coordinates, "FT_Get_Var_Blend_Coordinates");

        if(errorCount() != errCount) return FTSupport.badLibrary;
        else loadedVersion = FTSupport.ft27;
    }

    static if(ftSupport >= FTSupport.ft28) {
        lib.bindSymbol(cast(void**)&FT_Face_Properties, "FT_Face_Properties");
        lib.bindSymbol(cast(void**)&FT_Get_Var_Axis_Flags, "FT_Get_Var_Axis_Flags");
        lib.bindSymbol(cast(void**)&FT_Set_Default_Properties, "FT_Set_Default_Properties");
        lib.bindSymbol(cast(void**)&FT_Get_Sfnt_LangTag, "FT_Get_Sfnt_LangTag");

        if(errorCount() != errCount) return FTSupport.badLibrary;
        else loadedVersion = FTSupport.ft28;
    }

    static if(ftSupport >= FTSupport.ft29) {
        lib.bindSymbol(cast(void**)&FT_Done_MM_Var, "FT_Done_MM_Var");
        lib.bindSymbol(cast(void**)&FT_Set_Named_Instance, "FT_Set_Named_Instance");

        if(errorCount() != errCount) return FTSupport.badLibrary;
        else loadedVersion = FTSupport.ft29;
    }

    static if(ftSupport >= FTSupport.ft210) {
        lib.bindSymbol(cast(void**)&FT_Palette_Data_Get, "FT_Palette_Data_Get");
        lib.bindSymbol(cast(void**)&FT_Palette_Select, "FT_Palette_Select");
        lib.bindSymbol(cast(void**)&FT_Palette_Set_Foreground_Color, "FT_Palette_Set_Foreground_Color");
        lib.bindSymbol(cast(void**)&FT_Library_SetLcdGeometry, "FT_Library_SetLcdGeometry");

        if(errorCount() != errCount) return FTSupport.badLibrary;
        else loadedVersion = FTSupport.ft210;
    }

    return loadedVersion;
}