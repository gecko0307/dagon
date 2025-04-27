# Tutorial 11. Exporting Assets from Blender

Since Dagon 0.12, the recommended asset format for using with Dagon is [glTF](https://www.khronos.org/gltf/), a JSON-based scene description accompanied by a binary file that stores raw data such as vertex buffers.

glTF feature support in Dagon:
* ✔️ Scenes and nodes (interpreted as `Entity` hierarchy)
* ✔️ Meshes (Dagon implements a separate mesh system for glTF models, optimized for fast loading and rendering)
* ✔️ Materials and textures (Dagon's PBR materials are directly compatible with glTF)
* ✔️ Skins and animations

To export your models to glTF, you can use [Blender](https://blender.org/). The workflow is straightforward and requires almost no specific actions. A number of compatibility issues exist:
* Dagon currently supports only `.gltf + .bin` form, `.glb` is not supported;
* Models should be in Y-Up coordinate system, with 1 unit = 1 meter;
* EEVEE-next (Blender 4.2) dropped support for alpha clipping (`"alphaMode":"MASK"` in glTF). You should add it manually in your shader using nodes as shown below.

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/blender_alpha_clipping.jpg?raw=true)

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

The model cannot be used directly in the scene because it has its own node hierarchy, and it is not always the case that the model is used by the application entirely - it is possible to use only parts of the data, such as separate entities or meshes. You can choose which entities you want to add to the scene via `useEntity`. The simplest case is to use all of them:

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
