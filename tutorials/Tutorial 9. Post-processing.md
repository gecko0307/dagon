# Tutorial 9. Post-processing

Dagon provides a simple built-in post-processing renderer with a chain of common filters, including FXAA antialiasing, glow, depth of field, lens distortion, and LUT color correction. You can enable and disable them individually.

Despite post-processing renderer is a part of the `Game` class, it is recommended to configure it in your `Scene` objects, because different scenes in the game usually have different look and feel.

## SSAO

This is not really a post-processing effect: in Dagon, SSAO is a part of the deferred pipeline. SSAO stands for "screen-space ambient occlusion". It is an approximation of ambient shadowing in the scene, calculated in screen space. Pixels become darker if they are closely surrounded by geometry. SSAO adds a great portion of realism to the rendering, especially in interior scenes, but it tends to make all surfaces slightly darker. You can control the contrast of the effect using the `Game.deferredRenderer.ssaoPower` parameter. The greater is power, the more pronounced is the occlusion effect.

## Motion Blur

Motion blur simulates the streaking effect that occurs when fast-moving objects are captured by a camera with a slow shutter speed. It adds a cinematic quality to movement and helps convey speed. In Dagon, motion blur is configurable with several parameters. `Game.deferredRenderer.motionBlurFramerate` emulates the virtual camera's framerate and affects how long the "shutter" stays open. More samples (`Game.deferredRenderer.motionBlurSamples`) produce smoother blur but are more computationally expensive.

You can also limit the blur to certain ranges using `Game.deferredRenderer.motionBlurMinDistance` and `Game.deferredRenderer.motionBlurMaxDistance`. The `Game.deferredRenderer.motionBlurRandomness` value adds variation to the blur direction to reduce aliasing artifacts.

## Glow

Glow (also known as bloom) makes bright areas of the image bleed into surrounding regions, simulating how bright light scatters in real optical systems. It's especially useful for emphasizing lights and bright emissive materials.

You can control the threshold at which the glow kicks in using `Game.deferredRenderer.glowThreshold`, and then fine-tune the effect with `Game.deferredRenderer.glowIntensity` and `Game.deferredRenderer.glowRadius`. A low threshold combined with high intensity will produce a very "dreamy" look, while a higher threshold keeps the effect more subtle and focused.

## Depth of Field

Depth of field replicates the focusing behavior of physical lenses, where only objects at a certain distance appear sharp, while others become blurry. This effect adds a photographic realism and helps guide viewer attention. You can enable autofocus, where the engine determines focus depth based on what's visible in the center of the screen, or set `Game.deferredRenderer.focalDepth` manually. The Game.deferredRenderer.focalLength` and Game.deferredRenderer.fStop` parameters mimic camera lens settings: a longer focal length or a lower f-stop will produce a shallower depth of field, leading to stronger blurring of out-of-focus objects.

## Lens Distortion

Lens distortion simulates imperfections and curvature found in real-world lenses, especially wide-angle or fish-eye optics. In Dagon, you can tweak this effect with `Game.deferredRenderer.lensDistortionScale`, which controls the strength of the distortion, and `Game.deferredRenderer.lensDistortionDispersion`, which adds chromatic aberration (color fringing) based on wavelength-dependent refraction. This is particularly useful for creating stylized or cinematic visuals.

## Tone mapping

Tone mapping converts HDR (high dynamic range) values from the rendering pipeline into the limited color range of the display. This is essential for preserving both shadow and highlight detail. Dagon supports several tone mapping operators, such as `AgX_Base`, `AgX_Punchy`, `Uncharted`, `ACES`, `Filmic`, `Unreal`, and others, each with different response curves. The selected tonemapper affects the overall mood and contrast of the image. Adjust the `Game.deferredRenderer.exposure` to control brightness - this is analogous to camera ISO. Higher exposure brightens the image, while lower values make it darker.

## Antialiasing

Antialiasing smooths jagged edges of the polygons. Dagon uses FXAA (Fast Approximate Anti-Aliasing), which is fast and lightweight, making it suitable for real-time rendering with minimal performance overhead. Antialiasing is disable by default, you can enable it with `Game.deferredRenderer.fxaaEnabled`. Note that it works best with high-resolution rendering.

## LUT

LUT (Lookup Table) color grading allows you to apply cinematic color transformations to your scene. A LUT is a 3D texture that remaps RGB values to a new color space. This can be used to give your game a vintage, sci-fi, warm, cold, or any stylized color treatment. You can generate LUTs using image editing software like Photoshop or DaVinci Resolve, then import them into Dagon and assign them to `Game.deferredRenderer.colorLookupTable`. Don't forget to enable the effect via `Game.deferredRenderer.lutEnabled`.

## Example

```d
class TestScene: Scene
{
    Game game;
    
    this(Game game)
    {
        super(game);
        this.game = game;
    }
    
    override void afterLoad()
    {
        game.deferredRenderer.ssaoEnabled = true;
        game.deferredRenderer.ssaoPower = 6.0;
        
        game.postProcessingRenderer.tonemapper = Tonemapper.AgX_Punchy;
        game.postProcessingRenderer.exposure = 1.0f;
        
        game.postProcessingRenderer.motionBlurEnabled = true;
        game.postProcessingRenderer.motionBlurFramerate = 24;
        game.postProcessingRenderer.motionBlurSamples = 16;
        game.postProcessingRenderer.motionBlurRandomness = 0.2f;
        game.postProcessingRenderer.motionBlurMinDistance = 0.01f;
        game.postProcessingRenderer.motionBlurMaxDistance = 1.0f;
        
        game.postProcessingRenderer.glowEnabled = true;
        game.postProcessingRenderer.glowThreshold = 0.3f;
        game.postProcessingRenderer.glowIntensity = 0.3f;
        game.postProcessingRenderer.glowRadius = 10;
        
        game.postProcessingRenderer.fxaaEnabled = true;
        
        game.postProcessingRenderer.lutEnabled = true;
        game.postProcessingRenderer.colorLookupTable = aTexColorTable.texture;
        
        game.postProcessingRenderer.lensDistortionEnabled = true;
        game.postProcessingRenderer.lensDistortionScale = 1.0f;
        game.postProcessingRenderer.lensDistortionDispersion = 0.1f;
        
        game.postProcessingRenderer.depthOfFieldEnabled = true;
        game.postProcessingRenderer.autofocus = false;
        game.postProcessingRenderer.focalDepth = 1.5f;
        game.postProcessingRenderer.focalLength = 5.0f;
        game.postProcessingRenderer.fStop = 2.0f;
    }
}
```

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t9-post-processing)
