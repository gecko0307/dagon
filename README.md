[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)
[![Patreon button](https://img.shields.io/badge/patreon-donate-yellow.svg)](http://patreon.com/gecko0307 "Become a Patron!")

Dagon
=====
The goal of this project is creating a modern, easy to use, extendable 3D game engine for D language. Dagon is based on OpenGL 4.0 core profile. It works on Windows and Linux, both 32 and 64-bit. It doesn't support macOS because Apple doesn't support OpenGL anymore.

> Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API. Follow Dagon development on [Trello](https://trello.com/b/4sDgRjZI/dagon-0110) to see priority tasks. 

If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make one-time donation via [PayPal](https://www.paypal.me/tgafarov). I appreciate any support. Thanks in advance!

Screenshots
-----------
[![Screenshot4](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg)

[![Screenshot3](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/cerberus.jpg)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/cerberus.jpg)

[![Screenshot1](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/snow2.jpg)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/01/snow2.jpg)

Features
--------
* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP, HDR formats
* Own asset format with Blender exporter
* Deferred pipeline for opaque materials, forward pipeline for transparent materials and materials with custom shaders
* Physically based rendering (PBR)
* HDR rendering with Reinhard, Hable/Uncharted, ACES and Filmic tonemapping operators
* HDRI environment maps
* Directional lights with cascaded shadow mapping and volumetric scattering
* Spherical and tube area lights
* Spot lights
* Normal/parallax mapping, parallax occlusion mapping
* Deferred decals with normal mapping and PBR material properties
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field
* Water rendering
* Post-processing (FXAA, SSAO, lens distortion, motion blur, glow, LUT color grading)
* UTF-8 text rendering using TTF fonts via Freetype
* GUI and 2D graphics based on [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear). Canvas framework that renders vector shapes
* Keyboard, mouse, joystick input
* Unicode text input
* Ownership memory model
* Entity-component model
* Live asset reloading
* Built-in camera logics for quick and easy navigation (freeview and first person style view)
* [Box](https://github.com/gecko0307/box) container support for assets
* Built-in physics engine.

Planned in future:
* Screen-space reflections
* Newton Game Dynamics integration.

Usage
-----
To use latest stable Dagon, add the following dependency to your `dub.json`:
```
"dagon": "~>0.11.0"
```
Instead of manually configuring a new Dagon project, you can use a template with `dub init`. Create an empty directory for the project, cd to it and run the following:
```
dub init --type=dagon
dub build
```

Runtime Dependencies
--------------------
* [SDL](https://www.libsdl.org) 2.0.5
* [Freetype](https://www.freetype.org) 2.8.1
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) (optional)

On Windows runtime dependencies are automatically deployed if you are building with Dub. On other platforms you have to install them manually. 

Documentation
-------------
See [tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials) and corresponding [examples](https://github.com/gecko0307/dagon-tutorials).

License
-------
Copyright (c) 2016-2021 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Björn Roberg, dayllenger. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Rafał Ziemniewski, Kumar Sookram, Aleksandr Kovalev, Robert Georges, Jan Jurzitza (WebFreak), Rais Safiullin (SARFEX), Benas Cernevicius, Koichi Takio.

Made with Dagon
---------------
* [dagon-demo](https://github.com/gecko0307/dagon-demo) - a test application that demonstrates most of Dagon's features
* [dagon-sandbox](https://github.com/gecko0307/dagon-sandbox) - a test application for unstable version of Dagon
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game
