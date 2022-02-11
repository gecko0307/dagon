module stb.image.write;


extern(C):

alias stbi_write_func = void function(void* context, void* data, int size);

__gshared extern
{
	int stbi_write_tga_with_rle;
	int stbi_write_png_compression_level;
	int stbi_write_force_png_filter;
}

int stbi_write_png(in char* filename, int w, int h, int comp, in void* data, int stride_in_bytes);
int stbi_write_bmp(in char* filename, int w, int h, int comp, in void* data);
int stbi_write_tga(in char* filename, int w, int h, int comp, in void* data);
int stbi_write_hdr(in char* filename, int w, int h, int comp, in float* data);
int stbi_write_jpg(in char* filename, int x, int y, int comp, in void* data, int quality);


int stbi_write_png_to_func(stbi_write_func func, void* context, int w, int h, int comp, in void* data, int stride_in_bytes);
int stbi_write_bmp_to_func(stbi_write_func func, void* context, int w, int h, int comp, in void* data);
int stbi_write_tga_to_func(stbi_write_func func, void* context, int w, int h, int comp, in void* data);
int stbi_write_hdr_to_func(stbi_write_func func, void* context, int w, int h, int comp, in float* data);
int stbi_write_jpg_to_func(stbi_write_func func, void* context, int x, int y, int comp, in void* data, int quality);

void stbi_flip_vertically_on_write(int flip_boolean);
