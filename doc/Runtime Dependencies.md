# How to Install Runtime Dependencies

## Core Engine

Dagon requires at least OpenGL 4.0, SDL2 2.30, SDL2_Image 2.8 and FreeType. OpenGL library is usually provided by graphics card manufacturer. SDL2 and SDL2_Image can be obtained from the [official site](https://www.libsdl.org/), compiled from source or installed with a package manager such as APT.

Under Linux, if you want to use local libraries from application's working directory rather than from the system, add the following to your `dub.json`:

```
"lflags-linux": ["-rpath=$$ORIGIN"]
```

### SDL2

Dagon requires `SDL2.dll` under Windows and `libSDL2-2.0.so.0` under Linux. On 64-bit platforms, Dagon provides prebuilt SDL2 library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Download [SDL2 2.32.4](https://github.com/libsdl-org/SDL/releases/tag/release-2.32.4)
3. Inside the SDL2 source directory, create `build` directory. Inside it, run `cmake ..`

Under Linux, if you don't want to install SDL2 system-wide, then use prefix, for example: `cmake .. -DCMAKE_INSTALL_PREFIX=~/dev-install/sdl2`

4. Under Linux, run `make && make install`. Under Windows, open and build generated Visual Studio project.

### SDL2_Image

Dagon requires `SDL2_Image.dll` under Windows and `libSDL2_image-2.0.so` under Linux. On 64-bit platforms, Dagon provides prebuilt SDL2_Image library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Download [SDL2_Image 2.8.8](https://github.com/libsdl-org/SDL_image/releases/tag/release-2.8.8)
3. Inside the SDL2_Image source directory, create `build` directory. Inside it, run `cmake ..`

Under Linux, if you want to use local SDL2 from application directory rather from the system, add the following to `CMakeLists.txt`

```cmake
if(UNIX)
    set_target_properties(SDL2_image PROPERTIES LINK_FLAGS "-Wl,-rpath,\$ORIGIN")
endif()
```

Then specify SDL2 install path when running cmake, for example `cmake .. -DCMAKE_PREFIX_PATH=~/dev-install/sdl2`

4. Under Linux, run `make && make install`. Under Windows, open and build generated Visual Studio project.

### FreeType

Dagon requires `freetype-6.dll` under Windows and `libfreetype.so` under Linux. Minimal recommended version is 2.8.1. On 64-bit Windows, Dagon provides prebuilt FreeType, which is automatically copied to your project after compilation (if you are building with DUB). On Linux, Dagon relies on system-wide FreeType installation.

## dagon:exformats

dagon:exformats extension provides a number of optional dependencies for SDL2_Image under Windows, which are required for WebP, AVIF and TIFF support.

Under Linux, if configured, SDL2_Image will use libwebp, libavif and libtiff from the system.

On 64-bit Windows, the extension provides `libwebp-7.dll`, `libwebpdemux-2.dll`, `libavif-16.dll`, `libtiff-5.dll`, which are automatically copied to your project after compilation (if you are building with DUB).

## dagon:newton

dagon:newton extension requires [Newton Dynamics](https://newtondynamics.com/) 3.14 shared library. It can be installed system-wide or placed to the project's folder.

dagon:newton requires `newton.dll` under Windows and `libnewton.so` under Linux. On 64-bit platforms, the extension provides a prebuilt newton library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Clone [Newton repository](https://github.com/MADEAPPS/newton-dynamics)
3. Go to `newton-3.14`. Create `build` directory. Inside it, run `cmake ..`
4. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project.

## dagon:imgui

dagon:imgui extension requires [ImGui C wrapper library](https://github.com/gecko0307/dagon/tree/master/extensions/imgui/thirdparty/bindbc-imgui-0.7.0/deps/cimgui). The library should be compiled with SDL2 backend. It can be installed system-wide or placed to the project's folder.

dagon:newton requires `cimgui.dll` under Windows and `cimgui.so` under Linux. On 64-bit platforms, the extension provides a prebuilt cimgui library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) and [SDL2](https://www.libsdl.org/) are installed
2. Go to [extensions/imgui/thirdparty/bindbc-imgui-0.7.0/deps/cimgui/backend_test](https://github.com/gecko0307/dagon/tree/master/extensions/imgui/thirdparty/bindbc-imgui-0.7.0/deps/cimgui/backend_test). Create `build` directory. Inside it, run `cmake ..`
3. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project
4. Rename the compiled library from `cimgui_sdl.dll` (or `.so`) to `cimgui.dll` (or `.so`).

## dagon:ktx

dagon:ktx extension requires libktx 4.4.0 from [KTX Software Repository](https://github.com/KhronosGroup/KTX-Software). It can be installed system-wide or placed to the project's folder.

dagon:ktx requires `ktx.dll` under Windows and `libktx.so` under Linux. On 64-bit platforms, the extension provides a prebuilt libktx library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Download [KTX-Software 4.4.0](https://github.com/KhronosGroup/KTX-Software/releases/tag/v4.4.0)
3. Inside the KTX-Software source directory, create `build` directory. Inside it, run `cmake ..`
4. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project.

## dagon:physfs

dagon:physfs extension requires [PhysFS](https://github.com/icculus/physfs) 3.2.0. It can be installed system-wide or placed to the project's folder.

dagon:physfs requires `physfs.dll` under Windows and `libphysfs.so` under Linux. On 64-bit platforms, Dagon provides a prebuilt physfs library, which is automatically copied to your project after compilation (if you are building with DUB).

Compiling from source:
1. Make sure [CMake](https://cmake.org/) is installed
2. Download [PhysFS 3.2.0](https://github.com/icculus/physfs/releases/tag/release-3.2.0)
3. Inside the PhysFS source directory, create `build` directory. Inside it, run `cmake ..`
4. Under Linux, run `make`. Under Windows, open and build generated Visual Studio project.

## dagon:assimp

dagon:assimp extension requires [Open Asset Importer Library](https://github.com/assimp/assimp). It can be installed system-wide or placed to the project's folder.

dagon:assimp requires `Assimp.dll` under Windows and `libassimp.so` under Linux. On 64-bit platforms, Dagon provides a prebuilt Assimp library, which is automatically copied to your project after compilation (if you are building with DUB).

## dagon:video

dagon:video extension requires [libVLC](https://www.videolan.org/vlc/libvlc.html) 3.0.21. It can be installed system-wide or placed to the project's folder.

dagon:video requires `libvlccore.dll` and `libvlc.dll` under Windows and `libvlccore.so.9`, `libvlc.so` and `libidn.so.11` under Linux. On 64-bit platforms, Dagon provides prebuilt librares, which are automatically copied to your project after compilation (if you are building with DUB). Also a number of plugins are necessary for libVLC to work properly. They are stored in `plugins` folder under Windows and `plugins_linux` folder under Linux.
