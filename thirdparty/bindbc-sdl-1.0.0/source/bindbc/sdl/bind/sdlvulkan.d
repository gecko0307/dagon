
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlvulkan;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlvideo : SDL_Window;

static if(staticBinding) {
    extern(C) @nogc nothrow {
        static if(sdlSupport >= SDLSupport.sdl206) {
            SDL_bool SDL_Vulkan_CreateSurface(SDL_Window* window, void* instance, void* surface);
            void SDL_Vulkan_GetDrawableSize(SDL_Window* window, int* w, int* h);
            SDL_bool SDL_Vulkan_GetInstanceExtensions(SDL_Window* window, uint* pCount, const(char)** pNames);
            void* SDL_Vulkan_GetVkGetInstanceProcAddr();
            int SDL_Vulkan_LoadLibrary(const(char)* path);
            void SDL_Vulkan_UnloadLibrary();
        }
    }
}
else {
    static if(sdlSupport >= SDLSupport.sdl206) {
        extern(C) @nogc nothrow {
            alias pSDL_Vulkan_CreateSurface = SDL_bool function(SDL_Window* window, void* instance, void* surface);
            alias pSDL_Vulkan_GetDrawableSize = void function(SDL_Window* window, int* w, int* h);
            alias pSDL_Vulkan_GetInstanceExtensions = SDL_bool function(SDL_Window* window, uint* pCount, const(char)** pNames);
            alias pSDL_Vulkan_GetVkGetInstanceProcAddr = void* function();
            alias pSDL_Vulkan_LoadLibrary = int function(const(char)* path);
            alias pSDL_Vulkan_UnloadLibrary = void function();
        }

        __gshared {
            pSDL_Vulkan_CreateSurface SDL_Vulkan_CreateSurface;
            pSDL_Vulkan_GetDrawableSize SDL_Vulkan_GetDrawableSize;
            pSDL_Vulkan_GetInstanceExtensions SDL_Vulkan_GetInstanceExtensions;
            pSDL_Vulkan_GetVkGetInstanceProcAddr SDL_Vulkan_GetVkGetInstanceProcAddr;
            pSDL_Vulkan_LoadLibrary SDL_Vulkan_LoadLibrary;
            pSDL_Vulkan_UnloadLibrary SDL_Vulkan_UnloadLibrary;
        }
    }
}
