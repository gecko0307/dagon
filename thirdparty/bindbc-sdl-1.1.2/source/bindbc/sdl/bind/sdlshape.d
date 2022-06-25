
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlshape;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlpixels : SDL_Color;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window, SDL_WindowFlags;

enum {
    SDL_NONSHAPEABLE_WINDOW = -1,
    SDL_INVALID_SHAPE_ARGUMENT = -2,
    SDL_WINDOW_LACKS_SHAPE = -3,
}

enum WindowShapeMode {
    ShapeModeDefault,
    ShapeModeBinarizeAlpha,
    ShapeModeReverseBinarizeAlpha,
    ShapeModeColorKey
}
mixin(expandEnum!WindowShapeMode);

enum SDL_SHAPEMODEALPHA(WindowShapeMode mode) = (mode == ShapeModeDefault || mode == ShapeModeBinarizeAlpha || mode == ShapeModeReverseBinarizeAlpha);

union SDL_WindowShapeParams {
    ubyte binarizationCutoff;
    SDL_Color colorKey;
}

struct SDL_WindowShapeMode {
    WindowShapeMode mode;
    SDL_WindowShapeParams parameters;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_Window* SDL_CreateShapedWindow(const(char)* title, uint x, uint y, uint w, uint h, SDL_WindowFlags flags);
        SDL_bool SDL_IsShapedWindow(const(SDL_Window)* window);
        int SDL_SetWindowShape(SDL_Window* window, SDL_Surface* shape, SDL_WindowShapeMode* shape_mode);
        int SDL_GetShapedWindowMode(SDL_Window* window, SDL_WindowShapeMode* shape_mode);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_CreateShapedWindow = SDL_Window* function(const(char)* title, uint x, uint y, uint w, uint h, SDL_WindowFlags flags);
        alias pSDL_IsShapedWindow = SDL_bool function(const(SDL_Window)* window);
        alias pSDL_SetWindowShape = int function(SDL_Window* window, SDL_Surface* shape, SDL_WindowShapeMode* shape_mode);
        alias pSDL_GetShapedWindowMode = int function(SDL_Window* window, SDL_WindowShapeMode* shape_mode);
    }

    __gshared {
        pSDL_CreateShapedWindow SDL_CreateShapedWindow;
        pSDL_IsShapedWindow SDL_IsShapedWindow;
        pSDL_SetWindowShape SDL_SetWindowShape;
        pSDL_GetShapedWindowMode SDL_GetShapedWindowMode;
    }
}