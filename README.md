[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Dagon
=====
Dagon is a 3D game development framework for D language. It is a reincarnation of [DGL](https://github.com/gecko0307/dgl) with several architecture improvements. Dagon is based on OpenGL 4.0 core profile, SDL2 and Freetype 2.8.1.

The goal of this project is creating a modern, easy to use, extendable game engine for D due to the lack of such. If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make one-time donation via [PayPal](https://www.paypal.me/tgafarov). I appreciate any support. Thanks in advance!

Currently Dagon has the following features:
* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP, HDR formats
* Own asset format with Blender exporter
* Flexible material system with simple user-defined abstract API and different backends. You can implement custom materials, with your own shaders and parameters
* Deferred shading
* Physically based rendering (PBR)
* HDR rendering with auto-exposure (eye adaptation), Reinhard, Hable/Uncharted and ACES tonemapping operators
* Equirectangular HDRI environment maps support
* Spherical area lights
* Normal/parallax mapping, parallax occlusion mapping
* Cascaded shadow maps for directional light
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Post-processing (FXAA, SSAO, lens distortion, motion blur, glow, LUT color grading)
* UTF-8 text rendering using TTF fonts via Freetype
* Ownership memory model - every object belongs to some object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owners
* Entity-component model that allows game objects behave differently and combine many behaviours
* Scene management. Any scene has its own assets, entities and logical context
* Live asset reloading - asset can be automatically reloaded when the file is modified with external application
* Built-in camera logics for quick and easy navigation (freeview and first person style view)
* [Box](https://github.com/gecko0307/box) container support for assets.

Dagon works on Windows and Linux, both 32 and 64-bit. It doesn't support macOS and likely won't because [Apple doesn't support OpenGL anymore](https://developer.apple.com/macos/whats-new/#deprecationofopenglandopencl).

Screenshots:

[![Screenshot1](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/car-thumb.jpg)](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/car.jpg)
[![Screenshot2](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/characters-thumb.jpg)](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/characters.jpg)
[![Screenshot3](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/lights-thumb.jpg)](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/lights.jpg)

Video:

[https://www.youtube.com/watch?v=UhQfMkObTEs](https://www.youtube.com/watch?v=UhQfMkObTEs)

Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API.

Upcoming plans:

* Screen-space reflections
* Terrain renderer

Demos
-----
A test application that demonstrates Dagon's features is hosted [here](https://github.com/gecko0307/dagon-demo). If you are starting from scratch, we recommend to use it for learning purposes.

Documentation
-------------
See [Tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials).

License
-------
Copyright (c) 2016-2018 Timur Gafarov. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).
