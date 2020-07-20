
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlpower;

import bindbc.sdl.config;

enum SDL_PowerState {
    SDL_POWERSTATE_UNKNOWN,
    SDL_POWERSTATE_ON_BATTERY,
    SDL_POWERSTATE_NO_BATTERY,
    SDL_POWERSTATE_CHARGING,
    SDL_POWERSTATE_CHARGED
}
mixin(expandEnum!SDL_PowerState);

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_PowerState SDL_GetPowerInfo(int*,int*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetPowerInfo = SDL_PowerState function(int*,int*);
    }

    __gshared {
        pSDL_GetPowerInfo SDL_GetPowerInfo;
    }
}