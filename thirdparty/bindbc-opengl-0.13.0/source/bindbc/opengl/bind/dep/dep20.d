
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.dep.dep20;

version(GL_AllowDeprecated) {
    enum : uint  {
        GL_VERTEX_PROGRAM_TWO_SIDE        = 0x8643,
        GL_POINT_SPRITE                   = 0x8861,
        GL_COORD_REPLACE                  = 0x8862,
        GL_MAX_TEXTURE_COORDS             = 0x8871,
    }
}