# Dagon Engine

[Dagon](https://github.com/gecko0307/dagon) is an Open Source 3D game development framework based on OpenGL 4.0 core profile and SDL2. The goal of this project is to create a modern, easy to use, extensible 3D game engine for [D language](https://dlang.org/).

Dagon uses modern graphics techniques and so requires a fairly powerful graphics card to run (at least Turing-based NVIDIA cards are recommended). The engine works on Windows and Linux, support for mobile and web platforms is not planned.

The engine is still under development and lacks some of the planned features. Follow the development on [Trello](https://trello.com/b/4sDgRjZI/dagon-development-board) to see the priority tasks.

[![Screenshot1](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/05/sponza10.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2021/05/sponza10.jpg?)

[![Screenshot2](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg?)](https://gamedev.timurgafarov.ru/wp-content/uploads/2020/10/eevee_vs_dagon.jpg?)

<div class="video-container">
    <iframe src="https://www.youtube.com/embed/iDF4shPofgU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

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

## Runtime Dependencies

Dagon depends on the following shared libraries:

* [SDL](https://www.libsdl.org) 2.32.4.0
* [SDL_Image](https://github.com/libsdl-org/SDL_image) 2.8.8.0
* [libwebp](https://chromium.googlesource.com/webm/libwebp) for WebP support (optional)
* [libtiff](https://libtiff.gitlab.io/libtiff/) for TIFF support (optional)
* [libavif](https://github.com/AOMediaCodec/libavif) for AVIF support (optional)
* [Freetype](https://www.freetype.org) 2.8.1 for text rendering (optional)
* [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) 3.14 for rigid body simulation (optional)
* [cimgui](https://github.com/cimgui/cimgui) (optional)
* [libktx](https://github.com/KhronosGroup/KTX-Software) (optional)
* [PhysFS](https://github.com/icculus/physfs) (optional)
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) (optional, deprecated)

Mandatory dependencies are SDL and SDL_image, the others belong to the corresponding extensions.

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

Copyright (c) 2016-2025 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Denis Feklushkin, dayllenger, Konstantin Menshikov, Björn Roberg et al. Distributed under the [Boost Software License, Version 1.0](https://www.boost.org/LICENSE_1_0.txt).

* Core engine, Newton extension, Freetype extension, STBI extension, IQM extension, KTX extension - [Timur Gafarov aka gecko0307](https://github.com/gecko0307)
* ImGui extension (ImGuiOpenGLBackend) - [Joshua T. Fisher aka playmer](https://github.com/playmer), [LunaTheFoxgirl](https://github.com/LunaTheFoxgirl)
* Input manager, Nuklear extension - [Mateusz Muszyński aka Timu5](https://github.com/Timu5)
* Terrain rendering, OpenSimplex noise generator - Rafał Ziemniewski
* Shader loader - [Viktor M. aka dayllenger](https://github.com/dayllenger)
* glTF animation - [Denis Feklushkin aka denizzzka](https://github.com/denizzzka)
* Asset manager improvements - [Konstantin Menshikov aka MANKEYYENAME](https://github.com/MANKEYYENAME)
* OBJ group parser - [Vlad Davydov aka Tynuk](https://github.com/Tynukua)
* Bugfixes - [Björn Roberg aka roobie](https://github.com/roobie), [Isaac S.](https://github.com/isaacs-dev), [Adrien Allard aka Tichau](https://github.com/Tichau), [Ilya Lemeshko aka ijet](https://github.com/my-ijet), [Dennis Korpel aka dkorpel](https://github.com/dkorpel), [Robert Schadek aka burner](https://github.com/burner)

## Made with Dagon

* [Electronvolt](https://github.com/gecko0307/electronvolt) - work-in-progress first person puzzle based on Dagon
* [Chillwave Drive](https://github.com/gecko0307/chillwavedrive) - vehicle physics demo written using Dagon, Newton Dynamics and SoLoud
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone
* [sacengine](https://github.com/tg-2/sacengine) - [Sacrifice](https://en.wikipedia.org/wiki/Sacrifice_(video_game)) engine reimplementation
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game
