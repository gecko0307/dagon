#define STB_DEFINE
#include "stb.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_RESIZE_IMPLEMENTATION
#include "stb_image_resize.h"

#define STB_RECT_PACK_IMPLEMENTATION
#include "stb_rect_pack.h"

#define STB_DXT_IMPLEMENTATION
#include "stb_dxt.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STBIW_ZLIB_COMPRESS compress_for_stb_image_write
unsigned char *compress_for_stb_image_write(unsigned char *data, int data_len, int *out_len, int quality);
#include "stb_image_write.h"
