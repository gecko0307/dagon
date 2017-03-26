Dagon
=====
Dagon is a 3D game development framework for D. It is a work-in-progress reincarnation of [DGL](https://github.com/gecko0307/dgl) with several architecture improvements. The most significant changes are the following:

* Based on SDL2
* Ownership memory model - every object belongs to some object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owners
* Entity-component model that allows game objects behave differently and combine many behaviours
* Scene management. Any scene has its own assets, entities and logical context
* Live asset reloading - asset can be autimatically reloaded when the file is modified with external application
* [IQM](https://github.com/lsalzman/iqm) format support
* New material system with simple abstract API and different backends (fixed pipeline, PBR, non-PBR, etc.). Only fixed pipeline backend is implemented at the moment
* More texture formats support: PNG, JPG, TGA, BMP
* TTF fonts are now compatible with asset manager and VFS
* [Box](https://github.com/gecko0307/box) container support.

Dagon is still under development and doesn't have eye candy features yet. It's just a framework that you can use to build your own OpenGL-based graphics pipeline - just define your own Drawables, Behaviours and Scenes. In future, some functionality from DGL will be ported to Dagon.

Demos
-----
Dagon comes with a number of usage demos treated as dub subpackages:

* *Simple* - a simple scene with a textured cube, light sources and trackball view. Build: `dub build :simple`
* *Animation* - loading an animated IQM model. Build: `dub build :animation`
* *Physics* - advanced demo: [dmech](https://github.com/gecko0307/dmech) physics engine integration, first person camera with character controller, loading TTF font and rendering 2D text. Build: `dub build :physics`

License
-------
Copyright (c) 2016-2017 Timur Gafarov. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).
