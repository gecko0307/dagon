
//          Copyright 2018 - 2022 Michael D. Parker
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

static if(sdlSupport >= SDLSupport.sdl2014) enum SDL_IPHONE_MAX_GFORCE = 5.0;

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
        const(char)* SDL_JoystickNameForIndex(int device_index);
        SDL_JoystickGUID SDL_JoystickGetDeviceGUID(int device_index);
        SDL_Joystick* SDL_JoystickOpen(int device_index);
        const(char)* SDL_JoystickName(SDL_Joystick* joystick);
        SDL_JoystickGUID SDL_JoystickGetGUID(SDL_Joystick* joystick);
        void SDL_JoystickGetGUIDString(SDL_JoystickGUID guid, char* pszGUID, int cbGUID);
        SDL_JoystickGUID SDL_JoystickGetGUIDFromString(const(char)* );
        SDL_bool SDL_JoystickGetAttached(SDL_Joystick* joystick);
        SDL_JoystickID SDL_JoystickInstanceID(SDL_Joystick* joystick);
        int SDL_JoystickNumAxes(SDL_Joystick* joystick);
        int SDL_JoystickNumBalls(SDL_Joystick* joystick);
        int SDL_JoystickNumHats(SDL_Joystick* joystick);
        int SDL_JoystickNumButtons(SDL_Joystick* joystick);
        void SDL_JoystickUpdate();
        int SDL_JoystickEventState(int state);
        short SDL_JoystickGetAxis(SDL_Joystick* joystick, int axis);
        ubyte SDL_JoystickGetHat(SDL_Joystick* joystick, int hat);
        int SDL_JoystickGetBall(SDL_Joystick* joystick, int ball, int* dx, int* dy);
        ubyte SDL_JoystickGetButton(SDL_Joystick* joystick, int button);
        void SDL_JoystickClose(SDL_Joystick* joystick);

        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_JoystickPowerLevel SDL_JoystickCurrentPowerLevel(SDL_Joystick* joystick);
            SDL_Joystick* SDL_JoystickFromInstanceID(SDL_JoystickID instance_id);
        }
        static if(sdlSupport >= SDLSupport.sdl206) {
            SDL_bool SDL_JoystickGetAxisInitialState(SDL_Joystick* joystick, int axis, short* state);
            ushort SDL_JoystickGetDeviceProduct(int device_index);
            ushort SDL_JoystickGetDeviceProductVersion(int device_index);
            SDL_JoystickType SDL_JoystickGetDeviceType(int device_index);
            SDL_JoystickType SDL_JoystickGetDeviceInstanceID(int device_index);
            ushort SDL_JoystickGetDeviceVendor(int device_index);
            ushort SDL_JoystickGetProduct(SDL_Joystick* joystick);
            ushort SDL_JoystickGetProductVersion(SDL_Joystick* joystick);
            SDL_JoystickType SDL_JoystickGetType(SDL_Joystick* joystick);
            ushort SDL_JoystickGetVendor(SDL_Joystick* joystick);
        }
        static if(sdlSupport >= SDLSupport.sdl207) {
            void SDL_LockJoysticks();
            void SDL_UnlockJoysticks();
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            int SDL_JoystickRumble(SDL_Joystick* joystick, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms);
        }
        static if(sdlSupport >= SDLSupport.sdl2010) {
            int SDL_JoystickGetDevicePlayerIndex(int device_index);
            int SDL_JoystickGetPlayerIndex(SDL_Joystick* joystick);
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            SDL_Joystick* SDL_JoystickFromPlayerIndex(int);
            void SDL_JoystickSetPlayerIndex(SDL_Joystick* joystick,int);
        }
        static if(sdlSupport >= SDLSupport.sdl2014) {
            int SDL_JoystickAttachVirtual(SDL_JoystickType type, int naxes, int nbuttons, int nhats);
            int SDL_JoystickDetachVirtual(int device_index);
            SDL_bool SDL_JoystickIsVirtual(int device_index);
            int SDL_JoystickSetVirtualAxis(SDL_Joystick* joystick, int axis, short value);
            int SDL_JoystickSetVirtualButton(SDL_Joystick* joystick, int button, ubyte value);
            int SDL_JoystickSetVirtualHat(SDL_Joystick* joystick, int hat, ubyte value);
            const(char)* SDL_JoystickGetSerial(SDL_Joystick* joystick);
            int SDL_JoystickRumbleTriggers(SDL_Joystick* joystick, ushort left_rumble, ushort right_rumble, uint duration_ms);
            SDL_bool SDL_JoystickHasLED(SDL_Joystick* joystick);
            int SDL_JoystickSetLED(SDL_Joystick* joystick, ubyte red, ubyte green, ubyte blue);
        }
        static if(sdlSupport >= SDLSupport.sdl2016) {
            int SDL_JoystickSendEffect(SDL_Joystick* joystick, const(void)*data, int size);
        }
        static if(sdlSupport >= SDLSupport.sdl2018) {
            SDL_bool SDL_JoystickHasRumble(SDL_Joystick* joystick);
            SDL_bool SDL_JoystickHasRumbleTriggers(SDL_Joystick* joystick);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_NumJoysticks = int function();
        alias pSDL_JoystickNameForIndex = const(char)* function(int device_index);
        alias pSDL_JoystickGetDeviceGUID = SDL_JoystickGUID function(int device_index);
        alias pSDL_JoystickOpen = SDL_Joystick* function(int device_index);
        alias pSDL_JoystickName = const(char)* function(SDL_Joystick* joystick);
        alias pSDL_JoystickGetGUID = SDL_JoystickGUID function(SDL_Joystick* joystick);
        alias pSDL_JoystickGetGUIDString = void function(SDL_JoystickGUID guid, char* pszGUID, int cbGUID);
        alias pSDL_JoystickGetGUIDFromString = SDL_JoystickGUID function(const(char)* pchGUID);
        alias pSDL_JoystickGetAttached = SDL_bool function(SDL_Joystick* joystick);
        alias pSDL_JoystickInstanceID = SDL_JoystickID function(SDL_Joystick* joystick);
        alias pSDL_JoystickNumAxes = int function(SDL_Joystick* joystick);
        alias pSDL_JoystickNumBalls = int function(SDL_Joystick* joystick);
        alias pSDL_JoystickNumHats = int function(SDL_Joystick* joystick);
        alias pSDL_JoystickNumButtons = int function(SDL_Joystick* joystick);
        alias pSDL_JoystickUpdate = void function();
        alias pSDL_JoystickEventState = int function(int state);
        alias pSDL_JoystickGetAxis = short function(SDL_Joystick* joystick, int axis);
        alias pSDL_JoystickGetHat = ubyte function(SDL_Joystick* joystick, int hat);
        alias pSDL_JoystickGetBall = int function(SDL_Joystick* joystick, int ball, int* dx, int* dy);
        alias pSDL_JoystickGetButton = ubyte function(SDL_Joystick* joystick, int button);
        alias pSDL_JoystickClose = void function(SDL_Joystick* joystick);
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
            alias pSDL_JoystickCurrentPowerLevel = SDL_JoystickPowerLevel function(SDL_Joystick* joystick);
            alias pSDL_JoystickFromInstanceID = SDL_Joystick* function(SDL_JoystickID instance_id);
        }
        __gshared {
            pSDL_JoystickCurrentPowerLevel SDL_JoystickCurrentPowerLevel;
            pSDL_JoystickFromInstanceID SDL_JoystickFromInstanceID;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickGetAxisInitialState = SDL_bool function(SDL_Joystick* joystick, int axis, short* state);
            alias pSDL_JoystickGetDeviceProduct = ushort function(int device_index);
            alias pSDL_JoystickGetDeviceProductVersion = ushort function(int device_index);
            alias pSDL_JoystickGetDeviceType = SDL_JoystickType function(int device_index);
            alias pSDL_JoystickGetDeviceInstanceID = SDL_JoystickType function(int device_index);
            alias pSDL_JoystickGetDeviceVendor = ushort function(int device_index);
            alias pSDL_JoystickGetProduct = ushort function(SDL_Joystick* joystick);
            alias pSDL_JoystickGetProductVersion = ushort function(SDL_Joystick* joystick);
            alias pSDL_JoystickGetType = SDL_JoystickType function(SDL_Joystick* joystick);
            alias pSDL_JoystickGetVendor = ushort function(SDL_Joystick* joystick);
        }
        __gshared {
            pSDL_JoystickGetAxisInitialState SDL_JoystickGetAxisInitialState;
            pSDL_JoystickGetDeviceProduct SDL_JoystickGetDeviceProduct;
            pSDL_JoystickGetDeviceProductVersion SDL_JoystickGetDeviceProductVersion;
            pSDL_JoystickGetDeviceType SDL_JoystickGetDeviceType;
            pSDL_JoystickGetDeviceInstanceID SDL_JoystickGetDeviceInstanceID;
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
            alias pSDL_JoystickRumble = int function(SDL_Joystick* joystick, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms);
        }
        __gshared {
            pSDL_JoystickRumble SDL_JoystickRumble;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickGetDevicePlayerIndex = int function(int device_index);
            alias pSDL_JoystickGetPlayerIndex = int function(SDL_Joystick* joystick);
        }
        __gshared {
            pSDL_JoystickGetDevicePlayerIndex SDL_JoystickGetDevicePlayerIndex;
            pSDL_JoystickGetPlayerIndex SDL_JoystickGetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2012) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickFromPlayerIndex = SDL_Joystick* function(int);
            alias pSDL_JoystickSetPlayerIndex = void function(SDL_Joystick* joystick,int);
        }
        __gshared {
            pSDL_JoystickFromPlayerIndex SDL_JoystickFromPlayerIndex;
            pSDL_JoystickSetPlayerIndex SDL_JoystickSetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2014) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickAttachVirtual = int function(SDL_JoystickType type, int naxes, int nbuttons, int nhats);
            alias pSDL_JoystickDetachVirtual = int function(int device_index);
            alias pSDL_JoystickIsVirtual = SDL_bool function(int device_index);
            alias pSDL_JoystickSetVirtualAxis = int function(SDL_Joystick* joystick, int axis, short value);
            alias pSDL_JoystickSetVirtualButton = int function(SDL_Joystick* joystick, int button, ubyte value);
            alias pSDL_JoystickSetVirtualHat = int function(SDL_Joystick* joystick, int hat, ubyte value);
            alias pSDL_JoystickGetSerial = const(char)* function(SDL_Joystick* joystick);
            alias pSDL_JoystickRumbleTriggers = int function(SDL_Joystick* joystick, ushort left_rumble, ushort right_rumble, uint duration_ms);
            alias pSDL_JoystickHasLED = SDL_bool function(SDL_Joystick* joystick);
            alias pSDL_JoystickSetLED = int function(SDL_Joystick* joystick, ubyte red, ubyte green, ubyte blue);
        }
        __gshared {
            pSDL_JoystickAttachVirtual SDL_JoystickAttachVirtual;
            pSDL_JoystickDetachVirtual SDL_JoystickDetachVirtual;
            pSDL_JoystickIsVirtual SDL_JoystickIsVirtual;
            pSDL_JoystickSetVirtualAxis SDL_JoystickSetVirtualAxis;
            pSDL_JoystickSetVirtualButton SDL_JoystickSetVirtualButton;
            pSDL_JoystickSetVirtualHat SDL_JoystickSetVirtualHat;
            pSDL_JoystickGetSerial SDL_JoystickGetSerial;
            pSDL_JoystickRumbleTriggers SDL_JoystickRumbleTriggers;
            pSDL_JoystickHasLED SDL_JoystickHasLED;
            pSDL_JoystickSetLED SDL_JoystickSetLED;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2016) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickSendEffect = int function(SDL_Joystick* joystick, const(void)*data, int size);
        }
        __gshared {
            pSDL_JoystickSendEffect SDL_JoystickSendEffect;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2018) {
        extern(C) @nogc nothrow {
            alias pSDL_JoystickHasRumble = SDL_bool function(SDL_Joystick* joystick);
            alias pSDL_JoystickHasRumbleTriggers = SDL_bool function(SDL_Joystick* joystick);
        }
        __gshared {
            pSDL_JoystickHasRumble SDL_JoystickHasRumble;
            pSDL_JoystickHasRumbleTriggers SDL_JoystickHasRumbleTriggers;
        }
    }
}
