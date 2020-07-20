
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlstdinc;

import bindbc.sdl.config;

enum SDL_bool {
    SDL_FALSE = 0,
    SDL_TRUE = 1
}

mixin(expandEnum!SDL_bool);

alias Sint8 = byte;
alias Uint8 = ubyte;
alias Sint16 = short;
alias Uint16 = ushort;
alias Sint32 = int;
alias Uint32 = uint;
alias Sint64 = long;
alias Uint64 = ulong;

enum SDL_FOURCC(char A, char B, char C, char D)  = ((A << 0) | (B << 8) | (C << 16) | (D << 24));

static if(staticBinding) {
    extern(C) @nogc nothrow {
        void SDL_free(void* mem);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_free = void function(void* mem);
    }

    __gshared {
        pSDL_free SDL_free;
    }
}