
//          Copyright Michael D. Parker 2018.
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
        void SDL_LogSetAllPriority(SDL_LogPriority);
        void SDL_LogSetPriority(int,SDL_LogPriority);
        SDL_LogPriority SDL_LogGetPriority(int);
        void SDL_LogResetPriorities();
        void SDL_Log(const(char)*,...);
        void SDL_LogVerbose(int,const(char)*,...);
        void SDL_LogDebug(int,const(char)*,...);
        void SDL_LogInfo(int,const(char)*,...);
        void SDL_LogWarn(int,const(char)*,...);
        void SDL_LogError(int,const(char)*,...);
        void SDL_LogCritical(int,const(char)*,...);
        void SDL_LogMessage(int,SDL_LogPriority,const(char)*,...);
        void SDL_LogMessageV(int,SDL_LogPriority,const(char)*,va_list);
        void SDL_LogGetOutputFunction(SDL_LogOutputFunction,void**);
        void SDL_LogSetOutputFunction(SDL_LogOutputFunction,void*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_LogSetAllPriority = void function(SDL_LogPriority);
        alias pSDL_LogSetPriority = void function(int,SDL_LogPriority);
        alias pSDL_LogGetPriority = SDL_LogPriority function(int);
        alias pSDL_LogResetPriorities = void function();
        alias pSDL_Log = void function(const(char)*,...);
        alias pSDL_LogVerbose = void function(int,const(char)*,...);
        alias pSDL_LogDebug = void function(int,const(char)*,...);
        alias pSDL_LogInfo = void function(int,const(char)*,...);
        alias pSDL_LogWarn = void function(int,const(char)*,...);
        alias pSDL_LogError = void function(int,const(char)*,...);
        alias pSDL_LogCritical = void function(int,const(char)*,...);
        alias pSDL_LogMessage = void function(int,SDL_LogPriority,const(char)*,...);
        alias pSDL_LogMessageV = void function(int,SDL_LogPriority,const(char)*,va_list);
        alias pSDL_LogGetOutputFunction = void function(SDL_LogOutputFunction,void**);
        alias pSDL_LogSetOutputFunction = void function(SDL_LogOutputFunction,void*);
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