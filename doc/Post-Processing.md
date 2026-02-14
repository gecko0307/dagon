# Post-Processing Pipeline

Post-processing is a series of per-pixel operations (filters) applied to the framebuffer after it is rendered and before it is displayed on the screen. This is done mainly for aesthetic reasons, to give the rendering more cinematic appearance, or to achieve a certain look and feel determined by the game's design. One class of post-processing filters simulate optical phenomena inherent in a physical camera (bokeh, motion blur, chromatic aberration) to bring games closer to movies. Others use synthetic enhancement techniques (such as anti-aliasing) and color transformations to improve the perceived quality of the image.

Dagon provides a simple built-in post-processing pipeline, `PostProcRenderer`, that includes a stack of common filters, which can be enabled and disabled individually, via render.conf file or in the application code. It is also possible to add custom filters.

Most of the filters work in linear RGB color space, which ensures physically correct color arythmetics.

**Linear RGB**: a color space which values are proportional to actual physical light intensity.

**sRGB**: a gamma-encoded color space for display output. Dagon performs color space conversions automatically where required.

## Depth of Field

Depth of field is an optical effect of a camera lens. Objects at a specific focal distance remain sharp, while closer or farther objects become increasingly blurred. Dagon implements realistic bokeh-style DoF based on the code by Martins Upitis which uses a circle-of-confusion mask calculated from the depth buffer. It supports both automatic and manual focus.

## Motion Blur

Motion blur simulates the streaking of moving objects or the camera during exposure. Dagon implements velocity-based motion blur, using Monte Carlo sampling based on a per-pixel motion vector buffer computed from camera and object movement.

## Lens Distortion

Lens distortion simulates optical imperfections of a lens such as barrel distortion and chromatic aberration. Dagon implements an efficient and visually plausible lens distortion filter based on code by Jaume Sanchez Elias from [Wagner](https://github.com/spite/Wagner) composer.

## Glow

Glow (or bloom) enhances bright areas of the image, simulating light scattering in a lens. Dagon implements a threshold + blur approach, isolating bright regions, blurring them, and blending them back to the original scene. It uses [multipass separable Gaussian blur implementation](https://github.com/Experience-Monks/glsl-fast-gaussian-blur) by Matt DesLauriers, an extremely optimized algorithm that allows large blur radii.

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
* `lut.file` - path to the LUT file, usually a lossless image that encodes a 3D color space. Currently this parameter supports only GPUImage format LUTs (see below).

Dagon supports two LUT formats that differ in the 3D-to-2D encoding method they use.

* **GPUImage LUT** - TODO
* **Hald CLUT** - TODO

## Sharpening

Sharpening enhances perceived detail by increasing local contrast. Dagon imlements CAS (Contrast Adaptive Sharpening).

## Presentation

Final step after all filters is presentation, blitting the result into the backbuffer. This step includes gamma correction and optional pixelization procedure (to achieve a funny retro-style look).
