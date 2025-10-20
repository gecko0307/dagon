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

## settings.conf
`settings.conf` contains engine settings. It is fully preserved for Dagon's internal mechanisms, and you are not recommended to use it for storing game-specific settings.

The engine doesn't modify `settings.conf`, and you can implement a visual configurator in your game that modifies this file. If the file doesn't exist, the engine will print a warning and run with default settings.

### Application settings

Recognozed by the `Application` class.

* `logLevel` - minimum verbosity level of the logger. Default is `"debug"` in debug builds and `"info"` in release builds. Note that some early log output ignore this setting, because the config file is loaded after the VFS and locale system initialization. Supported options are:
  * `"debug"` - debug mode, prints all messages
  * `"info"` - prints informational messages, warnings and errors
  * `"warning"` - prints warnings and errors
  * `"error"` - prints only errors
* `logToStdout` - `0` or `1`, disables or enables printing log messages to the standard output. Default is `1`. Note that some early log output ignore this setting, because the config file is loaded after the VFS and locale system initialization
* `logTimestampTags` - `0` or `1`, disables or enables timestamps in log messages. Default is `0`. Note that some early log output ignore this setting, because the config file is loaded after the VFS and locale system initialization
* `logLevelTags` - `0` or `1`, disables or enables level tags in log messages. Default is `1`. Note that some early log output ignore this setting, because the config file is loaded after the VFS and locale system initialization
* `logFile` - enables logging to file, specifying the filename. File output for the logger is disabled by default. Note that some early log output ignore this setting, because the config file is loaded after the VFS and locale system initialization
* `windowWidth`, `windowHeight` - size of the game window. These values override default ones hardcoded in the application
* `windowResizable` - `0` or `1`, allow the user to resize the window or not. Default is `1`
* `windowX`, `windowY` - window position (in windowed mode). If not specified, the window is centered on the screen
* `fullscreen` - `0` or `1`, run in windowed or fullscreen mode. This value overrides default one hardcoded in the application
* `vsync` - `0` for immediate buffer swap; `1` for synchronization with the vertical retrace; `-1` for adaptive vsync. Default is `1`
* `windowTitle` - window title text. This value overrides default one hardcoded in the application
* `hideConsole` - `0` or `1`, show or hide the console window. It is convenient to leave it when debugging the game and hide it for end users. Default is `0`
* `locale` - locale that should be loaded. This option overrides automatically selected locale based on system language and region. For example, `locale: "en_US";` means that application will try load `locales/en_US.lang` file and will ignore system language
* `glDebugOutput` - `0` or `1`, force disable or enable OpenGL debug output. Default is `1` in debug builds, `0` in release builds. This option is ignored if `logLevel` is higher than `"debug"`
* `enableShaderCache` - `0` or `1`, cache compiled shader binaries to files for reuse instead of compiling shaders on each run. Disabled by default. This is an experimental feature, use with care
* `sdlPath` - path to SDL2 shared library. If empty string specified, default path is used
* `sdlPath.windows` - path to SDL2 shared library under Windows, overrides `sdlPath`. If empty string specified, default path is used
* `sdlPath.linux` - path to SDL2 shared library under Linux, overrides `sdlPath`. If empty string specified, default path is used
* `sdlImagePath` - path to SDL2_Image shared library. If empty string specified, default path is used
* `sdlImagePath.windows` - path to SDL2_Image shared library under Windows, overrides `sdlImagePath`. If empty string specified, default path is used
* `sdlImagePath.linux` - path to SDL2_Image shared library under Linux, overrides `sdlImagePath`. If empty string specified, default path is used

### Renderer settings

Recognozed by the `Game` class, applied to the `Game.deferredRenderer`.

* `renderer.fxaaEnabled` - `0` or `1`
* `renderer.ssaoEnabled` - `0` or `1`
* `renderer.ssaoSamples` - 
* `renderer.ssaoRadius` - 
* `renderer.ssaoPower` - 
* `renderer.ssaoDenoise` - 
* `renderer.occlusionBufferDetail` - 
* `renderer.glowEnabled` - `0` or `1`
* `renderer.glowViewScale` - 
* `renderer.glowThreshold` - 
* `renderer.glowIntensity` - 
* `renderer.glowRadius` - 
* `renderer.tonemapper` - 
* `renderer.exposure` - 
* `renderer.motionBlurEnabled` - `0` or `1`
* `renderer.motionBlurSamples` - 
* `renderer.motionBlurFramerate` - 
* `renderer.motionBlurRandomness` - 
* `renderer.motionBlurMinDistance` - 
* `renderer.motionBlurMaxDistance` - 
* `renderer.radialBlurAmount` - 
* `renderer.lensDistortionEnabled` - `0` or `1`
* `renderer.lensDistortionScale` - 
* `renderer.lensDistortionDispersion` - 
* `renderer.dofEnabled` - `0` or `1`
* `renderer.autofocus` - 
* `renderer.focalDepth` - 
* `renderer.focalLength` - 
* `renderer.fStop` - 
* `renderer.dofManual` - 
* `renderer.dofNearStart` - 
* `renderer.dofNearDistance` - 
* `renderer.dofFarStart` - 
* `renderer.dofFarDistance` - 
* `renderer.lutEnabled` - `0` or `1`
* `renderer.lut` - 
* `renderer.pixelizationEnabled` - `0` or `1`
* `renderer.pixelSize` -

### Audio settings

Recognized by the `AudioManager` class of the dagon:audio extension.

* `audio.enabled` - `0` or `1`
* `audio.backend` - backend API for audio output. This option is platform-specific: not all backends work on all platforms. It is recommended to change backend only if automatically selected one is not working. Supported options are:
  * `"auto"` - default value, backend is automatically selected
  * `"SDL1"` - cross-platform
  * `"SDL2"` - cross-platform (dagon:audio normally selects under Windows it because SDL2 is Dagon's core dependency)
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
* `audio.channels` - number of audio output channels. To use 5.1, specify `6`. To use 7.1, specify `8`. When using multichannel output, dagon:audio will map 3D sound to specified number of channels for surround effect. Default is `2` (stereo)
* `audio.sampleRate` - sample rate in Hz. Automatically chosen by default
* `audio.bufferSize` - buffer size in bytes. Automatically chosen by default
* `audio.masterVolume` - a number in 0.0..1.0 range. Global audio output volume. Default is `1.0`
* `audio.musicEnabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.Music`. Default is `1`
* `audio.musicVolume` - a number in 0.0..1.0 range. Background music volume (for sounds created as `SoundClass.Music`). Default is `0.5`
* `audio.sfxEnabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.SFX`. Default is `1`
* `audio.sfxVolume` - a number in 0.0..1.0 range. Sound effects volume (for sounds created as `SoundClass.SFX`). Default is `0.5`
* `audio.multimediaKeysEnabled` - `0` or `1`. Use multimedia keys found on some keyboards to control the active playlist. Note that audio players often hijack multimedia keypresses, in which cases they are not detected by Dagon. Default is `1`

## input.conf
`input.conf` contains input bindings. See Input Manager tutorial for details.
