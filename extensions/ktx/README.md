# dagon:ktx

[KTX](https://www.khronos.org/ktx/) format support via [libktx](https://github.com/KhronosGroup/KTX-Software).

## Usage

```d
import dagon;
import dagon.ext.ktx;

class MyScene: Scene
{
    TextureAsset aTexture;
    
    this(Game game)
    {
        super(game);
        registerKTXLoader(assetManager);
    }
    
    override void beforeLoad()
    {
        aTexture = addTextureAsset("data/texture.ktx2");
        aTexture.loaderOption = TranscodePriority.Quality;
    }
}
```

`TranscodePriority` is used to specify texture compression preference for transcoding Basis Universal textures:
- `TranscodePriority.Quality` (default value of `TextureAsset.loaderOption`) - prefer [BPTC](_Texture_Compression) if available, otherwise fall back to [S3TC](https://www.khronos.org/opengl/wiki/S3_Texture_Compression);
- `TranscodePriority.Size` - always prefer [S3TC](https://www.khronos.org/opengl/wiki/S3_Texture_Compression);
- `TranscodePriority.Uncompressed` - disables hardware compression, texture is decoded to RGBA32.

R and RG textures are always transcoded to [RGTC](https://www.khronos.org/opengl/wiki/Red_Green_Texture_Compression), except in `TranscodePriority.Uncompressed` mode.
