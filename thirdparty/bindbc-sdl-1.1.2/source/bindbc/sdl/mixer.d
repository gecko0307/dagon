
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.mixer;

import bindbc.sdl.config;
static if(bindSDLMixer):

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlaudio : AUDIO_S16LSB, SDL_MIX_MAXVOLUME;
import bindbc.sdl.bind.sdlerror : SDL_GetError, SDL_SetError, SDL_ClearError;
import bindbc.sdl.bind.sdlrwops : SDL_RWops, SDL_RWFromFile;
import bindbc.sdl.bind.sdlstdinc : SDL_bool;
import bindbc.sdl.bind.sdlversion : SDL_version, SDL_VERSIONNUM;

alias Mix_SetError = SDL_SetError;
alias Mix_GetError = SDL_GetError;
alias Mix_ClearError = SDL_ClearError;

enum SDLMixerSupport {
    noLibrary,
    badLibrary,
    sdlMixer200 = 200,
    sdlMixer201 = 201,
    sdlMixer202 = 202,
    sdlMixer204 = 204,
}

enum ubyte SDL_MIXER_MAJOR_VERSION = 2;
enum ubyte SDL_MIXER_MINOR_VERSION = 0;

version(SDL_Mixer_204) {
    enum sdlMixerSupport = SDLMixerSupport.sdlMixer204;
    enum ubyte SDL_MIXER_PATCHLEVEL = 4;
}
else version(SDL_Mixer_202) {
    enum sdlMixerSupport = SDLMixerSupport.sdlMixer202;
    enum ubyte SDL_MIXER_PATCHLEVEL = 2;
}
else version(SDL_Mixer_201) {
    enum sdlMixerSupport = SDLMixerSupport.sdlMixer201;
    enum ubyte SDL_MIXER_PATCHLEVEL = 1;
}
else {
    enum sdlMixerSupport = SDLMixerSupport.sdlMixer200;
    enum ubyte SDL_MIXER_PATCHLEVEL = 0;
}

alias MIX_MAJOR_VERSION = SDL_MIXER_MAJOR_VERSION;
alias MIX_MINOR_VERSION = SDL_MIXER_MINOR_VERSION;
alias MIX_PATCH_LEVEL = SDL_MIXER_PATCHLEVEL;

@nogc nothrow void SDL_MIXER_VERSION(SDL_version* X)
{
    X.major     = SDL_MIXER_MAJOR_VERSION;
    X.minor     = SDL_MIXER_MINOR_VERSION;
    X.patch     = SDL_MIXER_PATCHLEVEL;
}
alias SDL_MIX_VERSION = SDL_MIX_MAXVOLUME;

// These were implemented in SDL_mixer 2.0.2, but are fine for all versions.
enum SDL_MIXER_COMPILEDVERSION = SDL_VERSIONNUM!(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_PATCHLEVEL);
enum SDL_MIXER_VERSION_ATLEAST(ubyte X, ubyte Y, ubyte Z) = SDL_MIXER_COMPILEDVERSION >= SDL_VERSIONNUM!(X, Y, Z);

static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer204) {
    enum Mix_InitFlags {
        MIX_INIT_FLAC = 0x00000001,
        MIX_INIT_MOD = 0x00000002,
        MIX_INIT_MP3 = 0x00000008,
        MIX_INIT_OGG = 0x00000010,
        MIX_INIT_MID = 0x00000020,
        MIX_INIT_OPUS = 0x00000040,
    }
}
else static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer202) {
    enum Mix_InitFlags {
        MIX_INIT_FLAC = 0x00000001,
        MIX_INIT_MOD = 0x00000002,
        MIX_INIT_MP3 = 0x00000008,
        MIX_INIT_OGG = 0x00000010,
        MIX_INIT_MID = 0x00000020,
    }
}
else {
    enum Mix_InitFlags {
        MIX_INIT_FLAC = 0x00000001,
        MIX_INIT_MOD = 0x00000002,
        MIX_INIT_MODPLUG = 0x00000004,
        MIX_INIT_MP3 = 0x00000008,
        MIX_INIT_OGG = 0x00000010,
        MIX_INIT_FLUIDSYNTH = 0x00000020,
    }
}
mixin(expandEnum!Mix_InitFlags);

enum {
    MIX_CHANNELS              = 8,
    MIX_DEFAULT_FREQUENCY     = 22050,
    MIX_DEFAULT_CHANNELS      = 2,
    MIX_MAX_VOLUME            = 128,
    MIX_CHANNEL_POST          = -2,
}

version(LittleEndian) {
    enum MIX_DEFAULT_FORMAT = AUDIO_S16LSB;
} else {
    enum MIX_DEFAULT_FORMAT = AUDIO_S16MSB;
}

struct Mix_Chunk {
   int allocated;
   ubyte* abuf;
   uint alen;
   ubyte volume;
}

enum Mix_Fading {
   MIX_NO_FADING,
   MIX_FADING_OUT,
   MIX_FADING_IN
}
mixin(expandEnum!Mix_Fading);

static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer204) {
    enum Mix_MusicType {
       MUS_NONE,
       MUS_CMD,
       MUS_WAV,
       MUS_MOD,
       MUS_MID,
       MUS_OGG,
       MUS_MP3,
       MUS_MP3_MAD_UNUSED,
       MUS_FLAC,
       MUS_MODPLUG_UNUSED,
       MUS_OPUS,
    }
}
else static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer202) {
    enum Mix_MusicType {
       MUS_NONE,
       MUS_CMD,
       MUS_WAV,
       MUS_MOD,
       MUS_MID,
       MUS_OGG,
       MUS_MP3,
       MUS_MP3_MAD_UNUSED,
       MUS_FLAC,
       MUS_MODPLUG_UNUSED,
    }
}
else {
    enum Mix_MusicType {
       MUS_NONE,
       MUS_CMD,
       MUS_WAV,
       MUS_MOD,
       MUS_MID,
       MUS_OGG,
       MUS_MP3,
       MUS_MP3_MAD,
       MUS_FLAC,
       MUS_MODPLUG,
    }
}
mixin(expandEnum!Mix_MusicType);

struct Mix_Music;
enum MIX_EFFECTSMAXSPEED = "MIX_EFFECTSMAXSPEED";

extern(C) nothrow {
    alias Mix_EffectFunc_t = void function(int,void*,int,void*);
    alias Mix_EffectDone_t = void function(int,void*);

    // These aren't in SDL_mixer.h and are just here as a convenient and
    // visible means to add the proper attributes these callbacks.
    alias callbackVI = void function(int);
    alias callbackVPVPUbI = void function(void*,ubyte*,int);
    alias callbackV = void function();
    alias callbackIPCPV = int function(const(char*),void*);
}

@nogc nothrow {
    Mix_Chunk* Mix_LoadWAV(const(char)* file) {
        pragma(inline, true);
        return Mix_LoadWAV_RW(SDL_RWFromFile(file,"rb"),1);
    }

    int Mix_PlayChannel(int channel,Mix_Chunk* chunk,int loops) {
        pragma(inline, true);
        return Mix_PlayChannelTimed(channel,chunk,loops,-1);
    }

    int Mix_FadeInChannel(int channel,Mix_Chunk* chunk,int loops,int ms) {
        pragma(inline, true);
        return Mix_FadeInChannelTimed(channel,chunk,loops,ms,-1);
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        const(SDL_version)* Mix_Linked_Version();
        int Mix_Init(int flags);
        void Mix_Quit();
        int Mix_OpenAudio(int frequency, ushort format, int channels, int chunksize);
        int Mix_AllocateChannels(int numchans);
        int Mix_QuerySpec(int* frequency, ushort* format, int* channels);
        Mix_Chunk* Mix_LoadWAV_RW(SDL_RWops* src, int freesrc);
        Mix_Music* Mix_LoadMUS(const(char)* file);
        Mix_Music* Mix_LoadMUS_RW(SDL_RWops* src, int freesrc);
        Mix_Music* Mix_LoadMUSType_RW(SDL_RWops* src, Mix_MusicType type, int freesrc);
        Mix_Chunk* Mix_QuickLoad_WAV(ubyte* mem);
        Mix_Chunk* Mix_QuickLoad_RAW(ubyte* mem, uint len);
        void Mix_FreeChunk(Mix_Chunk* chunk);
        void Mix_FreeMusic(Mix_Music* music);
        int Mix_GetNumChunkDecoders();
        const(char)* Mix_GetChunkDecoder(int index);
        int Mix_GetNumMusicDecoders();
        const(char)* Mix_GetMusicDecoder(int index);
        Mix_MusicType Mix_GetMusicType(const(Mix_Music)* music);
        void Mix_SetPostMix(callbackVPVPUbI mix_func, void* arg);
        void Mix_HookMusic(callbackVPVPUbI mix_func, void* arg);
        void Mix_HookMusicFinished(callbackV music_finished);
        void* Mix_GetMusicHookData();
        void Mix_ChannelFinished(callbackVI channel_finished);
        int Mix_RegisterEffect(int chan, Mix_EffectFunc_t f, Mix_EffectDone_t d, void* arg);
        int Mix_UnregisterEffect(int channel, Mix_EffectFunc_t f);
        int Mix_UnregisterAllEffects(int channel);
        int Mix_SetPanning(int channel, ubyte left, ubyte right);
        int Mix_SetPosition(int channel, short angle, ubyte distance);
        int Mix_SetDistance(int channel, ubyte distance);
        int Mix_SetReverseStereo(int channel, int flip);
        int Mix_ReserveChannels(int num);
        int Mix_GroupChannel(int which, int tag);
        int Mix_GroupChannels(int from, int to, int tag);
        int Mix_GroupAvailable(int tag);
        int Mix_GroupCount(int tag);
        int Mix_GroupOldest(int tag);
        int Mix_GroupNewer(int tag);
        int Mix_PlayChannelTimed(int channel, Mix_Chunk* chunk, int loops, int ticks);
        int Mix_PlayMusic(Mix_Music* music, int loops);
        int Mix_FadeInMusic(Mix_Music* music, int loops, int ms);
        int Mix_FadeInMusicPos(Mix_Music* music, int loops, int ms, double position);
        int Mix_FadeInChannelTimed(int channel, Mix_Chunk* chunk, int loops, int ms, int ticks);
        int Mix_Volume(int channel, int volume);
        int Mix_VolumeChunk(Mix_Chunk* chunk, int volume);
        int Mix_VolumeMusic(int volume);
        int Mix_HaltChannel(int channel);
        int Mix_HaltGroup(int tag);
        int Mix_HaltMusic();
        int Mix_ExpireChannel(int channel, int ticks);
        int Mix_FadeOutChannel(int which, int ms);
        int Mix_FadeOutGroup(int tag, int ms);
        int Mix_FadeOutMusic(int ms);
        Mix_Fading Mix_FadingMusic();
        Mix_Fading Mix_FadingChannel(int which);
        void Mix_Pause(int channel);
        void Mix_Resume(int channel);
        int Mix_Paused(int channel);
        void Mix_PauseMusic();
        void Mix_ResumeMusic();
        void Mix_RewindMusic();
        int Mix_PausedMusic();
        int Mix_SetMusicPosition(double position);
        int Mix_Playing(int channel);
        int Mix_PlayingMusic();
        int Mix_SetMusicCMD(const(char)* command);
        int Mix_SetSynchroValue(int value);
        int Mix_GetSynchroValue();
        int Mix_SetSoundFonts(const char *paths);
        const(char)* Mix_GetSoundFonts();
        int Mix_EachSoundFont(callbackIPCPV function_, void *data);
        Mix_Chunk* Mix_GetChunk(int channel);
        void Mix_CloseAudio();

        static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer202) {
            int Mix_OpenAudioDevice(int frequency, ushort format, int channels, int chunksize, const(char)* device, int allowed_changes);
            SDL_bool Mix_HasChunkDecoder(const(char)* name);

            // Declared in SDL_mixer.h, but not implemented
            // SDL_bool Mix_HasMusicDecoder(const(char)*);
        }
    }
}
else {
    import bindbc.loader;

    extern(C) @nogc nothrow {
        alias pMix_Linked_Version = const(SDL_version)* function();
        alias pMix_Init = int function(int flags);
        alias pMix_Quit = void function();
        alias pMix_OpenAudio = int function(int frequency, ushort format, int channels, int chunksize);
        alias pMix_AllocateChannels = int function(int numchans);
        alias pMix_QuerySpec = int function(int* frequency, ushort* format, int* channels);
        alias pMix_LoadWAV_RW = Mix_Chunk* function(SDL_RWops* src, int freesrc);
        alias pMix_LoadMUS = Mix_Music* function(const(char)* file);
        alias pMix_LoadMUS_RW = Mix_Music* function(SDL_RWops* src, int freesrc);
        alias pMix_LoadMUSType_RW = Mix_Music* function(SDL_RWops* src, Mix_MusicType type, int freesrc);
        alias pMix_QuickLoad_WAV = Mix_Chunk* function(ubyte* mem);
        alias pMix_QuickLoad_RAW = Mix_Chunk* function(ubyte* mem, uint len);
        alias pMix_FreeChunk = void function(Mix_Chunk* chunk);
        alias pMix_FreeMusic = void function(Mix_Music* music);
        alias pMix_GetNumChunkDecoders = int function();
        alias pMix_GetChunkDecoder = const(char)* function(int index);
        alias pMix_GetNumMusicDecoders = int function();
        alias pMix_GetMusicDecoder = const(char)* function(int index);
        alias pMix_GetMusicType = Mix_MusicType function(const(Mix_Music)* music);
        alias pMix_SetPostMix = void function(callbackVPVPUbI mix_func, void* arg);
        alias pMix_HookMusic = void function(callbackVPVPUbI mix_func, void* arg);
        alias pMix_HookMusicFinished = void function(callbackV music_finished);
        alias pMix_GetMusicHookData = void* function();
        alias pMix_ChannelFinished = void function(callbackVI channel_finished);
        alias pMix_RegisterEffect = int function(int chan, Mix_EffectFunc_t f, Mix_EffectDone_t d, void* arg);
        alias pMix_UnregisterEffect = int function(int channel, Mix_EffectFunc_t f);
        alias pMix_UnregisterAllEffects = int function(int channel);
        alias pMix_SetPanning = int function(int channel, ubyte left, ubyte right);
        alias pMix_SetPosition = int function(int channel, short angle, ubyte distance);
        alias pMix_SetDistance = int function(int channel, ubyte distance);
        alias pMix_SetReverseStereo = int function(int channel, int flip);
        alias pMix_ReserveChannels = int function(int num);
        alias pMix_GroupChannel = int function(int which, int tag);
        alias pMix_GroupChannels = int function(int from, int to, int tag);
        alias pMix_GroupAvailable = int function(int tag);
        alias pMix_GroupCount = int function(int tag);
        alias pMix_GroupOldest = int function(int tag);
        alias pMix_GroupNewer = int function(int tag);
        alias pMix_PlayChannelTimed = int function(int channel, Mix_Chunk* chunk, int loops, int ticks);
        alias pMix_PlayMusic = int function(Mix_Music* music, int loops);
        alias pMix_FadeInMusic = int function(Mix_Music* music, int loops, int ms);
        alias pMix_FadeInMusicPos = int function(Mix_Music* music, int loops, int ms, double position);
        alias pMix_FadeInChannelTimed = int function(int channel, Mix_Chunk* chunk, int loops, int ms, int ticks);
        alias pMix_Volume = int function(int channel, int volume);
        alias pMix_VolumeChunk = int function(Mix_Chunk* chunk, int volume);
        alias pMix_VolumeMusic = int function(int volume);
        alias pMix_HaltChannel = int function(int channel);
        alias pMix_HaltGroup = int function(int tag);
        alias pMix_HaltMusic = int function();
        alias pMix_ExpireChannel = int function(int channel, int ticks);
        alias pMix_FadeOutChannel = int function(int which, int ms);
        alias pMix_FadeOutGroup = int function(int tag, int ms);
        alias pMix_FadeOutMusic = int function(int ms);
        alias pMix_FadingMusic = Mix_Fading function();
        alias pMix_FadingChannel = Mix_Fading function(int which);
        alias pMix_Pause = void function(int channel);
        alias pMix_Resume = void function(int channel);
        alias pMix_Paused = int function(int channel);
        alias pMix_PauseMusic = void function();
        alias pMix_ResumeMusic = void function();
        alias pMix_RewindMusic = void function();
        alias pMix_PausedMusic = int function();
        alias pMix_SetMusicPosition = int function(double position);
        alias pMix_Playing = int function(int channel);
        alias pMix_PlayingMusic = int function();
        alias pMix_SetMusicCMD = int function(const(char)* command);
        alias pMix_SetSynchroValue = int function(int value);
        alias pMix_GetSynchroValue = int function();
        alias pMix_SetSoundFonts = int function(const char *paths);
        alias pMix_GetSoundFonts = const(char)* function();
        alias pMix_EachSoundFont = int function(callbackIPCPV function_, void *data);
        alias pMix_GetChunk = Mix_Chunk* function(int channel);
        alias pMix_CloseAudio = void function();
    }

    __gshared {
        pMix_Linked_Version Mix_Linked_Version;
        pMix_Init Mix_Init;
        pMix_Quit Mix_Quit;
        pMix_OpenAudio Mix_OpenAudio;
        pMix_AllocateChannels Mix_AllocateChannels;
        pMix_QuerySpec Mix_QuerySpec;
        pMix_LoadWAV_RW Mix_LoadWAV_RW;
        pMix_LoadMUS Mix_LoadMUS;
        pMix_LoadMUS_RW Mix_LoadMUS_RW;
        pMix_LoadMUSType_RW Mix_LoadMUSType_RW;
        pMix_QuickLoad_WAV Mix_QuickLoad_WAV;
        pMix_QuickLoad_RAW Mix_QuickLoad_RAW;
        pMix_FreeChunk Mix_FreeChunk;
        pMix_FreeMusic Mix_FreeMusic;
        pMix_GetNumChunkDecoders Mix_GetNumChunkDecoders;
        pMix_GetChunkDecoder Mix_GetChunkDecoder;
        pMix_GetNumMusicDecoders Mix_GetNumMusicDecoders;
        pMix_GetMusicDecoder Mix_GetMusicDecoder;
        pMix_GetMusicType Mix_GetMusicType;
        pMix_SetPostMix Mix_SetPostMix;
        pMix_HookMusic Mix_HookMusic;
        pMix_HookMusicFinished Mix_HookMusicFinished;
        pMix_GetMusicHookData Mix_GetMusicHookData;
        pMix_ChannelFinished Mix_ChannelFinished;
        pMix_RegisterEffect Mix_RegisterEffect;
        pMix_UnregisterEffect Mix_UnregisterEffect;
        pMix_UnregisterAllEffects Mix_UnregisterAllEffects;
        pMix_SetPanning Mix_SetPanning;
        pMix_SetPosition Mix_SetPosition;
        pMix_SetDistance Mix_SetDistance;
        pMix_SetReverseStereo Mix_SetReverseStereo;
        pMix_ReserveChannels Mix_ReserveChannels;
        pMix_GroupChannel Mix_GroupChannel;
        pMix_GroupChannels Mix_GroupChannels;
        pMix_GroupAvailable Mix_GroupAvailable;
        pMix_GroupCount Mix_GroupCount;
        pMix_GroupOldest Mix_GroupOldest;
        pMix_GroupNewer Mix_GroupNewer;
        pMix_PlayChannelTimed Mix_PlayChannelTimed;
        pMix_PlayMusic Mix_PlayMusic;
        pMix_FadeInMusic Mix_FadeInMusic;
        pMix_FadeInMusicPos Mix_FadeInMusicPos;
        pMix_FadeInChannelTimed Mix_FadeInChannelTimed;
        pMix_Volume Mix_Volume;
        pMix_VolumeChunk Mix_VolumeChunk;
        pMix_VolumeMusic Mix_VolumeMusic;
        pMix_HaltChannel Mix_HaltChannel;
        pMix_HaltGroup Mix_HaltGroup;
        pMix_HaltMusic Mix_HaltMusic;
        pMix_ExpireChannel Mix_ExpireChannel;
        pMix_FadeOutChannel Mix_FadeOutChannel;
        pMix_FadeOutGroup Mix_FadeOutGroup;
        pMix_FadeOutMusic Mix_FadeOutMusic;
        pMix_FadingMusic Mix_FadingMusic;
        pMix_FadingChannel Mix_FadingChannel;
        pMix_Pause Mix_Pause;
        pMix_Resume Mix_Resume;
        pMix_Paused Mix_Paused;
        pMix_PauseMusic Mix_PauseMusic;
        pMix_ResumeMusic Mix_ResumeMusic;
        pMix_RewindMusic Mix_RewindMusic;
        pMix_PausedMusic Mix_PausedMusic;
        pMix_SetMusicPosition Mix_SetMusicPosition;
        pMix_Playing Mix_Playing;
        pMix_PlayingMusic Mix_PlayingMusic;
        pMix_SetMusicCMD Mix_SetMusicCMD;
        pMix_SetSynchroValue Mix_SetSynchroValue;
        pMix_GetSynchroValue Mix_GetSynchroValue;
        pMix_SetSoundFonts Mix_SetSoundFonts;
        pMix_GetSoundFonts Mix_GetSoundFonts;
        pMix_EachSoundFont Mix_EachSoundFont;
        pMix_GetChunk Mix_GetChunk;
        pMix_CloseAudio Mix_CloseAudio;
    }


    static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer202) {
        extern(C) @nogc nothrow {
            alias pMix_OpenAudioDevice = int function(int frequency, ushort format, int channels, int chunksize, const(char)* device, int allowed_changes);
            alias pMix_HasChunkDecoder = SDL_bool function(const(char)* name);

            // Declared in SDL_mixer.h, but not implemented
            //alias pMix_HasMusicDecoder = SDL_bool function(const(char)*);
        }

        __gshared {
            pMix_OpenAudioDevice Mix_OpenAudioDevice;
            pMix_HasChunkDecoder Mix_HasChunkDecoder;
            //pMix_HasMusicDecoder Mix_HasMusicDecoder;
        }
    }

    private {
        SharedLib lib;
        SDLMixerSupport loadedVersion;
    }

@nogc nothrow:
    void unloadSDLMixer()
    {
        if(lib != invalidHandle) {
            lib.unload();
        }
    }

    SDLMixerSupport loadedSDLMixerVersion() { return loadedVersion; }

    bool isSDLMixerLoaded()
    {
        return  lib != invalidHandle;
    }


    SDLMixerSupport loadSDLMixer()
    {
        version(Windows) {
            const(char)[][1] libNames = ["SDL2_mixer.dll"];
        }
        else version(OSX) {
            const(char)[][6] libNames = [
                "libSDL2_mixer.dylib",
                "/usr/local/lib/libSDL2_mixer.dylib",
                "../Frameworks/SDL2_mixer.framework/SDL2_mixer",
                "/Library/Frameworks/SDL2_mixer.framework/SDL2_mixer",
                "/System/Library/Frameworks/SDL2_mixer.framework/SDL2_mixer",
                "/opt/local/lib/libSDL2_mixer.dylib"
            ];
        }
        else version(Posix) {
            const(char)[][6] libNames = [
                "libSDL2_mixer.so",
                "/usr/local/lib/libSDL2_mixer.so",
                "libSDL2-2.0_mixer.so",
                "/usr/local/lib/libSDL2-2.0_mixer.so",
                "libSDL2-2.0_mixer.so.0",
                "/usr/local/lib/libSDL2-2.0_mixer.so.0"
            ];
        }
        else static assert(0, "bindbc-sdl is not yet supported on this platform.");

        SDLMixerSupport ret;
        foreach(name; libNames) {
            ret = loadSDLMixer(name.ptr);
            if(ret != SDLMixerSupport.noLibrary) break;
        }
        return ret;
    }

    SDLMixerSupport loadSDLMixer(const(char)* libName)
    {
        lib = load(libName);
        if(lib == invalidHandle) {
            return SDLMixerSupport.noLibrary;
        }

        auto errCount = errorCount();
        loadedVersion = SDLMixerSupport.badLibrary;

        lib.bindSymbol(cast(void**)&Mix_Linked_Version,"Mix_Linked_Version");
        lib.bindSymbol(cast(void**)&Mix_Init,"Mix_Init");
        lib.bindSymbol(cast(void**)&Mix_Quit,"Mix_Quit");
        lib.bindSymbol(cast(void**)&Mix_OpenAudio,"Mix_OpenAudio");
        lib.bindSymbol(cast(void**)&Mix_AllocateChannels,"Mix_AllocateChannels");
        lib.bindSymbol(cast(void**)&Mix_QuerySpec,"Mix_QuerySpec");
        lib.bindSymbol(cast(void**)&Mix_LoadWAV_RW,"Mix_LoadWAV_RW");
        lib.bindSymbol(cast(void**)&Mix_LoadMUS,"Mix_LoadMUS");
        lib.bindSymbol(cast(void**)&Mix_LoadMUS_RW,"Mix_LoadMUS_RW");
        lib.bindSymbol(cast(void**)&Mix_LoadMUSType_RW,"Mix_LoadMUSType_RW");
        lib.bindSymbol(cast(void**)&Mix_QuickLoad_WAV,"Mix_QuickLoad_WAV");
        lib.bindSymbol(cast(void**)&Mix_QuickLoad_RAW,"Mix_QuickLoad_RAW");
        lib.bindSymbol(cast(void**)&Mix_FreeChunk,"Mix_FreeChunk");
        lib.bindSymbol(cast(void**)&Mix_FreeMusic,"Mix_FreeMusic");
        lib.bindSymbol(cast(void**)&Mix_GetNumChunkDecoders,"Mix_GetNumChunkDecoders");
        lib.bindSymbol(cast(void**)&Mix_GetChunkDecoder,"Mix_GetChunkDecoder");
        lib.bindSymbol(cast(void**)&Mix_GetNumMusicDecoders,"Mix_GetNumMusicDecoders");
        lib.bindSymbol(cast(void**)&Mix_GetMusicDecoder,"Mix_GetMusicDecoder");
        lib.bindSymbol(cast(void**)&Mix_GetMusicType,"Mix_GetMusicType");
        lib.bindSymbol(cast(void**)&Mix_SetPostMix,"Mix_SetPostMix");
        lib.bindSymbol(cast(void**)&Mix_HookMusic,"Mix_HookMusic");
        lib.bindSymbol(cast(void**)&Mix_HookMusicFinished,"Mix_HookMusicFinished");
        lib.bindSymbol(cast(void**)&Mix_GetMusicHookData,"Mix_GetMusicHookData");
        lib.bindSymbol(cast(void**)&Mix_ChannelFinished,"Mix_ChannelFinished");
        lib.bindSymbol(cast(void**)&Mix_RegisterEffect,"Mix_RegisterEffect");
        lib.bindSymbol(cast(void**)&Mix_UnregisterEffect,"Mix_UnregisterEffect");
        lib.bindSymbol(cast(void**)&Mix_UnregisterAllEffects,"Mix_UnregisterAllEffects");
        lib.bindSymbol(cast(void**)&Mix_SetPanning,"Mix_SetPanning");
        lib.bindSymbol(cast(void**)&Mix_SetPosition,"Mix_SetPosition");
        lib.bindSymbol(cast(void**)&Mix_SetDistance,"Mix_SetDistance");
        lib.bindSymbol(cast(void**)&Mix_SetReverseStereo,"Mix_SetReverseStereo");
        lib.bindSymbol(cast(void**)&Mix_ReserveChannels,"Mix_ReserveChannels");
        lib.bindSymbol(cast(void**)&Mix_GroupChannel,"Mix_GroupChannel");
        lib.bindSymbol(cast(void**)&Mix_GroupChannels,"Mix_GroupChannels");
        lib.bindSymbol(cast(void**)&Mix_GroupAvailable,"Mix_GroupAvailable");
        lib.bindSymbol(cast(void**)&Mix_GroupCount,"Mix_GroupCount");
        lib.bindSymbol(cast(void**)&Mix_GroupOldest,"Mix_GroupOldest");
        lib.bindSymbol(cast(void**)&Mix_GroupNewer,"Mix_GroupNewer");
        lib.bindSymbol(cast(void**)&Mix_PlayChannelTimed,"Mix_PlayChannelTimed");
        lib.bindSymbol(cast(void**)&Mix_PlayMusic,"Mix_PlayMusic");
        lib.bindSymbol(cast(void**)&Mix_FadeInMusic,"Mix_FadeInMusic");
        lib.bindSymbol(cast(void**)&Mix_FadeInMusicPos,"Mix_FadeInMusicPos");
        lib.bindSymbol(cast(void**)&Mix_FadeInChannelTimed,"Mix_FadeInChannelTimed");
        lib.bindSymbol(cast(void**)&Mix_Volume,"Mix_Volume");
        lib.bindSymbol(cast(void**)&Mix_VolumeChunk,"Mix_VolumeChunk");
        lib.bindSymbol(cast(void**)&Mix_VolumeMusic,"Mix_VolumeMusic");
        lib.bindSymbol(cast(void**)&Mix_HaltChannel,"Mix_HaltChannel");
        lib.bindSymbol(cast(void**)&Mix_HaltGroup,"Mix_HaltGroup");
        lib.bindSymbol(cast(void**)&Mix_HaltMusic,"Mix_HaltMusic");
        lib.bindSymbol(cast(void**)&Mix_ExpireChannel,"Mix_ExpireChannel");
        lib.bindSymbol(cast(void**)&Mix_FadeOutChannel,"Mix_FadeOutChannel");
        lib.bindSymbol(cast(void**)&Mix_FadeOutGroup,"Mix_FadeOutGroup");
        lib.bindSymbol(cast(void**)&Mix_FadeOutMusic,"Mix_FadeOutMusic");
        lib.bindSymbol(cast(void**)&Mix_FadingMusic,"Mix_FadingMusic");
        lib.bindSymbol(cast(void**)&Mix_FadingChannel,"Mix_FadingChannel");
        lib.bindSymbol(cast(void**)&Mix_Pause,"Mix_Pause");
        lib.bindSymbol(cast(void**)&Mix_Resume,"Mix_Resume");
        lib.bindSymbol(cast(void**)&Mix_Paused,"Mix_Paused");
        lib.bindSymbol(cast(void**)&Mix_PauseMusic,"Mix_PauseMusic");
        lib.bindSymbol(cast(void**)&Mix_ResumeMusic,"Mix_ResumeMusic");
        lib.bindSymbol(cast(void**)&Mix_RewindMusic,"Mix_RewindMusic");
        lib.bindSymbol(cast(void**)&Mix_PausedMusic,"Mix_PausedMusic");
        lib.bindSymbol(cast(void**)&Mix_SetMusicPosition,"Mix_SetMusicPosition");
        lib.bindSymbol(cast(void**)&Mix_Playing,"Mix_Playing");
        lib.bindSymbol(cast(void**)&Mix_PlayingMusic,"Mix_PlayingMusic");
        lib.bindSymbol(cast(void**)&Mix_SetMusicCMD,"Mix_SetMusicCMD");
        lib.bindSymbol(cast(void**)&Mix_SetSynchroValue,"Mix_SetSynchroValue");
        lib.bindSymbol(cast(void**)&Mix_GetSynchroValue,"Mix_GetSynchroValue");
        lib.bindSymbol(cast(void**)&Mix_SetSoundFonts,"Mix_SetSoundFonts");
        lib.bindSymbol(cast(void**)&Mix_GetSoundFonts,"Mix_GetSoundFonts");
        lib.bindSymbol(cast(void**)&Mix_EachSoundFont,"Mix_EachSoundFont");
        lib.bindSymbol(cast(void**)&Mix_GetChunk,"Mix_GetChunk");
        lib.bindSymbol(cast(void**)&Mix_CloseAudio,"Mix_CloseAudio");

        if(errorCount() != errCount) return SDLMixerSupport.badLibrary;
        else loadedVersion = (sdlMixerSupport >= SDLMixerSupport.sdlMixer201) ? SDLMixerSupport.sdlMixer201 : SDLMixerSupport.sdlMixer200;

        static if(sdlMixerSupport >= SDLMixerSupport.sdlMixer202) {
            lib.bindSymbol(cast(void**)&Mix_OpenAudioDevice,"Mix_OpenAudioDevice");
            lib.bindSymbol(cast(void**)&Mix_HasChunkDecoder,"Mix_HasChunkDecoder");

            if(errorCount() != errCount) return SDLMixerSupport.badLibrary;
            else loadedVersion = (sdlMixerSupport >= SDLMixerSupport.sdlMixer204) ? SDLMixerSupport.sdlMixer204 : SDLMixerSupport.sdlMixer202;
        }

        return loadedVersion;
    }
}