
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlgesture;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdltouch : SDL_TouchID;
import bindbc.sdl.bind.sdlrwops : SDL_RWops;

alias SDL_GestureID = long;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_RecordGesture(SDL_TouchID);
        int SDL_SaveAllDollarTemplates(SDL_RWops*);
        int SDL_SaveDollarTemplate(SDL_GestureID,SDL_RWops*);
        int SDL_LoadDollarTemplates(SDL_TouchID,SDL_RWops*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_RecordGesture = int function(SDL_TouchID);
        alias pSDL_SaveAllDollarTemplates = int function(SDL_RWops*);
        alias pSDL_SaveDollarTemplate = int function(SDL_GestureID,SDL_RWops*);
        alias pSDL_LoadDollarTemplates = int function(SDL_TouchID,SDL_RWops*);
    }

    __gshared {
        pSDL_RecordGesture SDL_RecordGesture;
        pSDL_SaveAllDollarTemplates SDL_SaveAllDollarTemplates;
        pSDL_SaveDollarTemplate SDL_SaveDollarTemplate;
        pSDL_LoadDollarTemplates SDL_LoadDollarTemplates;
    }
}