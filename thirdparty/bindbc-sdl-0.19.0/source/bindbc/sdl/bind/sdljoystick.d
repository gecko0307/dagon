
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdljoystick;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

struct SDL_Joystick;

struct SDL_JoystickGUID {
    ubyte[16] data;
}

alias SDL_JoystickID = int;

enum : ubyte {
    SDL_HAT_CENTERED = 0x00,
    SDL_HAT_UP = 0x01,
    SDL_HAT_RIGHT = 0x02,
    SDL_HAT_DOWN = 0x04,
    SDL_HAT_LEFT = 0x08,
    SDL_HAT_RIGHTUP = (SDL_HAT_RIGHT|SDL_HAT_UP),
    SDL_HAT_RIGHTDOWN = (SDL_HAT_RIGHT|SDL_HAT_DOWN),
    SDL_HAT_LEFTUP = (SDL_HAT_LEFT|SDL_HAT_UP),
    SDL_HAT_LEFTDOWN = (SDL_HAT_LEFT|SDL_HAT_DOWN),
}

static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_JoystickPowerLevel {
        SDL_JOYSTICK_POWER_UNKNOWN = -1,
        SDL_JOYSTICK_POWER_EMPTY,
        SDL_JOYSTICK_POWER_LOW,
        SDL_JOYSTICK_POWER_MEDIUM,
        SDL_JOYSTICK_POWER_FULL,
        SDL_JOYSTICK_POWER_WIRED,
        SDL_JOYSTICK_POWER_MAX
    }
    mixin(expandEnum!SDL_JoystickPowerLevel);
}

static if(sdlSupport >= SDLSupport.sdl206) {
    enum SDL_JoystickType {
        SDL_JOYSTICK_TYPE_UNKNOWN,
        SDL_JOYSTICK_TYPE_GAMECONTROLLER,
        SDL_JOYSTICK_TYPE_WHEEL,
        SDL_JOYSTICK_TYPE_ARCADE_STICK,
        SDL_JOYSTICK_TYPE_FLIGHT_STICK,
        SDL_JOYSTICK_TYPE_DANCE_PAD,
        SDL_JOYSTICK_TYPE_GUITAR,
        SDL_JOYSTICK_TYPE_DRUM_KIT,
        SDL_JOYSTICK_TYPE_ARCADE_PAD,
        SDL_JOYSTICK_TYPE_THROTTLE,
    }
    mixin(expandEnum!SDL_JoystickType);

    enum {
        SDL_JOYSTICK_AXIS_MAX = 32767,
        SDL_JOYSTICK_AXIS_MIN = -32768,
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_NumJoysticks();
        const(char)* SDL_JoystickNameForIndex(int);
        SDL_JoystickGUID SDL_JoystickGetDeviceGUID(int);
        SDL_Joystick* SDL_JoystickOpen(int);
        const(char)* SDL_JoystickName(SDL_Joystick*);
        SDL_JoystickGUID SDL_JoystickGetGUID(SDL_Joystick*);
        char* SDL_JoystickGetGUIDString(SDL_JoystickGUID);
        SDL_JoystickGUID SDL_JoystickGetGUIDFromString(const(char)*);
        SDL_bool SDL_JoystickGetAttached(SDL_Joystick*);
        SDL_JoystickID SDL_JoystickInstanceID(SDL_Joystick*);
        int SDL_JoystickNumAxes(SDL_Joystick*);
        int SDL_JoystickNumBalls(SDL_Joystick*);
        int SDL_JoystickNumHats(SDL_Joystick*);
        int SDL_JoystickNumButtons(SDL_Joystick*);
        void SDL_JoystickUpdate();
        int SDL_JoystickEventState(int);
        short SDL_JoystickGetAxis(SDL_Joystick*,int);
        ubyte SDL_JoystickGetHat(SDL_Joystick*,int);
        int SDL_JoystickGetBall(SDL_Joystick*,int,int*,int*);
        ubyte SDL_JoystickGetButton(SDL_Joystick*,int);
        void SDL_JoystickClose(SDL_Joystick*);

        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_JoystickPowerLevel SDL_JoystickCurrentPowerLevel(SDL_Joystick*);
            SDL_Joystick* SDL_JoystickFromInstanceID(SDL_JoystickID);
        }
        static if(sdlSupport >= SDLSupport.sdl206) {
            SDL_bool SDL_JoystickGetAxisInitialState(SDL_Joystick*,int,short*);
            SDL_JoystickType SDL_JoystickGetDeviceInstanceID(int);
            ushort SDL_JoystickGetDeviceProduct(int);
            ushort SDL_JoystickGetDeviceProductVersion(int);
            SDL_JoystickType SDL_JoystickGetDeviceType(int);
            ushort SDL_JoystickGetDeviceVendor(int);
            ushort SDL_JoystickGetProduct(SDL_Joystick*);
            ushort SDL_JoystickGetProductVersion(SDL_Joystick*);
            SDL_JoystickType SDL_JoystickGetType(SDL_Joystick*);
            ushort SDL_JoystickGetVendor(SDL_Joystick*);
        }
        static if(sdlSupport >= SDLSupport.sdl207) {
            void SDL_LockJoysticks();
            void SDL_UnlockJoysticks();
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            int SDL_JoystickRumble(SDL_Joystick*,ushort,ushort,uint);
        }
        static if(sdlSupport >= SDLSupport.sdl2010) {
            int SDL_JoystickGetDevicePlayerIndex(int);
            int SDL_JoystickGetPlayerIndex(SDL_Joystick*);
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            SDL_Joystick* SDL_JoystickFromPlayerIndex(int);
            void SDL_JoystickSetPlayerIndex(SDL_Joystick*,int);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_NumJoysticks = int function();
        alias pSDL_JoystickNameForIndex = const(char)* function(int);
        alias pSDL_JoystickGetDeviceGUID = SDL_JoystickGUID function(int);
        alias pSDL_JoystickOpen = SDL_Joystick* function(int);
        alias pSDL_JoystickName = const(char)* function(SDL_Joystick*);
        alias pSDL_JoystickGetGUID = SDL_JoystickGUID function(SDL_Joystick*);
        alias pSDL_JoystickGetGUIDString = char* function(SDL_JoystickGUID);
        alias pSDL_JoystickGetGUIDFromString = SDL_JoystickGUID function(const(char)*);
        alias pSDL_JoystickGetAttached = SDL_bool function(SDL_Joystick*);
        alias pSDL_JoystickInstanceID = SDL_JoystickID function(SDL_Joystick*);
        alias pSDL_JoystickNumAxes = int function(SDL_Joystick*);
        alias pSDL_JoystickNumBalls = int function(SDL_Joystick*);
        alias pSDL_JoystickNumHats = int function(SDL_Joystick*);
        alias pSDL_JoystickNumButtons = int function(SDL_Joystick*);
        alias pSDL_JoystickUpdate = void function();
        alias pSDL_JoystickEventState = int function(int);
        alias pSDL_JoystickGetAxis = short function(SDL_Joystick*,int);
        alias pSDL_JoystickGetHat = ubyte function(SDL_Joystick*,int);
        alias pSDL_JoystickGetBall = int function(SDL_Joystick*,int,int*,int*);
        alias pSDL_JoystickGetButton = ubyte function(SDL_Joystick*,int);
        alias pSDL_JoystickClose = void function(SDL_Joystick*);
    }
    __gshared {
        pSDL_NumJoysticks SDL_NumJoysticks;
        pSDL_JoystickNameForIndex SDL_JoystickNameForIndex;
        pSDL_JoystickGetDeviceGUID SDL_JoystickGetDeviceGUID;
        pSDL_JoystickOpen SDL_JoystickOpen;
        pSDL_JoystickName SDL_JoystickName;
        pSDL_JoystickGetGUID SDL_JoystickGetGUID;
        pSDL_JoystickGetGUIDString SDL_JoystickGetGUIDString;
        pSDL_JoystickGetGUIDFromString SDL_JoystickGetGUIDFromString;
        pSDL_JoystickGetAttached SDL_JoystickGetAttached;
        pSDL_JoystickInstanceID SDL_JoystickInstanceID;
        pSDL_JoystickNumAxes SDL_JoystickNumAxes;
        pSDL_JoystickNumBalls SDL_JoystickNumBalls;
        pSDL_JoystickNumHats SDL_JoystickNumHats;
        pSDL_JoystickNumButtons SDL_JoystickNumButtons;
        pSDL_JoystickUpdate SDL_JoystickUpdate;
        pSDL_JoystickEventState SDL_JoystickEventState;
        pSDL_JoystickGetAxis SDL_JoystickGetAxis;
        pSDL_JoystickGetHat SDL_JoystickGetHat;
        pSDL_JoystickGetBall SDL_JoystickGetBall;
        pSDL_JoystickGetButton SDL_JoystickGetButton;
        pSDL_JoystickClose SDL_JoystickClose;
    }
    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickCurrentPowerLevel = SDL_JoystickPowerLevel function(SDL_Joystick*);
            alias pSDL_JoystickFromInstanceID = SDL_Joystick* function(SDL_JoystickID);
        }
        __gshared {
            pSDL_JoystickCurrentPowerLevel SDL_JoystickCurrentPowerLevel;
            pSDL_JoystickFromInstanceID SDL_JoystickFromInstanceID;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickGetAxisInitialState = SDL_bool function(SDL_Joystick*,int,short*);
            alias pSDL_JoystickGetDeviceInstanceID = SDL_JoystickType function(int);
            alias pSDL_JoystickGetDeviceProduct = ushort function(int);
            alias pSDL_JoystickGetDeviceProductVersion = ushort function(int);
            alias pSDL_JoystickGetDeviceType = SDL_JoystickType function(int);
            alias pSDL_JoystickGetDeviceVendor = ushort function(int);
            alias pSDL_JoystickGetProduct = ushort function(SDL_Joystick*);
            alias pSDL_JoystickGetProductVersion = ushort function(SDL_Joystick*);
            alias pSDL_JoystickGetType = SDL_JoystickType function(SDL_Joystick*);
            alias pSDL_JoystickGetVendor = ushort function(SDL_Joystick*);
        }
        __gshared {
            pSDL_JoystickGetAxisInitialState SDL_JoystickGetAxisInitialState;
            pSDL_JoystickGetDeviceInstanceID SDL_JoystickGetDeviceInstanceID;
            pSDL_JoystickGetDeviceProduct SDL_JoystickGetDeviceProduct;
            pSDL_JoystickGetDeviceProductVersion SDL_JoystickGetDeviceProductVersion;
            pSDL_JoystickGetDeviceType SDL_JoystickGetDeviceType;
            pSDL_JoystickGetDeviceVendor SDL_JoystickGetDeviceVendor;
            pSDL_JoystickGetProduct SDL_JoystickGetProduct;
            pSDL_JoystickGetProductVersion SDL_JoystickGetProductVersion;
            pSDL_JoystickGetType SDL_JoystickGetType;
            pSDL_JoystickGetVendor SDL_JoystickGetVendor;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl207) {
        extern(C) @nogc nothrow {
            alias pSDL_LockJoysticks = void function();
            alias pSDL_UnlockJoysticks = void function();
        }
        __gshared {
            pSDL_LockJoysticks SDL_LockJoysticks;
            pSDL_UnlockJoysticks SDL_UnlockJoysticks;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickRumble = int function(SDL_Joystick*,ushort,ushort,uint);
        }
        __gshared {
            pSDL_JoystickRumble SDL_JoystickRumble;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickGetDevicePlayerIndex = int function(int);
            alias pSDL_JoystickGetPlayerIndex = int function(SDL_Joystick*);
        }
        __gshared {
            pSDL_JoystickGetDevicePlayerIndex SDL_JoystickGetDevicePlayerIndex;
            pSDL_JoystickGetPlayerIndex SDL_JoystickGetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2012) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickFromPlayerIndex = SDL_Joystick* function(int);
            alias pSDL_JoystickSetPlayerIndex = void function(SDL_Joystick*,int);
        }
        __gshared {
            pSDL_JoystickFromPlayerIndex SDL_JoystickFromPlayerIndex;
            pSDL_JoystickSetPlayerIndex SDL_JoystickSetPlayerIndex;
        }
    }
}