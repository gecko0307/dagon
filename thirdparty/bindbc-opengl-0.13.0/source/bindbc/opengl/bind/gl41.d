
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl41;

import bindbc.opengl.config;
static if(glSupport >= GLSupport.gl41) {
    import bindbc.loader : SharedLib;
    import bindbc.opengl.context;

    package(bindbc.opengl) @nogc nothrow
    bool loadGL41(SharedLib lib, GLSupport contextVersion)
    {
        import bindbc.opengl.bind.arb : loadARB41;

        if(contextVersion >= GLSupport.gl41) {
            if(errorCountGL() == 0 && loadARB41(lib, contextVersion)) return true;
        }
        return false;
    }
}