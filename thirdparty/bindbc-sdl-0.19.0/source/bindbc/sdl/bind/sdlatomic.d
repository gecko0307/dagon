
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlatomic;

version(SDL_No_Atomics) {}
else:

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

alias SDL_SpinLock = int;

struct SDL_atomic_t {
    int value;
}

/*
The best way I can see to implement the barrier macros is to depend on
core.atomic.atomicFence. That should be okay even in BetterC mode since
it's a template. I've already got a dependency on DRuntime (e.g. core.stdc.config),
so I'll import it rather than copy/paste it. I'll change it if it somehow
becomes a problem in the future.
*/
import core.atomic : atomicFence;
alias SDL_CompilerBarrier = atomicFence!();
alias SDL_MemoryBarrierRelease = SDL_CompilerBarrier;
alias SDL_MemoryBarrierAcquire = SDL_CompilerBarrier;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_bool SDL_AtomicTryLock(SDL_SpinLock*);
        void SDL_AtomicLock(SDL_SpinLock*);
        void SDL_AtomicUnlock(SDL_SpinLock);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_AtomicTryLock = SDL_bool function(SDL_SpinLock*);
        alias pSDL_AtomicLock = void function(SDL_SpinLock*);
        alias pSDL_AtomicUnlock = void function(SDL_SpinLock);
    }

    __gshared {
        pSDL_AtomicTryLock SDL_AtomicTryLock;
        pSDL_AtomicLock SDL_AtomicLock;
        pSDL_AtomicUnlock SDL_AtomicUnlock;
    }
}

// Perhaps the following could be replace with the platform-specific intrinsics for GDC, like
// the GCC macros in SDL_atomic.h. I'll have to investigate.
static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_bool SDL_AtomicCAS(SDL_atomic_t*,int,int);
        SDL_bool SDL_AtomicCASPtr(void**,void*,void*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_AtomicCAS = SDL_bool function(SDL_atomic_t*,int,int);
        alias pSDL_AtomicCASPtr = SDL_bool function(void**,void*,void*);
    }

    __gshared {
        pSDL_AtomicCAS SDL_AtomicCAS;
        pSDL_AtomicCASPtr SDL_AtomicCASPtr;
    }
}

int SDL_AtomicSet(SDL_atomic_t* a, int v) {
    pragma(inline, true)
    int value;
    do {
        value = a.value;
    } while(!SDL_AtomicCAS(a, value, v));
    return value;
}

int SDL_AtomicGet(SDL_atomic_t* a) {
    pragma(inline, true)
    int value = a.value;
    SDL_CompilerBarrier();
    return value;
}

int SDL_AtomicAdd(SDL_atomic_t* a, int v) {
    pragma(inline, true)
    int value;
    do {
        value = a.value;
    } while(!SDL_AtomicCAS(a, value, value + v));
    return value;
}

int SDL_AtomicIncRef(SDL_atomic_t* a) {
    pragma(inline, true)
    return SDL_AtomicAdd(a, 1);
}

SDL_bool SDL_AtomicDecRef(SDL_atomic_t* a) {
    pragma(inline, true)
    return cast(SDL_bool)(SDL_AtomicAdd(a, -1) == 1);
}

void* SDL_AtomicSetPtr(void** a, void* v) {
    pragma(inline, true)
    void* value;
    do {
        value = *a;
    } while(!SDL_AtomicCASPtr(a, value, v));
    return value;
}

void* SDL_AtomicGetPtr(void** a) {
    pragma(inline, true)
    void* value = *a;
    SDL_CompilerBarrier();
    return value;
}
