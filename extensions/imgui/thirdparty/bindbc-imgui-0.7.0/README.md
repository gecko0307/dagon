# BindBC Imgui
D binding to CImgui with additional OpenGL and SDL backends

# Adding to your project
To add bindbc-imgui to your project run
```
dub add bindbc-imgui
```
bindbc-imgui will currently build it's own dependencies. We've found that distributing deps for all possible targets too onerous, and so instead now depend on an existing toolchain and tools. That said, we're open to contributions for doing this in a more traditional way across platforms, but we're experiementing with this to make development of inochi-creator (and it's related projects) easier. 

## Availible Configs
These configs have been developed to ease the use of this project in inochi-creator. Happy to accept PRs for additional configs with alternate goals. But we'd like to avoid (if this works how we're hoping) attempting to distribute binaries within our git source going forward.

### static_dynamicCRT
Statically linked cimgui, dynamically linked C/C++ runtime libraries.
### static_staticCRT
Statically linked cimgui, statically linked C/C++ runtime libraries.
 - Please note that you may run afoul of licensing issues using this configuration, due to glibc being under the LGPL. 
### dynamic_dynamicCRT
Dynamically linked cimgui, dynamically linked C/C++ runtime libraries.
### dynamic_staticCRT
Dynamically linked cimgui, statically linked C/C++ runtime libraries.
 - Please note that you may run afoul of licensing issues using this configuration, due to glibc being under the LGPL. 

## Platform Dependencies
### Windows
#### Dependencies
- Visual Studio 2022 (With "Desktop development with C++" workflow installed)
  - In theory, "Build Tools for Visual Studio 2022" should also work, but is untested.
- CMake (Currently 3.16 or higher is needed.)
- Dlang, either dmd or ldc

### Linux
#### Dependencies
- The equivalent of build-essential on Ubuntu, on centos 7, this was `sudo yum groupinstall 'Development Tools'`, this should get you a working C++ toolchain.
- Dlang, either dmd or ldc
- CMake (Currently 3.16 or higher is needed.)
- SDL2 (developer package)
- Freetype (developer package)
- appimagetool (for building an AppImage)

### Mac
Unfortunately for now, Mac is still in flux. We're having issues setting up the D side of our toolchain to run consistently, and once it does, our C++ side likely needs some help as well. Check back soon, or contact us via Issues here or the inochi2D project discord if you'd like to help. We'd like Mac to be easy to build, but we're not there yet.

# Using backends
To select backends use the `versions` directive in your dub package file
Current backends are: `USE_GL`, `USE_SDL2` (depends on bindbc-sdl) and `USE_GLFW` (depends on bindbc-glfw).

# Running examples
To run the examples go in to the `examples` directory and compile the example in question.