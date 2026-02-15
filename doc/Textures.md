# Textures

A texture is a raster image used for per-pixel data sampling in shaders. Textures usually store surface properties such as color, normals, roughness, and other, which are inputs to the render pipeline. Dagon supports 1D, 2D and 3D textures and cube map textures. Textures can be decoded from compressed image formats such as PNG or JPEG, or loaded directly from container formats (DDS, KTX).

## Image File Formats

Dagon supports all popular image formats via SDL_Image, libktx and built-in decoders:
- **PNG** - lossless format, best for data exchange between different software
- **JPEG** - lossy compression, best for large static images such as UI backgrounds and splash screens
- **BMP** - standard lossless format on Windows, used by some old image editors
- **TGA** - legacy lossless format originated in early graphics cards for IBM-PC, used by some old image editors
- **WebP** - modern image format that supports both lossy and lossless compression, offers better quality-to-size ratio than JPEG and PNG
- **TIFF** - flexible image container, supports lossless compression and high bit depths, commonly used in professional imaging
- **JPEG XL** - next-generation image format designed to replace JPEG, supports lossless and high-quality lossy compression with HDR and wide color gamut support
- **AVIF** - modern highly efficient image format based on AV1 codec, provides excellent compression efficiency and HDR support
- **HDR** (Radiance RGBE) - high dynamic range image format, commonly used for storing equirectangular environment maps
- **DDS** (DirectDraw Surface) - texture container, typically stores GPU-ready compressed textures (BCn), optimized for fast loading
- **KTX** (Khronos Texture) - texture container, modern alternative to DDS
- **KTX2** (Khronos Texture 2.0) - advanced KTX version with support for Basis Universal supercompression, designed for efficient cross-platform compressed texture delivery
- **SVG** - standard vector image format, mainly used for UI icons and scalable graphics
- **ICO** - Windows icon format
- **GIF** - legacy indexed-color format, mostly used for small animated images. Dagon doesn't support GIF animation
- **QOI** - extremely fast lossless image format optimized for rapid decoding with minimal overhead
- **XCF** - native GIMP project format, supports layers and high bit depths, useful for asset pipelines
- **PNM** - a family of simple uncompressed image formats (PBM/PGM/PPM), mainly used for testing and data interchange
- **XPM** - text-based image format originally designed for X Window System, occasionally used for icons
- **PCX** - legacy format from early PC graphics software, now mostly obsolete
- **LBM** (InterLeaved BitMap) - bitmap format originating from Amiga systems, rarely used today.

Not all features supported by each format are available to Dagon applications. Dagon's texture system is not an image editor backend, it was mainly designed as a lightweight and efficient intermediary for decoding and uploading images to VRAM, not manipulating them. For example, Dagon doesn't support:
- Animated images (frame-by-frame animation is usually implemented by offsetting texture coordinates on a spritesheet which is independent of image format)
- Multi-layered images
- In-memory indexed formats (all images are usually converted to RGBA8)
- Vector images (SVG images are rasterized)
- Embedded color profiles (all data is treated as either sRGB or linear, depending on usage context)
- EXIF metadata.

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

## sRGB vs Linear Color

Dagon primarily works with two color spaces:

* **Linear RGB**: a color space which values are proportional to actual physical light intensity.
* **sRGB**: a gamma-encoded color space for display output. Dagon performs color space conversions automatically where required.

Base color (diffuse) textures are always treated as sRGB images. Non-color raster data (such as normal maps and roughness/metallic maps) is always treated as linear.

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
