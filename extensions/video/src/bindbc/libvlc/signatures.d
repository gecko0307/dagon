module bindbc.libvlc.signatures;

import core.stdc.stdint;
import core.stdc.stdarg;
import std.stdio;

import bindbc.libvlc.types;

extern(C):

// libvlc.h
alias f_libvlc_errmsg = const(char)* function();
alias f_libvlc_clearerr = void function();
alias f_libvlc_vprinterr = const(char)* function(const(char)* fmt, va_list ap);
alias f_libvlc_printerr = const(char)* function(const(char)* fmt, ...);
alias f_libvlc_new = libvlc_instance_t* function(int argc, const(char)** argv);
alias f_libvlc_release = void function(libvlc_instance_t* p_instance);
alias f_libvlc_retain = void function(libvlc_instance_t* p_instance);
alias f_libvlc_add_intf = int function(libvlc_instance_t* p_instance, const(char)* name);
alias f_libvlc_set_exit_handler = void function(libvlc_instance_t* p_instance, libvlc_exit_handler_callback_t callback, void* opaque);
alias f_libvlc_set_user_agent = void function(libvlc_instance_t* p_instance, const(char)* name, const(char)* http);
alias f_libvlc_set_app_id = void function(libvlc_instance_t* p_instance, const(char)* id, const(char)* ver, const(char)* icon);
alias f_libvlc_get_version = const(char)* function();
alias f_libvlc_get_compiler = const(char)* function();
alias f_libvlc_get_changeset = const(char)* function();
alias f_libvlc_free = void function(void* ptr);
alias f_libvlc_event_attach = int function(
    libvlc_event_manager_t* p_event_manager,
    libvlc_event_type_t i_event_type,
    libvlc_callback_t f_callback,
    void* user_data);
alias f_libvlc_event_detach = void function(
    libvlc_event_manager_t* p_event_manager,
    libvlc_event_type_t i_event_type,
    libvlc_callback_t f_callback,
    void* p_user_data);
alias f_libvlc_event_type_name = const(char)* function(libvlc_event_type_t event_type);
alias f_libvlc_log_get_context = void function(const(libvlc_log_t)* ctx, const(char)** modul, const(char)** file, uint* line);
alias f_libvlc_log_get_object = void function(const(libvlc_log_t)* ctx, const(char)** name, const(char)** header, uintptr_t* id);
alias f_libvlc_log_unset = void function(libvlc_instance_t* p_instance);
alias f_libvlc_log_set = void function(libvlc_instance_t* p_instance, libvlc_log_cb cb, void* data);
alias f_libvlc_log_set_file = void function(libvlc_instance_t* p_instance, FILE* stream);
alias f_libvlc_module_description_list_release = void function(libvlc_module_description_t* p_list);
alias f_libvlc_audio_filter_list_get = libvlc_module_description_t* function(libvlc_instance_t* p_instance);
alias f_libvlc_video_filter_list_get = libvlc_module_description_t* function(libvlc_instance_t* p_instance);
alias f_libvlc_clock = int64_t function();

// libvlc_media.h
alias f_libvlc_media_new_location = libvlc_media_t* function(libvlc_instance_t* p_instance, const(char)* psz_mrl);
alias f_libvlc_media_new_path = libvlc_media_t* function(libvlc_instance_t* p_instance, const(char)* path);
alias f_libvlc_media_new_fd = libvlc_media_t* function(libvlc_instance_t* p_instance, int fd);
alias f_libvlc_media_new_callbacks = libvlc_media_t* function(
    libvlc_instance_t* instance,
    libvlc_media_open_cb open_cb,
    libvlc_media_read_cb read_cb,
    libvlc_media_seek_cb seek_cb,
    libvlc_media_close_cb close_cb,
    void* opaque);
alias f_libvlc_media_new_as_node = libvlc_media_t* function(libvlc_instance_t* p_instance, const(char)* psz_name);
alias f_libvlc_media_add_option = void function(libvlc_media_t* p_md, const(char)* psz_options);
alias f_libvlc_media_add_option_flag = void function(libvlc_media_t* p_md, const(char)* psz_options, uint i_flags);
alias f_libvlc_media_retain = void function(libvlc_media_t* p_md);
alias f_libvlc_media_release = void function(libvlc_media_t* p_md);
alias f_libvlc_media_get_mrl = char* function(libvlc_media_t* p_md);
alias f_libvlc_media_duplicate = libvlc_media_t* function(libvlc_media_t* p_md);
alias f_libvlc_media_get_meta = char* function(libvlc_media_t* p_md, libvlc_meta_t e_meta);
alias f_libvlc_media_set_meta = void function(libvlc_media_t* p_md, libvlc_meta_t e_meta, const(char)* psz_value);
alias f_libvlc_media_save_meta = int function(libvlc_media_t* p_md);
alias f_libvlc_media_get_state = libvlc_state_t function(libvlc_media_t* p_md);
alias f_libvlc_media_get_stats = int function(libvlc_media_t* p_md, libvlc_media_stats_t* p_stats);
alias f_libvlc_media_subitems = libvlc_media_list_t* function(libvlc_media_t* p_md);
alias f_libvlc_media_event_manager = libvlc_event_manager_t* function(libvlc_media_t* p_md);
alias f_libvlc_media_get_duration = libvlc_time_t function(libvlc_media_t* p_md);
alias f_libvlc_media_parse_with_options = int function(libvlc_media_t *p_md, libvlc_media_parse_flag_t parse_flag, int timeout);
alias f_libvlc_media_parse_stop = void function(libvlc_media_t* p_md);
alias f_libvlc_media_get_parsed_status = libvlc_media_parsed_status_t function(libvlc_media_t* p_md);
alias f_libvlc_media_set_user_data = void function(libvlc_media_t* p_md, void* p_new_user_data);
alias f_libvlc_media_get_user_data = void* function(libvlc_media_t* p_md);
alias f_libvlc_media_tracks_get = uint function(libvlc_media_t* p_md, libvlc_media_track_t*** tracks);
alias f_libvlc_media_get_codec_description = const(char)* function(libvlc_track_type_t i_type, uint32_t i_codec);
alias f_libvlc_media_tracks_release = void function(libvlc_media_track_t** p_tracks, uint i_count);
alias f_libvlc_media_get_type = libvlc_media_type_t function(libvlc_media_t* p_md);
alias f_libvlc_media_slaves_add = int function(
    libvlc_media_t* p_md,
    libvlc_media_slave_type_t i_type,
    uint i_priority,
    const(char)* psz_uri);
alias f_libvlc_media_slaves_clear = void function(libvlc_media_t* p_md);
alias f_libvlc_media_slaves_get = uint function(libvlc_media_t* p_md, libvlc_media_slave_t*** ppp_slaves);
alias f_libvlc_media_slaves_release = void function(libvlc_media_slave_t** pp_slaves, uint i_count);

// libvlc_media_player.h
alias f_libvlc_media_player_new = libvlc_media_player_t* function(libvlc_instance_t* p_libvlc_instance);
alias f_libvlc_media_player_new_from_media = libvlc_media_player_t* function(libvlc_media_t* p_md);
alias f_libvlc_media_player_release = void function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_retain = void function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_media = void function(libvlc_media_player_t* p_mi, libvlc_media_t* p_md);
alias f_libvlc_media_player_get_media = libvlc_media_t* function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_event_manager = libvlc_event_manager_t* function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_is_playing = int function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_play = int function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_pause = void function(libvlc_media_player_t* mp, int do_pause);
alias f_libvlc_media_player_pause = void function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_stop = void function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_renderer = int function(libvlc_media_player_t* p_mi, libvlc_renderer_item_t* p_item);
alias f_libvlc_video_set_callbacks = void function(
    libvlc_media_player_t* mp,
    libvlc_video_lock_cb lock,
    libvlc_video_unlock_cb unlock,
    libvlc_video_display_cb display,
    void* opaque);
alias f_libvlc_video_set_format = void function(libvlc_media_player_t* mp, const(char)* chroma, uint width, uint height, uint pitch);
alias f_libvlc_video_set_format_callbacks = void function(libvlc_media_player_t* mp, libvlc_video_format_cb setup, libvlc_video_cleanup_cb cleanup);
alias f_libvlc_media_player_set_nsobject = void function(libvlc_media_player_t* p_mi, void* drawable);
alias f_libvlc_media_player_get_nsobject = void* function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_xwindow = void function(libvlc_media_player_t* p_mi, uint32_t drawable);
alias f_libvlc_media_player_get_xwindow = uint32_t function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_hwnd = void function(libvlc_media_player_t* p_mi, void* drawable);
alias f_libvlc_media_player_get_hwnd = void* function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_android_context = void function(libvlc_media_player_t* p_mi, void* p_awindow_handler);
alias f_libvlc_media_player_set_evas_object = int function(libvlc_media_player_t* p_mi, void* p_evas_object);
alias f_libvlc_audio_set_callbacks = void function(
    libvlc_media_player_t* mp,
    libvlc_audio_play_cb play,
    libvlc_audio_pause_cb pause,
    libvlc_audio_resume_cb resume,
    libvlc_audio_flush_cb flush,
    libvlc_audio_drain_cb drain,
    void* opaque);
alias f_libvlc_audio_set_volume_callback = void function(libvlc_media_player_t* mp, libvlc_audio_set_volume_cb set_volume);

/*
void libvlc_audio_set_format_callbacks( libvlc_media_player_t *mp, libvlc_audio_setup_cb setup, libvlc_audio_cleanup_cb cleanup );
void libvlc_audio_set_format( libvlc_media_player_t *mp, const char *format, unsigned rate, unsigned channels );
libvlc_time_t libvlc_media_player_get_length( libvlc_media_player_t *p_mi );
libvlc_time_t libvlc_media_player_get_time( libvlc_media_player_t *p_mi );
void libvlc_media_player_set_time( libvlc_media_player_t *p_mi, libvlc_time_t i_time );
*/

alias f_libvlc_media_player_get_position = float function(libvlc_media_player_t* p_mi);

/*
void libvlc_media_player_set_position( libvlc_media_player_t *p_mi, float f_pos );
void libvlc_media_player_set_chapter( libvlc_media_player_t *p_mi, int i_chapter );
int libvlc_media_player_get_chapter( libvlc_media_player_t *p_mi );
int libvlc_media_player_get_chapter_count( libvlc_media_player_t *p_mi );
*/

alias f_libvlc_media_player_will_play = int function(libvlc_media_player_t* p_mi);

/*
int libvlc_media_player_get_chapter_count_for_title(libvlc_media_player_t *p_mi, int i_title );
void libvlc_media_player_set_title( libvlc_media_player_t *p_mi, int i_title );
int libvlc_media_player_get_title( libvlc_media_player_t *p_mi );
int libvlc_media_player_get_title_count( libvlc_media_player_t *p_mi );
void libvlc_media_player_previous_chapter( libvlc_media_player_t *p_mi );
void libvlc_media_player_next_chapter( libvlc_media_player_t *p_mi );
float libvlc_media_player_get_rate( libvlc_media_player_t *p_mi );
int libvlc_media_player_set_rate( libvlc_media_player_t *p_mi, float rate );
*/

alias f_libvlc_media_player_get_state = libvlc_state_t function(libvlc_media_player_t* p_mi);

/*
unsigned libvlc_media_player_has_vout( libvlc_media_player_t *p_mi );
int libvlc_media_player_is_seekable( libvlc_media_player_t *p_mi );
int libvlc_media_player_can_pause( libvlc_media_player_t *p_mi );
int libvlc_media_player_program_scrambled( libvlc_media_player_t *p_mi );
void libvlc_media_player_next_frame( libvlc_media_player_t *p_mi );
void libvlc_media_player_navigate( libvlc_media_player_t* p_mi, unsigned navigate );
void libvlc_media_player_set_video_title_display( libvlc_media_player_t *p_mi, libvlc_position_t position, unsigned int timeout );
int libvlc_media_player_add_slave( libvlc_media_player_t *p_mi, libvlc_media_slave_type_t i_type, const char *psz_uri, bool b_select );
void libvlc_track_description_list_release( libvlc_track_description_t *p_track_description );
void libvlc_toggle_fullscreen( libvlc_media_player_t *p_mi );
void libvlc_set_fullscreen( libvlc_media_player_t *p_mi, int b_fullscreen );
int libvlc_get_fullscreen( libvlc_media_player_t *p_mi );
void libvlc_video_set_key_input( libvlc_media_player_t *p_mi, unsigned on );
void libvlc_video_set_mouse_input( libvlc_media_player_t *p_mi, unsigned on );
*/

alias f_libvlc_video_get_size = int function(libvlc_media_player_t* p_mi, uint num, uint* px, uint* py);

/*
int libvlc_video_get_cursor( libvlc_media_player_t *p_mi, unsigned num, int *px, int *py );
float libvlc_video_get_scale( libvlc_media_player_t *p_mi );
*/

alias f_libvlc_video_set_scale = void function(libvlc_media_player_t* p_mi, float f_factor);

/*
char *libvlc_video_get_aspect_ratio( libvlc_media_player_t *p_mi );
void libvlc_video_set_aspect_ratio( libvlc_media_player_t *p_mi, const char *psz_aspect );
libvlc_video_viewpoint_t *libvlc_video_new_viewpoint();
int libvlc_video_update_viewpoint( libvlc_media_player_t *p_mi, const libvlc_video_viewpoint_t *p_viewpoint, bool b_absolute);
int libvlc_video_get_spu( libvlc_media_player_t *p_mi );
int libvlc_video_get_spu_count( libvlc_media_player_t *p_mi );
libvlc_track_description_t * libvlc_video_get_spu_description( libvlc_media_player_t *p_mi );
int libvlc_video_set_spu( libvlc_media_player_t *p_mi, int i_spu );
int64_t libvlc_video_get_spu_delay( libvlc_media_player_t *p_mi );
int libvlc_video_set_spu_delay( libvlc_media_player_t *p_mi, int64_t i_delay );
int libvlc_media_player_get_full_title_descriptions( libvlc_media_player_t *p_mi, libvlc_title_description_t ***titles );
void libvlc_title_descriptions_release( libvlc_title_description_t **p_titles, unsigned i_count );
int libvlc_media_player_get_full_chapter_descriptions(libvlc_media_player_t *p_mi, int i_chapters_of_title, libvlc_chapter_description_t *** pp_chapters );
void libvlc_chapter_descriptions_release( libvlc_chapter_description_t **p_chapters, unsigned i_count );
char *libvlc_video_get_crop_geometry( libvlc_media_player_t *p_mi );
void libvlc_video_set_crop_geometry( libvlc_media_player_t *p_mi, const char *psz_geometry );
int libvlc_video_get_teletext( libvlc_media_player_t *p_mi );
void libvlc_video_set_teletext( libvlc_media_player_t *p_mi, int i_page );
int libvlc_video_get_track_count( libvlc_media_player_t *p_mi );
libvlc_track_description_t * libvlc_video_get_track_description( libvlc_media_player_t *p_mi );
int libvlc_video_get_track( libvlc_media_player_t *p_mi );
int libvlc_video_set_track( libvlc_media_player_t *p_mi, int i_track );
int libvlc_video_take_snapshot(
    libvlc_media_player_t *p_mi,
    unsigned num,
    const char *psz_filepath,
    unsigned int i_width,
    unsigned int i_height );
void libvlc_video_set_deinterlace( libvlc_media_player_t *p_mi, const char *psz_mode );
int libvlc_video_get_marquee_int( libvlc_media_player_t *p_mi, unsigned option );
char *libvlc_video_get_marquee_string( libvlc_media_player_t *p_mi, unsigned option );
void libvlc_video_set_marquee_int( libvlc_media_player_t *p_mi, unsigned option, int i_val );
void libvlc_video_set_marquee_string( libvlc_media_player_t *p_mi, unsigned option, const char *psz_text );
int libvlc_video_get_logo_int( libvlc_media_player_t *p_mi, unsigned option );
void libvlc_video_set_logo_int( libvlc_media_player_t *p_mi, unsigned option, int value );
void libvlc_video_set_logo_string( libvlc_media_player_t *p_mi, unsigned option, const char *psz_value );
int libvlc_video_get_adjust_int( libvlc_media_player_t *p_mi, unsigned option );
void libvlc_video_set_adjust_int( libvlc_media_player_t *p_mi, unsigned option, int value );
float libvlc_video_get_adjust_float( libvlc_media_player_t *p_mi, unsigned option );
void libvlc_video_set_adjust_float( libvlc_media_player_t *p_mi, unsigned option, float value );
libvlc_audio_output_t * libvlc_audio_output_list_get( libvlc_instance_t *p_instance );
void libvlc_audio_output_list_release( libvlc_audio_output_t *p_list );
int libvlc_audio_output_set( libvlc_media_player_t *p_mi, const char *psz_name );
libvlc_audio_output_device_t * libvlc_audio_output_device_enum( libvlc_media_player_t *mp );
libvlc_audio_output_device_t * libvlc_audio_output_device_list_get( libvlc_instance_t *p_instance, const char *aout );
void libvlc_audio_output_device_list_release(libvlc_audio_output_device_t *p_list );
void libvlc_audio_output_device_set( libvlc_media_player_t *mp, const char *modul, const char *device_id );
char *libvlc_audio_output_device_get( libvlc_media_player_t *mp );
*/

alias f_libvlc_audio_toggle_mute = void function(libvlc_media_player_t* p_mi);

/*
int libvlc_audio_get_mute( libvlc_media_player_t *p_mi );
void libvlc_audio_set_mute( libvlc_media_player_t *p_mi, int status );
int libvlc_audio_get_volume( libvlc_media_player_t *p_mi );
*/

alias f_libvlc_audio_set_volume = int function(libvlc_media_player_t* p_mi, int i_volume);

/*
int libvlc_audio_get_track_count( libvlc_media_player_t *p_mi );
libvlc_track_description_t * libvlc_audio_get_track_description( libvlc_media_player_t *p_mi );
int libvlc_audio_get_track( libvlc_media_player_t *p_mi );
int libvlc_audio_set_track( libvlc_media_player_t *p_mi, int i_track );
int libvlc_audio_get_channel( libvlc_media_player_t *p_mi );
int libvlc_audio_set_channel( libvlc_media_player_t *p_mi, int channel );
int64_t libvlc_audio_get_delay( libvlc_media_player_t *p_mi );
int libvlc_audio_set_delay( libvlc_media_player_t *p_mi, int64_t i_delay );
unsigned libvlc_audio_equalizer_get_preset_count();
const char *libvlc_audio_equalizer_get_preset_name( unsigned u_index );
unsigned libvlc_audio_equalizer_get_band_count();
float libvlc_audio_equalizer_get_band_frequency( unsigned u_index );
libvlc_equalizer_t *libvlc_audio_equalizer_new();
libvlc_equalizer_t *libvlc_audio_equalizer_new_from_preset( unsigned u_index );
void libvlc_audio_equalizer_release( libvlc_equalizer_t *p_equalizer );
int libvlc_audio_equalizer_set_preamp( libvlc_equalizer_t *p_equalizer, float f_preamp );
float libvlc_audio_equalizer_get_preamp( libvlc_equalizer_t *p_equalizer );
int libvlc_audio_equalizer_set_amp_at_index( libvlc_equalizer_t *p_equalizer, float f_amp, unsigned u_band );
float libvlc_audio_equalizer_get_amp_at_index( libvlc_equalizer_t *p_equalizer, unsigned u_band );
int libvlc_media_player_set_equalizer( libvlc_media_player_t *p_mi, libvlc_equalizer_t *p_equalizer );
int libvlc_media_player_get_role(libvlc_media_player_t *p_mi);
int libvlc_media_player_set_role(libvlc_media_player_t *p_mi, unsigned role);
*/
