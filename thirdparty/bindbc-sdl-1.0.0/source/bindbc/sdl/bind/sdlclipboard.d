
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlclipboard;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_SetClipboardText(const(char)* text);
        char* SDL_GetClipboardText();
        SDL_bool SDL_HasClipboardText();
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_SetClipboardText = int function(const(char)* text);
        alias pSDL_GetClipboardText = char* function();
        alias pSDL_HasClipboardText = SDL_bool function();
    }

    __gshared {
        pSDL_SetClipboardText SDL_SetClipboardText;
        pSDL_GetClipboardText SDL_GetClipboardText;
        pSDL_HasClipboardText SDL_HasClipboardText;
    }
}