# Tutorial 3. Normal Maps

Normal mapping nowadays is a standard technique that is used by everyone. You can easily add it to your Dagon game by setting `normalTexture` of a material:
```d
matGround.normalTexture = aTexStoneNormal.texture;
```

Dagon also supports parallax mapping. It requires a height map:
```d
mGround.heightTexture = aTexStoneHeight.texture;
mGround.parallaxMode = ParallaxSimple;
```

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial3.jpg?raw=true)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial3)
