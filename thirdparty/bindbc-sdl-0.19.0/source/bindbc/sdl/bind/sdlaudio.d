
//          Copyright Michael D. Parker 2018.
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
        const(char)* SDL_GetAudioDriver(int);
        int SDL_AudioInit(const(char)*);
        void SDL_AudioQuit();
        const(char)* SDL_GetCurrentAudioDriver();
        int SDL_OpenAudio(SDL_AudioSpec*,SDL_AudioSpec*);
        int SDL_GetNumAudioDevices(int);
        const(char)* SDL_GetAudioDeviceName(int,int);
        SDL_AudioDeviceID SDL_OpenAudioDevice(const(char)*,int,const(SDL_AudioSpec)*,SDL_AudioSpec*,int);
        SDL_AudioStatus SDL_GetAudioStatus();
        SDL_AudioStatus SDL_GetAudioDeviceStatus(SDL_AudioDeviceID);
        void SDL_PauseAudio(int);
        void SDL_PauseAudioDevice(SDL_AudioDeviceID,int);
        SDL_AudioSpec* SDL_LoadWAV_RW(SDL_RWops*,int,SDL_AudioSpec*,ubyte**,uint*);
        void SDL_FreeWAV(ubyte*);
        int SDL_BuildAudioCVT(SDL_AudioCVT*,SDL_AudioFormat,ubyte,int,SDL_AudioFormat,ubyte,int);
        int SDL_ConvertAudio(SDL_AudioCVT*);
        void SDL_MixAudio(ubyte*,const(ubyte)*,uint,int);
        void SDL_MixAudioFormat(ubyte*,const(ubyte)*,SDL_AudioFormat,uint,int);
        void SDL_LockAudio();
        void SDL_LockAudioDevice(SDL_AudioDeviceID);
        void SDL_UnlockAudio();
        void SDL_UnlockAudioDevice(SDL_AudioDeviceID);
        void SDL_CloseAudio();
        void SDL_CloseAudioDevice(SDL_AudioDeviceID);

        static if(sdlSupport >= SDLSupport.sdl204) {
            int SDL_ClearQueuedAudio(SDL_AudioDeviceID);
            int SDL_GetQueuedAudioSize(SDL_AudioDeviceID);
            int SDL_QueueAudio(SDL_AudioDeviceID,const (void)*,uint);
        }

        static if(sdlSupport >= SDLSupport.sdl205) {
            uint SDL_DequeueAudio(SDL_AudioDeviceID,void*,uint);
        }

        static if(sdlSupport >= SDLSupport.sdl207) {
            SDL_AudioStream* SDL_NewAudioStream(const(SDL_AudioFormat),const(ubyte),const(int),const(SDL_AudioFormat),const(ubyte),const(int));
            int SDL_AudioStreamPut(SDL_AudioStream*,const(void)*,int);
            int SDL_AudioStreamGet(SDL_AudioStream*,void*,int);
            int SDL_AudioStreamAvailable(SDL_AudioStream*);
            int SDL_AudioStreamFlush(SDL_AudioStream*);
            void SDL_AudioStreamClear(SDL_AudioStream*);
            void SDL_FreeAudioStream(SDL_AudioStream*);
        }
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_GetNumAudioDrivers = int function();
        alias pSDL_GetAudioDriver = const(char)* function(int);
        alias pSDL_AudioInit = int function(const(char)*);
        alias pSDL_AudioQuit = void function();
        alias pSDL_GetCurrentAudioDriver = const(char)* function();
        alias pSDL_OpenAudio = int function(SDL_AudioSpec*,SDL_AudioSpec*);
        alias pSDL_GetNumAudioDevices = int function(int);
        alias pSDL_GetAudioDeviceName = const(char)* function(int,int);
        alias pSDL_OpenAudioDevice = SDL_AudioDeviceID function(const(char)*,int,const(SDL_AudioSpec)*,SDL_AudioSpec*,int);
        alias pSDL_GetAudioStatus = SDL_AudioStatus function();
        alias pSDL_GetAudioDeviceStatus = SDL_AudioStatus function(SDL_AudioDeviceID);
        alias pSDL_PauseAudio = void function(int);
        alias pSDL_PauseAudioDevice = void function(SDL_AudioDeviceID,int);
        alias pSDL_LoadWAV_RW = SDL_AudioSpec* function(SDL_RWops*,int,SDL_AudioSpec*,ubyte**,uint*);
        alias pSDL_FreeWAV = void function(ubyte*);
        alias pSDL_BuildAudioCVT = int function(SDL_AudioCVT*,SDL_AudioFormat,ubyte,int,SDL_AudioFormat,ubyte,int);
        alias pSDL_ConvertAudio = int function(SDL_AudioCVT*);
        alias pSDL_MixAudio = void function(ubyte*,const(ubyte)*,uint,int);
        alias pSDL_MixAudioFormat = void function(ubyte*,const(ubyte)*,SDL_AudioFormat,uint,int);
        alias pSDL_LockAudio = void function();
        alias pSDL_LockAudioDevice = void function(SDL_AudioDeviceID);
        alias pSDL_UnlockAudio = void function();
        alias pSDL_UnlockAudioDevice = void function(SDL_AudioDeviceID);
        alias pSDL_CloseAudio = void function();
        alias pSDL_CloseAudioDevice = void function(SDL_AudioDeviceID);
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
            alias pSDL_ClearQueuedAudio = int function(SDL_AudioDeviceID);
            alias pSDL_GetQueuedAudioSize = int function(SDL_AudioDeviceID);
            alias pSDL_QueueAudio = int function(SDL_AudioDeviceID,const (void)*,uint);
        }

        __gshared {
            pSDL_ClearQueuedAudio SDL_ClearQueuedAudio;
            pSDL_GetQueuedAudioSize SDL_GetQueuedAudioSize;
            pSDL_QueueAudio SDL_QueueAudio;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        extern(C) @nogc nothrow {
            alias pSDL_DequeueAudio = uint function(SDL_AudioDeviceID,void*,uint);
        }

        __gshared {
            pSDL_DequeueAudio SDL_DequeueAudio;
        }
    }

    static if(sdlSupport >= SDLSupport.sdl207) {
        extern(C) @nogc nothrow {
            alias pSDL_NewAudioStream = SDL_AudioStream* function(const(SDL_AudioFormat),const(ubyte),const(int),const(SDL_AudioFormat),const(ubyte),const(int));
            alias pSDL_AudioStreamPut = int function(SDL_AudioStream*,const(void)*,int);
            alias pSDL_AudioStreamGet = int function(SDL_AudioStream*,void*,int);
            alias pSDL_AudioStreamAvailable = int function(SDL_AudioStream*);
            alias pSDL_AudioStreamFlush = int function(SDL_AudioStream*);
            alias pSDL_AudioStreamClear = void function(SDL_AudioStream*);
            alias pSDL_FreeAudioStream = void function(SDL_AudioStream*);
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
}