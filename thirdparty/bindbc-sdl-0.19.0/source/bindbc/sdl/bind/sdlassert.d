
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlassert;

import bindbc.sdl.config;

enum SDL_assert_state : uint {
    SDL_ASSERTION_RETRY = 0,
    SDL_ASSERTION_BREAK = 1,
    SDL_ASSERTION_ABORT = 2,
    SDL_ASSERTION_IGNORE = 3,
    SDL_ASSERTION_ALWAYS_IGNORE = 4
}
alias SDL_AssertState = SDL_assert_state;
mixin(expandEnum!SDL_AssertState);

struct SDL_assert_data {
    int always_ignore;
    uint trigger_count;
    const(char) *condition;
    const(char) *filename;
    int linenum;
    const(char) *function_;
    const(SDL_assert_data) *next;
}
alias SDL_AssertData = SDL_assert_data;

extern(C) nothrow alias SDL_AssertionHandler = SDL_AssertState function(const(SDL_AssertData)* data, void* userdata);

static if(staticBinding) {
    extern(C) @nogc nothrow {
        void SDL_SetAssertionHandler(SDL_AssertionHandler,void*);
        const(SDL_assert_data)* SDL_GetAssertionReport();
        void SDL_ResetAssertionReport();

        static if(sdlSupport >= SDLSupport.sdl202) {
            SDL_AssertionHandler SDL_GetAssertionHandler(void**);
            SDL_AssertionHandler SDL_GetDefaultAssertionHandler();
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_SetAssertionHandler = void function(SDL_AssertionHandler,void*);
        alias pSDL_GetAssertionReport = const(SDL_assert_data)* function();
        alias pSDL_ResetAssertionReport = void function();
    }

    __gshared {
        pSDL_SetAssertionHandler SDL_SetAssertionHandler;
        pSDL_GetAssertionReport SDL_GetAssertionReport;
        pSDL_ResetAssertionReport SDL_ResetAssertionReport;
    }

    static if(sdlSupport >= SDLSupport.sdl202) {
        extern(C) @nogc nothrow {
            alias pSDL_GetAssertionHandler = SDL_AssertionHandler function(void**);
            alias pSDL_GetDefaultAssertionHandler = SDL_AssertionHandler function();
        }

        __gshared {
            pSDL_GetAssertionHandler SDL_GetAssertionHandler;
            pSDL_GetDefaultAssertionHandler SDL_GetDefaultAssertionHandler;
        }
    }
}
