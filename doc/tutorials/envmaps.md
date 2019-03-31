# Tutorial 5. Environment Maps

HDR environment maps are essential for realistic rendering. In Dagon, they are also easy to use:
```d
TextureAsset aTexEnvmap;

override void onAssetsRequest()
{  
    aTexEnvmap = addTextureAsset("data/envmap.hdr");

    // Other stuff...
}

override void onAllocate()
{
    super.onAllocate();
        
    environment.environmentMap = aTexEnvmap.texture;
    environment.skyMap = aTexEnvmap.texture;

    // Other stuff...
}
```
This code assumes `data/envmap.hdr` is an equirectangular environment map in Radiance RGBE (HDR) format.

![](https://www.dropbox.com/s/i7k9mzdllyva3qh/envmap.jpg?raw=1)

To actually see the map at the background, you should create a sky:
```d
auto eSky = createSky();
```
![](https://www.dropbox.com/s/i4366d7owda1abp/hdr.jpg?raw=1)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial5)