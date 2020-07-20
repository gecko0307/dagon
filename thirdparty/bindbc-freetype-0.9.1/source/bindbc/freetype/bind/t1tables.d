
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.t1tables;

import bindbc.freetype.bind.freetype,
       bindbc.freetype.bind.ftimage,
       bindbc.freetype.bind.fttypes;

struct PS_FontInfoRec {
    FT_String* _version;
    FT_String* notice;
    FT_String* full_name;
    FT_String* family_name;
    FT_String* weight;
    FT_Long italic_angle;
    FT_Bool is_fixed_pitch;
    FT_Short underline_position;
    FT_UShort underline_thickness;
}

alias PS_FontInfo = PS_FontInfoRec*;

struct PS_PrivateRec {
    FT_Int unique_id;
    FT_Int lenIV;
    FT_Byte num_blue_values;
    FT_Byte num_other_blues;
    FT_Byte num_family_blues;
    FT_Byte num_family_other_blues;
    FT_Short[14] blue_values;
    FT_Short[10] other_blues;
    FT_Short[14] family_blues;
    FT_Short[10] family_other_blues;
    FT_Fixed blue_scale;
    FT_Int blue_shift;
    FT_Int blue_fuzz;
    FT_UShort[1] standard_width;
    FT_UShort[1] standard_height;
    FT_Byte num_snap_widths;
    FT_Byte num_snap_heights;
    FT_Bool force_bold;
    FT_Bool round_stem_up;
    FT_Short[13] snap_widths;
    FT_Short[13] snap_heights;
    FT_Fixed expansion_factor;
    FT_Long language_group;
    FT_Long password;
    FT_Short[2] min_feature;
}

alias PS_Private = PS_PrivateRec*;

alias T1_Blend_Flags = int;
enum {
    T1_BLEND_UNDERLINE_POSITION = 0,
    T1_BLEND_UNDERLINE_THICKNESS,
    T1_BLEND_ITALIC_ANGLE,
    T1_BLEND_BLUE_VALUES,
    T1_BLEND_OTHER_BLUES,
    T1_BLEND_STANDARD_WIDTH,
    T1_BLEND_STANDARD_HEIGHT,
    T1_BLEND_STEM_SNAP_WIDTHS,
    T1_BLEND_STEM_SNAP_HEIGHTS,
    T1_BLEND_BLUE_SCALE,
    T1_BLEND_BLUE_SHIFT,
    T1_BLEND_FAMILY_BLUES,
    T1_BLEND_FAMILY_OTHER_BLUES,
    T1_BLEND_FORCE_BOLD,
    T1_BLEND_MAX
}

enum T1_MAX_MM_DESIGNS = 16;
enum T1_MAX_MM_AXIS = 4;
enum T1_MAX_MM_MAP_POINTS = 20;

struct PS_DesignMapRec {
    FT_Byte num_points;
    FT_Long* design_points;
    FT_Fixed* blend_points;
}

alias PS_DesignMap = PS_DesignMapRec*;

struct PS_BlendRec {
    FT_UInt num_designs;
    FT_UInt num_axis;
    FT_String*[T1_MAX_MM_AXIS] axis_names;
    FT_Fixed*[T1_MAX_MM_DESIGNS] design_pos;
    PS_DesignMapRec[T1_MAX_MM_AXIS] design_map;
    FT_Fixed* weight_vector;
    FT_Fixed* default_weight_vector;
    PS_FontInfo[T1_MAX_MM_DESIGNS+1] font_infos;
    PS_Private[T1_MAX_MM_DESIGNS+1] privates;
    FT_ULong blend_bitflags;
    FT_BBox*[T1_MAX_MM_DESIGNS+1] bboxes;
    FT_UInt[T1_MAX_MM_DESIGNS] default_design_vector;
    FT_UInt num_default_design_vector;
}

alias PS_Blend = PS_BlendRec*;

struct CID_FaceDictRec {
    PS_PrivateRec private_dict;
    FT_UInt len_buildchar;
    FT_Fixed forcebold_threshold;
    FT_Pos stroke_width;
    FT_Fixed expansion_factor;
    FT_Byte paint_type;
    FT_Byte font_type;
    FT_Matrix font_matrix;
    FT_Vector font_offset;
    FT_UInt num_subrs;
    FT_ULong subrmap_offset;
    FT_Int sd_bytes;
}

alias CID_FaceDict = CID_FaceDictRec*;

struct CID_FaceInfoRec {
    FT_String* cid_font_name;
    FT_Fixed cid_version;
    FT_Int cid_font_type;
    FT_String* registry;
    FT_String* ordering;
    FT_Int supplement;
    PS_FontInfoRec font_info;
    FT_BBox font_bbox;
    FT_ULong uid_base;
    FT_Int num_xuid;
    FT_ULong[16] xuid;
    FT_ULong cidmap_offset;
    FT_Int fd_bytes;
    FT_Int gd_bytes;
    FT_ULong cid_count;
    FT_Int num_dicts;
    CID_FaceDict font_dicts;
    FT_ULong data_offset;
}

alias CID_FaceInfo = CID_FaceInfoRec*;

alias T1_EncodingType = int;
enum {
    T1_ENCODING_TYPE_NONE = 0,
    T1_ENCODING_TYPE_ARRAY,
    T1_ENCODING_TYPE_STANDARD,
    T1_ENCODING_TYPE_ISOLATIN1,
    T1_ENCODING_TYPE_EXPERT,
}

alias PS_Dict_Keys = int;
enum {
    PS_DICT_FONT_TYPE,
    PS_DICT_FONT_MATRIX,
    PS_DICT_FONT_BBOX,
    PS_DICT_PAINT_TYPE,
    PS_DICT_FONT_NAME,
    PS_DICT_UNIQUE_ID,
    PS_DICT_NUM_CHAR_STRINGS,
    PS_DICT_CHAR_STRING_KEY,
    PS_DICT_CHAR_STRING,
    PS_DICT_ENCODING_TYPE,
    PS_DICT_ENCODING_ENTRY,

    PS_DICT_NUM_SUBRS,
    PS_DICT_SUBR,
    PS_DICT_STD_HW,
    PS_DICT_STD_VW,
    PS_DICT_NUM_BLUE_VALUES,
    PS_DICT_BLUE_VALUE,
    PS_DICT_BLUE_FUZZ,
    PS_DICT_NUM_OTHER_BLUES,
    PS_DICT_OTHER_BLUE,
    PS_DICT_NUM_FAMILY_BLUES,
    PS_DICT_FAMILY_BLUE,
    PS_DICT_NUM_FAMILY_OTHER_BLUES,
    PS_DICT_FAMILY_OTHER_BLUE,
    PS_DICT_BLUE_SCALE,
    PS_DICT_BLUE_SHIFT,
    PS_DICT_NUM_STEM_SNAP_H,
    PS_DICT_STEM_SNAP_H,
    PS_DICT_NUM_STEM_SNAP_V,
    PS_DICT_STEM_SNAP_V,
    PS_DICT_FORCE_BOLD,
    PS_DICT_RND_STEM_UP,
    PS_DICT_MIN_FEATURE,
    PS_DICT_LEN_IV,
    PS_DICT_PASSWORD,
    PS_DICT_LANGUAGE_GROUP,

    PS_DICT_VERSION,
    PS_DICT_NOTICE,
    PS_DICT_FULL_NAME,
    PS_DICT_FAMILY_NAME,
    PS_DICT_WEIGHT,
    PS_DICT_IS_FIXED_PITCH,
    PS_DICT_UNDERLINE_POSITION,
    PS_DICT_UNDERLINE_THICKNESS,
    PS_DICT_FS_TYPE,
    PS_DICT_ITALIC_ANGLE,

    PS_DICT_MAX = PS_DICT_ITALIC_ANGLE
}

version(BindFT_Static) {
	extern(C) @nogc nothrow {
        FT_Int FT_Has_PS_Glyph_Names(FT_Face);
        FT_Error FT_Get_PS_Font_Info(FT_Face,PS_FontInfoRec*);
        FT_Error FT_Get_PS_Font_Private(FT_Face,PS_PrivateRec*);
        FT_Long FT_Get_PS_Font_Value(FT_Face,PS_Dict_Keys*,FT_UInt,FT_Long);
    }
}
else {
    extern(C) @nogc nothrow {
        alias da_FT_Has_PS_Glyph_Names = FT_Int function(FT_Face);
        alias da_FT_Get_PS_Font_Info = FT_Error function(FT_Face,PS_FontInfoRec*);
        alias da_FT_Get_PS_Font_Private = FT_Error function(FT_Face,PS_PrivateRec*);
        alias da_FT_Get_PS_Font_Value = FT_Long function(FT_Face,PS_Dict_Keys*,FT_UInt,FT_Long);
    }

    __gshared {
        da_FT_Has_PS_Glyph_Names FT_Has_PS_Glyph_Names;
        da_FT_Get_PS_Font_Info FT_Get_PS_Font_Info;
        da_FT_Get_PS_Font_Private FT_Get_PS_Font_Private;
        da_FT_Get_PS_Font_Value FT_Get_PS_Font_Value;
    }
}