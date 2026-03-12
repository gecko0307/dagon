# Features

* Scene graph
* Virtual file system
* Static and animated meshes
* Native [glTF 2.0](https://www.khronos.org/gltf/), [OBJ](https://en.wikipedia.org/wiki/Wavefront_.obj_file) and [IQM](https://github.com/lsalzman/iqm) formats support. [FBX](https://en.wikipedia.org/wiki/FBX) and many other model formats support via [Assimp](https://github.com/assimp/assimp) library
* GPU skinning
* Textures in PNG, JPEG, WebP, AVIF, DDS, KTX, KTX2, HDR, SVG and many other formats
* S3TC (DXTn), RGTC, BPTC, [Basis Universal](https://github.com/BinomialLLC/basis_universal) texture compression support. Built-in DXT1/DXT5 compressor and DDS exporter
* GPU-based texture resizing
* Video support using [libVLC](https://www.videolan.org/vlc/libvlc.html). Screen-aligned 2D video playback and video textures on 3D meshes. Equirectangular 360° video support
* Runs in windowed, fullscreen and borderless fullscreen modes
* HiDPI support
* Hybrid rendering pipeline: deferred for opaque materials, forward for transparent materials and materials with custom shaders
* Physically based rendering (PBR) with GGX microfacet BRDF. Metallic-roughness workflow
* HDR rendering with all industry-standard tonemapping operators, including Reinhard, Hable/Uncharted, Unreal, ACES, Uchimura, AgX and Khronos PBR Neutral. Automatic exposure support
* HDRI environment maps. Equirectangular HDRI to cubemap conversion. GPU-based cubemap prefiltering with importance sampling. Loading prebaked cubemaps from DDS or KTX files
* Directional lights with cascaded shadow mapping
* Spherical and tube area lights with dual paraboloid shadow mapping
* Spot lights with perspective shadow mapping
* Volumetric light scattering support for all light types. Henyey-Greenstein scattering anisotropy for directional lights
* Local environment probes with box-projected cube mapping for approximated interior GI
* Normal mapping, parallax mapping, parallax occlusion mapping
* Deferred decals with normal mapping and PBR material properties
* Built-in Rayleight sky shader
* Particle system with force fields. Blended particles, soft particles, shaded particles with normal map support, particle shadows
* Terrain rendering. Procedural terrain using OpenSimplex noise or any custom height field. Deferred texturing for terrains
* Water rendering. Realistic ocean shader with Gerstner waves
* Cinematic post-processing (depth of field, lens distortion, motion blur, glow, vignetting, film grain, color correction, LUT, contrast adaptive sharpening). Custom post-processing filters support
* Simplified render pipeline for casual-style graphics. Retro rendering support: pixelization and vertex snapping
* Tween engine for simple animation. Delayed function calls
* Input from keyboard, mouse and up to 4 gamepads. Input manager with abstract bindings and file-based configuration
* Unicode text input
* Graphics tablet input (Windows-only)
* Ownership memory model
* Entity-component model
* Fast arena allocator
* Compute shaders
* Microservices and worker threads for running tasks in background, so that they don't block the main game loop
* Asynchronous thread-safe messaging. Use the message broker built into the event system to communicate between threads and the main loop
* Built-in camera logics for easy navigation: freeview and first person views
* Collision detection using MPR algorithm, raycasting, simple kinematic collision response system
* Chunk-based culling for managing large game worlds. Optional "floating origin" system to maintain high coordinate precision
* Rigid body physics using [Newton Dynamics](http://newtondynamics.com). Built-in character controller
* [Jolt Physics](https://github.com/jrouwe/JoltPhysics) integration (in development)
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
[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated.jpg)

[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated1.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated1.jpg)

[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated3.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated3.jpg)

[![Sakura](https://blog.pixperfect.online/wp-content/uploads/2026/03/001.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/03/001.jpg)

[![Sakura](https://blog.pixperfect.online/wp-content/uploads/2026/03/002.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/03/002.jpg)

[![Space](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/space.jpg)

[![Chillwave Drive](https://blog.pixperfect.online/wp-content/uploads/2025/05/chillwave-drive.jpg)](https://blog.pixperfect.online/wp-content/uploads/2025/05/chillwave-drive.jpg)
