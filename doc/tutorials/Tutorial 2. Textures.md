# Tutorial 2. Textures

You'll definitely want to load some textures and apply them to materials. This is very easy. Add a `TextureAsset` to your scene:
```d
class TestScene: Scene
{
    TextureAsset aTexStoneDiffuse;

    // other stuff here...
}
```
Now load it in `beforeLoad`:
```d
override void beforeLoad()
{    
    // other stuff here...
    aTexStoneDiffuse = addTextureAsset("data/stone-diffuse.png");
}
```
Create a material and apply the texture in `afterLoad` method:
```d
auto matGround = addMaterial();
matGround.baseColorTexture = aTexStoneDiffuse.texture;
```
Now you can apply `matGround` to our plane object from previous tutorial:
```d
ePlane.material = matGround;
```
And the result should be this:

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial2.jpg?raw=true)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial2)
