module stb.dxt.binding;


enum
{
	STB_DXT_NORMAL,
	STB_DXT_DITHER,
	STB_DXT_HIGHQUAL,
}

extern(C) @nogc nothrow:

void stb_compress_dxt_block(void* dest, in void* src_rgba_four_bytes_per_pixel, bool alpha, int mode);
void stb_compress_bc4_block(void* dest, in void* src_r_one_byte_per_pixel);
void stb_compress_bc5_block(void* dest, in void* src_rg_two_byte_per_pixel);
