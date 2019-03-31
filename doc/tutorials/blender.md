# Tutorial 11. Exporting Assets from Blender

Although most games usually utulize their own asset formats, specifically designed to fullfill their needs, Dagon provides a simple native solution for exporting game resources from 3D modeling software - an asset package. It is a file with *.asset extension. You can find its format specification [[here|Asset Package Format]]. 

Asset packages contains entities, meshes, materials and textures. Currently they are somewhat limited and don't support all features of Dagon (like actors, behaviours, controllers, particles, custom shaders, etc.), so they are suitable only for simple games, but the format will be extended in future. The plan is to support metadata with user-defined semantics, that will allow storing game-specific information.

We provide a reference [asset exporter for Blender 2.70+](https://github.com/gecko0307/dagon/blob/master/tools/io_export_dagon_asset.py). After you enable the addon, your objects and materials will get new properties specific to Dagon - they are the same properties that you can set programmatically in D. These properties will be saved to *.blend file, so you don't have to redefine them each time.

Add some meshes to your scene, unwrap them (meshes without an UV map will render incorrectly, and Dagon will print a warning about them), add materials if you wish and export the scene to an *.asset file using usual export menu. The addon will also create a folder with all exported data so that you can easily examine an asset file contents if something doesn't work as you expected. This folder is not necessary for a Dagon application, so you can delete it.

Now put the asset file somewhere your game can access it and add the following to your scene class:
```d
PackageAsset myAsset;

override void onAssetsRequest()
{
    myAsset = addPackageAsset("data/scene.asset");
}
```
Now you can access the asset using `entity` property of `myAsset`. It returns a root entity of the asset package - that is, an entity that is a parent for all root level objects in the Blender scene. You can use root entity as a drawable object for other entities:
```d
Entity myAssetInstance = createEntity3D();
myAssetInstance.drawable = myAsset.entity;
```
This is a neat way to have multiple instances of the same asset. If the asset is meant to be used directly (like a level geometry), it would be better to just append its root entity to the scene:
```d
addEntity3D(myAsset.entity);
```
You can get any entity from your asset by its file name with overloaded `entity` function. The same is true for meshes, materials, and textures:
```d
Entity myEntity = myAsset.entity("myEntity.entity");
Mesh myMesh = myAsset.mesh("myMesh.obj");
GenericMaterial myMaterial = myAsset.material("myMaterial.obj");
Texture myTexture = myAsset.texture("myTexture.obj");
```
They are ready for reuse and behave the same as explicitly created objects. You don't have to worry about managing asset resources, as they are fully controlled by an asset manager and properly released on scene end.