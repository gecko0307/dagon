# Material
Material in Dagon is a description of entity's surface properties. Dagon implements physically based rendering (PBR) and follows roughness/metallic workflow for materials.

Materials in Dagon are heterogeneous, meaning that their properties (`MaterialInput` structs) have dynamic typing and can handle both numeric values and textures.

`diffuse` - diffuse color (albedo), `Color4f` or `Texture`. The alpha channel defines surface transparency if `blending` property is set to `Transparent`.

`transparency` - transparency multiplier for diffuse color, `float`.

`emission` - self-illumination color, `Color4f` of `Texture`.

`energy` - self-illumination brightness, `float`.

`roughness` - roughness of a surface, `float` or `Texture`. For color textures, only R channel will be used.

`metallic` - metallicity of a surface, `float` or `Texture`. For color textures, only R channel will be used.

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