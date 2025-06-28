module bindbc.libvlc.types;

import core.stdc.stdint;
import core.stdc.stdarg;

alias ssize_t = ptrdiff_t;

// libvlc.h

alias libvlc_time_t = int64_t;
alias libvlc_event_type_t = int;

enum libvlc_log_level
{
    LIBVLC_DEBUG = 0,
    LIBVLC_NOTICE = 2,
    LIBVLC_WARNING = 3,
    LIBVLC_ERROR = 4
}

struct libvlc_instance_t;
struct libvlc_event_manager_t;
struct libvlc_event_t;
struct libvlc_log_t;
alias vlc_log_t = libvlc_log_t;

struct libvlc_module_description_t
{
    char* psz_name;
    char* psz_shortname;
    char* psz_longname;
    char* psz_help;
    libvlc_module_description_t* p_next;
}

extern(C)
{
    alias libvlc_callback_t = void function(const(libvlc_event_t)* p_event, void* p_data);
    alias libvlc_log_cb = void function(void* data, int level, const(libvlc_log_t)* ctx, const(char)* fmt, va_list args);
    alias libvlc_exit_handler_callback_t = void function(void*);
}

// libvlc_media.h

struct libvlc_media_t;

enum libvlc_meta_t
{
    libvlc_meta_Title,
    libvlc_meta_Artist,
    libvlc_meta_Genre,
    libvlc_meta_Copyright,
    libvlc_meta_Album,
    libvlc_meta_TrackNumber,
    libvlc_meta_Description,
    libvlc_meta_Rating,
    libvlc_meta_Date,
    libvlc_meta_Setting,
    libvlc_meta_URL,
    libvlc_meta_Language,
    libvlc_meta_NowPlaying,
    libvlc_meta_Publisher,
    libvlc_meta_EncodedBy,
    libvlc_meta_ArtworkURL,
    libvlc_meta_TrackID,
    libvlc_meta_TrackTotal,
    libvlc_meta_Director,
    libvlc_meta_Season,
    libvlc_meta_Episode,
    libvlc_meta_ShowName,
    libvlc_meta_Actors,
    libvlc_meta_AlbumArtist,
    libvlc_meta_DiscNumber,
    libvlc_meta_DiscTotal
}

enum libvlc_state_t
{
    libvlc_NothingSpecial = 0,
    libvlc_Opening,
    libvlc_Buffering,
    libvlc_Playing,
    libvlc_Paused,
    libvlc_Stopped,
    libvlc_Ended,
    libvlc_Error
}

enum
{
    libvlc_media_option_trusted = 0x2,
    libvlc_media_option_unique = 0x100
}

enum libvlc_track_type_t
{
    libvlc_track_unknown   = -1,
    libvlc_track_audio     = 0,
    libvlc_track_video     = 1,
    libvlc_track_text      = 2
}

struct libvlc_media_stats_t
{
    int   i_read_bytes;
    float f_input_bitrate;
    int   i_demux_read_bytes;
    float f_demux_bitrate;
    int   i_demux_corrupted;
    int   i_demux_discontinuity;
    int   i_decoded_video;
    int   i_decoded_audio;
    int   i_displayed_pictures;
    int   i_lost_pictures;
    int   i_played_abuffers;
    int   i_lost_abuffers;
    int   i_sent_packets;
    int   i_sent_bytes;
    float f_send_bitrate;
}

struct libvlc_media_track_info_t
{
    uint32_t i_codec;
    int i_id;
    libvlc_track_type_t i_type;
    int i_profile;
    int i_level;

    union
    {
        struct audio
        {
            uint i_channels;
            uint i_rate;
        }
        
        struct video
        {
            uint i_height;
            uint i_width;
        }
    }
}

struct libvlc_audio_track_t
{
    uint i_channels;
    uint i_rate;
}

enum libvlc_video_orient_t
{
    libvlc_video_orient_top_left,
    libvlc_video_orient_top_right,
    libvlc_video_orient_bottom_left,
    libvlc_video_orient_bottom_right,
    libvlc_video_orient_left_top,
    libvlc_video_orient_left_bottom,
    libvlc_video_orient_right_top,
    libvlc_video_orient_right_bottom
}

enum libvlc_video_projection_t
{
    libvlc_video_projection_rectangular,
    libvlc_video_projection_equirectangular,
    libvlc_video_projection_cubemap_layout_standard = 0x100
}

struct libvlc_video_viewpoint_t
{
    float f_yaw;
    float f_pitch;
    float f_roll;
    float f_field_of_view;
}

struct libvlc_video_track_t
{
    uint i_height;
    uint i_width;
    uint i_sar_num;
    uint i_sar_den;
    uint i_frame_rate_num;
    uint i_frame_rate_den;
    libvlc_video_orient_t i_orientation;
    libvlc_video_projection_t i_projection;
    libvlc_video_viewpoint_t pose;
}

struct libvlc_subtitle_track_t
{
    char* psz_encoding;
}

struct libvlc_media_track_t
{
    uint32_t i_codec;
    uint32_t i_original_fourcc;
    int i_id;
    libvlc_track_type_t i_type;
    int i_profile;
    int i_level;
    union
    {
        libvlc_audio_track_t* audio;
        libvlc_video_track_t* video;
        libvlc_subtitle_track_t* subtitle;
    }
    uint i_bitrate;
    char* psz_language;
    char* psz_description;
}

enum libvlc_media_type_t
{
    libvlc_media_type_unknown,
    libvlc_media_type_file,
    libvlc_media_type_directory,
    libvlc_media_type_disc,
    libvlc_media_type_stream,
    libvlc_media_type_playlist
}

enum libvlc_media_parse_flag_t
{
    libvlc_media_parse_local    = 0x00,
    libvlc_media_parse_network  = 0x01,
    libvlc_media_fetch_local    = 0x02,
    libvlc_media_fetch_network  = 0x04,
    libvlc_media_do_interact    = 0x08
}

enum libvlc_media_parsed_status_t
{
    libvlc_media_parsed_status_skipped = 1,
    libvlc_media_parsed_status_failed,
    libvlc_media_parsed_status_timeout,
    libvlc_media_parsed_status_done
}

enum libvlc_media_slave_type_t
{
    libvlc_media_slave_type_subtitle,
    libvlc_media_slave_type_audio
}

struct libvlc_media_slave_t
{
    char* psz_uri;
    libvlc_media_slave_type_t i_type;
    uint i_priority;
}

struct libvlc_media_list_t;

extern(C)
{
    alias libvlc_media_open_cb = int function(void* opaque, void** datap, uint64_t* sizep);
    alias libvlc_media_read_cb = ssize_t function(void* opaque, ubyte* buf, size_t len);
    alias libvlc_media_seek_cb = int function(void* opaque, uint64_t offset);
    alias libvlc_media_close_cb = void function(void* opaque);
}

// libvlc_media_player.h

struct libvlc_media_player_t;

extern(C)
{
    alias libvlc_video_lock_cb = void* function(void* opaque, void** planes);
    alias libvlc_video_unlock_cb = void function(void* opaque, void* picture, const(void)** planes);
    alias libvlc_video_display_cb = void function(void* opaque, void* picture);
}
