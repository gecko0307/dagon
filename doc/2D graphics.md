# 2D Graphics

Dagon is primarily a 3D engine, but it supports 2D rendering as well. 2D renderer is called HUD renderer, because it was created for drawing HUD elements on top of the rendered screen. It is also possible to make purely 2D games with it, in which cases it is recommended to use `Game2D` base game class.

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

TODO

## Widgets

Dagon provides a simple widget system for implementing a basic GUI in games. It is nowhere near as powerful as specialized GUI libraries such as ImGui, but can be to create buttons and menus.

TODO: add a button widget example

## 2D Applications

It is perfectly viable to use Dagon for 2D games! If you don't need 3D graphics and only rely on `HUDRenderer`, we recommend to use `Game2D` class instead of usual `Game`.

TODO: Game2D usage example
