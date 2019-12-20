# Material
Material in Dagon is a description of entity's surface properties. Dagon implements physically based rendering (PBR) and follows roughness/metallic workflow for materials. 

## PBR
PBR a combination of rendering techniques that bring real-time graphics closer to real world by following laws of optics. PBR operates on a unified set of inputs that are completely independent from lighting, so PBR materials look consistent in any environment and are usually portable between different graphics software and game engines. 

## Properties
Materials in Dagon are heterogeneous, meaning that their properties (`MaterialInput` structs) have dynamic typing and can handle both numeric values and textures.

`diffuse` - color of a surface. This is also called albedo or base color. You can assign `Color4f` or `Texture` to it. The alpha channel defines surface transparency if `blending` property is set to `Transparent`.

`transparency` - transparency multiplier for diffuse color, `float`.

`roughness` - roughness of a surface, a number between 0.0 and 1.0. This affects blurriness of specular reflection. Materials like metal, shiny plastic or polished wood have low roughness, and materials like raw stone, concrete or cloth have high roughness. You can assign `float` or `Texture` to it (though only R channel of a texture will be used).

`metallic` - metallicity of a surface, a number between 0.0 and 1.0. This affects color of specular reflection: for metals (conductors) incoming light color is modulated by surface color, and for other materials (dielectrics) it isn't, so, for example, a red chrome covered christmas ball looks different from red plastic ball. You can assign `float` or `Texture` to it (though only R channel of a texture will be used).

`emission` - self-illumination color, `Color4f` of `Texture`.

`energy` - self-illumination brightness, `float`.

`normal` - per-pixel normal of a surface in tangent space, `Vector3f` or `Texture`.

`height` - per-pixel height of a surface, `float` or `Texture`. When using parallax mapping, it is used to displace texture coordinates and give a surface more bumpy look.

`parallax` - parallax mapping method: 
* `ParallaxNone` (0) - parallax mapping turned off
* `ParallaxSimple` (1) - simple parallax mapping based on eye vector
* `ParallaxOcclusionMapping` (2) - parallax occlusion mapping

`blending` - blending mode of a surface:
* `Opaque` (0) - opaque surface. This is set by default
* `Transparent` (1) - alpha channel of diffuse color (or texture) defines transparency. Note that transparent materials are not supported by deferred pipeline, so such objects will be rendered in forward mode with fallback shading model
* `Additive` (2) - surface is additively blended with the background. Note that additive blending is not supported by deferred pipeline, so such objects will be rendered in forward mode with fallback shading model

`fogEnabled` - if set to `true`, surface will be mixed with fog color based on distance from camera.

`culling` - enable backface culling.

`colorWrite`, `depthWrite` - enable write to color (GBuffer) and depth buffers.

`textureScale` - when using textures, this `Vector2f` define the scale of UV coordinates. This is useful to repeat a texture on surface.