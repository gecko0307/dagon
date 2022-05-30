# BindBC Imgui
D binding to CImgui with additional OpenGL and SDL backends

# Adding to your project
To add bindbc-imgui to your project run
```
dub add bindbc-imgui
```
**Note** (Windows): For the precompiled DLLs you'll need Visual C++ Runtime 2019

# Using backends
To select backends use the `versions` directive in your dub package file
Current backends are: `USE_GL`, `USE_SDL2` (depends on bindbc-sdl) and `USE_GLFW` (depends on bindbc-glfw).

# Running examples
To run the examples go in to the `examples` directory and compile the example in question.