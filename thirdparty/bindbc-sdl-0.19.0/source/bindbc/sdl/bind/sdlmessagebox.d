
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmessagebox;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_MessageBoxFlags {
        SDL_MESSAGEBOX_ERROR = 0x00000010,
        SDL_MESSAGEBOX_WARNING = 0x00000020,
        SDL_MESSAGEBOX_INFORMATION = 0x00000040,
        SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT = 0x00000080,
        SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT = 0x00000100,
    }
}
else {
    enum SDL_MessageBoxFlags {
        SDL_MESSAGEBOX_ERROR = 0x00000010,
        SDL_MESSAGEBOX_WARNING = 0x00000020,
        SDL_MESSAGEBOX_INFORMATION = 0x00000040,
    }
}
mixin(expandEnum!SDL_MessageBoxFlags);

enum SDL_MessageBoxButtonFlags {
    SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT = 0x00000001,
    SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT = 0x00000002,
}
mixin(expandEnum!SDL_MessageBoxButtonFlags);

struct SDL_MessageBoxButtonData {
    uint flags;
    int buttonid;
    const(char)* text;
}

struct SDL_MessageBoxColor {
    ubyte r, g, b;
}

enum SDL_MessageBoxColorType {
    SDL_MESSAGEBOX_COLOR_BACKGROUND,
    SDL_MESSAGEBOX_COLOR_TEXT,
    SDL_MESSAGEBOX_COLOR_BUTTON_BORDER,
    SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND,
    SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED,
    SDL_MESSAGEBOX_COLOR_MAX,
}
mixin(expandEnum!SDL_MessageBoxColorType);

struct SDL_MessageBoxColorScheme {
    SDL_MessageBoxColor[SDL_MESSAGEBOX_COLOR_MAX] colors;
}

struct SDL_MessageBoxData {
    uint flags;
    SDL_Window* window;
    const(char)* title;
    const(char)* message;
    int numbuttons;
    const(SDL_MessageBoxButtonData)* buttons;
    const(SDL_MessageBoxColorScheme)* colorScheme;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_ShowMessageBox(const(SDL_MessageBoxData)*,int*);
        int SDL_ShowSimpleMessageBox(uint,const(char)*,const(char)*,SDL_Window*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_ShowMessageBox = int function(const(SDL_MessageBoxData)*,int*);
        alias pSDL_ShowSimpleMessageBox = int function(uint,const(char)*,const(char)*,SDL_Window*);
    }

    __gshared {
        pSDL_ShowMessageBox SDL_ShowMessageBox;
        pSDL_ShowSimpleMessageBox SDL_ShowSimpleMessageBox;
    }
}