# Post-Processing Pipeline

Post-processing is a series of per-pixel operations (filters) applied to the framebuffer after it is rendered and before it is displayed on the screen. This is done mainly for aesthetic reasons, to give the rendering more cinematic appearance, or to achieve a certain look and feel determined by the game's design. One class of post-processing filters simulate optical phenomena inherent in a physical camera (bokeh, motion blur, chromatic aberration) to bring games closer to movies. Others use synthetic enhancement techniques (such as anti-aliasing) and color transformations to improve the perceived quality of the image.

Dagon provides a simple built-in post-processing pipeline, `PostProcRenderer`, that includes a stack of common filters, which can be enabled and disabled individually, via render.conf file or in the application code. It is also possible to add custom filters.

Most of the filters work in linear RGB color space, which ensures physically correct color arythmetics. Dagon's working space is Rec. 709 linear RGB.

## Depth of Field

Depth of field is an optical effect of a camera lens. Objects at a specific focal distance remain sharp, while closer or farther objects become increasingly blurred. Dagon implements realistic bokeh-style DoF based on the code by Martins Upitis which uses a circle-of-confusion mask calculated from the depth buffer. It supports both automatic and manual focus.

Depth of field parameters (for render.conf):

* `dof.enabled` - enabled or disables depth of field. Default is `false`
* `dof.autofocus` - automatically determine focal depth based on distance to the point in the middle of the screen. If this is set to `false`, `dof.focalDepth` is used. Default is `true`
* `dof.focalDepth` - the distance between the back focal plane (sensor) and the front focal plane (main focal point). Used only in manual focusing mode. Measured in meters. Default is `1.0`
* `dof.focalLength` - f, the distance between the lens and the back focal plane when focused at infinity. Measured in millimeters. Default is `20`.

Focal length determines the field of view according to:

```
FOV = 2 arctan(d / 2f)
```

where `f` is the focal length, and `d` is the width of the frame for horizontal FOV, or height for vertical FOV.

In computer graphics, the FOV and focal length of a virtual camera are defined relative to a chosen virtual sensor size and are independent of render resolution. Once the sensor format is fixed, the relationship between FOV and focal length becomes constant, so precomputed values may be used instead of evaluating the formula at runtime. Given 36x24 full-frame format, vertical FOV angles for common lenses are the following:

```
12 mm -> 90.0°
14 mm -> 81.2°
16 mm -> 73.9°
20 mm -> 61.9°
24 mm -> 53.1°
35 mm -> 37.8°
50 mm -> 27.0°
```

* `dof.fStop` - the relative aperture of the lens, controls the depth of field. Default is `16` (f/16).

Smaller values (f/1.4, f/2.0) correspond to a larger aperture and shallower depth of field. Larger values (f/16, f/32) correspond to a smaller aperture and deeper depth of field.

* `dof.circleOfConfusion` - the maximum diameter of a blur spot on an image that the human eye still perceives as sharp. Measured in millimeters. Default is `0.03`.

Standard CoC sizes by sensor type (approximate):

```
Full Frame 35mm: 0.029..0.03 mm
APS-C Canon: 0.019 mm
APS-C Nikon/Sony/Pentax: 0.02 mm
Micro 4:3: 0.015 mm
Medium Format (6x4.5): 0.05 mm
```

* `dof.manual` - manual depth of field mode. When this mode is enabled, physically-based parameters (`fStop`, `focalLength`, `circleOfConfusion`) are ignored, and the range of distance in a scene that appears sharp is controlled using parameters below. `focalDepth` and `autofocus` are still respected. Default is `false`
* `dof.nearStart` - near-side sharpness threshold (distance from the front focal plane opposite the view direction at which focus begins to decrease)
* `dof.nearDistance` - the distance at which near-side focus blur reaches its maximum
* `dof.farStart` - far-side sharpness threshold (distance from the front focal plane in the view direction at which focus begins to decrease)
* `dof.farDistance` - the distance at which far-side focus blur reaches its maximum.
* `dof.pentagonBokeh` - if set to `true`, pentagon-shaped aperture will be simulated instead of a circular aperture. Default is `false`
* `dof.pentagonBokehFeather` - feathering (smoothing) factor of pentagon-shaped bokeh edges. Default is `0.4`.

## Motion Blur

Motion blur simulates the streaking of moving objects or the camera during exposure. Dagon implements velocity-based motion blur, using Monte Carlo sampling based on a per-pixel motion vector buffer computed from camera and object movement.

Motion blur parameters (for render.conf):

* `motionBlur.enabled` - enabled or disables motion blur. Default is `false`
* `motionBlur.samples` -
* `motionBlur.framerate` -
* `motionBlur.randomness` -
* `motionBlur.minDistance` -
* `motionBlur.maxDistance` -
* `motionBlur.radialBlurAmount` -

## Lens Distortion

Lens distortion simulates optical imperfections of a lens such as barrel distortion and chromatic aberration. Dagon implements an efficient and visually plausible lens distortion filter based on code by Jaume Sanchez Elias from [Wagner](https://github.com/spite/Wagner) composer.

Lens distortion parameters (for render.conf):

* `lensDistortion.enabled` - enabled or disables motion blur. Default is `false`
* `lensDistortion.scale` - 
* `lensDistortion.dispersion` -

## Glow

Glow (sometimes called bloom) is used to emphasize bright areas of the image, simulating light scattering/bleeding in an optical system. Dagon implements a threshold + blur approach, isolating bright regions, blurring them, and blending them back with the original scene. It uses [multipass separable Gaussian blur implementation](https://github.com/Experience-Monks/glsl-fast-gaussian-blur) by Matt DesLauriers, an extremely optimized algorithm that allows large blur radii.

* `glow.enabled` - enabled or disables glow. Default is `false`
* `glow.viewScale` -
* `glow.threshold` -
* `glow.intensity` -
* `glow.radius` -

## Vignetting

Vignetting is the reduction of an image's brightness at the periphery compared to the center.

Vignetting parameters (for render.conf):

* `vignette.enabled` -
* `vignette.strength` -
* `vignette.size` - the size of the vignette in the form [width / 2, height / 2]. To make a vignette that starts fading in halfway between the center and edges of UV space you would pass in `[0.25, 0.25]`
* `vignette.roundness` - how round the vignette will be. A value from `0` to `1` where `1` is perfectly round (forming a circle or oval) and `0` is not round at all (forming a square or rectangle)
* `vignette.feathering` - UV distance at which the vignette stops fading in. The vignette will start fading in at the edge of the values provided by size, and will be fully faded in at `[size.x + feathering, size.y + feathering]`. A value of zero results in a hard edge.

## Tonemap

Tonemapping filter converts high-dynamic-range (HDR) color values to low-dynamic-range (LDR) color values suitable for displays. Dagon supports all industry-standard tonemapping operators.

Tonemap parameters (for render.conf):

* `hdr.tonemapper` - tonemapping operator used to compress HDR to LDR. Default is `"ACES"`. Supported options are:
  * `"None"` - tonemapping is not applied
  * `"Unreal"` - tonemapper from Unreal 3
  * `"Reinhard"` - ["Photographic Tone Reproduction for Digital Images"](https://www-old.cs.utah.edu/docs/techreports/2002/pdf/UUCS-02-001.pdf), Erik Reinhard et al, 2002, Equation 3
  * `"Reinhard2"` - ["Photographic Tone Reproduction for Digital Images"](https://www-old.cs.utah.edu/docs/techreports/2002/pdf/UUCS-02-001.pdf), Erik Reinhard et al, 2002, Equation 4
  * `"Hable"`/`"Uncharted"` - ["Filmic Tonemapping Operators"](http://filmicworlds.com/blog/filmic-tonemapping-operators), John Hable, 2010, formula by John Hable (Uncharted 2)
  * `"Filmic"` - ["Filmic Tonemapping Operators"](http://filmicworlds.com/blog/filmic-tonemapping-operators), John Hable, 2010, formula by Jim Hejl and Richard Burgess-Dawson
  * `"ACES"` - ["ACES Filmic Tone Mapping Curve"](https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve), Krzysztof Narkowicz, 2016
  * `"Uchimura"` - ["HDR Theory and Practice"](https://www.slideshare.net/nikuque/hdr-theory-and-practicce-jp), Hajime Uchimura, 2017
  * `"Lottes"` - "Advanced Techniques and Optimization of HDR Color Pipelines", Timothy Lottes, 2016
  * `"AgX_Base"`, `"AgX_Punchy"` - AgX tonemapper from Blender 4.0+ and Filament
  * `"KhronosPBRNeutral"` - [Neutral Tone Mapping for PBR Color Accuracy](https://dl.acm.org/doi/fullHtml/10.1145/3641233.3664313), Emmett Lalish, 2024.

The same filter is also responsible for exposure compensation. This is a procedure that adapts HDR image to a desirable luminance range, ensuring highlights and shadows are properly exposed.

* `hdr.exposure` - exposure value for manual compensation. Default is `1.0`
* `hdr.autoexposure` - if enabled, the engine will automatically determine exposure compensation based on average luminance of a scene. Default is `false`
* `hdr.keyValue` - target average luminance for autoexposure. Higher values give brighter scene. Default is `0.5`
* `hdr.exposureAdaptationSpeed` - rate of exposure change over time. `1.0` corresponds to full exposure adjustment over one second. Default is `2.0`.

## Film Grain

Film grain is an artifact of a photographic media, a random optical texture caused by small particles being present on the physical film. Simulation of this effect is useful for achieving a retro look.

Film grain parameters (for render.conf):

* `filmGrain.enabled` - 
* `filmGrain.colored` - 

## Anti-Aliasing

Anti-aliasing is a filter for smoothing jagged polygon edges. Dagon implements FXAA (Fast Approximate Anti-Aliasing), one of the most efficient AA algorithms.

## Color Grading

Color grading is a set of operations that adjust the brightness, contrast, saturation, and color balance of a scene. Dagon supports basic color adjustment parameters that are combined into a single color correction matrix which is passed to the shader to linearly transform input color data.

Color adjustment is controlled with the following render.conf parameters:
* `cc.brightness` - scales overall lightness of a scene. `0.0` is identity brightness, negative values make the image darker, positive values make the image brighter. Default is `0.0`;
* `cc.contrast` - adjusts difference between dark and bright regions. `1.0` is identity contrast, smaller values decrease contrast, larger values increase contrast. Default is `1.0`;
* `cc.saturation` - scales color intensity. `1.0` is identity saturation, smaller values desaturate the image (`0.0` gives monochrome look), larger values oversaturate the image. Default is `1.0`;
* `cc.colorMatrix` - 4x4 row-major color correction matrix that overrides brightness/contrast/saturation, if specified. Directly used to transform the input color. For example, the following matrix applies a sepia filter:

```
cc.colorMatrix: [
    0.393, 0.769, 0.189, 0,
    0.349, 0.686, 0.168, 0,
    0.272, 0.534, 0.131, 0,
    0,     0,     0,     1
];
```

Alternatively, color grading can be done using a LUT (lookup table), a 3D texture that maps RGB values to adjusted color space. This is a very flexible approach that allows to "bake" non-linear color modifications using any external image editor. If LUT is used, `cc.*` parameters are ignored, and color adjustment is overridden with color lookup from a texture.

* `lut.enabled` - disables or enables LUT color grading
* `lut.file` - path to the LUT file, usually a lossless image that encodes a 3D color space. This parameter supports DDS 3D texture and GPUImage LUT (see below). The loaded LUT is automatically converted to 3D texture, enabling efficient trilinear sampling in the shader.

Dagon supports three LUT formats that differ in the 3D-to-2D encoding method they use:

* **GPUImage LUT** - format based on [GPUImage](https://github.com/BradLarson/GPUImage) workflow. This is 512x512 image that encodes 64x64x64 color array by slicing along B-channel, where each 64x64 slice encodes an RG plane. Slices are tiled from left to right, from top to bottom. This is a very size-efficient way to store a LUT, giving the best lossless compression in PNG. The drawback is that it requires a special lookup function in the shader, or should be converted to 3D texture in advance. Dagon automatically does this conversion for LUTs specified in render.conf;
* **Hald CLUT** - 3D texture linearly packed into 2D image row by row, starting from the first RG plane (where B = 0). This is also usually 512x512 image that encodes 64x64x64 color array. Hald CLUT compresses a bit worse than GPUImage LUT, but its advantage is that it doesn't require any runtime conversion and is directly uploaded to VRAM. **Currently this format is not supported for render.conf** (should be loaded manually in the game code);
* **DDS 3D texture** - a 3D texture stored in DDS container format. It doesn't require conversion and stored as uncompressed raw data, which makes it the fastest to load, but heaviest in file size.

GPUImage LUT and Hald CLUT can be easily created in any image editor that supports color grading (like Photoshop or GIMP). First, take a reference screenshot of the game in its unmodified colors. Open the screenshot in an editor. Extend the image canvas horizontally and place the identity LUT beside the screenshot (you can use identity GPUImage LUT from Dagon's data folder, `data/__internal/textures/lut.png`). Merge layers together and perform color adjustments: brightness, contrast, saturation, color temperature, RGB curves, etc. Note that color correction must be performed for each pixel independently of the others; filters based on convolution or any operations that depend on neighboring pixels are not compatible with LUT-based workflow

When you are happy with the result, crop the edited LUT and save it. It's worth noting that LUTs should always be stored in a lossless format. PNG is usually the best choice.

## Sharpening

Sharpening enhances perceived detail by increasing local contrast. Dagon imlements CAS (Contrast Adaptive Sharpening).

Sharpening parameters (for render.conf):

* `sharpening.enabled` - 
* `sharpening.strength` - 

## Presentation

Final step after all filters is presentation, blitting the result into the backbuffer. This step includes gamma correction and optional pixelization procedure (to achieve a funny retro-style look).

* `pixelization.enabled` - 
* `pixelization.pixelSize` - 
