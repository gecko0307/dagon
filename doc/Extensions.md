Dagon Extensions
================
Some functionality in Dagon is implemented via extension mechanism. Extensions are [DUB sub-packages](https://dub.pm/dub-reference/subpackages/) and should be explicitly added as dependencies to your project, for example:

`dub add dagon:newton` - adds Newton extension available as `dagon.newton` package import.

All extensions are experimental and not guaranteed to work on all platforms. Some of them require installing third-party libraries.

Available extensions:
* `dagon:newton` - rigid body physics simulation extension that uses [Newton Dynamics](https://newtondynamics.com/forum/newton.php) library via [bindbc-newton](https://github.com/gecko0307/bindbc-newton) dynamic binding
* `dagon:ftfont` - text rendering extension that uses [Freetype](https://freetype.org/) library via [bindbc-freetype](https://github.com/BindBC/bindbc-freetype) dynamic binding
* `dagon:imgui` - immediate mode GUI extension that uses [Dear ImGui](https://github.com/ocornut/imgui) via [i2d-imgui](https://github.com/Inochi2D/i2d-imgui) dynamic binding
* `dagon:nuklear` - immediate mode GUI extension that uses [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear) library via [bindbc-nuklear](https://github.com/Timu5/bindbc-nuklear) dynamic binding (deprecated, `dagon:imgui` recommended instead)
* `dagon:iqm` - [IQM](http://sauerbraten.org/iqm/) model format loader and renderer
