# Conf Files

Conf is a configuration file format in Dagon.

## Syntax

Conf file consists of key-value pairs separated by semicolon:

```
optionName: optionValue;
```

optionValue can be a number, a boolean value, a vector (an array), or a double-quoted string:

```
numberOption: 10;
boolOption: true;
vectorOption: [0.5, 1.0, 1.0];
stringOption: "Some text";
```

Lines beginning with double slash (`//`) are treated as comments and ignored:

```
// Some comment
```

## Built-in Conf Files

Dagon recognizes a number of built-in *.conf files (`settings.conf`, `render.conf`, `input.conf`, `audio.conf`) that are loaded from each VFS-mounted path. User-defined *.conf files (in APPDATA and custom paths) override root ones (in executable directory).

Built-in *.conf files are fully reserved for Dagon's internal mechanisms, and it is not recommended to use them for storing game-specific settings. The engine doesn't modify them, so you can implement a visual configurator in your game that modifies these files.

### settings.conf

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
* `window.maximized` - `0` or `1`, maximize the window initially. If enabled, `window.width` and `window.height` are ignored. Default is `0`
* `window.minimized` - `0` or `1`, minimize the window initially. Default is `0`
* `window.borderless` - `0` or `1`, enables or disables window decoration. Default is `0`
* `window.hiDPI` - `0` or `1`, hints that the application is hiDPI-aware. If enabled, the actual drawable area of the window will be larger than the window itself (by multiplier available as `Application.pixelRatio`) on appropriate displays. Default is `0`
* `window.title` - window title text. This value overrides default one hardcoded in the application
* `fullscreen` - `0` or `1`, run in windowed or fullscreen mode. This value overrides default one hardcoded in the application
* `fullscreenWindowed` - `0` or `1`, enables "windowed fullscreen" mode. The application runs in a borderless screen-sized window, which allows for easy switching to other applications. Default is `0`
* `vsync` - `0` for immediate buffer swap; `1` for synchronization with the vertical retrace; `-1` for adaptive vsync. Default is `1`
* `stepFrequency` - number of logic update cycles per second. This can be set to `auto` to synchronize updates with the display refresh rate. Default is `60`
* `maxTimersCount` - maximum number of simultaneous timers. Default is `1024`. `0` is treated as a default number
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

### render.conf

Recognozed by the `Game` class, applied to the `Game.deferredRenderer` and `Game.postProcessingRenderer`.

* `brdf.file` - path to the default BRDF lookup texture. Default is `"data/__internal/textures/brdf.dds"`
* `fxaa.enabled` - `0` or `1`, disable or enable FXAA anti-aliasing filter. Default is `0`
* `ssao.enabled` - `0` or `1`, disable or enable screen-space ambient occlusion (in deferred renderer). Default is `0`
* `ssao.samples` - number of SSAO integration samples per pixel. Default is `16`
* `ssao.radius` - maximum radius of occlusion detection for SSAO. Default is `0.2`
* `ssao.power` - SSAO power. The greater is power, the more pronounced is the occlusion effect. Default is `4.0`
* `ssao.denoise` - a number between `0.0` and `1.0` that interpolates between unfiltered (noisy) and denoised occlusion data. A simple bilateral filter is used to denoise. Default is `1.0`
* `ssao.occlusionBufferDetail` - a number between `0.0` and `1.0` that indicates a uniform scale of the occlusion buffer resolution. For example, `0.5` will give 1/4 of the main framebuffer. This is useful as a quality/performance tradeoff on low-end machines. Default is `1.0`
* `glow.enabled` - `0` or `1`, disable or enable glow filter. Default is `0`
* `glow.viewScale` - a number between `0.0` and `1.0` that indicates a uniform scale of the glow buffer resolution. For example, `0.5` will give 1/4 of the main framebuffer. This is useful as a quality/performance tradeoff on low-end machines. Default is `1.0`
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
* `motionBlur.enabled` - `0` or `1`, disable or enable motion blur filter. Default is `0`
* `motionBlur.samples` - 
* `motionBlur.framerate` - 
* `motionBlur.randomness` - 
* `motionBlur.minDistance` - 
* `motionBlur.maxDistance` - 
* `motionBlur.radialBlurAmount` - 
* `lensDistortion.enabled` - `0` or `1`, disable or enable lens distortion filter. Default is `0`
* `lensDistortion.scale` - 
* `lensDistortion.dispersion` - 
* `dof.enabled` - `0` or `1`, disable or enable depth of field filter. Default is `0`
* `dof.autofocus` - 
* `dof.focalDepth` - 
* `dof.focalLength` - 
* `dof.fStop` - 
* `dof.manual` - 
* `dof.nearStart` - 
* `dof.nearDistance` - 
* `dof.farStart` - 
* `dof.farDistance` - 
* `lut.enabled` - `0` or `1`, disable or enable color LUT filter. Default is `0`
* `lut.file` - 
* `pixelization.enabled` - `0` or `1`, disable or enable pixelization filter. Default is `0`
* `pixelization.pixelSize` - screen-space pixel size for pixelization filter. Default is `1`.

### audio.conf

Recognized by the `AudioManager` class of the dagon:audio extension.

* `enabled` - `0` or `1`
* `backend` - backend API for audio output. This option is platform-specific: not all backends work on all platforms. It is recommended to change backend only if automatically selected one is not working. Supported options are:
  * `"auto"` - default value, backend is automatically selected
  * `"SDL1"` - cross-platform
  * `"SDL2"` - cross-platform (automatically selected option under Windows because SDL2 is Dagon's core dependency)
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
* `channels` - number of audio output channels. To use 5.1, specify `6`. To use 7.1, specify `8`. When using multichannel output, dagon:audio will map 3D sound to the specified number of channels for surround effect. Default is `2` (stereo)
* `sampleRate` - output sample rate in Hz. Automatically chosen by default (`"auto"`)
* `bufferSize` - output buffer size in bytes. Automatically chosen by default (`"auto"`)
* `master.volume` - a number in 0.0..1.0 range. Global audio output volume. Default is `1.0`
* `master.fadeInDuration` - master volume fade-in in seconds. This is used to smoothly increase volume after the initialization, so that there will be no unpleasant "click" noise. Default is `0.25`
* `music.enabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.Music`. Default is `1`
* `music.volume` - a number in 0.0..1.0 range. Background music volume (for sounds created as `SoundClass.Music`). Default is `0.5`
* `sfx.enabled` - `0` or `1`. Disables or enables playing of sounds created as `SoundClass.SFX`. Default is `1`
* `sfx.volume` - a number in 0.0..1.0 range. Sound effects volume (for sounds created as `SoundClass.SFX`). Default is `0.5`
* `multimediaKeysEnabled` - `0` or `1`. Use multimedia keys found on some keyboards to control the active playlist. Note that audio players often hijack multimedia keypresses, in which cases they are not detected by Dagon. Default is `1`

### input.conf

`input.conf` contains input bindings recognozed by the `InputManager` class.

Binding definition format consists of device type and name (or number) coresponding to button or axis of this device.

- `kb` - keyboard (`kb_up`, `kb_w`, etc.)
- `ma` - mouse axis (`ma_x`, `ma_y`)
- `mb` - mouse button (`mb_left`, `mb_right`, etc.)
- `ga` - gamepad axis (`ga_leftx`, `ga_lefttrigger`, etc.)
- `gb` - gamepad button (`gb_a`, `gb_x`, etc.)
- `va` - virtual axis, has special syntax, for example: `va(kb_up, kb_down)`

`ga` and `gb` bindings accept optional gamepad index, for example: `gb[0]_x` or `ga[1]_lefty`. Up to 4 gamepads are supported. Default gamepad index is 0.

Example:

```
forward: "kb_w, kb_up, gb[0]_b";
back: "kb_s, kb_down, gb[0]_a";
left: "kb_a, kb_left";
right: "kb_d, kb_right";
jump: "kb_space";
interact: "kb_e";
```

Supported key names:
- `kb_a` .. `kb_z`, `kb_0` .. `kb_9`
- `kb_-`, `kb_=`, `kb_[`, `kb_]`, `kb_\`, `kb_#`, `kb_;`, `kb_'`, `` kb_` ``, `kb_,`, `kb_.`, `kb_/`
- `kb_return`, `kb_escape`, `kb_backspace`, `kb_delete`, `kb_tab`, `kb_space`, `kb_capsLock`
- `kb_f1` .. `kb_f24`
- `kb_printscreen`, `kb_scrolllock`, `kb_numlock`, `kb_pause`, `kb_insert`, `kb_home`, `kb_pageup`, `kb_pagedown`, `kb_end`
- `kb_left`, `kb_right`, `kb_up`, `kb_down`
- `kb_left_ctrl`, `kb_left_shift`, `kb_left_alt`, `kb_left_gui`
- `kb_right_ctrl`, `kb_right_shift`, `kb_right_alt`, `kb_right_gui`
- `kb_keypad_0` .. `kb_keypad_9`
- `kb_keypad_/`, `kb_keypad_*`, `kb_keypad_-`, `kb_keypad_+`, `kb_keypad_=`, `kb_keypad_enter`, `kb_keypad_.`, `kb_keypad_,`, `kb_keypad_00`, `kb_keypad_000`
- `kb_keypad_(`, `kb_keypad_)`, `kb_keypad_{`, `kb_keypad_}`, `kb_keypad_tab`, `kb_keypad_backspace`
- `kb_keypad_a`, `kb_keypad_b`, `kb_keypad_c`, `kb_keypad_d`, `kb_keypad_e`, `kb_keypad_f`
- `kb_keypad_xor`, `kb_keypad_^`, `kb_keypad_%`, `kb_keypad_<`, `kb_keypad_>`, `kb_keypad_&`, `kb_keypad_&&`, `kb_keypad_|`, `kb_keypad_||`, `kb_keypad_:`, `kb_keypad_#`, `kb_keypad_space`, `kb_keypad_@`, `kb_keypad_!`
- `kb_keypad_memstore`, `kb_keypad_memrecall`, `kb_keypad_memclear`, `kb_keypad_memadd`, `kb_keypad_memsubtract`, `kb_keypad_memmultiply`, `kb_keypad_memdivide`
- `kb_keypad_+/-`, `kb_keypad_clear`, `kb_keypad_clearentry`, `kb_keypad_binary`, `kb_keypad_octal`, `kb_keypad_decimal`, `kb_keypad_hexadecimal`
- `kb_mediaplay`, `kb_mediapause`, `kb_mediarecord`, `kb_mediafastforward`, `kb_mediarewind`, `kb_mediatracknext`, `kb_mediatrackprevious`, `kb_mediastop`, `kb_mediaplaypause`, `kb_mediaselect`
- `kb_nonusbackslash`, `kb_application`, `kb_power`
- `kb_execute`, `kb_help`, `kb_menu`, `kb_select`, `kb_stop`, `kb_again`, `kb_undo`, `kb_cut`, `kb_copy`, `kb_paste`, `kb_find`, `kb_mute`, `kb_volumeup`, `kb_volumedown`
- `kb_international_1` .. `kb_international_9`
- `kb_language_1` ..`kb_language_9`
- `kb_alterase`, `kb_sysreq`, `kb_cancel`, `kb_clear`, `kb_prior`, `kb_separator`, `kb_out`, `kb_oper`, `kb_clear_/_again`, `kb_crsel`, `kb_exsel`
- `kb_thousandsseparator`, `kb_decimalseparator`, `kb_currencyunit`, `kb_currencysubunit`
- `kb_modeswitch`, `kb_sleep`, `kb_wake`, `kb_channelup`, `kb_channeldown`
- `kb_eject`, 
- `kb_ac_new`, `kb_ac_open`, `kb_ac_close`, `kb_ac_exit`, `kb_ac_save`, `kb_ac_print`, `kb_ac_properties`, `kb_ac_search`, `kb_ac_home`, `kb_ac_back`, `kb_ac_forward`, `kb_ac_stop`, `kb_ac_refresh`, `kb_ac_bookmarks`
- `kb_softleft`, `kb_softright`
- `kb_call`, `kb_endcall`

Supported mouse button and axis names:
- `mb_left`, `mb_middle`, `mb_right`, `mb_x1`, `mb_x2`
- `ma_x`, `ma_y`

Supported gamepad button and axis names:
- `gb_dpup`, `gb_dpdown`, `gb_dpleft`, `gb_dpright`
- `gb_a`, `gb_b`, `gb_x`, `gb_y`
- `gb_back`, `gb_guide`, `gb_start`
- `gb_leftstick`, `gb_rightstick`
- `gb_leftshoulder`, `gb_rightshoulder`
- `gb_misc` (Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button)
- `gb_paddle1`, `gb_paddle2`, `gb_paddle3`, `gb_paddle4` (Xbox Elite paddles in order, facing the back: upper left, upper right, lower left, lower right)
- `gb_touchpad` (PS4/PS5 touchpad button)
- `ga_leftx`, `ga_lefty`
- `ga_rightx`, `ga_righty`
- `ga_triggerleft`, `ga_triggerright`
