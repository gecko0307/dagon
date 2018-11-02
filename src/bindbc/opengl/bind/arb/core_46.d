
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.arb.core_46;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl46) {
    enum has46 = true;
}
else enum has46 = false;

// ARB_polygon_offset_clamp
version(GL_ARB) enum useARBPolygonOffsetClamp = true;
else version(ARB_polygon_offset_clamp) enum useARBPolygonOffsetClamp = true;
else enum useARBPolygonOffsetClamp = has46;

static if(useARBPolygonOffsetClamp) {
    private bool _hasARBPolygonOffsetClamp;
    bool hasARBPolygonOffsetClamp() { return _hasARBPolygonOffsetClamp; }

    enum uint GL_POLYGON_OFFSET_CLAMP = 0x8E1B;

    extern(System) @nogc nothrow alias pglPolygonOffsetClamp = void function( GLfloat,GLfloat,GLfloat );
    __gshared pglPolygonOffsetClamp glPolygonOffsetClamp;

    private @nogc nothrow
    bool loadARBPolygonOffsetClamp(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glPolygonOffsetClamp, "glPolygonOffsetClamp");
        return resetErrorCountGL;
    }
}
else enum hasARBPolygonOffsetClamp = false;

// ARB_texture_filter_anisotropic
version(GL_ARB) enum useARBTextureFilterAnisotropic = true;
else version(ARB_texture_filter_anisotropic) enum useARBTextureFilterAnisotropic = true;
else enum useARBTextureFilterAnisotropic = has46;

static if(useARBTextureFilterAnisotropic) {
    private bool _hasARBTextureFilterAnisotropic;
    bool hasARBTextureFilterAnisotropic() { return _hasARBTextureFilterAnisotropic; }

    enum : uint {
        GL_TEXTURE_MAX_ANISOTROPY           = 0x84FE,
        GL_MAX_TEXTURE_MAX_ANISOTROPY       = 0x84FF,
    }
}
else enum hasARBTextureFilterAnisotropic = false;

package(bindbc.opengl) @nogc nothrow
bool loadARB46(SharedLib lib, GLSupport contextVersion)
{
    static if(has46) {
        if(contextVersion >= GLSupport.gl46) {
            _hasARBTextureFilterAnisotropic = true;

            bool ret = true;
            ret = _hasARBPolygonOffsetClamp = lib.loadARBPolygonOffsetClamp(contextVersion);
            return ret;
        }
    }

    static if(useARBTextureFilterAnisotropic) _hasARBTextureFilterAnisotropic =
            hasExtension(contextVersion, "GL_ARB_texture_filter_anisotropic");

    static if(useARBPolygonOffsetClamp) _hasARBPolygonOffsetClamp =
            hasExtension(contextVersion, "GL_ARB_polygon_offset_clamp") &&
            lib.loadARBPolygonOffsetClamp(contextVersion);

    return true;
}