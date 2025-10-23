# HiDPI Rendering

Dagon natively supports HiDPI (aka Retina) displays. These are displays with high pixel density (usually 240 DPI or higher). Normal rendering will appear blurry on such screens; the renderer should take pixel density into account and provide output larger than the target window. To enable HiDPI-awareness, use `window.hiDPI` option in `settings.conf`:

```
window.hiDPI = 1;
```

This will create a window with an actual drawable area larger than the window itself (by multiplier available as `Application.pixelRatio`).

## Logical vs. physical pixels

Dagon's built-in 3D renderer automatically adapts to the pixel ratio. However, HUD renderer currently doesn't do any DPI scaling, which means that screen-aligned 2D objects are rendered in framebuffer space, not in logical window space. An easy workaround is to make a root parent for all of the 2D objects and scale it by the `Application.pixelRatio`:

```d
float pixelRatio = myApplication.pixelRatio;
hudRoot.scaling = Vector3f(pixelRatio, pixelRatio, 1.0f);
```

After that, all children of `hudRoot` will have correct mapping from logical (window-space) to physical (framebuffer-space) pixels.

## HiDPI Text

Dagon's 2D text renderer is already HiDPI-aware. The font size, as well as all the typography, is adjusted by `pixelRatio`. Some care must be taken to convert values based on physical typographic units (such as glyph metrics and advance distances) to logical coordinates, if necessary.

## Mouse Input

The input system uses logical coordinates. For 2D games and UI systems, instead of converting the mouse coordinates (`eventManager.mouseX`, `eventManager.mouseY`) into physical space, we recommend doing all input-related tests and comparisons in logical space and use physical coordinates only for the rendering.
