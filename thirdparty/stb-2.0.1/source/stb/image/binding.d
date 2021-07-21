module stb.image.binding;

import core.stdc.stdio : FILE;


enum
{
	STBI_default,
	STBI_grey,
	STBI_grey_alpha,
	STBI_rgb,
	STBI_rgb_alpha
}

extern(C) @nogc nothrow:

struct stbi_io_callbacks
{
	int function(void* user, char* data, int size) read;
	void function(void* user, int n) skip;
	int function(void* user) eof;
}

ubyte* stbi_load_from_memory(in void* buffer, int len, int* x, int* y, int* channels_in_file, int desired_channels);
ubyte* stbi_load_from_callbacks(const(stbi_io_callbacks)* clbk, void* user, int* x, int* y, int* channels_in_file, int desired_channels);

ubyte* stbi_load_gif_from_memory(in void* buffer, int len, int** delays, int* x, int* y, int* z, int* comp, int req_comp);

ubyte* stbi_load(const(char)* filename, int* x, int* y, int* channels_in_file, int desired_channels);
ubyte* stbi_load_from_file(FILE* f, int* x, int* y, int* channels_in_file, int desired_channels);

ushort* stbi_load_16_from_memory(in void* buffer, int len, int* x, int* y, int* channels_in_file, int desired_channels);
ushort* stbi_load_16_from_callbacks(const(stbi_io_callbacks)* clbk, void* user, int* x, int* y, int* channels_in_file, int desired_channels);

ushort* stbi_load_16(const(char)* filename, int* x, int* y, int* channels_in_file, int desired_channels);
ushort* stbi_load_from_file_16(FILE* f, int* x, int* y, int* channels_in_file, int desired_channels);

float* stbi_loadf_from_memory(in void* buffer, int len, int* x, int* y, int* channels_in_file, int desired_channels);
float* stbi_loadf_from_callbacks(const(stbi_io_callbacks)* clbk, void* user, int* x, int* y, int* channels_in_file, int desired_channels);

float* stbi_loadf(const(char)* filename, int* x, int* y, int* channels_in_file, int desired_channels);
float* stbi_loadf_from_file(FILE* f, int* x, int* y, int* channels_in_file, int desired_channels);

void stbi_hdr_to_ldr_gamma(float gamma);
void stbi_hdr_to_ldr_scale(float scale);

void stbi_ldr_to_hdr_gamma(float gamma);
void stbi_ldr_to_hdr_scale(float scale);

int stbi_is_hdr_from_callbacks(const(stbi_io_callbacks)* clbk, void* user);
int stbi_is_hdr_from_memory(in void* buffer, int len);

int stbi_is_hdr(const(char)* filename);
int stbi_is_hdr_from_file(FILE* f);

const(char)* stbi_failure_reason();

void stbi_image_free(void* retval_from_stbi_load);

int stbi_info_from_memory(in void* buffer, int len, int* x, int* y, int* comp);
int stbi_info_from_callbacks(const(stbi_io_callbacks)* clbk, void* user, int* x, int* y, int* comp);
int stbi_is_16_bit_from_memory(in void* buffer, int len);
int stbi_is_16_bit_from_callbacks(const(stbi_io_callbacks)* clbk, void* user);

int stbi_info(const(char)* filename, int* x, int* y, int* comp);
int stbi_info_from_file(FILE* f, int* x, int* y, int* comp);
int stbi_is_16_bit(const(char)* filename);
int stbi_is_16_bit_from_file(FILE* f);

void stbi_set_unpremultiply_on_load(int flag_true_if_should_unpremultiply);

void stbi_convert_iphone_png_to_rgb(int flag_true_if_should_convert);

void stbi_set_flip_vertically_on_load(int flag_true_if_should_flip);

char* stbi_zlib_decode_malloc_guesssize(const(char)* buffer, int len, int initial_size, int* outlen);
char* stbi_zlib_decode_malloc_guesssize_headerflag(const(char)* buffer, int len, int initial_size, int* outlen, int parse_header);
char* stbi_zlib_decode_malloc(const(char)* buffer, int len, int* outlen);
int stbi_zlib_decode_buffer(char* obuffer, int olen, const(char)* ibuffer, int ilen);

char* stbi_zlib_decode_noheader_malloc(const(char)* buffer, int len, int* outlen);
int stbi_zlib_decode_noheader_buffer(char* obuffer, int olen, const(char)* ibuffer, int ilen);
