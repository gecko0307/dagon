
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlevents;

import bindbc.sdl.config;

import bindbc.sdl.bind.sdlgesture,
       bindbc.sdl.bind.sdljoystick,
       bindbc.sdl.bind.sdlkeyboard,
       bindbc.sdl.bind.sdlkeycode,
       bindbc.sdl.bind.sdlstdinc,
       bindbc.sdl.bind.sdlsyswm,
       bindbc.sdl.bind.sdltouch,
       bindbc.sdl.bind.sdlvideo;

enum {
    SDL_RELEASED = 0,
    SDL_PRESSED = 1,
}

static if(sdlSupport >= SDLSupport.sdl209) {
    enum SDL_EventType {
        SDL_FIRSTEVENT = 0,
        SDL_QUIT = 0x100,
        SDL_APP_TERMINATING,
        SDL_APP_LOWMEMORY,
        SDL_APP_WILLENTERBACKGROUND,
        SDL_APP_DIDENTERBACKGROUND,
        SDL_APP_WILLENTERFOREGROUND,
        SDL_APP_DIDENTERFOREGROUND,
        SDL_DISPLAYEVENT = 0x150,
        SDL_WINDOWEVENT = 0x200,
        SDL_SYSWMEVENT,
        SDL_KEYDOWN = 0x300,
        SDL_KEYUP,
        SDL_TEXTEDITING,
        SDL_TEXTINPUT,
        SDL_KEYMAPCHANGED,
        SDL_MOUSEMOTION = 0x400,
        SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP,
        SDL_MOUSEWHEEL,
        SDL_JOYAXISMOTION = 0x600,
        SDL_JOYBALLMOTION,
        SDL_JOYHATMOTION,
        SDL_JOYBUTTONDOWN,
        SDL_JOYBUTTONUP,
        SDL_JOYDEVICEADDED,
        SDL_JOYDEVICEREMOVED,
        SDL_CONTROLLERAXISMOTION = 0x650,
        SDL_CONTROLLERBUTTONDOWN,
        SDL_CONTROLLERBUTTONUP,
        SDL_CONTROLLERDEVICEADDED,
        SDL_CONTROLLERDEVICEREMOVED,
        SDL_CONTROLLERDEVICEREMAPPED,
        SDL_FINGERDOWN = 0x700,
        SDL_FINGERUP,
        SDL_FINGERMOTION,
        SDL_DOLLARGESTURE = 0x800,
        SDL_DOLLARRECORD,
        SDL_MULTIGESTURE,
        SDL_CLIPBOARDUPDATE = 0x900,
        SDL_DROPFILE = 0x1000,
        SDL_DROPTEXT,
        SDL_DROPBEGIN,
        SDL_DROPCOMPLETE,
        SDL_AUDIODEVICEADDED = 0x1100,
        SDL_AUDIODEVICEREMOVED,
        SDL_SENSORUPDATE = 0x1200,
        SDL_RENDER_TARGETS_RESET = 0x2000,
        SDL_RENDER_DEVICE_RESET,
        SDL_USEREVENT = 0x8000,
        SDL_LASTEVENT = 0xFFFF
    }
}
else static if(sdlSupport >= SDLSupport.sdl205) {
    enum SDL_EventType {
        SDL_FIRSTEVENT = 0,
        SDL_QUIT = 0x100,
        SDL_APP_TERMINATING,
        SDL_APP_LOWMEMORY,
        SDL_APP_WILLENTERBACKGROUND,
        SDL_APP_DIDENTERBACKGROUND,
        SDL_APP_WILLENTERFOREGROUND,
        SDL_APP_DIDENTERFOREGROUND,
        SDL_WINDOWEVENT = 0x200,
        SDL_SYSWMEVENT,
        SDL_KEYDOWN = 0x300,
        SDL_KEYUP,
        SDL_TEXTEDITING,
        SDL_TEXTINPUT,
        SDL_KEYMAPCHANGED,
        SDL_MOUSEMOTION = 0x400,
        SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP,
        SDL_MOUSEWHEEL,
        SDL_JOYAXISMOTION = 0x600,
        SDL_JOYBALLMOTION,
        SDL_JOYHATMOTION,
        SDL_JOYBUTTONDOWN,
        SDL_JOYBUTTONUP,
        SDL_JOYDEVICEADDED,
        SDL_JOYDEVICEREMOVED,
        SDL_CONTROLLERAXISMOTION = 0x650,
        SDL_CONTROLLERBUTTONDOWN,
        SDL_CONTROLLERBUTTONUP,
        SDL_CONTROLLERDEVICEADDED,
        SDL_CONTROLLERDEVICEREMOVED,
        SDL_CONTROLLERDEVICEREMAPPED,
        SDL_FINGERDOWN = 0x700,
        SDL_FINGERUP,
        SDL_FINGERMOTION,
        SDL_DOLLARGESTURE = 0x800,
        SDL_DOLLARRECORD,
        SDL_MULTIGESTURE,
        SDL_CLIPBOARDUPDATE = 0x900,
        SDL_DROPFILE = 0x1000,
        SDL_DROPTEXT,
        SDL_DROPBEGIN,
        SDL_DROPCOMPLETE,
        SDL_AUDIODEVICEADDED = 0x1100,
        SDL_AUDIODEVICEREMOVED,
        SDL_RENDER_TARGETS_RESET = 0x2000,
        SDL_RENDER_DEVICE_RESET,
        SDL_USEREVENT = 0x8000,
        SDL_LASTEVENT = 0xFFFF
    }
}
else static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_EventType {
        SDL_FIRSTEVENT = 0,
        SDL_QUIT = 0x100,
        SDL_APP_TERMINATING,
        SDL_APP_LOWMEMORY,
        SDL_APP_WILLENTERBACKGROUND,
        SDL_APP_DIDENTERBACKGROUND,
        SDL_APP_WILLENTERFOREGROUND,
        SDL_APP_DIDENTERFOREGROUND,
        SDL_WINDOWEVENT = 0x200,
        SDL_SYSWMEVENT,
        SDL_KEYDOWN = 0x300,
        SDL_KEYUP,
        SDL_TEXTEDITING,
        SDL_TEXTINPUT,
        SDL_KEYMAPCHANGED,
        SDL_MOUSEMOTION = 0x400,
        SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP,
        SDL_MOUSEWHEEL,
        SDL_JOYAXISMOTION = 0x600,
        SDL_JOYBALLMOTION,
        SDL_JOYHATMOTION,
        SDL_JOYBUTTONDOWN,
        SDL_JOYBUTTONUP,
        SDL_JOYDEVICEADDED,
        SDL_JOYDEVICEREMOVED,
        SDL_CONTROLLERAXISMOTION = 0x650,
        SDL_CONTROLLERBUTTONDOWN,
        SDL_CONTROLLERBUTTONUP,
        SDL_CONTROLLERDEVICEADDED,
        SDL_CONTROLLERDEVICEREMOVED,
        SDL_CONTROLLERDEVICEREMAPPED,
        SDL_FINGERDOWN = 0x700,
        SDL_FINGERUP,
        SDL_FINGERMOTION,
        SDL_DOLLARGESTURE = 0x800,
        SDL_DOLLARRECORD,
        SDL_MULTIGESTURE,
        SDL_CLIPBOARDUPDATE = 0x900,
        SDL_DROPFILE = 0x1000,
        SDL_AUDIODEVICEADDED = 0x1100,
        SDL_AUDIODEVICEREMOVED,
        SDL_RENDER_TARGETS_RESET = 0x2000,
        SDL_RENDER_DEVICE_RESET,
        SDL_USEREVENT = 0x8000,
        SDL_LASTEVENT = 0xFFFF
    }
}
else static if(sdlSupport >= SDLSupport.sdl201) {
    enum SDL_EventType {
        SDL_FIRSTEVENT = 0,
        SDL_QUIT = 0x100,
        SDL_APP_TERMINATING,
        SDL_APP_LOWMEMORY,
        SDL_APP_WILLENTERBACKGROUND,
        SDL_APP_DIDENTERBACKGROUND,
        SDL_APP_WILLENTERFOREGROUND,
        SDL_APP_DIDENTERFOREGROUND,
        SDL_WINDOWEVENT = 0x200,
        SDL_SYSWMEVENT,
        SDL_KEYDOWN = 0x300,
        SDL_KEYUP,
        SDL_TEXTEDITING,
        SDL_TEXTINPUT,
        SDL_MOUSEMOTION = 0x400,
        SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP,
        SDL_MOUSEWHEEL,
        SDL_JOYAXISMOTION = 0x600,
        SDL_JOYBALLMOTION,
        SDL_JOYHATMOTION,
        SDL_JOYBUTTONDOWN,
        SDL_JOYBUTTONUP,
        SDL_JOYDEVICEADDED,
        SDL_JOYDEVICEREMOVED,
        SDL_CONTROLLERAXISMOTION = 0x650,
        SDL_CONTROLLERBUTTONDOWN,
        SDL_CONTROLLERBUTTONUP,
        SDL_CONTROLLERDEVICEADDED,
        SDL_CONTROLLERDEVICEREMOVED,
        SDL_CONTROLLERDEVICEREMAPPED,
        SDL_FINGERDOWN = 0x700,
        SDL_FINGERUP,
        SDL_FINGERMOTION,
        SDL_DOLLARGESTURE = 0x800,
        SDL_DOLLARRECORD,
        SDL_MULTIGESTURE,
        SDL_CLIPBOARDUPDATE = 0x900,
        SDL_DROPFILE = 0x1000,
        SDL_RENDER_TARGETS_RESET = 0x2000,
        SDL_USEREVENT = 0x8000,
        SDL_LASTEVENT = 0xFFFF
    }
}
else {
    enum SDL_EventType {
        SDL_FIRSTEVENT = 0,
        SDL_QUIT = 0x100,
        SDL_APP_TERMINATING,
        SDL_APP_LOWMEMORY,
        SDL_APP_WILLENTERBACKGROUND,
        SDL_APP_DIDENTERBACKGROUND,
        SDL_APP_WILLENTERFOREGROUND,
        SDL_APP_DIDENTERFOREGROUND,
        SDL_WINDOWEVENT = 0x200,
        SDL_SYSWMEVENT,
        SDL_KEYDOWN = 0x300,
        SDL_KEYUP,
        SDL_TEXTEDITING,
        SDL_TEXTINPUT,
        SDL_MOUSEMOTION = 0x400,
        SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP,
        SDL_MOUSEWHEEL,
        SDL_JOYAXISMOTION = 0x600,
        SDL_JOYBALLMOTION,
        SDL_JOYHATMOTION,
        SDL_JOYBUTTONDOWN,
        SDL_JOYBUTTONUP,
        SDL_JOYDEVICEADDED,
        SDL_JOYDEVICEREMOVED,
        SDL_CONTROLLERAXISMOTION = 0x650,
        SDL_CONTROLLERBUTTONDOWN,
        SDL_CONTROLLERBUTTONUP,
        SDL_CONTROLLERDEVICEADDED,
        SDL_CONTROLLERDEVICEREMOVED,
        SDL_CONTROLLERDEVICEREMAPPED,
        SDL_FINGERDOWN = 0x700,
        SDL_FINGERUP,
        SDL_FINGERMOTION,
        SDL_DOLLARGESTURE = 0x800,
        SDL_DOLLARRECORD,
        SDL_MULTIGESTURE,
        SDL_CLIPBOARDUPDATE = 0x900,
        SDL_DROPFILE = 0x1000,
        SDL_USEREVENT = 0x8000,
        SDL_LASTEVENT = 0xFFFF
    }
}
mixin(expandEnum!SDL_EventType);

struct SDL_CommonEvent {
    SDL_EventType type;
    uint timestamp;
}

static if(sdlSupport >= SDLSupport.sdl209) {
    struct SDL_DisplayEvent {
        SDL_EventType type;
        uint timestamp;
        uint display;
        ubyte event;
        ubyte padding1;
        ubyte padding2;
        ubyte padding3;
        int data1;
    }
}

struct SDL_WindowEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    SDL_WindowEventID event;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    int data1;
    int data2;
}

struct SDL_KeyboardEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    ubyte state;
    ubyte repeat;
    ubyte padding2;
    ubyte padding3;
    SDL_Keysym keysym;
}

enum SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32;
struct SDL_TextEditingEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    char[SDL_TEXTEDITINGEVENT_TEXT_SIZE] text;
    int start;
    int length;
}

enum SDL_TEXTINPUTEVENT_TEXT_SIZE = 32;
struct SDL_TextInputEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    char[SDL_TEXTINPUTEVENT_TEXT_SIZE] text;
}

struct SDL_MouseMotionEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    uint which;
    uint state;
    int x;
    int y;
    int xrel;
    int yrel;
}

struct SDL_MouseButtonEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    uint which;
    ubyte button;
    ubyte state;
    static if(sdlSupport == SDLSupport.sdl200) {
        ubyte padding1;
        ubyte padding2;
    }
    else {
        ubyte clicks;
        ubyte padding1;
    }
    int x;
    int y;
}

struct SDL_MouseWheelEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    uint which;
    int x;
    int y;
    static if(sdlSupport >= SDLSupport.sdl204) {
        uint direction;
    }
}

struct SDL_JoyAxisEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte axis;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;
    ushort padding4;
}

struct SDL_JoyBallEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte ball;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short xrel;
    short yrel;
}

struct SDL_JoyHatEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte hat;
    ubyte value;
    ubyte padding1;
    ubyte padding2;
}

struct SDL_JoyButtonEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte button;
    ubyte state;
    ubyte padding1;
    ubyte padding2;
}

struct SDL_JoyDeviceEvent {
    SDL_EventType type;
    uint timestamp;
    int which;
}

struct SDL_ControllerAxisEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte axis;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;
    ushort padding4;
}

struct SDL_ControllerButtonEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_JoystickID which;
    ubyte button;
    ubyte state;
    ubyte padding1;
    ubyte padding2;
}

struct SDL_ControllerDeviceEvent {
    SDL_EventType type;
    uint timestamp;
    int which;
}

static if(sdlSupport >= SDLSupport.sdl204) {
    struct SDL_AudioDeviceEvent {
        uint type;
        uint timestamp;
        uint which;
        ubyte iscapture;
        ubyte padding1;
        ubyte padding2;
        ubyte padding3;
    }
}

struct SDL_TouchFingerEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_TouchID touchId;
    SDL_FingerID fingerId;
    float x;
    float y;
    float dx;
    float dy;
    float pressure;

    static if(sdlSupport >= SDLSupport.sdl2012) {
        uint windowID;
    }
}

struct SDL_MultiGestureEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_TouchID touchId;
    float dTheta;
    float dDist;
    float x;
    float y;
    ushort numFingers;
    ushort padding;
}

struct SDL_DollarGestureEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_TouchID touchId;
    SDL_GestureID gestureId;
    uint numFingers;
    float error;
    float x;
    float y;
}

struct SDL_DropEvent {
    SDL_EventType type;
    uint timestamp;
    char* file;
    static if(sdlSupport >= SDLSupport.sdl205) {
        uint windowID;
    }
}

struct SDL_SensorEvent {
    SDL_EventType type;
    uint timestamp;
    int which;
    float[6] data;
}

struct SDL_QuitEvent {
    SDL_EventType type;
    uint timestamp;
}

struct SDL_OSEvent {
    SDL_EventType type;
    uint timestamp;
}

struct SDL_UserEvent {
    SDL_EventType type;
    uint timestamp;
    uint windowID;
    int code;
    void* data1;
    void* data2;
}

struct SDL_SysWMEvent {
    SDL_EventType type;
    uint timestamp;
    SDL_SysWMmsg* msg;
}

union SDL_Event {
    SDL_EventType type;
    SDL_CommonEvent common;
    static if(sdlSupport >= SDLSupport.sdl209) {
        SDL_DisplayEvent display;
    }
    SDL_WindowEvent window;
    SDL_KeyboardEvent key;
    SDL_TextEditingEvent edit;
    SDL_TextInputEvent text;
    SDL_MouseMotionEvent motion;
    SDL_MouseButtonEvent button;
    SDL_MouseWheelEvent wheel;
    SDL_JoyAxisEvent jaxis;
    SDL_JoyBallEvent jball;
    SDL_JoyHatEvent jhat;
    SDL_JoyButtonEvent jbutton;
    SDL_JoyDeviceEvent jdevice;
    SDL_ControllerAxisEvent caxis;
    SDL_ControllerButtonEvent cbutton;
    SDL_ControllerDeviceEvent cdevice;
    static if(sdlSupport >= SDLSupport.sdl204) {
        SDL_AudioDeviceEvent adevice;
    }
    static if(sdlSupport >= SDLSupport.sdl209) {
        SDL_SensorEvent sensor;
    }
    SDL_QuitEvent quit;
    SDL_UserEvent user;
    SDL_SysWMEvent syswm;
    SDL_TouchFingerEvent tfinger;
    SDL_MultiGestureEvent mgesture;
    SDL_DollarGestureEvent dgesture;
    SDL_DropEvent drop;

    ubyte[56] padding;
}

enum SDL_eventaction {
    SDL_ADDEVENT,
    SDL_PEEKEVENT,
    SDL_GETEVENT
}
alias SDL_EventAction = SDL_eventaction;
mixin(expandEnum!SDL_EventAction);

extern(C) nothrow alias SDL_EventFilter = int function(void* userdata, SDL_Event* event);

enum {
    SDL_QUERY = -1,
    SDL_IGNORE = 0,
    SDL_DISABLE = 0,
    SDL_ENABLE = 1,
}

@nogc nothrow {
    int SDL_GetEventState(SDL_EventType type) {
        pragma(inline, true);
        return SDL_EventState(type, SDL_QUERY);
    }

    // This is implemented in SDL_quit.h, but works better here.
    bool SDL_QuitRequested() {
        pragma(inline, true);
        SDL_PumpEvents();
        return SDL_PeepEvents(null,0,SDL_PEEKEVENT,SDL_QUIT,SDL_QUIT) > 0;
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        void SDL_PumpEvents();
        int SDL_PeepEvents(SDL_Event*,int,SDL_eventaction,uint,uint);
        SDL_bool SDL_HasEvent(uint);
        SDL_bool SDL_HasEvents(uint,uint);
        void SDL_FlushEvent(uint);
        void SDL_FlushEvents(uint,uint);
        int SDL_PollEvent(SDL_Event*);
        int SDL_WaitEvent(SDL_Event*);
        int SDL_WaitEventTimeout(SDL_Event*,int);
        int SDL_PushEvent(SDL_Event*);
        void SDL_SetEventFilter(SDL_EventFilter,void*);
        SDL_bool SDL_GetEventFilter(SDL_EventFilter*,void**);
        void SDL_AddEventWatch(SDL_EventFilter,void*);
        void SDL_DelEventWatch(SDL_EventFilter,void*);
        void SDL_FilterEvents(SDL_EventFilter,void*);
        ubyte SDL_EventState(uint,int);
        uint SDL_RegisterEvents(int);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_PumpEvents = void function();
        alias pSDL_PeepEvents = int function(SDL_Event*,int,SDL_eventaction,uint,uint);
        alias pSDL_HasEvent = SDL_bool function(uint);
        alias pSDL_HasEvents = SDL_bool function(uint,uint);
        alias pSDL_FlushEvent = void function(uint);
        alias pSDL_FlushEvents = void function(uint,uint);
        alias pSDL_PollEvent = int function(SDL_Event*);
        alias pSDL_WaitEvent = int function(SDL_Event*);
        alias pSDL_WaitEventTimeout = int function(SDL_Event*,int);
        alias pSDL_PushEvent = int function(SDL_Event*);
        alias pSDL_SetEventFilter = void function(SDL_EventFilter,void*);
        alias pSDL_GetEventFilter = SDL_bool function(SDL_EventFilter*,void**);
        alias pSDL_AddEventWatch = void function(SDL_EventFilter,void*);
        alias pSDL_DelEventWatch = void function(SDL_EventFilter,void*);
        alias pSDL_FilterEvents = void function(SDL_EventFilter,void*);
        alias pSDL_EventState = ubyte function(uint,int);
        alias pSDL_RegisterEvents = uint function(int);
    }

    __gshared {
        pSDL_PumpEvents SDL_PumpEvents;
        pSDL_PeepEvents SDL_PeepEvents;
        pSDL_HasEvent SDL_HasEvent;
        pSDL_HasEvents SDL_HasEvents;
        pSDL_FlushEvent SDL_FlushEvent;
        pSDL_FlushEvents SDL_FlushEvents;
        pSDL_PollEvent SDL_PollEvent;
        pSDL_WaitEvent SDL_WaitEvent;
        pSDL_WaitEventTimeout SDL_WaitEventTimeout;
        pSDL_PushEvent SDL_PushEvent;
        pSDL_SetEventFilter SDL_SetEventFilter;
        pSDL_GetEventFilter SDL_GetEventFilter;
        pSDL_AddEventWatch SDL_AddEventWatch;
        pSDL_DelEventWatch SDL_DelEventWatch;
        pSDL_FilterEvents SDL_FilterEvents;
        pSDL_EventState SDL_EventState;
        pSDL_RegisterEvents SDL_RegisterEvents;
    }
}