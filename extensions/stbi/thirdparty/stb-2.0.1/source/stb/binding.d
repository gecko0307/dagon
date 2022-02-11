module stb.binding;

import core.stdc.stdarg;
import core.stdc.stdio : FILE;


auto stb_arrhead(T)(T** a)
{
	return cast(stb__arr*)a - 1;
}

extern(C) @nogc nothrow:

alias time_t = ulong;

alias stb_compare_func = int function(void* a, void* b);
alias stb_hash_func = int function(void* a, uint seed);
alias stb_thread_func = void* function(void*);

alias stb_bitset = uint;

alias stb_sync = void*;
alias stb_mutex = void*;
alias stb_thread = void*;
alias stb_semaphore = void*;

struct stb_ps;
struct stb_cfg;
struct stb_idict;
struct stb_sdict;
struct stb_ptrmap;
struct stb_matcher;
struct stb_spmatrix;
struct stb_workqueue;
struct stb_threadqueue;

struct stb_search
{
	int minval, maxval, guess;
	int mode, step;
}

struct stb__arr
{
	int len, limit;
	int stb_malloc;
	uint signature;
}

struct stb_perfect
{
	uint addend;
	uint multiplicand;
	uint b_mask;
	ubyte[16] small_bmap;
	ushort* large_bmap;
	uint table_mask;
	uint* table;
}

struct stb_dirtree2
{
	stb_dirtree2** subdirs;
	int num_subdir;
	float weight;
	char* fullpath;
	char* relpath;
	char** files;
}

struct stb_dirtree_dir
{
	char* path;
	time_t last_modified;
	int num_files;
	int flag;
}

struct stb_dirtree_file
{
	char* name;
	int dir;
	long size;
	time_t last_modified;
	int flag;
}

struct stb_dirtree
{
	stb_dirtree_dir* dirs;
	stb_dirtree_file* files;
	void* string_pool;
}

struct stb_dupe
{
	void*** hash_table;
	int hash_size;
	int size_log2;
	int population;
	int hash_shift;
	stb_hash_func hash;
	stb_compare_func eq;
	stb_compare_func ineq;
	void*** dupes;
}

struct stbfile
{
	int function(stbfile*) getbyte;
	uint function(stbfile*, void* block, uint len) getdata;

	int function(stbfile*, int byte_) putbyte;
	uint function(stbfile*, void* block, uint len) putdata;

	uint function(stbfile*) size;

	uint function(stbfile*) tell;
	void function(stbfile*, uint tell, void* block, uint len) backpatch;

	void function(stbfile*) close;

	FILE* f;
	ubyte* buffer;
	ubyte* indata, inend;

	union
	{
		int various;
		void* ptr;
	}
}

struct stb_arith
{
	uint range_low;
	uint range_high;
	uint code, range;
	int buffered_u8;
	int pending_ffs;
	stbfile* output;
}

struct stb_arith_symstate_item
{
	ushort cumfreq;
	ushort samples;
}

struct stb_arith_symstate
{
	int num_sym;
	uint pow2;
	int countdown;
	stb_arith_symstate_item[1] data;
}

enum //stb_splitpath_flag
{
	STB_PATH = 1,
	STB_FILE = 2,
	STB_EXT = 4,
	STB_PATH_FILE = STB_PATH + STB_FILE,
	STB_FILE_EXT = STB_FILE + STB_EXT,
	STB_EXT_NO_PERIOD = 8,
}

enum
{
	stb_keep_no,
	stb_keep_yes,
	stb_keep_if_different,
}

__gshared extern
{
	int stb_alloc_chunk_size;
	int stb_alloc_count_free;
	int stb_alloc_count_alloc;
	int stb_alloc_alignment;
	int stb_perfect_hash_max_failures;
}

void stb_wrapper_malloc(void* newp, int sz, char* file, int line);
void stb_wrapper_free(void* oldp, char* file, int line);
void stb_wrapper_realloc(void* oldp, void* newp, int sz, char* file, int line);
void stb_wrapper_calloc(size_t num, size_t sz, char* file, int line);
void stb_wrapper_listall(void function(void* ptr, int sz, char* file, int line) func);
void stb_wrapper_dump(char* filename);
int stb_wrapper_allocsize(void* oldp);
void stb_wrapper_check(void* oldp);

void* stb_smalloc(size_t sz);
void stb_sfree(void* p);
void* stb_srealloc(void* p, size_t sz);
void* stb_scalloc(size_t n, size_t sz);
char* stb_sstrdup(char* s);

void stbprint(const(char)* fmt, ...);
char* stb_sprintf(const(char)* fmt, ...);
char* stb_mprintf(const(char)* fmt, ...);
int stb_snprintf(char* s, size_t n, const(char)* fmt, ...);
int stb_vsnprintf(char* s, size_t n, const(char)* fmt, va_list v);

wchar* stb_from_utf8(wchar* buffer, char* str, int n);
char* stb_to_utf8(char* buffer, wchar* str, int n);

wchar* stb__from_utf8(char* str);
wchar* stb__from_utf8_alt(char* str);
char* stb__to_utf8(wchar* str);

void stb_fatal(char* fmt, ...);
void stb_(char* fmt, ...);
void stb_append_to_file(char* file, char* fmt, ...);
void stb_log(int active);
void stb_log_fileline(int active);
void stb_log_name(char* filename);

void stb_swap(void* p, void* q, size_t sz);
void* stb_copy(void* p, size_t sz);
void stb_pointer_array_free(void* p, int len);
void** stb_array_block_alloc(int count, int blocksize);

int stb__record_fileline(char* f, int n);

void* stb__temp(void* b, int b_sz, int want_sz);
void stb_tempfree(void* block, void* ptr);

void stb_newell_normal(float* normal, int num_vert, float** vert, int normalize);
int stb_box_face_vertex_axis_side(int face_number, int vertex_number, int axis);
void stb_linear_controller(float* curpos, float target_pos, float acc, float deacc, float dt);

int stb_float_eq(float x, float y, float delta, int max_ulps);
int stb_is_prime(uint m);
uint stb_power_of_two_nearest_prime(int n);

float stb_smoothstep(float t);
float stb_cubic_bezier_1d(float t, float p0, float p1, float p2, float p3);

double stb_linear_remap(double x, double a, double b, double c, double d);

int stb_bitcount(uint a);
uint stb_bitreverse8(ubyte n);
uint stb_bitreverse(uint n);

int stb_is_pow2(uint n);
int stb_log2_ceil(uint n);
int stb_log2_floor(uint n);

int stb_lowbit8(uint n);
int stb_highbit8(uint n);

int function(const(void)* a, const(void)* b) stb_intcmp(int offset);
int function(const(void)* a, const(void)* b) stb_qsort_strcmp(int offset);
int function(const(void)* a, const(void)* b) stb_qsort_stricmp(int offset);
int function(const(void)* a, const(void)* b) stb_floatcmp(int offset);
int function(const(void)* a, const(void)* b) stb_doublecmp(int offset);
int function(const(void)* a, const(void)* b) stb_charcmp(int offset);

int stb_search_binary(stb_search* s, int minv, int maxv, int find_smallest);
int stb_search_open(stb_search* s, int minv, int find_smallest);
int stb_probe(stb_search* s, int compare, int* result);

char* stb_skipwhite(char* s);
char* stb_trimwhite(char* s);
char* stb_skipnewline(char* s);
char* stb_strncpy(char* s, char* t, int n);
char* stb_substr(char* t, int n);
char* stb_duplower(char* s);
void stb_tolower(char* s);
char* stb_strchr2(char* s, char p1, char p2);
char* stb_strrchr2(char* s, char p1, char p2);
char* stb_strtok(char* output, char* src, char* delimit);
char* stb_strtok_keep(char* output, char* src, char* delimit);
char* stb_strtok_invert(char* output, char* src, char* allowed);
char* stb_dupreplace(char* s, char* find, char* replace);
void stb_replaceinplace(char* s, char* find, char* replace);
char* stb_splitpath(char* output, char* src, int flag);
char* stb_splitpathdup(char* src, int flag);
char* stb_replacedir(char* output, char* src, char* dir);
char* stb_replaceext(char* output, char* src, char* ext);
void stb_fixpath(char* path);
char* stb_shorten_path_readable(char* path, int max_len);
int stb_suffix(char* s, char* t);
int stb_suffixi(char* s, char* t);
int stb_prefix(char* s, char* t);
char* stb_strichr(char* s, char t);
char* stb_stristr(char* s, char* t);
int stb_prefix_count(char* s, char* t);
const(char)* stb_plural(int n);
size_t stb_strscpy(char* d, const(char)* s, size_t n);

char** stb_tokens(char* src, char* delimit, int* count);
char** stb_tokens_nested(char* src, char* delimit, int* count, char* nest_in, char* nest_out);
char** stb_tokens_nested_empty(char* src, char* delimit, int* count, char* nest_in, char* nest_out);
char** stb_tokens_allowempty(char* src, char* delimit, int* count);
char** stb_tokens_stripwhite(char* src, char* delimit, int* count);
char** stb_tokens_withdelim(char* src, char* delimit, int* count);
char** stb_tokens_quoted(char* src, char* delimit, int* count);

void stb_free(void* p);
void* stb_malloc_global(size_t size);
void* stb_malloc(void* context, size_t size);
void* stb_malloc_nofree(void* context, size_t size);
void* stb_malloc_leaf(void* context, size_t size);
void* stb_malloc_raw(void* context, size_t size);
void* stb_realloc(void* ptr, size_t newsize);

void stb_reassign(void* new_context, void* ptr);
void stb_malloc_validate(void* p, void* parent);

void stb_arr_malloc(void** target, void* context);

void* stb_arr_malloc_parent(void* p);

void stb_arr_free_(void** p);
void* stb__arr_copy_(void* p, int elem_size);
void stb__arr_setsize_(void** p, int size, int limit );
void stb__arr_setlen_(void** p, int size, int newlen );
void stb__arr_addlen_(void** p, int size, int addlen );
void stb__arr_deleten_(void** p, int size, int loc, int n );
void stb__arr_insertn_(void** p, int size, int loc, int n );

uint stb_hash(char* str);
uint stb_hashptr(void* p);
uint stb_hashlen(char* str, int len);
uint stb_rehash_improved(uint v);
uint stb_hash_fast(void* p, int len);
uint stb_hash2(char* str, uint* hash2_ptr);
uint stb_hash_number(uint hash);

int stb_perfect_create(stb_perfect*, uint*, int n);
void stb_perfect_destroy(stb_perfect*);
int stb_perfect_hash(stb_perfect*, uint x);

int stb_ischar(char s, char* set);

int stb_ptrmap_init(stb_ptrmap* h, int count);
int stb_ptrmap_memory_usage(stb_ptrmap* h);
stb_ptrmap* stb_ptrmap_create();
stb_ptrmap* stb_ptrmap_copy(stb_ptrmap* h);
void stb_ptrmap_destroy(stb_ptrmap* h);
int stb_ptrmap_get_flag(stb_ptrmap* a, void* k, void** v);
void* stb_ptrmap_get(stb_ptrmap* a, void* k);
int stb_ptrmap_set(stb_ptrmap* a, void* k, void* v);
int stb_ptrmap_add(stb_ptrmap* a, void* k, void* v);
int stb_ptrmap_update(stb_ptrmap* a, void* k, void* v);
int stb_ptrmap_remove(stb_ptrmap* a, void* k, void** v);

int stb_idict_init(stb_idict* h, int count);
int stb_idict_memory_usage(stb_idict* h);
stb_idict* stb_idict_create();
stb_idict* stb_idict_copy(stb_idict* h);
void stb_idict_destroy(stb_idict* h);
int stb_idict_get_flag(stb_idict* a, int k, int* v);
int stb_idict_get(stb_idict* a, int k);
int stb_idict_set(stb_idict* a, int k, int v);
int stb_idict_add(stb_idict* a, int k, int v);
int stb_idict_update(stb_idict* a, int k, int v);
int stb_idict_remove(stb_idict* a, int k, int* v);

void stb_ptrmap_delete(stb_ptrmap* e, void function(void*) free_func);
stb_ptrmap* stb_ptrmap_new();

stb_idict* stb_idict_new_size(int size);
void stb_idict_remove_all(stb_idict* e);

stb_spmatrix* stb_sparse_ptr_matrix_new(int val_size);
void stb_sparse_ptr_matrix_free(stb_spmatrix* z);
void* stb_sparse_ptr_matrix_get(stb_spmatrix* z, void* a, void* b, int create);

int stb_sdict_init(stb_sdict* h, int count);
int stb_sdict_memory_usage(stb_sdict* h);
stb_sdict* stb_sdict_create();
stb_sdict* stb_sdict_copy(stb_sdict* h);
void stb_sdict_destroy(stb_sdict* h);
int stb_sdict_get_flag(stb_sdict* a, char* k, void** v);
void* stb_sdict_get(stb_sdict* a, char* k);
int stb_sdict_set(stb_sdict* a, char* k, void* v);
int stb_sdict_add(stb_sdict* a, char* k, void* v);
int stb_sdict_update(stb_sdict* a, char* k, void* v);
int stb_sdict_remove(stb_sdict* a, char* k, void** v);

stb_sdict* stb_sdict_new(int use_arena);
stb_sdict* stb_sdict_copy(stb_sdict*);
void stb_sdict_delete(stb_sdict*);
void* stb_sdict_change(stb_sdict*, char* str, void* p);
int stb_sdict_count(stb_sdict* d);

int stb_sdict_internal_limit(stb_sdict* d);
char* stb_sdict_internal_key(stb_sdict* d, int n);
void* stb_sdict_internal_value(stb_sdict* d, int n);

void stb_fput_varlen64(FILE* f, ulong v);
ulong stb_fget_varlen64(FILE* f);
int stb_size_varlen64(ulong v);

void* stb_file(char* filename, size_t* length);
void* stb_file_max(char* filename, size_t* length);
size_t stb_filelen(FILE* f);
int stb_filewrite(char* filename, void* data, size_t length);
int stb_filewritestr(char* filename, char* data);
char** stb_stringfile(char* filename, int* len);
char** stb_stringfile_trimmed(char* name, int* len, char comm);
char* stb_fgets(char* buffer, int buflen, FILE* f);
char* stb_fgets_malloc(FILE* f);
int stb_fexists(char* filename);
int stb_fcmp(char* s1, char* s2);
int stb_feq(char* s1, char* s2);
time_t stb_ftimestamp(char* filename);

int stb_fullpath(char* abs, int abs_size, char* rel);
FILE* stb_fopen(char* filename, char* mode);
int stb_fclose(FILE* f, int keep);

int stb_copyfile(char* src, char* dest);

void stb_fput_varlen64(FILE* f, ulong v);
ulong stb_fget_varlen64(FILE* f);
int stb_size_varlen64(ulong v);

void stb_fwrite32(FILE* f, uint datum);
void stb_fput_varlen(FILE* f, int v);
void stb_fput_varlenu(FILE* f, uint v);
int stb_fget_varlen(FILE* f);
uint stb_fget_varlenu(FILE* f);
void stb_fput_ranged(FILE* f, int v, int b, uint n);
int stb_fget_ranged(FILE* f, int b, uint n);
int stb_size_varlen(int v);
int stb_size_varlenu(uint v);
int stb_size_ranged(int b, uint n);

int stb_fread(void* data, size_t len, size_t count, void* f);
int stb_fwrite(void* data, size_t len, size_t count, void* f);

char** stb_getopt_param(int* argc, char** argv, char* param);
char** stb_getopt(int* argc, char** argv);
void stb_getopt_free(char** opts);

char** stb_readdir_files(in char* dir);
char** stb_readdir_files_mask(in char* dir, in char* wild);
char** stb_readdir_subdirs(in char* dir);
char** stb_readdir_subdirs_mask(in char* dir, in char* wild);
void stb_readdir_free(char** files);
char** stb_readdir_recursive(in char* dir, in char* filespec);
void stb_delete_directory_recursive(in char* dir);

stb_dirtree2* stb_dirtree2_from_files_relative(char* src, char** filelist, int count);
stb_dirtree2* stb_dirtree2_from_files(char** filelist, int count);
int stb_dir_is_prefix(char* dir, int dirlen, char* file);

uint stb_adler32(uint adler32, in void* buffer, uint buflen);
uint stb_crc32_block(uint crc32, in void* buffer, uint len);
uint stb_crc32(in void* buffer, uint len);

void stb_sha1(ref ubyte[20] output, in void* buffer, uint len);
int stb_sha1_file(ref ubyte[20] output, in char *file);
void stb_sha1_readable(ref char[27] display, ref ubyte[20] sha);

void* stb_reg_open(char* mode, char* where);
void stb_reg_close(void* reg);
int stb_reg_read(void* zreg, char* str, void* data, size_t len);
int stb_reg_read_string(void* zreg, char* str, char* data, int len);
void stb_reg_write(void* zreg, char* str, void* data, size_t len);
void stb_reg_write_string(void* zreg, char* str, char* data);

stb_cfg* stb_cfg_open(char* config, char* mode);
void stb_cfg_close(stb_cfg* cfg);
int stb_cfg_read(stb_cfg* cfg, char* key, void* value, int len);
void stb_cfg_write(stb_cfg* cfg, char* key, void* value, int len);
int stb_cfg_read_string(stb_cfg* cfg, char* key, char* value, int len);
void stb_cfg_write_string(stb_cfg* cfg, char* key, char* value);
int stb_cfg_delete(stb_cfg* cfg, char* key);
void stb_cfg_set_directory(char* dir);

void stb_dirtree_free( stb_dirtree* d );
stb_dirtree* stb_dirtree_get( char* dir);
stb_dirtree* stb_dirtree_get_dir( char* dir, char* cache_dir);
stb_dirtree* stb_dirtree_get_with_file( char* dir, char* cache_file);

void stb_dirtree_db_add_dir(stb_dirtree* active, char* path, time_t last);
void stb_dirtree_db_add_file(stb_dirtree* active, char* name, int dir, long size, time_t last);
void stb_dirtree_db_read(stb_dirtree* target, char* filename, char* dir);
void stb_dirtree_db_write(stb_dirtree* target, char* filename, char* dir);

int stb_ps_find(stb_ps* ps, void* value);
stb_ps* stb_ps_add(stb_ps* ps, void* value);
stb_ps* stb_ps_remove(stb_ps* ps, void* value);
stb_ps* stb_ps_remove_any(stb_ps* ps, void** value);
void stb_ps_delete(stb_ps* ps);
int stb_ps_count(stb_ps* ps);

stb_ps* stb_ps_copy(stb_ps* ps);
int stb_ps_subset(stb_ps* bigger, stb_ps* smaller);
int stb_ps_eq(stb_ps* p0, stb_ps* p1);

void** stb_ps_getlist(stb_ps* ps, int* count);
int stb_ps_writelist(stb_ps* ps, void** list, int size );

int stb_ps_enum(stb_ps* ps, void* data, int function(void* value, void* data) func);
void** stb_ps_fastlist(stb_ps* ps, int* count);

size_t stb_srandLCG(size_t seed);
size_t stb_randLCG();
double stb_frandLCG();

void stb_srand(size_t seed);
size_t stb_rand();
double stb_frand();
void stb_shuffle(void* p, size_t n, size_t sz, size_t seed);
void stb_reverse(void* p, size_t n, size_t sz);

size_t stb_randLCG_explicit(size_t seed);

void stb_dupe_free(stb_dupe* sd);
stb_dupe* stb_dupe_create(stb_hash_func hash,
	stb_compare_func eq, int size, stb_compare_func ineq);
void stb_dupe_add(stb_dupe* sd, void* item);
void stb_dupe_finish(stb_dupe* sd);
int stb_dupe_numsets(stb_dupe* sd);
void** stb_dupe_set(stb_dupe* sd, int num);
int stb_dupe_set_count(stb_dupe* sd, int num);

stb_bitset* stb_bitset_new(int value, int len);
stb_bitset* stb_bitset_union(stb_bitset* p0, stb_bitset* p1, int len);

int* stb_bitset_getlist(stb_bitset* out_, int start, int end);

int stb_bitset_eq(stb_bitset* p0, stb_bitset* p1, int len);
int stb_bitset_disjoint(stb_bitset* p0, stb_bitset* p1, int len);
int stb_bitset_disjoint_0(stb_bitset* p0, stb_bitset* p1, int len);
int stb_bitset_subset(stb_bitset* bigger, stb_bitset* smaller, int len);
int stb_bitset_unioneq_changed(stb_bitset* p0, stb_bitset* p1, int len);

int stb_wordwrap(int* pairs, int pair_max, int count, char* str);
int* stb_wordwrapalloc(int count, char* str);

int stb_wildmatch(char* expr, char* candidate);
int stb_wildmatchi(char* expr, char* candidate);
int stb_wildfind(char* expr, char* candidate);
int stb_wildfindi(char* expr, char* candidate);

int stb_regex(char* regex, char* candidate);

stb_matcher* stb_regex_matcher(char* regex);
int stb_matcher_match(stb_matcher* m, char* str);
int stb_matcher_find(stb_matcher* m, char* str);
void stb_matcher_free(stb_matcher* f);

stb_matcher* stb_lex_matcher();
int stb_lex_item(stb_matcher* m, char* str, int result);
int stb_lex_item_wild(stb_matcher* matcher, char* regex, int result);
int stb_lex(stb_matcher* m, char* str, int* len);

uint stb_decompress_length(void* input);
uint stb_decompress(void* out_, void* in_, uint len);
uint stb_compress(void* out_, void* in_, uint len);
void stb_compress_window(int z);
void stb_compress_hashsize(uint z);

int stb_compress_tofile(char* filename, char* in_, uint len);
int stb_compress_intofile(FILE* f, char* input, uint len);
char* stb_decompress_fromfile(char* filename, uint* len);

int stb_compress_stream_start(FILE* f);
void stb_compress_stream_end(int close);
void stb_write(char* data, int data_len);

uint stb_getc(stbfile* f);
int stb_putc(stbfile* f, int ch);
uint stb_getdata(stbfile* f, void* buffer, uint len);
uint stb_putdata(stbfile* f, void* buffer, uint len);
uint stb_tell(stbfile* f);
uint stb_size(stbfile* f);
void stb_backpatch(stbfile* f, uint tell, void* buffer, uint len);

void stb_arith_init_encode(stb_arith* a, stbfile* out_);
void stb_arith_init_decode(stb_arith* a, stbfile* in_);
stbfile* stb_arith_encode_close(stb_arith* a);
stbfile* stb_arith_decode_close(stb_arith* a);

void stb_arith_encode(stb_arith* a, uint totalfreq, uint freq, uint cumfreq);
void stb_arith_encode_log2(stb_arith* a, uint totalfreq2, uint freq, uint cumfreq);
uint stb_arith_decode_value(stb_arith* a, uint totalfreq);
void stb_arith_decode_advance(stb_arith* a, uint totalfreq, uint freq, uint cumfreq);
uint stb_arith_decode_value_log2(stb_arith* a, uint totalfreq2);
void stb_arith_decode_advance_log2(stb_arith* a, uint totalfreq2, uint freq, uint cumfreq);

void stb_arith_encode_byte(stb_arith* a, int byte_);
int stb_arith_decode_byte(stb_arith* a);

void stb_thread_cleanup();

int stb_processor_count();

void stb_force_uniprocessor();

void stb_work_numthreads(int n);

int stb_work_maxunits(int n);

int stb_work(stb_thread_func f, void* d, /*volatile*/ void** return_code);

int stb_work_reach(stb_thread_func f, void* d, /*volatile*/ void** return_code, stb_sync rel);

void stb_barrier();

stb_workqueue* stb_workq_new(int numthreads, int max_units);
stb_workqueue* stb_workq_new_flags(int numthreads, int max_units, int no_add_mutex, int no_remove_mutex);
void stb_workq_delete(stb_workqueue* q);
void stb_workq_numthreads(stb_workqueue* q, int n);
int stb_workq(stb_workqueue* q, stb_thread_func f, void* d, /*volatile*/ void** return_code);
int stb_workq_reach(stb_workqueue* q, stb_thread_func f, void* d, /*volatile*/ void** return_code, stb_sync rel);
int stb_workq_length(stb_workqueue* q);

stb_thread stb_create_thread(stb_thread_func f, void* d);
stb_thread stb_create_thread2(stb_thread_func f, void* d, /*volatile*/ void** return_code, stb_semaphore rel);
void stb_destroy_thread(stb_thread t);

stb_semaphore stb_sem_new(int max_val);
stb_semaphore stb_sem_new_extra(int max_val, int start_val);
void stb_sem_delete(stb_semaphore s);
void stb_sem_waitfor(stb_semaphore s);
void stb_sem_release(stb_semaphore s);

stb_mutex stb_mutex_new();
void stb_mutex_delete(stb_mutex m);
void stb_mutex_begin(stb_mutex m);
void stb_mutex_end(stb_mutex m);

stb_sync stb_sync_new();
void stb_sync_delete(stb_sync s);
int stb_sync_set_target(stb_sync s, int count);
void stb_sync_reach_and_wait(stb_sync s);
int stb_sync_reach(stb_sync s);

stb_threadqueue* stb_threadq_new(int item_size, int num_items, int many_add, int many_remove);
void stb_threadq_delete(stb_threadqueue* tq);
int stb_threadq_get(stb_threadqueue* tq, void* output);
void stb_threadq_get_block(stb_threadqueue* tq, void* output);
int stb_threadq_add(stb_threadqueue* tq, void* input);

int stb_threadq_add_block(stb_threadqueue* tq, void* input);

void stb_source_path(char* str);
