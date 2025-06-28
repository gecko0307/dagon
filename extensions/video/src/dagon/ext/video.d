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
            environment["VLC_PLUGIN_PATH"] = absolutePath("./plugins_linux");
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
        // TODO: release player if not null
        
        if (media)
            libvlc_media_release(media);
        
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
    
    // TODO: pause()
    // TODO: setVolume(float v)
    
    void upload()
    {
        texture.bind();
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_BGRA, GL_UNSIGNED_BYTE, outputBuffer.ptr);
    }
    
    ~this()
    {
        if (media)
            libvlc_media_release(media);
        Delete(outputBuffer);
    }
}

extern(C) void vlcLog(void* data, int level, const(libvlc_log_t)* ctx, const(char)* fmt, va_list args)
{
    VideoManager videoManager = cast(VideoManager)data;
    char[1024] buf;
    vsnprintf(buf.ptr, buf.sizeof, fmt, args);
    buf[$-1] = 0; // ensure null-terminated
    switch (level)
    {
        case libvlc_log_level.LIBVLC_DEBUG:
            if (videoManager.logLevel <= LogLevel.Debug)
                logDebug("libVLC: ", buf);
            break;
        case libvlc_log_level.LIBVLC_NOTICE:
            if (videoManager.logLevel <= LogLevel.Info)
                logInfo("libVLC: ", buf);
            break;
        case libvlc_log_level.LIBVLC_WARNING:
            if (videoManager.logLevel <= LogLevel.Warning)
                logWarning("libVLC: ", buf);
            break;
        case libvlc_log_level.LIBVLC_ERROR:
            if (videoManager.logLevel <= LogLevel.Error)
                logError("libVLC: ", buf);
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
