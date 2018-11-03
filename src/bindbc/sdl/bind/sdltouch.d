
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdltouch;

alias SDL_TouchID = long;
alias SDL_FingerID = long;

struct SDL_Finger {
    SDL_FingerID id;
    float x;
    float y;
    float pressure;
}

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        int SDL_GetNumTouchDevices();
        SDL_TouchID SDL_GetTouchDevice(int);
        int SDL_GetNumTouchFingers(SDL_TouchID);
        SDL_Finger* SDL_GetTouchFinger(SDL_TouchID,int);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumTouchDevices = int function();
        alias pSDL_GetTouchDevice = SDL_TouchID function(int);
        alias pSDL_GetNumTouchFingers = int function(SDL_TouchID);
        alias pSDL_GetTouchFinger = SDL_Finger* function(SDL_TouchID,int);
    }

    __gshared {
        pSDL_GetNumTouchDevices SDL_GetNumTouchDevices;
        pSDL_GetTouchDevice SDL_GetTouchDevice;
        pSDL_GetNumTouchFingers SDL_GetNumTouchFingers;
        pSDL_GetTouchFinger SDL_GetTouchFinger;
    }
}