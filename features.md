# Features

* Scene graph
* Virtual file system
* Static and animated meshes
* Native [glTF 2.0](https://www.khronos.org/gltf/), [OBJ](https://en.wikipedia.org/wiki/Wavefront_.obj_file) and [IQM](https://github.com/lsalzman/iqm) formats support. [FBX](https://en.wikipedia.org/wiki/FBX) and many other model formats support via [Assimp](https://github.com/assimp/assimp) library
* GPU skinning
* Textures in PNG, JPEG, WebP, AVIF, DDS, KTX, KTX2, HDR, SVG and many other formats
* GPU-based texture resizing
* Video support using [libVLC](https://www.videolan.org/vlc/libvlc.html). Screen-aligned 2D video playback and video textures on 3D meshes. Equirectangular 360° video support
* Runs in windowed, fullscreen and borderless fullscreen modes
* HiDPI support
* Hybrid rendering pipeline: deferred for opaque materials, forward for transparent materials and materials with custom shaders
* Physically based rendering (PBR)
* HDR rendering with many tonemapping operators, including Reinhard, Hable/Uncharted, Unreal, ACES, Filmic, AgX, and Khronos PBR Neutral
* HDRI environment maps. Equirectangular HDRI to cubemap conversion. GPU-based cubemap prefiltering with GGX BRDF and importance sampling. Loading prebaked cubemaps from DDS or KTX files
* Directional lights with cascaded shadow mapping
* Spherical and tube area lights with dual paraboloid shadow mapping
* Spot lights with perspective shadow mapping
* Volumetric light scattering (isotropic for area lights, anisotropic for directional lights)
* Local environment probes with box-projected cube mapping for approximated interior GI
* Normal/parallax mapping, parallax occlusion mapping
* Deferred decals with normal mapping and PBR material properties
* Dynamic skydome with sun and day/night cycle
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field. Deferred texturing for terrains
* Water rendering. Realistic ocean shader with Gerstner waves
* Post-processing (FXAA, SSAO, DoF, lens distortion, motion blur, glow, color grading)
* Simplified render pipeline for casual-style graphics. Retro rendering support: pixelization and vertex snapping
* Tween engine for simple animation. Delayed function calls
* Input from keyboard, mouse and up to 4 gamepads. Input manager with abstract bindings and file-based configuration
* Unicode text input
* Graphics tablet input
* Ownership memory model
* Entity-component model
* Fast arena allocator
* Compute shaders
* Microservices and worker threads for running tasks in background, so that they don't block the main game loop
* Asynchronous thread-safe messaging. Use the message broker built into the event system to communicate between threads and the main loop
* Built-in camera logics for easy navigation: freeview and first person views
* Collision detection using MPR algorithm, raycasting
* Rigid body physics extension that uses [Newton Dynamics](http://newtondynamics.com). Built-in character controller
* Orthographic projection support. Screen-aligned rendering. Sprites and billboards. Create 2D/2.5D/isometric games with ease
* UTF-8 text rendering using TTF fonts via [FreeType](https://freetype.org/)
* Internationalization support
* GUI extension based on [Dear ImGui](https://github.com/ocornut/imgui)
* Native file open/save dialogs (for Windows, GTK, and Qt)
* Very basic and lightweight built-in UI toolkit
* 2D/3D sound. Various audio formats support including WAV, MP3, OGG/Vorbis, FLAC. Stereo, 5.1, 7.1 support
* VR support (in development).

Screenshots
-----------
[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2025/05/sponza.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/sponza.jpg)

[![Space](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)

[![Ocean](https://blog.pixperfect.online/wp-content/uploads/2025/08/ocean5.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/08/ocean5.jpg)

[![Forest](https://blog.pixperfect.online/wp-content/uploads/2025/05/forest.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/forest.jpg)

[![Chillwave Drive](https://blog.pixperfect.online/wp-content/uploads/2025/05/chillwave-drive.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/chillwave-drive.jpg)

[![Eevee vs Dagon](https://blog.pixperfect.online/wp-content/uploads/2025/05/eevee_vs_dagon.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/eevee_vs_dagon.jpg)
