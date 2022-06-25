
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftbdf;

version(linux) {
    import bindbc.freetype.config;
    import bindbc.freetype.bind.freetype,
           bindbc.freetype.bind.fttypes;

    alias BDF_PropertyType = int;
    enum {
        BDF_PROPERTY_TYPE_NONE = 0,
        BDF_PROPERTY_TYPE_ATOM = 1,
        BDF_PROPERTY_TYPE_INTEGER = 2,
        BDF_PROPERTY_TYPE_CARDINAL = 3
    }

    alias BDF_Property = BDF_PropertyRec*;

    struct BDF_PropertyRec {
        BDF_PropertyType type;
        union u {
         char* atom;
         FT_Int32 integer;
         FT_UInt32 cardinal;
        }
    }

    version(BindFT_Static) {
        extern(C) @nogc nothrow {
            FT_Error FT_Get_BDF_Charset_ID(FT_Face,const(char)** acharset_encoding,const(char)** acharset_registry);
            FT_Error FT_Get_BDF_Property(FT_Face,const(char)*,BDF_PropertyRec*);
        }
    }
    else {
        extern(C) @nogc nothrow {
            alias pFT_Get_BDF_Charset_ID = FT_Error function(FT_Face,const(char)** acharset_encoding,const(char)** acharset_registry);
            alias pFT_Get_BDF_Property = FT_Error function(FT_Face,const(char)*,BDF_PropertyRec*);
        }

        __gshared {
            pFT_Get_BDF_Charset_ID FT_Get_BDF_Charset_ID;
            pFT_Get_BDF_Property FT_Get_BDF_Property;
        }
    }
}
