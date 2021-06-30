
//          Copyright 2018 - 2021 Michael D. Parker
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
        SDL_Surface* SDL_CreateRGBSurface(uint flags, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask);
        SDL_Surface* SDL_CreateRGBSurfaceFrom(void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask);
        void SDL_FreeSurface(SDL_Surface* surface);
        int SDL_SetSurfacePalette(SDL_Surface* surface, SDL_Palette* palette);
        int SDL_LockSurface(SDL_Surface* surface);
        int SDL_UnlockSurface(SDL_Surface* surface);
        SDL_Surface* SDL_LoadBMP_RW(SDL_RWops* src, int freesrc);
        int SDL_SaveBMP_RW(SDL_Surface* surface, SDL_RWops* dst, int freedst);
        int SDL_SetSurfaceRLE(SDL_Surface* surface, int flag);
        int SDL_SetColorKey(SDL_Surface* surface, int flag, uint key);
        int SDL_GetColorKey(SDL_Surface* surface, uint* key);
        int SDL_SetSurfaceColorMod(SDL_Surface* surface, ubyte r, ubyte g, ubyte b);
        int SDL_GetSurfaceColorMod(SDL_Surface* surface, ubyte* r, ubyte* g, ubyte* b);
        int SDL_SetSurfaceAlphaMod(SDL_Surface* surface, ubyte alpha);
        int SDL_GetSurfaceAlphaMod(SDL_Surface* surface, ubyte* alpha);
        int SDL_SetSurfaceBlendMode(SDL_Surface* surface, SDL_BlendMode blendMode);
        int SDL_GetSurfaceBlendMode(SDL_Surface* surface, SDL_BlendMode* blendMode);
        SDL_bool SDL_SetClipRect(SDL_Surface* surface, const(SDL_Rect)* rect);
        void SDL_GetClipRect(SDL_Surface* surface, SDL_Rect* rect);
        SDL_Surface* SDL_ConvertSurface(SDL_Surface* surface, const(SDL_PixelFormat)* fmt, uint flags);
        SDL_Surface* SDL_ConvertSurfaceFormat(SDL_Surface* surface,uint pixel_format, uint flags);
        int SDL_ConvertPixels(int width, int height, uint src_format, const(void)* src, int src_pitch, uint dst_format, void* dst, int dst_pitch);
        int SDL_FillRect(SDL_Surface* surface, const(SDL_Rect)* rect, uint color);
        int SDL_FillRects(SDL_Surface* surface, const(SDL_Rect)* rects, int count, uint color);
        int SDL_UpperBlit(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        int SDL_LowerBlit(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        int SDL_SoftStretch(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, const(SDL_Rect)* dstrect);
        int SDL_UpperBlitScaled(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        int SDL_LowerBlitScaled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

        alias SDL_BlitSurface = SDL_UpperBlit;
        alias SDL_BlitScaled = SDL_UpperBlitScaled;

        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_Surface* SDL_CreateRGBSurfaceWithFormat(uint flags, int width, int height, int depth, uint format);
            SDL_Surface* SDL_CreateRGBSurfaceWithFormatFrom(void* pixels, int width, int height, int depth, int pitch, uint format);
        }
        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_Surface* SDL_DuplicateSurface(SDL_Surface* surface);
        }
        static if(sdlSupport >= SDLSupport.sdl208) {
            void SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE mode);
            SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionMode();
            SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionModeForResolution(int width, int height);
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            SDL_bool SDL_HasColorKey(SDL_Surface* surface);
        }
    }
}
else {
    extern(C) @nogc nothrow {alias pSDL_CreateRGBSurface = SDL_Surface* function(uint flags, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask);
        alias pSDL_CreateRGBSurfaceFrom = SDL_Surface* function(void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask);
        alias pSDL_FreeSurface = void function(SDL_Surface* surface);
        alias pSDL_SetSurfacePalette = int function(SDL_Surface* surface, SDL_Palette* palette);
        alias pSDL_LockSurface = int function(SDL_Surface* surface);
        alias pSDL_UnlockSurface = int function(SDL_Surface* surface);
        alias pSDL_LoadBMP_RW = SDL_Surface* function(SDL_RWops* src, int freesrc);
        alias pSDL_SaveBMP_RW = int function(SDL_Surface* surface, SDL_RWops* dst, int freedst);
        alias pSDL_SetSurfaceRLE = int function(SDL_Surface* surface, int flag);
        alias pSDL_SetColorKey = int function(SDL_Surface* surface, int flag, uint key);
        alias pSDL_GetColorKey = int function(SDL_Surface* surface, uint* key);
        alias pSDL_SetSurfaceColorMod = int function(SDL_Surface* surface, ubyte r, ubyte g, ubyte b);
        alias pSDL_GetSurfaceColorMod = int function(SDL_Surface* surface, ubyte* r, ubyte* g, ubyte* b);
        alias pSDL_SetSurfaceAlphaMod = int function(SDL_Surface* surface, ubyte alpha);
        alias pSDL_GetSurfaceAlphaMod = int function(SDL_Surface* surface, ubyte* alpha);
        alias pSDL_SetSurfaceBlendMode = int function(SDL_Surface* surface, SDL_BlendMode blendMode);
        alias pSDL_GetSurfaceBlendMode = int function(SDL_Surface* surface, SDL_BlendMode* blendMode);
        alias pSDL_SetClipRect = SDL_bool function(SDL_Surface* surface, const(SDL_Rect)* rect);
        alias pSDL_GetClipRect = void function(SDL_Surface* surface, SDL_Rect* rect);
        alias pSDL_ConvertSurface = SDL_Surface* function(SDL_Surface* surface, const(SDL_PixelFormat)* fmt, uint flags);
        alias pSDL_ConvertSurfaceFormat = SDL_Surface* function(SDL_Surface* surface,uint pixel_format, uint flags);
        alias pSDL_ConvertPixels = int function(int width, int height, uint src_format, const(void)* src, int src_pitch, uint dst_format, void* dst, int dst_pitch);
        alias pSDL_FillRect = int function(SDL_Surface* surface, const(SDL_Rect)* rect, uint color);
        alias pSDL_FillRects = int function(SDL_Surface* surface, const(SDL_Rect)* rects, int count, uint color);
        alias pSDL_UpperBlit = int function(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        alias pSDL_LowerBlit = int function(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        alias pSDL_SoftStretch = int function(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, const(SDL_Rect)* dstrect);
        alias pSDL_UpperBlitScaled = int function(SDL_Surface* src, const(SDL_Rect)* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);
        alias pSDL_LowerBlitScaled = int function(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect);

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
            alias pSDL_CreateRGBSurfaceWithFormat = SDL_Surface* function(uint flags, int width, int height, int depth, uint format);
            alias pSDL_CreateRGBSurfaceWithFormatFrom = SDL_Surface* function(void* pixels, int width, int height, int depth, int pitch, uint format);
        }

        __gshared {
            pSDL_CreateRGBSurfaceWithFormat SDL_CreateRGBSurfaceWithFormat;
            pSDL_CreateRGBSurfaceWithFormatFrom SDL_CreateRGBSurfaceWithFormatFrom;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_DuplicateSurface = SDL_Surface* function(SDL_Surface* surface);
        }

        __gshared {
            pSDL_DuplicateSurface SDL_DuplicateSurface;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl208) {
        extern(C) @nogc nothrow {
            alias pSDL_SetYUVConversionMode = void function(SDL_YUV_CONVERSION_MODE mode);
            alias pSDL_GetYUVConversionMode = SDL_YUV_CONVERSION_MODE function();
            alias pSDL_GetYUVConversionModeForResolution = SDL_YUV_CONVERSION_MODE function(int width, int height);
        }

        __gshared {
            pSDL_SetYUVConversionMode SDL_SetYUVConversionMode;
            pSDL_GetYUVConversionMode SDL_GetYUVConversionMode;
            pSDL_GetYUVConversionModeForResolution SDL_GetYUVConversionModeForResolution;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_HasColorKey = SDL_bool function(SDL_Surface* surface);
        }

        __gshared {
            pSDL_HasColorKey SDL_HasColorKey;
        }
    }
}