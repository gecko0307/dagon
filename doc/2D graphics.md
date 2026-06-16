# 2D Graphics

Dagon is primarily a 3D engine, but it supports 2D rendering as well. 2D renderer is called HUD renderer, because it was created for drawing HUD elements on top of the viewport. It is also possible to make purely 2D games with it, in which cases it is recommended to use `Game2D` base game class.

## HUD Objects

HUD stands for "Head-Up Display". In contrast to GUI, HUD is usually a non-interactive system for displaying in-game information, such as player's health, ammo, and a minimap. In Dagon, HUD elements are Entities with `layer` set to `EntityLayer.Foreground`. Projection in HUD pass is `OrthoScreen` meaning that it uses screen-aligned coordinate space (unit length in this space corresponds to a physical pixel of the back buffer). Coordinate origin is an upper-left corner of the window.

`Scene` class provides a helper method `addEntityHUD` to create such Entities. Note that HUD rendering requires a special shader, and it should be created manually. The following example shows how to create a 64x64 crosshair and set up a proper material for it:

```d
auto hudShader = New!HUDShader(assetManager);

auto crosshair = addEntityHUD();
crosshair.drawable = New!ShapeQuad(assetManager);
crosshair.scaling = Vector3f(64.0f, 64.0f, 1.0f);
crosshair.position = Vector3f(
    game.drawableWidth * 0.5f - 32.0f,
    game.drawableHeight * 0.5f - 32.0f,
    0.0f);

crosshair.material = addMaterial();
crosshair.material.shader = hudShader;
crosshair.material.baseColorTexture = aCrosshairSprite.texture;
crosshair.material.depthWrite = false;
crosshair.material.useCulling = false;
crosshair.material.blendMode = Transparent;
```

## 2D Text

Text rendering is a bit simpler, because it uses a specialized shader which is implicitly managed by the engine.

```d
auto text = New!TextLine(aFont.font, "Hello, World!", assetManager);
text.color = Color4f(1.0f, 1.0f, 1.0f, 1.0f);

auto eText = addEntityHUD();
eText.drawable = text;
eText.position = Vector3f(16.0f, 30.0f, 0.0f);
```

## Spritesheets

A spritesheet is a texture that contains multiple sub-images - sprites. Each sprite provides a texture for a quad that represents an object in a 2D world. This is achieved by transforming UV coordinates used to sample the texture. Dagon's material class provides a helper method `setSprite` for this task.

Sprites can be used in both 2D and 3D games. `setSprite` accepts UV coordinates ranging from 0 to 1, so, to use pixels, you have to divide pixel values with the texture size.

Let's say the crosshair is an upper-left 64x64 sub-image of a 1024x1024 texture:

```d
Vector2f spritesheetSize = Vector2f(1024, 1024);
crosshair.material.setSprite(
    Vector2f(64, 64) / spritesheetSize,
    Vector2f(0, 0) / spritesheetSize);
```

To animate a sprite, you can change UV offset over time, incrementing by the frame width along the X-axis.

## Widgets

Dagon provides a built-in widget system for implementing a basic GUI in games. It is nowhere near as powerful as specialized GUI libraries such as ImGui, but can be used for simple interactive elements such as buttons and menus.

TODO: add a button widget example

## 2D Applications

It is perfectly viable to use Dagon for 2D games! If you don't need 3D graphics and only rely on `HUDRenderer`, we recommend to use `Game2D` class instead of usual `Game`.

```d
class MyGame: Game2D
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        currentScene = New!TestScene(this);
    }
}
```

## HiDPI

Dagon natively supports HiDPI (aka Retina) displays. These are displays with high pixel density (usually 240 DPI or higher). Normal rendering will appear blurry on such screens; the renderer should take pixel density into account and provide output larger than the target window. To enable HiDPI-awareness, use `window.hiDPI` option in `settings.conf`:

```
window.hiDPI = 1;
```

This will create a window with an actual drawable area larger than the window itself (by multiplier available as `Application.pixelRatio`).

Dagon's built-in 3D renderer automatically adapts to the pixel ratio. However, HUD renderer currently doesn't do any DPI scaling, which means that screen-aligned 2D objects are rendered in framebuffer space, not in logical window space. An easy workaround is to make a root parent for all of the 2D objects and scale it by the `Application.pixelRatio`:

```d
float pixelRatio = myApplication.pixelRatio;
hudRoot.scaling = Vector3f(pixelRatio, pixelRatio, 1.0f);
```

After that, all children of `hudRoot` will have correct mapping from logical (window-space) to physical (framebuffer-space) pixels. For best quality, your sprites on the sheet should be 2x larger than their logical dimensions on screen.

Dagon's 2D text renderer is already HiDPI-aware. The font size, as well as all the typography, is adjusted by `pixelRatio`. Some care must be taken to convert values based on physical typographic units (such as glyph metrics and advance distances) to logical coordinates, if necessary.

The input system uses purely logical coordinates. For 2D games and UI systems, instead of converting the mouse coordinates (`eventManager.mouseX`, `eventManager.mouseY`) into physical space, we recommend doing all input-related tests and comparisons in logical space and use physical coordinates only for the rendering.
