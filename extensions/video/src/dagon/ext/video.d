module dagon.ext.video;

import std.stdio;
import std.conv;
import std.string;
import std.process;
import std.path;

import dlib.core.memory;
import dlib.core.ownership;
import dagon.core.bindings;
import dagon.core.logger;
import dagon.graphics.texture;

public import bindbc.libvlc;

class VideoManager: Owner
{
    LogLevel logLevel = LogLevel.Error;
    libvlc_instance_t* vlc;
    bool valid = false;
    
    this(Owner owner)
    {
        super(owner);
        
        version(linux)
        {
            setLinuxPluginsPath(absolutePath("./plugins_linux"));
        }
        
        auto ver = libvlc_get_version();
        logInfo("libVLC version: ", ver.to!string());
        
        string autoscale = "--autoscale";
        const(char)*[] vlcargs = [
            autoscale.ptr
        ];
        
        vlc = libvlc_new(cast(int)vlcargs.length, vlcargs.ptr);
        if (vlc is null)
            logError("Failed to create libVLC instance (missing plugins?)");
        else
            valid = true;
        
        if (valid)
        {
            libvlc_log_set(vlc, &vlcLog, cast(void*)this);
        }
        
        debug
        {
            logLevel = LogLevel.All;
        }
    }
    
    void setLinuxPluginsPath(string path)
    {
        environment["VLC_PLUGIN_PATH"] = path;
    }
    
    ~this()
    {
        if (vlc)
            libvlc_release(vlc);
    }
}

class Video: Owner
{
    VideoManager manager;
    uint width;
    uint height;
    ubyte[] outputBuffer;
    Texture texture;
    libvlc_media_t* media;
    libvlc_media_player_t* player;
    bool locked = false;
    bool needsUploading = false;
    
    this(VideoManager manager, uint width, uint height, Owner owner)
    {
        super(owner);
        this.manager = manager;
        this.width = width;
        this.height = height;
        
        outputBuffer = New!(ubyte[])(width * height * 4);
        
        texture = New!Texture(this);
        TextureBuffer buffer = {
            format: {
                target: GL_TEXTURE_2D,
                format: GL_BGRA,
                internalFormat: GL_RGBA8,
                pixelType: GL_UNSIGNED_BYTE,
                blockSize: 0,
                cubeFaces: CubeFaceBit.None
            },
            size: {
                width: width,
                height: height,
                depth: 0
            },
            mipLevels: 1,
            data: outputBuffer
        };
        texture.createFromBuffer(buffer, false);
    }
    
    bool open(string filename)
    {
        if (!manager.valid)
            return false;
        
        stop();
        release();
        
        media = libvlc_media_new_path(manager.vlc, filename.toStringz);
        if (media is null)
        {
            logError(libvlc_errmsg().to!string());
            return false;
        }
        
        player = libvlc_media_player_new_from_media(media);
        if (player is null)
        {
            logError(libvlc_errmsg().to!string());
            libvlc_media_release(media);
            media = null;
            return false;
        }
        
        libvlc_video_set_callbacks(player, &lock, &unlock, &display, cast(void*)this);
        libvlc_video_set_format(player, "RV32", width, height, width * 4);
        
        return true;
    }
    
    void play()
    {
        if (player)
            libvlc_media_player_play(player);
    }
    
    void pause()
    {
        if (player)
            libvlc_media_player_set_pause(player, 1);
    }
    
    void resume()
    {
        if (player)
            libvlc_media_player_set_pause(player, 0);
    }
    
    void stop()
    {
        if (player)
            libvlc_media_player_stop(player);
    }
    
    float position() @property
    {
        if (player)
            return libvlc_media_player_get_position(player);
        else
            return -1.0f;
    }
    
    bool willPlay() @property
    {
        if (player)
            return cast(bool)libvlc_media_player_will_play(player);
        else
            return false;
    }
    
    auto getState() @property
    {
        if (player)
            return libvlc_media_player_get_state(player);
        else
            return libvlc_state_t.libvlc_NothingSpecial;
    }
    
    bool isPlaying() @property
    {
        if (player)
        {
            libvlc_state_t state = libvlc_media_player_get_state(player);
            return state == libvlc_state_t.libvlc_Playing;
        }
        else
            return false;
    }
    
    bool isPaused() @property
    {
        if (player)
        {
            libvlc_state_t state = libvlc_media_player_get_state(player);
            return state == libvlc_state_t.libvlc_Paused;
        }
        else
            return false;
    }
    
    bool isStopped() @property
    {
        if (player)
        {
            libvlc_state_t state = libvlc_media_player_get_state(player);
            return state == libvlc_state_t.libvlc_Stopped;
        }
        else
            return false;
    }
    
    bool isEnded() @property
    {
        if (player)
        {
            libvlc_state_t state = libvlc_media_player_get_state(player);
            return state == libvlc_state_t.libvlc_Ended;
        }
        else
            return false;
    }
    
    void toggleMute()
    {
        if (player)
            libvlc_audio_toggle_mute(player);
    }
    
    void setVolume(float v)
    {
        if (player)
            libvlc_audio_set_volume(player, cast(int)(v * 100));
    }
    
    void update()
    {
        if (needsUploading && !locked)
            upload();
    }
    
    void upload()
    {
        texture.bind();
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_BGRA, GL_UNSIGNED_BYTE, outputBuffer.ptr);
        needsUploading = false;
    }
    
    void release()
    {
        if (player)
        {
            libvlc_media_player_set_media(player, null);
            libvlc_media_player_release(player);
            player = null;
        }
        
        if (media)
        {
            libvlc_media_release(media);
            media = null;
        }
    }
    
    ~this()
    {
        stop();
        release();
        Delete(outputBuffer);
    }
}

extern(C) void vlcLog(void* data, int level, const(libvlc_log_t)* ctx, const(char)* fmt, va_list args)
{
    VideoManager videoManager = cast(VideoManager)data;
    char[1024] buf;
    int numChars = vsnprintf(buf.ptr, buf.sizeof, fmt, args);
    if (numChars > buf.length)
        numChars = buf.length;
    string msg = cast(string)buf[0..numChars];
    switch (level)
    {
        case libvlc_log_level.LIBVLC_DEBUG:
            if (videoManager.logLevel <= LogLevel.Debug)
                logDebug("libVLC: ", msg);
            break;
        case libvlc_log_level.LIBVLC_NOTICE:
            if (videoManager.logLevel <= LogLevel.Info)
                logInfo("libVLC: ", msg);
            break;
        case libvlc_log_level.LIBVLC_WARNING:
            if (videoManager.logLevel <= LogLevel.Warning)
                logWarning("libVLC: ", msg);
            break;
        case libvlc_log_level.LIBVLC_ERROR:
            if (videoManager.logLevel <= LogLevel.Error)
                logError("libVLC: ", msg);
            break;
        default:
            break;
    }
}

extern(C) void* lock(void* opaque, void** planes)
{
    Video video = cast(Video)opaque;
    video.locked = true;
    planes[0] = video.outputBuffer.ptr;
    return null;
}

extern(C) void unlock(void* opaque, void* picture, const(void)** planes)
{
    Video video = cast(Video)opaque;
    video.locked = false;
}

extern(C) void display(void* opaque, void* picture)
{
    Video video = cast(Video)opaque;
    video.needsUploading = true;
}
