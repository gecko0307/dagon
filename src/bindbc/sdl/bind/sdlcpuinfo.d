
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlcpuinfo;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

enum  SDL_CACHELINE_SIZE = 128;

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        int SDL_GetCPUCount();
        int SDL_GetCPUCacheLineSize();
        SDL_bool SDL_HasRDTSC();
        SDL_bool SDL_HasAltiVec();
        SDL_bool SDL_HasMMX();
        SDL_bool SDL_Has3DNow();
        SDL_bool SDL_HasSSE();
        SDL_bool SDL_HasSSE2();
        SDL_bool SDL_HasSSE3();
        SDL_bool SDL_HasSSE41();
        SDL_bool SDL_HasSSE42();

        static if(sdlSupport >= SDLSupport.sdl201) {
            int SDL_GetSystemRAM();
        }
        static if(sdlSupport >= SDLSupport.sdl202) {
            SDL_bool SDL_HasAVX();
        }
        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_bool SDL_HasAVX2();
        }
        static if(sdlSupport >= SDLSupport.sdl206) {
            SDL_bool SDL_HasNEON();
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            SDL_bool SDL_HasAVX512F();
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetCPUCount = int function();
        alias pSDL_GetCPUCacheLineSize = int function();
        alias pSDL_HasRDTSC = SDL_bool function();
        alias pSDL_HasAltiVec = SDL_bool function();
        alias pSDL_HasMMX = SDL_bool function();
        alias pSDL_Has3DNow = SDL_bool function();
        alias pSDL_HasSSE = SDL_bool function();
        alias pSDL_HasSSE2 = SDL_bool function();
        alias pSDL_HasSSE3 = SDL_bool function();
        alias pSDL_HasSSE41 = SDL_bool function();
        alias pSDL_HasSSE42 = SDL_bool function();
    }

    __gshared {
        pSDL_GetCPUCount SDL_GetCPUCount;
        pSDL_GetCPUCacheLineSize SDL_GetCPUCacheLineSize;
        pSDL_HasRDTSC SDL_HasRDTSC;
        pSDL_HasAltiVec SDL_HasAltiVec;
        pSDL_HasMMX SDL_HasMMX;
        pSDL_Has3DNow SDL_Has3DNow;
        pSDL_HasSSE SDL_HasSSE;
        pSDL_HasSSE2 SDL_HasSSE2;
        pSDL_HasSSE3 SDL_HasSSE3;
        pSDL_HasSSE41 SDL_HasSSE41;
        pSDL_HasSSE42 SDL_HasSSE42;
    }

    static if(sdlSupport >= SDLSupport.sdl201) {
        extern(C) @nogc nothrow {
            alias pSDL_GetSystemRAM = int function();
        }

        __gshared {
            pSDL_GetSystemRAM SDL_GetSystemRAM;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl202) {
        extern(C) @nogc nothrow {
            alias pSDL_HasAVX = SDL_bool function();
        }

        __gshared {
            pSDL_HasAVX SDL_HasAVX;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_HasAVX2 = SDL_bool function();
        }

        __gshared {
            pSDL_HasAVX2 SDL_HasAVX2;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_HasAVX512F = SDL_bool function();
        }

        __gshared {
            pSDL_HasAVX512F SDL_HasAVX512F;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_HasAVX512F = SDL_bool function();
        }

        __gshared {
            pSDL_HasAVX512F SDL_HasAVX512F;
        }
    }
}