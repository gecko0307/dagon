
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl42;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl42) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;

    enum : uint {
        GL_COPY_READ_BUFFER_BINDING  = 0x8F36,
        GL_COPY_WRITE_BUFFER_BINDING = 0x8F37,
        GL_TRANSFORM_FEEDBACK_PAUSED = 0x8E23,
        GL_TRANSFORM_FEEDBACK_ACTIVE = 0x8E24,
        GL_COMPRESSED_RGBA_BPTC_UNORM = 0x8E8C,
        GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM = 0x8E8D,
        GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT = 0x8E8E,
        GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = 0x8E8F,
    }

    package(bindbc.opengl) @nogc nothrow
    GLSupport loadGL42(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB42;

        if(contextVersion >= GLSupport.gl42) {
            if(errorCountGL() == 0 && loadARB42(lib, contextVersion)) return GLSupport.gl42;
        }
        return GLSupport.gl41;
    }
}