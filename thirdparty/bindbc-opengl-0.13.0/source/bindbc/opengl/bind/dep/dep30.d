
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep30;

import bindbc.opengl.config;

static if(glAllowDeprecated && glSupport > GLSupport.gl21) {
    enum : uint  {
        GL_CLAMP_VERTEX_COLOR             = 0x891A,
        GL_CLAMP_FRAGMENT_COLOR           = 0x891B,
        GL_ALPHA_INTEGER                  = 0x8D97,
        GL_INDEX                          = 0x8222,
        GL_TEXTURE_LUMINANCE_TYPE         = 0x8C14,
        GL_TEXTURE_INTENSITY_TYPE         = 0x8C15,
    }
}