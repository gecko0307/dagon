# Textures

A texture is a raster image used for per-pixel data sampling in shaders. Dagon supports 1D, 2D and 3D textures and cube map textures. Textures can be decoded from image files such as PNG or JPEG, or loaded directly from container formats (DDS, KTX).

## Pixel Formats

Understanding pixel formats is crusial for dealing with textures in games. Dagon supports many formats, including block-compressed ones, but each image file format has its own set of supported pixel formats.

Popular uncompressed pixel formats include:
- RGBA8 - 4 channels, 8 bits per channel
- RGB8 - 3 channels, 8 bits per channel
- RG8 - 2 channels, 8 bits per channel
- R8 - 1 channel, 8 bits
- RGBA32F - 4 channels, 32-bit floating-point per channel
- RGBA16F - 4 channels, 16-bit floating-point per channel

The most GPU-efficient format for color textures is RGBA8 (4 channels, 8 bits per channel). Dagon's image loader automatically converts from input format to RGBA8, if `ConversionHint.RGBA` is specified in `TextureAsset.conversion.hint` property. For storing textures in exotic formats, DDS and KTX containers can be used.

Note: Dagon sets up OpenGL to use 4-byte alignment when reading pixel rows.
