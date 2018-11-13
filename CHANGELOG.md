Dagon 0.9.0 - 13 Nov, 2018
--------------------------
**Important:** Dagon now officially doesn't support macOS. This is because [Apple has deprecated OpenGL](https://developer.apple.com/macos/whats-new/#deprecationofopenglandopencl) in favour of Metal, which means that there will be no OpenGL above 4.1, and notorious driver issues will not be fixed. This makes targeting macOS in a non-commercial cross-platform game engine development virtually impossible. Dagon will stick with OpenGL 4.x and platforms that support it (Windows and Linux), and there are no plans to port the engine to other graphics APIs.

**Important:** This is a huge release (the biggest since 0.5.0) featuring titanic internal refactoring and API improvement, so it can break compatibility with existing projects. Resulting image can change, and some parameters may require additional tweaking. Some functionality have been removed due to switching to deferred rendering.

Changes:
- **Rendering**
  - Dagon now uses deferred shading which results in significantly better performance on complex scenes with large number of lights. Light count is now truly unlimited (fillrate-bound). This is mainly an internal optimization that doesn't affect user API. The only significant change is handling transparent entities (entities that use non-opaque materials) - they are rendered in a separate forward pass using only sun light, and currently there's no built-in way to shade them with point/area lights
  - Shader system has been redesigned from scratch. Now there is a `Shader` class that handles GLSL shader objects. Parameter handling was greatly simplified - all uniforms are created automatically and lazily from D/dlib types (`int`, `float`, `Vector3f` and others). Parameters can be even tied to class fields and methods via implicit references. User-defined shaders are supported - derive from `Shader` class and provide your shader object when calling `Scene.createMaterial`. Objects using such shaders fallback to forward pipeline, because in deferred path you can't have individual shaders per object
  - All built-in shaders use GLSL 4.0 (400 core), linear colors and ITU-R Rec.709 luminance. Internal shader optimizations include GLSL 4.0 subroutines instead of branching for maximum performance in ubershaders. As a consequence, no more implicit solid color textures - animated color values are possible
  - `dagon.graphics.clustered` module is now `dagon.graphics.light`. `ClusteredLightManager` renamed to `LightManager`. Its clustered shading functionality has been removed
- **Materials**
  - `Material`, `GenericMaterial` and all other material classes have been combined into one class - `Material`, which uses `Shader` objects. Material backends are completely gone
  - Particle system improvements, including soft particles (e.g. alpha blending based on distance to underlying objects) and shaded particles (using custom or procedural normal map). Particles can now cast shadows. It is now possible to create many emitters in one particle system. An emitter can render any `Entity` as a particle. Default particle system and particle shader are now part of a `Scene` class (`Scene.particleSystem`, `Scene.particleShader`). To create particle materials, use `Scene.createParticleMaterial()` method. It is possible to use custom shader for particle material, just pass your shader instance to `Scene.createParticleMaterial`
  - Simple water shader with procedural raindrop ripples (`dagon.graphics.shaders.water`)
- **Environment**
  - Experimental environment probes support
  - Optional Rayleigh sky model (`dagon.graphics.shaders.rayleigh`)
  - Default sky parameters were changed to more eye-pleasing ones
  - Custom material support for `Scene.createSky`
  - `environment.setDayTime(hours, minutes, seconds)` for quick sun/sky setup
  - `environment.backgroundColor` is now used to clear the framebuffer
- **Post-processing**
  - Screen space ambient occlusion (SSAO)
  - ACES tonemapper is now used by default
  - Motion blur now works for background objects and particles
  - Auto exposure now can be turned off (`Scene.hdr.autoExposure`)
- **Assets & logics**
  - OBJ files without normals now don't cause application crash. Mesh normals are generated if they are missing
  - IQM loader doesn't load textures automatically anymore - all textures/materials should be explicitly set up by programmer. It is possible to apply materials to individual IQM meshes
  - `FirstPersonView.mouseSensibility`
  - `SceneApplication.saveScreenshot`
- **Physics**
  - [dmech](https://github.com/gecko0307/dmech) physics engine has been (experimentally) integrated into Dagon. Built-in rigid body and character controllers are provided
- **Misc**
  - Dagon now uses [BindBC] instead of Derelict to dynamically link OpenGL, SDL and Freetype
  - Dagon now uses dlib 0.15.0
  - Automatic deployment using Dub. Now all files necessary to run the engine (Windows DLLs, configuration files, internal resources) are copied to project directory after each build

Dagon 0.8.3 - 21 Aug, 2018
--------------------------
* Ignore unsupported SDL2 functions.

Dagon 0.8.2 - 17 Aug, 2018
--------------------------
* Ignore unsupported Freetype functions
* Fixed `#define` errors.

Dagon 0.8.1 - 17 Aug, 2018
--------------------------
Fix to work with DMD 2.081.0.

Dagon 0.8.0 - 25 May, 2018
--------------------------
**IMPORTANT: this release doesn't work with DMD 2.081.0. Please, use Dagon 0.8.2.**

- **Rendering**
  - Dagon now requires OpenGL 4.0 (because of need for `glBlendFunci`). A long-term plan is to move to 4.3 to utilize compute shaders
  - `ParticleBackend` - a dedicated material backend for particle systems. It supports diffuse texture, per-particle color and transparency. Particle system now uses `GenericMaterial` instead of `Material`
- **Materials**
  - Non-opaque blending modes now work correctly for all shaders. `Additive` mode now takes transparency into account
  - More material properties are supported by standard shader, namely, `shadeless`, `shadowFilter`, `transparency`
- **Assets & logics**
  - Package assets support. A package asset is a [Box](https://github.com/gecko0307/box) container that stores meshes, entities, materials (for standard shader) and textures. They can be added directly to the scene or referenced using drawable mechanism, so you can use package assets both for level geometry and dynamic objects. [Exporter for Blender](https://github.com/gecko0307/dagon/blob/master/tools/io_export_dagon_asset.py) is available. Format specification is [here](https://github.com/gecko0307/dagon/blob/master/tools/asset-format-spec.md)
  - `Scene` have been renamed to `BaseScene`, `BaseScene3D` have been renamed to `Scene` (there is an alias for backward compatibility)
  - Factory methods for creating assets (like `addTextureAsset`) are now part of `Scene` (former `BaseScene3D`). New factory methods have been added: `addOBJAsset`, `addIQMAsset`, `addPackageAsset`
  - `Entity` class now implements `Drawable` interface, meaning that entities can render other entities. This is especially useful to render multiple instances of the same package asset
  - Entity children are now sorted by layer when new entity is added to a scene.

Dagon 0.7.0 - 17 May, 2018
--------------------------
**IMPORTANT: this release doesn't work with Dub due to erroneous package description file. If you use Dub to manage dependencies, please, add Dagon source code to your project manually (and specify its dependencies from `dub.json` as well) or wait for 0.8.0. Sorry for the inconvenience.**

- **Rendering**
  - The engine now uses HDR rendering with auto-exposure (eye adaptation). Available tone mapping operators are Reinhard, Hable (Uncharted 2) and ACES
  - Default rendering path now outputs minimal G-Buffer consisting of eye-space position buffer, normal buffer and luminance buffer for faster average luminance calculation
  - Equirectangular HDRI environment maps support
  - Improved CSM shadows. Cascades now more efficiently fit the frustum, resulting in significantly better shadows quality near the camera. Also shadow coordinates now can be height-corrected when using with parallax mapping, which gives more accurate shadow look on corners. Shadow brightness and color can now be adjusted
- **Materials**
  - Legacy material backends (`BlinnPhongBackend` and `BlinnPhongClusteredBackend`) have been removed. `StandardBackend` (former `PBRClusteredBackend`) should be used instead (which is already used by default)
  - Cook-Torrance BRDF is now used in standard shader instead of Blinn-Phong (both for sun light and point/area lights)
  - Texture support for `roughness` and `metallic` material properties
  - `energy` property for `GenericMaterial` which controls emission brightness 
  - Improved standard shader performance, especially on low-end systems
- **Post-processing**
  - New post-processing filters: camera motion blur, HDR glow, LUT color grading, improved lens distortion. Post-processing stack is now a part of `BaseScene3D`. Many filters are built-in, so you only have to enable them (they can be enabled/disabled individually). Read more on filters setup [here](https://github.com/gecko0307/dagon/wiki/Tutorial-9.-Post-processing).
- **Assets & logics**
  - New built-in primitive shape - UV sphere
  - Improved procedural sky. Sky dome geometry is now generated by the engine, and sky shader uses HDR. Default sky/environment colors are also changed
  - Layer system. Entities, both 2D and 3D, now have a `layer` property that is used to sort them for rendering. Larger layers are rendered last. All normal entities are created on layer 1 by default
  - `FirstPersonCamera` now calculates and stores 'weapon' matrix - a matrix that can be used to transform weapons and other handheld items in order to align them to camera
  - Driving wheels support
- **Misc**
  - Dagon now uses dlib 0.13.0
  - [Tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials) were added to project's wiki.

Dagon 0.6.0 - 4 Dec, 2017
-------------------------
* Experimental support for PBR materials (`dagon.graphics.materials.pbrclustered`). PBR material backend works in linear space and outputs tonemapped value using Hable function. Current limitations are constant-based `metallic` and `roughness` parameters (no texture support for them) and no custom environment maps support (sky parameters are used for procedural environment map). Eventually these features will be implemented.
* HDR textures.
* `energy` parameter for light sources.
* Transparency support for `ShadelessBackend`.
* `BaseScene3D` now provides all entities with default material.
* Dynamic scaling for particles.
* Better default colors for `Sky`.
* Improved shadows.
* Different attachement logic for entities - parent/child relation, camera-invariant, screen-invariant.
* Joystick support has been added to `EventManager`. Games that use joystick must be shipped with `gamecontrollerdb.txt` file to automatically configure button mappings (otherwise mapping will be unpredictable).

Dagon 0.5.0 - 25 Oct, 2017
--------------------------
* Dagon now uses OpenGL 3.3.
* Light clustering engine now uses dynamic domain that is centered around the camera.
* Area light support.
* `BlinnPhongClusteredBackend` is now used as default material backend in `BaseScene3D`.
* Shadows are now integral part of `BaseScene3D`.

Dagon 0.4.0 - 14 Sep, 2017
--------------------------
This is the last release of Dagon for legacy OpenGL. All future development will be based on [gl33](https://github.com/gecko0307/dagon/tree/gl33) branch.

* Dagon now uses OpenGL 2.1.
* Shadows now internally use CSM via texture array. Simple shadow maps are not supported.
* Parallax mapping in `ClusteredBlinnPhongBackend` is now turned off when no height data provided to material.
* Added an ability to turn off sky colors.

Dagon 0.3.0 - 7 Sep, 2017
-------------------------
* Clustered forward shading (`dagon.graphics.clustered`) - a technique that allows to have hundreds of dynamics lights without significant performanse loss.
* New material backend - `BlinnPhongClusteredBackend`, which supports clustered shading and implements normal/parallax mapping. `NonPBRBackend` is renamed to `BlinnPhongBackend`.
* Improved environment handling. New sky material backend (`SkyBackend`) that implements dynamic procedural skydome with day/night cycle.
* Post-processing framework. Two post-processing filters are available at the moment - FXAA and lens distortion.

Dagon 0.2.0 - 11 Aug, 2017
--------------------------
* `dagon.graphics.particles` - a particle system with force fields support. Currently supported force fields are `Attractor`, `Deflector`, `Vortex`, `BlackHole` and `ColorChanger`. Particle emitter itself works as a `Behaviour` and should be attached to `Entity`.
* `dagon.graphics.shadow` - initial shadow map support with experimental GLSL-based `NonPBRBackend` for `GenericMaterial`.
* Breaking change: `Drawable` now defines `void render(RenderingContext* rc)` instead of `void render()`.
* Breaking change: simplified API for `GenericMaterialBackend`.
* Parallel lights support in `dagon.graphics.light`.

Dagon 0.1.1 - 8 Jun, 2017
-------------------------
* 64-bit fix under Windows.

Dagon 0.1.0 - 8 Jun, 2017
-------------------------
* Excluded dmech from core Dagon, it is now part of demo application
* Use dlib 0.11.1
* `FirstPersonView` now utilizes SDL's relative mouse mode and can be activated/deactivated
* Fixed lots of bugs, including asset management bug with reloading scenes.
  
Dagon 0.0.3 - 10 Apr, 2017
--------------------------
- Removed libraries from main repository, they now should be downloaded separately from [here](https://github.com/gecko0307/dagon/releases/tag/v0.0.2).
- Demos are now hosted as a [separate project](https://github.com/gecko0307/dagon-demo)
* Material system
* OBJ format support
* Font and text support
* Box container support
* BaseScene3D
* Added unittests for Entity
* A lot of small changes and bugfixes.

9 Oct, 2016
-----------
Project started.
