# Conf Files

Conf is a configuration file format in Dagon. Any application using Dagon tries to read two configuration files from the VFS: `settings.conf` and `input.conf`.

## Syntax

Conf file consists of key-value pairs separated by semicolon:

```
optionName: optionValue;
```

optionValue can be a number, a vector (an array), or a double-quoted string:

```
numberOption: 10;
vectorOption: [0.5, 1.0, 1.0];
stringOption: "Some text";
```

Dagon has a number of built-in *.conf files (`settings.conf`, `render.conf`, `input.conf`, `audio.conf`) that are loaded from each VFS-mounted path. User-defined *.conf files (in APPDATA and custom paths) override root ones (in executable directory).

Built in *.conf files are fully reserved for Dagon's internal mechanisms, and it is not recommended to use them for storing game-specific settings. The engine doesn't modify them, so you can implement a visual configurator in your game that modifies these files.

## settings.conf

`settings.conf` contains engine settings recognozed by the `Application` class. If the file doesn't exist, the engine will print a warning and run with default settings.

* `log.enabled` - `0` or `1`, disables or enables the logger. Default is `1`
* `log.level` - minimum verbosity level of the logger. Default is `"debug"` in debug builds and `"info"` in release builds. Supported options are:
  * `"debug"` - debug mode, prints all messages
  * `"info"` - prints informational messages, warnings and errors
  * `"warning"` - prints warnings and errors
  * `"error"` - prints only errors
* `log.toStdout` - `0` or `1`, disables or enables printing log messages to the standard output. Default is `1`
* `log.timestampTags` - `0` or `1`, disables or enables timestamps in log messages. Default is `0`
* `log.levelTags` - `0` or `1`, disables or enables level tags in log messages. Default is `1`
* `log.file` - enables logging to file, specifying the filename. File output for the logger is disabled by default
* `vfs.appDataFolder` - game data folder name in `APPDATA` directory (`HOME` under Linux). These value override default one hardcoded in the application
* `vfs.appDataFolder.windows` - overrides `vfs.appDataFolder` under Windows
* `vfs.appDataFolder.linux` - overrides `vfs.appDataFolder` under Linux
* `vfs.mount` - additional paths to mount in the VFS, separated by semicolon (`"my/path;my/another/path"`)
* `vfs.mount.windows` - overrides `vfs.mount` under Windows
* `vfs.mount.linux` - overrides `vfs.mount` under Linux
* `window.width`, `window.height` - size of the game window. These values override default ones hardcoded in the application
* `window.x`, `window.y` - window position (in non-maximized windowed mode). If not specified, the window is centered on the screen
* `window.resizable` - `0` or `1`, allow the user to resize the window or not (in windowed mode). Default is `1`
* `window.maximized` - `0` or `1`, maximize the window initially. If enabled, `window.width` and `window.height` are ignored and determined automatically. Default is `0`
* `window.minimized` - `0` or `1`, minimize the window initially. Default is `0`
* `window.borderless` - `0` or `1`, enables or disables window decoration. Default is `0`
* `window.hiDPI` - `0` or `1`, hints that the application is hiDPI-aware. If enabled, the actual drawable area of the window will be larger than the window itself (by multiplier available as `Application.pixelRatio`) on appropriate displays. Default is `0`
* `window.title` - window title text. This value overrides default one hardcoded in the application
* `fullscreen` - `0` or `1`, run in windowed or fullscreen mode. This value overrides default one hardcoded in the application
* `fullscreenWindowed` - `0` or `1`, enables "windowed fullscreen" mode. The application runs in a borderless screen-sized window, which allows for easy switching to other applications. Default is `0`
* `vsync` - `0` for immediate buffer swap; `1` for synchronization with the vertical retrace; `-1` for adaptive vsync. Default is `1`
* `stepFrequency` - number of logic update cycles per second. This can be set to `auto` to synchronize updates with the display refresh rate. Default is `60`
* `hideConsole` - `0` or `1`, show or hide the console window. It is convenient to leave it when debugging the game and hide it for end users. Default is `0`
* `localesPath` - path to the folder containing translation files. Default is `"locale"`
* `locale` - locale that should be loaded. This option overrides automatically selected locale based on system language and region. For example, `locale: "en_US";` means that application will try load `locale/en_US.lang` file and will ignore system language
* `gl.debugOutput` - `0` or `1`, force disable or enable OpenGL debug output. Default is `1` in debug builds, `0` in release builds. This option is ignored if `logLevel` is higher than `"debug"`
* `gl.shaderCache.enabled` - `0` or `1`, cache compiled shader binaries to files for reuse instead of compiling shaders on each run. Disabled by default. This is an experimental feature, use with care
* `gl.shaderCache.path` - path to a folder for storing cached shader binaries. Default is `"data/__internal/shader_cache"`
* `gl.shaderCache.path.windows` - overrides `gl.shaderCache.path` under Windows
* `gl.shaderCache.path.linux` - overrides `gl.shaderCache.linux` under Windows
* `font.sans` - path to the default sans font. Default is `"data/__internal/fonts/LiberationSans-Regular.ttf"`
* `font.sans.windows` - overrides `vfs.sans` under Windows
* `font.sans.linux` - overrides `vfs.sans` under Linux
* `font.monospace` - path to the default monospace font. Default is `"data/__internal/fonts/LiberationMono-Regular.ttf"`
* `font.monospace.windows` - overrides `vfs.sans` under Windows
* `font.monospace.linux` - overrides `vfs.sans` under Linux
* `font.size` - default sans/monospace font size. Default is `10`
* `SDL2.path` - path to SDL2 shared library. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified (default case), `"SDL2.dll"` is used under Windows, and `"libSDL2-2.0.so.0"` is used under Linux
* `SDL2.path.windows` - path to SDL2 shared library under Windows, overrides `SDL2.path`. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified, `"SDL2.dll"` is used
* `SDL2.path.linux` - path to SDL2 shared library under Linux, overrides `SDL2.path`. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified, `"libSDL2-2.0.so.0"` is used
* `SDL2Image.path` - path to SDL2_Image shared library. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified (default case), `"SDL2_Image.dll"` is used under Windows, and `"libSDL2_image-2.0.so"` is used under Linux
* `SDL2Image.path.windows` - path to SDL2_Image shared library under Windows, overrides `SDL2Image.path`. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified, `"SDL2_Image.dll"` is used
* `SDL2Image.path.linux` - path to SDL2_Image shared library under Linux, overrides `SDL2Image.path`. If empty string specified, the path is automatically determined by the library loader. If `"auto"` specified, `"libSDL2_image-2.0.so"` is used
* `events.keyRepeat` - enable repeated triggering of "key down" events when user presses and holds a key. This is generally only useful for text input in GUI applications. Default is `0`
* `events.controllerAxisThreshold` - defines maximum value of controller axis for normalization. Default is `32639`
* `events.graphicsTablet.enabled` - `0` or `1`, disable or enable graphics tablet events (if device is available). Default is `1`.

## render.conf

Recognozed by the `Game` class, applied to the `Game.deferredRenderer` and `Game.postProcessingRenderer`.

* `brdf.file` - 
* `fxaa.enabled` - `0` or `1`
* `ssao.enabled` - `0` or `1`
* `ssao.samples` - 
* `ssao.radius` - 
* `ssao.power` - 
* `ssao.denoise` - 
* `ssao.occlusionBufferDetail` - 
* `glow.enabled` - `0` or `1`
* `glow.viewScale` - 
* `glow.threshold` - 
* `glow.intensity` - 
* `glow.radius` - 
* `hdr.tonemapper` - tonemapping operator used to compress HDR to LDR. Default is `"ACES"`. Supported options are:
  * `"None"`
  * `"Reinhard"`
  * `"Reinhard2"`
  * `"Hable"`
  * `"Uncharted"`
  * `"ACES"`
  * `"Filmic"`
  * `"Unreal"`
  * `"AgX_Base"`
  * `"AgX_Punchy"`
  * `"KhronosPBRNeutral"`
* `hdr.exposure` - exposure value to adjust brightness
* `motionBlur.enabled` - `0` or `1`
* `motionBlur.samples` - 
* `motionBlur.framerate` - 
* `motionBlur.randomness` - 
* `motionBlur.minDistance` - 
* `motionBlur.maxDistance` - 
* `motionBlur.radialBlurAmount` - 
* `lensDistortion.enabled` - `0` or `1`
* `lensDistortion.scale` - 
* `lensDistortion.dispersion` - 
* `dof.enabled` - `0` or `1`
* `dof.autofocus` - 
* `dof.focalDepth` - 
* `dof.focalLength` - 
* `dof.fStop` - 
* `dof.manual` - 
* `dof.nearStart` - 
* `dof.nearDistance` - 
* `dof.farStart` - 
* `dof.farDistance` - 
* `lut.enabled` - `0` or `1`
* `lut.file` - 
* `pixelization.enabled` - `0` or `1`, disable or enable pixelization filter
* `pixelization.pixelSize` - screen-space pixel size for pixelization filter.

### audio.conf

Recognized by the `AudioManager` class of the dagon:audio extension.

* `enabled` - `0` or `1`
* `backend` - backend API for audio output. This option is platform-specific: not all backends work on all platforms. It is recommended to change backend only if automatically selected one is not working. Supported options are:
  * `"auto"` - default value, backend is automatically selected
  * `"SDL1"` - cross-platform
  * `"SDL2"` - cross-platform (autumatically selected option under Windows because SDL2 is Dagon's core dependency)
  * `"PortAudio"` - cross-platform
  * `"WinMM"` - Windows-only
  * `"XAudio2"` - Windows-only
  * `"WASAPI"` - Windows-only
  * `"ALSA"` - Linux-only
  * `"JACK"` - Linux-only
  * `"OSS"` - Linux-only
  * `"OpenAL"` - cross-platform
  * `"CoreAudio"` - Mac-only (Dagon itself doesn't support macOS, but the sound library does)
  * `"OpenSLES"` - cross-platform
  * `"VitaHomebrew"` - PlayStation Vita-only (Dagon itself doesn't support PS Vita, but the sound library does)
  * `"MiniAudio"` - cross-platform
  * `"NoSound"` - disables sound output
* `channels` - number of audio output channels. To use 5.1, specify `6`. To use 7.1, specify `8`. When using multichannel output, dagon:audio will map 3D sound to specified number of channels for surround effect. Default is `2` (stereo)
* `sampleRate` - sample rate in Hz. Automatically chosen by default (`"auto"`)
* `bufferSize` - buffer size in bytes. Automatically chosen by default (`"auto"`)
* `master.volume` - a number in 0.0..1.0 range. Global audio output volume. Default is `1.0`
* `master.fadeInDuration` - master volume fade-in in seconds. This is used to smoothly increase volume after the initialization, so that there will be no unpleasant "click" noise. Default is `0.25`
* `music.enabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.Music`. Default is `1`
* `music.volume` - a number in 0.0..1.0 range. Background music volume (for sounds created as `SoundClass.Music`). Default is `0.5`
* `sfx.enabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.SFX`. Default is `1`
* `sfx.volume` - a number in 0.0..1.0 range. Sound effects volume (for sounds created as `SoundClass.SFX`). Default is `0.5`
* `multimediaKeysEnabled` - `0` or `1`. Use multimedia keys found on some keyboards to control the active playlist. Note that audio players often hijack multimedia keypresses, in which cases they are not detected by Dagon. Default is `1`

## input.conf

`input.conf` contains input bindings recognozed by the `InputManager` class. See Input Manager tutorial for details.
