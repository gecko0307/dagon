# Tutorial 6. PBR

Dagon supports physically-based rendering (PBR) - a combination of rendering techniques that bring real-time graphics closer to real world by following laws of optics. PBR operates on a unified set of inputs that are completely independent from lighting, so PBR materials look consistent in any environment and are usually portable between different graphics software and game engines. 

There are two main PBR workflows - albedo/roughness/metallic (UE4 style) and albedo/gloss/metallic (Unity style). Dagon follows UE4 style.

Materials in Dagon have the following PBR properties:

`diffuse` - color of a surface. This is also called albedo or base color. You can assign `Color4f` or `Texture` to it.

`roughness` - roughness of a surface, a number between 0.0 and 1.0. This affects blurriness of specular reflection. Materials like metal, shiny plastic or polished wood have low roughness, and materials like raw stone, concrete or cloth have high roughness. You can assign `float` or `Texture` to it (though only R channel of a texture will be used).

`metallic` - metallicity of a surface, a number between 0.0 and 1.0. This affects color of specular reflection: for metals (conductors) incoming light color is modulated by surface color, and for other materials (dielectrics) it isn't, so, for example, a red chrome covered christmas ball looks different from red plastic ball. You can assign `float` or `Texture` to it (though only R channel of a texture will be used).

For basic materials, numeric PBR parameters can be enough. For example, this is a shiny red plastic:
```d
auto mPlastic = createMaterial();
mPlastic.diffuse = Color4f(1.0, 0.2, 0.2, 1.0);
mPlastic.roughness = 0.1f;
```
Bronze-like metal:
```d
auto mMetal = createMaterial();
mMetal.diffuse = Color4f(1.0, 0.5, 0.1, 1.0);
mMetal.roughness = 0.1f;
mMetal.metallic = 1.0f;
```

![]( https://www.dropbox.com/s/lkgrb1it7913ce6/materials.png?raw=1)

A lot more interesting effects can be achieved with texture-based parameters. Here is a setup for Andrew Maximov's famous Cerberus model:
```d
auto mCerberus = createMaterial();
mCerberus.diffuse = aTexCerberusAlbedo.texture;
mCerberus.roughness = aTexCerberusRoughness.texture;
mCerberus.metallic = aTexCerberusMetallic.texture;
mCerberus.normal = aTexCerberusNormal.texture;
```

![](https://www.dropbox.com/s/7o4wkx1n4lzg1kq/cerberus.jpg?raw=1)
