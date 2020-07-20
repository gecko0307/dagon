
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlplatform;

import bindbc.sdl.config;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        const(char)* SDL_GetPlatform();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetPlatform = const(char)* function();
    }

    __gshared {
        pSDL_GetPlatform SDL_GetPlatform;
    }
}