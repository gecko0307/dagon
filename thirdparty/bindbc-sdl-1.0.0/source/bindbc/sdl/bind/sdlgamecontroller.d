
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlgamecontroller;

import bindbc.sdl.config;

import bindbc.sdl.bind.sdljoystick,
       bindbc.sdl.bind.sdlrwops,
       bindbc.sdl.bind.sdlsensor;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

struct SDL_GameController;

static if(sdlSupport >= SDLSupport.sdl2014) {
    enum SDL_GameControllerType {
        SDL_CONTROLLER_TYPE_UNKNOWN = 0,
        SDL_CONTROLLER_TYPE_XBOX360,
        SDL_CONTROLLER_TYPE_XBOXONE,
        SDL_CONTROLLER_TYPE_PS3,
        SDL_CONTROLLER_TYPE_PS4,
        SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
        SDL_CONTROLLER_TYPE_VIRTUAL,
        SDL_CONTROLLER_TYPE_PS5
    }
    mixin(expandEnum!SDL_GameControllerType);
}
else static if(sdlSupport >= SDLSupport.sdl2012) {
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

static if(sdlSupport >= SDLSupport.sdl2014) {
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
        SDL_CONTROLLER_BUTTON_MISC1,
        SDL_CONTROLLER_BUTTON_PADDLE1,
        SDL_CONTROLLER_BUTTON_PADDLE2,
        SDL_CONTROLLER_BUTTON_PADDLE3,
        SDL_CONTROLLER_BUTTON_PADDLE4,
        SDL_CONTROLLER_BUTTON_TOUCHPAD,
        SDL_CONTROLLER_BUTTON_MAX,
    }
}
else {
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
        SDL_CONTROLLER_BUTTON_MAX,
    }
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
        int SDL_GameControllerAddMapping(const(char)* mappingString);
        char* SDL_GameControllerMappingForGUID(SDL_JoystickGUID guid);
        char* SDL_GameControllerMapping(SDL_GameController* gamecontroller);
        SDL_bool SDL_IsGameController(int joystick_index);
        const(char)* SDL_GameControllerNameForIndex(int joystick_index);
        SDL_GameController* SDL_GameControllerOpen(int joystick_index);
        const(char)* SDL_GameControllerName(SDL_GameController* gamecontroller);
        SDL_bool SDL_GameControllerGetAttached(SDL_GameController* gamecontroller);
        SDL_Joystick* SDL_GameControllerGetJoystick(SDL_GameController* gamecontroller);
        int SDL_GameControllerEventState(int state);
        void SDL_GameControllerUpdate();
        SDL_GameControllerAxis SDL_GameControllerGetAxisFromString(const(char)* pchString);
        const(char)* SDL_GameControllerGetStringForAxis(SDL_GameControllerAxis axis);
        SDL_GameControllerButtonBind SDL_GameControllerGetBindForAxis(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
        short SDL_GameControllerGetAxis(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
        SDL_GameControllerButton SDL_GameControllerGetButtonFromString(const(char*) pchString);
        const(char)* SDL_GameControllerGetStringForButton(SDL_GameControllerButton button);
        SDL_GameControllerButtonBind SDL_GameControllerGetBindForButton(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
        ubyte SDL_GameControllerGetButton(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
        void SDL_GameControllerClose(SDL_GameController* gamecontroller);

        static if(sdlSupport >= SDLSupport.sdl202) {
            int SDL_GameControllerAddMappingsFromRW(SDL_RWops* rw, int freerw);
        }
        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_GameController* SDL_GameControllerFromInstanceID(SDL_JoystickID joyid);
        }
        static if(sdlSupport >= SDLSupport.sdl206) {
            ushort SDL_GameControllerGetProduct(SDL_GameController* gamecontroller);
            ushort SDL_GameControllerGetProductVersion(SDL_GameController* gamecontroller);
            ushort SDL_GameControllerGetVendor(SDL_GameController* gamecontroller);
            char* SDL_GameControllerMappingForIndex(int mapping_index);
            int SDL_GameControllerNumMappings();
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            char* SDL_GameControllerMappingForDeviceIndex(int joystick_index);
            int SDL_GameControllerRumble(SDL_GameController* gamecontroller, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms);
        }
        static if(sdlSupport >= SDLSupport.sdl2010) {
            int SDL_GameControllerGetPlayerIndex(SDL_GameController* gamecontroller);
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            SDL_GameControllerType SDL_GameControllerTypeForIndex(int joystick_index);
            SDL_GameController* SDL_GameControllerFromPlayerIndex(int player_index);
            SDL_GameControllerType SDL_GameControllerGetType(SDL_GameController* gamecontroller);
            void SDL_GameControllerSetPlayerIndex(SDL_GameController* gamecontroller, int player_index);
        }
        static if(sdlSupport >= SDLSupport.sdl2014) {
            SDL_bool SDL_GameControllerHasAxis(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
            SDL_bool SDL_GameControllerHasButton(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
            int SDL_GameControllerGetNumTouchpads(SDL_GameController* gamecontroller);
            int SDL_GameControllerGetNumTouchpadFingers (SDL_GameController* gamecontroller, int touchpad);
            int SDL_GameControllerGetTouchpadFinger(SDL_GameController* gamecontroller, int touchpad, int finger, ubyte* state, float* x, float* y, float* pressure);
            SDL_bool SDL_GameControllerHasSensor(SDL_GameController* gamecontroller, SDL_SensorType type);
            int SDL_GameControllerSetSensorEnabled(SDL_GameController* gamecontroller, SDL_SensorType type, SDL_bool enabled);
            SDL_bool SDL_GameControllerIsSensorEnabled(SDL_GameController* gamecontroller, SDL_SensorType type);
            int SDL_GameControllerGetSensorData(SDL_GameController* gamecontroller, SDL_SensorType type, float* data, int num_values);
            int SDL_GameControllerRumbleTriggers(SDL_GameController* gamecontroller, ushort left_rumble, ushort right_rumble, uint duration_ms);
            SDL_bool SDL_GameControllerHasLED(SDL_GameController* gamecontroller);
            int SDL_GameControllerSetLED(SDL_GameController* gamecontroller, ubyte red, ubyte green, ubyte blue);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GameControllerAddMapping = int function(const(char)* mappingString);
        alias pSDL_GameControllerMappingForGUID = char* function(SDL_JoystickGUID guid);
        alias pSDL_GameControllerMapping = char* function(SDL_GameController* gamecontroller);
        alias pSDL_IsGameController = SDL_bool function(int joystick_index);
        alias pSDL_GameControllerNameForIndex = const(char)* function(int joystick_index);
        alias pSDL_GameControllerOpen = SDL_GameController* function(int joystick_index);
        alias pSDL_GameControllerName = const(char)* function(SDL_GameController* gamecontroller);
        alias pSDL_GameControllerGetAttached = SDL_bool function(SDL_GameController* gamecontroller);
        alias pSDL_GameControllerGetJoystick = SDL_Joystick* function(SDL_GameController* gamecontroller);
        alias pSDL_GameControllerEventState = int function(int state);
        alias pSDL_GameControllerUpdate = void function();
        alias pSDL_GameControllerGetAxisFromString = SDL_GameControllerAxis function(const(char)* pchString);
        alias pSDL_GameControllerGetStringForAxis = const(char)* function(SDL_GameControllerAxis axis);
        alias pSDL_GameControllerGetBindForAxis = SDL_GameControllerButtonBind function(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
        alias pSDL_GameControllerGetAxis = short function(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
        alias pSDL_GameControllerGetButtonFromString = SDL_GameControllerButton function(const(char*) pchString);
        alias pSDL_GameControllerGetStringForButton = const(char)* function(SDL_GameControllerButton button);
        alias pSDL_GameControllerGetBindForButton = SDL_GameControllerButtonBind function(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
        alias pSDL_GameControllerGetButton = ubyte function(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
        alias pSDL_GameControllerClose = void function(SDL_GameController* gamecontroller);
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
            alias pSDL_GameControllerAddMappingsFromRW = int function(SDL_RWops* rw, int freerw);
        }

        __gshared {
            pSDL_GameControllerAddMappingsFromRW SDL_GameControllerAddMappingsFromRW;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerFromInstanceID = SDL_GameController* function(SDL_JoystickID joyid);
        }

        __gshared {
            pSDL_GameControllerFromInstanceID SDL_GameControllerFromInstanceID;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerGetProduct = ushort function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerGetProductVersion = ushort function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerGetVendor = ushort function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerMappingForIndex = char* function(int mapping_index);
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
            alias pSDL_GameControllerMappingForDeviceIndex = char* function(int joystick_index);
            alias pSDL_GameControllerRumble = int function(SDL_GameController* gamecontroller, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms);
        }

        __gshared {
            pSDL_GameControllerMappingForDeviceIndex SDL_GameControllerMappingForDeviceIndex;
            pSDL_GameControllerRumble SDL_GameControllerRumble;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerGetPlayerIndex = int function(SDL_GameController* gamecontroller);
        }
        __gshared {
            pSDL_GameControllerGetPlayerIndex SDL_GameControllerGetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2012) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerTypeForIndex = SDL_GameControllerType function(int joystick_index);
            alias pSDL_GameControllerFromPlayerIndex = SDL_GameController* function(int player_index);
            alias pSDL_GameControllerGetType = SDL_GameControllerType function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerSetPlayerIndex = void function(SDL_GameController* gamecontroller, int player_index);

        }
        __gshared {
            pSDL_GameControllerTypeForIndex SDL_GameControllerTypeForIndex;
            pSDL_GameControllerFromPlayerIndex SDL_GameControllerFromPlayerIndex;
            pSDL_GameControllerGetType SDL_GameControllerGetType;
            pSDL_GameControllerSetPlayerIndex SDL_GameControllerSetPlayerIndex;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2014) {
        extern(C) @nogc nothrow {
            alias pSDL_GameControllerHasAxis = SDL_bool function(SDL_GameController* gamecontroller, SDL_GameControllerAxis axis);
            alias pSDL_GameControllerHasButton = SDL_bool function(SDL_GameController* gamecontroller, SDL_GameControllerButton button);
            alias pSDL_GameControllerGetNumTouchpads = int function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerGetNumTouchpadFingers = int function(SDL_GameController* gamecontroller, int touchpad);
            alias pSDL_GameControllerGetTouchpadFinger = int function(SDL_GameController* gamecontroller, int touchpad, int finger, ubyte* state, float* x, float* y, float* pressure);
            alias pSDL_GameControllerHasSensor = SDL_bool function(SDL_GameController* gamecontroller, SDL_SensorType type);
            alias pSDL_GameControllerSetSensorEnabled = int function(SDL_GameController* gamecontroller, SDL_SensorType type, SDL_bool enabled);
            alias pSDL_GameControllerIsSensorEnabled = SDL_bool function(SDL_GameController* gamecontroller, SDL_SensorType type);
            alias pSDL_GameControllerGetSensorData = int function(SDL_GameController* gamecontroller, SDL_SensorType type, float* data, int num_values);
            alias pSDL_GameControllerRumbleTriggers = int function(SDL_GameController* gamecontroller, ushort left_rumble, ushort right_rumble, uint duration_ms);
            alias pSDL_GameControllerHasLED = SDL_bool function(SDL_GameController* gamecontroller);
            alias pSDL_GameControllerSetLED = int function(SDL_GameController* gamecontroller, ubyte red, ubyte green, ubyte blue);
        }
        __gshared {
            pSDL_GameControllerHasAxis SDL_GameControllerHasAxis;
            pSDL_GameControllerHasButton SDL_GameControllerHasButton;
            pSDL_GameControllerGetNumTouchpads SDL_GameControllerGetNumTouchpads;
            pSDL_GameControllerGetNumTouchpadFingers SDL_GameControllerGetNumTouchpadFingers;
            pSDL_GameControllerGetTouchpadFinger SDL_GameControllerGetTouchpadFinger;
            pSDL_GameControllerHasSensor SDL_GameControllerHasSensor;
            pSDL_GameControllerSetSensorEnabled SDL_GameControllerSetSensorEnabled;
            pSDL_GameControllerIsSensorEnabled SDL_GameControllerIsSensorEnabled;
            pSDL_GameControllerGetSensorData SDL_GameControllerGetSensorData;
            pSDL_GameControllerRumbleTriggers SDL_GameControllerRumbleTriggers;
            pSDL_GameControllerHasLED SDL_GameControllerHasLED;
            pSDL_GameControllerSetLED SDL_GameControllerSetLED;
        }
    }
}