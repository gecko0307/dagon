
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlsyswm;

import core.stdc.config : c_long;
import bindbc.sdl.config;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlversion : SDL_version;
import bindbc.sdl.bind.sdlvideo : SDL_Window;


static if(sdlSupport >= SDLSupport.sdl2012) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
        SDL_SYSWM_WINRT,
        SDL_SYSWM_ANDROID,
        SDL_SYSWM_VIVANTE,
        SDL_SYSWM_OS2,
        SDL_SYSWM_HAIKU,
    }
}
else static if(sdlSupport >= SDLSupport.sdl206) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
        SDL_SYSWM_WINRT,
        SDL_SYSWM_ANDROID,
        SDL_SYSWM_VIVANTE,
        SDL_SYSWM_OS2,
    }
}
else static if(sdlSupport >= SDLSupport.sdl205) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
        SDL_SYSWM_WINRT,
        SDL_SYSWM_ANDROID,
        SDL_SYSWM_VIVANTE,
    }
}
else static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
        SDL_SYSWM_WINRT,
        SDL_SYSWM_ANDROID,
    }
}
else static if(sdlSupport >= SDLSupport.sdl203) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
        SDL_SYSWM_WINRT,
    }
}
else static if(sdlSupport >= SDLSupport.sdl202) {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
        SDL_SYSWM_WAYLAND,
        SDL_SYSWM_MIR,
    }
}
else {
    enum SDL_SYSWM_TYPE {
        SDL_SYSWM_UNKNOWN,
        SDL_SYSWM_WINDOWS,
        SDL_SYSWM_X11,
        SDL_SYSWM_DIRECTFB,
        SDL_SYSWM_COCOA,
        SDL_SYSWM_UIKIT,
    }
}
mixin(expandEnum!SDL_SYSWM_TYPE);

version(Windows) {
    // I don't want to import core.sys.windows.windows just for these
    version(Win64) {
        alias wparam = ulong;
        alias lparam = long;
    }else {
        alias wparam = uint;
        alias lparam = int;
    }
}

struct SDL_SysWMmsg {
    SDL_version version_;
    SDL_SYSWM_TYPE subsystem;
    union msg_ {
        version(Windows) {
            struct win_ {
                void* hwnd;
                uint msg;
                wparam wParam;
                lparam lParam;
            }
            win_ win;
        }
        else version(OSX) {
            struct cocoa_ {
                int dummy;
            }
            cocoa_ cocoa;
        }
        else version(linux) {
            struct dfb_ {
                void* event;
            }
            dfb_ dfb;
        }

        version(Posix) {
            struct x11_ {
                c_long[24] pad; // sufficient size for any X11 event
            }
            x11_ x11;
        }

        static if(sdlSupport >= SDLSupport.sdl205) {
            struct vivante_ {
                int dummy;
            }
            vivante_ vivante;
        }

        int dummy;
    }
    msg_ msg;
}

struct SDL_SysWMinfo {
    SDL_version version_;
    SDL_SYSWM_TYPE subsystem;

    union info_ {
        version(Windows) {
            struct win_ {
               void* window;
               static if(sdlSupport >= SDLSupport.sdl204) void* hdc;
               static if(sdlSupport >= SDLSupport.sdl206) void* hinstance;
            }
            win_ win;
        }
        else version(OSX) {
            struct cocoa_ {
               void* window;
            }
            cocoa_ cocoa;

            struct uikit_ {
                void *window;
            }
            uikit_ uikit;

        }
        else version(linux) {
            struct dfb_ {
                void *dfb;
                void *window;
                void *surface;
            }
            dfb_ dfb;

            static if(sdlSupport >= SDLSupport.sdl202) {
                struct mir_ {
                    void *connection;
                    void *surface;
                }
                mir_ mir;
            }
        }

        version(Posix) {
            struct x11_ {
                void* display;
                uint window;
            }
            x11_ x11;

            static if(sdlSupport >= SDLSupport.sdl202) {
                struct wl_ {
                    void *display;
                    void *surface;
                    void *shell_surface;
                }
                wl_ wl;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl204) {
            version(Android) {
                struct android_ {
                    void* window;
                    void* surface;
                }
                android_ android;
            }
        }

        static if(sdlSupport >= SDLSupport.sdl206) ubyte[64] dummy;
        else int dummy;
    }
    info_ info;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        SDL_bool SDL_GetWindowWMInfo(SDL_Window* window, SDL_SysWMinfo* info);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetWindowWMInfo = SDL_bool function(SDL_Window* window, SDL_SysWMinfo* info);
    }

    __gshared {
        pSDL_GetWindowWMInfo SDL_GetWindowWMInfo;
    }
}
