module stb.rectpack;

import
		std.typecons,
		std.algorithm,

		stb,
		stb.rectpack.binding;


struct TexturePacker
{
	this(stbrp_rect[] rects)
	{
 		_rects = rects;
 		_nodes = new stbrp_node[TEX_MAX];
 	}

	auto process()
	{
		auto w = binarySearch(0, TEX_MAX,	a => canPack(a, a) ? -1 : 1);
		auto h = binarySearch(0, w,			a => canPack(w, a) ? -1 : 1);

		// call once more because binarySearch can do some extra failing tries
		canPack(w, h);

		return tuple!(`w`, `h`)(w, h);

	}

private:
	enum TEX_MAX = 16384;

	bool canPack(int w, int h)
	{
		stbrp_init_target(&_context, w, h, _nodes.ptr, cast(uint)_nodes.length);
		return !!stbrp_pack_rects(&_context, _rects.ptr, cast(uint)_rects.length);
	}

	stbrp_rect[] _rects;
	stbrp_node[] _nodes;
	stbrp_context _context;
}

unittest
{
	stbrp_rect[3] arr;

	arr[0] = stbrp_rect(0, 10, 20); // id, w, h
	arr[1] = stbrp_rect(1, 20, 20);
	arr[2] = stbrp_rect(2, 40, 20);

	auto res = TexturePacker(arr).process;

	assert(res.w == 40 && res.h == 40);
	assert(arr[].all!(a => a.was_packed));
}
