[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Dagon
=====
Dagon is a 3D/2D game development framework for D. It is a work-in-progress reincarnation of [DGL](https://github.com/gecko0307/dgl) with several architecture improvements. Surrently Dagon has the following features:

* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP formats
* Flexible material system with simple abstract API and different backends (for example, fixed pipeline or GLSL-based). You can implement custom materials, with your own shaders and parameters
* Clustered forward shading (world space XZ plane light indexing, variable number of lights per fragment)
* Normal/parallax mapping
* Cascaded shadow maps
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields
* Post-processing filters (FXAA, lens distortion)
* UTF-8 text rendering using TTF fonts via Freetype
* Ownership memory model - every object belongs to some object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owners
* Entity-component model that allows game objects behave differently and combine many behaviours
* Scene management. Any scene has its own assets, entities and logical context
* Live asset reloading - asset can be automatically reloaded when the file is modified with external application
* [Box](https://github.com/gecko0307/box) container support for assets.

[![Screenshot1](/screenshots/main-thumb.jpg)](/screenshots/main.jpg)

Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API.

Upcoming plans:

* Port the engine to OpenGL 3.3 - see [gl33](https://github.com/gecko0307/dagon/tree/gl33) branch
* PBR, IBL
* Water with reflections and refractions
* Terrain renderer
* SSAO
* Camera motion blur
* Bloom

Known problems
--------------
For historical reasons, Dagon is based on OpenGL 2.1. But some functionality (`BlinnPhongBackend` and `ClusteredBlinnPhongBackend`) uses OpenGL 3.x level features via GL_EXT_gpu_shader4 extension (like integer samplers, direct texel fetches, `sampler2DArrayShadow`). It works correctly only on NVIDIA cards. Currently we are porting Dagon to core OpenGL 3.3, and soon it will support wider range of graphics hardware.

Prerequisites
-------------
Dagon is known to work on Windows, Linux, FreeBSD and OSX. To use Dagon, a number of libraries should be installed, namely SDL2 and Freetype. If you don't have them installed system-wide (which is a common case on Windows), you can use the libraries provided [here](https://github.com/gecko0307/dagon/releases/tag/v0.0.2). Currently we provide libraries only for Windows and Linux. Download an archive for your system and place the `lib` folder to your project's working directory. Dagon will automatically detect and try to load them. If there are no local libraries in `lib` directory, it will use system ones.

Demos
-----
A test application that demonstrates Dagon's features is hosted [here](https://github.com/gecko0307/dagon-demo). If you are starting from scratch, we recommend to use it for learning purposes.

Documentation
-------------
Not available yet, sorry.

License
-------
Copyright (c) 2016-2017 Timur Gafarov. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).
