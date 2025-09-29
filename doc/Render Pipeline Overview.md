# Render Pipeline Overview

This is a brief description of Dagon's graphics tech.

### Pipeline

Render pipeline is a heart of any 3D visualization. Pipeline describes the sequence of operations for transforming 3D data into a 2D image displayed on a screen. It is typically divided into several conceptual stages, involving both CPU and GPU processing. In Dagon, "pipeline" term refers to `dagon.render.pipeline.Pipeline` class, an abstraction that manages a sequence of `RenderPass` objects. A pass binds a render target, a shader with corresponding parameters, prepares a `GraphicsState` structure and finally makes a series of draw calls for a certain subset of entities in the scene.

Dagon features a hybrid renderer that combines both deferred (see below) and forward pipelines. There is also an alternative simple renderer for NPR, retro and casual-styled graphics.

### Deferred Rendering

Deferred rendering is one of the two major techniques in rasterization. It breaks rendering into two main phases - geometry pass and light pass. First all visible geometry is rasterized into a set of fragment attribute buffers (often collectively called a G-buffer), which include depth buffer, normal buffer, color buffer, etc. Then a desired number of light volumes are rasterized into a final radiance buffer. A light shader calculates radiance for a given fragment based on light's properties and G-buffer values corresponding to that fragment. 

Deferred rendering has the following advantages over forward rendering:
* No hardcoded limit on light number. Usually the number of lights is limited only by GPU fillrate, not some fixed maximum.
* No hardcoded limit on light model variety. Forward rendering can handle only strictly limited set of predefined light models - usually point, spot and directional. With deferred, you can implement custom lights in addition to these. Adding a new light model is a matter of writing a new light volume shader.
* No redundant GPU work. Classic forward renderer (without depth prepass) does full radiance calculation for every fragment, no matter if it will be discarded by depth test afterwards. Deferred renderer, by its nature, calculates radiance only for final visible fragments. For complex scenes this can matter at lot.
* Smaller and thus faster shaders. With forward renderer you usually end up writing big, branched 'ubershaders' that handle every possible lighting scenario. In deferred, all functionality is decomposed to separate smaller passes. However, deferred pipeline requires more framebuffer switches.
* G-buffer can be used not only for computing radiance, but also for post-processing, most notably screen-space effects (SSAO, SSLR). In forward renderer this is not possible without depth and normal prepass.

There are some disadvantages as well:
* Higher VRAM and memory bandwidth requirements. This actually matters only for mobile platforms and less of an issue on desktop.
* No simple way of handling transparency. We can't simply blend a fragment to G-buffer over existing data because then the resulting attributes will be meaningless. Transparent objects are usually discarded at the geometry pass and rendered in forward mode as a final step after the light pass. This means that they can't be lit with deferred light volumes and should be handled with some fallback lighting technique.
* Less material variety. In classic deferred renderer BRDF is defined by light volume shaders, so we can have different BRDFs per light, but not per material. This limitation is less critical if a renderer uses PBR principles (albedo, roughness and metallic maps, microfacet BRDF, image-based lighting, etc.). PBR, which is de-facto standard way of defining materials nowadays, allows greater variety of common materials, such as colored metals, shiny and rough dielectrics, and any combinations of them on the same surface. PBR extension of a deferred renderer comes at additional VRAM cost, but the outcome is very good. Again, objects with custom BRDFs (which you actually don't have too much in typical situations) can be rendered in forward mode.
* Deferred shading is incompatible with MSAA. Common workaround is to use post-process antialiasing (FXAA, TAA, SMAA).

### Area Lights

Area lights provide more realistic and physically correct approximation of real-world lights than traditional point light sources. An area light is a polygonal or volumetric shape that emits light from its surface. Such lights are useful to represent ball lamps, fluorescent tubes, LED panels, etc.

Dagon supports spherical and tube area lights. Spherical area lights can be seen as direct generalization of point lights. They have a position and a radius. For a given point on a surface, instead of a vector to the center of the light, a vector to the closest point on a sphere is used to evaluate BRDF. Then the lighting is computed as usual using preferred BRDF such as GGX. Tube area lights are basically the same, but have also a length.

Dagon's deferred renderer treats all point lights as area lights - if the light has zero radius and length, it becomes classic point light.

### Cascaded shadow maps

Cascaded shadow maps are the most popular technique to render plausible quality shadows for a parallel light source at any distance from the viewer. Several shadow maps (cascades) are used with different projection sizes. First cascade covers a relatively small area in front of the viewer, so nearest shadows have the best quality. Next cascade cover larger area and hence is less detailed, and so on. Key point is that distant shadows occupy much less space on screen so that aliasing artifacts become negligible. The result is a smooth decrease of shadow detalization as the distance increases.

Dagon uses 3 cascades placed in order of increasing distance from the camera. Because cascades have the same resolution, Dagon passes them in one texture unit as an array texture of `sampler2DArrayShadow` sampler type. To access it in GLSL via `texture` function, you should use 4-vector XYZW where XY are texture coordinates, Z is a cascade index (0, 1 or 2), and W is a fragment depth (reference value). Look into `shadowLookup` function in standard shaders to learn how things work.

### Dual-Paraboloid Shadow Maps

Dual-paraboloid shadow maps are an optimized method for rendering and sampling shadows for omnidirectional light sources (in Dagon, these are spherical and tube area lights). Straightforward shadowing technique for such lights is a depth cube map, rendered from 6 directions around the light source. Paraboloid projection allows to use only 2 depth maps, each covering a half-space around the light source. Same projection is then used to convert eye-space coordinates to depth texture coordinates to sample the map for an arbitrary point. The trade-off is singularity artifacts at the border between half-spaces, but they are usually negligible.

### Perspective Shadow Maps

TODO

### HDR

Dagon's renderer outputs radiance into a floating-point frame buffer without clamping the values to 0..1 range, so the buffer contains greater luminance information compared to traditional integer frame buffer. The final image that is visible on screen is a result of an additional tone mapping pass, which applies a non-linear luminance compression to the incoming values. Very dark and very bright pixels are compressed more, and pixels of a medium brightness are compressed less. Dagon supports all popular tone mapping operators: Reinhard, Reinhard2, Hable, Uncharted, Unreal, Filmic, ACES, AgX, AgX_Punchy, and Khronos PBR Neutral.
