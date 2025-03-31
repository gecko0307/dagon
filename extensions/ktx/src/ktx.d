module ktx;

import std.stdio;
import std.path;
import std.algorithm;

import dlib.core.stream;
import dlib.core.memory;
import dlib.core.ownership;
import dlib.filesystem.filesystem;

import dagon.core.bindings;
import dagon.graphics.texture;
import dagon.resource.asset;
import dagon.resource.scene;

import bindbc.ktx;

enum VkFormat
{
    UNDEFINED = 0,
    R4G4_UNORM_PACK8 = 1,
    R4G4B4A4_UNORM_PACK16 = 2,
    B4G4R4A4_UNORM_PACK16 = 3,
    R5G6B5_UNORM_PACK16 = 4,
    B5G6R5_UNORM_PACK16 = 5,
    R5G5B5A1_UNORM_PACK16 = 6,
    B5G5R5A1_UNORM_PACK16 = 7,
    A1R5G5B5_UNORM_PACK16 = 8,
    R8_UNORM = 9,
    R8_SNORM = 10,
    R8_USCALED = 11,
    R8_SSCALED = 12,
    R8_UINT = 13,
    R8_SINT = 14,
    R8_SRGB = 15,
    R8G8_UNORM = 16,
    R8G8_SNORM = 17,
    R8G8_USCALED = 18,
    R8G8_SSCALED = 19,
    R8G8_UINT = 20,
    R8G8_SINT = 21,
    R8G8_SRGB = 22,
    R8G8B8_UNORM = 23,
    R8G8B8_SNORM = 24,
    R8G8B8_USCALED = 25,
    R8G8B8_SSCALED = 26,
    R8G8B8_UINT = 27,
    R8G8B8_SINT = 28,
    R8G8B8_SRGB = 29,
    B8G8R8_UNORM = 30,
    B8G8R8_SNORM = 31,
    B8G8R8_USCALED = 32,
    B8G8R8_SSCALED = 33,
    B8G8R8_UINT = 34,
    B8G8R8_SINT = 35,
    B8G8R8_SRGB = 36,
    R8G8B8A8_UNORM = 37,
    R8G8B8A8_SNORM = 38,
    R8G8B8A8_USCALED = 39,
    R8G8B8A8_SSCALED = 40,
    R8G8B8A8_UINT = 41,
    R8G8B8A8_SINT = 42,
    R8G8B8A8_SRGB = 43,
    B8G8R8A8_UNORM = 44,
    B8G8R8A8_SNORM = 45,
    B8G8R8A8_USCALED = 46,
    B8G8R8A8_SSCALED = 47,
    B8G8R8A8_UINT = 48,
    B8G8R8A8_SINT = 49,
    B8G8R8A8_SRGB = 50,
    A8B8G8R8_UNORM_PACK32 = 51,
    A8B8G8R8_SNORM_PACK32 = 52,
    A8B8G8R8_USCALED_PACK32 = 53,
    A8B8G8R8_SSCALED_PACK32 = 54,
    A8B8G8R8_UINT_PACK32 = 55,
    A8B8G8R8_SINT_PACK32 = 56,
    A8B8G8R8_SRGB_PACK32 = 57,
    A2R10G10B10_UNORM_PACK32 = 58,
    A2R10G10B10_SNORM_PACK32 = 59,
    A2R10G10B10_USCALED_PACK32 = 60,
    A2R10G10B10_SSCALED_PACK32 = 61,
    A2R10G10B10_UINT_PACK32 = 62,
    A2R10G10B10_SINT_PACK32 = 63,
    A2B10G10R10_UNORM_PACK32 = 64,
    A2B10G10R10_SNORM_PACK32 = 65,
    A2B10G10R10_USCALED_PACK32 = 66,
    A2B10G10R10_SSCALED_PACK32 = 67,
    A2B10G10R10_UINT_PACK32 = 68,
    A2B10G10R10_SINT_PACK32 = 69,
    R16_UNORM = 70,
    R16_SNORM = 71,
    R16_USCALED = 72,
    R16_SSCALED = 73,
    R16_UINT = 74,
    R16_SINT = 75,
    R16_SFLOAT = 76,
    R16G16_UNORM = 77,
    R16G16_SNORM = 78,
    R16G16_USCALED = 79,
    R16G16_SSCALED = 80,
    R16G16_UINT = 81,
    R16G16_SINT = 82,
    R16G16_SFLOAT = 83,
    R16G16B16_UNORM = 84,
    R16G16B16_SNORM = 85,
    R16G16B16_USCALED = 86,
    R16G16B16_SSCALED = 87,
    R16G16B16_UINT = 88,
    R16G16B16_SINT = 89,
    R16G16B16_SFLOAT = 90,
    R16G16B16A16_UNORM = 91,
    R16G16B16A16_SNORM = 92,
    R16G16B16A16_USCALED = 93,
    R16G16B16A16_SSCALED = 94,
    R16G16B16A16_UINT = 95,
    R16G16B16A16_SINT = 96,
    R16G16B16A16_SFLOAT = 97,
    R32_UINT = 98,
    R32_SINT = 99,
    R32_SFLOAT = 100,
    R32G32_UINT = 101,
    R32G32_SINT = 102,
    R32G32_SFLOAT = 103,
    R32G32B32_UINT = 104,
    R32G32B32_SINT = 105,
    R32G32B32_SFLOAT = 106,
    R32G32B32A32_UINT = 107,
    R32G32B32A32_SINT = 108,
    R32G32B32A32_SFLOAT = 109,
    R64_UINT = 110,
    R64_SINT = 111,
    R64_SFLOAT = 112,
    R64G64_UINT = 113,
    R64G64_SINT = 114,
    R64G64_SFLOAT = 115,
    R64G64B64_UINT = 116,
    R64G64B64_SINT = 117,
    R64G64B64_SFLOAT = 118,
    R64G64B64A64_UINT = 119,
    R64G64B64A64_SINT = 120,
    R64G64B64A64_SFLOAT = 121,
    B10G11R11_UFLOAT_PACK32 = 122,
    E5B9G9R9_UFLOAT_PACK32 = 123,
    D16_UNORM = 124,
    X8_D24_UNORM_PACK32 = 125,
    D32_SFLOAT = 126,
    S8_UINT = 127,
    D16_UNORM_S8_UINT = 128,
    D24_UNORM_S8_UINT = 129,
    D32_SFLOAT_S8_UINT = 130,
    BC1_RGB_UNORM_BLOCK = 131,
    BC1_RGB_SRGB_BLOCK = 132,
    BC1_RGBA_UNORM_BLOCK = 133,
    BC1_RGBA_SRGB_BLOCK = 134,
    BC2_UNORM_BLOCK = 135,
    BC2_SRGB_BLOCK = 136,
    BC3_UNORM_BLOCK = 137,
    BC3_SRGB_BLOCK = 138,
    BC4_UNORM_BLOCK = 139,
    BC4_SNORM_BLOCK = 140,
    BC5_UNORM_BLOCK = 141,
    BC5_SNORM_BLOCK = 142,
    BC6H_UFLOAT_BLOCK = 143,
    BC6H_SFLOAT_BLOCK = 144,
    BC7_UNORM_BLOCK = 145,
    BC7_SRGB_BLOCK = 146,
    ETC2_R8G8B8_UNORM_BLOCK = 147,
    ETC2_R8G8B8_SRGB_BLOCK = 148,
    ETC2_R8G8B8A1_UNORM_BLOCK = 149,
    ETC2_R8G8B8A1_SRGB_BLOCK = 150,
    ETC2_R8G8B8A8_UNORM_BLOCK = 151,
    ETC2_R8G8B8A8_SRGB_BLOCK = 152,
    EAC_R11_UNORM_BLOCK = 153,
    EAC_R11_SNORM_BLOCK = 154,
    EAC_R11G11_UNORM_BLOCK = 155,
    EAC_R11G11_SNORM_BLOCK = 156,
    ASTC_4x4_UNORM_BLOCK = 157,
    ASTC_4x4_SRGB_BLOCK = 158,
    ASTC_5x4_UNORM_BLOCK = 159,
    ASTC_5x4_SRGB_BLOCK = 160,
    ASTC_5x5_UNORM_BLOCK = 161,
    ASTC_5x5_SRGB_BLOCK = 162,
    ASTC_6x5_UNORM_BLOCK = 163,
    ASTC_6x5_SRGB_BLOCK = 164,
    ASTC_6x6_UNORM_BLOCK = 165,
    ASTC_6x6_SRGB_BLOCK = 166,
    ASTC_8x5_UNORM_BLOCK = 167,
    ASTC_8x5_SRGB_BLOCK = 168,
    ASTC_8x6_UNORM_BLOCK = 169,
    ASTC_8x6_SRGB_BLOCK = 170,
    ASTC_8x8_UNORM_BLOCK = 171,
    ASTC_8x8_SRGB_BLOCK = 172,
    ASTC_10x5_UNORM_BLOCK = 173,
    ASTC_10x5_SRGB_BLOCK = 174,
    ASTC_10x6_UNORM_BLOCK = 175,
    ASTC_10x6_SRGB_BLOCK = 176,
    ASTC_10x8_UNORM_BLOCK = 177,
    ASTC_10x8_SRGB_BLOCK = 178,
    ASTC_10x10_UNORM_BLOCK = 179,
    ASTC_10x10_SRGB_BLOCK = 180,
    ASTC_12x10_UNORM_BLOCK = 181,
    ASTC_12x10_SRGB_BLOCK = 182,
    ASTC_12x12_UNORM_BLOCK = 183,
    ASTC_12x12_SRGB_BLOCK = 184,
  // Provided by VK_VERSION_1_1
    G8B8G8R8_422_UNORM = 1000156000,
  // Provided by VK_VERSION_1_1
    B8G8R8G8_422_UNORM = 1000156001,
  // Provided by VK_VERSION_1_1
    G8_B8_R8_3PLANE_420_UNORM = 1000156002,
  // Provided by VK_VERSION_1_1
    G8_B8R8_2PLANE_420_UNORM = 1000156003,
  // Provided by VK_VERSION_1_1
    G8_B8_R8_3PLANE_422_UNORM = 1000156004,
  // Provided by VK_VERSION_1_1
    G8_B8R8_2PLANE_422_UNORM = 1000156005,
  // Provided by VK_VERSION_1_1
    G8_B8_R8_3PLANE_444_UNORM = 1000156006,
  // Provided by VK_VERSION_1_1
    R10X6_UNORM_PACK16 = 1000156007,
  // Provided by VK_VERSION_1_1
    R10X6G10X6_UNORM_2PACK16 = 1000156008,
  // Provided by VK_VERSION_1_1
    R10X6G10X6B10X6A10X6_UNORM_4PACK16 = 1000156009,
  // Provided by VK_VERSION_1_1
    G10X6B10X6G10X6R10X6_422_UNORM_4PACK16 = 1000156010,
  // Provided by VK_VERSION_1_1
    B10X6G10X6R10X6G10X6_422_UNORM_4PACK16 = 1000156011,
  // Provided by VK_VERSION_1_1
    G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16 = 1000156012,
  // Provided by VK_VERSION_1_1
    G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16 = 1000156013,
  // Provided by VK_VERSION_1_1
    G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16 = 1000156014,
  // Provided by VK_VERSION_1_1
    G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16 = 1000156015,
  // Provided by VK_VERSION_1_1
    G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16 = 1000156016,
  // Provided by VK_VERSION_1_1
    R12X4_UNORM_PACK16 = 1000156017,
  // Provided by VK_VERSION_1_1
    R12X4G12X4_UNORM_2PACK16 = 1000156018,
  // Provided by VK_VERSION_1_1
    R12X4G12X4B12X4A12X4_UNORM_4PACK16 = 1000156019,
  // Provided by VK_VERSION_1_1
    G12X4B12X4G12X4R12X4_422_UNORM_4PACK16 = 1000156020,
  // Provided by VK_VERSION_1_1
    B12X4G12X4R12X4G12X4_422_UNORM_4PACK16 = 1000156021,
  // Provided by VK_VERSION_1_1
    G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16 = 1000156022,
  // Provided by VK_VERSION_1_1
    G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16 = 1000156023,
  // Provided by VK_VERSION_1_1
    G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16 = 1000156024,
  // Provided by VK_VERSION_1_1
    G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16 = 1000156025,
  // Provided by VK_VERSION_1_1
    G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16 = 1000156026,
  // Provided by VK_VERSION_1_1
    G16B16G16R16_422_UNORM = 1000156027,
  // Provided by VK_VERSION_1_1
    B16G16R16G16_422_UNORM = 1000156028,
  // Provided by VK_VERSION_1_1
    G16_B16_R16_3PLANE_420_UNORM = 1000156029,
  // Provided by VK_VERSION_1_1
    G16_B16R16_2PLANE_420_UNORM = 1000156030,
  // Provided by VK_VERSION_1_1
    G16_B16_R16_3PLANE_422_UNORM = 1000156031,
  // Provided by VK_VERSION_1_1
    G16_B16R16_2PLANE_422_UNORM = 1000156032,
  // Provided by VK_VERSION_1_1
    G16_B16_R16_3PLANE_444_UNORM = 1000156033,
  // Provided by VK_VERSION_1_3
    G8_B8R8_2PLANE_444_UNORM = 1000330000,
  // Provided by VK_VERSION_1_3
    G10X6_B10X6R10X6_2PLANE_444_UNORM_3PACK16 = 1000330001,
  // Provided by VK_VERSION_1_3
    G12X4_B12X4R12X4_2PLANE_444_UNORM_3PACK16 = 1000330002,
  // Provided by VK_VERSION_1_3
    G16_B16R16_2PLANE_444_UNORM = 1000330003,
  // Provided by VK_VERSION_1_3
    A4R4G4B4_UNORM_PACK16 = 1000340000,
  // Provided by VK_VERSION_1_3
    A4B4G4R4_UNORM_PACK16 = 1000340001,
  // Provided by VK_VERSION_1_3
    ASTC_4x4_SFLOAT_BLOCK = 1000066000,
  // Provided by VK_VERSION_1_3
    ASTC_5x4_SFLOAT_BLOCK = 1000066001,
  // Provided by VK_VERSION_1_3
    ASTC_5x5_SFLOAT_BLOCK = 1000066002,
  // Provided by VK_VERSION_1_3
    ASTC_6x5_SFLOAT_BLOCK = 1000066003,
  // Provided by VK_VERSION_1_3
    ASTC_6x6_SFLOAT_BLOCK = 1000066004,
  // Provided by VK_VERSION_1_3
    ASTC_8x5_SFLOAT_BLOCK = 1000066005,
  // Provided by VK_VERSION_1_3
    ASTC_8x6_SFLOAT_BLOCK = 1000066006,
  // Provided by VK_VERSION_1_3
    ASTC_8x8_SFLOAT_BLOCK = 1000066007,
  // Provided by VK_VERSION_1_3
    ASTC_10x5_SFLOAT_BLOCK = 1000066008,
  // Provided by VK_VERSION_1_3
    ASTC_10x6_SFLOAT_BLOCK = 1000066009,
  // Provided by VK_VERSION_1_3
    ASTC_10x8_SFLOAT_BLOCK = 1000066010,
  // Provided by VK_VERSION_1_3
    ASTC_10x10_SFLOAT_BLOCK = 1000066011,
  // Provided by VK_VERSION_1_3
    ASTC_12x10_SFLOAT_BLOCK = 1000066012,
  // Provided by VK_VERSION_1_3
    ASTC_12x12_SFLOAT_BLOCK = 1000066013,
  // Provided by VK_VERSION_1_4
    A1B5G5R5_UNORM_PACK16 = 1000470000,
  // Provided by VK_VERSION_1_4
    A8_UNORM = 1000470001,
  // Provided by VK_IMG_format_pvrtc
    PVRTC1_2BPP_UNORM_BLOCK_IMG = 1000054000,
  // Provided by VK_IMG_format_pvrtc
    PVRTC1_4BPP_UNORM_BLOCK_IMG = 1000054001,
  // Provided by VK_IMG_format_pvrtc
    PVRTC2_2BPP_UNORM_BLOCK_IMG = 1000054002,
  // Provided by VK_IMG_format_pvrtc
    PVRTC2_4BPP_UNORM_BLOCK_IMG = 1000054003,
  // Provided by VK_IMG_format_pvrtc
    PVRTC1_2BPP_SRGB_BLOCK_IMG = 1000054004,
  // Provided by VK_IMG_format_pvrtc
    PVRTC1_4BPP_SRGB_BLOCK_IMG = 1000054005,
  // Provided by VK_IMG_format_pvrtc
    PVRTC2_2BPP_SRGB_BLOCK_IMG = 1000054006,
  // Provided by VK_IMG_format_pvrtc
    PVRTC2_4BPP_SRGB_BLOCK_IMG = 1000054007,
  // Provided by VK_NV_optical_flow
    R16G16_SFIXED5_NV = 1000464000,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_4x4_SFLOAT_BLOCK_EXT = ASTC_4x4_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_5x4_SFLOAT_BLOCK_EXT = ASTC_5x4_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_5x5_SFLOAT_BLOCK_EXT = ASTC_5x5_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_6x5_SFLOAT_BLOCK_EXT = ASTC_6x5_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_6x6_SFLOAT_BLOCK_EXT = ASTC_6x6_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_8x5_SFLOAT_BLOCK_EXT = ASTC_8x5_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_8x6_SFLOAT_BLOCK_EXT = ASTC_8x6_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_8x8_SFLOAT_BLOCK_EXT = ASTC_8x8_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_10x5_SFLOAT_BLOCK_EXT = ASTC_10x5_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_10x6_SFLOAT_BLOCK_EXT = ASTC_10x6_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_10x8_SFLOAT_BLOCK_EXT = ASTC_10x8_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_10x10_SFLOAT_BLOCK_EXT = ASTC_10x10_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_12x10_SFLOAT_BLOCK_EXT = ASTC_12x10_SFLOAT_BLOCK,
  // Provided by VK_EXT_texture_compression_astc_hdr
    ASTC_12x12_SFLOAT_BLOCK_EXT = ASTC_12x12_SFLOAT_BLOCK,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8B8G8R8_422_UNORM_KHR = G8B8G8R8_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    B8G8R8G8_422_UNORM_KHR = B8G8R8G8_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8_B8_R8_3PLANE_420_UNORM_KHR = G8_B8_R8_3PLANE_420_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8_B8R8_2PLANE_420_UNORM_KHR = G8_B8R8_2PLANE_420_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8_B8_R8_3PLANE_422_UNORM_KHR = G8_B8_R8_3PLANE_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8_B8R8_2PLANE_422_UNORM_KHR = G8_B8R8_2PLANE_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G8_B8_R8_3PLANE_444_UNORM_KHR = G8_B8_R8_3PLANE_444_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R10X6_UNORM_PACK16_KHR = R10X6_UNORM_PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R10X6G10X6_UNORM_2PACK16_KHR = R10X6G10X6_UNORM_2PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR = R10X6G10X6B10X6A10X6_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR = G10X6B10X6G10X6R10X6_422_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR = B10X6G10X6R10X6G10X6_422_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR = G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR = G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR = G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR = G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR = G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R12X4_UNORM_PACK16_KHR = R12X4_UNORM_PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R12X4G12X4_UNORM_2PACK16_KHR = R12X4G12X4_UNORM_2PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR = R12X4G12X4B12X4A12X4_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR = G12X4B12X4G12X4R12X4_422_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR = B12X4G12X4R12X4G12X4_422_UNORM_4PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR = G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR = G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR = G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR = G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR = G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16B16G16R16_422_UNORM_KHR = G16B16G16R16_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    B16G16R16G16_422_UNORM_KHR = B16G16R16G16_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16_B16_R16_3PLANE_420_UNORM_KHR = G16_B16_R16_3PLANE_420_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16_B16R16_2PLANE_420_UNORM_KHR = G16_B16R16_2PLANE_420_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16_B16_R16_3PLANE_422_UNORM_KHR = G16_B16_R16_3PLANE_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16_B16R16_2PLANE_422_UNORM_KHR = G16_B16R16_2PLANE_422_UNORM,
  // Provided by VK_KHR_sampler_ycbcr_conversion
    G16_B16_R16_3PLANE_444_UNORM_KHR = G16_B16_R16_3PLANE_444_UNORM,
  // Provided by VK_EXT_ycbcr_2plane_444_formats
    G8_B8R8_2PLANE_444_UNORM_EXT = G8_B8R8_2PLANE_444_UNORM,
  // Provided by VK_EXT_ycbcr_2plane_444_formats
    G10X6_B10X6R10X6_2PLANE_444_UNORM_3PACK16_EXT = G10X6_B10X6R10X6_2PLANE_444_UNORM_3PACK16,
  // Provided by VK_EXT_ycbcr_2plane_444_formats
    G12X4_B12X4R12X4_2PLANE_444_UNORM_3PACK16_EXT = G12X4_B12X4R12X4_2PLANE_444_UNORM_3PACK16,
  // Provided by VK_EXT_ycbcr_2plane_444_formats
    G16_B16R16_2PLANE_444_UNORM_EXT = G16_B16R16_2PLANE_444_UNORM,
  // Provided by VK_EXT_4444_formats
    A4R4G4B4_UNORM_PACK16_EXT = A4R4G4B4_UNORM_PACK16,
  // Provided by VK_EXT_4444_formats
    A4B4G4R4_UNORM_PACK16_EXT = A4B4G4R4_UNORM_PACK16,
  // Provided by VK_NV_optical_flow
  // R16G16_S10_5_NV is a deprecated alias
    R16G16_S10_5_NV = R16G16_SFIXED5_NV,
  // Provided by VK_KHR_maintenance5
    A1B5G5R5_UNORM_PACK16_KHR = A1B5G5R5_UNORM_PACK16,
  // Provided by VK_KHR_maintenance5
    A8_UNORM_KHR = A8_UNORM,
}

bool vkFormatToGLFormat(VkFormat vkFormat, out TextureFormat tf)
{
    tf.format = 0;
    tf.internalFormat = 0;
    tf.pixelType = 0;
    tf.blockSize = 0;
    
    switch(vkFormat)
    {
        case VkFormat.R8_UNORM:
            tf.format = GL_RED;
            tf.internalFormat = GL_R8;
            tf.pixelType = GL_UNSIGNED_BYTE;
            break;
        
        case VkFormat.R8_SNORM:
            tf.format = GL_RED;
            tf.internalFormat = GL_R8;
            tf.pixelType = GL_BYTE;
            break;
        
        case VkFormat.R8G8_UNORM:
            tf.format = GL_RG;
            tf.internalFormat = GL_RG8;
            tf.pixelType = GL_UNSIGNED_BYTE;
            break;
        
        case VkFormat.R8G8_SNORM:
            tf.format = GL_RG;
            tf.internalFormat = GL_RG8;
            tf.pixelType = GL_BYTE;
            break;
        
        case VkFormat.R8G8B8A8_UNORM, VkFormat.R8G8B8A8_SRGB:
            tf.format = GL_RGBA;
            tf.internalFormat = GL_RGBA8;
            tf.pixelType = GL_UNSIGNED_BYTE;
            break;
        
        case VkFormat.R8G8B8_UNORM, VkFormat.R8G8B8_SRGB:
            tf.format = GL_RGB;
            tf.internalFormat = GL_RGB8;
            tf.pixelType = GL_UNSIGNED_BYTE;
            break;
        
        case VkFormat.R32G32B32A32_SFLOAT:
            tf.format = GL_RGBA;
            tf.internalFormat = GL_RGBA32F;
            tf.pixelType = GL_FLOAT;
            break;
        
        case VkFormat.R16G16B16A16_SFLOAT:
            tf.format = GL_RGBA;
            tf.internalFormat = GL_RGBA16F;
            tf.pixelType = GL_HALF_FLOAT;
            break;
        
        case VkFormat.BC1_RGB_UNORM_BLOCK, VkFormat.BC1_RGB_SRGB_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGB_S3TC_DXT1_EXT;
            tf.blockSize = 8;
            break;
        
        case VkFormat.BC2_UNORM_BLOCK, VkFormat.BC2_SRGB_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC3_UNORM_BLOCK, VkFormat.BC3_SRGB_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC4_UNORM_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RED_RGTC1;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC4_SNORM_BLOCK:
            tf.internalFormat = GL_COMPRESSED_SIGNED_RED_RGTC1;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC5_UNORM_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RG_RGTC2;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC5_SNORM_BLOCK:
            tf.internalFormat = GL_COMPRESSED_SIGNED_RG_RGTC2;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC6H_SFLOAT_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC6H_UFLOAT_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB;
            tf.blockSize = 16;
            break;
        
        case VkFormat.BC7_UNORM_BLOCK, VkFormat.BC7_SRGB_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGBA_BPTC_UNORM_ARB;
            tf.blockSize = 16;
            break;
        
        case VkFormat.ASTC_4x4_UNORM_BLOCK, VkFormat.ASTC_4x4_SRGB_BLOCK:
            tf.internalFormat = GL_COMPRESSED_RGBA_ASTC_4x4_KHR;
            tf.blockSize = 16;
            break;
        
        default:
            writeln("Warning: unsupported VkFormat");
            return false;
    }
    
    return true;
}

bool loadKTX1(InputStream istrm, string filename, TextureBuffer* buffer, bool* generateMipmaps)
{
    size_t dataSize = istrm.size;
    ubyte[] data = New!(ubyte[])(dataSize);
    istrm.readBytes(data.ptr, dataSize);
    
    ktxTexture1* tex = null;
    KTX_error_code err = ktxTexture1_CreateFromMemory(data.ptr, dataSize,
        ktxTextureCreateFlagBits.KTX_TEXTURE_CREATE_LOAD_IMAGE_DATA_BIT, &tex);
    if (err != KTX_error_code.KTX_SUCCESS)
    {
        writeln("Error loading ", filename, ": ", err);
        return false;
    }
    
    TextureSize size;
    size.width = tex.baseWidth;
    size.height = tex.baseWidth;
    size.depth = tex.baseDepth;
    
    TextureFormat format;
    format.format = tex.glFormat;
    format.internalFormat = tex.glInternalformat;
    format.pixelType = tex.glType;
    
    // Don't use automatic linearization
    if (format.internalFormat == GL_SRGB8_ALPHA8)
        format.internalFormat = GL_RGBA8;
    else if (format.internalFormat == GL_SRGB8)
        format.internalFormat = GL_RGB8;
    
    if (tex.isCubemap)
    {
        format.target = GL_TEXTURE_CUBE_MAP;
        format.cubeFaces = CubeFaceBit.All;
    }
    else
    {
        if (tex.numDimensions == 1)
            format.target = GL_TEXTURE_1D;
        else if (tex.numDimensions == 2)
            format.target = GL_TEXTURE_2D;
        else if (tex.numDimensions == 3)
            format.target = GL_TEXTURE_3D;
    }
    
    buffer.format = format;
    buffer.size = size;
    buffer.mipLevels = tex.numLevels;
    buffer.data = New!(ubyte[])(tex.dataSize);
    
    size_t dstOffset = 0;
    for (uint cubeFace = 0; cubeFace < tex.numFaces; cubeFace++)
    {
        for (uint mipLevel = 0; mipLevel < buffer.mipLevels; mipLevel++)
        {
            ktx_size_t mipLevelOffset;
            ktxTexture_GetImageOffset(tex, mipLevel, 0, cubeFace, &mipLevelOffset);
            ktx_size_t mipLevelSize = ktxTexture_GetImageSize(tex, mipLevel);
            
            buffer.data[dstOffset..dstOffset+mipLevelSize] = tex.pData[mipLevelOffset..mipLevelOffset+mipLevelSize];
            dstOffset += mipLevelSize;
        }
    }
    
    *generateMipmaps = tex.generateMipmaps;
    
    ktxTexture1_Destroy(tex);
    
    return true;
}

enum TranscodeFormatPriority
{
    Uncompressed,
    Quality,
    Size
}

bool loadKTX2(InputStream istrm, string filename, TextureBuffer* buffer, TranscodeFormatPriority priority, bool* generateMipmaps)
{
    size_t dataSize = istrm.size;
    ubyte[] data = New!(ubyte[])(dataSize);
    istrm.readBytes(data.ptr, dataSize);
    
    ktxTexture2* tex = null;
    KTX_error_code err = ktxTexture2_CreateFromMemory(data.ptr, dataSize,
        ktxTextureCreateFlagBits.KTX_TEXTURE_CREATE_LOAD_IMAGE_DATA_BIT, &tex);
    if (err != KTX_error_code.KTX_SUCCESS)
    {
        writeln("Error loading ", filename, ": ", err);
        return false;
    }
    
    if (ktxTexture2_NeedsTranscoding(tex))
    {
        auto numChannels = ktxTexture2_GetNumComponents(tex);
        
        bool bptcSupported = true; // TODO: check extension
        
        ktx_transcode_fmt_e targetFormat;
        string targetFormatStr;
        
        // TODO: support floating point textures
        
        if (priority == TranscodeFormatPriority.Uncompressed)
        {
            targetFormat = ktx_transcode_fmt_e.KTX_TTF_RGBA32;
            targetFormatStr = "RGBA32";
        }
        else if (numChannels == 1)
        {
            targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC4_R;
            targetFormatStr = "RGTC/BC4";
        }
        else if (numChannels == 2)
        {
            targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC5_RG;
            targetFormatStr = "RGTC/BC5";
        }
        else if (numChannels == 3)
        {
            if (bptcSupported && priority == TranscodeFormatPriority.Quality)
            {
                targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC7_RGBA;
                targetFormatStr = "BPTC/BC7";
            }
            else
            {
                targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC1_RGB;
                targetFormatStr = "DXT1/BC1";
            }
        }
        else if (numChannels == 4)
        {
            if (bptcSupported && priority == TranscodeFormatPriority.Quality)
            {
                targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC7_RGBA;
                targetFormatStr = "BPTC/BC7";
            }
            else
            {
                targetFormat = ktx_transcode_fmt_e.KTX_TTF_BC3_RGBA;
                targetFormatStr = "DXT5/BC3";
            }
        }
        
        writeln("Transcoding ", filename, " to ", targetFormatStr);
        err = ktxTexture2_TranscodeBasis(tex, targetFormat, 0);
        if (err != KTX_error_code.KTX_SUCCESS)
        {
            writeln("Error loading ", filename, ": ", err);
            return false;
        }
    }
    
    TextureSize size;
    size.width = tex.baseWidth;
    size.height = tex.baseWidth;
    size.depth = tex.baseDepth;
    
    TextureFormat format;
    
    if (!vkFormatToGLFormat(cast(VkFormat)tex.vkFormat, format))
        return false;
    
    if (tex.isCubemap)
    {
        format.target = GL_TEXTURE_CUBE_MAP;
        format.cubeFaces = CubeFaceBit.All;
    }
    else
    {
        if (tex.numDimensions == 1)
            format.target = GL_TEXTURE_1D;
        else if (tex.numDimensions == 2)
            format.target = GL_TEXTURE_2D;
        else if (tex.numDimensions == 3)
            format.target = GL_TEXTURE_3D;
    }
    
    buffer.format = format;
    buffer.size = size;
    buffer.mipLevels = tex.numLevels;
    buffer.data = New!(ubyte[])(tex.dataSize);
    
    size_t dstOffset = 0;
    for (uint cubeFace = 0; cubeFace < tex.numFaces; cubeFace++)
    {
        for (uint mipLevel = 0; mipLevel < buffer.mipLevels; mipLevel++)
        {
            ktx_size_t mipLevelOffset;
            ktxTexture2_GetImageOffset(tex, mipLevel, 0, cubeFace, &mipLevelOffset);
            ktx_size_t mipLevelSize = ktxTexture_GetImageSize(tex, mipLevel);
            
            buffer.data[dstOffset..dstOffset+mipLevelSize] = tex.pData[mipLevelOffset..mipLevelOffset+mipLevelSize];
            dstOffset += mipLevelSize;
        }
    }
    
    *generateMipmaps = tex.generateMipmaps;
    
    ktxTexture2_Destroy(tex);
    
    return true;
}

class KTXAsset: Asset
{
    Texture texture;
    protected TextureBuffer buffer;
    protected bool generateMipmaps = true;
    
    TranscodeFormatPriority transcodeFormatPriority;
    
    this(TranscodeFormatPriority transcodeFormatPriority, Owner o)
    {
        super(o);
        this.transcodeFormatPriority = transcodeFormatPriority;
        texture = New!Texture(this);
    }
    
    ~this()
    {
        release();
    }
    
    override bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager assetManager)
    {
        string ext = filename.extension;
        if (ext == ".ktx" || ext == ".KTX")
            return loadKTX1(istrm, filename, &buffer, &generateMipmaps);
        else if (ext == ".ktx2" || ext == ".KTX2")
            return loadKTX2(istrm, filename, &buffer, transcodeFormatPriority, &generateMipmaps);
        else
            return false;
    }
    
    override bool loadThreadUnsafePart()
    {
        if (texture.valid)
            return true;
        
        if (buffer.data.length)
        {
            texture.createFromBuffer(buffer, generateMipmaps);
            Delete(buffer.data);
            return true;
        }
        else
            return false;
    }
    
    override void release()
    {
        if (texture)
            texture.release();
        if (buffer.data.length)
            Delete(buffer.data);
    }
}

KTXAsset addKTXAsset(Scene scene, string filename, TranscodeFormatPriority transcodeFormatPriority, bool preload = false)
{
    KTXAsset ktx;
    if (scene.assetManager.assetExists(filename))
        ktx = cast(KTXAsset)scene.assetManager.getAsset(filename);
    else
    {
        ktx = New!KTXAsset(transcodeFormatPriority, scene.assetManager);
        scene.addAsset(ktx, filename, preload);
    }
    return ktx;
}
