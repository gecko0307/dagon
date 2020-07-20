
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlerror;

import bindbc.sdl.config;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        void SDL_SetError(const(char)*,...);
        const(char)* SDL_GetError();
        void SDL_ClearError();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_SetError = void function(const(char)*,...);
        alias pSDL_GetError = const(char)* function();
        alias pSDL_ClearError = void function();
    }

    __gshared {
        pSDL_SetError SDL_SetError;
        pSDL_GetError SDL_GetError;
        pSDL_ClearError SDL_ClearError;
    }
}