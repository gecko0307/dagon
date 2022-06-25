
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdllog;

import core.stdc.stdarg : va_list;
import bindbc.sdl.config;

enum SDL_MAX_LOG_MESSAGE = 4096;

enum SDL_LogCategory {
    SDL_LOG_CATEGORY_APPLICATION,
    SDL_LOG_CATEGORY_ERROR,
    SDL_LOG_CATEGORY_ASSERT,
    SDL_LOG_CATEGORY_SYSTEM,
    SDL_LOG_CATEGORY_AUDIO,
    SDL_LOG_CATEGORY_VIDEO,
    SDL_LOG_CATEGORY_RENDER,
    SDL_LOG_CATEGORY_INPUT,
    SDL_LOG_CATEGORY_TEST,

    SDL_LOG_CATEGORY_RESERVED1,
    SDL_LOG_CATEGORY_RESERVED2,
    SDL_LOG_CATEGORY_RESERVED3,
    SDL_LOG_CATEGORY_RESERVED4,
    SDL_LOG_CATEGORY_RESERVED5,
    SDL_LOG_CATEGORY_RESERVED6,
    SDL_LOG_CATEGORY_RESERVED7,
    SDL_LOG_CATEGORY_RESERVED8,
    SDL_LOG_CATEGORY_RESERVED9,
    SDL_LOG_CATEGORY_RESERVED10,

    SDL_LOG_CATEGORY_CUSTOM
}
mixin(expandEnum!SDL_LogCategory);

enum SDL_LogPriority {
    SDL_LOG_PRIORITY_VERBOSE = 1,
    SDL_LOG_PRIORITY_DEBUG,
    SDL_LOG_PRIORITY_INFO,
    SDL_LOG_PRIORITY_WARN,
    SDL_LOG_PRIORITY_ERROR,
    SDL_LOG_PRIORITY_CRITICAL,
    SDL_NUM_LOG_PRIORITIES
}
mixin(expandEnum!SDL_LogPriority);

extern(C) nothrow alias SDL_LogOutputFunction = void function(void*, int, SDL_LogPriority, const(char)*);

static if(staticBinding) {
    extern(C) @nogc nothrow {
        void SDL_LogSetAllPriority(SDL_LogPriority priority);
        void SDL_LogSetPriority(int,SDL_LogPriority priority);
        SDL_LogPriority SDL_LogGetPriority(int category);
        void SDL_LogResetPriorities();
        void SDL_Log(const(char)* fmt,...);
        void SDL_LogVerbose(int category, const(char)* fmt,...);
        void SDL_LogDebug(int category, const(char)* fmt,...);
        void SDL_LogInfo(int category, const(char)* fmt,...);
        void SDL_LogWarn(int category, const(char)* fmt,...);
        void SDL_LogError(int category, const(char)* fmt,...);
        void SDL_LogCritical(int category, const(char)* fmt,...);
        void SDL_LogMessage(int category,SDL_LogPriority, const(char)* fmt,...);
        void SDL_LogMessageV(int category,SDL_LogPriority, const(char)* fmt, va_list ap);
        void SDL_LogGetOutputFunction(SDL_LogOutputFunction callback, void** userdata);
        void SDL_LogSetOutputFunction(SDL_LogOutputFunction callback,void* userdata);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_LogSetAllPriority = void function(SDL_LogPriority priority);
        alias pSDL_LogSetPriority = void function(int category,SDL_LogPriority priority);
        alias pSDL_LogGetPriority = SDL_LogPriority function(int category);
        alias pSDL_LogResetPriorities = void function();
        alias pSDL_Log = void function(const(char)* fmt,...);
        alias pSDL_LogVerbose = void function(int category, const(char)* fmt,...);
        alias pSDL_LogDebug = void function(int category, const(char)* fmt,...);
        alias pSDL_LogInfo = void function(int category, const(char)* fmt,...);
        alias pSDL_LogWarn = void function(int category, const(char)* fmt,...);
        alias pSDL_LogError = void function(int category, const(char)* fmt,...);
        alias pSDL_LogCritical = void function(int category, const(char)* fmt,...);
        alias pSDL_LogMessage = void function(int category,SDL_LogPriority, const(char)* fmt,...);
        alias pSDL_LogMessageV = void function(int category,SDL_LogPriority, const(char)* fmt, va_list ap);
        alias pSDL_LogGetOutputFunction = void function(SDL_LogOutputFunction callback, void** userdata);
        alias pSDL_LogSetOutputFunction = void function(SDL_LogOutputFunction callback,void* userdata);
    }

    __gshared {
        pSDL_LogSetAllPriority SDL_LogSetAllPriority;
        pSDL_LogSetPriority SDL_LogSetPriority;
        pSDL_LogGetPriority SDL_LogGetPriority;
        pSDL_LogResetPriorities SDL_LogResetPriorities;
        pSDL_Log SDL_Log;
        pSDL_LogVerbose SDL_LogVerbose;
        pSDL_LogDebug SDL_LogDebug;
        pSDL_LogInfo SDL_LogInfo;
        pSDL_LogWarn SDL_LogWarn;
        pSDL_LogError SDL_LogError;
        pSDL_LogCritical SDL_LogCritical;
        pSDL_LogMessage SDL_LogMessage;
        pSDL_LogMessageV SDL_LogMessageV;
        pSDL_LogGetOutputFunction SDL_LogGetOutputFunction;
        pSDL_LogSetOutputFunction SDL_LogSetOutputFunction;
    }
}