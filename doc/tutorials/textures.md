# Tutorial 2. Textures

You'll definitely want to load some textures and apply them to materials. This is very easy. Add a `TextureAsset` to your scene:
```d
class TestScene: Scene
{
    // other stuff here...
    TextureAsset aTexGrass;
    // other stuff here...
}
```
Now load it in `onAssetsRequest`:
```d
override void onAssetsRequest()
{    
    // other stuff here...
    aTexGrass = addTextureAsset("data/grass.png");
}
```
Create a material and apply the texture:
```d
auto matGround = createMaterial();
matGround.diffuse = aTexGrass.texture;
```
Yes, in Dagon you can assign both colors and textures to material parameters!

Now you can apply `matGround` to our plane object from previous tutorial:
```d
ePlane.material = matGround;
```
And the result should be this:

![](https://www.dropbox.com/s/y8u31u7omfm5qax/texture.jpg?raw=1)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial2)