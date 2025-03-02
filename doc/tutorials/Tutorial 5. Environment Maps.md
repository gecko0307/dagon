# Tutorial 5. Environment Maps

HDR environment maps are essential for realistic rendering. In Dagon, they are also easy to use:
```d
TextureAsset aTexEnvmap;

override void beforeLoad()
{  
    aTexEnvmap = addTextureAsset("data/envmap.hdr");

    // Other stuff...
}

override void afterLoad()
{
    environment.ambientMap = aTexEnvmap.texture;

    // Other stuff...
}
```
This code seamlessly supports both equirectangular environment maps and DDS cubemaps. However, conversion from an equirectangular map is not done automatically, so the engine will use different sampling method for each format and the resulting picture may look different.

For this tutorial I've used an equirectangular environment map in Radiance RGBE (HDR) format:

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/envmap.jpg?raw=true)

To actually see the map at the background, you should create a sky:
```d
auto eSky = addEntity();
eSky.layer = EntityLayer.Background;
auto psync = New!PositionSync(eventManager, eSky, camera);
eSky.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
eSky.scaling = Vector3f(100.0f, 100.0f, 100.0f);
eSky.material = addMaterial();
eSky.material.depthWrite = false;
eSky.material.culling = false;
eSky.material.baseColorTexture = aTexEnvmap.texture;
```

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial5.jpg?raw=true)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial5)
