# Credits

## Authors and contributors
* Core engine, Newton extension, Jolt extension, IQM extension, KTX extension, Assimp extension, PhysFS extension, audio extension, video extension - [Timur Gafarov aka gecko0307](https://github.com/gecko0307)
* Input manager, Nuklear extension - [Mateusz Muszyński aka Timu5](https://github.com/Timu5)
* Terrain rendering, OpenSimplex noise generator - Rafał Ziemniewski
* Shader loader - [Viktor M. aka dayllenger](https://github.com/dayllenger)
* glTF animation - [Denis Feklushkin aka denizzzka](https://github.com/denizzzka)
* Asset manager improvements - [Konstantin Menshikov aka MANKEYYENAME](https://github.com/MANKEYYENAME)
* OBJ group parser - [Vlad Davydov aka Tynuk](https://github.com/Tynukua)
* Bugfixes - [Björn Roberg aka roobie](https://github.com/roobie), [Isaac S.](https://github.com/isaacs-dev), [Adrien Allard aka Tichau](https://github.com/Tichau), [Ilya Lemeshko aka ijet](https://github.com/my-ijet), [Dennis Korpel aka dkorpel](https://github.com/dkorpel), [Robert Schadek aka burner](https://github.com/burner)

## Adapted third-party code
* Wintab binding - [Vadim Lopatin aka buggins](https://github.com/buggins)
* DXT1/DXT5 compressor - [Fabian Giesen](https://github.com/rygorous), [Yann Collet](https://github.com/Cyan4973)
* ImGui extension (ImGuiOpenGLBackend) - [Joshua T. Fisher aka playmer](https://github.com/playmer), [LunaTheFoxgirl](https://github.com/LunaTheFoxgirl)
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

## Third-party libraries
Dagon and its extensions depend on the following libraries:
* [Simple DirectMedia Layer (SDL)](https://www.libsdl.org/)
* [SDL_Image](https://github.com/libsdl-org/SDL_image)
* [FreeType](https://freetype.org/)
* [libavif](https://github.com/AOMediaCodec/libavif)
* [libtiff](https://gitlab.com/libtiff/libtiff)
* [libwebp](https://chromium.googlesource.com/webm/libwebp)
* [libktx](https://github.com/KhronosGroup/KTX-Software)
* [Newton Game Dynamics](https://github.com/MADEAPPS/newton-dynamics)
* [Jolt Physics](https://github.com/jrouwe/JoltPhysics) via [joltc](https://github.com/amerkoleci/joltc) wrapper
* [Open Asset Import Library (Assimp)](https://github.com/assimp/assimp)
* [OpenVR](https://github.com/ValveSoftware/openvr)
* [PhysFS](https://github.com/icculus/physfs)
* [SoLoud](https://github.com/jarikomppa/soloud)
* [libVLC](https://images.videolan.org/vlc/libvlc.html)
* [cimgui](https://github.com/cimgui/cimgui)
* [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear)
