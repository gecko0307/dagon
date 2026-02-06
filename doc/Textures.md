# Textures

A texture is a raster image used for per-pixel data sampling in shaders. Textures usually store surface properties such as color, normals, roughness, and other, which are inputs to the render pipeline. Dagon supports 1D, 2D and 3D textures and cube map textures. Textures can be decoded from compressed image formats such as PNG or JPEG, or loaded directly from container formats (DDS, KTX).

## Pixel Formats

Understanding pixel formats is crusial for dealing with textures in games. Dagon supports many pixel formats, including block-compressed ones, but each image file format supports only its own subset.

Popular uncompressed pixel formats include:
- RGBA8 – 4 channels, 8 bits per channel
- RGB8 – 3 channels, 8 bits per channel
- RG8 – 2 channels, 8 bits per channel
- R8 – 1 channel, 8 bits
- RGBA32F – 4 channels, 32-bit floating-point per channel
- RGBA16F – 4 channels, 16-bit floating-point per channel

The most GPU-efficient format for color textures is RGBA8 (4 channels, 8 bits per channel). Dagon's image loader automatically converts from input format to RGBA8, if `ConversionHint.RGBA` is specified in `TextureAsset.conversion.hint` property. For storing textures in exotic or block-compressed formats, DDS and KTX containers can be used.

Note: Dagon sets up OpenGL to use 4-byte alignment when reading pixel rows.

## HDR Textures

High dynamic range (HDR) textures store color data with a wider numeric range per channel. Typical formats are:
- RGBA16F – half-precision floating point, 16 bits per channel
- RGBA32F – full-precision floating point, 32 bits per channel

HDR textures are mainly used for storing linear color buffers, lightmaps and environment maps, intermediate render targets in post-processing pipelines. Dagon supports loading such textures from RGBE/Radiance HDR, DDS and KTX/KTX2 files.

## Texture Compression

Block-compressed formats reduce GPU memory usage and bandwidth. Dagon supports all compression formats available on desktop GPUs:
- DXT1/BC1 – color only, 4 bpp
- DXT3/BC2 – color + low-precision alpha, 8 bpp
- DXT5/BC3 – color + high-precision alpha, 8 bpp
- RGTC/BC4 – single-channel (monochrome), 4 bpp
- RGTC/BC5 – dual-channel, 8 bpp
- BPTC/BC6 – HDR color only, floating-point, 8 bpp
- BPTC/BC7 – color + high-precision alpha, 8 bpp

Compressed textures are typically loaded from DDS or KTX files.

## Cubemaps

Cubemaps are textures composed of 6 square faces, used for environment mapping and image-based lighting. Cubemaps can be constructed from individual faces or loaded directly from DDS or KTX. In the latter case it is possible to store prebaked mipmap which is useful for efficiency: no need to pre-filter the cubemap in runtime. The downside is that a high-resolution HDR cubemap with a full mipchain significantly increases the file size.

## 3D Textures

3D textures (volume textures) store voxel data with width × height × depth. Dagon supports loading 3D textures from DDS and KTX.
