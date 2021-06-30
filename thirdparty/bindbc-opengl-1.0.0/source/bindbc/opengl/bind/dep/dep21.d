
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep21;

version(GL_AllowDeprecated) {
    enum : uint  {
        GL_CURRENT_RASTER_SECONDARY_COLOR = 0x845F,
        GL_SLUMINANCE_ALPHA               = 0x8C44,
        GL_SLUMINANCE8_ALPHA8             = 0x8C45,
        GL_SLUMINANCE                     = 0x8C46,
        GL_SLUMINANCE8                    = 0x8C47,
        GL_COMPRESSED_SLUMINANCE          = 0x8C4A,
        GL_COMPRESSED_SLUMINANCE_ALPHA    = 0x8C4B,
    }
}