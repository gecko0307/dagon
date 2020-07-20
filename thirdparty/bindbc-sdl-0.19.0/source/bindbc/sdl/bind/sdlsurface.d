
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlsurface;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlblendmode : SDL_BlendMode;
import bindbc.sdl.bind.sdlrect : SDL_Rect;
import bindbc.sdl.bind.sdlrwops;
import bindbc.sdl.bind.sdlpixels : SDL_Palette, SDL_PixelFormat;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

enum {
    SDL_SWSURFACE = 0,
    SDL_PREALLOC = 0x00000001,
    SDL_RLEACCEL = 0x00000002,
    SDL_DONTFREE = 0x00000004,
}

@nogc nothrow pure
bool SDL_MUSTLOCK(const(SDL_Surface)* S)
{
    pragma(inline, true);
    return (S.flags & SDL_RLEACCEL) != 0;
}

struct SDL_BlitMap;
struct SDL_Surface {
    int flags;
    SDL_PixelFormat* format;
    int w, h;
    int pitch;
    void* pixels;
    void* userdata;
    int locked;
    void* lock_data;
    SDL_Rect clip_rect;
    SDL_BlitMap* map;
    int refcount;
}

extern(C) nothrow alias SDL_blit = int function(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

@nogc nothrow {
    SDL_Surface* SDL_LoadBMP(const(char)* file) {
        pragma(inline, true);
        return SDL_LoadBMP_RW(SDL_RWFromFile(file,"rb"),1);
    }

    int SDL_SaveBMP(SDL_Surface* surface,const(char)* file) {
        pragma(inline, true);
        return SDL_SaveBMP_RW(surface,SDL_RWFromFile(file,"wb"),1);
    }
}

static if(sdlSupport >= SDLSupport.sdl208) {
    enum SDL_YUV_CONVERSION_MODE {
        SDL_YUV_CONVERSION_JPEG,
        SDL_YUV_CONVERSION_BT601,
        SDL_YUV_CONVERSION_BT709,
        SDL_YUV_CONVERSION_AUTOMATIC,
    }
    mixin(expandEnum!SDL_YUV_CONVERSION_MODE);
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_Surface* SDL_CreateRGBSurface(uint,int,int,int,uint,uint,uint,uint);
        SDL_Surface* SDL_CreateRGBSurfaceFrom(void*,int,int,int,int,uint,uint,uint,uint);
        void SDL_FreeSurface(SDL_Surface*);
        int SDL_SetSurfacePalette(SDL_Surface*,SDL_Palette*);
        int SDL_LockSurface(SDL_Surface*);
        int SDL_UnlockSurface(SDL_Surface*);
        SDL_Surface* SDL_LoadBMP_RW(SDL_RWops*,int);
        int SDL_SaveBMP_RW(SDL_Surface*,SDL_RWops*,int);
        int SDL_SetSurfaceRLE(SDL_Surface*,int);
        int SDL_SetColorKey(SDL_Surface*,int,uint);
        int SDL_GetColorKey(SDL_Surface*,uint*);
        int SDL_SetSurfaceColorMod(SDL_Surface*,ubyte,ubyte,ubyte);
        int SDL_GetSurfaceColorMod(SDL_Surface*,ubyte*,ubyte*,ubyte*);
        int SDL_SetSurfaceAlphaMod(SDL_Surface*,ubyte);
        int SDL_GetSurfaceAlphaMod(SDL_Surface*,ubyte*);
        int SDL_SetSurfaceBlendMode(SDL_Surface*,SDL_BlendMode);
        int SDL_GetSurfaceBlendMode(SDL_Surface*,SDL_BlendMode*);
        SDL_bool SDL_SetClipRect(SDL_Surface*,const(SDL_Rect)*);
        void SDL_GetClipRect(SDL_Surface*,SDL_Rect*);
        SDL_Surface* SDL_ConvertSurface(SDL_Surface*,const(SDL_PixelFormat)*,uint);
        SDL_Surface* SDL_ConvertSurfaceFormat(SDL_Surface*,uint,uint);
        int SDL_ConvertPixels(int,int,uint,const(void)*,int,uint,void*,int);
        int SDL_FillRect(SDL_Surface*,const(SDL_Rect)*,uint);
        int SDL_FillRects(SDL_Surface*,const(SDL_Rect)*,int,uint);
        int SDL_UpperBlit(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,SDL_Rect*);
        int SDL_LowerBlit(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*);
        int SDL_SoftStretch(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,const(SDL_Rect)*);
        int SDL_UpperBlitScaled(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,SDL_Rect*);
        int SDL_LowerBlitScaled(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*);

        alias SDL_BlitSurface = SDL_UpperBlit;
        alias SDL_BlitScaled = SDL_UpperBlitScaled;

        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_Surface* SDL_CreateRGBSurfaceWithFormat(uint,int,int,int,uint);
            SDL_Surface* SDL_CreateRGBSurfaceWithFormatFrom(void*,int,int,int,int,uint);
        }
        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_Surface* SDL_DuplicateSurface(SDL_Surface*);
        }
        static if(sdlSupport >= SDLSupport.sdl208) {
            void SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE);
            SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionMode();
            SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionModeForResolution(int,int);
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            SDL_bool SDL_HasColorKey(SDL_Surface*);
        }
    }
}
else {
    extern(C) @nogc nothrow {alias pSDL_CreateRGBSurface = SDL_Surface* function(uint,int,int,int,uint,uint,uint,uint);
        alias pSDL_CreateRGBSurfaceFrom = SDL_Surface* function(void*,int,int,int,int,uint,uint,uint,uint);
        alias pSDL_FreeSurface = void function(SDL_Surface*);
        alias pSDL_SetSurfacePalette = int function(SDL_Surface*,SDL_Palette*);
        alias pSDL_LockSurface = int function(SDL_Surface*);
        alias pSDL_UnlockSurface = int function(SDL_Surface*);
        alias pSDL_LoadBMP_RW = SDL_Surface* function(SDL_RWops*,int);
        alias pSDL_SaveBMP_RW = int function(SDL_Surface*,SDL_RWops*,int);
        alias pSDL_SetSurfaceRLE = int function(SDL_Surface*,int);
        alias pSDL_SetColorKey = int function(SDL_Surface*,int,uint);
        alias pSDL_GetColorKey = int function(SDL_Surface*,uint*);
        alias pSDL_SetSurfaceColorMod = int function(SDL_Surface*,ubyte,ubyte,ubyte);
        alias pSDL_GetSurfaceColorMod = int function(SDL_Surface*,ubyte*,ubyte*,ubyte*);
        alias pSDL_SetSurfaceAlphaMod = int function(SDL_Surface*,ubyte);
        alias pSDL_GetSurfaceAlphaMod = int function(SDL_Surface*,ubyte*);
        alias pSDL_SetSurfaceBlendMode = int function(SDL_Surface*,SDL_BlendMode);
        alias pSDL_GetSurfaceBlendMode = int function(SDL_Surface*,SDL_BlendMode*);
        alias pSDL_SetClipRect = SDL_bool function(SDL_Surface*,const(SDL_Rect)*);
        alias pSDL_GetClipRect = void function(SDL_Surface*,SDL_Rect*);
        alias pSDL_ConvertSurface = SDL_Surface* function(SDL_Surface*,const(SDL_PixelFormat)*,uint);
        alias pSDL_ConvertSurfaceFormat = SDL_Surface* function(SDL_Surface*,uint,uint);
        alias pSDL_ConvertPixels = int function(int,int,uint,const(void)*,int,uint,void*,int);
        alias pSDL_FillRect = int function(SDL_Surface*,const(SDL_Rect)*,uint);
        alias pSDL_FillRects = int function(SDL_Surface*,const(SDL_Rect)*,int,uint);
        alias pSDL_UpperBlit = int function(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,SDL_Rect*);
        alias pSDL_LowerBlit = int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*);
        alias pSDL_SoftStretch = int function(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,const(SDL_Rect)*);
        alias pSDL_UpperBlitScaled = int function(SDL_Surface*,const(SDL_Rect)*,SDL_Surface*,SDL_Rect*);
        alias pSDL_LowerBlitScaled = int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*);

        alias SDL_BlitSurface = SDL_UpperBlit;
        alias SDL_BlitScaled = SDL_UpperBlitScaled;
    }

    __gshared {
        pSDL_CreateRGBSurface SDL_CreateRGBSurface;
        pSDL_CreateRGBSurfaceFrom SDL_CreateRGBSurfaceFrom;
        pSDL_FreeSurface SDL_FreeSurface;
        pSDL_SetSurfacePalette SDL_SetSurfacePalette;
        pSDL_LockSurface SDL_LockSurface;
        pSDL_UnlockSurface SDL_UnlockSurface;
        pSDL_LoadBMP_RW SDL_LoadBMP_RW;
        pSDL_SaveBMP_RW SDL_SaveBMP_RW;
        pSDL_SetSurfaceRLE SDL_SetSurfaceRLE;
        pSDL_SetColorKey SDL_SetColorKey;
        pSDL_GetColorKey SDL_GetColorKey;
        pSDL_SetSurfaceColorMod SDL_SetSurfaceColorMod;
        pSDL_GetSurfaceColorMod SDL_GetSurfaceColorMod;
        pSDL_SetSurfaceAlphaMod SDL_SetSurfaceAlphaMod;
        pSDL_GetSurfaceAlphaMod SDL_GetSurfaceAlphaMod;
        pSDL_SetSurfaceBlendMode SDL_SetSurfaceBlendMode;
        pSDL_GetSurfaceBlendMode SDL_GetSurfaceBlendMode;
        pSDL_SetClipRect SDL_SetClipRect;
        pSDL_GetClipRect SDL_GetClipRect;
        pSDL_ConvertSurface SDL_ConvertSurface;
        pSDL_ConvertSurfaceFormat SDL_ConvertSurfaceFormat;
        pSDL_ConvertPixels SDL_ConvertPixels;
        pSDL_FillRect SDL_FillRect;
        pSDL_FillRects SDL_FillRects;
        pSDL_UpperBlit SDL_UpperBlit;
        pSDL_LowerBlit SDL_LowerBlit;
        pSDL_SoftStretch SDL_SoftStretch;
        pSDL_UpperBlitScaled SDL_UpperBlitScaled;
        pSDL_LowerBlitScaled SDL_LowerBlitScaled;
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_CreateRGBSurfaceWithFormat = SDL_Surface* function(uint,int,int,int,uint);
            alias pSDL_CreateRGBSurfaceWithFormatFrom = SDL_Surface* function(void*,int,int,int,int,uint);
        }

        __gshared {
            pSDL_CreateRGBSurfaceWithFormat SDL_CreateRGBSurfaceWithFormat;
            pSDL_CreateRGBSurfaceWithFormatFrom SDL_CreateRGBSurfaceWithFormatFrom;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_DuplicateSurface = SDL_Surface* function(SDL_Surface*);
        }

        __gshared {
            pSDL_DuplicateSurface SDL_DuplicateSurface;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl208) {
        extern(C) @nogc nothrow {
            alias pSDL_SetYUVConversionMode = void function(SDL_YUV_CONVERSION_MODE);
            alias pSDL_GetYUVConversionMode = SDL_YUV_CONVERSION_MODE function();
            alias pSDL_GetYUVConversionModeForResolution = SDL_YUV_CONVERSION_MODE function(int,int);
        }

        __gshared {
            pSDL_SetYUVConversionMode SDL_SetYUVConversionMode;
            pSDL_GetYUVConversionMode SDL_GetYUVConversionMode;
            pSDL_GetYUVConversionModeForResolution SDL_GetYUVConversionModeForResolution;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_HasColorKey = SDL_bool function(SDL_Surface*);
        }

        __gshared {
            pSDL_HasColorKey SDL_HasColorKey;
        }
    }
}