[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Dagon
=====
The goal of this project is creating a modern, easy to use, extendable 3D game engine for D language due to the lack of such. Dagon is based on OpenGL 4.0 core profile. It works on Windows and Linux, both 32 and 64-bit. It doesn't support macOS because [Apple doesn't support OpenGL anymore](https://developer.apple.com/macos/whats-new/#deprecationofopenglandopencl).

> Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API. Follow Dagon development on [Trello](https://trello.com/b/4sDgRjZI/dagon) to see priority tasks. 

If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make one-time donation via [PayPal](https://www.paypal.me/tgafarov). I appreciate any support. Thanks in advance!

Features
--------
* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP, HDR formats
* Own asset format with Blender exporter
* Flexible material system with simple user-defined data model (interface) and shaders (backend). You can implement custom materials, with your own shaders and parameters
* Deferred pipeline for opaque materials, forward pipeline for transparent materials and materials with custom shaders
* Physically based rendering (PBR)
* HDR rendering with auto-exposure (eye adaptation), Reinhard, Hable/Uncharted and ACES tonemapping operators
* Cube and equirectangular HDRI environment maps
* Cubemap baking
* Directional lights with cascaded shadow mapping
* Spherical and tube area lights
* Spot lights
* Normal/parallax mapping, parallax occlusion mapping
* Dynamic skydome with sun and day/night cycle. Simple and Rayleigh sky models
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field
* Water rendering
* Post-processing (FXAA, SSAO, lens distortion, motion blur, glow, LUT color grading)
* UTF-8 text rendering using TTF fonts via Freetype
* GUI based on [Nuklear](https://github.com/vurtun/nuklear)
* Ownership memory model - every object belongs to some object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owners
* Entity-component model that allows game objects behave differently and combine many behaviours
* Scene management. Any scene has its own assets, entities and logical context
* Live asset reloading - asset can be automatically reloaded when the file is modified with external application
* Built-in camera logics for quick and easy navigation (freeview and first person style view)
* [Box](https://github.com/gecko0307/box) container support for assets
* Built-in physics engine.

Planned in future:
* Screen-space reflections

Screenshots
-----------
[![Screenshot1](https://1.bp.blogspot.com/-grsFLVdZMFs/W6KqhXuBqOI/AAAAAAAADqA/pU6vuB8PKZUws3eP0Ac0GJ4p6fbIWi0kACPcBGAYYCw/s1600/screenshot001.jpg)](https://1.bp.blogspot.com/-grsFLVdZMFs/W6KqhXuBqOI/AAAAAAAADqA/pU6vuB8PKZUws3eP0Ac0GJ4p6fbIWi0kACPcBGAYYCw/s1600/screenshot001.jpg)
[![Screenshot2](https://2.bp.blogspot.com/-r92DjuBgFGk/Ww2Q9xDVbxI/AAAAAAAADaQ/HxZTNLloXq8DVthWn9iDBEjnhs5skJv7wCPcBGAYYCw/s1600/Untitled%2B9.jpg)](https://2.bp.blogspot.com/-r92DjuBgFGk/Ww2Q9xDVbxI/AAAAAAAADaQ/HxZTNLloXq8DVthWn9iDBEjnhs5skJv7wCPcBGAYYCw/s1600/Untitled%2B9.jpg)
[![Screenshot3](https://2.bp.blogspot.com/-kJFkO4qk15g/XFKeMCYok4I/AAAAAAAAD04/mB1uiIGcAoQMs0Ngo0Et2zf3ZvdKaVePACLcBGAs/s1600/nuklear.jpg)](https://2.bp.blogspot.com/-kJFkO4qk15g/XFKeMCYok4I/AAAAAAAAD04/mB1uiIGcAoQMs0Ngo0Et2zf3ZvdKaVePACLcBGAs/s1600/nuklear.jpg)
[![Screenshot4](https://1.bp.blogspot.com/-o8H1blpZeFQ/W78a-nttgrI/AAAAAAAADrc/LPZZ4j_A5jIye0hib3bR7W17sAvY1ucYQCLcBGAs/s1600/dagon-demo-dwarf.jpg)](https://1.bp.blogspot.com/-o8H1blpZeFQ/W78a-nttgrI/AAAAAAAADrc/LPZZ4j_A5jIye0hib3bR7W17sAvY1ucYQCLcBGAs/s1600/dagon-demo-dwarf.jpg)

Video
-----
[https://www.youtube.com/watch?v=nhdOhPQ9g90](https://www.youtube.com/watch?v=nhdOhPQ9g90)

Dependencies
------------
Dagon depends on the following D packages:
* [dlib](https://github.com/gecko0307/dlib)
* [bindbc-opengl](https://github.com/BindBC/bindbc-opengl)
* [bindbc-sdl](https://github.com/BindBC/bindbc-sdl)
* [bindbc-ft](https://github.com/gecko0307/bindbc-ft)
* [bindbc-nuklear](https://github.com/Timu5/bindbc-nuklear)

Runtime dependencies (dynamic link libraries):
* [SDL](https://www.libsdl.org) 2.0.5
* [Freetype](https://www.freetype.org) 2.8.1
* [Nuklear](https://github.com/vurtun/nuklear)

Under Windows runtime dependencies are automatically deployed if you are building with Dub. Under other OSes you have to install them manually.

Usage
-----
To use latest stable Dagon, add the following dependency to your `dub.json`:
```
"dagon": "0.9.2"
```
If you want to test new features, use `"dagon": "~master"`. The master should be stable enough to compile a working application, but be ready for breaking changes at any time.

Demos
-----
A test application that demonstrates almost all of Dagon's features is hosted [here](https://github.com/gecko0307/dagon-demo). There are also [simple introductory examples](https://github.com/gecko0307/dagon-tutorials).

Documentation
-------------
See [Tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials).

License
-------
Copyright (c) 2016-2019 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Björn Roberg, dayllenger. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Rafał Ziemniewski, Kumar Sookram, Aleksandr Kovalev.
