//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.util;

import bindbc.loader;
import bindbc.opengl.config;
import bindbc.opengl.context;
import bindbc.opengl.gl : libGL;

@nogc nothrow:
bool loadBaseGLSymbol(void** ptr, const(char)* symName)
{
    assert(ptr);
    auto lib = libGL();
    if(lib != invalidHandle) {
        auto errCount = errorCount();
        lib.bindSymbol(ptr, symName);
        return errorCount() == errCount;
    }
    else return false;
}

bool loadExtendedGLSymbol(void** ptr, const(char)* symName)
{
    assert(ptr);
    auto lib = libGL();
    if(lib.getContextVersion() > GLSupport.noContext) {
        auto errCount = errorCountGL();
        lib.bindGLSymbol(ptr, symName);
        return errorCountGL() == errCount;
    }
    else return false;
}