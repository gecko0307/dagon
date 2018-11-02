
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlrwops;

import core.stdc.stdio : FILE;
import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

enum : uint {
    SDL_RWOPS_UNKNOWN = 0,
    SDL_RWOPS_WINFILE = 1,
    SDL_RWOPS_STDFILE = 2,
    SDL_RWOPS_JNIFILE = 3,
    SDL_RWOPS_MEMORY = 4,
    SDL_RWOPS_MEMORY_RO = 5,
}

struct SDL_RWops {
    extern(C) @nogc nothrow {
        long function(SDL_RWops*) size;
        long function(SDL_RWops*, long, int) seek;
        size_t function(SDL_RWops*, void*, size_t, size_t) read;
        size_t function(SDL_RWops*, const(void)*, size_t, size_t) write;
        int function(SDL_RWops*) close;
    }

    uint type;

    union Hidden {
        // version(Android)
        version(Windows) {
            struct Windowsio {
                int append;
                void* h;
                struct Buffer {
                    void* data;
                    size_t size;
                    size_t left;
                }
                Buffer buffer;
            }
            Windowsio windowsio;
        }

        struct Stdio {
            int autoclose;
            FILE* fp;
        }
        Stdio stdio;

        struct Mem {
            ubyte* base;
            ubyte* here;
            ubyte* stop;
        }
        Mem mem;

        struct Unknown {
            void* data1;
            void* data2;
        }
        Unknown unknown;
    }
    Hidden hidden;
}

enum {
    RW_SEEK_SET = 0,
    RW_SEEK_CUR = 1,
    RW_SEEK_END = 2,
}

@nogc nothrow {
    long SDL_RWsize(SDL_RWops* ctx) { return ctx.size(ctx); }
    long SDL_RWseek(SDL_RWops* ctx, long offset, int whence) { return ctx.seek(ctx, offset, whence); }
    long SDL_RWtell(SDL_RWops* ctx) { return ctx.seek(ctx, 0, RW_SEEK_CUR); }
    size_t SDL_RWread(SDL_RWops* ctx, void* ptr, size_t size, size_t n) { return ctx.read(ctx, ptr, size, n); }
    size_t SDL_RWwrite(SDL_RWops* ctx, const(void)* ptr, size_t size, size_t n) { return ctx.write(ctx, ptr, size, n); }
    int SDL_RWclose(SDL_RWops* ctx) { return ctx.close(ctx); }
}

static if(sdlSupport >= SDLSupport.sdl206) {
    @nogc nothrow
    void* SDL_LoadFile(const(char)* filename, size_t datasize) {
        pragma(inline, true);
        return SDL_LoadFile_RW(SDL_RWFromFile(filename, "rb"), datasize, 1);
    }
}

version(BindSDL_Static)  {
    extern(C) @nogc nothrow {
        SDL_RWops* SDL_RWFromFile(const(char)*,const(char)*);
        SDL_RWops* SDL_RWFromFP(FILE*,SDL_bool);
        SDL_RWops* SDL_RWFromMem(void*,int);
        SDL_RWops* SDL_RWFromConstMem(const(void)*,int);
        SDL_RWops* SDL_AllocRW();
        void SDL_FreeRW(SDL_RWops*);
        ubyte SDL_ReadU8(SDL_RWops*);
        ushort SDL_ReadLE16(SDL_RWops*);
        ushort SDL_ReadBE16(SDL_RWops*);
        uint SDL_ReadLE32(SDL_RWops*);
        uint SDL_ReadBE32(SDL_RWops*);
        ulong SDL_ReadLE64(SDL_RWops*);
        ulong SDL_ReadBE64(SDL_RWops*);
        size_t SDL_WriteU8n(SDL_RWops*,ubyte);
        size_t SDL_WriteLE16(SDL_RWops*,ushort);
        size_t SDL_WriteBE16(SDL_RWops*,ushort);
        size_t SDL_WriteLE32(SDL_RWops*,uint);
        size_t SDL_WriteBE32(SDL_RWops*,uint);
        size_t SDL_WriteLE64(SDL_RWops*,ulong);
        size_t SDL_WriteBE64(SDL_RWops*,ulong);

        static if(sdlSupport >= SDLSupport.sdl206) {
            void* SDL_LoadFile_RW(SDL_RWops*,size_t,int);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_RWFromFile = SDL_RWops* function(const(char)*,const(char)*);
        alias pSDL_RWFromFP = SDL_RWops* function(FILE*,SDL_bool);
        alias pSDL_RWFromMem = SDL_RWops* function(void*,int);
        alias pSDL_RWFromConstMem = SDL_RWops* function(const(void)*,int);
        alias pSDL_AllocRW = SDL_RWops* function();
        alias pSDL_FreeRW = void function(SDL_RWops*);
        alias pSDL_ReadU8 = ubyte function(SDL_RWops*);
        alias pSDL_ReadLE16 = ushort function(SDL_RWops*);
        alias pSDL_ReadBE16 = ushort function(SDL_RWops*);
        alias pSDL_ReadLE32 = uint function(SDL_RWops*);
        alias pSDL_ReadBE32 = uint function(SDL_RWops*);
        alias pSDL_ReadLE64 = ulong function(SDL_RWops*);
        alias pSDL_ReadBE64 = ulong function(SDL_RWops*);
        alias pSDL_WriteU8 = size_t function(SDL_RWops*,ubyte);
        alias pSDL_WriteLE16 = size_t function(SDL_RWops*,ushort);
        alias pSDL_WriteBE16 = size_t function(SDL_RWops*,ushort);
        alias pSDL_WriteLE32 = size_t function(SDL_RWops*,uint);
        alias pSDL_WriteBE32 = size_t function(SDL_RWops*,uint);
        alias pSDL_WriteLE64 = size_t function(SDL_RWops*,ulong);
        alias pSDL_WriteBE64 = size_t function(SDL_RWops*,ulong);
    }

    __gshared {
        pSDL_RWFromFile SDL_RWFromFile;
        pSDL_RWFromFP SDL_RWFromFP;
        pSDL_RWFromMem SDL_RWFromMem;
        pSDL_RWFromConstMem SDL_RWFromConstMem;
        pSDL_AllocRW SDL_AllocRW;
        pSDL_FreeRW SDL_FreeRW;
        pSDL_ReadU8 SDL_ReadU8;
        pSDL_ReadLE16 SDL_ReadLE16;
        pSDL_ReadBE16 SDL_ReadBE16;
        pSDL_ReadLE32 SDL_ReadLE32;
        pSDL_ReadBE32 SDL_ReadBE32;
        pSDL_ReadLE64 SDL_ReadLE64;
        pSDL_ReadBE64 SDL_ReadBE64;
        pSDL_WriteU8 SDL_WriteU8;
        pSDL_WriteLE16 SDL_WriteLE16;
        pSDL_WriteBE16 SDL_WriteBE16;
        pSDL_WriteLE32 SDL_WriteLE32;
        pSDL_WriteBE32 SDL_WriteBE32;
        pSDL_WriteLE64 SDL_WriteLE64;
        pSDL_WriteBE64 SDL_WriteBE64;
    }

    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_LoadFile_RW = void* function(SDL_RWops*,size_t,int);
        }

        __gshared {
            pSDL_LoadFile_RW SDL_LoadFile_RW;
        }
    }
}