# Conf Files

Conf is a configuration file format in Dagon. Any application using Dagon tries to read two configuration files from working directory: `settings.conf` and `input.conf`.

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
`settings.conf` contains engine settings. It is fully preserved for Dagon's internal mechanisms, and you are not recommended to use it for storing game-specific settings. Supported options are the following:

* `windowWidth`, `windowHeight` - size of a game window. They override default values specified in an application
* `fullscreen` - `0` or `1`, run in windowed or fullscreen mode
* `windowTitle` - window title text
* `hideConsole` - `0` or `1`, show or hide the console window. For example, it is convenient to leave it when debugging the game and hide it for end users
* `locale` - locale that should be loaded. This option overrides automatically selected locale based on system language and region. For example, `locale: "en_US";` means that application will try load `locales/en_US.lang` file and will ignore system language.
* `renderer.fxaaEnabled` - 
* `renderer.ssaoEnabled` - 
* `renderer.ssaoSamples` - 
* `renderer.ssaoRadius` - 
* `renderer.ssaoPower` - 
* `renderer.ssaoDenoise` - 
* `renderer.occlusionBufferDetail` - 
* `renderer.glowEnabled` - 
* `renderer.glowViewScale` - 
* `renderer.glowThreshold` - 
* `renderer.glowIntensity` - 
* `renderer.glowRadius` - 
* `renderer.tonemapper` - 
* `renderer.exposure` - 
* `renderer.motionBlurEnabled` - 
* `renderer.motionBlurSamples` - 
* `renderer.motionBlurFramerate` - 
* `renderer.motionBlurRandomness` - 
* `renderer.motionBlurMinDistance` - 
* `renderer.motionBlurMaxDistance` - 
* `renderer.radialBlurAmount` - 
* `renderer.lensDistortionEnabled` - 
* `renderer.lensDistortionScale` - 
* `renderer.lensDistortionDispersion` - 
* `renderer.dofEnabled` - 
* `renderer.autofocus` - 
* `renderer.focalDepth` - 
* `renderer.focalLength` - 
* `renderer.fStop` - 
* `renderer.dofManual` - 
* `renderer.dofNearStart` - 
* `renderer.dofNearDistance` - 
* `renderer.dofFarStart` - 
* `renderer.dofFarDistance` - 
* `renderer.lutEnabled` - 
* `renderer.lut` - 

The engine doesn't modify `settings.conf`, and you can imlement a visual configurator in your game that modifies this file.

If the file doesn't exist, the engine will print a warning and run with default settings.

## input.conf
`input.conf` contains input bindings. See Input Manager tutorial for details.
