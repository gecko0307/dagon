# Post-Processing Pipeline

Post-processing is a series of per-pixel operations (filters) applied to the framebuffer after it is rendered and before it is displayed on the screen. This is done mainly for aesthetic reasons, to give the rendering more cinematic appearance, or to achieve a certain look and feel determined by the game's design. One class of post-processing filters simulate optical phenomena inherent in a physical camera (bokeh, motion blur, chromatic aberration) to bring games closer to movies. Others use synthetic enhancement techniques (such as anti-aliasing) and color transformations to improve the perceived quality of the image.

Dagon provides a simple built-in post-processing pipeline, `PostProcRenderer`, that includes a stack of common filters, which can be enabled and disabled individually, via render.conf file or in the application code. It is also possible to add custom filters.

Most of the filters work in linear RGB color space, which ensures physically correct color arythmetics.

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
* `dof.pentagonBokehFeather` - feathering (smoothing) factor of pentagon-shaped bokeh edges. Default is `0.4`

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

## Tonemap

Tonemapping converts high-dynamic-range (HDR) color values to low-dynamic-range (LDR) color values suitable for displays. Dagon supports all industry-standard tonemapping operators, including Reinhard, Hable/Uncharted, Unreal, ACES, Uchimura, AgX and Khronos PBR Neutral.

## Anti-aliasing

Anti-aliasing is a filter for smoothing jagged polygon edges. Dagon implements FXAA (Fast Approximate Anti-Aliasing), one of the most efficient AA algorithms.

## Color Grading

Color grading is a set of operations that adjust the brightness, contrast, saturation, and color balance of a scene. Dagon supports basic color adjustment parameters that are combined into a single color correction matrix which is passed to the shader to linearly transform input color data. Alternatively, color grading can be done using a LUT (lookup table), a 3D texture that maps RGB values to adjusted color space. This is a very flexible approach that allows to "bake" color modifications using any external image editor.

Color adjustment is controlled with the following render.conf parameters:
* `cc.brightness` - scales overall lightness of a scene. `0.0` is identity brightness (unchanged), negative values make the image darker, positive values make the image brighter;
* `cc.contrast` - adjusts difference between dark and bright regions. `1.0` is identity contrast (unchanged), smaller values decrease contrast, larger values increase contrast;
* `cc.saturation` - scales color intensity. `1.0` is identity saturation, smaller values desaturate the image (`0.0` gives monochrome look), larger values oversaturate the image;

If LUT is used, `cc` parameters are ignored, and color adjustment is overridden with color lookup from a texture.
* `lut.enabled` - disables or enables LUT color grading
* `lut.file` - path to the LUT file, usually a lossless image that encodes a 3D color space. Currently this parameter supports only GPUImage format LUTs (see below). The loaded LUT is automatically converted to 3D texture for more efficient sampling in the shader

Dagon supports two LUT formats that differ in the 3D-to-2D encoding method they use.

* **GPUImage LUT** -
* **Hald CLUT** -

It is also possible to load 3D texture 

## Sharpening

Sharpening enhances perceived detail by increasing local contrast. Dagon imlements CAS (Contrast Adaptive Sharpening).

## Presentation

Final step after all filters is presentation, blitting the result into the backbuffer. This step includes gamma correction and optional pixelization procedure (to achieve a funny retro-style look).
