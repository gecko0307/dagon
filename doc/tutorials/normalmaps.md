# Tutorial 3. Normal maps

Normal mapping nowadays is a standard technique that is used by everyone. You can easily add it to your Dagon game by defining `normal` property of a material:
```d
matGround.normal = aTexStoneNormal.texture;
```
![](https://www.dropbox.com/s/mgu32rcl4qwcxjs/normalmap.jpg?raw=1)

Dagon also supports parallax mapping. It requires a height map:
```d
mGround.height = aTexStoneHeight.texture;
mGround.parallax = ParallaxSimple;
```
![](https://www.dropbox.com/s/fn0amtqqduyabpb/parallax.jpg?raw=1)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial3)