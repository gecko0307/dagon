
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlgamecontroller;

import bindbc.sdl.config;

import bindbc.sdl.bind.sdljoystick,
       bindbc.sdl.bind.sdlrwops;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

struct SDL_GameController;

static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_GameControllerType {
        SDL_CONTROLLER_TYPE_UNKNOWN = 0,
        SDL_CONTROLLER_TYPE_XBOX360,
        SDL_CONTROLLER_TYPE_XBOXONE,
        SDL_CONTROLLER_TYPE_PS3,
        SDL_CONTROLLER_TYPE_PS4,
        SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
    }
    mixin(expandEnum!SDL_GameControllerType);
}

enum SDL_GameControllerBindType {
    SDL_CONTROLLER_BINDTYPE_NONE = 0,
    SDL_CONTROLLER_BINDTYPE_BUTTON,
    SDL_CONTROLLER_BINDTYPE_AXIS,
    SDL_CONTROLLER_BINDTYPE_HAT,
}
mixin(expandEnum!SDL_GameControllerBindType);

struct SDL_GameControllerButtonBind {
    SDL_GameControllerBindType bindType;
    union value {
        int button;
        int axis;
        struct hat {
            int hat;
            int hat_mask;
        }
    }
    alias button = value.button;
    alias axis = value.axis;
    alias hat = value.hat;
}

enum SDL_GameControllerAxis {
    SDL_CONTROLLER_AXIS_INVALID = -1,
    SDL_CONTROLLER_AXIS_LEFTX,
    SDL_CONTROLLER_AXIS_LEFTY,
    SDL_CONTROLLER_AXIS_RIGHTX,
    SDL_CONTROLLER_AXIS_RIGHTY,
    SDL_CONTROLLER_AXIS_TRIGGERLEFT,
    SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
    SDL_CONTROLLER_AXIS_MAX
}
mixin(expandEnum!SDL_GameControllerAxis);

enum SDL_GameControllerButton {
    SDL_CONTROLLER_BUTTON_INVALID = -1,
    SDL_CONTROLLER_BUTTON_A,
    SDL_CONTROLLER_BUTTON_B,
    SDL_CONTROLLER_BUTTON_X,
    SDL_CONTROLLER_BUTTON_Y,
    SDL_CONTROLLER_BUTTON_BACK,
    SDL_CONTROLLER_BUTTON_GUIDE,
    SDL_CONTROLLER_BUTTON_START,
    SDL_CONTROLLER_BUTTON_LEFTSTICK,
    SDL_CONTROLLER_BUTTON_RIGHTSTICK,
    SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
    SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
    SDL_CONTROLLER_BUTTON_DPAD_UP,
    SDL_CONTROLLER_BUTTON_DPAD_DOWN,
    SDL_CONTROLLER_BUTTON_DPAD_LEFT,
    SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
    SDL_CONTROLLER_BUTTON_MAX
}
mixin(expandEnum!SDL_GameControllerButton);

static if(sdlSupport >= SDLSupport.sdl202) {
    @nogc nothrow
    int SDL_GameControllerAddMappingsFromFile(const(char)* file) {
        pragma(inline, true);
        return SDL_GameControllerAddMappingsFromRW(SDL_RWFromFile(file,"rb"),1);
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_GameControllerAddMapping(const(char)*);
        char* SDL_GameControllerMappingForGUID(SDL_JoystickGUID);
        char* SDL_GameControllerMapping(SDL_GameController*);
        SDL_bool SDL_IsGameController(int);
        const(char)* SDL_GameControllerNameForIndex(int);
        SDL_GameController* SDL_GameControllerOpen(int);
        const(char)* SDL_GameControllerName(SDL_GameController*);
        SDL_bool SDL_GameControllerGetAttached(SDL_GameController*);
        SDL_Joystick* SDL_GameControllerGetJoystick(SDL_GameController*);
        int SDL_GameControllerEventState(int);
        void SDL_GameControllerUpdate();
        SDL_GameControllerAxis SDL_GameControllerGetAxisFromString(const(char)*);
        const(char)* SDL_GameControllerGetStringForAxis(SDL_GameControllerAxis);
        SDL_GameControllerButtonBind SDL_GameControllerGetBindForAxis(SDL_GameController*,SDL_GameControllerAxis);
        short SDL_GameControllerGetAxis(SDL_GameController*,SDL_GameControllerAxis);
        SDL_GameControllerButton SDL_GameControllerGetButtonFromString(const(char*));
        const(char)* SDL_GameControllerGetStringForButton(SDL_GameControllerButton);
        SDL_GameControllerButtonBind SDL_GameControllerGetBindForButton(SDL_GameController*,SDL_GameControllerButton);
        ubyte SDL_GameControllerGetButton(SDL_GameController*,SDL_GameControllerButton);
        void SDL_GameControllerClose(SDL_GameController*);

        static if(sdlSupport >= SDLSupport.sdl202) {
            int SDL_GameControllerAddMappingsFromRW(SDL_RWops*,int);
        }
        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_GameController* SDL_GameControllerFromInstanceID(SDL_JoystickID);
        }
        static if(sdlSupport >= SDLSupport.sdl206) {
            ushort SDL_GameControllerGetProduct(SDL_GameController*);
            ushort SDL_GameControllerGetProductVersion(SDL_GameController*);
            ushort SDL_GameControllerGetVendor(SDL_GameController*);
            char* SDL_GameControllerMappingForIndex(int);
            int SDL_GameControllerNumMappings();
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            char* SDL_GameControllerMappingForDeviceIndex(int);
            int SDL_GameControllerRumble(SDL_GameController*,ushort,ushort,uint);
        }
        static if(sdlSupport >= SDLSupport.sdl2010) {
            int SDL_GameControllerGetPlayerIndex(SDL_GameController*);
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            SDL_GameControllerType SDL_GameControllerTypeForIndex(int);
            SDL_GameController* SDL_GameControllerFromPlayerIndex(int);
            SDL_GameControllerType SDL_GameControllerGetType(SDL_GameController*);
            void SDL_GameControllerSetPlayerIndex(SDL_GameController*,int);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GameControllerAddMapping = int function(const(char)*);
        alias pSDL_GameControllerMappingForGUID = char* function(SDL_JoystickGUID);
        alias pSDL_GameControllerMapping = char* function(SDL_GameController*);
        alias pSDL_IsGameController = SDL_bool function(int);
        alias pSDL_GameControllerNameForIndex = const(char)* function(int);
        alias pSDL_GameControllerOpen = SDL_GameController* function(int);
        alias pSDL_GameControllerName = const(char)* function(SDL_GameController*);
        alias pSDL_GameControllerGetAttached = SDL_bool function(SDL_GameController*);
        alias pSDL_GameControllerGetJoystick = SDL_Joystick* function(SDL_GameController*);
        alias pSDL_GameControllerEventState = int function(int);
        alias pSDL_GameControllerUpdate = void function();
        alias pSDL_GameControllerGetAxisFromString = SDL_GameControllerAxis function(const(char)*);
        alias pSDL_GameControllerGetStringForAxis = const(char)* function(SDL_GameControllerAxis);
        alias pSDL_GameControllerGetBindForAxis = SDL_GameControllerButtonBind function(SDL_GameController*,SDL_GameControllerAxis);
        alias pSDL_GameControllerGetAxis = short function(SDL_GameController*,SDL_GameControllerAxis);
        alias pSDL_GameControllerGetButtonFromString = SDL_GameControllerButton function(const(char*));
        alias pSDL_GameControllerGetStringForButton = const(char)* function(SDL_GameControllerButton);
        alias pSDL_GameControllerGetBindForButton = SDL_GameControllerButtonBind function(SDL_GameController*,SDL_GameControllerButton);
        alias pSDL_GameControllerGetButton = ubyte function(SDL_GameController*,SDL_GameControllerButton);
        alias pSDL_GameControllerClose = void function(SDL_GameController*);
    }
    __gshared {
        pSDL_GameControllerAddMapping SDL_GameControllerAddMapping;
        pSDL_GameControllerMappingForGUID SDL_GameControllerMappingForGUID;
        pSDL_GameControllerMapping SDL_GameControllerMapping;
        pSDL_IsGameController SDL_IsGameController;
        pSDL_GameControllerNameForIndex SDL_GameControllerNameForIndex;
        pSDL_GameControllerOpen SDL_GameControllerOpen;
        pSDL_GameControllerName SDL_GameControllerName;
        pSDL_GameControllerGetAttached SDL_GameControllerGetAttached;
        pSDL_GameControllerGetJoystick SDL_GameControllerGetJoystick;
        pSDL_GameControllerEventState SDL_GameControllerEventState;
        pSDL_GameControllerUpdate SDL_GameControllerUpdate;
        pSDL_GameControllerGetAxisFromString SDL_GameControllerGetAxisFromString;
        pSDL_GameControllerGetStringForAxis SDL_GameControllerGetStringForAxis;
        pSDL_GameControllerGetBindForAxis SDL_GameControllerGetBindForAxis;
        pSDL_GameControllerGetAxis SDL_GameControllerGetAxis;
        pSDL_GameControllerGetButtonFromString SDL_GameControllerGetButtonFromString;
        pSDL_GameControllerGetStringForButton SDL_GameControllerGetStringForButton;
        pSDL_GameControllerGetBindForButton SDL_GameControllerGetBindForButton;
        pSDL_GameControllerGetButton SDL_GameControllerGetButton;
        pSDL_GameControllerClose SDL_GameControllerClose;
    }
    static if(sdlSupport >= SDLSupport.sdl202) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerAddMappingsFromRW = int function(SDL_RWops*,int);
        }

        __gshared {
            pSDL_GameControllerAddMappingsFromRW SDL_GameControllerAddMappingsFromRW;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerFromInstanceID = SDL_GameController* function(SDL_JoystickID);
        }

        __gshared {
            pSDL_GameControllerFromInstanceID SDL_GameControllerFromInstanceID;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerGetProduct = ushort function(SDL_GameController*);
            alias pSDL_GameControllerGetProductVersion = ushort function(SDL_GameController*);
            alias pSDL_GameControllerGetVendor = ushort function(SDL_GameController*);
            alias pSDL_GameControllerMappingForIndex = char* function(int);
            alias pSDL_GameControllerNumMappings = int function();
        }

        __gshared {
            pSDL_GameControllerGetProduct SDL_GameControllerGetProduct;
            pSDL_GameControllerGetProductVersion SDL_GameControllerGetProductVersion;
            pSDL_GameControllerGetVendor SDL_GameControllerGetVendor;
            pSDL_GameControllerMappingForIndex SDL_GameControllerMappingForIndex;
            pSDL_GameControllerNumMappings SDL_GameControllerNumMappings;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerMappingForDeviceIndex = char* function(int);
            alias pSDL_GameControllerRumble = int function(SDL_GameController*,ushort,ushort,uint);
        }

        __gshared {
            pSDL_GameControllerMappingForDeviceIndex SDL_GameControllerMappingForDeviceIndex;
            pSDL_GameControllerRumble SDL_GameControllerRumble;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerGetPlayerIndex = int function(SDL_GameController*);
        }
        __gshared {
            pSDL_GameControllerGetPlayerIndex SDL_GameControllerGetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2012) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerTypeForIndex = SDL_GameControllerType function(int);
            alias pSDL_GameControllerFromPlayerIndex = SDL_GameController* function(int);
            alias pSDL_GameControllerGetType = SDL_GameControllerType function(SDL_GameController*);
            alias pSDL_GameControllerSetPlayerIndex = void function(SDL_GameController*,int);

        }
        __gshared {
            pSDL_GameControllerTypeForIndex SDL_GameControllerTypeForIndex;
            pSDL_GameControllerFromPlayerIndex SDL_GameControllerFromPlayerIndex;
            pSDL_GameControllerGetType SDL_GameControllerGetType;
            pSDL_GameControllerSetPlayerIndex SDL_GameControllerSetPlayerIndex;
        }
    }
}