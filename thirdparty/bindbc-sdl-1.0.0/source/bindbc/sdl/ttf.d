
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.ttf;

import bindbc.sdl.config;
static if(bindSDLTTF):

import core.stdc.config;
import bindbc.sdl.bind.sdlerror : SDL_GetError, SDL_SetError;
import bindbc.sdl.bind.sdlpixels : SDL_Color;
import bindbc.sdl.bind.sdlrwops : SDL_RWops;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlversion : SDL_version;

alias TTF_SetError = SDL_SetError;
alias TTF_GetError = SDL_GetError;

enum SDLTTFSupport {
    noLibrary,
    badLibrary,
    sdlTTF2012 = 2012,
    sdlTTF2013 = 2013,
    sdlTTF2014 = 2014,
}

enum ubyte SDL_TTF_MAJOR_VERSION = 2;
enum ubyte SDL_TTF_MINOR_VERSION = 0;

version(SDL_TTF_2014) {
    enum sdlTTFSupport = SDLTTFSupport.sdlTTF2014;
    enum ubyte SDL_TTF_PATCHLEVEL = 14;
}
else version(SDL_TTF_2013) {
    enum sdlTTFSupport = SDLTTFSupport.sdlTTF2013;
    enum ubyte SDL_TTF_PATCHLEVEL = 13;
}
else {
    enum sdlTTFSupport = SDLTTFSupport.sdlTTF2012;
    enum ubyte SDL_TTF_PATCHLEVEL = 12;
}

alias TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
alias TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
alias TTF_PATCHLEVEL = SDL_TTF_PATCHLEVEL;

@nogc nothrow
void SDL_TTF_VERSION(SDL_version* X) {
    X.major = SDL_TTF_MAJOR_VERSION;
    X.minor = SDL_TTF_MINOR_VERSION;
    X.patch = SDL_TTF_PATCHLEVEL;
}
alias TTF_VERSION = SDL_TTF_VERSION;

enum {
    UNICODE_BOM_NATIVE = 0xFEFF,
    UNICODE_BOM_SWAPPED = 0xFFFE,
    TTF_STYLE_NORMAL = 0x00,
    TTF_STYLE_BOLD = 0x01,
    TTF_STYLE_ITALIC = 0x02,
    TTF_STYLE_UNDERLINE = 0x04,
    TTF_STYLE_STRIKETHROUGH = 0x08,
}

enum {
    TTF_HINTING_NORMAL = 0,
    TTF_HINTING_LIGHT = 1,
    TTF_HINTING_MONO = 2,
    TTF_HINTING_NONE = 3,
}

struct TTF_Font;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_version* TTF_Linked_Version();
        void TTF_ByteSwappedUNICODE(int swapped);
        int TTF_Init();
        TTF_Font * TTF_OpenFont(const(char)* file, int ptsize);
        TTF_Font * TTF_OpenFontIndex(const(char)* file, int ptsize, c_long index);
        TTF_Font * TTF_OpenFontRW(SDL_RWops* src, int freesrc, int ptsize);
        TTF_Font * TTF_OpenFontIndexRW(SDL_RWops* src, int freesrc, int ptsize, c_long index);
        int TTF_GetFontStyle(const(TTF_Font)* font);
        void TTF_SetFontStyle(const(TTF_Font)* font ,int style);
        int TTF_GetFontOutline(const(TTF_Font)* font);
        void TTF_SetFontOutline(TTF_Font* font, int outline);
        int TTF_GetFontHinting(const(TTF_Font)* font);
        void TTF_SetFontHinting(TTF_Font* font, int hinting);
        int TTF_FontHeight(const(TTF_Font)* font);
        int TTF_FontAscent(const(TTF_Font)* font);
        int TTF_FontDescent(const(TTF_Font)* font);
        int TTF_FontLineSkip(const(TTF_Font)* font);
        int TTF_GetFontKerning(const(TTF_Font)* font);
        void TTF_SetFontKerning(TTF_Font* font, int allowed);
        int TTF_FontFaces(const(TTF_Font)* font);
        int TTF_FontFaceIsFixedWidth(const(TTF_Font)* font);
        char* TTF_FontFaceFamilyName(const(TTF_Font)* font);
        char* TTF_FontFaceStyleName(const(TTF_Font)* font);
        int TTF_GlyphIsProvided(const(TTF_Font)* font, ushort ch);
        int TTF_GlyphMetrics(TTF_Font* font, ushort ch, int* minx, int* maxx, int* miny, int* maxy, int* advance);
        int TTF_SizeText(TTF_Font* font, const(char)* text, int* w, int* h);
        int TTF_SizeUTF8(TTF_Font* font, const(char)* text, int* w, int* h);
        int TTF_SizeUNICODE(TTF_Font* font, const(ushort)* text, int* w, int* h);
        SDL_Surface* TTF_RenderText_Solid(TTF_Font* font, const(char)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderUTF8_Solid(TTF_Font* font, const(char)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderUNICODE_Solid(TTF_Font* font, const(ushort)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderGlyph_Solid(TTF_Font* font, ushort ch, SDL_Color fg);
        SDL_Surface* TTF_RenderText_Shaded(TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg);
        SDL_Surface* TTF_RenderUTF8_Shaded(TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg);
        SDL_Surface* TTF_RenderUNICODE_Shaded(TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg);
        SDL_Surface TTF_RenderGlyph_Shaded(TTF_Font* font, ushort ch, SDL_Color fg,SDL_Color bg);
        SDL_Surface* TTF_RenderText_Blended(TTF_Font* font, const(char)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderUTF8_Blended(TTF_Font* font, const(char)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderUNICODE_Blended(TTF_Font* font, const(ushort)* text, SDL_Color fg);
        SDL_Surface* TTF_RenderText_Blended_Wrapped(TTF_Font* font, const(char)* text, SDL_Color fg, uint wrapLength);
        SDL_Surface* TTF_RenderUTF8_Blended_Wrapped(TTF_Font* font, const(char)* text,SDL_Color fg, uint wrapLength);
        SDL_Surface* TTF_RenderUNICODE_Blended_Wrapped(TTF_Font* font, const(ushort)* text, SDL_Color fg, uint wrapLength);
        SDL_Surface* TTF_RenderGlyph_Blended(TTF_Font* font, ushort ch, SDL_Color fg);
        void TTF_CloseFont(TTF_Font* font);
        void TTF_Quit();
        int TTF_WasInit();
        int TTF_GetFontKerningSize(TTF_Font* font, int prev_index, int index);

        static if(sdlTTFSupport >= SDLTTFSupport.sdlTTF2014)  {
            int TTF_GetFontKerningSizeGlyph(TTF_Font* font, ushort previous_ch, ushort ch);
        }
    }
}
else {
    import bindbc.loader;
    extern(C) @nogc nothrow {
        alias pTTF_Linked_Version = SDL_version* function();
        alias pTTF_ByteSwappedUNICODE = void function(int swapped);
        alias pTTF_Init = int function();
        alias pTTF_OpenFont = TTF_Font * function(const(char)* file, int ptsize);
        alias pTTF_OpenFontIndex = TTF_Font * function(const(char)* file, int ptsize, c_long index);
        alias pTTF_OpenFontRW = TTF_Font * function(SDL_RWops* src, int freesrc, int ptsize);
        alias pTTF_OpenFontIndexRW = TTF_Font * function(SDL_RWops* src, int freesrc, int ptsize, c_long index);
        alias pTTF_GetFontStyle = int function(const(TTF_Font)* font);
        alias pTTF_SetFontStyle = void function(const(TTF_Font)* font ,int style);
        alias pTTF_GetFontOutline = int function(const(TTF_Font)* font);
        alias pTTF_SetFontOutline = void function(TTF_Font* font, int outline);
        alias pTTF_GetFontHinting = int function(const(TTF_Font)* font);
        alias pTTF_SetFontHinting = void function(TTF_Font* font, int hinting);
        alias pTTF_FontHeight = int function(const(TTF_Font)* font);
        alias pTTF_FontAscent = int function(const(TTF_Font)* font);
        alias pTTF_FontDescent = int function(const(TTF_Font)* font);
        alias pTTF_FontLineSkip = int function(const(TTF_Font)* font);
        alias pTTF_GetFontKerning = int function(const(TTF_Font)* font);
        alias pTTF_SetFontKerning = void function(TTF_Font* font, int allowed);
        alias pTTF_FontFaces = int function(const(TTF_Font)* font);
        alias pTTF_FontFaceIsFixedWidth = int function(const(TTF_Font)* font);
        alias pTTF_FontFaceFamilyName = char* function(const(TTF_Font)* font);
        alias pTTF_FontFaceStyleName = char* function(const(TTF_Font)* font);
        alias pTTF_GlyphIsProvided = int function(const(TTF_Font)* font, ushort ch);
        alias pTTF_GlyphMetrics = int function(TTF_Font* font, ushort ch, int* minx, int* maxx, int* miny, int* maxy, int* advance);
        alias pTTF_SizeText = int function(TTF_Font* font, const(char)* text, int* w, int* h);
        alias pTTF_SizeUTF8 = int function(TTF_Font* font, const(char)* text, int* w, int* h);
        alias pTTF_SizeUNICODE = int function(TTF_Font* font, const(ushort)* text, int* w, int* h);
        alias pTTF_RenderText_Solid = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg);
        alias pTTF_RenderUTF8_Solid = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg);
        alias pTTF_RenderUNICODE_Solid = SDL_Surface* function(TTF_Font* font, const(ushort)* text,SDL_Color fg);
        alias pTTF_RenderGlyph_Solid = SDL_Surface* function(TTF_Font* font, ushort ch, SDL_Color fg);
        alias pTTF_RenderText_Shaded = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg);
        alias pTTF_RenderUTF8_Shaded = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg, SDL_Color bg);
        alias pTTF_RenderUNICODE_Shaded = SDL_Surface* function(TTF_Font* font, const(ushort)* text, SDL_Color fg, SDL_Color bg);
        alias pTTF_RenderGlyph_Shaded = SDL_Surface* function(TTF_Font* font, ushort ch, SDL_Color fg,SDL_Color bg);
        alias pTTF_RenderText_Blended = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg);
        alias pTTF_RenderUTF8_Blended = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg);
        alias pTTF_RenderUNICODE_Blended = SDL_Surface* function(TTF_Font* font, const(ushort)* text, SDL_Color fg);
        alias pTTF_RenderText_Blended_Wrapped = SDL_Surface* function(TTF_Font* font, const(char)* text, SDL_Color fg, uint wrapLength);
        alias pTTF_RenderUTF8_Blended_Wrapped = SDL_Surface* function(TTF_Font* font, const(char)* text,SDL_Color fg, uint wrapLength);
        alias pTTF_RenderUNICODE_Blended_Wrapped = SDL_Surface* function(TTF_Font* font, const(ushort)* text, SDL_Color fg, uint wrapLength);
        alias pTTF_RenderGlyph_Blended = SDL_Surface* function(TTF_Font* font, ushort ch, SDL_Color fg);
        alias pTTF_CloseFont = void function(TTF_Font* font);
        alias pTTF_Quit = void function();
        alias pTTF_WasInit = int function();
        alias pTTF_GetFontKerningSize = int function(TTF_Font* font, int prev_index, int index);
    }

    __gshared {
        pTTF_Linked_Version TTF_Linked_Version;
        pTTF_ByteSwappedUNICODE TTF_ByteSwappedUNICODE;
        pTTF_Init TTF_Init;
        pTTF_OpenFont TTF_OpenFont;
        pTTF_OpenFontIndex TTF_OpenFontIndex;
        pTTF_OpenFontRW TTF_OpenFontRW;
        pTTF_OpenFontIndexRW TTF_OpenFontIndexRW;
        pTTF_GetFontStyle TTF_GetFontStyle;
        pTTF_SetFontStyle TTF_SetFontStyle;
        pTTF_GetFontOutline TTF_GetFontOutline;
        pTTF_SetFontOutline TTF_SetFontOutline;
        pTTF_GetFontHinting TTF_GetFontHinting;
        pTTF_SetFontHinting TTF_SetFontHinting;
        pTTF_FontHeight TTF_FontHeight;
        pTTF_FontAscent TTF_FontAscent;
        pTTF_FontDescent TTF_FontDescent;
        pTTF_FontLineSkip TTF_FontLineSkip;
        pTTF_GetFontKerning TTF_GetFontKerning;
        pTTF_SetFontKerning TTF_SetFontKerning;
        pTTF_FontFaces TTF_FontFaces;
        pTTF_FontFaceIsFixedWidth TTF_FontFaceIsFixedWidth;
        pTTF_FontFaceFamilyName TTF_FontFaceFamilyName;
        pTTF_FontFaceStyleName TTF_FontFaceStyleName;
        pTTF_GlyphIsProvided TTF_GlyphIsProvided;
        pTTF_GlyphMetrics TTF_GlyphMetrics;
        pTTF_SizeText TTF_SizeText;
        pTTF_SizeUTF8 TTF_SizeUTF8;
        pTTF_SizeUNICODE TTF_SizeUNICODE;
        pTTF_RenderText_Solid TTF_RenderText_Solid;
        pTTF_RenderUTF8_Solid TTF_RenderUTF8_Solid;
        pTTF_RenderUNICODE_Solid TTF_RenderUNICODE_Solid;
        pTTF_RenderGlyph_Solid TTF_RenderGlyph_Solid;
        pTTF_RenderText_Shaded TTF_RenderText_Shaded;
        pTTF_RenderUTF8_Shaded TTF_RenderUTF8_Shaded;
        pTTF_RenderUNICODE_Shaded TTF_RenderUNICODE_Shaded;
        pTTF_RenderGlyph_Shaded TTF_RenderGlyph_Shaded;
        pTTF_RenderText_Blended TTF_RenderText_Blended;
        pTTF_RenderUTF8_Blended TTF_RenderUTF8_Blended;
        pTTF_RenderUNICODE_Blended TTF_RenderUNICODE_Blended;
        pTTF_RenderText_Blended_Wrapped TTF_RenderText_Blended_Wrapped;
        pTTF_RenderUTF8_Blended_Wrapped TTF_RenderUTF8_Blended_Wrapped;
        pTTF_RenderUNICODE_Blended_Wrapped TTF_RenderUNICODE_Blended_Wrapped;
        pTTF_RenderGlyph_Blended TTF_RenderGlyph_Blended;
        pTTF_CloseFont TTF_CloseFont;
        pTTF_Quit TTF_Quit;
        pTTF_WasInit TTF_WasInit;
        pTTF_GetFontKerningSize TTF_GetFontKerningSize;
    }

    static if(sdlTTFSupport >= SDLTTFSupport.sdlTTF2014) {
        extern(C) @nogc nothrow {
            alias pTTF_GetFontKerningSizeGlyphs = int function(TTF_Font* font, ushort previous_ch, ushort ch);
        }

        __gshared {
            pTTF_GetFontKerningSizeGlyphs TTF_GetFontKerningSizeGlyphs;
        }
    }

    private {
        SharedLib lib;
        SDLTTFSupport loadedVersion;
    }

@nogc nothrow:
    void unloadSDLTTF()
    {
        if(lib != invalidHandle) {
            lib.unload();
        }
    }

    SDLTTFSupport loadedSDLTTFVersion() { return loadedVersion; }

    bool isSDLTTFLoaded()
    {
        return  lib != invalidHandle;
    }

    SDLTTFSupport loadSDLTTF()
    {
        version(Windows) {
            const(char)[][1] libNames = ["SDL2_ttf.dll"];
        }
        else version(OSX) {
            const(char)[][6] libNames = [
                "libSDL2_ttf.dylib",
                "/usr/local/lib/libSDL2_ttf.dylib",
                "../Frameworks/SDL2_ttf.framework/SDL2_ttf",
                "/Library/Frameworks/SDL2_ttf.framework/SDL2_ttf",
                "/System/Library/Frameworks/SDL2_ttf.framework/SDL2_ttf",
                "/opt/local/lib/libSDL2_ttf.dylib"
            ];
        }
        else version(Posix) {
            const(char)[][6] libNames = [
                "libSDL2_ttf.so",
                "/usr/local/lib/libSDL2_ttf.so",
                "libSDL2-2.0_ttf.so",
                "/usr/local/lib/libSDL2-2.0_ttf.so",
                "libSDL2-2.0_ttf.so.0",
                "/usr/local/lib/libSDL2-2.0_ttf.so.0"
            ];
        }
        else static assert(0, "bindbc-sdl is not yet supported on this platform.");

        SDLTTFSupport ret;
        foreach(name; libNames) {
            ret = loadSDLTTF(name.ptr);
            if(ret != SDLTTFSupport.noLibrary) break;
        }
        return ret;
    }

    SDLTTFSupport loadSDLTTF(const(char)* libName)
    {
        lib = load(libName);
        if(lib == invalidHandle) {
            return SDLTTFSupport.noLibrary;
        }

        auto errCount = errorCount();
        loadedVersion = SDLTTFSupport.badLibrary;

        lib.bindSymbol(cast(void**)&TTF_Linked_Version,"TTF_Linked_Version");
        lib.bindSymbol(cast(void**)&TTF_ByteSwappedUNICODE,"TTF_ByteSwappedUNICODE");
        lib.bindSymbol(cast(void**)&TTF_Init,"TTF_Init");
        lib.bindSymbol(cast(void**)&TTF_OpenFont,"TTF_OpenFont");
        lib.bindSymbol(cast(void**)&TTF_OpenFontIndex,"TTF_OpenFontIndex");
        lib.bindSymbol(cast(void**)&TTF_OpenFontRW,"TTF_OpenFontRW");
        lib.bindSymbol(cast(void**)&TTF_OpenFontIndexRW,"TTF_OpenFontIndexRW");
        lib.bindSymbol(cast(void**)&TTF_GetFontStyle,"TTF_GetFontStyle");
        lib.bindSymbol(cast(void**)&TTF_SetFontStyle,"TTF_SetFontStyle");
        lib.bindSymbol(cast(void**)&TTF_GetFontOutline,"TTF_GetFontOutline");
        lib.bindSymbol(cast(void**)&TTF_SetFontOutline,"TTF_SetFontOutline");
        lib.bindSymbol(cast(void**)&TTF_GetFontHinting,"TTF_GetFontHinting");
        lib.bindSymbol(cast(void**)&TTF_SetFontHinting,"TTF_SetFontHinting");
        lib.bindSymbol(cast(void**)&TTF_FontHeight,"TTF_FontHeight");
        lib.bindSymbol(cast(void**)&TTF_FontAscent,"TTF_FontAscent");
        lib.bindSymbol(cast(void**)&TTF_FontDescent,"TTF_FontDescent");
        lib.bindSymbol(cast(void**)&TTF_FontLineSkip,"TTF_FontLineSkip");
        lib.bindSymbol(cast(void**)&TTF_GetFontKerning,"TTF_GetFontKerning");
        lib.bindSymbol(cast(void**)&TTF_SetFontKerning,"TTF_SetFontKerning");
        lib.bindSymbol(cast(void**)&TTF_FontFaces,"TTF_FontFaces");
        lib.bindSymbol(cast(void**)&TTF_FontFaceIsFixedWidth,"TTF_FontFaceIsFixedWidth");
        lib.bindSymbol(cast(void**)&TTF_FontFaceFamilyName,"TTF_FontFaceFamilyName");
        lib.bindSymbol(cast(void**)&TTF_FontFaceStyleName,"TTF_FontFaceStyleName");
        lib.bindSymbol(cast(void**)&TTF_GlyphIsProvided,"TTF_GlyphIsProvided");
        lib.bindSymbol(cast(void**)&TTF_GlyphMetrics,"TTF_GlyphMetrics");
        lib.bindSymbol(cast(void**)&TTF_SizeText,"TTF_SizeText");
        lib.bindSymbol(cast(void**)&TTF_SizeUTF8,"TTF_SizeUTF8");
        lib.bindSymbol(cast(void**)&TTF_SizeUNICODE,"TTF_SizeUNICODE");
        lib.bindSymbol(cast(void**)&TTF_RenderText_Solid,"TTF_RenderText_Solid");
        lib.bindSymbol(cast(void**)&TTF_RenderUTF8_Solid,"TTF_RenderUTF8_Solid");
        lib.bindSymbol(cast(void**)&TTF_RenderUNICODE_Solid,"TTF_RenderUNICODE_Solid");
        lib.bindSymbol(cast(void**)&TTF_RenderGlyph_Solid,"TTF_RenderGlyph_Solid");
        lib.bindSymbol(cast(void**)&TTF_RenderText_Shaded,"TTF_RenderText_Shaded");
        lib.bindSymbol(cast(void**)&TTF_RenderUTF8_Shaded,"TTF_RenderUTF8_Shaded");
        lib.bindSymbol(cast(void**)&TTF_RenderUNICODE_Shaded,"TTF_RenderUNICODE_Shaded");
        lib.bindSymbol(cast(void**)&TTF_RenderGlyph_Shaded,"TTF_RenderGlyph_Shaded");
        lib.bindSymbol(cast(void**)&TTF_RenderText_Blended,"TTF_RenderText_Blended");
        lib.bindSymbol(cast(void**)&TTF_RenderUTF8_Blended,"TTF_RenderUTF8_Blended");
        lib.bindSymbol(cast(void**)&TTF_RenderUNICODE_Blended,"TTF_RenderUNICODE_Blended");
        lib.bindSymbol(cast(void**)&TTF_RenderText_Blended_Wrapped,"TTF_RenderText_Blended_Wrapped");
        lib.bindSymbol(cast(void**)&TTF_RenderUTF8_Blended_Wrapped,"TTF_RenderUTF8_Blended_Wrapped");
        lib.bindSymbol(cast(void**)&TTF_RenderUNICODE_Blended_Wrapped,"TTF_RenderUNICODE_Blended_Wrapped");
        lib.bindSymbol(cast(void**)&TTF_RenderGlyph_Blended,"TTF_RenderGlyph_Blended");
        lib.bindSymbol(cast(void**)&TTF_CloseFont,"TTF_CloseFont");
        lib.bindSymbol(cast(void**)&TTF_Quit,"TTF_Quit");
        lib.bindSymbol(cast(void**)&TTF_WasInit,"TTF_WasInit");
        lib.bindSymbol(cast(void**)&TTF_GetFontKerningSize,"TTF_GetFontKerningSize");

        if(errorCount() != errCount) return SDLTTFSupport.badLibrary;
        else loadedVersion = SDLTTFSupport.sdlTTF2012;

        static if(sdlTTFSupport >= SDLTTFSupport.sdlTTF2014) {
            lib.bindSymbol(cast(void**)&TTF_GetFontKerningSizeGlyphs,"TTF_GetFontKerningSizeGlyphs");

            if(errorCount() != errCount) return SDLTTFSupport.badLibrary;
            else loadedVersion = SDLTTFSupport.sdlTTF2014;
        }

        return loadedVersion;
    }
}
