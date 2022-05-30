
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlvideo;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrect : SDL_Rect;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlsurface : SDL_Surface;

struct SDL_DisplayMode {
    uint format;
    int w;
    int h;
    int refresh_rate;
    void* driverdata;
}

struct SDL_Window;

// SDL_WindowFlags
enum uint SDL_WINDOW_FULLSCREEN = 0x00000001;
enum uint SDL_WINDOW_OPENGL = 0x00000002;
enum uint SDL_WINDOW_SHOWN = 0x00000004;
enum uint SDL_WINDOW_HIDDEN = 0x00000008;
enum uint SDL_WINDOW_BORDERLESS = 0x00000010;
enum uint SDL_WINDOW_RESIZABLE = 0x00000020;
enum uint SDL_WINDOW_MINIMIZED = 0x00000040;
enum uint SDL_WINDOW_MAXIMIZED = 0x00000080;
enum uint SDL_WINDOW_INPUT_GRABBED = 0x00000100;
enum uint SDL_WINDOW_INPUT_FOCUS = 0x00000200;
enum uint SDL_WINDOW_MOUSE_FOCUS = 0x00000400;
enum uint SDL_WINDOW_FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN | 0x00001000;
enum uint SDL_WINDOW_FOREIGN = 0x00000800;
static if(sdlSupport >= SDLSupport.sdl201) {
    enum uint SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000;
}
static if(sdlSupport >= SDLSupport.sdl204) {
    enum uint SDL_WINDOW_MOUSE_CAPTURE = 0x00004000;
}
static if(sdlSupport >= SDLSupport.sdl205) {
    enum uint SDL_WINDOW_ALWAYS_ON_TOP = 0x00008000;
    enum uint SDL_WINDOW_SKIP_TASKBAR  = 0x00010000;
    enum uint SDL_WINDOW_UTILITY = 0x00020000;
    enum uint SDL_WINDOW_TOOLTIP = 0x00040000;
    enum uint SDL_WINDOW_POPUP_MENU = 0x00080000;
}
static if(sdlSupport >= SDLSupport.sdl206) {
    enum uint SDL_WINDOW_VULKAN = 0x10000000;
}
static if(sdlSupport >= SDLSupport.sdl206) {
    enum uint SDL_WINDOW_METAL = 0x20000000;
}
static if(sdlSupport >= SDLSupport.sdl2016) {
    enum uint SDL_WINDOW_MOUSE_GRABBED = SDL_WINDOW_INPUT_GRABBED;
    enum uint SDL_WINDOW_KEYBOARD_GRABBED = 0x00100000;
}
alias SDL_WindowFlags = uint;

enum uint SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF0000;
enum uint SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_DISPLAY(0);

enum uint SDL_WINDOWPOS_CENTERED_MASK = 0x2FFF0000;
enum uint SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_DISPLAY(0);

@safe @nogc nothrow pure {
    uint SDL_WINDOWPOS_UNDEFINED_DISPLAY(uint x) { return SDL_WINDOWPOS_UNDEFINED_MASK | x; }
    uint SDL_WINDOWPOS_ISUNDEFINED(uint x) { return (x & 0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK; }
    uint SDL_WINDOWPOS_CENTERED_DISPLAY(uint x) { return SDL_WINDOWPOS_CENTERED_MASK | x; }
    uint SDL_WINDOWPOS_ISCENTERED(uint x) { return (x & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK; }
}

static if(sdlSupport >= SDLSupport.sdl2018) {
    enum SDL_WindowEventID : ubyte {
        SDL_WINDOWEVENT_NONE,
        SDL_WINDOWEVENT_SHOWN,
        SDL_WINDOWEVENT_HIDDEN,
        SDL_WINDOWEVENT_EXPOSED,
        SDL_WINDOWEVENT_MOVED,
        SDL_WINDOWEVENT_RESIZED,
        SDL_WINDOWEVENT_SIZE_CHANGED,
        SDL_WINDOWEVENT_MINIMIZED,
        SDL_WINDOWEVENT_MAXIMIZED,
        SDL_WINDOWEVENT_RESTORED,
        SDL_WINDOWEVENT_ENTER,
        SDL_WINDOWEVENT_LEAVE,
        SDL_WINDOWEVENT_FOCUS_GAINED,
        SDL_WINDOWEVENT_FOCUS_LOST,
        SDL_WINDOWEVENT_CLOSE,
        SDL_WINDOWEVENT_TAKE_FOCUS,
        SDL_WINDOWEVENT_HIT_TEST,
        SDL_WINDOWEVENT_ICCPROF_CHANGED,
        SDL_WINDOWEVENT_DISPLAY_CHANGED,
    }

}
else static if(sdlSupport >= SDLSupport.sdl205) {
    enum SDL_WindowEventID : ubyte {
        SDL_WINDOWEVENT_NONE,
        SDL_WINDOWEVENT_SHOWN,
        SDL_WINDOWEVENT_HIDDEN,
        SDL_WINDOWEVENT_EXPOSED,
        SDL_WINDOWEVENT_MOVED,
        SDL_WINDOWEVENT_RESIZED,
        SDL_WINDOWEVENT_SIZE_CHANGED,
        SDL_WINDOWEVENT_MINIMIZED,
        SDL_WINDOWEVENT_MAXIMIZED,
        SDL_WINDOWEVENT_RESTORED,
        SDL_WINDOWEVENT_ENTER,
        SDL_WINDOWEVENT_LEAVE,
        SDL_WINDOWEVENT_FOCUS_GAINED,
        SDL_WINDOWEVENT_FOCUS_LOST,
        SDL_WINDOWEVENT_CLOSE,
        SDL_WINDOWEVENT_TAKE_FOCUS,
        SDL_WINDOWEVENT_HIT_TEST,
    }

}
else {
    enum SDL_WindowEventID : ubyte {
        SDL_WINDOWEVENT_NONE,
        SDL_WINDOWEVENT_SHOWN,
        SDL_WINDOWEVENT_HIDDEN,
        SDL_WINDOWEVENT_EXPOSED,
        SDL_WINDOWEVENT_MOVED,
        SDL_WINDOWEVENT_RESIZED,
        SDL_WINDOWEVENT_SIZE_CHANGED,
        SDL_WINDOWEVENT_MINIMIZED,
        SDL_WINDOWEVENT_MAXIMIZED,
        SDL_WINDOWEVENT_RESTORED,
        SDL_WINDOWEVENT_ENTER,
        SDL_WINDOWEVENT_LEAVE,
        SDL_WINDOWEVENT_FOCUS_GAINED,
        SDL_WINDOWEVENT_FOCUS_LOST,
        SDL_WINDOWEVENT_CLOSE,
    }
}
mixin(expandEnum!SDL_WindowEventID);

static if(sdlSupport >= SDLSupport.sdl2014) {
    enum SDL_DisplayEventID {
        SDL_DISPLAYEVENT_NONE,
        SDL_DISPLAYEVENT_ORIENTATION,
        SDL_DISPLAYEVENT_CONNECTED,
        SDL_DISPLAYEVENT_DISCONNECTED,
    }
    mixin(expandEnum!SDL_DisplayEventID);
}
else static if(sdlSupport >= SDLSupport.sdl209) {
    enum SDL_DisplayEventID {
        SDL_DISPLAYEVENT_NONE,
        SDL_DISPLAYEVENT_ORIENTATION,
    }
    mixin(expandEnum!SDL_DisplayEventID);
}

static if(sdlSupport >= SDLSupport.sdl209) {
    enum SDL_DisplayOrientation {
        SDL_ORIENTATION_UNKNOWN,
        SDL_ORIENTATION_LANDSCAPE,
        SDL_ORIENTATION_LANDSCAPE_FLIPPED,
        SDL_ORIENTATION_PORTRAIT,
        SDL_ORIENTATION_PORTRAIT_FLIPPED,
    }
    mixin(expandEnum!SDL_DisplayOrientation);
}

static if(sdlSupport >= SDLSupport.sdl2016) {
    enum SDL_FlashOperation {
        SDL_FLASH_CANCEL,
        SDL_FLASH_BRIEFLY,
        SDL_FLASH_UNTIL_FOCUSED
    }
    mixin(expandEnum!SDL_FlashOperation);
}

alias SDL_GLContext = void*;

static if(sdlSupport >= SDLSupport.sdl206) {
    enum SDL_GLattr {
        SDL_GL_RED_SIZE,
        SDL_GL_GREEN_SIZE,
        SDL_GL_BLUE_SIZE,
        SDL_GL_ALPHA_SIZE,
        SDL_GL_BUFFER_SIZE,
        SDL_GL_DOUBLEBUFFER,
        SDL_GL_DEPTH_SIZE,
        SDL_GL_STENCIL_SIZE,
        SDL_GL_ACCUM_RED_SIZE,
        SDL_GL_ACCUM_GREEN_SIZE,
        SDL_GL_ACCUM_BLUE_SIZE,
        SDL_GL_ACCUM_ALPHA_SIZE,
        SDL_GL_STEREO,
        SDL_GL_MULTISAMPLEBUFFERS,
        SDL_GL_MULTISAMPLESAMPLES,
        SDL_GL_ACCELERATED_VISUAL,
        SDL_GL_RETAINED_BACKING,
        SDL_GL_CONTEXT_MAJOR_VERSION,
        SDL_GL_CONTEXT_MINOR_VERSION,
        SDL_GL_CONTEXT_EGL,
        SDL_GL_CONTEXT_FLAGS,
        SDL_GL_CONTEXT_PROFILE_MASK,
        SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
        SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
        SDL_GL_RELEASE_BEHAVIOR,
        SDL_GL_CONTEXT_RESET_NOTIFICATION,
        SDL_GL_CONTEXT_NO_ERROR,
    }
}
else static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_GLattr {
        SDL_GL_RED_SIZE,
        SDL_GL_GREEN_SIZE,
        SDL_GL_BLUE_SIZE,
        SDL_GL_ALPHA_SIZE,
        SDL_GL_BUFFER_SIZE,
        SDL_GL_DOUBLEBUFFER,
        SDL_GL_DEPTH_SIZE,
        SDL_GL_STENCIL_SIZE,
        SDL_GL_ACCUM_RED_SIZE,
        SDL_GL_ACCUM_GREEN_SIZE,
        SDL_GL_ACCUM_BLUE_SIZE,
        SDL_GL_ACCUM_ALPHA_SIZE,
        SDL_GL_STEREO,
        SDL_GL_MULTISAMPLEBUFFERS,
        SDL_GL_MULTISAMPLESAMPLES,
        SDL_GL_ACCELERATED_VISUAL,
        SDL_GL_RETAINED_BACKING,
        SDL_GL_CONTEXT_MAJOR_VERSION,
        SDL_GL_CONTEXT_MINOR_VERSION,
        SDL_GL_CONTEXT_EGL,
        SDL_GL_CONTEXT_FLAGS,
        SDL_GL_CONTEXT_PROFILE_MASK,
        SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
        SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
        SDL_GL_RELEASE_BEHAVIOR,
    }
}
else static if(sdlSupport >= SDLSupport.sdl201) {
    enum SDL_GLattr {
        SDL_GL_RED_SIZE,
        SDL_GL_GREEN_SIZE,
        SDL_GL_BLUE_SIZE,
        SDL_GL_ALPHA_SIZE,
        SDL_GL_BUFFER_SIZE,
        SDL_GL_DOUBLEBUFFER,
        SDL_GL_DEPTH_SIZE,
        SDL_GL_STENCIL_SIZE,
        SDL_GL_ACCUM_RED_SIZE,
        SDL_GL_ACCUM_GREEN_SIZE,
        SDL_GL_ACCUM_BLUE_SIZE,
        SDL_GL_ACCUM_ALPHA_SIZE,
        SDL_GL_STEREO,
        SDL_GL_MULTISAMPLEBUFFERS,
        SDL_GL_MULTISAMPLESAMPLES,
        SDL_GL_ACCELERATED_VISUAL,
        SDL_GL_RETAINED_BACKING,
        SDL_GL_CONTEXT_MAJOR_VERSION,
        SDL_GL_CONTEXT_MINOR_VERSION,
        SDL_GL_CONTEXT_EGL,
        SDL_GL_CONTEXT_FLAGS,
        SDL_GL_CONTEXT_PROFILE_MASK,
        SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
        SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
    }
}
else {
    enum SDL_GLattr {
        SDL_GL_RED_SIZE,
        SDL_GL_GREEN_SIZE,
        SDL_GL_BLUE_SIZE,
        SDL_GL_ALPHA_SIZE,
        SDL_GL_BUFFER_SIZE,
        SDL_GL_DOUBLEBUFFER,
        SDL_GL_DEPTH_SIZE,
        SDL_GL_STENCIL_SIZE,
        SDL_GL_ACCUM_RED_SIZE,
        SDL_GL_ACCUM_GREEN_SIZE,
        SDL_GL_ACCUM_BLUE_SIZE,
        SDL_GL_ACCUM_ALPHA_SIZE,
        SDL_GL_STEREO,
        SDL_GL_MULTISAMPLEBUFFERS,
        SDL_GL_MULTISAMPLESAMPLES,
        SDL_GL_ACCELERATED_VISUAL,
        SDL_GL_RETAINED_BACKING,
        SDL_GL_CONTEXT_MAJOR_VERSION,
        SDL_GL_CONTEXT_MINOR_VERSION,
        SDL_GL_CONTEXT_EGL,
        SDL_GL_CONTEXT_FLAGS,
        SDL_GL_CONTEXT_PROFILE_MASK,
        SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
    }
}
mixin(expandEnum!SDL_GLattr);

enum SDL_GLprofile  {
    SDL_GL_CONTEXT_PROFILE_CORE = 0x0001,
    SDL_GL_CONTEXT_PROFILE_COMPATIBILITY = 0x0002,
    SDL_GL_CONTEXT_PROFILE_ES = 0x0004,
}
mixin(expandEnum!SDL_GLprofile);

enum {
    SDL_GL_CONTEXT_DEBUG_FLAG = 0x0001,
    SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
    SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG = 0x0004,
    SDL_GL_CONTEXT_RESET_ISOLATION_FLAG = 0x0008,
}
alias SDL_GLcontextFlag = int;

static if(sdlSupport >= SDLSupport.sdl204) {
    enum SDL_GLcontextReleaseFlag {
        SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE    = 0x0000,
        SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH   = 0x0001,
    }
    mixin(expandEnum!SDL_GLcontextReleaseFlag);

    enum SDL_HitTestResult {
        SDL_HITTEST_NORMAL,
        SDL_HITTEST_DRAGGABLE,
        SDL_HITTEST_RESIZE_TOPLEFT,
        SDL_HITTEST_RESIZE_TOP,
        SDL_HITTEST_RESIZE_TOPRIGHT,
        SDL_HITTEST_RESIZE_RIGHT,
        SDL_HITTEST_RESIZE_BOTTOMRIGHT,
        SDL_HITTEST_RESIZE_BOTTOM,
        SDL_HITTEST_RESIZE_BOTTOMLEFT,
        SDL_HITTEST_RESIZE_LEFT,
    }
    mixin(expandEnum!SDL_HitTestResult);

    import bindbc.sdl.bind.sdlrect : SDL_Point;
    extern(C) nothrow alias SDL_HitTest = SDL_HitTestResult function(SDL_Window*,const(SDL_Point)*,void*);
}

static if(sdlSupport >= SDLSupport.sdl206) {
    enum SDL_GLContextResetNotification {
        SDL_GL_CONTEXT_RESET_NO_NOTIFICATION = 0x0000,
        SDL_GL_CONTEXT_RESET_LOSE_CONTEXT    = 0x0001,
    }
    mixin(expandEnum!SDL_GLContextResetNotification);
}

 

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_GetNumVideoDrivers();
        const(char)* SDL_GetVideoDriver(int index);
        int SDL_VideoInit(const(char)* driver_name);
        void SDL_VideoQuit();
        const(char)* SDL_GetCurrentVideoDriver();
        int SDL_GetNumVideoDisplays();
        const(char)* SDL_GetDisplayName(int displayIndex);
        int SDL_GetDisplayBounds(int displayIndex, SDL_Rect* rect);
        int SDL_GetNumDisplayModes(int displayIndex);
        int SDL_GetDisplayMode(int displayIndex, int modeIndex, SDL_DisplayMode* mode);
        int SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode* mode);
        int SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode* mode);
        SDL_DisplayMode* SDL_GetClosestDisplayMode(int displayIndex, const(SDL_DisplayMode)* mode, SDL_DisplayMode* closest);
        int SDL_GetWindowDisplayIndex(SDL_Window* window);
        int SDL_SetWindowDisplayMode(SDL_Window* window, const(SDL_DisplayMode)* mode);
        int SDL_GetWindowDisplayMode(SDL_Window* window, SDL_DisplayMode* mode);
        uint SDL_GetWindowPixelFormat(SDL_Window* window);
        SDL_Window* SDL_CreateWindow(const(char)* title, int x, int y, int w, int h, SDL_WindowFlags flags);
        SDL_Window* SDL_CreateWindowFrom(const(void)* data);
        uint SDL_GetWindowID(SDL_Window* window);
        SDL_Window* SDL_GetWindowFromID(uint id);
        SDL_WindowFlags SDL_GetWindowFlags(SDL_Window* window);
        void SDL_SetWindowTitle(SDL_Window* window, const(char)* title);
        const(char)* SDL_GetWindowTitle(SDL_Window* window);
        void SDL_SetWindowIcon(SDL_Window* window, SDL_Surface* icon);
        void* SDL_SetWindowData(SDL_Window* window, const(char)* name, void* userdata);
        void* SDL_GetWindowData(SDL_Window* window, const(char)* name);
        void SDL_SetWindowPosition(SDL_Window* window, int x, int y);
        void SDL_GetWindowPosition(SDL_Window* window, int* x, int* y);
        void SDL_SetWindowSize(SDL_Window* window, int w, int h);
        void SDL_GetWindowSize(SDL_Window* window, int* w, int* h);
        void SDL_SetWindowMinimumSize(SDL_Window* window, int min_w, int min_h);
        void SDL_GetWindowMinimumSize(SDL_Window* window, int* w, int* h);
        void SDL_SetWindowMaximumSize(SDL_Window* window, int max_w, int max_h);
        void SDL_GetWindowMaximumSize(SDL_Window* window, int* w, int* h);
        void SDL_SetWindowBordered(SDL_Window* window, SDL_bool bordered);
        void SDL_ShowWindow(SDL_Window* window);
        void SDL_HideWindow(SDL_Window* window);
        void SDL_RaiseWindow(SDL_Window* window);
        void SDL_MaximizeWindow(SDL_Window* window);
        void SDL_MinimizeWindow(SDL_Window* window);
        void SDL_RestoreWindow(SDL_Window* window);
        int SDL_SetWindowFullscreen(SDL_Window* window, SDL_WindowFlags flags);
        SDL_Surface* SDL_GetWindowSurface(SDL_Window* window);
        int SDL_UpdateWindowSurface(SDL_Window* window);
        int SDL_UpdateWindowSurfaceRects(SDL_Window* window, SDL_Rect* rects, int numrects);
        void SDL_SetWindowGrab(SDL_Window* window, SDL_bool grabbed);
        SDL_bool SDL_GetWindowGrab(SDL_Window* window);
        int SDL_SetWindowBrightness(SDL_Window* window, float brightness);
        float SDL_GetWindowBrightness(SDL_Window* window);
        int SDL_SetWindowGammaRamp(SDL_Window* window, const(ushort)* red, const(ushort)* green, const(ushort)* blue);
        int SDL_GetWindowGammaRamp(SDL_Window* window, ushort* red, ushort* green, ushort* blue);
        void SDL_DestroyWindow(SDL_Window* window);
        SDL_bool SDL_IsScreenSaverEnabled();
        void SDL_EnableScreenSaver();
        void SDL_DisableScreenSaver();
        int SDL_GL_LoadLibrary(const(char)* path);
        void* SDL_GL_GetProcAddress(const(char)* proc);
        void SDL_GL_UnloadLibrary();
        SDL_bool SDL_GL_ExtensionSupported(const(char)* extension);
        int SDL_GL_SetAttribute(SDL_GLattr attr, int value);
        int SDL_GL_GetAttribute(SDL_GLattr attr, int* value);
        SDL_GLContext SDL_GL_CreateContext(SDL_Window* window);
        int SDL_GL_MakeCurrent(SDL_Window* window, SDL_GLContext context);
        SDL_Window* SDL_GL_GetCurrentWindow();
        SDL_GLContext SDL_GL_GetCurrentContext();
        int SDL_GL_SetSwapInterval(int interval);
        int SDL_GL_GetSwapInterval();
        void SDL_GL_SwapWindow(SDL_Window* window);
        void SDL_GL_DeleteContext(SDL_GLContext context);

        static if(sdlSupport >= SDLSupport.sdl201) {
            void SDL_GL_GetDrawableSize(SDL_Window* window, int* w, int* h);
        }
        static if(sdlSupport >= SDLSupport.sdl202) {
            void SDL_GL_ResetAttributes();
        }
        static if(sdlSupport >= SDLSupport.sdl204) {
            int SDL_GetDisplayDPI(int displayIndex, float* ddpi, float* hdpi, float* vdpi);
            SDL_Window* SDL_GetGrabbedWindow();
            int SDL_SetWindowHitTest(SDL_Window* window, SDL_HitTest callback, void* callback_data);
        }
        static if(sdlSupport >= SDLSupport.sdl205) {
            int SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect* rect);
            int SDL_GetWindowBordersSize(SDL_Window* window, int* top, int* left, int* bottom, int* right);
            int SDL_GetWindowOpacity(SDL_Window* window, float* opacity);
            int SDL_SetWindowInputFocus(SDL_Window* window);
            int SDL_SetWindowModalFor(SDL_Window* modal_window, SDL_Window* parent_window);
            int SDL_SetWindowOpacity(SDL_Window* window, float opacity);
            void SDL_SetWindowResizable(SDL_Window* window, SDL_bool resizable);
        }
        static if(sdlSupport >= SDLSupport.sdl209) {
            SDL_DisplayOrientation SDL_GetDisplayOrientation(int displayIndex);
        }
        static if(sdlSupport >= SDLSupport.sdl2016) {
            int SDL_FlashWindow(SDL_Window* window, SDL_FlashOperation operation);
            void SDL_SetWindowAlwaysOnTop(SDL_Window* window, SDL_bool on_top);
            void SDL_SetWindowKeyboardGrab(SDL_Window* window, SDL_bool grabbed);
            SDL_bool SDL_GetWindowKeyboardGrab(SDL_Window * window);
            void SDL_SetWindowMouseGrab(SDL_Window* window, SDL_bool grabbed);
            SDL_bool SDL_GetWindowMouseGrab(SDL_Window* window);
        }
        static if(sdlSupport >= SDLSupport.sdl2018) {
            void* SDL_GetWindowICCProfile(SDL_Window* window, size_t* size);
            int SDL_SetWindowMouseRect(SDL_Window* window, const(SDL_Rect)* rect);
            const(SDL_Rect)* SDL_GetWindowMouseRect(SDL_Window* window);
            
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumVideoDrivers = int function();
        alias pSDL_GetVideoDriver = const(char)* function(int index);
        alias pSDL_VideoInit = int function(const(char)* driver_name);
        alias pSDL_VideoQuit = void function();
        alias pSDL_GetCurrentVideoDriver = const(char)* function();
        alias pSDL_GetNumVideoDisplays = int function();
        alias pSDL_GetDisplayName = const(char)* function(int displayIndex);
        alias pSDL_GetDisplayBounds = int function(int displayIndex, SDL_Rect* rect);
        alias pSDL_GetNumDisplayModes = int function(int displayIndex);
        alias pSDL_GetDisplayMode = int function(int displayIndex, int modeIndex, SDL_DisplayMode* mode);
        alias pSDL_GetDesktopDisplayMode = int function(int displayIndex, SDL_DisplayMode* mode);
        alias pSDL_GetCurrentDisplayMode = int function(int displayIndex, SDL_DisplayMode* mode);
        alias pSDL_GetClosestDisplayMode = SDL_DisplayMode* function(int displayIndex, const(SDL_DisplayMode)* mode, SDL_DisplayMode* closest);
        alias pSDL_GetWindowDisplayIndex = int function(SDL_Window* window);
        alias pSDL_SetWindowDisplayMode = int function(SDL_Window* window, const(SDL_DisplayMode)* mode);
        alias pSDL_GetWindowDisplayMode = int function(SDL_Window* window, SDL_DisplayMode* mode);
        alias pSDL_GetWindowPixelFormat = uint function(SDL_Window* window);
        alias pSDL_CreateWindow = SDL_Window* function(const(char)* title, int x, int y, int w, int h, SDL_WindowFlags flags);
        alias pSDL_CreateWindowFrom = SDL_Window* function(const(void)* data);
        alias pSDL_GetWindowID = uint function(SDL_Window* window);
        alias pSDL_GetWindowFromID = SDL_Window* function(uint id);
        alias pSDL_GetWindowFlags = SDL_WindowFlags function(SDL_Window* window);
        alias pSDL_SetWindowTitle = void function(SDL_Window* window, const(char)* title);
        alias pSDL_GetWindowTitle = const(char)* function(SDL_Window* window);
        alias pSDL_SetWindowIcon = void function(SDL_Window* window, SDL_Surface* icon);
        alias pSDL_SetWindowData = void* function(SDL_Window* window, const(char)* name, void* userdata);
        alias pSDL_GetWindowData = void* function(SDL_Window* window, const(char)* name);
        alias pSDL_SetWindowPosition = void function(SDL_Window* window, int x, int y);
        alias pSDL_GetWindowPosition = void function(SDL_Window* window, int* x, int* y);
        alias pSDL_SetWindowSize = void function(SDL_Window* window, int w, int h);
        alias pSDL_GetWindowSize = void function(SDL_Window* window, int* w, int* h);
        alias pSDL_SetWindowMinimumSize = void function(SDL_Window* window, int min_w, int min_h);
        alias pSDL_GetWindowMinimumSize = void function(SDL_Window* window, int* w, int* h);
        alias pSDL_SetWindowMaximumSize = void function(SDL_Window* window, int max_w, int max_h);
        alias pSDL_GetWindowMaximumSize = void function(SDL_Window* window, int* w, int* h);
        alias pSDL_SetWindowBordered = void function(SDL_Window* window, SDL_bool bordered);
        alias pSDL_ShowWindow = void function(SDL_Window* window);
        alias pSDL_HideWindow = void function(SDL_Window* window);
        alias pSDL_RaiseWindow = void function(SDL_Window* window);
        alias pSDL_MaximizeWindow = void function(SDL_Window* window);
        alias pSDL_MinimizeWindow = void function(SDL_Window* window);
        alias pSDL_RestoreWindow = void function(SDL_Window* window);
        alias pSDL_SetWindowFullscreen = int function(SDL_Window* window, SDL_WindowFlags flags);
        alias pSDL_GetWindowSurface = SDL_Surface* function(SDL_Window* window);
        alias pSDL_UpdateWindowSurface = int function(SDL_Window* window);
        alias pSDL_UpdateWindowSurfaceRects = int function(SDL_Window* window, SDL_Rect* rects, int numrects);
        alias pSDL_SetWindowGrab = void function(SDL_Window* window, SDL_bool grabbed);
        alias pSDL_GetWindowGrab = SDL_bool function(SDL_Window* window);
        alias pSDL_SetWindowBrightness = int function(SDL_Window* window, float brightness);
        alias pSDL_GetWindowBrightness = float function(SDL_Window* window);
        alias pSDL_SetWindowGammaRamp = int function(SDL_Window* window, const(ushort)* red, const(ushort)* green, const(ushort)* blue);
        alias pSDL_GetWindowGammaRamp = int function(SDL_Window* window, ushort* red, ushort* green, ushort* blue);
        alias pSDL_DestroyWindow = void function(SDL_Window* window);
        alias pSDL_IsScreenSaverEnabled = SDL_bool function();
        alias pSDL_EnableScreenSaver = void function();
        alias pSDL_DisableScreenSaver = void function();
        alias pSDL_GL_LoadLibrary = int function(const(char)* path);
        alias pSDL_GL_GetProcAddress = void* function(const(char)* proc);
        alias pSDL_GL_UnloadLibrary = void function();
        alias pSDL_GL_ExtensionSupported = SDL_bool function(const(char)* extension);
        alias pSDL_GL_SetAttribute = int function(SDL_GLattr attr, int value);
        alias pSDL_GL_GetAttribute = int function(SDL_GLattr attr, int* value);
        alias pSDL_GL_CreateContext = SDL_GLContext function(SDL_Window* window);
        alias pSDL_GL_MakeCurrent = int function(SDL_Window* window, SDL_GLContext context);
        alias pSDL_GL_GetCurrentWindow = SDL_Window* function();
        alias pSDL_GL_GetCurrentContext = SDL_GLContext function();
        alias pSDL_GL_SetSwapInterval = int function(int interval);
        alias pSDL_GL_GetSwapInterval = int function();
        alias pSDL_GL_SwapWindow = void function(SDL_Window* window);
        alias pSDL_GL_DeleteContext = void function(SDL_GLContext context);
    }

    __gshared {
        pSDL_GetNumVideoDrivers SDL_GetNumVideoDrivers;
        pSDL_GetVideoDriver SDL_GetVideoDriver;
        pSDL_VideoInit SDL_VideoInit;
        pSDL_VideoQuit SDL_VideoQuit;
        pSDL_GetCurrentVideoDriver SDL_GetCurrentVideoDriver;
        pSDL_GetNumVideoDisplays SDL_GetNumVideoDisplays;
        pSDL_GetDisplayName SDL_GetDisplayName;
        pSDL_GetDisplayBounds SDL_GetDisplayBounds;
        pSDL_GetNumDisplayModes SDL_GetNumDisplayModes;
        pSDL_GetDisplayMode SDL_GetDisplayMode;
        pSDL_GetDesktopDisplayMode SDL_GetDesktopDisplayMode;
        pSDL_GetCurrentDisplayMode SDL_GetCurrentDisplayMode;
        pSDL_GetClosestDisplayMode SDL_GetClosestDisplayMode;
        pSDL_GetWindowDisplayIndex SDL_GetWindowDisplayIndex;
        pSDL_SetWindowDisplayMode SDL_SetWindowDisplayMode;
        pSDL_GetWindowDisplayMode SDL_GetWindowDisplayMode;
        pSDL_GetWindowPixelFormat SDL_GetWindowPixelFormat;
        pSDL_CreateWindow SDL_CreateWindow;
        pSDL_CreateWindowFrom SDL_CreateWindowFrom;
        pSDL_GetWindowID SDL_GetWindowID;
        pSDL_GetWindowFromID SDL_GetWindowFromID;
        pSDL_GetWindowFlags SDL_GetWindowFlags;
        pSDL_SetWindowTitle SDL_SetWindowTitle;
        pSDL_GetWindowTitle SDL_GetWindowTitle;
        pSDL_SetWindowIcon SDL_SetWindowIcon;
        pSDL_SetWindowData SDL_SetWindowData;
        pSDL_GetWindowData SDL_GetWindowData;
        pSDL_SetWindowPosition SDL_SetWindowPosition;
        pSDL_GetWindowPosition SDL_GetWindowPosition;
        pSDL_SetWindowSize SDL_SetWindowSize;
        pSDL_GetWindowSize SDL_GetWindowSize;
        pSDL_SetWindowMinimumSize SDL_SetWindowMinimumSize;
        pSDL_GetWindowMinimumSize SDL_GetWindowMinimumSize;
        pSDL_SetWindowMaximumSize SDL_SetWindowMaximumSize;
        pSDL_GetWindowMaximumSize SDL_GetWindowMaximumSize;
        pSDL_SetWindowBordered SDL_SetWindowBordered;
        pSDL_ShowWindow SDL_ShowWindow;
        pSDL_HideWindow SDL_HideWindow;
        pSDL_RaiseWindow SDL_RaiseWindow;
        pSDL_MaximizeWindow SDL_MaximizeWindow;
        pSDL_MinimizeWindow SDL_MinimizeWindow;
        pSDL_RestoreWindow SDL_RestoreWindow;
        pSDL_SetWindowFullscreen SDL_SetWindowFullscreen;
        pSDL_GetWindowSurface SDL_GetWindowSurface;
        pSDL_UpdateWindowSurface SDL_UpdateWindowSurface;
        pSDL_UpdateWindowSurfaceRects SDL_UpdateWindowSurfaceRects;
        pSDL_SetWindowGrab SDL_SetWindowGrab;
        pSDL_GetWindowGrab SDL_GetWindowGrab;
        pSDL_SetWindowBrightness SDL_SetWindowBrightness;
        pSDL_GetWindowBrightness SDL_GetWindowBrightness;
        pSDL_SetWindowGammaRamp SDL_SetWindowGammaRamp;
        pSDL_GetWindowGammaRamp SDL_GetWindowGammaRamp;
        pSDL_DestroyWindow SDL_DestroyWindow;
        pSDL_IsScreenSaverEnabled SDL_IsScreenSaverEnabled;
        pSDL_EnableScreenSaver SDL_EnableScreenSaver;
        pSDL_DisableScreenSaver SDL_DisableScreenSaver;
        pSDL_GL_LoadLibrary SDL_GL_LoadLibrary;
        pSDL_GL_GetProcAddress SDL_GL_GetProcAddress;
        pSDL_GL_UnloadLibrary SDL_GL_UnloadLibrary;
        pSDL_GL_ExtensionSupported SDL_GL_ExtensionSupported;
        pSDL_GL_SetAttribute SDL_GL_SetAttribute;
        pSDL_GL_GetAttribute SDL_GL_GetAttribute;
        pSDL_GL_CreateContext SDL_GL_CreateContext;
        pSDL_GL_MakeCurrent SDL_GL_MakeCurrent;
        pSDL_GL_GetCurrentWindow SDL_GL_GetCurrentWindow;
        pSDL_GL_GetCurrentContext SDL_GL_GetCurrentContext;
        pSDL_GL_SetSwapInterval SDL_GL_SetSwapInterval;
        pSDL_GL_GetSwapInterval SDL_GL_GetSwapInterval;
        pSDL_GL_SwapWindow SDL_GL_SwapWindow;
        pSDL_GL_DeleteContext SDL_GL_DeleteContext;
    }

    static if(sdlSupport >= SDLSupport.sdl201) {
        extern(C) @nogc nothrow {
            alias pSDL_GL_GetDrawableSize = void function(SDL_Window* window, int* w, int* h);
        }

        __gshared {
            pSDL_GL_GetDrawableSize SDL_GL_GetDrawableSize;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl202) {
        extern(C) @nogc nothrow {
            alias pSDL_GL_ResetAttributes = void function();
        }

        __gshared {
            pSDL_GL_ResetAttributes SDL_GL_ResetAttributes;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_GetDisplayDPI = int function(int displayIndex, float* ddpi, float* hdpi, float* vdpi);
            alias pSDL_GetGrabbedWindow = SDL_Window* function();
            alias pSDL_SetWindowHitTest = int function(SDL_Window* window, SDL_HitTest callback, void* callback_data);
        }

        __gshared {
            pSDL_GetDisplayDPI SDL_GetDisplayDPI;
            pSDL_GetGrabbedWindow SDL_GetGrabbedWindow;
            pSDL_SetWindowHitTest SDL_SetWindowHitTest;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_GetDisplayUsableBounds = int function(int displayIndex, SDL_Rect* rect);
            alias pSDL_GetWindowBordersSize = int function(SDL_Window* window, int* top, int* left, int* bottom, int* right);
            alias pSDL_GetWindowOpacity = int function(SDL_Window* window, float* opacity);
            alias pSDL_SetWindowInputFocus = int function(SDL_Window* window);
            alias pSDL_SetWindowModalFor = int function(SDL_Window* modal_window, SDL_Window* parent_window);
            alias pSDL_SetWindowOpacity = int function(SDL_Window* window, float opacity);
            alias pSDL_SetWindowResizable = void function(SDL_Window* window, SDL_bool resizable);
        }

        __gshared {
            pSDL_GetDisplayUsableBounds SDL_GetDisplayUsableBounds;
            pSDL_GetWindowBordersSize SDL_GetWindowBordersSize;
            pSDL_GetWindowOpacity SDL_GetWindowOpacity;
            pSDL_SetWindowInputFocus SDL_SetWindowInputFocus;
            pSDL_SetWindowModalFor SDL_SetWindowModalFor;
            pSDL_SetWindowOpacity SDL_SetWindowOpacity;
            pSDL_SetWindowResizable SDL_SetWindowResizable;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        extern(C) @nogc nothrow {
            alias pSDL_GetDisplayOrientation = SDL_DisplayOrientation function(int displayIndex);
        }

        __gshared {
            pSDL_GetDisplayOrientation SDL_GetDisplayOrientation;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl2016) {
        extern(C) @nogc nothrow {
            alias pSDL_FlashWindow = int function(SDL_Window* window, SDL_FlashOperation operation);
            alias pSDL_SetWindowAlwaysOnTop = void function(SDL_Window* window, SDL_bool on_top);
            alias pSDL_SetWindowKeyboardGrab = void function(SDL_Window* window, SDL_bool grabbed);
            alias pSDL_GetWindowKeyboardGrab = SDL_bool function(SDL_Window* window);
            alias pSDL_SetWindowMouseGrab = void function(SDL_Window* window, SDL_bool grabbed);
            alias pSDL_GetWindowMouseGrab = SDL_bool function(SDL_Window* window);
        }

        __gshared {
            pSDL_FlashWindow SDL_FlashWindow;
            pSDL_SetWindowAlwaysOnTop SDL_SetWindowAlwaysOnTop;
            pSDL_SetWindowKeyboardGrab SDL_SetWindowKeyboardGrab;
            pSDL_GetWindowKeyboardGrab SDL_GetWindowKeyboardGrab;
            pSDL_SetWindowMouseGrab SDL_SetWindowMouseGrab;
            pSDL_GetWindowMouseGrab SDL_GetWindowMouseGrab;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl2018) {
        extern(C) @nogc nothrow {
            alias pSDL_GetWindowICCProfile = void* function(SDL_Window* window, size_t* size);
            alias pSDL_SetWindowMouseRect = int function(SDL_Window* window, const(SDL_Rect)* rect);
            alias pSDL_GetWindowMouseRect = const(SDL_Rect)* function(SDL_Window* window);
        }

        __gshared {
            pSDL_GetWindowICCProfile SDL_GetWindowICCProfile;
            pSDL_SetWindowMouseRect SDL_SetWindowMouseRect;
            pSDL_GetWindowMouseRect SDL_GetWindowMouseRect;
        }
    }
}
