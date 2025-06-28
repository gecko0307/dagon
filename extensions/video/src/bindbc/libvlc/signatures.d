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
alias f_libvlc_media_player_new_from_media = libvlc_media_player_t* function(libvlc_media_t* p_md);
alias f_libvlc_video_get_size = int function(libvlc_media_player_t* p_mi, uint num, uint* px, uint* py);
alias f_libvlc_video_set_callbacks = void function(
    libvlc_media_player_t* mp,
    libvlc_video_lock_cb lock,
    libvlc_video_unlock_cb unlock,
    libvlc_video_display_cb display,
    void* opaque);
alias f_libvlc_media_player_play = int function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_is_playing = int function(libvlc_media_player_t* p_mi);
alias f_libvlc_media_player_set_hwnd = void function(libvlc_media_player_t* p_mi, void* drawable);
alias f_libvlc_video_set_scale = void function(libvlc_media_player_t* p_mi, float f_factor);
alias f_libvlc_video_set_format = void function(libvlc_media_player_t* mp, const(char)* chroma, uint width, uint height, uint pitch);
