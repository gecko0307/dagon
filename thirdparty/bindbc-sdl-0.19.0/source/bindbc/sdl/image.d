
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.image;

import bindbc.sdl.config;
static if(bindSDLImage):

import bindbc.sdl.bind.sdlerror : SDL_GetError, SDL_SetError;
import bindbc.sdl.bind.sdlrender : SDL_Renderer, SDL_Texture;
import bindbc.sdl.bind.sdlrwops : SDL_RWops;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;
import bindbc.sdl.bind.sdlversion : SDL_version, SDL_VERSIONNUM;

alias IMG_SetError = SDL_SetError;
alias IMG_GetError = SDL_GetError;

enum SDLImageSupport {
    noLibrary,
    badLibrary,
    sdlImage200 = 200,
    sdlImage201,
    sdlImage202,
    sdlImage203,
    sdlImage204,
    sdlImage205,
}

enum ubyte SDL_IMAGE_MAJOR_VERSION = 2;
enum ubyte SDL_IMAGE_MINOR_VERSION = 0;


version(SDL_Image_205) {
    enum sdlImageSupport = SDLImageSupport.sdlImage205;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 5;
}
else version(SDL_Image_204) {
    enum sdlImageSupport = SDLImageSupport.sdlImage204;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 4;
}
else version(SDL_Image_203) {
    enum sdlImageSupport = SDLImageSupport.sdlImage203;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 3;
}
else version(SDL_Image_202) {
    enum sdlImageSupport = SDLImageSupport.sdlImage202;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 2;
}
else version(SDL_Image_201) {
    enum sdlImageSupport = SDLImageSupport.sdlImage201;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 1;
}
else {
    enum sdlImageSupport = SDLImageSupport.sdlImage200;
    enum ubyte SDL_IMAGE_PATCHLEVEL = 0;
}

@nogc nothrow void SDL_IMAGE_VERSION(SDL_version* X)
{
    X.major     = SDL_IMAGE_MAJOR_VERSION;
    X.minor     = SDL_IMAGE_MINOR_VERSION;
    X.patch     = SDL_IMAGE_PATCHLEVEL;
}

// These were implemented in SDL_image 2.0.2, but are fine for all versions.
enum SDL_IMAGE_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_PATCHLEVEL);
enum SDL_IMAGE_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_IMAGE_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

enum {
    IMG_INIT_JPG    = 0x00000001,
    IMG_INIT_PNG    = 0x00000002,
    IMG_INIT_TIF    = 0x00000004,
    IMG_INIT_WEBP   = 0x00000008,
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int IMG_Init(int);
        int IMG_Quit();
        const(SDL_version)* IMG_Linked_Version();
        SDL_Surface* IMG_LoadTyped_RW(SDL_RWops*,int,const(char)*);
        SDL_Surface* IMG_Load(const(char)*);
        SDL_Surface* IMG_Load_RW(SDL_RWops*,int);

        SDL_Texture* IMG_LoadTexture(SDL_Renderer*,const(char)*);
        SDL_Texture* IMG_LoadTexture_RW(SDL_Renderer*,SDL_RWops*,int);
        SDL_Texture* IMG_LoadTextureTyped_RW(SDL_Renderer*,SDL_RWops*,int,const(char)*);

        int IMG_isICO(SDL_RWops*);
        int IMG_isCUR(SDL_RWops*);
        int IMG_isBMP(SDL_RWops*);
        int IMG_isGIF(SDL_RWops*);
        int IMG_isJPG(SDL_RWops*);
        int IMG_isLBM(SDL_RWops*);
        int IMG_isPCX(SDL_RWops*);
        int IMG_isPNG(SDL_RWops*);
        int IMG_isPNM(SDL_RWops*);
        int IMG_isTIF(SDL_RWops*);
        int IMG_isXCF(SDL_RWops*);
        int IMG_isXPM(SDL_RWops*);
        int IMG_isXV(SDL_RWops*);
        int IMG_isWEBP(SDL_RWops*);

        SDL_Surface* IMG_LoadICO_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadCUR_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadBMP_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadGIF_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadJPG_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadLBM_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadPCX_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadPNG_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadPNM_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadTGA_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadTIF_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadXCF_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadXPM_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadXV_RW(SDL_RWops*);
        SDL_Surface* IMG_LoadWEBP_RW(SDL_RWops*);

        SDL_Surface* IMG_ReadXPMFromArray(char**);

        int IMG_SavePNG(SDL_Surface*,const(char)*);
        int IMG_SavePNG_RW(SDL_Surface*,SDL_RWops*,int);

        static if(sdlImageSupport >= SDLImageSupport.sdlImage202) {
            int IMG_isSVG(SDL_RWops*);
            SDL_Surface* IMG_LoadSVG(SDL_RWops*);
            int IMG_SaveJPG(SDL_Surface*,const(char)*,int);
            int IMG_SaveJPG_RW(SDL_Surface*,SDL_RWops*,int,int);
        }
    }
}
else {
    import bindbc.loader;

    extern(C) @nogc nothrow {
        alias pIMG_Init = int function(int);
        alias pIMG_Quit = int function();
        alias pIMG_Linked_Version = const(SDL_version)* function();
        alias pIMG_LoadTyped_RW = SDL_Surface* function(SDL_RWops*,int,const(char)*);
        alias pIMG_Load = SDL_Surface* function(const(char)*);
        alias pIMG_Load_RW = SDL_Surface* function(SDL_RWops*,int);

        alias pIMG_LoadTexture = SDL_Texture* function(SDL_Renderer*,const(char)*);
        alias pIMG_LoadTexture_RW = SDL_Texture* function(SDL_Renderer*,SDL_RWops*,int);
        alias pIMG_LoadTextureTyped_RW = SDL_Texture* function(SDL_Renderer*,SDL_RWops*,int,const(char)*);

        alias pIMG_isICO = int function(SDL_RWops*);
        alias pIMG_isCUR = int function(SDL_RWops*);
        alias pIMG_isBMP = int function(SDL_RWops*);
        alias pIMG_isGIF = int function(SDL_RWops*);
        alias pIMG_isJPG = int function(SDL_RWops*);
        alias pIMG_isLBM = int function(SDL_RWops*);
        alias pIMG_isPCX = int function(SDL_RWops*);
        alias pIMG_isPNG = int function(SDL_RWops*);
        alias pIMG_isPNM = int function(SDL_RWops*);
        alias pIMG_isTIF = int function(SDL_RWops*);
        alias pIMG_isXCF = int function(SDL_RWops*);
        alias pIMG_isXPM = int function(SDL_RWops*);
        alias pIMG_isXV = int function(SDL_RWops*);
        alias pIMG_isWEBP = int function(SDL_RWops*);

        alias pIMG_LoadICO_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadCUR_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadBMP_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadGIF_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadJPG_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadLBM_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadPCX_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadPNG_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadPNM_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadTGA_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadTIF_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadXCF_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadXPM_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadXV_RW = SDL_Surface* function(SDL_RWops*);
        alias pIMG_LoadWEBP_RW = SDL_Surface* function(SDL_RWops*);

        alias pIMG_ReadXPMFromArray = SDL_Surface* function(char**);

        alias pIMG_SavePNG = int function(SDL_Surface*,const(char)*);
        alias pIMG_SavePNG_RW = int function(SDL_Surface*,SDL_RWops*,int);
    }

    __gshared {
        pIMG_Init IMG_Init;
        pIMG_Quit IMG_Quit;
        pIMG_Linked_Version IMG_Linked_Version;
        pIMG_LoadTyped_RW IMG_LoadTyped_RW;
        pIMG_Load IMG_Load;
        pIMG_Load_RW IMG_Load_RW;
        pIMG_LoadTexture IMG_LoadTexture;
        pIMG_LoadTexture_RW IMG_LoadTexture_RW;
        pIMG_LoadTextureTyped_RW IMG_LoadTextureTyped_RW;
        pIMG_isICO IMG_isICO;
        pIMG_isCUR IMG_isCUR;
        pIMG_isBMP IMG_isBMP;
        pIMG_isGIF IMG_isGIF;
        pIMG_isJPG IMG_isJPG;
        pIMG_isLBM IMG_isLBM;
        pIMG_isPCX IMG_isPCX;
        pIMG_isPNG IMG_isPNG;
        pIMG_isPNM IMG_isPNM;
        pIMG_isTIF IMG_isTIF;
        pIMG_isXCF IMG_isXCF;
        pIMG_isXPM IMG_isXPM;
        pIMG_isXV IMG_isXV;
        pIMG_isWEBP IMG_isWEBP;
        pIMG_LoadICO_RW IMG_LoadICO_RW;
        pIMG_LoadCUR_RW IMG_LoadCUR_RW;
        pIMG_LoadBMP_RW IMG_LoadBMP_RW;
        pIMG_LoadGIF_RW IMG_LoadGIF_RW;
        pIMG_LoadJPG_RW IMG_LoadJPG_RW;
        pIMG_LoadLBM_RW IMG_LoadLBM_RW;
        pIMG_LoadPCX_RW IMG_LoadPCX_RW;
        pIMG_LoadPNG_RW IMG_LoadPNG_RW;
        pIMG_LoadPNM_RW IMG_LoadPNM_RW;
        pIMG_LoadTGA_RW IMG_LoadTGA_RW;
        pIMG_LoadTIF_RW IMG_LoadTIF_RW;
        pIMG_LoadXCF_RW IMG_LoadXCF_RW;
        pIMG_LoadXPM_RW IMG_LoadXPM_RW;
        pIMG_LoadXV_RW IMG_LoadXV_RW;
        pIMG_LoadWEBP_RW IMG_LoadWEBP_RW;
        pIMG_ReadXPMFromArray IMG_ReadXPMFromArray;
        pIMG_SavePNG IMG_SavePNG;
        pIMG_SavePNG_RW IMG_SavePNG_RW;
    }

    static if(sdlImageSupport >= SDLImageSupport.sdlImage202) {
        extern(C) @nogc nothrow {
            alias pIMG_isSVG = int function(SDL_RWops*);
            alias pIMG_LoadSVG_RW = SDL_Surface* function(SDL_RWops*);
            alias pIMG_SaveJPG = int function(SDL_Surface*,const(char)*,int);
            alias pIMG_SaveJPG_RW = int function(SDL_Surface*,SDL_RWops*,int,int);
        }

        __gshared {
            pIMG_isSVG IMG_isSVG;
            pIMG_LoadSVG_RW IMG_LoadSVG;
            pIMG_SaveJPG IMG_SaveJPG;
            pIMG_SaveJPG_RW IMG_SaveJPG_RW;
        }
    }

    private {
        SharedLib lib;
        SDLImageSupport loadedVersion;
    }

    void unloadSDLImage()
    {
        if(lib != invalidHandle) {
            lib.unload();
        }
    }

    SDLImageSupport loadedSDLImageVersion() { return loadedVersion; }

    bool isSDLImageLoaded()
    {
        return  lib != invalidHandle;
    }


    SDLImageSupport loadSDLImage()
    {
        version(Windows) {
            const(char)[][1] libNames = ["SDL2_image.dll"];
        }
        else version(OSX) {
            const(char)[][6] libNames = [
                "libSDL2_image.dylib",
                "/usr/local/lib/libSDL2_image.dylib",
                "../Frameworks/SDL2_image.framework/SDL2_image",
                "/Library/Frameworks/SDL2_image.framework/SDL2_image",
                "/System/Library/Frameworks/SDL2_image.framework/SDL2_image",
                "/opt/local/lib/libSDL2_image.dylib"
            ];
        }
        else version(Posix) {
            const(char)[][6] libNames = [
                "libSDL2_image.so",
                "/usr/local/lib/libSDL2_image.so",
                "libSDL2_image-2.0.so",
                "/usr/local/lib/libSDL2_image-2.0.so",
                "libSDL2_image-2.0.so.0",
                "/usr/local/lib/libSDL2_image-2.0.so.0"
            ];
        }
        else static assert(0, "bindbc-sdl is not yet supported on this platform.");

        SDLImageSupport ret;
        foreach(name; libNames) {
            ret = loadSDLImage(name.ptr);
            if(ret != SDLImageSupport.noLibrary) break;
        }
        return ret;
    }

    SDLImageSupport loadSDLImage(const(char)* libName)
    {
        lib = load(libName);
        if(lib == invalidHandle) {
            return SDLImageSupport.noLibrary;
        }

        auto errCount = errorCount();
        loadedVersion = SDLImageSupport.badLibrary;

        lib.bindSymbol(cast(void**)&IMG_Init,"IMG_Init");
        lib.bindSymbol(cast(void**)&IMG_Quit,"IMG_Quit");
        lib.bindSymbol(cast(void**)&IMG_Linked_Version,"IMG_Linked_Version");
        lib.bindSymbol(cast(void**)&IMG_LoadTyped_RW,"IMG_LoadTyped_RW");
        lib.bindSymbol(cast(void**)&IMG_Load,"IMG_Load");
        lib.bindSymbol(cast(void**)&IMG_Load_RW,"IMG_Load_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadTexture,"IMG_LoadTexture");
        lib.bindSymbol(cast(void**)&IMG_LoadTexture_RW,"IMG_LoadTexture_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadTextureTyped_RW,"IMG_LoadTextureTyped_RW");
        lib.bindSymbol(cast(void**)&IMG_isICO,"IMG_isICO");
        lib.bindSymbol(cast(void**)&IMG_isCUR,"IMG_isCUR");
        lib.bindSymbol(cast(void**)&IMG_isBMP,"IMG_isBMP");
        lib.bindSymbol(cast(void**)&IMG_isGIF,"IMG_isGIF");
        lib.bindSymbol(cast(void**)&IMG_isJPG,"IMG_isJPG");
        lib.bindSymbol(cast(void**)&IMG_isLBM,"IMG_isLBM");
        lib.bindSymbol(cast(void**)&IMG_isPCX,"IMG_isPCX");
        lib.bindSymbol(cast(void**)&IMG_isPNG,"IMG_isPNG");
        lib.bindSymbol(cast(void**)&IMG_isPNM,"IMG_isPNM");
        lib.bindSymbol(cast(void**)&IMG_isTIF,"IMG_isTIF");
        lib.bindSymbol(cast(void**)&IMG_isXCF,"IMG_isXCF");
        lib.bindSymbol(cast(void**)&IMG_isXPM,"IMG_isXPM");
        lib.bindSymbol(cast(void**)&IMG_isXV,"IMG_isXV");
        lib.bindSymbol(cast(void**)&IMG_isWEBP,"IMG_isWEBP");
        lib.bindSymbol(cast(void**)&IMG_LoadICO_RW,"IMG_LoadICO_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadCUR_RW,"IMG_LoadCUR_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadBMP_RW,"IMG_LoadBMP_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadGIF_RW,"IMG_LoadGIF_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadJPG_RW,"IMG_LoadJPG_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadLBM_RW,"IMG_LoadLBM_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadPCX_RW,"IMG_LoadPCX_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadPNG_RW,"IMG_LoadPNG_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadPNM_RW,"IMG_LoadPNM_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadTGA_RW,"IMG_LoadTGA_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadTIF_RW,"IMG_LoadTIF_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadXCF_RW,"IMG_LoadXCF_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadXPM_RW,"IMG_LoadXPM_RW");
        lib.bindSymbol(cast(void**)&IMG_LoadXV_RW,"IMG_LoadXV_RW");
        lib.bindSymbol(cast(void**)&IMG_isXV,"IMG_isXV");
        lib.bindSymbol(cast(void**)&IMG_LoadWEBP_RW,"IMG_LoadWEBP_RW");
        lib.bindSymbol(cast(void**)&IMG_SavePNG,"IMG_SavePNG");
        lib.bindSymbol(cast(void**)&IMG_SavePNG_RW,"IMG_SavePNG_RW");

        if(errorCount() != errCount) return SDLImageSupport.badLibrary;
        else loadedVersion = (sdlImageSupport >= SDLImageSupport.sdlImage201) ? SDLImageSupport.sdlImage201 : SDLImageSupport.sdlImage200;

        static if(sdlImageSupport >= SDLImageSupport.sdlImage202) {
            lib.bindSymbol(cast(void**)&IMG_isSVG,"IMG_isSVG");
            lib.bindSymbol(cast(void**)&IMG_LoadSVG,"IMG_LoadSVG_RW");
            lib.bindSymbol(cast(void**)&IMG_SaveJPG,"IMG_SaveJPG");
            lib.bindSymbol(cast(void**)&IMG_SaveJPG_RW,"IMG_SaveJPG_RW");

            if(errorCount() != errCount) return SDLImageSupport.badLibrary;
            else {
                loadedVersion = (sdlImageSupport >= SDLImageSupport.sdlImage205) ? SDLImageSupport.sdlImage205 : sdlImageSupport;
            }
        }

        return loadedVersion;
    }
}
