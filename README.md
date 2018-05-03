[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)

Dagon
=====
Dagon is a 3D game development framework for D. It is a work-in-progress reincarnation of [DGL](https://github.com/gecko0307/dgl) with several architecture improvements. Dagon is based on OpenGL 3.3 core profile, SDL2 and Freetype 2.8.1.

Currently Dagon has the following features:
* Static and animated meshes, OBJ and [IQM](https://github.com/lsalzman/iqm) formats support
* Textures in PNG, JPG, TGA, BMP, HDR formats
* Flexible material system with simple user-defined abstract API and different backends. You can implement custom materials, with your own shaders and parameters
* Physically based rendering (PBR)
* HDR rendering with auto-exposure (eye adaptation), Reinhard and Hable/Uncharted tonemapping operators
* HDRI environment maps support
* Multiple light sources using clustered forward shading method (variable number of lights per fragment)
* Spherical area lights
* Normal/parallax mapping, parallax occlusion mapping
* Cascaded shadow maps for directional light
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields
* RTT, post-processing filters (FXAA, lens distortion, motion blur)
* UTF-8 text rendering using TTF fonts via Freetype
* Ownership memory model - every object belongs to some object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owners
* Entity-component model that allows game objects behave differently and combine many behaviours
* Scene management. Any scene has its own assets, entities and logical context
* Live asset reloading - asset can be automatically reloaded when the file is modified with external application
* Built-in camera logics for quick and easy navigation (freeview and first person style view)
* [Box](https://github.com/gecko0307/box) container support for assets.

[![Screenshot1](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/car-thumb.jpg)](https://raw.githubusercontent.com/gecko0307/dagon-demo/master/screenshots/car.jpg)

[https://www.youtube.com/watch?v=pxu9sxL9MIM](https://www.youtube.com/watch?v=pxu9sxL9MIM)

Dagon is still under development and lacks a lot of important functionality. Currently it is not recommended to use Dagon in production due to unstable API.

Upcoming plans:

* Particle materials, soft particles
* Water with reflections and refractions
* Terrain renderer
* SSAO
* Bloom

Demos
-----
A test application that demonstrates Dagon's features is hosted [here](https://github.com/gecko0307/dagon-demo). If you are starting from scratch, we recommend to use it for learning purposes.

Documentation
-------------
See [Tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials).

License
-------
Copyright (c) 2016-2018 Timur Gafarov. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).
