
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdltimer;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

extern(C) nothrow alias SDL_TimerCallback = uint function(uint interval, void* param);
alias SDL_TimerID = int;

// This was added to SDL 2.0.1 as a macro, but it's
// useful & has no dependency on the library version,
// so it's here for 2.0.0 as well.
@nogc nothrow pure
bool SDL_TICKS_PASSED(uint A, uint B) {
    pragma(inline, true);
    return cast(int)(B - A) <= 0;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        uint SDL_GetTicks();
        ulong SDL_GetPerformanceCounter();
        ulong SDL_GetPerformanceFrequency();
        void SDL_Delay(uint);
        SDL_TimerID SDL_AddTimer(uint,SDL_TimerCallback,void*);
        SDL_bool SDL_RemoveTimer(SDL_TimerID);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetTicks = uint function();
        alias pSDL_GetPerformanceCounter = ulong function();
        alias pSDL_GetPerformanceFrequency = ulong function();
        alias pSDL_Delay = void function(uint);
        alias pSDL_AddTimer = SDL_TimerID function(uint,SDL_TimerCallback,void*);
        alias pSDL_RemoveTimer = SDL_bool function(SDL_TimerID);
    }

    __gshared {
        pSDL_GetTicks SDL_GetTicks;
        pSDL_GetPerformanceCounter SDL_GetPerformanceCounter;
        pSDL_GetPerformanceFrequency SDL_GetPerformanceFrequency;
        pSDL_Delay SDL_Delay;
        pSDL_AddTimer SDL_AddTimer;
        pSDL_RemoveTimer SDL_RemoveTimer;
    }
}