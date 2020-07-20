
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdltouch;

import bindbc.sdl.config;

alias SDL_TouchID = long;
alias SDL_FingerID = long;

struct SDL_Finger {
    SDL_FingerID id;
    float x;
    float y;
    float pressure;
}

enum DL_TOUCH_MOUSEID = cast(uint)-1;

static if(sdlSupport >= SDLSupport.sdl2010) {
    enum SDL_TouchDeviceType {
        SDL_TOUCH_DEVICE_INVALID = -1,
        SDL_TOUCH_DEVICE_DIRECT,
        SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE,
        SDL_TOUCH_DEVICE_INDIRECT_RELATIVE,
    }
    mixin(expandEnum!SDL_TouchDeviceType);

    enum SDL_MOUSE_TOUCHID = -1L;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_GetNumTouchDevices();
        SDL_TouchID SDL_GetTouchDevice(int);
        int SDL_GetNumTouchFingers(SDL_TouchID);
        SDL_Finger* SDL_GetTouchFinger(SDL_TouchID,int);
    }
    static if(sdlSupport >= SDLSupport.sdl2010) {
        SDL_TouchDeviceType SDL_GetTouchDeviceType(SDL_TouchID);
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
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_GetTouchDeviceType = SDL_TouchDeviceType function(SDL_TouchID);
        }
        __gshared {
            pSDL_GetTouchDeviceType SDL_GetTouchDeviceType;
        }
    }
}