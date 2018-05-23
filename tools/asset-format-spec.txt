Dagon Asset File Format
-----------------------
Although most games usually utulize their own asset formats, specifically designed to fullfill their needs, Dagon provides a simple native solution for storing game resources. This is *.asset file format.

An asset file is basically a Box container - a simple uncompressed archive. You can read more about Box format [here](https://github.com/gecko0307/box). Inside this file there is a mandatory index file and an optional set of asset files - such as meshes, entities, materials and textures.

Index file (INDEX)
------------------
This is a file named `INDEX` in the root level of a Box directory structure. It is a text file which contains a list of all entity files that should be automatically loaded by Dagon from this asset file. For example:
```
Cube.entity
someFolder/Sphere.entity
```

Mesh file (*.obj)
-----------------
A mesh file should be a plain OBJ model.

Texture file (image)
--------------------
This can be PNG, JPG, BMP, TGA, or HDR.

Progressive JPEGs are not supported by Dagon.

It is recommended to use 24-bit RGB or RGBA images. 

The engine assumes all color data is in standard 2.2 gamma encoding and converts it to linear space. Non-color data such as normal and height maps are not converted.

Entity file (*.entity)
----------------------
A text file that defines 3D entity and its properties. Properties are a set of key-value pairs:
```
name: "Suzanne";
position: [0.0, 1.0, 0.0];
rotation: [0.0, 0.0, 0.0, 1.0];
scale: [1.0, 1.0, 1.0];
parent: "Parent.entity";
mesh: "Suzanne.obj";
material: "Material.mat";
visible: 1;
castShadow: 1;
useMotionBlur: 1;
solid: 1;
layer: 1;
```
All properties are optional. The order of properties is irrelevant.

Position and scale are defined in standard euclidean XYZ space where Y-axis points upward and Z-axis points forward. Unit is meter.

Rotation is a quaternion defined as XYZW vector.

Mesh, material and entity filenames always point to files in the same asset file, relative to the root level.

Material file (*.mat)
---------------------
A text file that defines a material and its properties. It has the same syntax as entity file. Possible properties are the same as `GenericMaterial` properties in Dagon's native API:
```
name: "Material";
diffuse: "stone.png";
roughness: 0.5;
metallic: 0.0;
emission: "emit.png";
energy: 1.0;
normal: "normalmap.png";
height: "heightmap.png";
parallax: 1;
parallaxScale: 0.03;
parallaxBias: -0.01;
shadeless: 0;
transparency: 1.0;
useShadows: 1;
shadowFilter: 1;
fogEnabled: 1;
blendingMode: 0;
culling: 1;
colorWrite: 1;
depthWrite: 1;
```
All properties are optional. The order of properties is irrelevant.

Texture filenames always point to files in the same asset file, relative to the root level.

`diffuse` and `emission` properties may be a texture filename or an RGB color (floating point, gamma-corrected), for example:
```
diffuse: [1.0, 0.5, 0.0];
```
`roughness` and `metallic` properties may be floats or texture filenames (only R channel of a texture will be used):
```
roughness: "pbr_roughness.png";
metallic: "pbr_metallic.png";
```

`parallax` property has the following possible values: 0 = ParallaxNone, 1 = ParallaxSimple, 2 = ParallaxOcclusionMapping.

`shadowFilter` property has the following possible values: 0 = ShadowFilterNone, 1 = ShadowFilterPCF.

`blendingMode` property has the following possible values: 0 = Opaque, 1 = Transparent, 2 = Additive.

Exporting
---------
We provide an asset file exporter for Blender which extends Blender's materials and objects with a set of properties specific to Dagon. Standard material properties are not supported because there is no direct relation between Dagon's renderer and BI or Cycles.

