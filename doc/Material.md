# Material
Material in Dagon is a description of entity's surface properties. Dagon implements physically based rendering (PBR) and follows roughness/metallic workflow for materials.

## PBR
PBR a combination of rendering techniques that bring real-time graphics closer to real world by following laws of optics. PBR operates on a unified set of inputs that are completely independent from lighting, so PBR materials look consistent in any environment and are usually portable between different graphics software and game engines.

## Properties
`baseColorFactor` and `baseColorTexture` - color of a surface. This is also called albedo or diffuse color. The alpha channel defines surface transparency if `blendMode` property is set to `Transparent`.

`roughnessFactor` and `roughnessTexture` - roughness of a surface, a number between 0.0 and 1.0. This affects blurriness of specular reflection. Materials like metal, shiny plastic or polished wood have low roughness, and materials like raw stone, concrete or cloth have high roughness.

`metallicFactor` and `metallicTexture` - metallicity of a surface, a number between 0.0 and 1.0. This affects color of specular reflection: for metals (conductors) incoming light color is modulated by surface color, and for other materials (dielectrics) it isn't, so, for example, a red chrome covered christmas ball looks different from red plastic ball.

`emissionFactor` and `emissionTexture` - self-illumination color.

`emissionEnergy` - self-illumination brightness.

`normalFactor` and `normalTexture` - per-pixel normal of a surface in tangent space.

`heightFactor` and `heightTexture` - per-pixel height of a surface. When using parallax mapping, it is used to displace texture coordinates and give a surface more bumpy look.

`maskFactor` and `maskTexture` - used only with terrains. Defines an alpha mask for a terrain texture layer.

`parallaxMode` - parallax mapping method: 
* `ParallaxNone` (0) - parallax mapping turned off
* `ParallaxSimple` (1) - simple parallax mapping based on eye vector
* `ParallaxOcclusionMapping` (2) - parallax occlusion mapping.

`blendMode` - blending mode of a surface:
* `Opaque` (0) - opaque surface. This is set by default
* `Transparent` (1) - alpha channel of diffuse color (or texture) defines transparency. Note that transparent materials are not supported by deferred pipeline, so such objects will be rendered in forward mode with fallback shading model
* `Additive` (2) - surface is additively blended with the background. Note that additive blending is not supported by deferred pipeline, so such objects will be rendered in forward mode with fallback shading model.

`opacity` - transparency multiplier for base color color.

`alphaTestThreshold` - alpha cutout threshold. Any alpha lower than this value will be treated as 0 (fully transparent) in deferred pipeline.

`useFog` - if set to `true`, surface will be mixed with fog color based on distance from camera.

`useCulling` - enable backface culling.

`colorWrite`, `depthWrite` - enable write to color buffer (or GBuffer) and depth buffers.

`textureScale` - when using textures, this `Vector2f` define the scale of UV coordinates. This is useful to repeat a texture on surface.

`shadowFilter` - determines filter for sampling shadow maps:
* `ShadowFilterNone` (0) - don't filter shadows
* `ShadowFilterPCF` (1) - use percentage-closer filtering (soft shadows)
