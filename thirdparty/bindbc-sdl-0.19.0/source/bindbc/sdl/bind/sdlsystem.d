
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlsystem;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrender : SDL_Renderer;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;

version(Android) {
    enum int SDL_ANDROID_EXTERNAL_STORAGE_READ  = 0x01;
    enum int SDL_ANDROID_EXTERNAL_STORAGE_WRITE = 0x02;
}

static if(sdlSupport >= SDLSupport.sdl201) {
    version(Windows) struct IDirect3DDevice9;
}

static if(sdlSupport >= SDLSupport.sdl204) {
    version(Windows) {
        extern(C) nothrow alias SDL_WindowsMessageHook = void function(void*,void*,uint,ulong,long);
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        version(Android) {
            void* SDL_AndroidGetJNIEnv();
            void* SDL_AndroidGetActivity();
            const(char)* SDL_AndroidGetInternalStoragePath();
            int SDL_AndroidGetInternalStorageState();
            const(char)* SDL_AndroidGetExternalStoragePath();

            static if(sdlSupport >= SDLSupport.sdl208) {
                SDL_bool SDL_IsAndroidTV();
            }
            static if(sdlSupport >= SDLSupport.sdl209) {
                SDL_bool SDL_IsChromebook();
                SDL_bool SDL_IsDeXMode();
                void SDL_AndroidBackButton();
            }
            static if(sdlSupport >= SDLSupport.sdl2012) {
                int SDL_GetAndroidSDKVersion();
            }
        }
        else version(Windows) {
            static if(sdlSupport >= SDLSupport.sdl201) {
                int SDL_Direct3D9GetAdapterIndex(int);
                IDirect3DDevice9* SDL_RenderGetD3D9Device(SDL_Renderer*);
            }
            static if(sdlSupport >= SDLSupport.sdl202) {
                SDL_bool SDL_DXGIGetOutputInfo(int,int*,int*);
            }
            static if(sdlSupport >= SDLSupport.sdl204) {
                void SDL_SetWindowsMessageHook(SDL_WindowsMessageHook,void*);
            }
        }
        else version(linux) {
            static if(sdlSupport >= SDLSupport.sdl209) {
                int SDL_LinuxSetThreadPriority(long,int);
            }
        }
    }
}
else {
    version(Android) {
        extern(C) @nogc nothrow {
            alias pSDL_AndroidGetJNIEnv = void* function();
            alias pSDL_AndroidGetActivity = void* function();
            alias pSDL_AndroidGetInternalStoragePath = const(char)* function();
            alias pSDL_AndroidGetInternalStorageState = int function();
            alias pSDL_AndroidGetExternalStoragePath = const(char)* function();
        }

        __gshared {
            pSDL_AndroidGetJNIEnv SDL_AndroidGetJNIEnv;
            pSDL_AndroidGetActivity SDL_AndroidGetActivity;

            pSDL_AndroidGetInternalStoragePath SDL_AndroidGetInternalStoragePath;
            pSDL_AndroidGetInternalStorageState SDL_AndroidGetInternalStorageState;
            pSDL_AndroidGetExternalStoragePath SDL_AndroidGetExternalStoragePath;
        }
        static if(sdlSupport >= SDLSupport.sdl208) {
            extern(C) @nogc nothrow {
                alias pSDL_IsAndroidTV = SDL_bool function();
            }

            __gshared {
                pSDL_IsAndroidTV SDL_IsAndroidTV;
            }
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            extern(C) @nogc nothrow {
                alias pSDL_IsChromebook = SDL_bool function();
                alias pSDL_IsDeXMode = SDL_bool function();
                alias pSDL_AndroidBackButton = void function();
            }

            __gshared {
                pSDL_IsChromebook SDL_IsChromebook;
                pSDL_IsDeXMode SDL_IsDeXMode;
                pSDL_AndroidBackButton SDL_AndroidBackButton;
            }
        }
        static if(sdlSupport >= SDLSupport.sdl2012) {
            extern(C) @nogc nothrow {
                alias pSDL_GetAndroidSDKVersion = int function();
            }

            __gshared {
                pSDL_GetAndroidSDKVersion SDL_GetAndroidSDKVersion;
            }
        }
    }
    else version(Windows) {
        static if(sdlSupport >= SDLSupport.sdl201) {
            extern(C) @nogc nothrow {
                alias pSDL_Direct3D9GetAdapterIndex = int function(int);
                alias pSDL_RenderGetD3D9Device = IDirect3DDevice9* function(SDL_Renderer*);
            }

            __gshared {
                pSDL_Direct3D9GetAdapterIndex SDL_Direct3D9GetAdapterIndex ;
                pSDL_RenderGetD3D9Device SDL_RenderGetD3D9Device;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl202) {
            extern(C) @nogc nothrow {
                alias pSDL_DXGIGetOutputInfo = SDL_bool function(int,int*,int*);
            }

            __gshared {
                pSDL_DXGIGetOutputInfo SDL_DXGIGetOutputInfo;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl204) {
            extern(C) @nogc nothrow {
                alias pSDL_SetWindowsMessageHook = void function(SDL_WindowsMessageHook,void*);
            }

            __gshared {
                pSDL_SetWindowsMessageHook SDL_SetWindowsMessageHook;
            }
        }
    }
    else version(linux) {
        static if(sdlSupport >= SDLSupport.sdl209) {
            extern(C) @nogc nothrow {
                alias pSDL_LinuxSetThreadPriority = int function(long,int);
            }

            __gshared {
                pSDL_LinuxSetThreadPriority SDL_LinuxSetThreadPriority;
            }
        }
    }
}