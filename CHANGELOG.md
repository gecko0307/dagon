Dagon 0.16.0 - TBD
------------------
- **Rendering**
  - Approximated subsurface scattering support
  - Environment light probes support
- **Assets**
  - `EntityManager` is now `World`
  - `EntityGroup*` accessor classes moved to `dagon.graphics.world`
  - New material property, `subsurfaceScattering`.

Dagon 0.15.0 - 31 Aug, 2023
---------------------------
- **Core**
  - Relative mouse mode support (`EventManager.setRelativeMouseMode`)
  - `dagon.core.locale`: fix deprecations in Windows locale API signatures
- **Assets**
  - 1D and 3D textures support
  - Embedded images support in glTF loader
  - `dagon.graphics.texture`: New methods `Texture.setFaceImage`, `Texture.setFaceBit`, new function `cubeFaceBit`
  - `dagon.graphics.cubemap` module is deprecated, use `dagon.graphics.texture` instead
  - Deprecated material properties have been removed
- **Post-processing**
  - [Hald CLUT](http://www.quelsolaar.com/technology/clut.html) support in LUT shader + `Texture.createFromImage3D` method. When you use a 3D texture as a lookup table, the shader will automatically switch to the Hald mode
  - Manual mode parameters for DoF filter: `dofManual`, `dofNearStart`, `dofNearDistance`, `dofFarStart`, `dofFarDistance`
- **UI**
  - `FirstPersonViewComponent` uses relative mode by default, and it can be switched with `useRelativeMouseMode` property
- **Extensions**
  - Updated Newton binding
  - `NewtonUserJointSetRowSpringDamperAcceleration` was removed in favor of `NewtonUserJointSetRowMassDependentSpringDamperAcceleration` and `NewtonUserJointSetRowMassIndependentSpringDamperAcceleration`
  - New method `NewtonRigidBody.localPointVelocity`
- **Misc**
  - Dagon now uses dlib 1.2.1.

Dagon 0.14.1 - 9 Sep, 2022
--------------------------
- **Misc**
  - Update init-exec template code

Dagon 0.14.0 - 27 Aug, 2022
---------------------------
- **Core**
  - Custom event dispatcher (`EventManager.onProcessEvent`) that provides access to raw SDL events
- **Rendering**
  - `dagon.render.deferred` package is now `dagon.render.passes`
  - Unreal and Reinhard2 tonemapping operators (`Tonemapper.Unreal` and `Tonemapper.Reinhard2`, respectively)
- **Assets**
  - `Material` now provides a new set of explicit properties for direct compatibility with glTF (texture properties always take precedence over factor properties):
    - `diffuse` is now `baseColorTexture` and `baseColorFactor`
    - `roughnessMetallic` is now `roughnessMetallicTexture`
    - `roughness` is now `roughnessFactor`
    - `metallic` is now `metallicFactor`
    - `emission` is now `emissionTexture` and `emissionFactor`
    - `energy` is now `emissionEnergy`
    - `normal` is now `normalTexture` and `normalFactor`
    - `height` is now `heightTexture` and `heightFactor`
    - `transparency` is now `opacity`
    - `clipThreshold` is now `alphaTestThreshold`
    - `blending` is now `blendMode`
    - `parallax` is now `parallaxMode`
    - `shadowsEnabled` is now `useShadows`
    - `fogEnabled` is now `useFog`
    - `culling` is now `useCulling`
  - Old material properties are still supported, but deprecated and write-only. `Material.roughness` and `Material.metallic` now don't support textures
  - Texture system redesign. `Texture` class now can be created from raw pixel data without intermediate `SuperImage`, hense DDS textures are now loaded directly to `Texture` object without additional layers of abstraction. Also `Texture` now supports cubemaps in addition to 2D textures
  - New texturing system for terrains
  - Added support for ASTC texture compression format
  - New module `dagon.graphics.texproc` with `combineTextures` function
  - `alphaMode` support for glTF materials
- **Game**
  - New methods: `Game.resize`, `Game.frameTexture`
- **Extensions**
  - Experimental [Dear ImGui](https://github.com/ocornut/imgui) extension, `dagon.ext.imgui`. It is based on [bindbc-imgui](https://github.com/Inochi2D/bindbc-imgui) binding. It will not replace Nuklear, both toolkits will coexist in future
  - New constraint `NewtonUserJointConstraint` in Newton extension
  - Fix raycast in Newton extension
  - `libnewton.so` and `libnuklear.so` are now loaded from `/usr/local/lib` under Posix
  - Fix CMake configuraiton for installing Nuklear in `/usr/local/lib` under Posix.

Dagon 0.13.0 - 2 Mar, 2022
--------------------------
- **Core**
  - State for joystick buttons in `EventManager` (`joystickButtonPressed`, `joystickButtonUp`, `joystickButtonDown`)
- **Rendering**
  - Fixed state validation failure on AMD (different sampler types for same sample texture unit). Cubemap and equirectangular environment map now use different texture units
- **Assets**
  - Images are now loaded using callback mechanism in `AssetManager`. You can register your own loader function with `AssetManager.registerImageLoader` method
  - Dagon now uses dlib.image to load images by default. stb_image is available through `dagon:stbi` extension. Import `dagon.ext.stbi` module and register the loader with `stbiRegister` function in your scene constructor:
    ```json
    stbiRegister(assetManager);
    ```
  - OBJ loader now supports quads
  - `emissiveFactor` support for glTF materials
  - `Entity.setRotation`
- **Post-processing**
  - Motion blur shader now supports static radial blur - enable it with `PostProcRenderer.radialBlurAmount`. Fixed `Entity.blurMask` for objects rendered via forward pipeline. Mask is now used to smoothly decrease motion blur in a processed fragment, which allows to fully avoid undesirable blur leaks inside entities with `blurMask` property set to `0`
  - New properties to control lens distortion effect: `PostProcRenderer.lensDistortionDispersion`, `PostProcRenderer.lensDistortionScale`
- **Extensions**
  - `dagon.ext.physics` was removed in favour of `dagon.ext.newton`
  - `NewtonRigidBody.addForceAtPos` now works correctly. Added `NewtonRigidBody.centerOfMass`
  - `NewtonConvexHullShape` is now created from `TriangleSet` instead of `Mesh`
  - Fixed compilation of `dagon.ext.iqm`. Added `Actor.blendSpeed` property. Switching `Actor` animation to the same frame range as the current one now doesn't cause loop reset
- **Debugging tools**
  - Shader programs are now validated against current OpenGL state in debug mode. Invalid shader causes application exit
  - Debug output messages are now more informative, they include textual definitions of message source, type and severity instead of numeric constants. Issues with high severity cause application exit.
- **Misc**
  - Dagon now uses dlib 1.0.0.

Dagon 0.12.1 - 29 Oct, 2021
---------------------------
- Fixed a bug with wrong rendering in `SkyShader`.

Dagon 0.12.0 - 26 Oct, 2021
---------------------------
No changes since 0.12.0-beta2.

Dagon 0.12.0-beta2 - 11 Oct, 2021
---------------------------------
Changes since 0.12.0-beta1:
- **Rendering**
  - Background color is now used correctly
  - Any entity can use terrain shader
  - `Entity.gbufferMask` to store the value that should be written to alpha channel of color buffer in G-buffer
  - Support `light.diffuse`, `light.specular` in sun light shader
- **Newton extension**
  - `FirstPersonViewComponent.baseOrientation`
  - `NewtonRigidBody.addImpulse`
  - `NewtonRigidBody.createUpVectorConstraint` now returns `NewtonJoint` pointer.
- **Misc**
  - Dagon now uses dlib 0.23.0.

Dagon 0.12.0-beta1 - 13 Sep, 2021
---------------------------------
- **Rendering**
  - `Light.diffuse` and `Light.specular` parameters that control brightness of diffuse and specular portions of a light
  - New parameters for particle system objects: `ForceField.active`, `BlackHole.threshold`
  - Ability to limit camera pitch angle in`FirstPersonViewComponent` (`pitchLimitMax` and `pitchLimitMin` parameters)
  - Fixed a bug in Sky shader that didn't write proper data to albedo buffer
  - Fixed a bug in HUD shader with invalid `va_Texcoord` uniform location
  - Fixed "black dots" bug with area lights
- **Assets**
  - Initial [glTF](https://www.khronos.org/gltf/) format support (without animation)
  - DDS cubemaps support, in 32 and 16-bit RGBA floating-point formats and with pre-baked mipmaps
  - Decoding of generic image formats such as PNG and JPEG now relies on [stb_image](https://github.com/nothings/stb), resulting in substantial loading speedup for large images. Also PSD and GIF formats are now supported
  - `Material` now supports `roughnessMetallic` parameter to pass combined PBR texture. Following glTF convention, G channel stores roughness and B stores metallic
  - Cubemaps now can be created from any image (equirectangular HDR or DDS with mipmaps) using `fromImage` method
  - Built-in disk shape (`dagon.graphics.shapes.ShapeDisk`)
- **Post-processing**
  - Depth of Field effect (`dagon.postproc.shader.dof`)
  - `DeferredRenderer.occlusionBufferDetail` parameter that controls resolution coefficient of SSAO buffer
- **Extensions**
  - `dagon:newton` extension that integrates [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) real-time physics engine. Newton provides better performance and stability compared to dmech, as well as new features such as convex hulls for dynamic bodies and heightmap collision shapes for terrains
- **Misc**
  - Dagon now uses SDL 2.0.14, dlib 0.22.0, bindbc-loader 1.0.0, bindbc-sdl 1.0.0, bindbc-opengl 1.0.0
  - Dagon now recognizes a configuration file (`settings.conf`) in project folder. Configuration overrides some of the hardcoded application settings, such as window width and height, fullscreen and window title
  - Under Windows now it is possible to hide console window by specifying `hideConsole: 1;` in `settings.conf`.

Dagon 0.11.0 - 21 Oct, 2020
---------------------------
Changes since 0.11.0-beta2:
- **Misc**
  - Dagon now uses dlib 0.20.0.

Dagon 0.11.0-beta2 - 10 Oct, 2020
---------------------------------
Changes since 0.11.0-beta1:
- **Rendering**
  - Filmic tonemapper support
  - Emission texture is now sampled correctly, with gamma to linear conversion
- **Misc**
  - Dagon now uses dlib 0.20.0-beta1.

Dagon 0.11.0-beta1 - 7 Oct, 2020
--------------------------------
**Important:** This release features major redesign of almost every component in the engine and **breaks compatibility with old code**.

Changes:
- **Overall**
  - Source tree structure was changed to reduce coupling. Now all modules strictly depend only on modules in the same or lower-level package. See #54 for details. `dagon.logics` is gone, its modules were moved to `dagon.graphics`
  - New extension infrastructure based on DUB subpackages to keep core Dagon more lightweight and easier to install. Currently there are four extensions - Nuklear integration, Freetype font loader, IQM model loader, and a physics engine, which are no more available from `dagon` package. You should explicitly add them to your DUB dependencies as `dagon:nuklear`, `dagon:ftfont`, `dagon:iqm`, `dagon:physics`. They are importable as `dagon.ext.nuklear`, `dagon.ext.ftfont`, `dagon.ext.iqm`, `dagon.ext.physics`. To create font assets, use `addFontAsset` which is now a free function, not a scene method. The same is for IQM assets (`addIQMAsset`)
  - Added new package `dagon.game` - a template application with typical game-oriented rendering setup and a fixed-step update timer
- **Core**
  - New module `dagon.core.time` which contains `Time` helper structure and `Cadencer` class
- **Rendering**
  - Renderer was entirely rewritten from scratch based on a new concept of pipelines (see `dagon.render` package). A pipeline is a sequence of draw call groups - passes. Each pass traverses a subset of scene objects and renders them to a given buffer using a given shader. For example, a deferred pipeline contains geometry pass that fills G-buffer, environment pass and lighting pass
  - Volumetric scattering (aka 'God rays') for sun light
  - Improved PBR - new roughness to lod mapping for environment maps, better looking metals and shiny dielectrics
  - Multiple optimizations across the renderer, including less shader switches and data copying, timer fixes, etc. 25-30% performance boost on some systems
  - Render viewports can now be resized in runtime
  - Standard shaders moved to `dagon.render.shaders`
  - Discrete LOD drawables (`dagon.graphics.lod`). They render different user-specified drawables based on distance from the camera
  - Now there's no `Scene.mainSun` - fallback light source should be set for each transparent material using `Material.sun` property
- **Materials**
  - `specularity` property for materials. It specifies a luminance coefficient for the specular radiance component. It doesn't have a physical meaning, but is useful for material tweaking, for example to eliminate burnt highlights.
  - Improved water shader, animated waves support
- **Assets**
  - DDS format support for textures. Supported compression types are S3TC (DXT1/BC1, DXT3/BC2, DXT5/BC3), RGTC (BC4, BC5), BPTC (BC6H, BC7)
- **Environment**
  - `Environment` object was simplified. Now there's no default environment map, only `environment.ambientColor` and `environment.ambientMap`.
- **Post-processing**
  - Post-processing engine was also reimplemented and now exists as a separate render pipeline. See `dagon.postproc` and `dagon.game.postprocrenderer`
  - Denoise filter for SSAO. A lot less samples are now needed to achieve smooth ambient occlusion. Also SSAO is now rendered into a separate buffer, so that its resolution can be lowered for better performance, and occlusion data can be used at several stages of the pipeline
- **UI**
  - File drag-and-drop event
- **Misc**
  - `dagon:ftfont` uses [official BindBC Freetype binding](https://github.com/BindBC/bindbc-freetype) instead of custom one.

Dagon 0.10.2 - 24 Dec, 2019
---------------------------
- Use dlib 0.17.0
- Fix warnings with recent compiler versions.

Dagon 0.10.1 - 14 Jun, 2019
---------------------------
- Alpha cutout for shadows. Partially transparent objects now cast correct shadows
- UTF8 support in Nuklear clipboard callbacks - Unicode copy/paste now work correctly.

Dagon 0.10.0 - 31 Mar, 2019
---------------------------
- **Rendering**
  - Terrain renderer with image-based and procedural (OpenSimplex noise) heightmaps. Thanks to Rafał Ziemniewski for the implementation
  - Decals support in deferred renderer. Decals are special `Entities` that project a texture/material to geometry in the G-buffer. They can be used to place details over static geometry, such as bullet holes, graffiti, blood, dirt, footprints, clutter, etc. By default they project along -Y axis (towards the ground), but they can be transformed like any other `Entity` to project on non-horizontal surfaces as well. Decal is created using `Scene.createDecal`. Decals are visible only on Entities with `dynamic` property turned off. To create a decal material, use `Scene.createDecalMaterial`. Decal material properties are the same as for standard materials - they can have diffuse, normal, roughness, metallic and emission maps
  - Tube area lights support in deferred renderer. These are capsule-like lights that have length and radius. `Scene.createLight` is now deprecated, use `Scene.createLightSphere` and `Scene.createLightTube` instead
  - Spot lights support. They can be created using `Scene.createLightSpot` method
  - Custom directional lights support. They can be created using `Scene.createLightSun` method
  - Shadow rendering mechanism has been changed. Now there's no global shadow map, each directional light can have its own shadow map. It is turned on by `light.shadow = true`
  - Particles now don't drop shadows if `dropShadow` is set to false for emitter's `Entity`
  - `CascadedShadowMap.eyeSpaceNormalShift` - controls displacement of shadow coordinates by the surface normal (0.008 by default)
- **Materials**
  - Cubemap textures support (`dagon.graphics.cubemap`). You can build a cubemap from individual face images, generate from equirectangular environment map, or render the scene into cubemap
  - `ImageAsset` - a new asset type for loading raw images with Dagon, without creating OpenGL textures for them. They are useful to load cubemaps, as well as to store non-color data. `ImageAsset` supports the same formats as `TextureAsset` - PNG, JPEG, TGA, BMP, HDR
  - `textureScale` property for materials - bidirectional scale factor for texture coordinates
  - Built-in terrain shader (`dagon.graphics.shaders.terrain`) with 4 texture layers and splatting. Each layer supports diffuse and normal maps. To create terrain material, use `Scene.createTerrainMaterial`. Textures are passed via material properties, `diffuse` and `normal` being the first layer, `diffuse2` and `normal2` the second, and so on. There are also `textureScale`, `roughness` and `metallic` for each layer (`textureScale2`, etc). Roughness and metallic properties are limited to numeric values. Splatting textures (that is, bw textures that define blending between layers) are passed using `splatmap1`, `splatmap2`, etc.
- **UI**
  - [Nuklear](https://github.com/vurtun/nuklear) integration (`dagon.ui.nuklear`). It is a lightweight immediate mode GUI toolkit which can be used to render windows and widgets over the rendered scene. To use Nuklear, create `NuklearGUI` object and attach is to 2D entity's drawable, then use its methods to 'draw' widgets in `onLogicsUpdate` (API is very close to original Nuklear functions). Nuklear also provides a canvas windget to draw 2D vector shapes - lines, Bezier curves, rectangles, circles, arcs, triangles, and polygons. Thanks to [Mateusz Muszyński](https://github.com/Timu5) for the implementation and [bindbc-nuklear](https://github.com/Timu5/bindbc-nuklear) binding
- **Environment**
  - Breaking change: now there is no default sun for deferred renderer, it should be created explicitly. Forward mode shaders still use sun settings from `Environment` (as well as sky shaders), so these settings should be synced with a custom `LightSource` by specifying `Scene.mainSun`:
```d
    mainSun = createLightSun(Quaternionf.identity, environment.sunColor, environment.sunEnergy);
    mainSun.shadow = true;
```
  - Breaking change: `Environment.environmentMap` now is used only for image-based lighting - to apply an environment map to sky object, use `Environment.skyMap` property. Both of them now support `Cubemap` textures also
  - `Environment.environmentBrightness` was added. It is a final brightness multiplier applied to environment map, both texture-based and procedural
  - `Environment.skyBrightness` was added. It is a final brightness multiplier in standard sky shader
  - Built-in sky object now uses `ShapeBox` instead of `ShapeSphere`
- **Post-processing**
  - Breaking change: post-processing settings are now part of the `Renderer` class, not `Scene`
  - Improved HDR glow quality. New glow parameters have been added to `Scene`: `minLuminanceThreshold`, `maxLuminanceThreshold`. They define luminance range in which glow should be gradually decreased (`minLuminanceThreshold` - glow is zero at this luminance and lower, `maxLuminanceThreshold` - glow is full bright at this luminance and higher).
- **Assets & logics**
  - Transformation methods for `Entity`: `translate`, `rotate`, `move`, `moveToPoint`, `strafe`, `lift`, `pitch`, `turn`, `roll`, `scale`, `scaleX`, `scaleY`, `scaleZ`, `direction`, `right`, `up`
  - Now `Entity` has two separate rotation mechanisms - quaternion (`Entity.rotation`) and axis-angles vector (`Entity.angles`). You can use any of the two, or both simultaneously. This distinction was introduced to simplify user-programmed rotations while maintaining easy integration of quaternion-based systems (such as dmech). Axis-angles vector represents sequiential rotation around three local axes (X, Y, Z) in degrees. This rotation is always applied after the quaternion, so you can use `Entity.rotation` as a 'primary' rotation coming from physics engine, and `Entity.angles` as a 'secondary' rotation applying only to graphical representation of the object
  - Basic animation tweens (`dagon.logics.tween`) - objects that interpolate `Entity` transformation over time with easing functions. There are several common in and out easing functions (linear, quad, back, bounce). To create tweens, use `Entity.moveTo`, `Entity.moveFrom`, `Entity.moveFromTo`, `Entity.rotateTo`, `Entity.rotateFrom`, `Entity.rotateFromTo`, `Entity.scaleFrom`, `Entity.scaleTo`, `Entity.scaleFromTo`
  - `Entity.dynamic` to distinguish static/dynamic objects in renderer (you still can move static objects). Static entities are rendered before decals and meant to be immovable
  - Now `Entity` doesn't have default controller. `DefaultEntityController` functionality was integrated into `Entity`. Custom controllers are still supported
  - `Scene.deleteEntity` method
  - `BoxShape` in `dagon.graphics.shapes`
  - `Scene.asset` - generic asset adding method
  - Update timer was fixed, so that the application runs with a consistent speed at varying framerates. Dagon games are now playable on low-end hardware
- **Misc**
  - A simple configuration system. Dagon applications now support optional [settings.conf](https://github.com/gecko0307/dagon/blob/master/settings.conf) file in the working directory or in user's home directory (`%APPDATA%/.dagon` under Windows, `$HOME/.dagon` under Posix). You can access loaded configuration via `SceneApplication.config` property
  - `dagon.core.input.InputManager` - an abstraction layer for mapping between logical commands and input events (thanks to [Mateusz Muszyński](https://github.com/Timu5) for the implementation). It allows to remap inputs without changing code. It supports keyboard, mouse and game controller devices. Mapping are stored in `input.conf` file, which has the same syntax as `settings.conf`:
```
    upDownAxis: "ga_lefty, va(kb_down, kb_up)";
    myButton: "kb_p, gb_leftshoulder";
```
  - `dagon.core.locale` - a module that detects system locale. It can be used to automatically switch application's language
  - In debug builds Dagon now shows informative error messages from graphics driver using debug output extension (GL_KHR_debug) when it is available
  - BindBC bindings have been excluded from source tree and used as Dub dependencies. Freetype binding is now a separate project, [bindbc-ft](https://github.com/gecko0307/bindbc-ft)
  - Dagon can be compiled without Freetype and Nuklear dependencies (thus disabling text and UI rendering). See README.md for details on how to do it
  - Dagon now uses dlib 0.16.0.

Dagon 0.9.2 - 20 Nov, 2018
--------------------------
- Fix GL_INVALID_OPERATION error.

Dagon 0.9.1 - 17 Nov, 2018
--------------------------
- Fix shadows for semi-transparent particles
- Fix 'not reachable' warning
- Performance optimization by reducing shader switching for some passes.

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
* Removed libraries from main repository, they now should be downloaded separately from [here](https://github.com/gecko0307/dagon/releases/tag/v0.0.2).
* Demos are now hosted as a [separate project](https://github.com/gecko0307/dagon-demo)
* Material system
* OBJ format support
* Font and text support
* Box container support
* BaseScene3D
* Added unittests for Entity
* A lot of small changes and bugfixes.

Dagon 0.0.2 - 5 Apr, 2017
-------------------------
Added Dagon to DUB package registry.

Dagon 0.0.1 - 28 Mar, 2017
-------------------------
Initial release.

9 Oct, 2016
-----------
Project started.
