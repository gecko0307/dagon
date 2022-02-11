module stb.rectpack.binding;


enum
{
	STBRP_HEURISTIC_Skyline_default,

	STBRP_HEURISTIC_Skyline_BL_sortHeight = 0,
	STBRP_HEURISTIC_Skyline_BF_sortHeight
}

extern(C):

struct stbrp_rect
{
	int id;
	ushort w, h;
	ushort x, y;
	int was_packed;
}

struct stbrp_node
{
	ushort x, y;
	stbrp_node* next;
}

struct stbrp_context
{
	int width;
	int height;
	int align_;
	int init_mode;
	int heuristic;
	int num_nodes;
	stbrp_node* active_head;
	stbrp_node* free_head;
	stbrp_node[2] extra;
}

int stbrp_pack_rects(stbrp_context* context, stbrp_rect* rects, int num_rects);

void stbrp_init_target(stbrp_context* context, int width, int height, stbrp_node* nodes, int num_nodes);

void stbrp_setup_allow_out_of_mem(stbrp_context* context, int allow_out_of_mem);

void stbrp_setup_heuristic(stbrp_context* context, int heuristic);
