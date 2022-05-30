
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlaudio;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlrwops;

enum : ushort {
    SDL_AUDIO_MASK_BITSIZE = 0xFF,
    SDL_AUDIO_MASK_DATATYPE = 1<<8,
    SDL_AUDIO_MASK_ENDIAN = 1<<12,
    SDL_AUDIO_MASK_SIGNED = 1<<15,
}

enum SDL_AudioFormat : ushort {
    AUDIO_U8 = 0x0008,
    AUDIO_S8 = 0x8008,
    AUDIO_U16LSB = 0x0010,
    AUDIO_S16LSB = 0x8010,
    AUDIO_U16MSB = 0x1010,
    AUDIO_S16MSB = 0x9010,
    AUDIO_U16 = AUDIO_U16LSB,
    AUDIO_S16 = AUDIO_S16LSB,
    AUDIO_S32LSB = 0x8020,
    AUDIO_S32MSB = 0x9020,
    AUDIO_S32 = AUDIO_S32LSB,
    AUDIO_F32LSB = 0x8120,
    AUDIO_F32MSB = 0x9120,
    AUDIO_F32 = AUDIO_F32LSB,
}
mixin(expandEnum!SDL_AudioFormat);

version(LittleEndian) {
    alias AUDIO_U16SYS = AUDIO_U16LSB;
    alias AUDIO_S16SYS = AUDIO_S16LSB;
    alias AUDIO_S32SYS = AUDIO_S32LSB;
    alias AUDIO_F32SYS = AUDIO_F32LSB;
} else {
    alias AUDIO_U16SYS = AUDIO_U16MSB;
    alias AUDIO_S16SYS = AUDIO_S16MSB;
    alias AUDIO_S32SYS = AUDIO_S32MSB;
    alias AUDIO_F32SYS = AUDIO_F32MSB;
}

enum SDL_AUDIO_BITSIZE(SDL_AudioFormat x) = x & SDL_AUDIO_MASK_BITSIZE;
enum SDL_AUDIO_ISFLOAT(SDL_AudioFormat x) = x & SDL_AUDIO_MASK_DATATYPE;
enum SDL_AUDIO_ISBIGENDIAN(SDL_AudioFormat x) = x & SDL_AUDIO_MASK_ENDIAN;
enum SDL_AUDIO_ISSIGNED(SDL_AudioFormat x) = x & SDL_AUDIO_MASK_SIGNED;
enum SDL_AUDIO_ISINT(SDL_AudioFormat x) = !SDL_AUDIO_ISFLOAT!x;
enum SDL_AUDIO_ISLITTLEENDIAN(SDL_AudioFormat x) = !SDL_AUDIO_ISBIGENDIAN!x;
enum SDL_AUDIO_ISUNSIGNED(SDL_AudioFormat x) = !SDL_AUDIO_ISSIGNED!x;

static if(sdlSupport >= SDLSupport.sdl209) {
    enum {
        SDL_AUDIO_ALLOW_FREQUENCY_CHANGE = 0x00000001,
        SDL_AUDIO_ALLOW_FORMAT_CHANGE = 0x00000002,
        SDL_AUDIO_ALLOW_CHANNELS_CHANGE = 0x00000004,
        SDL_AUDIO_ALLOW_SAMPLES_CHANGE = 0x00000008,
        SDL_AUDIO_ALLOW_ANY_CHANGE = SDL_AUDIO_ALLOW_FREQUENCY_CHANGE |
                                     SDL_AUDIO_ALLOW_FORMAT_CHANGE |
                                     SDL_AUDIO_ALLOW_CHANNELS_CHANGE |
                                     SDL_AUDIO_ALLOW_SAMPLES_CHANGE,
    }
}
else {
    enum {
        SDL_AUDIO_ALLOW_FREQUENCY_CHANGE = 0x00000001,
        SDL_AUDIO_ALLOW_FORMAT_CHANGE = 0x00000002,
        SDL_AUDIO_ALLOW_CHANNELS_CHANGE = 0x00000004,
        SDL_AUDIO_ALLOW_ANY_CHANGE = SDL_AUDIO_ALLOW_FREQUENCY_CHANGE |
                                     SDL_AUDIO_ALLOW_FORMAT_CHANGE |
                                     SDL_AUDIO_ALLOW_CHANNELS_CHANGE,
    }
}

extern(C) nothrow alias SDL_AudioCallback = void function(void* userdata, ubyte* stream, int len);
struct SDL_AudioSpec {
    int freq;
    SDL_AudioFormat format;
    ubyte channels;
    ubyte silence;
    ushort samples;
    ushort padding;
    uint size;
    SDL_AudioCallback callback;
    void* userdata;
}

// Declared in 2.0.6, but doesn't hurt to use here
enum SDL_AUDIOCVT_MAX_FILTERS = 9;

extern(C) nothrow alias SDL_AudioFilter = void function(SDL_AudioCVT* cvt, SDL_AudioFormat format);
struct SDL_AudioCVT {
    int needed;
    SDL_AudioFormat src_format;
    SDL_AudioFormat dst_format;
    double rate_incr;
    ubyte* buf;
    int len;
    int len_cvt;
    int len_mult;
    double len_ratio;
    SDL_AudioFilter[SDL_AUDIOCVT_MAX_FILTERS + 1] filters;
    int filter_index;
}

alias SDL_AudioDeviceID = uint;

enum SDL_AudioStatus {
    SDL_AUDIO_STOPPED = 0,
    SDL_AUDIO_PLAYING,
    SDL_AUDIO_PAUSED,
}
mixin(expandEnum!SDL_AudioStatus);

enum SDL_MIX_MAXVOLUME = 128;

static if(sdlSupport >= SDLSupport.sdl207) {
    struct SDL_AudioStream;
}

@nogc nothrow
SDL_AudioSpec* SDL_LoadWAV(const(char)* file, SDL_AudioSpec* spec, ubyte** audio_buf, uint* len) {
    pragma(inline, true);
    return SDL_LoadWAV_RW(SDL_RWFromFile(file,"rb"),1,spec,audio_buf,len);
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_GetNumAudioDrivers();
        const(char)* SDL_GetAudioDriver(int index);
        int SDL_AudioInit(const(char)* driver_name);
        void SDL_AudioQuit();
        const(char)* SDL_GetCurrentAudioDriver();
        int SDL_OpenAudio(SDL_AudioSpec* desired, SDL_AudioSpec* obtained);
        int SDL_GetNumAudioDevices(int iscapture);
        const(char)* SDL_GetAudioDeviceName(int index, int iscapture);
        SDL_AudioDeviceID SDL_OpenAudioDevice(const(char)* device, int iscapture, const(SDL_AudioSpec)* desired, SDL_AudioSpec* obtained, int allowed_changes);
        SDL_AudioStatus SDL_GetAudioStatus();
        SDL_AudioStatus SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev);
        void SDL_PauseAudio(int pause_on);
        void SDL_PauseAudioDevice(SDL_AudioDeviceID dev, int pause_on);
        SDL_AudioSpec* SDL_LoadWAV_RW(SDL_RWops* src, int freesrc, SDL_AudioSpec* spec, ubyte** audio_buf, uint* audio_len);
        void SDL_FreeWAV(ubyte* audio_buf);
        int SDL_BuildAudioCVT(SDL_AudioCVT* cvt, SDL_AudioFormat src_format, ubyte src_channels, int src_rate, SDL_AudioFormat dst_format, ubyte dst_channels, int dst_rate);
        int SDL_ConvertAudio(SDL_AudioCVT* cvt);
        void SDL_MixAudio(ubyte* dst, const(ubyte)* src, uint len, int volume);
        void SDL_MixAudioFormat(ubyte* dst, const(ubyte)* src, SDL_AudioFormat format, uint len, int volume);
        void SDL_LockAudio();
        void SDL_LockAudioDevice(SDL_AudioDeviceID dev);
        void SDL_UnlockAudio();
        void SDL_UnlockAudioDevice(SDL_AudioDeviceID dev);
        void SDL_CloseAudio();
        void SDL_CloseAudioDevice(SDL_AudioDeviceID dev);

        static if(sdlSupport >= SDLSupport.sdl204) {
            int SDL_QueueAudio(SDL_AudioDeviceID dev, const(void)* data, uint len);
            int SDL_ClearQueuedAudio(SDL_AudioDeviceID dev);
            int SDL_GetQueuedAudioSize(SDL_AudioDeviceID dev);
        }

        static if(sdlSupport >= SDLSupport.sdl205) {
            uint SDL_DequeueAudio(SDL_AudioDeviceID dev, void* data, uint len);
        }

        static if(sdlSupport >= SDLSupport.sdl207) {
            SDL_AudioStream* SDL_NewAudioStream(const(SDL_AudioFormat) src_format, const(ubyte) src_channels, const(int) src_rate, const(SDL_AudioFormat) dst_format, const(ubyte) dst_channels, const(int) dst_rate);
            int SDL_AudioStreamPut(SDL_AudioStream* stream, const(void)* buf, int len);
            int SDL_AudioStreamGet(SDL_AudioStream* stream, void* buf, int len);
            int SDL_AudioStreamAvailable(SDL_AudioStream* stream);
            int SDL_AudioStreamFlush(SDL_AudioStream* stream);
            void SDL_AudioStreamClear(SDL_AudioStream* stream);
            void SDL_FreeAudioStream(SDL_AudioStream* stream);
        }
        
        static if(sdlSupport >= SDLSupport.sdl2016) {
            int SDL_GetAudioDeviceSpec(int index, int iscapture, SDL_AudioSpec *spec);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumAudioDrivers = int function();
        alias pSDL_GetAudioDriver = const(char)* function(int index);
        alias pSDL_AudioInit = int function(const(char)* driver_name);
        alias pSDL_AudioQuit = void function();
        alias pSDL_GetCurrentAudioDriver = const(char)* function();
        alias pSDL_OpenAudio = int function(SDL_AudioSpec* desired, SDL_AudioSpec* obtained);
        alias pSDL_GetNumAudioDevices = int function(int iscapture);
        alias pSDL_GetAudioDeviceName = const(char)* function(int index, int iscapture);
        alias pSDL_OpenAudioDevice = SDL_AudioDeviceID function(const(char)* device, int iscapture, const(SDL_AudioSpec)* desired, SDL_AudioSpec* obtained, int allowed_changes);
        alias pSDL_GetAudioStatus = SDL_AudioStatus function();
        alias pSDL_GetAudioDeviceStatus = SDL_AudioStatus function(SDL_AudioDeviceID dev);
        alias pSDL_PauseAudio = void function(int pause_on);
        alias pSDL_PauseAudioDevice = void function(SDL_AudioDeviceID dev, int pause_on);
        alias pSDL_LoadWAV_RW = SDL_AudioSpec* function(SDL_RWops* src, int freesrc, SDL_AudioSpec* spec, ubyte** audio_buf, uint* audio_len);
        alias pSDL_FreeWAV = void function(ubyte* audio_buf);
        alias pSDL_BuildAudioCVT = int function(SDL_AudioCVT* cvt, SDL_AudioFormat src_format, ubyte src_channels, int src_rate, SDL_AudioFormat dst_format, ubyte dst_channels, int dst_rate);
        alias pSDL_ConvertAudio = int function(SDL_AudioCVT* cvt);
        alias pSDL_MixAudio = void function(ubyte* dst, const(ubyte)* src, uint len, int volume);
        alias pSDL_MixAudioFormat = void function(ubyte* dst, const(ubyte)* src, SDL_AudioFormat format, uint len, int volume);
        alias pSDL_LockAudio = void function();
        alias pSDL_LockAudioDevice = void function(SDL_AudioDeviceID dev);
        alias pSDL_UnlockAudio = void function();
        alias pSDL_UnlockAudioDevice = void function(SDL_AudioDeviceID dev);
        alias pSDL_CloseAudio = void function();
        alias pSDL_CloseAudioDevice = void function(SDL_AudioDeviceID dev);
    }

    __gshared {
        pSDL_GetNumAudioDrivers SDL_GetNumAudioDrivers;
        pSDL_GetAudioDriver SDL_GetAudioDriver;
        pSDL_AudioInit SDL_AudioInit;
        pSDL_AudioQuit SDL_AudioQuit;
        pSDL_GetCurrentAudioDriver SDL_GetCurrentAudioDriver;
        pSDL_OpenAudio SDL_OpenAudio;
        pSDL_GetNumAudioDevices SDL_GetNumAudioDevices;
        pSDL_GetAudioDeviceName SDL_GetAudioDeviceName;
        pSDL_OpenAudioDevice SDL_OpenAudioDevice;
        pSDL_GetAudioStatus SDL_GetAudioStatus;
        pSDL_GetAudioDeviceStatus SDL_GetAudioDeviceStatus;
        pSDL_PauseAudio SDL_PauseAudio;
        pSDL_PauseAudioDevice SDL_PauseAudioDevice;
        pSDL_LoadWAV_RW SDL_LoadWAV_RW;
        pSDL_FreeWAV SDL_FreeWAV;
        pSDL_BuildAudioCVT SDL_BuildAudioCVT;
        pSDL_ConvertAudio SDL_ConvertAudio;
        pSDL_MixAudio SDL_MixAudio;
        pSDL_MixAudioFormat SDL_MixAudioFormat;
        pSDL_LockAudio SDL_LockAudio;
        pSDL_LockAudioDevice SDL_LockAudioDevice;
        pSDL_UnlockAudio SDL_UnlockAudio;
        pSDL_UnlockAudioDevice SDL_UnlockAudioDevice;
        pSDL_CloseAudio SDL_CloseAudio;
        pSDL_CloseAudioDevice SDL_CloseAudioDevice;
    }

    static if(sdlSupport >= SDLSupport.sdl204) {
        extern(C) @nogc nothrow {
            alias pSDL_QueueAudio = int function(SDL_AudioDeviceID dev, const(void)* data, uint len);
            alias pSDL_ClearQueuedAudio = int function(SDL_AudioDeviceID dev);
            alias pSDL_GetQueuedAudioSize = int function(SDL_AudioDeviceID dev);
        }

        __gshared {
            pSDL_QueueAudio SDL_QueueAudio;
            pSDL_ClearQueuedAudio SDL_ClearQueuedAudio;
            pSDL_GetQueuedAudioSize SDL_GetQueuedAudioSize;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_DequeueAudio = uint function(SDL_AudioDeviceID dev, void* data, uint len);
        }

        __gshared {
            pSDL_DequeueAudio SDL_DequeueAudio;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl207) {
        extern(C) @nogc nothrow {
            alias pSDL_NewAudioStream = SDL_AudioStream* function(const(SDL_AudioFormat) src_format, const(ubyte) src_channels, const(int) src_rate, const(SDL_AudioFormat) dst_format, const(ubyte) dst_channels, const(int) dst_rate);
            alias pSDL_AudioStreamPut = int function(SDL_AudioStream* stream, const(void)* buf, int len);
            alias pSDL_AudioStreamGet = int function(SDL_AudioStream* stream, void* buf ,int len);
            alias pSDL_AudioStreamAvailable = int function(SDL_AudioStream* stream);
            alias pSDL_AudioStreamFlush = int function(SDL_AudioStream* stream);
            alias pSDL_AudioStreamClear = void function(SDL_AudioStream* stream);
            alias pSDL_FreeAudioStream = void function(SDL_AudioStream* stream);
        }

        __gshared {
            pSDL_NewAudioStream SDL_NewAudioStream;
            pSDL_AudioStreamPut SDL_AudioStreamPut;
            pSDL_AudioStreamGet SDL_AudioStreamGet;
            pSDL_AudioStreamAvailable SDL_AudioStreamAvailable;
            pSDL_AudioStreamFlush SDL_AudioStreamFlush;
            pSDL_AudioStreamClear SDL_AudioStreamClear;
            pSDL_FreeAudioStream SDL_FreeAudioStream;
        }
    }
    
    static if(sdlSupport >= SDLSupport.sdl2016) {
        extern(C) @nogc nothrow {
            alias pSDL_GetAudioDeviceSpec = int function(int index, int iscapture, SDL_AudioSpec *spec);
        }

        __gshared {
            pSDL_GetAudioDeviceSpec SDL_GetAudioDeviceSpec;
        }
    }
}
