
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmessagebox;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

// SDL_MessageBoxFlags
enum SDL_MESSAGEBOX_ERROR = 0x00000010;
enum SDL_MESSAGEBOX_WARNING = 0x00000020;
enum SDL_MESSAGEBOX_INFORMATION = 0x00000040;
static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT = 0x00000080;
    enum SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT = 0x00000100;
}
alias SDL_MessageBoxFlags = int;

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
        int SDL_ShowMessageBox(const(SDL_MessageBoxData)* messageboxdata, int* buttonid);
        int SDL_ShowSimpleMessageBox(uint flags, const(char)* title, const(char)* messsage, SDL_Window* window);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_ShowMessageBox = int function(const(SDL_MessageBoxData)* messageboxdata, int* buttonid);
        alias pSDL_ShowSimpleMessageBox = int function(uint flags, const(char)* title, const(char)* messsage, SDL_Window* window);
    }

    __gshared {
        pSDL_ShowMessageBox SDL_ShowMessageBox;
        pSDL_ShowSimpleMessageBox SDL_ShowSimpleMessageBox;
    }
}