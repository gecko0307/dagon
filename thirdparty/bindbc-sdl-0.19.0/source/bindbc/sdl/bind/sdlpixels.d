
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlpixels;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_FOURCC, SDL_bool;

enum SDL_ALPHA_OPAQUE = 255;
enum SDL_ALPHA_TRANSPARENT = 0;

enum SDL_PixelType {
    SDL_PIXELTYPE_UNKNOWN,
    SDL_PIXELTYPE_INDEX1,
    SDL_PIXELTYPE_INDEX4,
    SDL_PIXELTYPE_INDEX8,
    SDL_PIXELTYPE_PACKED8,
    SDL_PIXELTYPE_PACKED16,
    SDL_PIXELTYPE_PACKED32,
    SDL_PIXELTYPE_ARRAYU8,
    SDL_PIXELTYPE_ARRAYU16,
    SDL_PIXELTYPE_ARRAYU32,
    SDL_PIXELTYPE_ARRAYF16,
    SDL_PIXELTYPE_ARRAYF32
}
mixin(expandEnum!SDL_PixelType);

enum SDL_BitmapOrder {
    SDL_BITMAPORDER_NONE,
    SDL_BITMAPORDER_4321,
    SDL_BITMAPORDER_1234
}
mixin(expandEnum!SDL_BitmapOrder);

enum SDL_PackedOrder {
    SDL_PACKEDORDER_NONE,
    SDL_PACKEDORDER_XRGB,
    SDL_PACKEDORDER_RGBX,
    SDL_PACKEDORDER_ARGB,
    SDL_PACKEDORDER_RGBA,
    SDL_PACKEDORDER_XBGR,
    SDL_PACKEDORDER_BGRX,
    SDL_PACKEDORDER_ABGR,
    SDL_PACKEDORDER_BGRA
}
mixin(expandEnum!SDL_PackedOrder);

enum SDL_ArrayOrder {
    SDL_ARRAYORDER_NONE,
    SDL_ARRAYORDER_RGB,
    SDL_ARRAYORDER_RGBA,
    SDL_ARRAYORDER_ARGB,
    SDL_ARRAYORDER_BGR,
    SDL_ARRAYORDER_BGRA,
    SDL_ARRAYORDER_ABGR
}
mixin(expandEnum!SDL_ArrayOrder);

enum SDL_PackedLayout {
    SDL_PACKEDLAYOUT_NONE,
    SDL_PACKEDLAYOUT_332,
    SDL_PACKEDLAYOUT_4444,
    SDL_PACKEDLAYOUT_1555,
    SDL_PACKEDLAYOUT_5551,
    SDL_PACKEDLAYOUT_565,
    SDL_PACKEDLAYOUT_8888,
    SDL_PACKEDLAYOUT_2101010,
    SDL_PACKEDLAYOUT_1010102
}
mixin(expandEnum!SDL_PackedLayout);

alias SDL_DEFINE_PIXELFOURCC = SDL_FOURCC;

enum uint SDL_DEFINE_PIXELFORMAT(int type, int order, int layout, int bits, int bytes) =
    (1 << 28) | (type << 24) | (order << 20) | (layout << 16) | (bits << 8) | (bytes << 0);

enum uint SDL_PIXELFLAG(uint x) = (x >> 28) & 0x0F;
enum uint SDL_PIXELTYPE(uint x) = (x >> 24) & 0x0F;
enum uint SDL_PIXELORDER(uint x) = (x >> 20) & 0x0F;
enum uint SDL_PIXELLAYOUT(uint x) = (x >> 16) & 0x0F;
enum uint SDL_BITSPERPIXEL(uint x) = (x >> 8) & 0xFF;

template SDL_BYTESPERPIXEL(uint x) {
    static if(SDL_ISPIXELFORMAT_FOURCC!x) {
        static if(x == SDL_PIXELFORMAT_YUY2 || x == SDL_PIXELFORMAT_UYVY || x == SDL_PIXELFORMAT_YVYU)
            enum SDL_BYTESPERPIXEL = 2;
        else enum SDL_BYTESPERPIXEL = 1;
    }
    else enum SDL_BYTESPERPIXEL = (x >> 0) & 0xFF;
}

template SDL_ISPIXELFORMAT_INDEXED(uint format) {
    static if(SDL_ISPIXELFORMAT_FOURCC!format) {
        enum SDL_ISPIXELFORMAT_INDEXED = SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX1 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX4 ||
            SDL_PIXELTYPE!format == SDL_PIXELTYPE_INDEX8;
    }
    else enum SDL_ISPIXELFORMAT_INDEXED = false;
}

template SDL_ISPIXELFORMAT_PACKED(uint format) {
    static if(SDL_ISPIXELFORMAT_FOURCC!format) {
        enum SDL_ISPIXELFORMAT_PACKED = SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED8 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED16 ||
            SDL_PIXELTYPE!format == SDL_PIXELTYPE_PACKED32;
    }
    else enum SDL_ISPIXELFORMAT_PACKED = false;
}

static if(sdlSupport >= SDLSupport.sdl204) {
    template SDL_ISPIXELFORMAT_ARRAY(uint format) {
        static if(SDL_ISPIXELFORMAT_FOURCC!format) {
            enum SDL_ISPIXELFORMAT_ARRAY = SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU8 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU16 ||
                SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYU32 || SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYF16 ||
                SDL_PIXELTYPE!format == SDL_PIXELTYPE_ARRAYF32;
        }
        else enum SDL_ISPIXELFORMAT_ARRAY = false;
    }
}

template SDL_ISPIXELFORMAT_ALPHA(uint format) {
    static if(SDL_ISPIXELFORMAT_PACKED!format) {
        enum SDL_ISPIXELFORMAT_ALPHA = (SDL_PIXELORDER!format == SDL_PACKEDORDER_ARGB || SDL_PIXELORDER!format == SDL_PACKEDORDER_RGBA ||
                SDL_PIXELORDER!format == SDL_PACKEDORDER_ABGR || SDL_PIXELORDER!format == SDL_PACKEDORDER_BGRA);
    }
    else static if(sdlSupport >= SDLSupport.sdl204 && SDL_ISPIXELFORMAT_ARRAY!format) {
        enum SDL_ISPIXELFORMAT_ALPHA = (SDL_PIXELORDER!format == SDL_ARRAYORDER_ARGB || SDL_PIXELORDER!format == SDL_ARRAYORDER_RGBA ||
                SDL_PIXELORDER!format == SDL_ARRAYORDER_ABGR || SDL_PIXELORDER!format == SDL_ARRAYORDER_BGRA);
    }
    else enum SDL_ISPIXELFORMAT_ALPHA = false;
}

enum SDL_ISPIXELFORMAT_FOURCC(uint format) = format && !(format & 0x80000000);

enum SDL_PIXELFORMAT_UNKNOWN        = 0;
enum SDL_PIXELFORMAT_INDEX1LSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_4321, 0, 1, 0);
enum SDL_PIXELFORMAT_INDEX1MSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_1234, 0, 1, 0);
enum SDL_PIXELFORMAT_INDEX4LSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_4321, 0, 4, 0);
enum SDL_PIXELFORMAT_INDEX4MSB      = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_1234, 0, 4, 0);
enum SDL_PIXELFORMAT_INDEX8         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1);
enum SDL_PIXELFORMAT_RGB332         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED8, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_332, 8, 1);
enum SDL_PIXELFORMAT_RGB444         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_4444, 12, 2);
enum SDL_PIXELFORMAT_BGR444         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_4444, 12, 2);
enum SDL_PIXELFORMAT_RGB555         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_1555, 15, 2);
enum SDL_PIXELFORMAT_BGR555         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_1555, 15, 2);
enum SDL_PIXELFORMAT_ARGB4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_4444, 16, 2);
enum SDL_PIXELFORMAT_RGBA4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_4444, 16, 2);
enum SDL_PIXELFORMAT_ABGR4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_4444, 16, 2);
enum SDL_PIXELFORMAT_BGRA4444       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_4444, 16, 2);
enum SDL_PIXELFORMAT_ARGB1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_1555, 16, 2);
enum SDL_PIXELFORMAT_RGBA5551       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_5551, 16, 2);
enum SDL_PIXELFORMAT_ABGR1555       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_1555, 16, 2);
enum SDL_PIXELFORMAT_BGRA5551       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_5551, 16, 2);
enum SDL_PIXELFORMAT_RGB565         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_565, 16, 2);
enum SDL_PIXELFORMAT_BGR565         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_565, 16, 2);
enum SDL_PIXELFORMAT_RGB24          = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_RGB, 0, 24, 3);
enum SDL_PIXELFORMAT_BGR24          = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_BGR, 0, 24, 3);
enum SDL_PIXELFORMAT_RGB888         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_8888, 24, 4);
enum SDL_PIXELFORMAT_RGBX8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBX, SDL_PACKEDLAYOUT_8888, 24, 4);
enum SDL_PIXELFORMAT_BGR888         = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_8888, 24, 4);
enum SDL_PIXELFORMAT_BGRX8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRX, SDL_PACKEDLAYOUT_8888, 24, 4);
enum SDL_PIXELFORMAT_ARGB8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_8888, 32, 4);
enum SDL_PIXELFORMAT_RGBA8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_8888, 32, 4);
enum SDL_PIXELFORMAT_ABGR8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_8888, 32, 4);
enum SDL_PIXELFORMAT_BGRA8888       = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_8888, 32, 4);
enum SDL_PIXELFORMAT_ARGB2101010    = SDL_DEFINE_PIXELFORMAT!(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_2101010, 32, 4);

enum SDL_PIXELFORMAT_YV12           = SDL_DEFINE_PIXELFOURCC!('Y', 'V', '1', '2');
enum SDL_PIXELFORMAT_IYUV           = SDL_DEFINE_PIXELFOURCC!('I', 'Y', 'U', 'V');
enum SDL_PIXELFORMAT_YUY2           = SDL_DEFINE_PIXELFOURCC!('Y', 'U', 'Y', '2');
enum SDL_PIXELFORMAT_UYVY           = SDL_DEFINE_PIXELFOURCC!('U', 'Y', 'V', 'Y');
enum SDL_PIXELFORMAT_YVYU           = SDL_DEFINE_PIXELFOURCC!('Y', 'V', 'Y', 'U');

static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_PIXELFORMAT_NV12       = SDL_DEFINE_PIXELFOURCC!('N', 'V', '1', '2');
    enum SDL_PIXELFORMAT_NV21       = SDL_DEFINE_PIXELFOURCC!('N', 'V', '2', '1');
}

static if(sdlSupport >= SDLSupport.sdl208) {
    enum SDL_PIXELFORMAT_EXTERNAL_OES   = SDL_DEFINE_PIXELFOURCC!('O', 'E', 'S', ' ');
}

static assert(SDL_PIXELFORMAT_BGRX8888 == 0x16661804);

// Added in SDL 2.0.5, but doesn't hurt to make available for every version.
version(BigEndian) {
    alias SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888;
    alias SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888;
    alias SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888;
    alias SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888;
}
else {
    alias SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888;
    alias SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888;
    alias SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888;
    alias SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888;
}

struct SDL_Color {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}
alias SDL_Colour = SDL_Color;

struct SDL_Palette {
    int ncolors;
    SDL_Color* colors;
    uint version_;    // NOTE: original was named 'version'
    int refcount;
}

struct SDL_PixelFormat {
    uint format;
    SDL_Palette *palette;
    ubyte BitsPerPixel;
    ubyte BytesPerPixel;
    ubyte[2] padding;
    uint Rmask;
    uint Gmask;
    uint Bmask;
    uint Amask;
    ubyte Rloss;
    ubyte Gloss;
    ubyte Bloss;
    ubyte Aloss;
    ubyte Rshift;
    ubyte Gshift;
    ubyte Bshift;
    ubyte Ashift;
    int refcount;
    SDL_PixelFormat* next;
}

static if(staticBinding) {
  extern(C) @nogc nothrow {
      const(char)* SDL_GetPixelFormatName(uint);
      SDL_bool SDL_PixelFormatEnumToMasks(uint,int*,uint*,uint*,uint*,uint*);
      uint SDL_MasksToPixelFormatEnum(int,uint,uint,uint,uint);
      SDL_PixelFormat* SDL_AllocFormat(uint);
      void SDL_FreeFormat(SDL_PixelFormat*);
      SDL_Palette* SDL_AllocPalette(int);
      int SDL_SetPixelFormatPalette(SDL_PixelFormat*,SDL_Palette*);
      int SDL_SetPaletteColors(SDL_Palette*,const(SDL_Color)*,int,int);
      void SDL_FreePalette(SDL_Palette*);
      uint SDL_MapRGB(const(SDL_PixelFormat)*,ubyte,ubyte,ubyte);
      uint SDL_MapRGBA(const(SDL_PixelFormat)*,ubyte,ubyte,ubyte,ubyte);
      void SDL_GetRGB(uint,const(SDL_PixelFormat)*,ubyte*,ubyte*,ubyte*);
      void SDL_GetRGBA(uint,const(SDL_PixelFormat)*,ubyte*,ubyte*,ubyte*,ubyte*);
      void SDL_CalculateGammaRamp(float,ushort*);
  }
}
else {
  extern(C) @nogc nothrow {
      alias pSDL_GetPixelFormatName = const(char)* function(uint);
      alias pSDL_PixelFormatEnumToMasks = SDL_bool function(uint,int*,uint*,uint*,uint*,uint*);
      alias pSDL_MasksToPixelFormatEnum = uint function(int,uint,uint,uint,uint);
      alias pSDL_AllocFormat = SDL_PixelFormat* function(uint);
      alias pSDL_FreeFormat = void function(SDL_PixelFormat*);
      alias pSDL_AllocPalette = SDL_Palette* function(int);
      alias pSDL_SetPixelFormatPalette = int function(SDL_PixelFormat*,SDL_Palette*);
      alias pSDL_SetPaletteColors = int function(SDL_Palette*,const(SDL_Color)*,int,int);
      alias pSDL_FreePalette = void function(SDL_Palette*);
      alias pSDL_MapRGB = uint function(const(SDL_PixelFormat)*,ubyte,ubyte,ubyte);
      alias pSDL_MapRGBA = uint function(const(SDL_PixelFormat)*,ubyte,ubyte,ubyte,ubyte);
      alias pSDL_GetRGB = void function(uint,const(SDL_PixelFormat)*,ubyte*,ubyte*,ubyte*);
      alias pSDL_GetRGBA = void function(uint,const(SDL_PixelFormat)*,ubyte*,ubyte*,ubyte*,ubyte*);
      alias pSDL_CalculateGammaRamp = void function(float,ushort*);
  }

  __gshared {
      pSDL_GetPixelFormatName SDL_GetPixelFormatName;
      pSDL_PixelFormatEnumToMasks SDL_PixelFormatEnumToMasks;
      pSDL_MasksToPixelFormatEnum SDL_MasksToPixelFormatEnum;
      pSDL_AllocFormat SDL_AllocFormat;
      pSDL_FreeFormat SDL_FreeFormat;
      pSDL_AllocPalette SDL_AllocPalette;
      pSDL_SetPixelFormatPalette SDL_SetPixelFormatPalette;
      pSDL_SetPaletteColors SDL_SetPaletteColors;
      pSDL_FreePalette SDL_FreePalette;
      pSDL_MapRGB SDL_MapRGB;
      pSDL_MapRGBA SDL_MapRGBA;
      pSDL_GetRGB SDL_GetRGB;
      pSDL_GetRGBA SDL_GetRGBA;
      pSDL_CalculateGammaRamp SDL_CalculateGammaRamp;
  }
}