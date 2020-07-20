
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlfilesystem;

import bindbc.sdl.config;

static if(staticBinding){
    extern(C) @nogc nothrow {
        static if(sdlSupport >= SDLSupport.sdl201) {
            char* SDL_GetBasePath();
            char* SDL_GetPrefPath(const(char)* org,const(char)* app);
        }
    }
}
else {
    static if(sdlSupport >= SDLSupport.sdl201) {
        extern(C) @nogc nothrow {
            alias pSDL_GetBasePath = char* function();
            alias pSDL_GetPrefPath = char* function(const(char)* org,const(char)* app);
        }

        __gshared {
            pSDL_GetBasePath SDL_GetBasePath;
            pSDL_GetPrefPath SDL_GetPrefPath;
        }
    }
}
