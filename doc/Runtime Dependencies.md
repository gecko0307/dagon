How to Install Runtime Dependencies
===================================
Core Engine
-----------
Dagon requires at least OpenGL 4.0, SDL 2.30 + SDL2_Image 2.8. OpenGL library is usually provided by graphics card manufacturer. SDL can be obtained from the [official site](https://www.libsdl.org/) or installed with a package manager such as APT. On 64-bit platforms, Dagon provides prebuilt SDL and SDL2_Image libraries, which are automatically copied to your project after compilation (if you are building with DUB).

Under Linux, if you want to use local libraries from application's working directory rather than from the system, add the following to your `dub.json`:

```
"lflags-linux": ["-rpath=$$ORIGIN"]
```

dagon:newton
------------
dagon:newton extension requires [Newton Dynamics](https://newtondynamics.com/) 3.14 shared library - `newton.dll` for Windows and `libnewton.so` for Linux. It can be installed system-wide or placed to the project's folder. On 64-bit platforms, Dagon provides a prebuilt newton library, which is automatically copied to your project after compilation (if you are building with DUB).

Newton 4.0 is not supported.

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Clone [Newton repository](https://github.com/MADEAPPS/newton-dynamics)
3. Go to `newton-3.14`. Create `build` directory. Inside it, run `cmake ..`
4. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project.

dagon:imgui
-----------
dagon:imgui extension requires [ImGui C wrapper library](https://github.com/Inochi2D/cimgui/tree/49bb5ce65f7d5eeab7861d8ffd5aa2a58ca8f08c) - `cimgui.dll` for Windows and `cimgui.so` for Linux. The library should be compiled with SDL2 backend. It can be installed system-wide or placed to the project's folder. On 64-bit platforms, Dagon provides a prebuilt cimgui library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) and [SDL2](https://www.libsdl.org/) are installed
2. Go to [extensions/imgui/thirdparty/bindbc-imgui-0.7.0/deps/cimgui/backend_test](https://github.com/gecko0307/dagon/tree/master/extensions/imgui/thirdparty/bindbc-imgui-0.7.0/deps/cimgui/backend_test). Create `build` directory. Inside it, run `cmake ..`
3. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project
4. Rename the compiled library from `cimgui_sdl.dll` (or `.so`) to `cimgui.dll` (or `.so`).
