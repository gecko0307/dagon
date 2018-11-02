
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlrender;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlblendmode : SDL_BlendMode;
import bindbc.sdl.bind.sdlrect : SDL_Point, SDL_Rect;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

enum SDL_RendererFlags : uint {
    SDL_RENDERER_SOFTWARE = 0x00000001,
    SDL_RENDERER_ACCELERATED = 0x00000002,
    SDL_RENDERER_PRESENTVSYNC = 0x00000004,
    SDL_RENDERER_TARGETTEXTURE = 0x00000008,
}

mixin(expandEnum!SDL_RendererFlags);

struct SDL_RendererInfo {
    const(char)* name;
    SDL_RendererFlags flags;
    uint num_texture_formats;
    uint[16] texture_formats;
    int max_texture_width;
    int max_texture_height;
}

enum SDL_TextureAccess {
    SDL_TEXTUREACCESS_STATIC,
    SDL_TEXTUREACCESS_STREAMING,
    SDL_TEXTUREACCESS_TARGET,
}
mixin(expandEnum!SDL_TextureAccess);

enum SDL_TextureModulate {
    SDL_TEXTUREMODULATE_NONE = 0x00000000,
    SDL_TEXTUREMODULATE_COLOR = 0x00000001,
    SDL_TEXTUREMODULATE_ALPHA = 0x00000002
}
mixin(expandEnum!SDL_TextureModulate);

enum SDL_RendererFlip {
    SDL_FLIP_NONE = 0x00000000,
    SDL_FLIP_HORIZONTAL = 0x00000001,
    SDL_FLIP_VERTICAL = 0x00000002,
}
mixin(expandEnum!SDL_RendererFlip);

struct SDL_Renderer;
struct SDL_Texture;

version(BindSDL_Static) {
    extern(C) @nogc nothrow {
        int SDL_GetNumRenderDrivers();
        int SDL_GetRenderDriverInfo(int,SDL_RendererInfo*);
        int SDL_CreateWindowAndRenderer(int,int,uint,SDL_Window**,SDL_Renderer**);
        SDL_Renderer* SDL_CreateRenderer(SDL_Window*,int,SDL_RendererFlags);
        SDL_Renderer* SDL_CreateSoftwareRenderer(SDL_Surface*);
        SDL_Renderer* SDL_GetRenderer(SDL_Window*);
        int SDL_GetRendererInfo(SDL_Renderer*,SDL_RendererInfo*);
        int SDL_GetRendererOutputSize(SDL_Renderer*,int*,int*);
        SDL_Texture* SDL_CreateTexture(SDL_Renderer*,uint,SDL_TextureAccess,int,int);
        SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer*,SDL_Surface*);
        int SDL_QueryTexture(SDL_Texture*,uint*,int*,int*,int*);
        int SDL_SetTextureColorMod(SDL_Texture*,ubyte,ubyte,ubyte);
        int SDL_GetTextureColorMod(SDL_Texture*,ubyte*,ubyte*,ubyte*);
        int SDL_SetTextureAlphaMod(SDL_Texture*,ubyte);
        int SDL_GetTextureAlphaMod(SDL_Texture*,ubyte*);
        int SDL_SetTextureBlendMode(SDL_Texture*,SDL_BlendMode);
        int SDL_GetTextureBlendMode(SDL_Texture*,SDL_BlendMode*);
        int SDL_UpdateTexture(SDL_Texture*,const(SDL_Rect)*,const(void)*,int);
        int SDL_LockTexture(SDL_Texture*,const(SDL_Rect)*,void**,int*);
        void SDL_UnlockTexture(SDL_Texture*);
        SDL_bool SDL_RenderTargetSupported(SDL_Renderer*);
        int SDL_SetRenderTarget(SDL_Renderer*,SDL_Texture*);
        SDL_Texture* SDL_GetRenderTarget(SDL_Renderer*);
        int SDL_RenderSetClipRect(SDL_Renderer*,const(SDL_Rect)*);
        void SDL_RenderGetClipRect(SDL_Renderer* renderer,SDL_Rect*);
        int SDL_RenderSetLogicalSize(SDL_Renderer*,int,int);
        void SDL_RenderGetLogicalSize(SDL_Renderer*,int*,int*);
        int SDL_RenderSetViewport(SDL_Renderer*,const(SDL_Rect)*);
        void SDL_RenderGetViewport(SDL_Renderer*,SDL_Rect*);
        int SDL_RenderSetScale(SDL_Renderer*,float,float);
        int SDL_RenderGetScale(SDL_Renderer*,float*,float*);
        int SDL_SetRenderDrawColor(SDL_Renderer*,ubyte,ubyte,ubyte,ubyte);
        int SDL_GetRenderDrawColor(SDL_Renderer*,ubyte*,ubyte*,ubyte*,ubyte*);
        int SDL_SetRenderDrawBlendMode(SDL_Renderer*,SDL_BlendMode);
        int SDL_GetRenderDrawBlendMode(SDL_Renderer*,SDL_BlendMode*);
        int SDL_RenderClear(SDL_Renderer*);
        int SDL_RenderDrawPoint(SDL_Renderer*,int,int);
        int SDL_RenderDrawPoints(SDL_Renderer*,const(SDL_Point)*,int);
        int SDL_RenderDrawLine(SDL_Renderer*,int,int,int,int);
        int SDL_RenderDrawLines(SDL_Renderer*,const(SDL_Point)*,int);
        int SDL_RenderDrawRect(SDL_Renderer*,const(SDL_Rect)*);
        int SDL_RenderDrawRects(SDL_Renderer*,const(SDL_Rect)*,int);
        int SDL_RenderFillRect(SDL_Renderer*,const(SDL_Rect)*);
        int SDL_RenderFillRects(SDL_Renderer*,const(SDL_Rect)*,int);
        int SDL_RenderCopy(SDL_Renderer*,SDL_Texture*,const(SDL_Rect)*,const(SDL_Rect*));
        int SDL_RenderCopyEx(SDL_Renderer*,SDL_Texture*,const(SDL_Rect)*,const(SDL_Rect)*,const(double),const(SDL_Point)*,const(SDL_RendererFlip));
        int SDL_RenderReadPixels(SDL_Renderer*,const(SDL_Rect)*,uint,void*,int);
        void SDL_RenderPresent(SDL_Renderer*);
        void SDL_DestroyTexture(SDL_Texture*);
        void SDL_DestroyRenderer(SDL_Renderer*);
        int SDL_GL_BindTexture(SDL_Texture*,float*,float*);
        int SDL_GL_UnbindTexture(SDL_Texture*);

        static if(sdlSupport >= SDLSupport.sdl201) {
            int SDL_UpdateYUVTexture(SDL_Texture*,const(SDL_Rect)*,const(ubyte)*,int,const(ubyte)*,int,const(ubyte)*,int);
        }

        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_bool SDL_RenderIsClipEnabled(SDL_Renderer*);
        }

        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_bool SDL_RenderGetIntegerScale(SDL_Renderer*);
            int SDL_RenderSetIntegerScale(SDL_Renderer*,SDL_bool);
        }

        static if(sdlSupport >= SDLSupport.sdl208) {
            void* SDL_RenderGetMetalLayer(SDL_Renderer*);
            void* SDL_RenderGetMetalCommandEncoder(SDL_Renderer*);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumRenderDrivers = int function();
        alias pSDL_GetRenderDriverInfo = int function(int,SDL_RendererInfo*);
        alias pSDL_CreateWindowAndRenderer = int function(int,int,uint,SDL_Window**,SDL_Renderer**);
        alias pSDL_CreateRenderer = SDL_Renderer* function(SDL_Window*,int,SDL_RendererFlags);
        alias pSDL_CreateSoftwareRenderer = SDL_Renderer* function(SDL_Surface*);
        alias pSDL_GetRenderer = SDL_Renderer* function(SDL_Window*);
        alias pSDL_GetRendererInfo = int function(SDL_Renderer*,SDL_RendererInfo*);
        alias pSDL_GetRendererOutputSize = int function(SDL_Renderer*,int*,int*);
        alias pSDL_CreateTexture = SDL_Texture* function(SDL_Renderer*,uint,SDL_TextureAccess,int,int);
        alias pSDL_CreateTextureFromSurface = SDL_Texture* function(SDL_Renderer*,SDL_Surface*);
        alias pSDL_QueryTexture = int function(SDL_Texture*,uint*,int*,int*,int*);
        alias pSDL_SetTextureColorMod = int function(SDL_Texture*,ubyte,ubyte,ubyte);
        alias pSDL_GetTextureColorMod = int function(SDL_Texture*,ubyte*,ubyte*,ubyte*);
        alias pSDL_SetTextureAlphaMod = int function(SDL_Texture*,ubyte);
        alias pSDL_GetTextureAlphaMod = int function(SDL_Texture*,ubyte*);
        alias pSDL_SetTextureBlendMode = int function(SDL_Texture*,SDL_BlendMode);
        alias pSDL_GetTextureBlendMode = int function(SDL_Texture*,SDL_BlendMode*);
        alias pSDL_UpdateTexture = int function(SDL_Texture*,const(SDL_Rect)*,const(void)*,int);
        alias pSDL_LockTexture = int function(SDL_Texture*,const(SDL_Rect)*,void**,int*);
        alias pSDL_UnlockTexture = void function(SDL_Texture*);
        alias pSDL_RenderTargetSupported = SDL_bool function(SDL_Renderer*);
        alias pSDL_SetRenderTarget = int function(SDL_Renderer*,SDL_Texture*);
        alias pSDL_GetRenderTarget = SDL_Texture* function(SDL_Renderer*);
        alias pSDL_RenderSetClipRect = int function(SDL_Renderer*,const(SDL_Rect)*);
        alias pSDL_RenderGetClipRect = void function(SDL_Renderer* renderer,SDL_Rect*);
        alias pSDL_RenderSetLogicalSize = int function(SDL_Renderer*,int,int);
        alias pSDL_RenderGetLogicalSize = void function(SDL_Renderer*,int*,int*);
        alias pSDL_RenderSetViewport = int function(SDL_Renderer*,const(SDL_Rect)*);
        alias pSDL_RenderGetViewport = void function(SDL_Renderer*,SDL_Rect*);
        alias pSDL_RenderSetScale = int function(SDL_Renderer*,float,float);
        alias pSDL_RenderGetScale = int function(SDL_Renderer*,float*,float*);
        alias pSDL_SetRenderDrawColor = int function(SDL_Renderer*,ubyte,ubyte,ubyte,ubyte);
        alias pSDL_GetRenderDrawColor = int function(SDL_Renderer*,ubyte*,ubyte*,ubyte*,ubyte*);
        alias pSDL_SetRenderDrawBlendMode = int function(SDL_Renderer*,SDL_BlendMode);
        alias pSDL_GetRenderDrawBlendMode = int function(SDL_Renderer*,SDL_BlendMode*);
        alias pSDL_RenderClear = int function(SDL_Renderer*);
        alias pSDL_RenderDrawPoint = int function(SDL_Renderer*,int,int);
        alias pSDL_RenderDrawPoints = int function(SDL_Renderer*,const(SDL_Point)*,int);
        alias pSDL_RenderDrawLine = int function(SDL_Renderer*,int,int,int,int);
        alias pSDL_RenderDrawLines = int function(SDL_Renderer*,const(SDL_Point)*,int);
        alias pSDL_RenderDrawRect = int function(SDL_Renderer*,const(SDL_Rect)*);
        alias pSDL_RenderDrawRects = int function(SDL_Renderer*,const(SDL_Rect)*,int);
        alias pSDL_RenderFillRect = int function(SDL_Renderer*,const(SDL_Rect)*);
        alias pSDL_RenderFillRects = int function(SDL_Renderer*,const(SDL_Rect)*,int);
        alias pSDL_RenderCopy = int function(SDL_Renderer*,SDL_Texture*,const(SDL_Rect)*,const(SDL_Rect*));
        alias pSDL_RenderCopyEx = int function(SDL_Renderer*,SDL_Texture*,const(SDL_Rect)*,const(SDL_Rect)*,const(double),const(SDL_Point)*,const(SDL_RendererFlip));
        alias pSDL_RenderReadPixels = int function(SDL_Renderer*,const(SDL_Rect)*,uint,void*,int);
        alias pSDL_RenderPresent = void function(SDL_Renderer*);
        alias pSDL_DestroyTexture = void function(SDL_Texture*);
        alias pSDL_DestroyRenderer = void function(SDL_Renderer*);
        alias pSDL_GL_BindTexture = int function(SDL_Texture*,float*,float*);
        alias pSDL_GL_UnbindTexture = int function(SDL_Texture*);
    }

    __gshared {
        pSDL_GetNumRenderDrivers SDL_GetNumRenderDrivers;
        pSDL_GetRenderDriverInfo SDL_GetRenderDriverInfo;
        pSDL_CreateWindowAndRenderer SDL_CreateWindowAndRenderer;
        pSDL_CreateRenderer SDL_CreateRenderer;
        pSDL_CreateSoftwareRenderer SDL_CreateSoftwareRenderer;
        pSDL_GetRenderer SDL_GetRenderer;
        pSDL_GetRendererInfo SDL_GetRendererInfo;
        pSDL_GetRendererOutputSize SDL_GetRendererOutputSize;
        pSDL_CreateTexture SDL_CreateTexture;
        pSDL_CreateTextureFromSurface SDL_CreateTextureFromSurface;
        pSDL_QueryTexture SDL_QueryTexture;
        pSDL_SetTextureColorMod SDL_SetTextureColorMod;
        pSDL_GetTextureColorMod SDL_GetTextureColorMod;
        pSDL_SetTextureAlphaMod SDL_SetTextureAlphaMod;
        pSDL_GetTextureAlphaMod SDL_GetTextureAlphaMod;
        pSDL_SetTextureBlendMode SDL_SetTextureBlendMode;
        pSDL_GetTextureBlendMode SDL_GetTextureBlendMode;
        pSDL_UpdateTexture SDL_UpdateTexture;
        pSDL_LockTexture SDL_LockTexture;
        pSDL_UnlockTexture SDL_UnlockTexture;
        pSDL_RenderTargetSupported SDL_RenderTargetSupported;
        pSDL_SetRenderTarget SDL_SetRenderTarget;
        pSDL_GetRenderTarget SDL_GetRenderTarget;
        pSDL_RenderSetClipRect SDL_RenderSetClipRect;
        pSDL_RenderGetClipRect SDL_RenderGetClipRect;
        pSDL_RenderSetLogicalSize SDL_RenderSetLogicalSize;
        pSDL_RenderGetLogicalSize SDL_RenderGetLogicalSize;
        pSDL_RenderSetViewport SDL_RenderSetViewport;
        pSDL_RenderGetViewport SDL_RenderGetViewport;
        pSDL_RenderSetScale SDL_RenderSetScale;
        pSDL_RenderGetScale SDL_RenderGetScale;
        pSDL_SetRenderDrawColor SDL_SetRenderDrawColor;
        pSDL_GetRenderDrawColor SDL_GetRenderDrawColor;
        pSDL_SetRenderDrawBlendMode SDL_SetRenderDrawBlendMode;
        pSDL_GetRenderDrawBlendMode SDL_GetRenderDrawBlendMode;
        pSDL_RenderClear SDL_RenderClear;
        pSDL_RenderDrawPoint SDL_RenderDrawPoint;
        pSDL_RenderDrawPoints SDL_RenderDrawPoints;
        pSDL_RenderDrawLine SDL_RenderDrawLine;
        pSDL_RenderDrawLines SDL_RenderDrawLines;
        pSDL_RenderDrawRect SDL_RenderDrawRect;
        pSDL_RenderDrawRects SDL_RenderDrawRects;
        pSDL_RenderFillRect SDL_RenderFillRect;
        pSDL_RenderFillRects SDL_RenderFillRects;
        pSDL_RenderCopy SDL_RenderCopy;
        pSDL_RenderCopyEx SDL_RenderCopyEx;
        pSDL_RenderReadPixels SDL_RenderReadPixels;
        pSDL_RenderPresent SDL_RenderPresent;
        pSDL_DestroyTexture SDL_DestroyTexture;
        pSDL_DestroyRenderer SDL_DestroyRenderer;
        pSDL_GL_BindTexture SDL_GL_BindTexture;
        pSDL_GL_UnbindTexture SDL_GL_UnbindTexture;
    }

    static if(sdlSupport >= SDLSupport.sdl201) {
        extern(C) @nogc nothrow {
            alias pSDL_UpdateYUVTexture = int function(SDL_Texture*,const(SDL_Rect)*,const(ubyte)*,int,const(ubyte)*,int,const(ubyte)*,int);
        }

        __gshared {
            pSDL_UpdateYUVTexture SDL_UpdateYUVTexture;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_RenderIsClipEnabled = SDL_bool function(SDL_Renderer*);
        }

        __gshared {
            pSDL_RenderIsClipEnabled SDL_RenderIsClipEnabled;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_RenderGetIntegerScale = SDL_bool function(SDL_Renderer*);
            alias pSDL_RenderSetIntegerScale = int function(SDL_Renderer*,SDL_bool);
        }

        __gshared {
            pSDL_RenderGetIntegerScale SDL_RenderGetIntegerScale;
            pSDL_RenderSetIntegerScale SDL_RenderSetIntegerScale;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl208) {
        extern(C) @nogc nothrow {
            alias pSDL_RenderGetMetalLayer = void* function(SDL_Renderer*);
            alias pSDL_RenderGetMetalCommandEncoder = void* function(SDL_Renderer*);
        }

        __gshared {
            pSDL_RenderGetMetalLayer SDL_RenderGetMetalLayer;
            pSDL_RenderGetMetalCommandEncoder SDL_RenderGetMetalCommandEncoder;
        }
    }
}