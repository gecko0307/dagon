module stb.dxt;

import
		std.algorithm,

		stb.image,
		stb.dxt.binding;


uint dxtTextureSize(uint w, uint h, bool isDxt5)
{
	w = (w + 3) / 4;
	h = (h + 3) / 4;

	return w * h * (isDxt5 ? 16 : 8);
}

auto dxtCompress(in Image im, bool isDxt5)
{
	auto res = new ubyte[dxtTextureSize(im.w, im.h, isDxt5)];

	auto
			sz = isDxt5 ? 4 : 2,
			line = (im.w + 3) / 4;

	for(uint y; y < im.h; y += 4)
	for(uint x; x < im.w; x += 4)
	{
		Color[4][4] block;

		foreach(k; 0..4)
		{
			auto v = min(y + k, im.h - 1);

			foreach(u; 0..4)
			{
				block[k][u] = im[min(x + u, im.w - 1), v];
			}
		}

		stb_compress_dxt_block(res.ptr + (y * line + x) * sz, block.ptr, isDxt5, STB_DXT_DITHER | STB_DXT_HIGHQUAL);
	}

	return res;
}
