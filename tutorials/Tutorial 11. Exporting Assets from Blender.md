# Tutorial 11. Exporting Assets from Blender

Since Dagon 0.12, the recommended asset format for using with Dagon is [glTF](https://www.khronos.org/gltf/), a JSON-based scene description accompanied by a binary file that stores raw data such as vertex buffers.

glTF feature support in Dagon:
* ✔️ Scenes and nodes
* ✔️ Meshes (Dagon implements a separate mesh system for glTF models, optimized for fast loading and rendering)
* ✔️ Materials and textures (Dagon's PBR materials are directly compatible with glTF)
* ✔️ Skinning
* ❌ Morph-target animation

To export your models to glTF, you can use [Blender](https://blender.org/). The workflow is straightforward and requires almost no specific actions. A number of compatibility issues exist:
* Dagon currently supports only `.gltf + .bin` form, `.glb` is not supported;
* Models should be in Y-Up coordinate system, with 1 unit = 1 meter;
* EEVEE-next (Blender 4.2) dropped support for alpha clipping (`"alphaMode":"MASK"` in glTF). You should add it manually in your shader using nodes as shown below.

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/blender_alpha_clipping.jpg?raw=true)

## Loading

On the application side, a model is loaded via `GLTFAsset` object:

```d
class Mycene: Scene
{
    GLTFAsset model;

    override void beforeLoad()
    {
        model = addGLTFAsset("assets/model.gltf");
    }
}
```

glTF models in Dagon are stored in a data structure separate from the usual scene, using `GLTFNode` objects instead of `Entity` objects. However, each `GLTFNode` has an `Entity` associated with it. It is not always the case that the model is used by the application entirely - it is possible to use only parts of the data, such as separate entities or meshes. You can choose which entities you want to add to the scene via `useEntity`. The simplest case is to use all of them:

```d
    override void afterLoad()
    {
        model.markTransparentEntities();
        useEntity(model.rootEntity);
        foreach(node; model.nodes)
        {
            useEntity(node.entity);
        }
    }
```

`markTransparentEntities` method is necessary in cases when glTF objects use alpha-blended materials, because in this scenario the engine must know which entities should be drawn in forward mode. This is not needed when all materials are opaque or alpha-clipped.

`rootEntity` represents the scene as a whole. `GLTFAsset` also provides all the data from glTF scene description in correspondings properties:

* `JSONDocument doc` - parsed JSON
* `Array!GLTFBuffer buffers` - array of buffers
* `Array!GLTFBufferView bufferViews` - array of buffer views
* `Array!GLTFAccessor accessors` - array of accessors
* `Array!GLTFMesh meshes` - array of meshes. `GLTFMesh` is `Drawable` and can be used with ordinary entities
* `Array!TextureAsset images` - array of images (represented as `TextureAsset` objects)
* `Array!Texture textures` - array of textures (ordinary Dagon textures)
* `Array!Material materials` - array of materials (ordinary Dagon materials)
* `Array!GLTFNode nodes` - array of scene nodes. Each node holds an `Entity`
* `Array!GLTFSkin skins` - array of skins (WIP) 
* `Array!GLTFScene scenes` - array of scenes. A scene is just a collection of nodes
* `GLTFScene scene(string name)` - get a scene by name
* `Material material(string name)` - get a material by name
* `GLTFMesh mesh(string name)` - get a mesh by name
* `GLTFNode node(string name)` - get a node by name
* `GLTFSkin skin(string name)` - get a skin by name
* `GLTFAnimation animation(string name)` - get an animation by name

## Animation

If the model contains skins and animation, they are not applied autimatically and require some ground work:

```d
auto charNode = model.node("character");
charPose = New!GLTFPose(charNode.skin, assetManager);
charPose.animation = model.animation("walk");

Entity character = charNode.entity;
character.pose = charPose;
charPose.play();
```

You can attach any entities to the glTF skeleton bones. This is done simply by making attached entity a child of a bone entity:

```d
Entity weapon = addEntity(model.node("arm_right").entity);
weapon.drawable = someWeaponMesh;
```

This will work only if entire hierarchy of the skeleton is added to the scene with `useEntity` method as shown above.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t11-gltf)
