
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlmutex;

import bindbc.sdl.config;

enum SDL_MUTEX_TIMEOUT = 1;
enum SDL_MUTEX_MAXWAIT = uint.max;

struct SDL_mutex;
struct SDL_sem;
struct SDL_cond;


static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_mutex* SDL_CreateMutex();
        int SDL_LockMutex(SDL_mutex* mutex);
        int SDL_TryLockMutex(SDL_mutex* mutex);
        int SDL_UnlockMutex(SDL_mutex* mutex);
        void SDL_DestroyMutex(SDL_mutex* mutex);

        SDL_sem* SDL_CreateSemaphore(uint initial_value);
        void SDL_DestroySemaphore(SDL_sem* sem);
        int SDL_SemWait(SDL_sem* sem);
        int SDL_SemWaitTimeout(SDL_sem* sem, uint ms);
        int SDL_SemPost(SDL_sem* sem);
        uint SDL_SemValue(SDL_sem* sem);

        SDL_cond* SDL_CreateCond();
        void SDL_DestroyCond(SDL_cond* cond);
        int SDL_CondSignal(SDL_cond* cond);
        int SDL_CondBroadcast(SDL_cond* cond);
        int SDL_CondWait(SDL_cond* cond,SDL_mutex*);
        int SDL_CondWaitTimeout(SDL_cond* cond, SDL_mutex* mutex, uint ms);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_CreateMutex = SDL_mutex* function();
        alias pSDL_LockMutex = int function(SDL_mutex* mutex);
        alias pSDL_TryLockMutex = int function(SDL_mutex* mutex);
        alias pSDL_UnlockMutex = int function(SDL_mutex* mutex);
        alias pSDL_DestroyMutex = void function(SDL_mutex* mutex);
        alias pSDL_CreateSemaphore = SDL_sem* function(uint initial_value);
        alias pSDL_DestroySemaphore = void function(SDL_sem* sem);

        alias pSDL_SemWait = int function(SDL_sem* sem);
        alias pSDL_SemWaitTimeout = int function(SDL_sem* sem, uint ms);
        alias pSDL_SemPost = int function(SDL_sem* sem);
        alias pSDL_SemValue = uint function(SDL_sem* sem);

        alias pSDL_CreateCond = SDL_cond* function();
        alias pSDL_DestroyCond = void function(SDL_cond* cond);
        alias pSDL_CondSignal = int function(SDL_cond* cond);
        alias pSDL_CondBroadcast = int function(SDL_cond* cond);
        alias pSDL_CondWait = int function(SDL_cond* cond,SDL_mutex*);
        alias pSDL_CondWaitTimeout = int function(SDL_cond* cond, SDL_mutex* mutex, uint ms);
    }

    __gshared {
        pSDL_CreateMutex SDL_CreateMutex;
        pSDL_LockMutex SDL_LockMutex;
        pSDL_TryLockMutex SDL_TryLockMutex;
        pSDL_UnlockMutex SDL_UnlockMutex;
        pSDL_DestroyMutex SDL_DestroyMutex;
        pSDL_CreateSemaphore SDL_CreateSemaphore;
        pSDL_DestroySemaphore SDL_DestroySemaphore;
        pSDL_SemWait SDL_SemWait;
        pSDL_SemWaitTimeout SDL_SemWaitTimeout;
        pSDL_SemPost SDL_SemPost;
        pSDL_SemValue SDL_SemValue;
        pSDL_CreateCond SDL_CreateCond;
        pSDL_DestroyCond SDL_DestroyCond;
        pSDL_CondSignal SDL_CondSignal;
        pSDL_CondBroadcast SDL_CondBroadcast;
        pSDL_CondWait SDL_CondWait;
        pSDL_CondWaitTimeout SDL_CondWaitTimeout;
    }
}