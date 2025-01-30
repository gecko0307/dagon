<img align="left" alt="dagon logo" src="https://github.com/gecko0307/dagon/raw/master/logo/dagon-logo-320.png" width="100" style="vertical-align:top" />

The goal of this project is to create a modern, easy to use, extensible 3D game engine for [D language](https://dlang.org/). Dagon is based on OpenGL 4.0 core profile. It currently works on Windows and Linux.

The engine is still under development and lacks many important features. It is currently not recommended to use Dagon in production due to API instability. Follow the development on [Trello](https://trello.com/b/4sDgRjZI/dagon-development-board) to see the priority tasks.

Dagon uses modern graphics techniques and so requires a fairly powerful graphics card to run (at least Turing-based NVIDIA cards are recommended). The engine is only desktop, support for mobile and web platforms is not planned.

If you like Dagon, support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make a one-time donation via [NOWPayments](https://nowpayments.io/donation/gecko0307). I appreciate any support. Thanks in advance!

[![GitHub Actions CI Status](https://github.com/gecko0307/dagon/workflows/CI/badge.svg)](https://github.com/gecko0307/dagon/actions?query=workflow%3ACI)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Screenshots
-----------
[![Screenshot1](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/05/sponza10.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/05/sponza10.jpg?)

[![Screenshot2](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg?)

[![Screenshot3](https://gamedev.timurgafarov.ru/wp-content/uploads/2024/12/box_proj_004.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2024/12/box_proj_004.jpg?)

[![Screenshot4](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/cerberus.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/cerberus.jpg?)

[![Screenshot5](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/08/003.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/08/003.jpg?)

Features
--------
* Scene graph
* Static and animated meshes, [glTF](https://www.khronos.org/gltf/), [OBJ](https://en.wikipedia.org/wiki/Wavefront_.obj_file) and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, DDS, HDR, TGA, BMP formats
* Deferred pipeline for opaque materials, forward pipeline for transparent materials and materials with custom shaders
* Simplified render pipeline for retro and casual-style graphics
* Physically based rendering (PBR)
* HDR rendering with Reinhard, Hable/Uncharted, Unreal, ACES, Filmic and AgX tonemappers
* HDRI environment maps. Preconvolved DDS cubemaps
* Directional lights with cascaded shadow mapping and volumetric scattering
* Spherical and tube area lights, spot lights
* Local environment probes with box-projected cube mapping for approximated interior GI
* Normal/parallax mapping, parallax occlusion mapping
* Deferred decals with normal mapping and PBR material properties
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field
* Water rendering
* Post-processing (FXAA, SSAO, DoF, lens distortion, motion blur, glow, color grading)
* Keyboard, mouse and joystick input. Input manager with abstract bindings and file-based configuration
* Unicode text input
* Ownership memory model
* Entity-component model
* Built-in camera logics for easy navigation: freeview and first person views
* Rigid body physics extension that uses [Newton Dynamics](http://newtondynamics.com). Built-in character controller
* Orthographic projection support. Sprites and billboards. Create 2.5D isometric games with ease
* Screen-aligned 2D rendering
* UTF-8 text rendering using TTF fonts via Freetype
* GUI extension based on [Dear ImGui](https://github.com/ocornut/imgui).

Planned in future:
* Screen-space reflections.

Getting Started
---------------
The recommended way to start using Dagon is creating a game template with `dub init`. Create an empty directory for the project, cd to it and run the following:
```
dub init --type=dagon
dub build
```

Do not delete `data/__internal` folder! It is used to store engine's internal data such as shaders and textures.

Runtime Dependencies
--------------------
* [SDL](https://www.libsdl.org) 2.0.14
* [Freetype](https://www.freetype.org) 2.8.1 (optional)
* [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) 3.14 (optional)
* [ImGui](https://github.com/ocornut/imgui) (optional)
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) (optional, deprecated)

Runtime dependencies are automatically deployed on 64-bit Windows and Linux. On other platforms, you will have to [install them manually](https://github.com/gecko0307/dagon/blob/master/doc/Runtime%20Dependencies.md).

Known Bugs and Limitations
--------------------------
* The engine is not tested on macOS and most likely doesn't support it. macOS support is low priority at the moment
* dagon:nuklear extension has [problems](https://github.com/gecko0307/dagon/issues/89) under Linux
* dagon:newton crashes under Linux when loading Newton plugins (`NewtonPhysicsWorld.loadPlugins`)

Documentation
-------------
See [tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials) and corresponding [examples](https://github.com/gecko0307/dagon-tutorials).

License
-------
Copyright (c) 2016-2025 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, dayllenger, Konstantin Menshikov, Björn Roberg, Isaac S., ijet. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Jan Jurzitza (WebFreak), Daniel Laburthe, Rafał Ziemniewski, Kumar Sookram, Aleksandr Kovalev, Robert Georges, Rais Safiullin (SARFEX), Benas Cernevicius, Koichi Takio, Konstantin Menshikov.

Made with Dagon
---------------
* [Electronvolt](https://github.com/gecko0307/electronvolt) - work-in-progress first person puzzle based on Dagon
* [Vehicle Demo](https://github.com/gecko0307/vehicle-demo) - vehicle physics engine written using Dagon and Newton Dynamics
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone
* [sacengine](https://github.com/tg-2/sacengine) - [Sacrifice](https://en.wikipedia.org/wiki/Sacrifice_(video_game)) engine reimplementation
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game
