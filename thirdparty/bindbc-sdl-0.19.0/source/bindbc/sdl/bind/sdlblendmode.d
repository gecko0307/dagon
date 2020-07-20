
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlblendmode;

import bindbc.sdl.config;

static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_BlendMode {
        SDL_BLENDMODE_NONE = 0x00000000,
        SDL_BLENDMODE_BLEND = 0x00000001,
        SDL_BLENDMODE_ADD = 0x00000002,
        SDL_BLENDMODE_MOD = 0x00000004,
        SDL_BLENDMODE_MUL = 0x00000008,
        SDL_BLENDMODE_INVALID = 0x7FFFFFFF,
    }
}
else static if(sdlSupport >= SDLSupport.sdl206) {
    enum SDL_BlendMode {
        SDL_BLENDMODE_NONE = 0x00000000,
        SDL_BLENDMODE_BLEND = 0x00000001,
        SDL_BLENDMODE_ADD = 0x00000002,
        SDL_BLENDMODE_MOD = 0x00000004,
        SDL_BLENDMODE_INVALID = 0x7FFFFFFF,
    }
}
else {
    enum SDL_BlendMode {
        SDL_BLENDMODE_NONE = 0x00000000,
        SDL_BLENDMODE_BLEND = 0x00000001,
        SDL_BLENDMODE_ADD = 0x00000002,
        SDL_BLENDMODE_MOD = 0x00000004,
    }
}
mixin(expandEnum!SDL_BlendMode);

static if(sdlSupport >= SDLSupport.sdl206) {

    enum SDL_BlendOperation {
        SDL_BLENDOPERATION_ADD = 0x1,
        SDL_BLENDOPERATION_SUBTRACT = 0x2,
        SDL_BLENDOPERATION_REV_SUBTRACT = 0x3,
        SDL_BLENDOPERATION_MINIMUM = 0x4,
        SDL_BLENDOPERATION_MAXIMUM = 0x5,
    }
    mixin(expandEnum!SDL_BlendOperation);

    enum SDL_BlendFactor {
        SDL_BLENDFACTOR_ZERO = 0x1,
        SDL_BLENDFACTOR_ONE = 0x2,
        SDL_BLENDFACTOR_SRC_COLOR = 0x3,
        SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = 0x4,
        SDL_BLENDFACTOR_SRC_ALPHA = 0x5,
        SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = 0x6,
        SDL_BLENDFACTOR_DST_COLOR = 0x7,
        SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = 0x8,
        SDL_BLENDFACTOR_DST_ALPHA = 0x9,
        SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = 0xA,
    }
    mixin(expandEnum!SDL_BlendFactor);
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        static if(sdlSupport >= SDLSupport.sdl206) {
            SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor,SDL_BlendFactor,SDL_BlendOperation,SDL_BlendFactor,SDL_BlendFactor,SDL_BlendOperation);
        }
    }
}
else {
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_ComposeCustomBlendMode = SDL_BlendMode function(SDL_BlendFactor,SDL_BlendFactor,SDL_BlendOperation,SDL_BlendFactor,SDL_BlendFactor,SDL_BlendOperation);
        }

        __gshared {
            pSDL_ComposeCustomBlendMode SDL_ComposeCustomBlendMode;
        }
    }
}
