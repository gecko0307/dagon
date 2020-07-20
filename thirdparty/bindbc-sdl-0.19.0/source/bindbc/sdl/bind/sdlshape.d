
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlshape;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlpixels : SDL_Color;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

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
        SDL_Window* SDL_CreateShapedWindow(const(char)*,uint,uint,uint,uint,uint);
        SDL_bool SDL_IsShapedWindow(const(SDL_Window)*);
        int SDL_SetWindowShape(SDL_Window*,SDL_Surface*,SDL_WindowShapeMode*);
        int SDL_GetShapedWindowMode(SDL_Window*,SDL_WindowShapeMode*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_CreateShapedWindow = SDL_Window* function(const(char)*,uint,uint,uint,uint,uint);
        alias pSDL_IsShapedWindow = SDL_bool function(const(SDL_Window)*);
        alias pSDL_SetWindowShape = int function(SDL_Window*,SDL_Surface*,SDL_WindowShapeMode*);
        alias pSDL_GetShapedWindowMode = int function(SDL_Window*,SDL_WindowShapeMode*);
    }

    __gshared {
        pSDL_CreateShapedWindow SDL_CreateShapedWindow;
        pSDL_IsShapedWindow SDL_IsShapedWindow;
        pSDL_SetWindowShape SDL_SetWindowShape;
        pSDL_GetShapedWindowMode SDL_GetShapedWindowMode;
    }
}