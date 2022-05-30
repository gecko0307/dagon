
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmisc;

import bindbc.sdl.config;

static if(sdlSupport >= SDLSupport.sdl2014) {

    static if(staticBinding) {
        extern(C) @nogc nothrow int SDL_OpenURL(const(char)* url);
    }
    else {
        extern(C) @nogc nothrow alias pSDL_OpenURL = int function(const(char)* url);
        __gshared pSDL_OpenURL SDL_OpenURL;
    }

}