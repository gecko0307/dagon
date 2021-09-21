module stb.image;

import
		core.bitop,
		std.file,
		std.path,
		std.conv,
		std.math,
		std.range,
		std.string,
		std.mmfile,
		std.typecons,
		std.bitmanip,
		std.exception,
		std.algorithm,

		core.stdc.string,
		etc.c.zlib,

		stb.image.write,
		stb.image.resize,
		stb.image.binding;


struct Color
{
	this(uint r, uint g, uint b, uint a = 0)
	{
		this.r = cast(ubyte)r;
		this.g = cast(ubyte)g;
		this.b = cast(ubyte)b;
		this.a = cast(ubyte)a;
	}

	static fromInt(uint n)
	{
		n = n.bswap;
		return *cast(Color*)&n;
	}

	const
	{
		auto opBinary(string op: `*`)(in Color c)
		{
			return Color(
							r * c.r / 255,
							g * c.g / 255,
							b * c.b / 255,
							a * c.a / 255
												);
		}

		auto opBinary(string op: `+`)(in Color c)
		{
			return Color(
							min(r + c.r, 255),
							min(g + c.g, 255),
							min(b + c.b, 255),
							min(a + c.a, 255)
												);
		}

		auto opBinary(string op: `^`)(in Color c)
		{
			// TODO: CHECK FORCORRECTNESS
			auto od = 255 - c.a;
			auto ra = c.a + a * od / 255;

			// TODO: WORKAROUND
			if(!ra) ra = 1;

			return Color(
							(c.r * c.a + r * a * od / 255) / ra,
							(c.g * c.a + g * a * od / 255) / ra,
							(c.b * c.a + b * a * od / 255) / ra,
							ra
																	);
		}

		bool isGray(ubyte n)
		{
			auto a = min(r, g, b), b = max(r, g, b);
			return abs(a - b) < 30 && b < n;
		}

		bool compare(in Color c, ubyte d)
		{
			return abs(r - c.r) + abs(g - c.g) + abs(b - c.b) + abs(a - c.a) <= d * 4;
		}
	}

	ref opOpAssign(string op)(in Color c)
	{
		return this = this.opBinary!op(c);
	}

	ubyte
			r,
			g,
			b,
			a;
}

static assert(Color.sizeof == 4);

enum
{
	colorGray = Color(128, 128, 128, 200),
	colorBlack = Color(0, 0, 0, 255),
	colorWhite = Color(255, 255, 255, 255),
	colorTransparent = Color.init,
}

enum
{
	IM_BMP,
	IM_TGA,
	IM_PNG,
	IM_JPG,
}

final class Image
{
	this(string name)
	{
		auto f = new MmFile(name);

		scope(exit)
		{
			f.destroy;
		}

		this(f[]);
	}

	this(in void[] data)
	{
		auto p = cast(Color*)stbi_load_from_memory(data.ptr, cast(uint)data.length, cast(int*)&_w, cast(int*)&_h, null, 4);
		enforce(p, `unknown/corrupted image`);

		_data = p[0.._w * _h].dup;
		stbi_image_free(p);
	}

	this(uint w, uint h, const(void)[] data = null)
	{
		assert(w && h);

		if(data.length)
		{
			_data = cast(Color[])data;
			assert(_data.length == w * h);
		}
		else
		{
			_data = new Color[w * h];
		}

		_w = w;
		_h = h;
	}

	this(in Image im)
	{
		_w = im._w;
		_h = im._h;
		_data = im._data.dup;
	}

	auto blit(in Image im, uint x, uint y)
	{
		assert(x + im._w <= _w && y + im._h <= _h);

		foreach(j; 0..im._h)
		{
			memcpy(&this[x, j + y], &im[0, j], im.w * 4);
		}

		return this;
	}

	const
	{
		auto dup()
		{
			return new Image(this);
		}

		void saveToFile(string name)
		{
			ubyte f;

			switch(name.extension.stripLeft(`.`).toLower)
			{
			case `png`:
				f = IM_PNG;
				break;
			case `bmp`:
				f = IM_BMP;
				break;
			case `tga`:
				f = IM_TGA;
				break;
			case `jpg`:
			case `jpeg`:
				f = IM_JPG;
				break;
			default:
				throw new Exception(`unknown image extension`);
			}

			saveToFile(name, f);
		}

		void saveToFile(string name, ubyte format)
		{
			std.file.write(name, save(format));
		}

		auto save(ubyte format)
		{
			bool res;
			void[] data;

			final switch(format)
			{
			case IM_BMP:
				res = !!stbi_write_bmp_to_func(&writerCallback, &data, _w, _h, 4, _data.ptr);
				break;
			case IM_TGA:
				res = !!stbi_write_tga_to_func(&writerCallback, &data, _w, _h, 4, _data.ptr);
				break;
			case IM_PNG:
				res = !!stbi_write_png_to_func(&writerCallback, &data, _w, _h, 4, _data.ptr, 0);
				break;
			case IM_JPG:
				//res = !!stbi_write_jpg_to_func(&writerCallback, &data, _w, _h, 4, _data.ptr, 95);
			}

			assert(res);
			return data;
		}

		auto subImage(uint x, uint y, uint w, uint h)
		{
			assert(x + w <= _w && y + h <= _h);
			auto res = new Image(w, h);

			foreach(i; 0..w)
			foreach(j; 0..h)
				res[j][] = this[y + j][x..x + w][];

			return res;
		}

		auto resize(uint w, uint h)
		{
			auto res = new Image(w, h);
			stbir_resize_uint8(cast(ubyte*)_data.ptr, _w, _h, 0, cast(ubyte*)res[].ptr, w, h, 0, 4);
			return res;
		}

		/*auto rotate(float angle)
		{
			Image res;
			if(angle > 85 && angle < 95)
			{
				res = new Image(_h, _w);

				foreach(i; 0.._w)
				foreach(j; 0.._h)
					res[j, i] = this[i, j]; // TODO: IT'S -90, NOT 90
					//res[j, i] = this[_w - i - 1, j];
			}
			return res;
		}*/
	}

	void clean()
	{
		_data
				.filter!((ref a) => a.compare(Color(255, 0, 255, 255), 10))
				.each!((ref a) => a.a = 0);

		normalizeTransparentPixels;
	}

	void normalizeTransparentPixels()
	{
		const uint N = _w * _h;

		auto opaque = new byte[N];
		auto loose = new bool[N];

		uint[] pending;
		uint[] pendingNext;

		static immutable byte[2][8] offsets =
		[
			[ -1, -1 ],
			[  0, -1 ],
			[  1, -1 ],
			[ -1,  0 ],
			[  1,  0 ],
			[ -1,  1 ],
			[  0,  1 ],
			[  1,  1 ]
		];

		auto image = cast(ubyte[])_data;

		for(uint i = 0, j = 3; i < N; i++, j += 4)
		{
			if(image[j] == 0)
			{
				bool isLoose = true;

				int x = i % _w;
				int y = i / _w;

				for(int k = 0; k < 8; k++)
				{
					int s = offsets[k][0];
					int t = offsets[k][1];

					if(x + s >= 0 && x + s < _w && y + t >= 0 && y + t < _h)
					{
						uint index = j + 4 * (s + t * _w);

						if(image[index] != 0)
						{
							isLoose = false;
							break;
						}
					}
				}

				if(isLoose)
				{
					loose[i] = true;
				}
				else
				{
					pending ~= i;
				}
			}
			else
			{
				opaque[i] = -1;
			}
		}

		while(pending.length > 0)
		{
			pendingNext = null;

			for(uint p = 0; p < pending.length; p++)
			{
				uint i = pending[p] * 4;
				uint j = pending[p];

				int x = j % _w;
				int y = j / _w;

				int r = 0;
				int g = 0;
				int b = 0;

				int count = 0;

				for(uint k = 0; k < 8; k++)
				{
					int s = offsets[k][0];
					int t = offsets[k][1];

					if(x + s >= 0 && x + s < _w && y + t >= 0 && y + t < _h)
					{
						t *= _w;

						if(opaque[j + s + t] & 1)
						{
							uint index = i + 4 * (s + t);

							r += image[index + 0];
							g += image[index + 1];
							b += image[index + 2];

							count++;
						}
					}
				}

				if(count > 0)
				{
					image[i + 0] = cast(ubyte)(r / count);
					image[i + 1] = cast(ubyte)(g / count);
					image[i + 2] = cast(ubyte)(b / count);

					opaque[j] = cast(byte)0xFE;

					for(uint k = 0; k < 8; k++)
					{
						int s = offsets[k][0];
						int t = offsets[k][1];

						if(x + s >= 0 && x + s < _w && y + t >= 0 && y + t < _h)
						{
							uint index = j + s + t * _w;

							if(loose[index])
							{
								pendingNext ~= index;
								loose[index] = false;
							}
						}
					}
				}
				else
				{
					pendingNext ~= j;
				}
			}

			if(pendingNext.length > 0)
			{
				for(uint p = 0; p < pending.length; p++)
				{
					opaque[pending[p]] >>= 1;
				}
			}

			pending.swap(pendingNext);
		}
	}

	auto flip()
	{
		foreach(j; 0.._h / 2)
		foreach(i; 0.._w)
		{
			swap(this[i, j], this[i, _h - j - 1]);
		}

		return this;
	}

	auto mirror()
	{
		foreach(i; 0.._w / 2)
		foreach(j; 0.._h)
		{
			swap(this[i, j], this[_w - i - 1, j]);
		}

		return this;
	}

	inout
	{
		auto toMipmaps()
		{
			inout(Image)[] res = [ this ];

			while(true)
			{
				auto im = res.back;

				if(im.w == 1 && im.h == 1)
				{
					break;
				}

				auto
						w = max(im.w / 2, 1),
						h = max(im.h / 2, 1);

				res ~= cast(inout(Image))resize(w, h);
			}

			return res;
		}

		ref opIndex(uint x, uint y)
		{
			return _data[y * _w + x];
		}

		auto opIndex(uint y)
		{
			auto c = y * _w;
			return _data[c..c + _w];
		}

		auto opSlice()
		{
			return _data;
		}
	}

	@property const
	{
		auto w() { return _w; }
		auto h() { return _h; }
	}

private:
	static extern(C) void writerCallback(void* ptr, void* data, int len)
	{
		*cast(void[]*)ptr ~= data[0..len];
	}

	Color[] _data;

	uint
			_w,
			_h;
}

static this()
{
    // To prevent linker from stripping the symbol
    auto f = &compress_for_stb_image_write;
}

private extern(C):

ubyte* compress_for_stb_image_write(in ubyte* data, uint len, uint* resLen, int level)
{
	import core.stdc.stdlib;

	auto dst = compressBound(len);
	auto res = cast(ubyte*)malloc(dst);

	if(compress2(res, &dst, data, len, level) == Z_OK)
	{
		*resLen = cast(uint)dst;
		return res;
	}

	free(res);
	return null;
}

