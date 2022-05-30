
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlthread;

import core.stdc.config : c_ulong;
import bindbc.sdl.config;

struct SDL_Thread;
alias SDL_threadID = c_ulong;
alias SDL_TLSID = uint;

static if(sdlSupport >= SDLSupport.sdl209) {
    enum SDL_ThreadPriority {
        SDL_THREAD_PRIORITY_LOW,
        SDL_THREAD_PRIORITY_NORMAL,
        SDL_THREAD_PRIORITY_HIGH,
        SDL_THREAD_PRIORITY_TIME_CRITICAL,
    }
}
else {
    enum SDL_ThreadPriority {
        SDL_THREAD_PRIORITY_LOW,
        SDL_THREAD_PRIORITY_NORMAL,
        SDL_THREAD_PRIORITY_HIGH,
    }
}
mixin(expandEnum!SDL_ThreadPriority);

extern(C) nothrow {
    alias SDL_ThreadFunction = int function(void*);
    alias TLSDestructor = void function(void*);
}

version(Windows) {
    /*
    On Windows, SDL_CreateThread/WithStackSize require the _beginthreadex/_endthreadex of
    the caller's process when using the DLL. As best as I can tell, this will be okay even
    when statically linking. If it does break, I'll need to add a new version identifier
    when BindBC_Static is specified in order to distingiuish between linking with the
    DLL's import library and statically linking with SDL.
    */
    private {
        import core.stdc.stdint : uintptr_t;

        extern(Windows) alias btex_fptr = uint function(void*);
        extern(C) @nogc nothrow {
            uintptr_t _beginthreadex(void*,uint,btex_fptr,void*,uint,uint*);
            void _endthreadex(uint);

            alias pfnSDL_CurrentBeginThread = uintptr_t function(void*,uint,btex_fptr,void*,uint,uint*);
            alias pfnSDL_CurrentEndThread = void function(uint);
        }
    }

    SDL_Thread* SDL_CreateThreadImpl(SDL_ThreadFunction fn, const(char)* name, void* data) {
        return SDL_CreateThread(fn, name, data, &_beginthreadex, &_endthreadex);
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        SDL_Thread* SDL_CreateThreadWithStackSizeImpl(SDL_ThreadFunction fn, const(char)* name, const(size_t) stackSize, void* data) {
            return SDL_CreateThreadWithStackSize(fn, name, stackSize, data, &_beginthreadex, &_endthreadex);
        }
    }
}


static if(staticBinding) {
    extern(C) @nogc nothrow {
        version(Windows) SDL_Thread* SDL_CreateThread(SDL_ThreadFunction fn, const(char)* name, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread);
        else SDL_Thread* SDL_CreateThread(SDL_ThreadFunction,const(char)*,void*);

        const(char)* SDL_GetThreadName(SDL_Thread* thread);
        SDL_threadID SDL_ThreadID();
        SDL_threadID SDL_GetThreadID(SDL_Thread* thread);
        int SDL_SetThreadPriority(SDL_ThreadPriority priority);
        void SDL_WaitThread(SDL_Thread* thread, int* status);
        SDL_TLSID SDL_TLSCreate();
        void* SDL_TLSGet(SDL_TLSID id);
        int SDL_TLSSet(SDL_TLSID id,const(void)* value, TLSDestructor destructor);

        static if(sdlSupport >= SDLSupport.sdl202) {
            void SDL_DetachThread(SDL_Thread* thread);
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            version(Windows) SDL_Thread* SDL_CreateThreadWithStackSize(SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread);
            else SDL_Thread* SDL_CreateThreadWithStackSize(SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data);
        }
        static if(sdlSupport >= SDLSupport.sdl2016) {
            void SDL_TLSCleanup();
        }
    }
}
else {
    extern(C) @nogc nothrow {
        version(Windows)alias pSDL_CreateThread = SDL_Thread* function(SDL_ThreadFunction fn, const(char)* name, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread);
        else alias pSDL_CreateThread = SDL_Thread* function(SDL_ThreadFunction fn, const(char)*  name, void* data);

        alias pSDL_GetThreadName = const(char)* function(SDL_Thread* thread);
        alias pSDL_ThreadID = SDL_threadID function();
        alias pSDL_GetThreadID = SDL_threadID function(SDL_Thread* thread);
        alias pSDL_SetThreadPriority = int function(SDL_ThreadPriority priority);
        alias pSDL_WaitThread = void function(SDL_Thread* thread, int* status);
        alias pSDL_TLSCreate = SDL_TLSID function();
        alias pSDL_TLSGet = void* function(SDL_TLSID id);
        alias pSDL_TLSSet = int function(SDL_TLSID id,const(void)* value, TLSDestructor destructor);
    }

    __gshared {
        pSDL_CreateThread SDL_CreateThread;
        pSDL_GetThreadName SDL_GetThreadName;
        pSDL_ThreadID SDL_ThreadID;
        pSDL_GetThreadID SDL_GetThreadID;
        pSDL_SetThreadPriority SDL_SetThreadPriority;
        pSDL_WaitThread SDL_WaitThread;
        pSDL_TLSCreate SDL_TLSCreate;
        pSDL_TLSGet SDL_TLSGet;
        pSDL_TLSSet SDL_TLSSet;
    }

    static if(sdlSupport >= SDLSupport.sdl202) {
        extern(C) @nogc nothrow {
            alias pSDL_DetachThread = void function(SDL_Thread* thread);
        }
        __gshared {
            pSDL_DetachThread SDL_DetachThread;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl209) {

        extern(C) @nogc nothrow {
            version(Windows) alias pSDL_CreateThreadWithStackSize = SDL_Thread* function(SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data, pfnSDL_CurrentBeginThread pfnBeginThread, pfnSDL_CurrentEndThread pfnEndThread);
            else alias pSDL_CreateThreadWithStackSize = SDL_Thread* function(SDL_ThreadFunction fn, const(char)* name, const(size_t) stacksize, void* data);
        }

        __gshared {
            pSDL_CreateThreadWithStackSize SDL_CreateThreadWithStackSize;
        }
    }
    static if(sdlSupport >= SDLSupport.sdl2016) {

        extern(C) @nogc nothrow {
            alias pSDL_TLSCleanup = void function();
        }

        __gshared {
            pSDL_TLSCleanup SDL_TLSCleanup;
        }
    }
}
