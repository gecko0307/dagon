module stb.image.resize;


alias stbir_edge = int;
alias stbir_filter = int;
alias stbir_colorspace = int;
alias stbir_datatype = int;

enum
{
	STBIR_EDGE_CLAMP = 1,
	STBIR_EDGE_REFLECT,
	STBIR_EDGE_WRAP,
	STBIR_EDGE_ZERO,
}

enum
{
	STBIR_FILTER_DEFAULT,
	STBIR_FILTER_BOX,
	STBIR_FILTER_TRIANGLE,
	STBIR_FILTER_CUBICBSPLINE,
	STBIR_FILTER_CATMULLROM,
	STBIR_FILTER_MITCHELL,
}

enum
{
	STBIR_COLORSPACE_LINEAR,
	STBIR_COLORSPACE_SRGB,
	STBIR_MAX_COLORSPACES,
}

enum
{
	STBIR_TYPE_UINT8,
	STBIR_TYPE_UINT16,
	STBIR_TYPE_UINT32,
	STBIR_TYPE_FLOAT,
	STBIR_MAX_TYPES
}

extern(C):

int stbir_resize_uint8(	in ubyte* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
						ubyte* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
						int num_channels);

int stbir_resize_float(	in float* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
						float* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
						int num_channels);

int stbir_resize_uint8_srgb(in ubyte* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
							ubyte* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
							int num_channels, int alpha_channel, int flags);


int stbir_resize_uint8_srgb_edgemode(	in ubyte* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
										ubyte* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
										int num_channels, int alpha_channel, int flags,
										stbir_edge edge_wrap_mode);


int stbir_resize_uint8_generic(	in ubyte* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
								ubyte* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
								int num_channels, int alpha_channel, int flags,
								stbir_edge edge_wrap_mode, stbir_filter filter, stbir_colorspace space,
								void* alloc_context);

int stbir_resize_uint16_generic(in ushort* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
								ushort* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
								int num_channels, int alpha_channel, int flags,
								stbir_edge edge_wrap_mode, stbir_filter filter, stbir_colorspace space,
								void* alloc_context);

int stbir_resize_float_generic(	in float* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
								float* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
								int num_channels, int alpha_channel, int flags,
								stbir_edge edge_wrap_mode, stbir_filter filter, stbir_colorspace space,
								void* alloc_context);


int stbir_resize(	in void* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
					void* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
					stbir_datatype datatype,
					int num_channels, int alpha_channel, int flags,
					stbir_edge edge_mode_horizontal, stbir_edge edge_mode_vertical,
					stbir_filter filter_horizontal, stbir_filter filter_vertical,
					stbir_colorspace space, void* alloc_context);

int stbir_resize_subpixel(	in void* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
							void* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
							stbir_datatype datatype,
							int num_channels, int alpha_channel, int flags,
							stbir_edge edge_mode_horizontal, stbir_edge edge_mode_vertical,
							stbir_filter filter_horizontal, stbir_filter filter_vertical,
							stbir_colorspace space, void* alloc_context,
							float x_scale, float y_scale,
							float x_offset, float y_offset);

int stbir_resize_region(in void* input_pixels, int input_w, int input_h, int input_stride_in_bytes,
						void* output_pixels, int output_w, int output_h, int output_stride_in_bytes,
						stbir_datatype datatype,
						int num_channels, int alpha_channel, int flags,
						stbir_edge edge_mode_horizontal, stbir_edge edge_mode_vertical,
						stbir_filter filter_horizontal, stbir_filter filter_vertical,
						stbir_colorspace space, void* alloc_context,
						float s0, float t0, float s1, float t1);
