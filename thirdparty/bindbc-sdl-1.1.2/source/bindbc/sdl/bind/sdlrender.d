
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlrender;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlblendmode : SDL_BlendMode;
import bindbc.sdl.bind.sdlrect;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlvideo : SDL_Window;
import bindbc.sdl.bind.sdlpixels : SDL_Color;

enum : uint {
    SDL_RENDERER_SOFTWARE = 0x00000001,
    SDL_RENDERER_ACCELERATED = 0x00000002,
    SDL_RENDERER_PRESENTVSYNC = 0x00000004,
    SDL_RENDERER_TARGETTEXTURE = 0x00000008,
}
alias SDL_RendererFlags = uint;

struct SDL_RendererInfo {
    const(char)* name;
    SDL_RendererFlags flags;
    uint num_texture_formats;
    uint[16] texture_formats;
    int max_texture_width;
    int max_texture_height;
}

static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_ScaleMode {
        SDL_ScaleModeNearest,
        SDL_ScaleModeLinear,
        SDL_ScaleModeBest,
    }
    mixin(expandEnum!SDL_ScaleMode);
}

static if(sdlSupport >= SDLSupport.sdl2018) {
    struct SDL_Vertex {
        SDL_FPoint position;
        SDL_Color color;
        SDL_FPoint tex_coord;
    }
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

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_GetNumRenderDrivers();
        int SDL_GetRenderDriverInfo(int index, SDL_RendererInfo* info);
        int SDL_CreateWindowAndRenderer(int width, int height, uint window_flags, SDL_Window** window, SDL_Renderer** renderer);
        SDL_Renderer* SDL_CreateRenderer(SDL_Window* window, int index, SDL_RendererFlags flags);
        SDL_Renderer* SDL_CreateSoftwareRenderer(SDL_Surface* surface);
        SDL_Renderer* SDL_GetRenderer(SDL_Window* window);
        int SDL_GetRendererInfo(SDL_Renderer* renderer, SDL_RendererInfo* info);
        int SDL_GetRendererOutputSize(SDL_Renderer* renderer, int* w, int* h);
        SDL_Texture* SDL_CreateTexture(SDL_Renderer* renderer, uint format, SDL_TextureAccess access, int w, int h);
        SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer* renderer, SDL_Surface* surface);
        int SDL_QueryTexture(SDL_Texture* texture, uint* format, SDL_TextureAccess* access, int* w, int* h);
        int SDL_SetTextureColorMod(SDL_Texture* texture, ubyte r, ubyte g, ubyte b);
        int SDL_GetTextureColorMod(SDL_Texture* texture, ubyte* r, ubyte* g, ubyte* b);
        int SDL_SetTextureAlphaMod(SDL_Texture* texture, ubyte alpha);
        int SDL_GetTextureAlphaMod(SDL_Texture* texture, ubyte* alpha);
        int SDL_SetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode blendMode);
        int SDL_GetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode* blendMode);
        int SDL_UpdateTexture(SDL_Texture* texture, const(SDL_Rect)* rect, const(void)* pixels, int pitch);
        int SDL_LockTexture(SDL_Texture* texture, const(SDL_Rect)* rect, void** pixels, int* pitch);
        void SDL_UnlockTexture(SDL_Texture* texture);
        SDL_bool SDL_RenderTargetSupported(SDL_Renderer* renderer);
        int SDL_SetRenderTarget(SDL_Renderer* renderer, SDL_Texture* texture);
        SDL_Texture* SDL_GetRenderTarget(SDL_Renderer* renderer);
        int SDL_RenderSetClipRect(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        void SDL_RenderGetClipRect(SDL_Renderer* renderer, SDL_Rect* rect);
        int SDL_RenderSetLogicalSize(SDL_Renderer* renderer, int w, int h);
        void SDL_RenderGetLogicalSize(SDL_Renderer* renderer, int* w, int* h);
        int SDL_RenderSetViewport(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        void SDL_RenderGetViewport(SDL_Renderer* renderer, SDL_Rect* rect);
        int SDL_RenderSetScale(SDL_Renderer* renderer, float scaleX, float scaleY);
        int SDL_RenderGetScale(SDL_Renderer* renderer, float* scaleX, float* scaleY);
        int SDL_SetRenderDrawColor(SDL_Renderer* renderer, ubyte r, ubyte g, ubyte b, ubyte a);
        int SDL_GetRenderDrawColor(SDL_Renderer* renderer, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        int SDL_SetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode blendMode);
        int SDL_GetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode* blendMode);
        int SDL_RenderClear(SDL_Renderer* renderer);
        int SDL_RenderDrawPoint(SDL_Renderer* renderer, int x, int y);
        int SDL_RenderDrawPoints(SDL_Renderer* renderer, const(SDL_Point)* points, int count);
        int SDL_RenderDrawLine(SDL_Renderer* renderer, int x1, int y1, int x2, int y2);
        int SDL_RenderDrawLines(SDL_Renderer* renderer, const(SDL_Point)* points, int count);
        int SDL_RenderDrawRect(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        int SDL_RenderDrawRects(SDL_Renderer* renderer, const(SDL_Rect)* rects, int count);
        int SDL_RenderFillRect(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        int SDL_RenderFillRects(SDL_Renderer* renderer, const(SDL_Rect)* rects, int count);
        int SDL_RenderCopy(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect);
        int SDL_RenderCopyEx(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect, const(double) angle, const(SDL_Point)* center, const(SDL_RendererFlip) flip);
        int SDL_RenderReadPixels(SDL_Renderer* renderer, const(SDL_Rect)* rect,uint,void*,int);
        void SDL_RenderPresent(SDL_Renderer* renderer);
        void SDL_DestroyTexture(SDL_Texture* texture);
        void SDL_DestroyRenderer(SDL_Renderer* renderer);
        int SDL_GL_BindTexture(SDL_Texture* texture, float* texw, float* texh);
        int SDL_GL_UnbindTexture(SDL_Texture* texture);

        static if(sdlSupport >= SDLSupport.sdl201) {
            int SDL_UpdateYUVTexture(SDL_Texture* texture ,const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* Uplane, int Upitch, const(ubyte)* Vplane, int Vpitch);
        }
        static if(sdlSupport >= SDLSupport.sdl204) {
            SDL_bool SDL_RenderIsClipEnabled(SDL_Renderer* renderer);
        }
        static if(sdlSupport >= SDLSupport.sdl205) {
            SDL_bool SDL_RenderGetIntegerScale(SDL_Renderer* renderer);
            int SDL_RenderSetIntegerScale(SDL_Renderer* renderer,SDL_bool);
        }
        static if(sdlSupport >= SDLSupport.sdl208) {
            void* SDL_RenderGetMetalLayer(SDL_Renderer* renderer);
            void* SDL_RenderGetMetalCommandEncoder(SDL_Renderer* renderer);
        }
        static if(sdlSupport >= SDLSupport.sdl2010) {
            int SDL_RenderDrawPointF(SDL_Renderer* renderer, float x, float y);
            int SDL_RenderDrawPointsF(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);
            int SDL_RenderDrawLineF(SDL_Renderer* renderer, float x1, float y1, float x2, float y2);
            int SDL_RenderDrawLinesF(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);
            int SDL_RenderDrawRectF(SDL_Renderer* renderer, const(SDL_FRect)* rect);
            int SDL_RenderDrawRectsF(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);
            int SDL_RenderFillRectF(SDL_Renderer* renderer, const(SDL_FRect)* rect);
            int SDL_RenderFillRectsF(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);
            int SDL_RenderCopyF(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect);
            int SDL_RenderCopyExF(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect, const(double) angle, const(SDL_FPoint)* center, const(SDL_RendererFlip) flip);
            int SDL_RenderFlush(SDL_Renderer* renderer);
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            int SDL_SetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode scaleMode);
            int SDL_GetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode* scaleMode);
            int SDL_LockTextureToSurface(SDL_Texture* texture, const(SDL_Rect)* rect,SDL_Surface** surface);
        }
        static if(sdlSupport >= SDLSupport.sdl2016) {
            int SDL_UpdateNVTexture(SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* UVplane, int UVpitch);
        }
        static if(sdlSupport >= SDLSupport.sdl2018) {
            int SDL_SetTextureUserData(SDL_Texture* texture, void* userdata);
            void* SDL_GetTextureUserData(SDL_Texture* texture);
            void SDL_RenderWindowToLogical(SDL_Renderer* renderer, int windowX, int windowY, float* logicalX, float* logicalY);
            void SDL_RenderLogicalToWindow(SDL_Renderer* renderer, float logicalX, float logicalY, int* windowX, int* windowY);
            int SDL_RenderGeometry(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int num_vertices, const(int)* indices, int num_indices);
            static if(sdlSupport >= SDLSupport.sdl2020) int SDL_RenderGeometryRaw(SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(SDL_Color)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices);
            else int SDL_RenderGeometryRaw(SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(int)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices);
            int SDL_RenderSetVSync(SDL_Renderer* renderer, int vsync);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumRenderDrivers = int function();
        alias pSDL_GetRenderDriverInfo = int function(int index, SDL_RendererInfo* info);
        alias pSDL_CreateWindowAndRenderer = int function(int width, int height, uint window_flags, SDL_Window** window, SDL_Renderer** renderer);
        alias pSDL_CreateRenderer = SDL_Renderer* function(SDL_Window* window, int index, SDL_RendererFlags flags);
        alias pSDL_CreateSoftwareRenderer = SDL_Renderer* function(SDL_Surface* surface);
        alias pSDL_GetRenderer = SDL_Renderer* function(SDL_Window* window);
        alias pSDL_GetRendererInfo = int function(SDL_Renderer* renderer, SDL_RendererInfo* info);
        alias pSDL_GetRendererOutputSize = int function(SDL_Renderer* renderer, int* w, int* h);
        alias pSDL_CreateTexture = SDL_Texture* function(SDL_Renderer* renderer, uint format, SDL_TextureAccess access, int w, int h);
        alias pSDL_CreateTextureFromSurface = SDL_Texture* function(SDL_Renderer* renderer, SDL_Surface* surface);
        alias pSDL_QueryTexture = int function(SDL_Texture* texture, uint* format, SDL_TextureAccess* access, int* w, int* h);
        alias pSDL_SetTextureColorMod = int function(SDL_Texture* texture, ubyte r, ubyte g, ubyte b);
        alias pSDL_GetTextureColorMod = int function(SDL_Texture* texture, ubyte* r, ubyte* g, ubyte* b);
        alias pSDL_SetTextureAlphaMod = int function(SDL_Texture* texture, ubyte alpha);
        alias pSDL_GetTextureAlphaMod = int function(SDL_Texture* texture, ubyte* alpha);
        alias pSDL_SetTextureBlendMode = int function(SDL_Texture* texture, SDL_BlendMode blendMode);
        alias pSDL_GetTextureBlendMode = int function(SDL_Texture* texture, SDL_BlendMode* blendMode);
        alias pSDL_UpdateTexture = int function(SDL_Texture* texture, const(SDL_Rect)* rect, const(void)* pixels, int pitch);
        alias pSDL_LockTexture = int function(SDL_Texture* texture, const(SDL_Rect)* rect, void** pixels, int* pitch);
        alias pSDL_UnlockTexture = void function(SDL_Texture* texture);
        alias pSDL_RenderTargetSupported = SDL_bool function(SDL_Renderer* renderer);
        alias pSDL_SetRenderTarget = int function(SDL_Renderer* renderer, SDL_Texture* texture);
        alias pSDL_GetRenderTarget = SDL_Texture* function(SDL_Renderer* renderer);
        alias pSDL_RenderSetClipRect = int function(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        alias pSDL_RenderGetClipRect = void function(SDL_Renderer* renderer, SDL_Rect* rect);
        alias pSDL_RenderSetLogicalSize = int function(SDL_Renderer* renderer, int w, int h);
        alias pSDL_RenderGetLogicalSize = void function(SDL_Renderer* renderer, int* w, int* h);
        alias pSDL_RenderSetViewport = int function(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        alias pSDL_RenderGetViewport = void function(SDL_Renderer* renderer, SDL_Rect* rect);
        alias pSDL_RenderSetScale = int function(SDL_Renderer* renderer, float scaleX, float scaleY);
        alias pSDL_RenderGetScale = int function(SDL_Renderer* renderer, float* scaleX, float* scaleY);
        alias pSDL_SetRenderDrawColor = int function(SDL_Renderer* renderer, ubyte r, ubyte g, ubyte b, ubyte a);
        alias pSDL_GetRenderDrawColor = int function(SDL_Renderer* renderer, ubyte* r, ubyte* g, ubyte* b, ubyte* a);
        alias pSDL_SetRenderDrawBlendMode = int function(SDL_Renderer* renderer, SDL_BlendMode blendMode);
        alias pSDL_GetRenderDrawBlendMode = int function(SDL_Renderer* renderer, SDL_BlendMode* blendMode);
        alias pSDL_RenderClear = int function(SDL_Renderer* renderer);
        alias pSDL_RenderDrawPoint = int function(SDL_Renderer* renderer, int x, int y);
        alias pSDL_RenderDrawPoints = int function(SDL_Renderer* renderer, const(SDL_Point)* points, int count);
        alias pSDL_RenderDrawLine = int function(SDL_Renderer* renderer, int x1, int y1, int x2, int y2);
        alias pSDL_RenderDrawLines = int function(SDL_Renderer* renderer, const(SDL_Point)* points, int count);
        alias pSDL_RenderDrawRect = int function(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        alias pSDL_RenderDrawRects = int function(SDL_Renderer* renderer, const(SDL_Rect)* rects, int count);
        alias pSDL_RenderFillRect = int function(SDL_Renderer* renderer, const(SDL_Rect)* rect);
        alias pSDL_RenderFillRects = int function(SDL_Renderer* renderer, const(SDL_Rect)* rects, int count);
        alias pSDL_RenderCopy = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect);
        alias pSDL_RenderCopyEx = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Rect)* srcrect, const(SDL_Rect)* dstrect, const(double) angle, const(SDL_Point)* center, const(SDL_RendererFlip) flip);
        alias pSDL_RenderReadPixels = int function(SDL_Renderer* renderer, const(SDL_Rect)* rect,uint,void*,int);
        alias pSDL_RenderPresent = void function(SDL_Renderer* renderer);
        alias pSDL_DestroyTexture = void function(SDL_Texture* texture);
        alias pSDL_DestroyRenderer = void function(SDL_Renderer* renderer);
        alias pSDL_GL_BindTexture = int function(SDL_Texture* texture, float* texw, float* texh);
        alias pSDL_GL_UnbindTexture = int function(SDL_Texture* texture);
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
            alias pSDL_UpdateYUVTexture = int function(SDL_Texture* texture ,const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* Uplane, int Upitch, const(ubyte)* Vplane, int Vpitch);
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
    static if(sdlSupport >= SDLSupport.sdl2010) {
        extern(C) @nogc nothrow {
            alias pSDL_RenderDrawPointF = int function(SDL_Renderer* renderer, float x, float y);
            alias pSDL_RenderDrawPointsF = int function(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);
            alias pSDL_RenderDrawLineF = int function(SDL_Renderer* renderer, float x1, float y1, float x2, float y2);
            alias pSDL_RenderDrawLinesF = int function(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);
            alias pSDL_RenderDrawRectF = int function(SDL_Renderer* renderer, const(SDL_FRect)* rect);
            alias pSDL_RenderDrawRectsF = int function(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);
            alias pSDL_RenderFillRectF = int function(SDL_Renderer* renderer, const(SDL_FRect)* rect);
            alias pSDL_RenderFillRectsF = int function(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);
            alias pSDL_RenderCopyF = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect);
            alias pSDL_RenderCopyExF = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect, const(double) angle, const(SDL_FPoint)* center, const(SDL_RendererFlip) flip);
            alias pSDL_RenderFlush = int function(SDL_Renderer* renderer);
        }
        __gshared {
            pSDL_RenderDrawPointF SDL_RenderDrawPointF;
            pSDL_RenderDrawPointsF SDL_RenderDrawPointsF;
            pSDL_RenderDrawLineF SDL_RenderDrawLineF;
            pSDL_RenderDrawLinesF SDL_RenderDrawLinesF;
            pSDL_RenderDrawRectF SDL_RenderDrawRectF;
            pSDL_RenderDrawRectsF SDL_RenderDrawRectsF;
            pSDL_RenderFillRectF SDL_RenderFillRectF;
            pSDL_RenderFillRectsF SDL_RenderFillRectsF;
            pSDL_RenderCopyF SDL_RenderCopyF;
            pSDL_RenderCopyExF SDL_RenderCopyExF;
            pSDL_RenderFlush SDL_RenderFlush;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2012) {
        extern(C) @nogc nothrow {
            alias pSDL_SetTextureScaleMode = int function(SDL_Texture* texture, SDL_ScaleMode scaleMode);
            alias pSDL_GetTextureScaleMode = int function(SDL_Texture* texture, SDL_ScaleMode* scaleMode);
            alias pSDL_LockTextureToSurface = int function(SDL_Texture* texture, const(SDL_Rect)* rect,SDL_Surface** surface);
        }
        __gshared {
            pSDL_SetTextureScaleMode SDL_SetTextureScaleMode;
            pSDL_GetTextureScaleMode SDL_GetTextureScaleMode;
            pSDL_LockTextureToSurface SDL_LockTextureToSurface;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2016) {
        extern(C) @nogc nothrow {
            alias pSDL_UpdateNVTexture = int function(SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* UVplane, int UVpitch);
        }
        __gshared {
            pSDL_UpdateNVTexture SDL_UpdateNVTexture;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2018) {
        extern(C) @nogc nothrow {
            alias pSDL_SetTextureUserData = int function(SDL_Texture* texture, void* userdata);
            alias pSDL_GetTextureUserData = void* function(SDL_Texture* texture);
            alias pSDL_RenderWindowToLogical = void function(SDL_Renderer* renderer, int windowX, int windowY, float* logicalX, float* logicalY);
            alias pSDL_RenderLogicalToWindow = void function(SDL_Renderer* renderer, float logicalX, float logicalY, int* windowX, int* windowY);
            alias pSDL_RenderGeometry = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int num_vertices, const(int)* indices, int num_indices);
            static if(sdlSupport >= SDLSupport.sdl2020) alias pSDL_RenderGeometryRaw = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(SDL_Color)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices);
            else alias pSDL_RenderGeometryRaw = int function(SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(int)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices);
            alias pSDL_RenderSetVSync = int function(SDL_Renderer* renderer, int vsync);
        }
        __gshared {
            pSDL_SetTextureUserData SDL_SetTextureUserData;
            pSDL_GetTextureUserData SDL_GetTextureUserData;
            pSDL_RenderWindowToLogical SDL_RenderWindowToLogical;
            pSDL_RenderLogicalToWindow SDL_RenderLogicalToWindow;
            pSDL_RenderGeometry SDL_RenderGeometry;
            pSDL_RenderGeometryRaw SDL_RenderGeometryRaw;
            pSDL_RenderSetVSync SDL_RenderSetVSync;
        }
    }
}
