
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.config;

debug public import core.stdc.stdio;

enum GLSupport {
    noLibrary,
    badLibrary,
    noContext,
    gl11 = 11,
    gl12 = 12,
    gl13 = 13,
    gl14 = 14,
    gl15 = 15,
    gl20 = 20,
    gl21 = 21,
    gl30 = 30,
    gl31 = 31,
    gl32 = 32,
    gl33 = 33,
    gl40 = 40,
    gl41 = 41,
    gl42 = 42,
    gl43 = 43,
    gl44 = 44,
    gl45 = 45,
    gl46 = 46,
}

version(GL_AllowDeprecated) enum glAllowDeprecated = true;
else enum glAllowDeprecated = false;

version(GL_46)             enum glSupport = GLSupport.gl46;
else version(GL_45)        enum glSupport = GLSupport.gl45;
else version(GL_44)        enum glSupport = GLSupport.gl44;
else version(GL_43)        enum glSupport = GLSupport.gl43;
else version(GL_42)        enum glSupport = GLSupport.gl42;
else version(GL_41)        enum glSupport = GLSupport.gl41;
else version(GL_40)        enum glSupport = GLSupport.gl40;
else version(GL_33)        enum glSupport = GLSupport.gl33;
else version(GL_32)        enum glSupport = GLSupport.gl32;
else version(GL_31)        enum glSupport = GLSupport.gl31;
else version(GL_30)        enum glSupport = GLSupport.gl30;
else                       enum glSupport = GLSupport.gl21;