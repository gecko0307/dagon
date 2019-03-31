This is a brief description of Dagon's graphics tech.

Deferred Rendering
------------------
Deferred rendering is one of the two major techniques in rasterization. It breaks rendering into two main phases - geometry pass and light pass. First all geometry is rasterized into a set of fragment attribute buffers (often collectively called a G-buffer), which include position buffer, normal buffer, color buffer, etc. Then a desired number of light volumes are rasterized into a final radiance buffer. A light shader calculates radiance for a given fragment based on light's properties and G-buffer values corresponding to that fragment. 

Deferred rendering has the following advantages over forward rendering:
* No hardcoded limit on light number. Usually the number of lights is limited only by GPU fillrate, not some fixed maximum.
* No hardcoded limit on light model variety. Forward rendering can handle only strictly limited set of predefined light models - usually point, spot and directional. With deferred, you can implement custom lights in addition to these. Adding a new light model is a matter of writing a new light volume shader.
* No redundant GPU work. Classic forward renderer (without depth prepass) does full radiance calculation for every fragment, no matter if it will be discarded by depth test afterwards. Deferred renderer, by its nature, calculates radiance only for final visible fragments. For complex scenes this can matter at lot.
* Smaller and thus faster shaders. With forward renderer you usually end up writing big, branched 'ubershaders' that handle every possible lighting scenario. In deferred, all functionality is decomposed to separate cache-friendly passes.
* G-buffer can be used not only for computing radiance, but also for post-processing, most notably screen-space effects (SSAO, SSLR). In forward renderer this is not possible without depth and normal prepass.

There are some disadvantages as well:
* Higher VRAM and memory bandwidth requirements. This actually matters only for mobile platforms and less of an issue on desktop.
* No simple way of handling transparency. We can't simply blend a fragment to G-buffer over existing data because then the resulting attributes will be meaningless. Transparent objects are usually discarded at the geometry pass and rendered in forward mode as a final step after the light pass. This means that they can't be lit with deferred light volumes and should be handled with some fallback lighting technique.
* Less material variety. In classic deferred renderer BRDF is defined by light volume shaders, so we can have different BRDFs per light, but not per material. This limitation is less critical if a renderer uses PBR principles (albedo, roughness and metallic maps, microfacet BRDF, image-based lighting, etc.). PBR, which is de-facto standard way of defining materials nowadays, allows greater variety of common materials, such as colored metals, shiny and rough dielectrics, and any combinations of them on the same surface. PBR extension of a deferred renderer comes at additional VRAM cost, but the outcome is very good. Again, objects with custom BRDFs (which you actually don't have too much in typical situations) can be rendered in forward mode.

Area Lights
-----------
Area lights are an interesting topic that is given much attention recently. They provide more realistic and physically correct approximation of real-world lights than traditional point light sources. An area light is a polygonal or volumetric shape that emits light from its surface. Such lights are useful to represent ball lamps, fluorescent tubes, LED panels, etc.

Dagon supports spherical and tube area lights. Spherical area lights can be seen as direct generalization of point lights. They have a position and a radius. For a given point on a surface, instead of a vector to the center of the light, a vector to the closest point on a sphere is used to evaluate BRDF. Then the lighting is computed as usual using standard Blinn-Phong and Lambert models. Tube area lights are basically the same, but have also a length.

Dagon's deferred renderer treats all point lights as area lights - if the light has zero radius and length, it becomes classic point light.

Cascaded shadow maps
--------------------
Cascaded shadow maps are the most popular technique to render plausible quality shadows at any distance from the viewer. Several shadow maps (cascades) are used with different projection sizes. First cascade covers a relatively small area in front of the viewer, so nearest shadows have the best quality. Next cascade cover larger area and hence is less detailed, and so on. Key point is that distant shadows occupy much less space on screen so that aliasing artifacts become negligible. The result is a smooth decrease of shadow detalization as the distance increases.

Dagon uses 3 cascades placed in order of increasing distance from the camera. Because cascades have the same resolution, Dagon passes them in one texture unit as an array texture of `sampler2DArrayShadow` sampler type. To access it in GLSL via `texture` function, you should use 4-vector XYZW where XY are texture coordinates, Z is a cascade index (0, 1 or 2), and W is a fragment depth (reference value). Look into `shadowLookup` function in standard shaders to learn how things work.

HDR
---
Dagon's renderer outputs radiance into a floating-point frame buffer without clamping the values to 0..1 range, so the buffer contains greater luminance information compared to traditional integer frame buffer. The final image that is visible on screen is a result of an additional tone mapping pass, which applies a non-linear luminance compression to the incoming values. Very dark and very bright pixels are compressed more, and pixels of a medium prightness are compressed less. There are three tone mapping functions supported by Dagon: Reinhard, Hable (Uncharted) and ACES.