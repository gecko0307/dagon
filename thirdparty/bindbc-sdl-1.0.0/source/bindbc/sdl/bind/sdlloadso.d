
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlloadso;

import bindbc.sdl.config;
static if(staticBinding){
    extern(C) @nogc nothrow {
        void* SDL_LoadObject(const(char)* sofile);
        void* SDL_LoadFunction(void* handle,const(char*) name);
        void SDL_UnloadObject(void* handle);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_LoadObject = void* function(const(char)* sofile);
        alias pSDL_LoadFunction = void* function(void* handle,const(char*) name);
        alias pSDL_UnloadObject = void function(void* handle);
    }

    __gshared {
        pSDL_LoadObject SDL_LoadObject;
        pSDL_LoadFunction SDL_LoadFunction;
        pSDL_UnloadObject SDL_UnloadObject;
    }
}