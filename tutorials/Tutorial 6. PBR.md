# Tutorial 6. PBR

Dagon supports physically-based rendering (PBR) - a combination of rendering techniques that bring real-time graphics closer to real world by following laws of optics. PBR operates on a unified set of inputs that are completely independent from lighting, so PBR materials look consistent in any environment and are usually portable between different graphics software and game engines. 

There are two main PBR workflows - metallic and specular. Dagon implements metallic workflow.

Materials in Dagon have the following PBR properties:

`baseColorFactor` and `baseColorTexture` - color of a surface. This is also called albedo.

`roughnessFactor` and G channel of `roughnessMetallicTexture` - roughness of a surface, a number between 0.0 and 1.0. This affects blurriness of specular reflection. Materials like metal, shiny plastic or polished wood have low roughness, and materials like raw stone, concrete or cloth have high roughness.

`metallicFactor` and B channel of `roughnessMetallicTexture` - metallicity of a surface, a number between 0.0 and 1.0. This affects color of specular reflection: for metals (conductors) incoming light color is modulated by surface color, and for other materials (dielectrics) it isn't, so, for example, a red chrome covered christmas ball looks different from red plastic ball. 

For basic materials, numeric PBR parameters can be enough. For example, this is a shiny red plastic:
```d
auto mPlastic = addMaterial();
mPlastic.baseColorFactor = Color4f(1.0, 0.2, 0.2, 1.0);
mPlastic.roughnessFactor = 0.1f;
```
Bronze-like metal:
```d
auto mMetal = addMaterial();
mMetal.baseColorFactor = Color4f(1.0, 0.5, 0.1, 1.0);
mMetal.roughnessFactor = 0.1f;
mMetal.metallicFactor = 1.0f;
```

Simple glass with Fresnel reflection:
```d
auto mGlass = addMaterial();
mGlass.baseColorFactor = Color4f(1.0, 1.0, 1.0, 1.0);
mGlass.roughnessFactor = 0.0f;
mGlass.metallicFactor = 1.0f;
mGlass.blendMode = Transparent;
mGlass.opacity = 0.0f;
```

A lot more interesting effects can be achieved with texture-based parameters. Here is a setup for Damaged Helmet model by [theblueturtle_](https://sketchfab.com/theblueturtle_) which also demonstrates combining separate roughness and metallic textures into one:
```d
auto mHelmet = addMaterial();
mHelmet.baseColorTexture = aTexHelmetAlbedo.texture;
Texture roughnessMetallicTexture = New!Texture(assetManager);
roughnessMetallicTexture.createBlank(1024, 1024, 4, 8, false);
combineTextures([
    null, 
    aTexHelmetRoughness.texture, 
    aTexHelmetMetallic.texture, 
    null
], roughnessMetallicTexture);
roughnessMetallicTexture.generateMipmap();
mHelmet.roughnessMetallicTexture = roughnessMetallicTexture;
mHelmet.normalTexture = aTexHelmetNormal.texture;
mHelmet.emissionTexture = aTexHelmetEmission.texture;
```

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial6.jpg?raw=true)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t6-pbr)
