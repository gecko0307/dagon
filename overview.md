# Dagon Engine

[Dagon](https://github.com/gecko0307/dagon) is an Open Source 3D game development framework based on OpenGL 4.3 core profile and SDL2. The goal of this project is to create a modern, easy to use, extensible 3D game engine for [D language](https://dlang.org/).

> Note: this project is not connected to Dagon engine by Senscape.

[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated.jpg)

[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated1.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated1.jpg)

[![Sponza](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated3.jpg)](https://blog.pixperfect.online/wp-content/uploads/2026/02/sponza_updated3.jpg)

## Platform Support

Dagon currently works on Windows and Linux. The engine is only desktop, support for mobile and web platforms is not planned.

Dagon uses computation-heavy graphics techniques and so requires a fairly powerful graphics card to run (Ampere-based NVIDIA GPUs are recommended for optimal performance).

The recommended system requirements (for Full HD rendering at 60 fps):
- **CPU:** Intel Core i3-10100 / AMD Ryzen 3 3100
- **RAM:** application-dependent, usually 8 Gb minimum
- **GPU:** GeForce RTX 30 / Radeon RX 6000 series
- **VRAM:** 8 Gb
- **OS:** 64-bit Windows 10 or higher / Linux.

## Download

Latest source tarball can be downloaded from [GitHub releases page](https://github.com/gecko0307/dagon/releases).

You can also add Dagon as a dependency to your DUB project:

```bash
dub add dagon
```

## Getting Started

Assuming you have installed the D language toolchain, the recommended way to start using Dagon is to create a game template with `dub init`. Run the following in an empty directory:

```
dub init --type=dagon
dub build
```

By running a template application you should see a sample scene with a plane and a cube. You can then modify the generated dub.json file to suit your needs.

It is strongly recommended to use [LDC](https://github.com/ldc-developers/ldc) and compile in release mode to achieve maximum CPU performance:

```
dub build --compiler=ldc2 --build=release-nobounds
```

To use Dagon repository directly instead of a release (for example, to modify the engine), you can clone it with Git and specify the local path to the `dagon` dependency in your `dub.json` or `dub.selections.json`:

```
"dagon": { "path": "path/to/your/dagon/copy" }

## Runtime Dependencies

Dagon depends on the following shared libraries:

* [SDL](https://www.libsdl.org) 2.32.4.0
* [SDL_Image](https://github.com/libsdl-org/SDL_image) 2.8.8.0
* [Freetype](https://www.freetype.org) 2.8.1 for text rendering
* [libwebp](https://chromium.googlesource.com/webm/libwebp) for WebP support (optional)
* [libtiff](https://libtiff.gitlab.io/libtiff/) for TIFF support (optional)
* [libavif](https://github.com/AOMediaCodec/libavif) for AVIF support (optional)
* [Assimp](https://github.com/assimp/assimp) for additional 3D formats support (optional)
* [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) 3.14 for rigid body simulation (optional)
* [Jolt Physics](https://github.com/jrouwe/JoltPhysics) via [joltc](https://github.com/amerkoleci/joltc) wrapper (optional)
* [cimgui](https://github.com/cimgui/cimgui) (optional)
* [libktx](https://github.com/KhronosGroup/KTX-Software) (optional)
* [PhysFS](https://github.com/icculus/physfs) (optional)
* [SoLoud](https://github.com/jarikomppa/soloud) (optional)
* [libVLC](https://www.videolan.org/vlc/libvlc.html) (optional)
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) (optional, deprecated)

Runtime dependencies are automatically deployed on 64-bit Windows and Linux. On other platforms, you will have to install them manually. Read more [here](https://github.com/gecko0307/dagon/blob/master/doc/Runtime%20Dependencies.md).

Under Linux, if you want to use local libraries in Windows way (from application's working directory rather than from the system), add the following to your `dub.json`:

```
"lflags-linux": ["-rpath=$$ORIGIN"]
```

## Contributing

If you want to contribute code to Dagon, send pull requests to [the project repository](https://github.com/gecko0307/dagon). Please, read [Contributing Guidelines](?p=contributing_guidelines) first.

Found a bug? Please, create an issue [here](https://github.com/gecko0307/dagon/issues).

## Sponsorship

If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307) and get a reward depending on your donation amount. Supporters who donate $10 and more will be listed on this page as Sponsors. You can also make a donation via [NowPayments](https://nowpayments.io/donation?api_key=EAAJMMS-8Z643SJ-K5Z4V2Q-Z31626N).

Big thanks to these awesome people for supporting Dagon: **Daniel Laburthe**, **Rafał Ziemniewski**, **Kumar Sookram**, **Aleksandr Kovalev**, **Robert Georges**, **Jan Jurzitza (WebFreak)**, **Rais Safiullin (SARFEX)**, **Benas Cernevicius**, **Koichi Takio**, **Konstantin Menshikov**.

## License and Credits

Copyright (c) 2016-2026 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Denis Feklushkin, dayllenger, Konstantin Menshikov, Björn Roberg et al. Distributed under the [Boost Software License, Version 1.0](https://www.boost.org/LICENSE_1_0.txt).

### Authors and contributors:
* Core engine, Newton extension, Jolt extension, IQM extension, KTX extension, Assimp extension, PhysFS extension, audio extension, video extension - [Timur Gafarov aka gecko0307](https://github.com/gecko0307)
* Input manager, Nuklear extension - [Mateusz Muszyński aka Timu5](https://github.com/Timu5)
* Terrain rendering, OpenSimplex noise generator - Rafał Ziemniewski
* Shader loader - [Viktor M. aka dayllenger](https://github.com/dayllenger)
* glTF animation - [Denis Feklushkin aka denizzzka](https://github.com/denizzzka)
* Asset manager improvements - [Konstantin Menshikov aka MANKEYYENAME](https://github.com/MANKEYYENAME)
* OBJ group parser - [Vlad Davydov aka Tynuk](https://github.com/Tynukua)
* Bugfixes - [Björn Roberg aka roobie](https://github.com/roobie), [Isaac S.](https://github.com/isaacs-dev), [Adrien Allard aka Tichau](https://github.com/Tichau), [Ilya Lemeshko aka ijet](https://github.com/my-ijet), [Dennis Korpel aka dkorpel](https://github.com/dkorpel), [Robert Schadek aka burner](https://github.com/burner)

### Adapted third-party code:
* Wintab binding - [Vadim Lopatin aka buggins](https://github.com/buggins)
* DXT1/DXT5 compressor - [Fabian Giesen](https://github.com/rygorous), [Yann Collet](https://github.com/Cyan4973)
* ImGui extension (ImGuiOpenGLBackend) - [Joshua T. Fisher aka playmer](https://github.com/playmer), [LunaTheFoxgirl](https://github.com/LunaTheFoxgirl)
* SoLoud binding contains code by [Jari Komppa](https://github.com/jarikomppa)
* SSAO implementation is based on the code by [Reinder Nijhoff](https://www.shadertoy.com/view/Ms33WB)
* FXAA implementation is based on the code by [JeGX](http://www.geeks3d.com/20110405/fxaa-fast-approximate-anti-aliasing-demo-glsl-opengl-test-radeon-geforce)
* Optimized separable Gaussian blur - [Matt DesLauriers](https://github.com/Experience-Monks)
* Depth of field effect - [Martins Upitis](https://github.com/martinsh)
* Lens distortion effect - [Jaume Sanchez](https://github.com/spite)
* Sharpening shader is based on AMD's [FidelityFX™ CAS](https://gpuopen.com/fidelityfx-cas/)
* Cubemap prefiltering shader is based on the code by [Joey de Vries](https://learnopengl.com/)
* Hammersley point set calculation is based on the radical inverse function by [Holger Dammertz](http://holger.dammertz.org/stuff/notes_HammersleyOnHemisphere.html)
* Reinhard tonemapper is based on the function by Erik Reinhard et al, ["Photographic Tone Reproduction for Digital Images"](https://www-old.cs.utah.edu/docs/techreports/2002/pdf/UUCS-02-001.pdf)
* Unreal tonemapper is based on the function from Unreal 3
* Hable tonemapper is based on the function by [John Hable](http://filmicworlds.com/blog/filmic-tonemapping-operators)
* ACES tonemapper is based on the function by [Krzysztof Narkowicz](https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve)
* Filmic tonemapper is based on the function by [Jim Hejl and Richard Burgess-Dawson](http://filmicworlds.com/blog/filmic-tonemapping-operators)
* AgX tonemapper is based on the code by [Don McCurdy](https://github.com/mrdoob), which in turn is based on Blender and Filament implementations
* Khronos PBR Neutral tonemapper is based on the code by [Khronos Group](https://github.com/KhronosGroup/ToneMapping)
* Uchimura tonemapper is based on the function by [Hajime Uchimura](https://www.desmos.com/calculator/gslcdxvipg)
* Lottes tonemapper is based on the function by Timothy Lottes ("Advanced Techniques and Optimization of HDR Color Pipelines")
* Vignette shader by [Tyler Lindberg](https://github.com/TyLindberg)

## Made with Dagon

* [Sponza Demo](https://github.com/gecko0307/dagon-sponza) - Crytek Sponza Atrium scene implemented using Dagon
* [Electronvolt](https://github.com/gecko0307/electronvolt) - work-in-progress first person puzzle based on Dagon
* [Chillwave Drive](https://github.com/gecko0307/chillwavedrive) - vehicle physics demo written using Dagon, Newton Dynamics and SoLoud
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone
* [sacengine](https://github.com/tg-2/sacengine) - [Sacrifice](https://en.wikipedia.org/wiki/Sacrifice_(video_game)) engine reimplementation
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game
