# Dagon
Dagon is a 3D game engine for D language based on OpenGL 4.3 and SDL2. It features deferred HDR renderer, PBR materials, an event manager, scene manager, asset manager, and entity-component model.

## Project Goals
1. Replacing DGL as an engine for [Electronvolt](https://github.com/gecko0307/electronvolt). This means that Dagon is mainly targeted to first person action games, but nothing stops you from using it in a game of any genre.
2. Implementing a modern, easy to use, extendable 3D game engine for D due to the lack of such. We believe that D is an excellent language for game development and it deserves more attention in this domain.
3. Creating a use case for [dlib](https://github.com/gecko0307/dlib) for educational purposes.

## The Name
Dagon is named after a god from H. P. Lovecraft's Cthulhu Mythos pantheon. This name was choosen in accordance with the community tradition of naming D projects using words beginning with 'd'.

## Architecture
Dagon is a hierarchical component-based framework. At the root of the hierarchy there is an `Application` object. It can store one or multiple `Scene` objects. Each scene has its own assets, logics, event system, etc. Scene stores `Entity` objects which are basic building blocks of the game world. `Entity` can be transformed, animated and rendered.

Read more [here](https://github.com/gecko0307/dagon/blob/master/doc/Architecture.md).

## dlib
Dagon heavily relies on [dlib](https://github.com/gecko0307/dlib). It is used everywhere in the engine, from memory management and vector math to file I/O and image decoding. Actually, as stated earlier, Dagon's secondary goal is to promote dlib and demonstrate its features.

## Memory Management
Dagon mostly avoids using the garbage collector and manages all of its data manually with `New` and `Delete` functions. You are also expected to do so. You still can use garbage collected data in Dagon, but this may result in weird bugs, so you are strongly recommended to do things our way. Most part of the engine is built around dlib's ownership model–every object belongs to some other object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management–you have to manually delete only root owner, which usually is an `Application` object. When creating objects, it is recommended to make scene's `assetManager` their owner.

## Creating Assets
Dagon is a framework-style engine, meaning that it is controlled programmatically and doesn't provide you with an editor. How you will build your scenes is up to you. You can build them manually by loading models one by one in your code, create your own scene format, or export glTF scenes from a 3D editor of your choise. We recommend [Blender](https://www.blender.org/) as an external editor.

## Extending
Dagon is written with extendability in mind, so you can easily add your own drawable objects, entity components, shaders and asset loaders. Drawable can be anything you want—you can manually create meshes and animate them. With components you can dynamically attach custom data and functionality to game entities. Materials can use custom GLSL shaders and parameters, and your asset loaders help Dagon understand files that you want to load from disk—these can be 3D models, levels, save files, etc.

## Further reading
- [FAQ](https://github.com/gecko0307/dagon/blob/master/doc/FAQ.md)
- [Tutorials](https://github.com/gecko0307/dagon/blob/master/doc/tutorials)
- [Installing Runtime Dependencies](https://github.com/gecko0307/dagon/blob/master/doc/Runtime%20Dependencies.md)
- [Application Architecture](https://github.com/gecko0307/dagon/blob/master/doc/Architecture.md)
- [Render Pipeline Overview](https://github.com/gecko0307/dagon/blob/master/doc/Render%20Pipeline%20Overview.md)
- [Scene and Asset Management](https://github.com/gecko0307/dagon/blob/master/doc/Scene%20and%20Asset%20Management.md)
- [Entity](https://github.com/gecko0307/dagon/blob/master/doc/Entity.md)
- [Event System](https://github.com/gecko0307/dagon/blob/master/doc/Event%20System.md)
- [Virtual File System](https://github.com/gecko0307/dagon/blob/master/doc/Virtual%20File%20System.md)
- [Conf Files](https://github.com/gecko0307/dagon/blob/master/doc/Conf%20Files.md)
- [Materials](https://github.com/gecko0307/dagon/blob/master/doc/Materials.md)
- [Textures](https://github.com/gecko0307/dagon/blob/master/doc/Textures.md)
- [HiDPI](https://github.com/gecko0307/dagon/blob/master/doc/HiDPI.md)
- [Localization](https://github.com/gecko0307/dagon/blob/master/doc/Localization.md)
- [Collision Detection](https://github.com/gecko0307/dagon/blob/master/doc/Collision%20Detection.md)
- [Compute Shaders](https://github.com/gecko0307/dagon/blob/master/doc/Compute%20Shaders.md)
- [Multithreading and Messaging System](https://github.com/gecko0307/dagon/blob/master/doc/Messaging%20System.md)
- [Extensions](https://github.com/gecko0307/dagon/blob/master/doc/Extensions.md)
- [Video Playback](https://github.com/gecko0307/dagon/blob/master/doc/Video.md)
- [Development Guide](https://github.com/gecko0307/dagon/blob/master/doc/Development%20Guide.md)
