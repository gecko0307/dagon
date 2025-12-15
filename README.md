<img align="left" alt="dagon logo" src="https://github.com/gecko0307/dagon/raw/master/logo/dagon-logo-320.png" width="100" style="vertical-align:top" />

The goal of this project is to create a modern, easy to use, extensible 3D game engine for [D language](https://dlang.org/). Dagon is based on OpenGL 4.3 core profile and SDL2. It currently works on Windows and Linux.

> Note: this project is not connected to Dagon engine by Senscape. Also not to be confused with Dagor engine by Gaijin Entertainment.

Dagon uses computation-heavy graphics techniques and so requires a fairly powerful graphics card to run (Ampere-based NVIDIA GPUs are recommended for optimal performance). The engine is only desktop, support for mobile and web platforms is not planned.

If you like Dagon, support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make a one-time donation via [NOWPayments](https://nowpayments.io/donation/gecko0307). I appreciate any support. Thanks in advance!

[![GitHub Actions CI Status](https://github.com/gecko0307/dagon/workflows/CI/badge.svg)](https://github.com/gecko0307/dagon/actions?query=workflow%3ACI)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Screenshots
-----------
[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2025/05/sponza.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/sponza.jpg)

[![Space](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)

[![Chillwave Drive](https://blog.pixperfect.online/wp-content/uploads/2025/12/chillwave_drive_twilight.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/12/chillwave_drive_twilight.jpg)

[![Ocean](https://blog.pixperfect.online/wp-content/uploads/2025/08/ocean5.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/08/ocean5.jpg)

[![Forest](https://blog.pixperfect.online/wp-content/uploads/2025/05/forest.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/forest.jpg)

[![Eevee vs Dagon](https://blog.pixperfect.online/wp-content/uploads/2025/05/eevee_vs_dagon.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/eevee_vs_dagon.jpg)

Features
--------
* Scene graph
* Virtual file system
* Static and animated meshes
* Native [glTF 2.0](https://www.khronos.org/gltf/), [OBJ](https://en.wikipedia.org/wiki/Wavefront_.obj_file) and [IQM](https://github.com/lsalzman/iqm) formats support. [FBX](https://en.wikipedia.org/wiki/FBX) and many other model formats support via [Assimp](https://github.com/assimp/assimp) library
* GPU skinning
* Textures in PNG, JPEG, WebP, AVIF, DDS, KTX, KTX2, HDR, SVG and many other formats
* GPU-based texture resizing
* Video support using [libVLC](https://www.videolan.org/vlc/libvlc.html). Screen-aligned 2D video playback and video textures on 3D meshes. Equirectangular 360° video support
* Runs in windowed, fullscreen and borderless fullscreen modes
* HiDPI support
* Hybrid rendering pipeline: deferred for opaque materials, forward for transparent materials and materials with custom shaders
* Physically based rendering (PBR)
* HDR rendering with many tonemapping operators, including Reinhard, Hable/Uncharted, Unreal, ACES, Filmic, AgX, and Khronos PBR Neutral
* HDRI environment maps. Equirectangular HDRI to cubemap conversion. GPU-based cubemap prefiltering with GGX BRDF and importance sampling. Loading prebaked cubemaps from DDS or KTX files
* Directional lights with cascaded shadow mapping
* Spherical and tube area lights with dual paraboloid shadow mapping
* Spot lights with perspective shadow mapping
* Volumetric light scattering (isotropic for area lights, anisotropic for directional lights)
* Local environment probes with box-projected cube mapping for approximated interior GI
* Normal/parallax mapping, parallax occlusion mapping
* Deferred decals with normal mapping and PBR material properties
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field. Deferred texturing for terrains
* Water rendering. Realistic ocean shader with Gerstner waves
* Post-processing (FXAA, SSAO, DoF, lens distortion, motion blur, glow, color grading)
* Simplified render pipeline for casual-style graphics. Retro rendering support: pixelization and vertex snapping
* Tween engine for simple animation. Delayed function calls
* Input from keyboard, mouse and up to 4 gamepads. Input manager with abstract bindings and file-based configuration
* Unicode text input
* Graphics tablet input
* Ownership memory model
* Entity-component model
* Fast arena allocator
* Compute shaders
* Microservices and worker threads for running tasks in background, so that they don't block the main game loop
* Asynchronous thread-safe messaging. Use the message broker built into the event system to communicate between threads and the main loop
* Built-in camera logics for easy navigation: freeview and first person views
* Collision detection using MPR algorithm, raycasting
* Rigid body physics extension that uses [Newton Dynamics](http://newtondynamics.com). Built-in character controller
* Orthographic projection support. Screen-aligned rendering. Sprites and billboards. Create 2D/2.5D/isometric games with ease
* UTF-8 text rendering using TTF fonts via [FreeType](https://freetype.org/)
* Internationalization support
* GUI extension based on [Dear ImGui](https://github.com/ocornut/imgui)
* Native file open/save dialogs (for Windows, GTK, and Qt)
* Very basic and lightweight built-in UI toolkit
* 2D/3D sound. Various audio formats support including WAV, MP3, OGG/Vorbis, FLAC. Stereo, 5.1, 7.1 support
* VR support (in development).

Getting Started
---------------
The recommended way to start using Dagon is creating a game template with `dub init`. Create an empty directory for the project, cd to it and run the following:
```
dub init --type=dagon
dub build
```

Do not delete `data/__internal` folder! It is used to store engine's internal data such as shaders and textures.

It is strongly recommended to use [LDC](https://github.com/ldc-developers/ldc) and compile in release mode to achieve maximum performance:

```
dub build --compiler=ldc2 --build=release-nobounds
```

Runtime Dependencies
--------------------
* [SDL](https://www.libsdl.org) 2.32.4.0
* [SDL_Image](https://github.com/libsdl-org/SDL_image) 2.8.8.0
* [FreeType](https://www.freetype.org) 2.8.1 for text rendering
* [libwebp](https://chromium.googlesource.com/webm/libwebp) for WebP support (optional)
* [libtiff](https://libtiff.gitlab.io/libtiff/) for TIFF support (optional)
* [libavif](https://github.com/AOMediaCodec/libavif) for AVIF support (optional)
* [Assimp](https://github.com/assimp/assimp) for additional 3D formats support (optional)
* [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) 3.14 for rigid body simulation (optional)
* [cimgui](https://github.com/cimgui/cimgui) (optional)
* [libktx](https://github.com/KhronosGroup/KTX-Software) (optional)
* [PhysFS](https://github.com/icculus/physfs) (optional)
* [SoLoud](https://github.com/jarikomppa/soloud) (optional)
* [libVLC](https://www.videolan.org/vlc/libvlc.html) (optional)
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) (optional, deprecated)

Most of them are automatically deployed on 64-bit Windows and Linux. Read more [here](https://github.com/gecko0307/dagon/blob/master/doc/Runtime%20Dependencies.md).

Under Linux, if you want to use local libraries in Windows way (from application's working directory rather than from the system), add the following to your `dub.json`:

```
"lflags-linux": ["-rpath=$$ORIGIN"]
```

Known Bugs and Limitations
--------------------------
* The engine doesn't support macOS
* dagon:nuklear extension has [problems](https://github.com/gecko0307/dagon/issues/89) under Linux
* dagon:newton crashes under Linux when loading Newton plugins (`NewtonPhysicsWorld.loadPlugins`)

Documentation
-------------
* [API documentation (WIP)](https://gecko0307.github.io/dagon/doc/dagon.html)
* [Tutorials](https://gecko0307.github.io/dagon/?p=tutorials) and corresponding [examples](https://github.com/gecko0307/dagon-tutorials)
* [Wiki](https://github.com/gecko0307/dagon/wiki)
* [FAQ](https://github.com/gecko0307/dagon/wiki/FAQ).

HTML documentation can be generated from source code using ddox (`dub build -b ddox`). Be aware that documentation is currently incomplete.

Documentation status:
* ✔️ [dagon.core](https://gecko0307.github.io/dagon/doc/dagon/core.html)
* ✔️ [dagon.graphics](https://gecko0307.github.io/dagon/doc/dagon/graphics.html)
* ⏳ [dagon.resource](https://gecko0307.github.io/dagon/doc/dagon/resource.html)
* ⏳ [dagon.render](https://gecko0307.github.io/dagon/doc/dagon/render.html)
* ✔️ [dagon.game](https://gecko0307.github.io/dagon/doc/dagon/game.html)
* ⏳ [dagon.ui](https://gecko0307.github.io/dagon/doc/dagon/ui.html)
* ❌ `dagon.collision`
* ✔️ [dagon.compute](https://gecko0307.github.io/dagon/doc/dagon/compute.html)
* ❌ `dagon.extra`
* ❌ `dagon.ext.assimp`
* ❌ `dagon.ext.audio`
* ❌ `dagon.ext.imgui`
* ❌ `dagon.ext.iqm`
* ❌ `dagon.ext.ktx`
* ❌ `dagon.ext.newton`
* ❌ `dagon.ext.nuclear`
* ❌ `dagon.ext.openvr`
* ❌ `dagon.ext.physfs`
* ❌ `dagon.ext.video`

License
-------
Copyright (c) 2016-2025 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Denis Feklushkin, dayllenger, Konstantin Menshikov, Björn Roberg et al. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Jan Jurzitza (WebFreak), Daniel Laburthe, Rafał Ziemniewski, Kumar Sookram, Aleksandr Kovalev, Robert Georges, Rais Safiullin (SARFEX), Benas Cernevicius, Koichi Takio, Konstantin Menshikov.

Made with Dagon
---------------
* [Electronvolt](https://github.com/gecko0307/electronvolt) - work-in-progress first person puzzle based on Dagon
* [Chillwave Drive](https://github.com/gecko0307/chillwavedrive) - driving game demo written using Dagon, Newton Dynamics and SoLoud
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone
* [sacengine](https://github.com/tg-2/sacengine) - [Sacrifice](https://en.wikipedia.org/wiki/Sacrifice_(video_game)) engine reimplementation
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game
