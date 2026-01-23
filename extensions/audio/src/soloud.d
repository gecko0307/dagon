module soloud;

public import bindbc.soloud;

nothrow @nogc:

public struct SoloudObject
{
    public int* objhandle;
}

public struct Soloud
{
  nothrow @nogc:
    public enum AUTO = 0;
    public enum SDL1 = 1;
    public enum SDL2 = 2;
    public enum PORTAUDIO = 3;
    public enum WINMM = 4;
    public enum XAUDIO2 = 5;
    public enum WASAPI = 6;
    public enum ALSA = 7;
    public enum JACK = 8;
    public enum OSS = 9;
    public enum OPENAL = 10;
    public enum COREAUDIO = 11;
    public enum OPENSLES = 12;
    public enum VITA_HOMEBREW = 13;
    public enum MINIAUDIO = 14;
    public enum NOSOUND = 15;
    public enum NULLDRIVER = 16;
    public enum BACKEND_MAX = 17;
    public enum CLIP_ROUNDOFF = 1;
    public enum ENABLE_VISUALIZATION = 2;
    public enum LEFT_HANDED_3D = 4;
    public enum NO_FPU_REGISTER_CHANGE = 8;
    public enum WAVE_SQUARE = 0;
    public enum WAVE_SAW = 1;
    public enum WAVE_SIN = 2;
    public enum WAVE_TRIANGLE = 3;
    public enum WAVE_BOUNCE = 4;
    public enum WAVE_JAWS = 5;
    public enum WAVE_HUMPS = 6;
    public enum WAVE_FSQUARE = 7;
    public enum WAVE_FSAW = 8;
    public enum RESAMPLER_POINT = 0;
    public enum RESAMPLER_LINEAR = 1;
    public enum RESAMPLER_CATMULLROM = 2;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Soloud(SoloudObject(Soloud_create()));
    }

    void free()
    {
        Soloud_destroy(objhandle);
    }

    public int init(uint aFlags = CLIP_ROUNDOFF, uint aBackend = AUTO, uint aSamplerate = AUTO, uint aBufferSize = AUTO, uint aChannels = 2)
    {
        return Soloud_initEx(objhandle, aFlags, aBackend, aSamplerate, aBufferSize, aChannels);
    }
    
    public void deinit()
    {
        Soloud_deinit(objhandle);
    }

    public uint getVersion()
    {
        return Soloud_getVersion(objhandle);
    }

    public const(char)* getErrorString(int aErrorCode)
    {
        return Soloud_getErrorString(objhandle, aErrorCode);
    }

    public uint getBackendId()
    {
        return Soloud_getBackendId(objhandle);
    }

    public const(char)* getBackendString()
    {
        return Soloud_getBackendString(objhandle);
    }

    public uint getBackendChannels()
    {
        return Soloud_getBackendChannels(objhandle);
    }

    public uint getBackendSamplerate()
    {
        return Soloud_getBackendSamplerate(objhandle);
    }

    public uint getBackendBufferSize()
    {
        return Soloud_getBackendBufferSize(objhandle);
    }

    public int setSpeakerPosition(uint aChannel, float aX, float aY, float aZ)
    {
        return Soloud_setSpeakerPosition(objhandle, aChannel, aX, aY, aZ);
    }

    public int getSpeakerPosition(uint aChannel, float[] aX, float[] aY, float[] aZ)
    {
        return Soloud_getSpeakerPosition(objhandle, aChannel, aX, aY, aZ);
    }

    public uint play(SoloudObject aSound, float aVolume = -1.0f, float aPan = 0.0f, int aPaused = 0, uint aBus = 0)
    {
        return Soloud_playEx(objhandle, aSound.objhandle, aVolume, aPan, aPaused, aBus);
    }

    public uint playClocked(double aSoundTime, SoloudObject aSound, float aVolume = -1.0f, float aPan = 0.0f, uint aBus = 0)
    {
        return Soloud_playClockedEx(objhandle, aSoundTime, aSound.objhandle, aVolume, aPan, aBus);
    }

    public uint play3d(SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, int aPaused = 0, uint aBus = 0)
    {
        return Soloud_play3dEx(objhandle, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused, aBus);
    }

    public uint play3dClocked(double aSoundTime, SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, uint aBus = 0)
    {
        return Soloud_play3dClockedEx(objhandle, aSoundTime, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aBus);
    }

    public uint playBackground(SoloudObject aSound, float aVolume = -1.0f, int aPaused = 0, uint aBus = 0)
    {
        return Soloud_playBackgroundEx(objhandle, aSound.objhandle, aVolume, aPaused, aBus);
    }

    public int seek(uint aVoiceHandle, double aSeconds)
    {
        return Soloud_seek(objhandle, aVoiceHandle, aSeconds);
    }

    public void stop(uint aVoiceHandle)
    {
        Soloud_stop(objhandle, aVoiceHandle);
    }

    public void stopAll()
    {
        Soloud_stopAll(objhandle);
    }

    public void stopAudioSource(SoloudObject aSound)
    {
        Soloud_stopAudioSource(objhandle, aSound.objhandle);
    }

    public int countAudioSource(SoloudObject aSound)
    {
        return Soloud_countAudioSource(objhandle, aSound.objhandle);
    }

    public void setFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aValue)
    {
        Soloud_setFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aValue);
    }

    public float getFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId)
    {
        return Soloud_getFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId);
    }

    public void fadeFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aTo, double aTime)
    {
        Soloud_fadeFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aTo, aTime);
    }

    public void oscillateFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aFrom, float aTo, double aTime)
    {
        Soloud_oscillateFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aFrom, aTo, aTime);
    }

    public double getStreamTime(uint aVoiceHandle)
    {
        return Soloud_getStreamTime(objhandle, aVoiceHandle);
    }

    public double getStreamPosition(uint aVoiceHandle)
    {
        return Soloud_getStreamPosition(objhandle, aVoiceHandle);
    }

    public int getPause(uint aVoiceHandle)
    {
        return Soloud_getPause(objhandle, aVoiceHandle);
    }

    public float getVolume(uint aVoiceHandle)
    {
        return Soloud_getVolume(objhandle, aVoiceHandle);
    }

    public float getOverallVolume(uint aVoiceHandle)
    {
        return Soloud_getOverallVolume(objhandle, aVoiceHandle);
    }

    public float getPan(uint aVoiceHandle)
    {
        return Soloud_getPan(objhandle, aVoiceHandle);
    }

    public float getSamplerate(uint aVoiceHandle)
    {
        return Soloud_getSamplerate(objhandle, aVoiceHandle);
    }

    public int getProtectVoice(uint aVoiceHandle)
    {
        return Soloud_getProtectVoice(objhandle, aVoiceHandle);
    }

    public uint getActiveVoiceCount()
    {
        return Soloud_getActiveVoiceCount(objhandle);
    }

    public uint getVoiceCount()
    {
        return Soloud_getVoiceCount(objhandle);
    }

    public int isValidVoiceHandle(uint aVoiceHandle)
    {
        return Soloud_isValidVoiceHandle(objhandle, aVoiceHandle);
    }

    public float getRelativePlaySpeed(uint aVoiceHandle)
    {
        return Soloud_getRelativePlaySpeed(objhandle, aVoiceHandle);
    }

    public float getPostClipScaler()
    {
        return Soloud_getPostClipScaler(objhandle);
    }

    public uint getMainResampler()
    {
        return Soloud_getMainResampler(objhandle);
    }

    public float getGlobalVolume()
    {
        return Soloud_getGlobalVolume(objhandle);
    }

    public uint getMaxActiveVoiceCount()
    {
        return Soloud_getMaxActiveVoiceCount(objhandle);
    }

    public int getLooping(uint aVoiceHandle)
    {
        return Soloud_getLooping(objhandle, aVoiceHandle);
    }

    public int getAutoStop(uint aVoiceHandle)
    {
        return Soloud_getAutoStop(objhandle, aVoiceHandle);
    }

    public double getLoopPoint(uint aVoiceHandle)
    {
        return Soloud_getLoopPoint(objhandle, aVoiceHandle);
    }

    public void setLoopPoint(uint aVoiceHandle, double aLoopPoint)
    {
        Soloud_setLoopPoint(objhandle, aVoiceHandle, aLoopPoint);
    }

    public void setLooping(uint aVoiceHandle, int aLooping)
    {
        Soloud_setLooping(objhandle, aVoiceHandle, aLooping);
    }

    public void setAutoStop(uint aVoiceHandle, int aAutoStop)
    {
        Soloud_setAutoStop(objhandle, aVoiceHandle, aAutoStop);
    }

    public int setMaxActiveVoiceCount(uint aVoiceCount)
    {
        return Soloud_setMaxActiveVoiceCount(objhandle, aVoiceCount);
    }

    public void setInaudibleBehavior(uint aVoiceHandle, int aMustTick, int aKill)
    {
        Soloud_setInaudibleBehavior(objhandle, aVoiceHandle, aMustTick, aKill);
    }

    public void setGlobalVolume(float aVolume)
    {
        Soloud_setGlobalVolume(objhandle, aVolume);
    }

    public void setPostClipScaler(float aScaler)
    {
        Soloud_setPostClipScaler(objhandle, aScaler);
    }

    public void setMainResampler(uint aResampler)
    {
        Soloud_setMainResampler(objhandle, aResampler);
    }

    public void setPause(uint aVoiceHandle, int aPause)
    {
        Soloud_setPause(objhandle, aVoiceHandle, aPause);
    }

    public void setPauseAll(int aPause)
    {
        Soloud_setPauseAll(objhandle, aPause);
    }

    public int setRelativePlaySpeed(uint aVoiceHandle, float aSpeed)
    {
        return Soloud_setRelativePlaySpeed(objhandle, aVoiceHandle, aSpeed);
    }

    public void setProtectVoice(uint aVoiceHandle, int aProtect)
    {
        Soloud_setProtectVoice(objhandle, aVoiceHandle, aProtect);
    }

    public void setSamplerate(uint aVoiceHandle, float aSamplerate)
    {
        Soloud_setSamplerate(objhandle, aVoiceHandle, aSamplerate);
    }

    public void setPan(uint aVoiceHandle, float aPan)
    {
        Soloud_setPan(objhandle, aVoiceHandle, aPan);
    }

    public void setPanAbsolute(uint aVoiceHandle, float aLVolume, float aRVolume)
    {
        Soloud_setPanAbsolute(objhandle, aVoiceHandle, aLVolume, aRVolume);
    }

    public void setChannelVolume(uint aVoiceHandle, uint aChannel, float aVolume)
    {
        Soloud_setChannelVolume(objhandle, aVoiceHandle, aChannel, aVolume);
    }

    public void setVolume(uint aVoiceHandle, float aVolume)
    {
        Soloud_setVolume(objhandle, aVoiceHandle, aVolume);
    }

    public void setDelaySamples(uint aVoiceHandle, uint aSamples)
    {
        Soloud_setDelaySamples(objhandle, aVoiceHandle, aSamples);
    }

    public void fadeVolume(uint aVoiceHandle, float aTo, double aTime)
    {
        Soloud_fadeVolume(objhandle, aVoiceHandle, aTo, aTime);
    }

    public void fadePan(uint aVoiceHandle, float aTo, double aTime)
    {
        Soloud_fadePan(objhandle, aVoiceHandle, aTo, aTime);
    }

    public void fadeRelativePlaySpeed(uint aVoiceHandle, float aTo, double aTime)
    {
        Soloud_fadeRelativePlaySpeed(objhandle, aVoiceHandle, aTo, aTime);
    }

    public void fadeGlobalVolume(float aTo, double aTime)
    {
        Soloud_fadeGlobalVolume(objhandle, aTo, aTime);
    }

    public void schedulePause(uint aVoiceHandle, double aTime)
    {
        Soloud_schedulePause(objhandle, aVoiceHandle, aTime);
    }

    public void scheduleStop(uint aVoiceHandle, double aTime)
    {
        Soloud_scheduleStop(objhandle, aVoiceHandle, aTime);
    }

    public void oscillateVolume(uint aVoiceHandle, float aFrom, float aTo, double aTime)
    {
        Soloud_oscillateVolume(objhandle, aVoiceHandle, aFrom, aTo, aTime);
    }

    public void oscillatePan(uint aVoiceHandle, float aFrom, float aTo, double aTime)
    {
        Soloud_oscillatePan(objhandle, aVoiceHandle, aFrom, aTo, aTime);
    }

    public void oscillateRelativePlaySpeed(uint aVoiceHandle, float aFrom, float aTo, double aTime)
    {
        Soloud_oscillateRelativePlaySpeed(objhandle, aVoiceHandle, aFrom, aTo, aTime);
    }

    public void oscillateGlobalVolume(float aFrom, float aTo, double aTime)
    {
        Soloud_oscillateGlobalVolume(objhandle, aFrom, aTo, aTime);
    }

    public void setGlobalFilter(uint aFilterId, SoloudObject aFilter)
    {
        Soloud_setGlobalFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void setVisualizationEnable(int aEnable)
    {
        Soloud_setVisualizationEnable(objhandle, aEnable);
    }

    public float[] calcFFT()
    {
        return Soloud_calcFFT(objhandle);
    }

    public float[] getWave()
    {
        return Soloud_getWave(objhandle);
    }

    public float getApproximateVolume(uint aChannel)
    {
        return Soloud_getApproximateVolume(objhandle, aChannel);
    }

    public uint getLoopCount(uint aVoiceHandle)
    {
        return Soloud_getLoopCount(objhandle, aVoiceHandle);
    }

    public float getInfo(uint aVoiceHandle, uint aInfoKey)
    {
        return Soloud_getInfo(objhandle, aVoiceHandle, aInfoKey);
    }

    public uint createVoiceGroup()
    {
        return Soloud_createVoiceGroup(objhandle);
    }

    public int destroyVoiceGroup(uint aVoiceGroupHandle)
    {
        return Soloud_destroyVoiceGroup(objhandle, aVoiceGroupHandle);
    }

    public int addVoiceToGroup(uint aVoiceGroupHandle, uint aVoiceHandle)
    {
        return Soloud_addVoiceToGroup(objhandle, aVoiceGroupHandle, aVoiceHandle);
    }

    public int isVoiceGroup(uint aVoiceGroupHandle)
    {
        return Soloud_isVoiceGroup(objhandle, aVoiceGroupHandle);
    }

    public int isVoiceGroupEmpty(uint aVoiceGroupHandle)
    {
        return Soloud_isVoiceGroupEmpty(objhandle, aVoiceGroupHandle);
    }

    public void update3dAudio()
    {
        Soloud_update3dAudio(objhandle);
    }

    public int set3dSoundSpeed(float aSpeed)
    {
        return Soloud_set3dSoundSpeed(objhandle, aSpeed);
    }

    public float get3dSoundSpeed()
    {
        return Soloud_get3dSoundSpeed(objhandle);
    }

    public void set3dListenerParameters(float aPosX, float aPosY, float aPosZ, float aAtX, float aAtY, float aAtZ, float aUpX, float aUpY, float aUpZ, float aVelocityX = 0.0f, float aVelocityY = 0.0f, float aVelocityZ = 0.0f)
    {
        Soloud_set3dListenerParametersEx(objhandle, aPosX, aPosY, aPosZ, aAtX, aAtY, aAtZ, aUpX, aUpY, aUpZ, aVelocityX, aVelocityY, aVelocityZ);
    }

    public void set3dListenerPosition(float aPosX, float aPosY, float aPosZ)
    {
        Soloud_set3dListenerPosition(objhandle, aPosX, aPosY, aPosZ);
    }

    public void set3dListenerAt(float aAtX, float aAtY, float aAtZ)
    {
        Soloud_set3dListenerAt(objhandle, aAtX, aAtY, aAtZ);
    }

    public void set3dListenerUp(float aUpX, float aUpY, float aUpZ)
    {
        Soloud_set3dListenerUp(objhandle, aUpX, aUpY, aUpZ);
    }

    public void set3dListenerVelocity(float aVelocityX, float aVelocityY, float aVelocityZ)
    {
        Soloud_set3dListenerVelocity(objhandle, aVelocityX, aVelocityY, aVelocityZ);
    }

    public void set3dSourceParameters(uint aVoiceHandle, float aPosX, float aPosY, float aPosZ, float aVelocityX = 0.0f, float aVelocityY = 0.0f, float aVelocityZ = 0.0f)
    {
        Soloud_set3dSourceParametersEx(objhandle, aVoiceHandle, aPosX, aPosY, aPosZ, aVelocityX, aVelocityY, aVelocityZ);
    }

    public void set3dSourcePosition(uint aVoiceHandle, float aPosX, float aPosY, float aPosZ)
    {
        Soloud_set3dSourcePosition(objhandle, aVoiceHandle, aPosX, aPosY, aPosZ);
    }

    public void set3dSourceVelocity(uint aVoiceHandle, float aVelocityX, float aVelocityY, float aVelocityZ)
    {
        Soloud_set3dSourceVelocity(objhandle, aVoiceHandle, aVelocityX, aVelocityY, aVelocityZ);
    }

    public void set3dSourceMinMaxDistance(uint aVoiceHandle, float aMinDistance, float aMaxDistance)
    {
        Soloud_set3dSourceMinMaxDistance(objhandle, aVoiceHandle, aMinDistance, aMaxDistance);
    }

    public void set3dSourceAttenuation(uint aVoiceHandle, uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Soloud_set3dSourceAttenuation(objhandle, aVoiceHandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dSourceDopplerFactor(uint aVoiceHandle, float aDopplerFactor)
    {
        Soloud_set3dSourceDopplerFactor(objhandle, aVoiceHandle, aDopplerFactor);
    }

    public void mix(float[] aBuffer, uint aSamples)
    {
        Soloud_mix(objhandle, aBuffer, aSamples);
    }

    public void mixSigned16(short[] aBuffer, uint aSamples)
    {
        Soloud_mixSigned16(objhandle, aBuffer, aSamples);
    }

}

public struct Ay
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Ay(SoloudObject(Ay_create()));
    }

    void free()
    {
        Ay_destroy(objhandle);
    }

    public void setVolume(float aVolume)
    {
        Ay_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Ay_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Ay_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Ay_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Ay_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Ay_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Ay_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Ay_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Ay_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Ay_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Ay_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Ay_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Ay_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Ay_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Ay_stop(objhandle);
    }

}

public struct BassboostFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum BOOST = 1;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return BassboostFilter(SoloudObject(BassboostFilter_create()));
    }

    void free()
    {
        BassboostFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return BassboostFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return BassboostFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return BassboostFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return BassboostFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return BassboostFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(float aBoost)
    {
        return BassboostFilter_setParams(objhandle, aBoost);
    }

}

public struct BiquadResonantFilter
{
  nothrow @nogc:
    public enum LOWPASS = 0;
    public enum HIGHPASS = 1;
    public enum BANDPASS = 2;
    public enum WET = 0;
    public enum TYPE = 1;
    public enum FREQUENCY = 2;
    public enum RESONANCE = 3;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return BiquadResonantFilter(SoloudObject(BiquadResonantFilter_create()));
    }

    void free()
    {
        BiquadResonantFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return BiquadResonantFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return BiquadResonantFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return BiquadResonantFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return BiquadResonantFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return BiquadResonantFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(int aType, float aFrequency, float aResonance)
    {
        return BiquadResonantFilter_setParams(objhandle, aType, aFrequency, aResonance);
    }

}

public struct Bus
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Bus(SoloudObject(Bus_create()));
    }

    void free()
    {
        Bus_destroy(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Bus_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public uint play(SoloudObject aSound, float aVolume = 1.0f, float aPan = 0.0f, int aPaused = 0)
    {
        return Bus_playEx(objhandle, aSound.objhandle, aVolume, aPan, aPaused);
    }

    public uint playClocked(double aSoundTime, SoloudObject aSound, float aVolume = 1.0f, float aPan = 0.0f)
    {
        return Bus_playClockedEx(objhandle, aSoundTime, aSound.objhandle, aVolume, aPan);
    }

    public uint play3d(SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, int aPaused = 0)
    {
        return Bus_play3dEx(objhandle, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused);
    }

    public uint play3dClocked(double aSoundTime, SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f)
    {
        return Bus_play3dClockedEx(objhandle, aSoundTime, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume);
    }

    public int setChannels(uint aChannels)
    {
        return Bus_setChannels(objhandle, aChannels);
    }

    public void setVisualizationEnable(int aEnable)
    {
        Bus_setVisualizationEnable(objhandle, aEnable);
    }

    public void annexSound(uint aVoiceHandle)
    {
        Bus_annexSound(objhandle, aVoiceHandle);
    }

    public float[] calcFFT()
    {
        return Bus_calcFFT(objhandle);
    }

    public float[] getWave()
    {
        return Bus_getWave(objhandle);
    }

    public float getApproximateVolume(uint aChannel)
    {
        return Bus_getApproximateVolume(objhandle, aChannel);
    }

    public uint getActiveVoiceCount()
    {
        return Bus_getActiveVoiceCount(objhandle);
    }

    public uint getResampler()
    {
        return Bus_getResampler(objhandle);
    }

    public void setResampler(uint aResampler)
    {
        Bus_setResampler(objhandle, aResampler);
    }

    public void setVolume(float aVolume)
    {
        Bus_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Bus_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Bus_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Bus_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Bus_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Bus_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Bus_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Bus_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Bus_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Bus_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Bus_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Bus_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Bus_getLoopPoint(objhandle);
    }

    public void stop()
    {
        Bus_stop(objhandle);
    }

}

public struct DCRemovalFilter
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return DCRemovalFilter(SoloudObject(DCRemovalFilter_create()));
    }

    void free()
    {
        DCRemovalFilter_destroy(objhandle);
    }

    public int setParams(float aLength = 0.1f)
    {
        return DCRemovalFilter_setParamsEx(objhandle, aLength);
    }

    public int getParamCount()
    {
        return DCRemovalFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return DCRemovalFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return DCRemovalFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return DCRemovalFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return DCRemovalFilter_getParamMin(objhandle, aParamIndex);
    }

}

public struct EchoFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum DELAY = 1;
    public enum DECAY = 2;
    public enum FILTER = 3;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return EchoFilter(SoloudObject(EchoFilter_create()));
    }

    void free()
    {
        EchoFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return EchoFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return EchoFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return EchoFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return EchoFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return EchoFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(float aDelay, float aDecay = 0.7f, float aFilter = 0.0f)
    {
        return EchoFilter_setParamsEx(objhandle, aDelay, aDecay, aFilter);
    }

}

public struct FFTFilter
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return FFTFilter(SoloudObject(FFTFilter_create()));
    }

    void free()
    {
        FFTFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return FFTFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return FFTFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return FFTFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return FFTFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return FFTFilter_getParamMin(objhandle, aParamIndex);
    }

}

public struct FlangerFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum DELAY = 1;
    public enum FREQ = 2;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return FlangerFilter(SoloudObject(FlangerFilter_create()));
    }

    void free()
    {
        FlangerFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return FlangerFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return FlangerFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return FlangerFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return FlangerFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return FlangerFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(float aDelay, float aFreq)
    {
        return FlangerFilter_setParams(objhandle, aDelay, aFreq);
    }

}

public struct FreeverbFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum FREEZE = 1;
    public enum ROOMSIZE = 2;
    public enum DAMP = 3;
    public enum WIDTH = 4;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return FreeverbFilter(SoloudObject(FreeverbFilter_create()));
    }

    void free()
    {
        FreeverbFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return FreeverbFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return FreeverbFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return FreeverbFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return FreeverbFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return FreeverbFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(float aMode, float aRoomSize, float aDamp, float aWidth)
    {
        return FreeverbFilter_setParams(objhandle, aMode, aRoomSize, aDamp, aWidth);
    }

}

public struct LofiFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum SAMPLERATE = 1;
    public enum BITDEPTH = 2;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return LofiFilter(SoloudObject(LofiFilter_create()));
    }

    void free()
    {
        LofiFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return LofiFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return LofiFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return LofiFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return LofiFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return LofiFilter_getParamMin(objhandle, aParamIndex);
    }

    public int setParams(float aSampleRate, float aBitdepth)
    {
        return LofiFilter_setParams(objhandle, aSampleRate, aBitdepth);
    }

}

public struct Monotone
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Monotone(SoloudObject(Monotone_create()));
    }

    void free()
    {
        Monotone_destroy(objhandle);
    }

    public int setParams(int aHardwareChannels, int aWaveform = Soloud.WAVE_SQUARE)
    {
        return Monotone_setParamsEx(objhandle, aHardwareChannels, aWaveform);
    }

    public int load(const(char)* aFilename)
    {
        return Monotone_load(objhandle, aFilename);
    }

    public int loadMem(ubyte* aMem, uint aLength, int aCopy = false, int aTakeOwnership = true)
    {
        return Monotone_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
    }

    public int loadFile(SoloudObject aFile)
    {
        return Monotone_loadFile(objhandle, aFile.objhandle);
    }

    public void setVolume(float aVolume)
    {
        Monotone_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Monotone_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Monotone_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Monotone_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Monotone_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Monotone_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Monotone_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Monotone_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Monotone_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Monotone_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Monotone_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Monotone_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Monotone_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Monotone_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Monotone_stop(objhandle);
    }

}

public struct Noise
{
  nothrow @nogc:
    public enum WHITE = 0;
    public enum PINK = 1;
    public enum BROWNISH = 2;
    public enum BLUEISH = 3;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Noise(SoloudObject(Noise_create()));
    }

    void free()
    {
        Noise_destroy(objhandle);
    }

    public void setOctaveScale(float aOct0, float aOct1, float aOct2, float aOct3, float aOct4, float aOct5, float aOct6, float aOct7, float aOct8, float aOct9)
    {
        Noise_setOctaveScale(objhandle, aOct0, aOct1, aOct2, aOct3, aOct4, aOct5, aOct6, aOct7, aOct8, aOct9);
    }

    public void setType(int aType)
    {
        Noise_setType(objhandle, aType);
    }

    public void setVolume(float aVolume)
    {
        Noise_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Noise_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Noise_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Noise_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Noise_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Noise_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Noise_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Noise_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Noise_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Noise_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Noise_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Noise_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Noise_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Noise_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Noise_stop(objhandle);
    }

}

public struct Openmpt
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Openmpt(SoloudObject(Openmpt_create()));
    }

    void free()
    {
        Openmpt_destroy(objhandle);
    }

    public int load(const(char)* aFilename)
    {
        return Openmpt_load(objhandle, aFilename);
    }

    public int loadMem(ubyte* aMem, uint aLength, int aCopy = false, int aTakeOwnership = true)
    {
        return Openmpt_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
    }

    public int loadFile(SoloudObject aFile)
    {
        return Openmpt_loadFile(objhandle, aFile.objhandle);
    }

    public void setVolume(float aVolume)
    {
        Openmpt_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Openmpt_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Openmpt_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Openmpt_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Openmpt_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Openmpt_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Openmpt_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Openmpt_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Openmpt_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Openmpt_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Openmpt_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Openmpt_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Openmpt_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Openmpt_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Openmpt_stop(objhandle);
    }

}

public struct Queue
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Queue(SoloudObject(Queue_create()));
    }

    void free()
    {
        Queue_destroy(objhandle);
    }

    public int play(SoloudObject aSound)
    {
        return Queue_play(objhandle, aSound.objhandle);
    }

    public uint getQueueCount()
    {
        return Queue_getQueueCount(objhandle);
    }

    public int isCurrentlyPlaying(SoloudObject aSound)
    {
        return Queue_isCurrentlyPlaying(objhandle, aSound.objhandle);
    }

    public int setParamsFromAudioSource(SoloudObject aSound)
    {
        return Queue_setParamsFromAudioSource(objhandle, aSound.objhandle);
    }

    public int setParams(float aSamplerate, uint aChannels = 2)
    {
        return Queue_setParamsEx(objhandle, aSamplerate, aChannels);
    }

    public void setVolume(float aVolume)
    {
        Queue_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Queue_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Queue_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Queue_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Queue_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Queue_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Queue_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Queue_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Queue_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Queue_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Queue_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Queue_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Queue_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Queue_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Queue_stop(objhandle);
    }

}

public struct RobotizeFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum FREQ = 1;
    public enum WAVE = 2;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return RobotizeFilter(SoloudObject(RobotizeFilter_create()));
    }

    void free()
    {
        RobotizeFilter_destroy(objhandle);
    }

    public int getParamCount()
    {
        return RobotizeFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return RobotizeFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return RobotizeFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return RobotizeFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return RobotizeFilter_getParamMin(objhandle, aParamIndex);
    }

    public void setParams(float aFreq, int aWaveform)
    {
        RobotizeFilter_setParams(objhandle, aFreq, aWaveform);
    }

}

public struct Sfxr
{
  nothrow @nogc:
    public enum COIN = 0;
    public enum LASER = 1;
    public enum EXPLOSION = 2;
    public enum POWERUP = 3;
    public enum HURT = 4;
    public enum JUMP = 5;
    public enum BLIP = 6;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Sfxr(SoloudObject(Sfxr_create()));
    }

    void free()
    {
        Sfxr_destroy(objhandle);
    }

    public void resetParams()
    {
        Sfxr_resetParams(objhandle);
    }

    public int loadParams(const(char)* aFilename)
    {
        return Sfxr_loadParams(objhandle, aFilename);
    }

    public int loadParamsMem(ubyte* aMem, uint aLength, int aCopy = false, int aTakeOwnership = true)
    {
        return Sfxr_loadParamsMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
    }

    public int loadParamsFile(SoloudObject aFile)
    {
        return Sfxr_loadParamsFile(objhandle, aFile.objhandle);
    }

    public int loadPreset(int aPresetNo, int aRandSeed)
    {
        return Sfxr_loadPreset(objhandle, aPresetNo, aRandSeed);
    }

    public void setVolume(float aVolume)
    {
        Sfxr_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Sfxr_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Sfxr_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Sfxr_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Sfxr_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Sfxr_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Sfxr_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Sfxr_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Sfxr_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Sfxr_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Sfxr_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Sfxr_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Sfxr_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Sfxr_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Sfxr_stop(objhandle);
    }

}

public struct Speech
{
  nothrow @nogc:
    public enum KW_SAW = 0;
    public enum KW_TRIANGLE = 1;
    public enum KW_SIN = 2;
    public enum KW_SQUARE = 3;
    public enum KW_PULSE = 4;
    public enum KW_NOISE = 5;
    public enum KW_WARBLE = 6;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Speech(SoloudObject(Speech_create()));
    }

    void free()
    {
        Speech_destroy(objhandle);
    }

    public int setText(const(char)* aText)
    {
        return Speech_setText(objhandle, aText);
    }

    public int setParams(uint aBaseFrequency = 1330, float aBaseSpeed = 10.0f, float aBaseDeclination = 0.5f, int aBaseWaveform = KW_TRIANGLE)
    {
        return Speech_setParamsEx(objhandle, aBaseFrequency, aBaseSpeed, aBaseDeclination, aBaseWaveform);
    }

    public void setVolume(float aVolume)
    {
        Speech_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Speech_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Speech_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Speech_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Speech_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Speech_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Speech_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Speech_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Speech_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Speech_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Speech_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Speech_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Speech_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Speech_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Speech_stop(objhandle);
    }

}

public struct TedSid
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return TedSid(SoloudObject(TedSid_create()));
    }

    void free()
    {
        TedSid_destroy(objhandle);
    }

    public int load(const(char)* aFilename)
    {
        return TedSid_load(objhandle, aFilename);
    }

    public int loadMem(ubyte* aMem, uint aLength, int aCopy = false, int aTakeOwnership = true)
    {
        return TedSid_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
    }

    public int loadFile(SoloudObject aFile)
    {
        return TedSid_loadFile(objhandle, aFile.objhandle);
    }

    public void setVolume(float aVolume)
    {
        TedSid_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        TedSid_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        TedSid_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        TedSid_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        TedSid_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        TedSid_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        TedSid_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        TedSid_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        TedSid_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        TedSid_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        TedSid_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        TedSid_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return TedSid_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        TedSid_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        TedSid_stop(objhandle);
    }

}

public struct Vic
{
  nothrow @nogc:
    public enum PAL = 0;
    public enum NTSC = 1;
    public enum BASS = 0;
    public enum ALTO = 1;
    public enum SOPRANO = 2;
    public enum NOISE = 3;
    public enum MAX_REGS = 4;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Vic(SoloudObject(Vic_create()));
    }

    void free()
    {
        Vic_destroy(objhandle);
    }

    public void setModel(int model)
    {
        Vic_setModel(objhandle, model);
    }

    public int getModel()
    {
        return Vic_getModel(objhandle);
    }

    public void setRegister(int reg, ubyte value)
    {
        Vic_setRegister(objhandle, reg, value);
    }

    public ubyte getRegister(int reg)
    {
        return Vic_getRegister(objhandle, reg);
    }

    public void setVolume(float aVolume)
    {
        Vic_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Vic_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Vic_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Vic_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Vic_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Vic_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Vic_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Vic_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Vic_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Vic_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Vic_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Vic_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Vic_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Vic_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Vic_stop(objhandle);
    }

}

public struct Vizsn
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Vizsn(SoloudObject(Vizsn_create()));
    }

    void free()
    {
        Vizsn_destroy(objhandle);
    }

    public void setText(char* aText)
    {
        Vizsn_setText(objhandle, aText);
    }

    public void setVolume(float aVolume)
    {
        Vizsn_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Vizsn_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Vizsn_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Vizsn_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Vizsn_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Vizsn_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Vizsn_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Vizsn_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Vizsn_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Vizsn_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Vizsn_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Vizsn_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Vizsn_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Vizsn_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Vizsn_stop(objhandle);
    }

}

public struct Wav
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return Wav(SoloudObject(Wav_create()));
    }

    void free()
    {
        Wav_destroy(objhandle);
    }

    public int load(const(char)* aFilename)
    {
        return Wav_load(objhandle, aFilename);
    }

    public int loadMem(ubyte* aMem, uint aLength, int aCopy = false, int aTakeOwnership = true)
    {
        return Wav_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
    }

    public int loadFile(SoloudObject aFile)
    {
        return Wav_loadFile(objhandle, aFile.objhandle);
    }

    public int loadRawWave8(ubyte* aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1)
    {
        return Wav_loadRawWave8Ex(objhandle, aMem, aLength, aSamplerate, aChannels);
    }

    public int loadRawWave16(short* aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1)
    {
        return Wav_loadRawWave16Ex(objhandle, aMem, aLength, aSamplerate, aChannels);
    }

    public int loadRawWave(float* aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1, int aCopy = false, int aTakeOwnership = true)
    {
        return Wav_loadRawWaveEx(objhandle, aMem, aLength, aSamplerate, aChannels, aCopy, aTakeOwnership);
    }

    public double getLength()
    {
        return Wav_getLength(objhandle);
    }

    public void setVolume(float aVolume)
    {
        Wav_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        Wav_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        Wav_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        Wav_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        Wav_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        Wav_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        Wav_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        Wav_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        Wav_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        Wav_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        Wav_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        Wav_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return Wav_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        Wav_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        Wav_stop(objhandle);
    }

}

public struct WaveShaperFilter
{
  nothrow @nogc:
    public enum WET = 0;
    public enum AMOUNT = 1;

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return WaveShaperFilter(SoloudObject(WaveShaperFilter_create()));
    }

    void free()
    {
        WaveShaperFilter_destroy(objhandle);
    }

    public int setParams(float aAmount)
    {
        return WaveShaperFilter_setParams(objhandle, aAmount);
    }

    public int getParamCount()
    {
        return WaveShaperFilter_getParamCount(objhandle);
    }

    public const(char)* getParamName(uint aParamIndex)
    {
        return WaveShaperFilter_getParamName(objhandle, aParamIndex);
    }

    public uint getParamType(uint aParamIndex)
    {
        return WaveShaperFilter_getParamType(objhandle, aParamIndex);
    }

    public float getParamMax(uint aParamIndex)
    {
        return WaveShaperFilter_getParamMax(objhandle, aParamIndex);
    }

    public float getParamMin(uint aParamIndex)
    {
        return WaveShaperFilter_getParamMin(objhandle, aParamIndex);
    }

}

public struct WavStream
{
  nothrow @nogc:

    public SoloudObject soloudObject;
    alias soloudObject this;

    public static create()
    {
        return WavStream(SoloudObject(WavStream_create()));
    }

    void free()
    {
        WavStream_destroy(objhandle);
    }

    public int load(const(char)* aFilename)
    {
        return WavStream_load(objhandle, aFilename);
    }

    public int loadMem(ubyte* aData, uint aDataLen, int aCopy = false, int aTakeOwnership = true)
    {
        return WavStream_loadMemEx(objhandle, aData, aDataLen, aCopy, aTakeOwnership);
    }

    public int loadToMem(const(char)* aFilename)
    {
        return WavStream_loadToMem(objhandle, aFilename);
    }

    public int loadFile(SoloudObject aFile)
    {
        return WavStream_loadFile(objhandle, aFile.objhandle);
    }

    public int loadFileToMem(SoloudObject aFile)
    {
        return WavStream_loadFileToMem(objhandle, aFile.objhandle);
    }

    public double getLength()
    {
        return WavStream_getLength(objhandle);
    }

    public void setVolume(float aVolume)
    {
        WavStream_setVolume(objhandle, aVolume);
    }

    public void setLooping(int aLoop)
    {
        WavStream_setLooping(objhandle, aLoop);
    }

    public void setAutoStop(int aAutoStop)
    {
        WavStream_setAutoStop(objhandle, aAutoStop);
    }

    public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
    {
        WavStream_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
    }

    public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
    {
        WavStream_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
    }

    public void set3dDopplerFactor(float aDopplerFactor)
    {
        WavStream_set3dDopplerFactor(objhandle, aDopplerFactor);
    }

    public void set3dListenerRelative(int aListenerRelative)
    {
        WavStream_set3dListenerRelative(objhandle, aListenerRelative);
    }

    public void set3dDistanceDelay(int aDistanceDelay)
    {
        WavStream_set3dDistanceDelay(objhandle, aDistanceDelay);
    }

    public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
    {
        WavStream_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
    }

    public void set3dAttenuator(SoloudObject aAttenuator)
    {
        WavStream_set3dAttenuator(objhandle, aAttenuator.objhandle);
    }

    public void setInaudibleBehavior(int aMustTick, int aKill)
    {
        WavStream_setInaudibleBehavior(objhandle, aMustTick, aKill);
    }

    public void setLoopPoint(double aLoopPoint)
    {
        WavStream_setLoopPoint(objhandle, aLoopPoint);
    }

    public double getLoopPoint()
    {
        return WavStream_getLoopPoint(objhandle);
    }

    public void setFilter(uint aFilterId, SoloudObject aFilter)
    {
        WavStream_setFilter(objhandle, aFilterId, aFilter.objhandle);
    }

    public void stop()
    {
        WavStream_stop(objhandle);
    }
}
