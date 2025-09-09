# Material

Material in Dagon is a description of entity's surface properties. Dagon implements physically based rendering (PBR) and follows roughness/metallic workflow for materials.

## PBR

PBR a combination of rendering techniques that bring real-time graphics closer to real world by following laws of optics. PBR operates on a unified set of inputs that are completely independent from lighting, so PBR materials look consistent in any environment and are usually portable between different graphics software and game engines.

## Properties

`baseColorFactor` and `baseColorTexture` - color of a surface. This is also called albedo or diffuse color. The alpha channel defines surface transparency if `blendMode` property is set to `Transparent`. Color data must be in sRGB space.

`roughnessFactor` - roughness of a surface, a number between `0.0` and `1.0`. Dagon's shading model (GGX) treats all surfaces as consisting of microscopic perfect mirrors (microfacets). The roughness parameter can be understood as a probability of microfacet normal's random deviation from the surface normal. Visually, this affects blurriness of a specular reflection. Materials like metal, shiny plastic or polished wood have low roughness, and materials like raw stone, concrete or cloth have high roughness.

`metallicFactor` - metalness of a surface, a number between `0.0` and `1.0`. It defines the surface's material type: non-metal (dielectric) or metal (conductor). A value of 0.0 means the surface behaves like a non-metal (e.g., plastic, wood, fabric), and 1.0 means it behaves like a pure metal (e.g., iron, gold, copper). Intermediate values can be used for artistic purposes or for simulating dirty or oxidized metal surfaces. In Dagon's shading model, this factor determines how light interacts with microfacets:
* For non-metals (metallic = 0), microfacets reflect only specular light and have a separate diffuse response based on `baseColorFactor`.
* For metals (metallic = 1), the surface has no diffuse reflection - all reflected light is specular, colored by `baseColorFactor`.
Microfacets are considered perfect mirrors at microscopic scale, but only for metals their reflectance dominates, while for dielectrics, much of the incoming light is scattered diffusely beneath the surface. Effectively, `metallicFactor` defines the chemical composition of the surface, while `roughnessFactor` defines its microscopic geometric structure.

`roughnessMetallicTexture` - combined roughness/metallic texture. Green channel stores roughness, blue channel stores metalness (as defined by glTF 2.0 specification). Data must be in linear space.

`emissionFactor` and `emissionTexture` - self-illumination color. Must be in sRGB.

`emissionEnergy` - self-illumination brightness.

`normalFactor` and `normalTexture` - per-pixel normal of a surface in tangent space.

`heightFactor` and `heightTexture` - per-pixel height of a surface. When using parallax mapping, it is used to displace texture coordinates and give a surface more bumpy look.

`maskFactor` and `maskTexture` - a number between `0.0` and `1.0`, or a b/w texture. Used only with terrains. Defines an alpha mask for a terrain texture layer.

`parallaxMode` - parallax mapping method. This property controls how height information from the heightmap is used to create an illusion of depth on flat surfaces by offsetting texture coordinates based on view direction. Available modes:
* `ParallaxNone` (0) - disables parallax mapping;
* `ParallaxSimple` (1) - basic offset mapping: uses a single-step linear offset of texture coordinates along the eye vector. It is fast but visually less accurate, especially at grazing angles;
* `ParallaxOcclusionMapping` (2) - parallax occlusion mapping. Traces multiple depth layers to find the correct occlusion point along the view ray. Produces more convincing depth with self-occlusion and perspective parallax, but is more expensive to compute.
Parallax mapping only affects the appearance of surface detail, not the actual geometry or silhouette of the mesh. Works best when applied to surfaces viewed at shallow angles.

`parallaxScale` - scale of the parallax height effect. Default is `0.03`. This value defines the maximum height in world units to interpret samples from the height map. Larger values increase the perceived depth but may cause artifacts like texture stretching or visible discontinuities. For realistic materials, a value between 0.02 and 0.05 is typically sufficient.

`parallaxBias` - vertical bias applied to the parallax height function. Default is `-0.01`. This offsets the sampled height to reduce artifacts like texture popping or self-shadowing errors at steep viewing angles.

`blendMode` - blending mode of a surface:
* `Opaque` (0) - opaque surface. This is set by default;
* `Transparent` (1) - alpha channel of diffuse color (or texture) defines transparency. Note that transparent materials are not supported by deferred pipeline, such objects will be rendered in forward mode with fallback shading model;
* `Additive` (2) - surface is additively blended with the background. Note that additive blending is not supported by deferred pipeline, such objects will be rendered in forward mode with fallback shading model.

`subsurfaceScattering` - subsurface scattering factor, a number between 0.0 and 1.0. This property simulates the effect of light penetrating a translucent material, scattering beneath the surface, and exiting at nearby points. It is useful for rendering materials like skin, wax, marble, or milk, where light interaction is not purely superficial. Dagon's implementation is based on the Hanrahan-Krueger BRDF approximation of an isotropic BSSRD, which models light transport under the surface in a simplified, physically plausible way. Subsurface scattering affects only diffuse response.
* A value of 0.0 disables subsurface scattering, producing a fully opaque and solid look.
* A value of 1.0 represents maximum subsurface softness, with diffuse lighting appearing to come from below the surface.
Intermediate values blend between standard Lambertian diffusion and subsurface diffusion.

`opacity` - transparency multiplier for base color's alpha value, a number between 0.0 and 1.0. Affects partial transparency of a surface if `blendMode` property is set to `Transparent`. Partial transparency is supported only in forward pipeline; in deferred pipeline surface pixels can be either fully solid or fully transparent (alpha cutout). This is controlled with the `alphaTestThreshold` property.

`alphaTestThreshold` - alpha cutout threshold, a number between 0.0 and 1.0. Any `opacity` lower than this value will be treated as 0 (fully transparent) in deferred pipeline. In forward pipeline this parameter is not used.

`useFog` - if set to `true`, surface will be mixed with fog color based on distance from camera. Exact look and feel or the fog effect is largely pipeline-defined and should be programmed in a shader, but all built-in implementations in Dagon respect standard fog parameters from `Environment` object.

`useCulling` - enable backface culling.

`textureMappingMode` - what to use for sampling textures:
* `VertexUV` (0) - per-vertex UV coordinates;
* `Matcap` (1) - calculated spherical coordinates for fake reflections.

`textureTransformation` - 3x3 affine matrix that transforms mesh texture coordinates, if `textureMappingMode` is set to `VertexUV`.

`textureScale` - when using textures, this `Vector2f` define the scale of UV coordinates. This is useful to repeat a texture on surface.

`shadowFilter` - determines filter for sampling shadow maps:
* `ShadowFilterNone` (0) - don't filter shadows
* `ShadowFilterPCF` (1) - use percentage-closer filtering (soft shadows)

`colorWrite`, `depthWrite` - enable write to color buffer (or GBuffer) and depth buffer, respectively.

`outputColor`, `outputNormal`, `outputPBR`, `outputEmission` - enable writing to the corresponding render target in G-buffer.
