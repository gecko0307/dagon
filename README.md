[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Dagon
=====
The goal of this project is creating a modern, easy to use, extendable 3D game engine for D language due to the lack of such. Dagon is based on OpenGL 4.0 core profile, SDL2 and Freetype 2.8.1. It works on Windows and Linux, both 32 and 64-bit. It doesn't support macOS because [Apple doesn't support OpenGL anymore](https://developer.apple.com/macos/whats-new/#deprecationofopenglandopencl).

If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make one-time donation via [PayPal](https://www.paypal.me/tgafarov). I appreciate any support. Thanks in advance!

Currently Dagon has the following features:
* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP, HDR formats
* Own asset format with Blender exporter
* Flexible material system with simple user-defined data model (interface) and shaders (backend). You can implement custom materials, with your own shaders and parameters
* Deferred pipeline for opaque materials, forward pipeline for transparent materials and materials with custom shaders
* Physically based rendering (PBR)
* HDR rendering with auto-exposure (eye adaptation), Reinhard, Hable/Uncharted and ACES tonemapping operators
* Equirectangular HDRI environment maps
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
* [Box](https://github.com/gecko0307/box) container support for assets
* Built-in physics engine.

Planned in future:
* Screen-space reflections
* Terrain
* Water

Screenshots:

[![Screenshot1](https://1.bp.blogspot.com/-grsFLVdZMFs/W6KqhXuBqOI/AAAAAAAADqA/pU6vuB8PKZUws3eP0Ac0GJ4p6fbIWi0kACPcBGAYYCw/s1600/screenshot001.jpg)](https://1.bp.blogspot.com/-grsFLVdZMFs/W6KqhXuBqOI/AAAAAAAADqA/pU6vuB8PKZUws3eP0Ac0GJ4p6fbIWi0kACPcBGAYYCw/s1600/screenshot001.jpg)
[![Screenshot2](https://2.bp.blogspot.com/-r92DjuBgFGk/Ww2Q9xDVbxI/AAAAAAAADaQ/HxZTNLloXq8DVthWn9iDBEjnhs5skJv7wCPcBGAYYCw/s1600/Untitled%2B9.jpg)](https://2.bp.blogspot.com/-r92DjuBgFGk/Ww2Q9xDVbxI/AAAAAAAADaQ/HxZTNLloXq8DVthWn9iDBEjnhs5skJv7wCPcBGAYYCw/s1600/Untitled%2B9.jpg)
[![Screenshot3](https://3.bp.blogspot.com/-5dp4hgznRQY/Wv_2W7xzpMI/AAAAAAAADYk/BoJ9fm899Ts44vo9Gja26tl9q9ckoFNiACLcBGAs/s1600/exporter.jpg)](https://3.bp.blogspot.com/-5dp4hgznRQY/Wv_2W7xzpMI/AAAAAAAADYk/BoJ9fm899Ts44vo9Gja26tl9q9ckoFNiACLcBGAs/s1600/exporter.jpg)

Video:

[https://www.youtube.com/watch?v=UhQfMkObTEs](https://www.youtube.com/watch?v=UhQfMkObTEs)

Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API.

Usage
-----
To use latest stable Dagon, add the following dependency to your `dub.json`:
```
"dagon": "0.8.3"
```
If you want to test new features, use `"dagon": "~master"`. The master should be stable enough to compile a working application, but be ready for breaking changes at any time.

Demos
-----
A test application that demonstrates Dagon's features is hosted [here](https://github.com/gecko0307/dagon-demo). If you are starting from scratch, we recommend to use it for learning purposes.

Documentation
-------------
See [Tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials).

License
-------
Copyright (c) 2016-2018 Timur Gafarov. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Rafal Ziemniewski, Kumar Sookram, Aleksandr Kovalev.
