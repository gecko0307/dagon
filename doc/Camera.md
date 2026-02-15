# Camera and View

Dagon provides a virtual camera system for both perspective and orthographic views. The camera simulates real-world optical principles while remaining fully resolution-independent for interactive applications.

The engine differentiates between a `Camera` and a `RenderView`:

* `Camera` is a subtype of `Entity`, a spatial object that can be transformed and provides perspective projection matrix based on the given FOV angle and Z thresholds.
* `RenderView` is an abstraction that encapsulates `Camera`, viewport and projection settings for a certain render pass. While `Camera` is a virtual model of a real-world camera, `RenderView` is more flexible than `Camera` alone, supporting both perspective and orthographic projections.

## Perspective View

Used when `RenderView.projection = Perspective`. Perspective projection in Dagon simulates how objects appear smaller as they move away from the camera, creating a realistic sense of depth.

Unlike photography and cinema, 3D graphics does not have a standard frame size that determines the optical characteristics of the camera. Games are expected to run at different resolutions, and this affects what user sees on the screen. One of the challenges with virtual cameras is maintaining a consistent user experience across different resolutions. Dagon uses Hor+ (horizontal plus) scaling method, where the vertical FOV of the camera is fixed (programmed in the game), while the horizontal FOV depends on the aspect ratio of the rendering resolution. A wider aspect ratio results in a larger FOV. This method favors wide and ultrawide screens, ensuring that they display more content on the sides rather than cropping the image vertically (Ver-).

## Orthographic View

Used when `RenderView.projection = Ortho`. The orthographic projection displays objects without perspective distortion (parallel lines remain parallel on screen). It is mostly used for isometric games.

## Screen-Aligned Orthographic View

Used when `RenderView.projection = OrthoScreen`. In this mode, the orthographic projection is built in such way that 1 scene unit corresponds to 1 logical pixel on the screen. It is used for 2D graphics, HUD and GUI overlays.
