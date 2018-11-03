
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind;

public
import bindbc.opengl.bind.gl21,
       bindbc.opengl.bind.types;

version(GL_46) {
    public import bindbc.opengl.bind.gl46;
    version = GL_45;
}
version(GL_45) {
    public import bindbc.opengl.bind.gl45;
    version = GL_44;
}
version(GL_44) {
    public import bindbc.opengl.bind.gl44;
    version = GL_43;
}
version(GL_43) {
    public import bindbc.opengl.bind.gl43;
    version = GL_42;
}
version(GL_42) {
    public import bindbc.opengl.bind.gl42;
    version = GL_41;
}
version(GL_41) {
    public import bindbc.opengl.bind.gl41;
    version = GL_40;
}
version(GL_40) {
    public import bindbc.opengl.bind.gl40;
    version = GL_33;
}
version(GL_33) {
    public import bindbc.opengl.bind.gl33;
    version = GL_32;
}
version(GL_32) {
    public import bindbc.opengl.bind.gl32;
    version = GL_31;
}
version(GL_31) {
    public import bindbc.opengl.bind.gl31;
    version = GL_30;
}
version(GL_30) public import bindbc.opengl.bind.gl30;

public
import bindbc.opengl.bind.arb;