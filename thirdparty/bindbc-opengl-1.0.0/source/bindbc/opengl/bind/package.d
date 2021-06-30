
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind;

public
import bindbc.opengl.config,
       bindbc.opengl.bind.gl21,
       bindbc.opengl.bind.types;

static if(glSupport >= GLSupport.gl46) {
    public import bindbc.opengl.bind.gl46;
}
static if(glSupport >= GLSupport.gl45) {
    public import bindbc.opengl.bind.gl45;
}
static if(glSupport >= GLSupport.gl44) {
    public import bindbc.opengl.bind.gl44;
}
static if(glSupport >= GLSupport.gl43) {
    public import bindbc.opengl.bind.gl43;
}
static if(glSupport >= GLSupport.gl42) {
    public import bindbc.opengl.bind.gl42;
}
static if(glSupport >= GLSupport.gl41) {
    public import bindbc.opengl.bind.gl41;
}
static if(glSupport >= GLSupport.gl40) {
    public import bindbc.opengl.bind.gl40;
}
static if(glSupport >= GLSupport.gl33) {
    public import bindbc.opengl.bind.gl33;
}
static if(glSupport >= GLSupport.gl32) {
    public import bindbc.opengl.bind.gl32;
}
static if(glSupport >= GLSupport.gl31) {
    public import bindbc.opengl.bind.gl31;
}
static if(glSupport >= GLSupport.gl30) {
    public import bindbc.opengl.bind.gl30;
}

public
import bindbc.opengl.bind.arb,
       bindbc.opengl.bind.nv;
