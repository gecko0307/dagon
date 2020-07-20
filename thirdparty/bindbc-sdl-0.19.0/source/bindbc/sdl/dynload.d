
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.dynload;

version(BindBC_Static) {}
else version(BindSDL_Static) {}
else:

import bindbc.loader;
import bindbc.sdl.config,
       bindbc.sdl.bind;

private {
    SharedLib lib;
    SDLSupport loadedVersion;
}

void unloadSDL()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

SDLSupport loadedSDLVersion() { return loadedVersion; }

bool isSDLLoaded()
{
    return  lib != invalidHandle;
}

SDLSupport loadSDL()
{
    // #1778 prevents me from using static arrays here :(
    version(Windows) {
        const(char)[][1] libNames = ["SDL2.dll"];
    }
    else version(OSX) {
        const(char)[][7] libNames = [
            "libSDL2.dylib",
            "/usr/local/lib/libSDL2.dylib",
            "/usr/local/lib/libSDL2/libSDL2.dylib",
            "../Frameworks/SDL2.framework/SDL2",
            "/Library/Frameworks/SDL2.framework/SDL2",
            "/System/Library/Frameworks/SDL2.framework/SDL2",
            "/opt/local/lib/libSDL2.dylib"
        ];
    }
    else version(Posix) {
        const(char)[][6] libNames = [
            "libSDL2.so",
            "/usr/local/lib/libSDL2.so",
            "libSDL2-2.0.so",
            "/usr/local/lib/libSDL2-2.0.so",
            "libSDL2-2.0.so.0",
            "/usr/local/lib/libSDL2-2.0.so.0"
        ];
    }
    else static assert(0, "bindbc-sdl is not yet supported on this platform.");

    SDLSupport ret;
    foreach(name; libNames) {
        ret = loadSDL(name.ptr);
        if(ret != SDLSupport.noLibrary) break;
    }
    return ret;
}

SDLSupport loadSDL(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle) {
        return SDLSupport.noLibrary;
    }

    auto errCount = errorCount();
    loadedVersion = SDLSupport.badLibrary;

    lib.bindSymbol(cast(void**)&SDL_Init, "SDL_Init");
    lib.bindSymbol(cast(void**)&SDL_InitSubSystem, "SDL_InitSubSystem");
    lib.bindSymbol(cast(void**)&SDL_QuitSubSystem, "SDL_QuitSubSystem");
    lib.bindSymbol(cast(void**)&SDL_WasInit, "SDL_WasInit");
    lib.bindSymbol(cast(void**)&SDL_Quit, "SDL_Quit");
    lib.bindSymbol(cast(void**)&SDL_SetAssertionHandler, "SDL_SetAssertionHandler");
    lib.bindSymbol(cast(void**)&SDL_GetAssertionReport, "SDL_GetAssertionReport");
    lib.bindSymbol(cast(void**)&SDL_ResetAssertionReport, "SDL_ResetAssertionReport");
    lib.bindSymbol(cast(void**)&SDL_AtomicCAS, "SDL_AtomicCAS");
    lib.bindSymbol(cast(void**)&SDL_AtomicCASPtr, "SDL_AtomicCASPtr");
    lib.bindSymbol(cast(void**)&SDL_GetNumAudioDrivers, "SDL_GetNumAudioDrivers");
    lib.bindSymbol(cast(void**)&SDL_GetAudioDriver, "SDL_GetAudioDriver");
    lib.bindSymbol(cast(void**)&SDL_AudioInit, "SDL_AudioInit");
    lib.bindSymbol(cast(void**)&SDL_AudioQuit, "SDL_AudioQuit");
    lib.bindSymbol(cast(void**)&SDL_GetCurrentAudioDriver, "SDL_GetCurrentAudioDriver");
    lib.bindSymbol(cast(void**)&SDL_OpenAudio, "SDL_OpenAudio");
    lib.bindSymbol(cast(void**)&SDL_GetNumAudioDevices, "SDL_GetNumAudioDevices");
    lib.bindSymbol(cast(void**)&SDL_GetAudioDeviceName, "SDL_GetAudioDeviceName");
    lib.bindSymbol(cast(void**)&SDL_OpenAudioDevice, "SDL_OpenAudioDevice");
    lib.bindSymbol(cast(void**)&SDL_GetAudioStatus, "SDL_GetAudioStatus");
    lib.bindSymbol(cast(void**)&SDL_GetAudioDeviceStatus, "SDL_GetAudioDeviceStatus");
    lib.bindSymbol(cast(void**)&SDL_PauseAudio, "SDL_PauseAudio");
    lib.bindSymbol(cast(void**)&SDL_PauseAudioDevice, "SDL_PauseAudioDevice");
    lib.bindSymbol(cast(void**)&SDL_LoadWAV_RW, "SDL_LoadWAV_RW");
    lib.bindSymbol(cast(void**)&SDL_FreeWAV, "SDL_FreeWAV");
    lib.bindSymbol(cast(void**)&SDL_BuildAudioCVT, "SDL_BuildAudioCVT");
    lib.bindSymbol(cast(void**)&SDL_ConvertAudio, "SDL_ConvertAudio");
    lib.bindSymbol(cast(void**)&SDL_MixAudio, "SDL_MixAudio");
    lib.bindSymbol(cast(void**)&SDL_MixAudioFormat, "SDL_MixAudioFormat");
    lib.bindSymbol(cast(void**)&SDL_LockAudio, "SDL_LockAudio");
    lib.bindSymbol(cast(void**)&SDL_LockAudioDevice, "SDL_LockAudioDevice");
    lib.bindSymbol(cast(void**)&SDL_UnlockAudio, "SDL_UnlockAudio");
    lib.bindSymbol(cast(void**)&SDL_UnlockAudioDevice, "SDL_UnlockAudioDevice");
    lib.bindSymbol(cast(void**)&SDL_CloseAudio, "SDL_CloseAudio");
    lib.bindSymbol(cast(void**)&SDL_CloseAudioDevice, "SDL_CloseAudioDevice");
    lib.bindSymbol(cast(void**)&SDL_SetClipboardText, "SDL_SetClipboardText");
    lib.bindSymbol(cast(void**)&SDL_GetClipboardText, "SDL_GetClipboardText");
    lib.bindSymbol(cast(void**)&SDL_HasClipboardText, "SDL_HasClipboardText");
    lib.bindSymbol(cast(void**)&SDL_GetCPUCount, "SDL_GetCPUCount");
    lib.bindSymbol(cast(void**)&SDL_GetCPUCacheLineSize, "SDL_GetCPUCacheLineSize");
    lib.bindSymbol(cast(void**)&SDL_HasRDTSC, "SDL_HasRDTSC");
    lib.bindSymbol(cast(void**)&SDL_HasAltiVec, "SDL_HasAltiVec");
    lib.bindSymbol(cast(void**)&SDL_HasMMX, "SDL_HasMMX");
    lib.bindSymbol(cast(void**)&SDL_Has3DNow, "SDL_Has3DNow");
    lib.bindSymbol(cast(void**)&SDL_HasSSE, "SDL_HasSSE");
    lib.bindSymbol(cast(void**)&SDL_HasSSE2, "SDL_HasSSE2");
    lib.bindSymbol(cast(void**)&SDL_HasSSE3, "SDL_HasSSE3");
    lib.bindSymbol(cast(void**)&SDL_HasSSE41, "SDL_HasSSE41");
    lib.bindSymbol(cast(void**)&SDL_HasSSE42, "SDL_HasSSE42");
    lib.bindSymbol(cast(void**)&SDL_SetError, "SDL_SetError");
    lib.bindSymbol(cast(void**)&SDL_GetError, "SDL_GetError");
    lib.bindSymbol(cast(void**)&SDL_ClearError, "SDL_ClearError");
    lib.bindSymbol(cast(void**)&SDL_PumpEvents, "SDL_PumpEvents");
    lib.bindSymbol(cast(void**)&SDL_PeepEvents, "SDL_PeepEvents");
    lib.bindSymbol(cast(void**)&SDL_HasEvent, "SDL_HasEvent");
    lib.bindSymbol(cast(void**)&SDL_HasEvents, "SDL_HasEvents");
    lib.bindSymbol(cast(void**)&SDL_FlushEvent, "SDL_FlushEvent");
    lib.bindSymbol(cast(void**)&SDL_FlushEvents, "SDL_FlushEvents");
    lib.bindSymbol(cast(void**)&SDL_PollEvent, "SDL_PollEvent");
    lib.bindSymbol(cast(void**)&SDL_WaitEvent, "SDL_WaitEvent");
    lib.bindSymbol(cast(void**)&SDL_WaitEventTimeout, "SDL_WaitEventTimeout");
    lib.bindSymbol(cast(void**)&SDL_PushEvent, "SDL_PushEvent");
    lib.bindSymbol(cast(void**)&SDL_SetEventFilter, "SDL_SetEventFilter");
    lib.bindSymbol(cast(void**)&SDL_GetEventFilter, "SDL_GetEventFilter");
    lib.bindSymbol(cast(void**)&SDL_AddEventWatch, "SDL_AddEventWatch");
    lib.bindSymbol(cast(void**)&SDL_DelEventWatch, "SDL_DelEventWatch");
    lib.bindSymbol(cast(void**)&SDL_FilterEvents, "SDL_FilterEvents");
    lib.bindSymbol(cast(void**)&SDL_EventState, "SDL_EventState");
    lib.bindSymbol(cast(void**)&SDL_RegisterEvents, "SDL_RegisterEvents");
    lib.bindSymbol(cast(void**)&SDL_GameControllerAddMapping, "SDL_GameControllerAddMapping");
    lib.bindSymbol(cast(void**)&SDL_GameControllerMappingForGUID, "SDL_GameControllerMappingForGUID");
    lib.bindSymbol(cast(void**)&SDL_GameControllerMapping, "SDL_GameControllerMapping");
    lib.bindSymbol(cast(void**)&SDL_IsGameController, "SDL_IsGameController");
    lib.bindSymbol(cast(void**)&SDL_GameControllerNameForIndex, "SDL_GameControllerNameForIndex");
    lib.bindSymbol(cast(void**)&SDL_GameControllerOpen, "SDL_GameControllerOpen");
    lib.bindSymbol(cast(void**)&SDL_GameControllerName, "SDL_GameControllerName");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetAttached, "SDL_GameControllerGetAttached");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetJoystick, "SDL_GameControllerGetJoystick");
    lib.bindSymbol(cast(void**)&SDL_GameControllerEventState, "SDL_GameControllerEventState");
    lib.bindSymbol(cast(void**)&SDL_GameControllerUpdate, "SDL_GameControllerUpdate");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetAxisFromString, "SDL_GameControllerGetAxisFromString");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetStringForAxis, "SDL_GameControllerGetStringForAxis");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetBindForAxis, "SDL_GameControllerGetBindForAxis");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetAxis, "SDL_GameControllerGetAxis");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetButtonFromString, "SDL_GameControllerGetButtonFromString");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetStringForButton, "SDL_GameControllerGetStringForButton");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetBindForButton, "SDL_GameControllerGetBindForButton");
    lib.bindSymbol(cast(void**)&SDL_GameControllerGetButton, "SDL_GameControllerGetButton");
    lib.bindSymbol(cast(void**)&SDL_GameControllerClose, "SDL_GameControllerClose");
    lib.bindSymbol(cast(void**)&SDL_RecordGesture, "SDL_RecordGesture");
    lib.bindSymbol(cast(void**)&SDL_SaveAllDollarTemplates, "SDL_SaveAllDollarTemplates");
    lib.bindSymbol(cast(void**)&SDL_SaveDollarTemplate, "SDL_SaveDollarTemplate");
    lib.bindSymbol(cast(void**)&SDL_LoadDollarTemplates, "SDL_LoadDollarTemplates");
    lib.bindSymbol(cast(void**)&SDL_NumHaptics, "SDL_NumHaptics");
    lib.bindSymbol(cast(void**)&SDL_HapticName, "SDL_HapticName");
    lib.bindSymbol(cast(void**)&SDL_HapticOpen, "SDL_HapticOpen");
    lib.bindSymbol(cast(void**)&SDL_HapticOpened, "SDL_HapticOpened");
    lib.bindSymbol(cast(void**)&SDL_HapticIndex, "SDL_HapticIndex");
    lib.bindSymbol(cast(void**)&SDL_MouseIsHaptic, "SDL_MouseIsHaptic");
    lib.bindSymbol(cast(void**)&SDL_HapticOpenFromMouse, "SDL_HapticOpenFromMouse");
    lib.bindSymbol(cast(void**)&SDL_JoystickIsHaptic, "SDL_JoystickIsHaptic");
    lib.bindSymbol(cast(void**)&SDL_HapticOpenFromJoystick, "SDL_HapticOpenFromJoystick");
    lib.bindSymbol(cast(void**)&SDL_HapticClose, "SDL_HapticClose");
    lib.bindSymbol(cast(void**)&SDL_HapticNumEffects, "SDL_HapticNumEffects");
    lib.bindSymbol(cast(void**)&SDL_HapticNumEffectsPlaying, "SDL_HapticNumEffectsPlaying");
    lib.bindSymbol(cast(void**)&SDL_HapticQuery, "SDL_HapticQuery");
    lib.bindSymbol(cast(void**)&SDL_HapticNumAxes, "SDL_HapticNumAxes");
    lib.bindSymbol(cast(void**)&SDL_HapticEffectSupported, "SDL_HapticEffectSupported");
    lib.bindSymbol(cast(void**)&SDL_HapticNewEffect, "SDL_HapticNewEffect");
    lib.bindSymbol(cast(void**)&SDL_HapticUpdateEffect, "SDL_HapticUpdateEffect");
    lib.bindSymbol(cast(void**)&SDL_HapticRunEffect, "SDL_HapticRunEffect");
    lib.bindSymbol(cast(void**)&SDL_HapticStopEffect, "SDL_HapticStopEffect");
    lib.bindSymbol(cast(void**)&SDL_HapticDestroyEffect, "SDL_HapticDestroyEffect");
    lib.bindSymbol(cast(void**)&SDL_HapticGetEffectStatus, "SDL_HapticGetEffectStatus");
    lib.bindSymbol(cast(void**)&SDL_HapticSetGain, "SDL_HapticSetGain");
    lib.bindSymbol(cast(void**)&SDL_HapticSetAutocenter, "SDL_HapticSetAutocenter");
    lib.bindSymbol(cast(void**)&SDL_HapticPause, "SDL_HapticPause");
    lib.bindSymbol(cast(void**)&SDL_HapticUnpause, "SDL_HapticUnpause");
    lib.bindSymbol(cast(void**)&SDL_HapticStopAll, "SDL_HapticStopAll");
    lib.bindSymbol(cast(void**)&SDL_HapticRumbleSupported, "SDL_HapticRumbleSupported");
    lib.bindSymbol(cast(void**)&SDL_HapticRumbleInit, "SDL_HapticRumbleInit");
    lib.bindSymbol(cast(void**)&SDL_HapticRumblePlay, "SDL_HapticRumblePlay");
    lib.bindSymbol(cast(void**)&SDL_HapticRumbleStop, "SDL_HapticRumbleStop");
    lib.bindSymbol(cast(void**)&SDL_SetHintWithPriority, "SDL_SetHintWithPriority");
    lib.bindSymbol(cast(void**)&SDL_SetHint, "SDL_SetHint");
    lib.bindSymbol(cast(void**)&SDL_GetHint, "SDL_GetHint");
    lib.bindSymbol(cast(void**)&SDL_AddHintCallback, "SDL_AddHintCallback");
    lib.bindSymbol(cast(void**)&SDL_DelHintCallback, "SDL_DelHintCallback");
    lib.bindSymbol(cast(void**)&SDL_ClearHints, "SDL_ClearHints");
    lib.bindSymbol(cast(void**)&SDL_NumJoysticks, "SDL_NumJoysticks");
    lib.bindSymbol(cast(void**)&SDL_JoystickNameForIndex, "SDL_JoystickNameForIndex");
    lib.bindSymbol(cast(void**)&SDL_JoystickOpen, "SDL_JoystickOpen");
    lib.bindSymbol(cast(void**)&SDL_JoystickName, "SDL_JoystickName");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceGUID, "SDL_JoystickGetDeviceGUID");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetGUID, "SDL_JoystickGetGUID");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetGUIDString, "SDL_JoystickGetGUIDString");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetGUIDFromString, "SDL_JoystickGetGUIDFromString");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetAttached, "SDL_JoystickGetAttached");
    lib.bindSymbol(cast(void**)&SDL_JoystickInstanceID, "SDL_JoystickInstanceID");
    lib.bindSymbol(cast(void**)&SDL_JoystickNumAxes, "SDL_JoystickNumAxes");
    lib.bindSymbol(cast(void**)&SDL_JoystickNumBalls, "SDL_JoystickNumBalls");
    lib.bindSymbol(cast(void**)&SDL_JoystickNumHats, "SDL_JoystickNumHats");
    lib.bindSymbol(cast(void**)&SDL_JoystickNumButtons, "SDL_JoystickNumButtons");
    lib.bindSymbol(cast(void**)&SDL_JoystickUpdate, "SDL_JoystickUpdate");
    lib.bindSymbol(cast(void**)&SDL_JoystickEventState, "SDL_JoystickEventState");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetAxis, "SDL_JoystickGetAxis");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetHat, "SDL_JoystickGetHat");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetBall, "SDL_JoystickGetBall");
    lib.bindSymbol(cast(void**)&SDL_JoystickGetButton, "SDL_JoystickGetButton");
    lib.bindSymbol(cast(void**)&SDL_JoystickClose, "SDL_JoystickClose");
    lib.bindSymbol(cast(void**)&SDL_GetKeyboardFocus, "SDL_GetKeyboardFocus");
    lib.bindSymbol(cast(void**)&SDL_GetKeyboardState, "SDL_GetKeyboardState");
    lib.bindSymbol(cast(void**)&SDL_GetModState, "SDL_GetModState");
    lib.bindSymbol(cast(void**)&SDL_SetModState, "SDL_SetModState");
    lib.bindSymbol(cast(void**)&SDL_GetKeyFromScancode, "SDL_GetKeyFromScancode");
    lib.bindSymbol(cast(void**)&SDL_GetScancodeFromKey, "SDL_GetScancodeFromKey");
    lib.bindSymbol(cast(void**)&SDL_GetScancodeName, "SDL_GetScancodeName");
    lib.bindSymbol(cast(void**)&SDL_GetScancodeFromName, "SDL_GetScancodeFromName");
    lib.bindSymbol(cast(void**)&SDL_GetKeyName, "SDL_GetKeyName");
    lib.bindSymbol(cast(void**)&SDL_GetKeyFromName, "SDL_GetKeyFromName");
    lib.bindSymbol(cast(void**)&SDL_StartTextInput, "SDL_StartTextInput");
    lib.bindSymbol(cast(void**)&SDL_IsTextInputActive, "SDL_IsTextInputActive");
    lib.bindSymbol(cast(void**)&SDL_StopTextInput, "SDL_StopTextInput");
    lib.bindSymbol(cast(void**)&SDL_SetTextInputRect, "SDL_SetTextInputRect");
    lib.bindSymbol(cast(void**)&SDL_HasScreenKeyboardSupport, "SDL_HasScreenKeyboardSupport");
    lib.bindSymbol(cast(void**)&SDL_IsScreenKeyboardShown, "SDL_IsScreenKeyboardShown");
    lib.bindSymbol(cast(void**)&SDL_LoadObject, "SDL_LoadObject");
    lib.bindSymbol(cast(void**)&SDL_LoadFunction, "SDL_LoadFunction");
    lib.bindSymbol(cast(void**)&SDL_UnloadObject, "SDL_UnloadObject");
    lib.bindSymbol(cast(void**)&SDL_LogSetAllPriority, "SDL_LogSetAllPriority");
    lib.bindSymbol(cast(void**)&SDL_LogSetPriority, "SDL_LogSetPriority");
    lib.bindSymbol(cast(void**)&SDL_LogGetPriority, "SDL_LogGetPriority");
    lib.bindSymbol(cast(void**)&SDL_LogResetPriorities, "SDL_LogResetPriorities");
    lib.bindSymbol(cast(void**)&SDL_Log, "SDL_Log");
    lib.bindSymbol(cast(void**)&SDL_LogVerbose, "SDL_LogVerbose");
    lib.bindSymbol(cast(void**)&SDL_LogDebug, "SDL_LogDebug");
    lib.bindSymbol(cast(void**)&SDL_LogInfo, "SDL_LogInfo");
    lib.bindSymbol(cast(void**)&SDL_LogWarn, "SDL_LogWarn");
    lib.bindSymbol(cast(void**)&SDL_LogError, "SDL_LogError");
    lib.bindSymbol(cast(void**)&SDL_LogCritical, "SDL_LogCritical");
    lib.bindSymbol(cast(void**)&SDL_LogMessage, "SDL_LogMessage");
    lib.bindSymbol(cast(void**)&SDL_LogMessageV, "SDL_LogMessageV");
    lib.bindSymbol(cast(void**)&SDL_LogGetOutputFunction, "SDL_LogGetOutputFunction");
    lib.bindSymbol(cast(void**)&SDL_LogSetOutputFunction, "SDL_LogSetOutputFunction");
    lib.bindSymbol(cast(void**)&SDL_ShowMessageBox, "SDL_ShowMessageBox");
    lib.bindSymbol(cast(void**)&SDL_ShowSimpleMessageBox, "SDL_ShowSimpleMessageBox");
    lib.bindSymbol(cast(void**)&SDL_GetMouseFocus, "SDL_GetMouseFocus");
    lib.bindSymbol(cast(void**)&SDL_GetMouseState, "SDL_GetMouseState");
    lib.bindSymbol(cast(void**)&SDL_GetRelativeMouseState, "SDL_GetRelativeMouseState");
    lib.bindSymbol(cast(void**)&SDL_WarpMouseInWindow, "SDL_WarpMouseInWindow");
    lib.bindSymbol(cast(void**)&SDL_SetRelativeMouseMode, "SDL_SetRelativeMouseMode");
    lib.bindSymbol(cast(void**)&SDL_GetRelativeMouseMode, "SDL_GetRelativeMouseMode");
    lib.bindSymbol(cast(void**)&SDL_CreateCursor, "SDL_CreateCursor");
    lib.bindSymbol(cast(void**)&SDL_CreateColorCursor, "SDL_CreateColorCursor");
    lib.bindSymbol(cast(void**)&SDL_CreateSystemCursor, "SDL_CreateSystemCursor");
    lib.bindSymbol(cast(void**)&SDL_SetCursor, "SDL_SetCursor");
    lib.bindSymbol(cast(void**)&SDL_GetCursor, "SDL_GetCursor");
    lib.bindSymbol(cast(void**)&SDL_GetDefaultCursor, "SDL_GetDefaultCursor");
    lib.bindSymbol(cast(void**)&SDL_FreeCursor, "SDL_FreeCursor");
    lib.bindSymbol(cast(void**)&SDL_ShowCursor, "SDL_ShowCursor");
    lib.bindSymbol(cast(void**)&SDL_CreateMutex, "SDL_CreateMutex");
    lib.bindSymbol(cast(void**)&SDL_LockMutex, "SDL_LockMutex");
    lib.bindSymbol(cast(void**)&SDL_TryLockMutex, "SDL_TryLockMutex");
    lib.bindSymbol(cast(void**)&SDL_UnlockMutex, "SDL_UnlockMutex");
    lib.bindSymbol(cast(void**)&SDL_DestroyMutex, "SDL_DestroyMutex");
    lib.bindSymbol(cast(void**)&SDL_CreateSemaphore, "SDL_CreateSemaphore");
    lib.bindSymbol(cast(void**)&SDL_DestroySemaphore, "SDL_DestroySemaphore");
    lib.bindSymbol(cast(void**)&SDL_SemWait, "SDL_SemWait");
    lib.bindSymbol(cast(void**)&SDL_SemWaitTimeout, "SDL_SemWaitTimeout");
    lib.bindSymbol(cast(void**)&SDL_SemPost, "SDL_SemPost");
    lib.bindSymbol(cast(void**)&SDL_SemValue, "SDL_SemValue");
    lib.bindSymbol(cast(void**)&SDL_CreateCond, "SDL_CreateCond");
    lib.bindSymbol(cast(void**)&SDL_DestroyCond, "SDL_DestroyCond");
    lib.bindSymbol(cast(void**)&SDL_CondSignal, "SDL_CondSignal");
    lib.bindSymbol(cast(void**)&SDL_CondBroadcast, "SDL_CondBroadcast");
    lib.bindSymbol(cast(void**)&SDL_CondWait, "SDL_CondWait");
    lib.bindSymbol(cast(void**)&SDL_CondWaitTimeout, "SDL_CondWaitTimeout");
    lib.bindSymbol(cast(void**)&SDL_GetPixelFormatName, "SDL_GetPixelFormatName");
    lib.bindSymbol(cast(void**)&SDL_PixelFormatEnumToMasks, "SDL_PixelFormatEnumToMasks");
    lib.bindSymbol(cast(void**)&SDL_MasksToPixelFormatEnum, "SDL_MasksToPixelFormatEnum");
    lib.bindSymbol(cast(void**)&SDL_AllocFormat, "SDL_AllocFormat");
    lib.bindSymbol(cast(void**)&SDL_FreeFormat, "SDL_FreeFormat");
    lib.bindSymbol(cast(void**)&SDL_AllocPalette, "SDL_AllocPalette");
    lib.bindSymbol(cast(void**)&SDL_SetPixelFormatPalette, "SDL_SetPixelFormatPalette");
    lib.bindSymbol(cast(void**)&SDL_SetPaletteColors, "SDL_SetPaletteColors");
    lib.bindSymbol(cast(void**)&SDL_FreePalette, "SDL_FreePalette");
    lib.bindSymbol(cast(void**)&SDL_MapRGB, "SDL_MapRGB");
    lib.bindSymbol(cast(void**)&SDL_MapRGBA, "SDL_MapRGBA");
    lib.bindSymbol(cast(void**)&SDL_GetRGB, "SDL_GetRGB");
    lib.bindSymbol(cast(void**)&SDL_GetRGBA, "SDL_GetRGBA");
    lib.bindSymbol(cast(void**)&SDL_CalculateGammaRamp, "SDL_CalculateGammaRamp");
    lib.bindSymbol(cast(void**)&SDL_GetPlatform, "SDL_GetPlatform");
    lib.bindSymbol(cast(void**)&SDL_GetPowerInfo, "SDL_GetPowerInfo");
    lib.bindSymbol(cast(void**)&SDL_HasIntersection, "SDL_HasIntersection");
    lib.bindSymbol(cast(void**)&SDL_IntersectRect, "SDL_IntersectRect");
    lib.bindSymbol(cast(void**)&SDL_UnionRect, "SDL_UnionRect");
    lib.bindSymbol(cast(void**)&SDL_EnclosePoints, "SDL_EnclosePoints");
    lib.bindSymbol(cast(void**)&SDL_IntersectRectAndLine, "SDL_IntersectRectAndLine");
    lib.bindSymbol(cast(void**)&SDL_GetNumRenderDrivers, "SDL_GetNumRenderDrivers");
    lib.bindSymbol(cast(void**)&SDL_GetRenderDriverInfo, "SDL_GetRenderDriverInfo");
    lib.bindSymbol(cast(void**)&SDL_CreateWindowAndRenderer, "SDL_CreateWindowAndRenderer");
    lib.bindSymbol(cast(void**)&SDL_CreateRenderer, "SDL_CreateRenderer");
    lib.bindSymbol(cast(void**)&SDL_CreateSoftwareRenderer, "SDL_CreateSoftwareRenderer");
    lib.bindSymbol(cast(void**)&SDL_GetRenderer, "SDL_GetRenderer");
    lib.bindSymbol(cast(void**)&SDL_GetRendererInfo, "SDL_GetRendererInfo");
    lib.bindSymbol(cast(void**)&SDL_GetRendererOutputSize, "SDL_GetRendererOutputSize");
    lib.bindSymbol(cast(void**)&SDL_CreateTexture, "SDL_CreateTexture");
    lib.bindSymbol(cast(void**)&SDL_CreateTextureFromSurface, "SDL_CreateTextureFromSurface");
    lib.bindSymbol(cast(void**)&SDL_QueryTexture, "SDL_QueryTexture");
    lib.bindSymbol(cast(void**)&SDL_SetTextureColorMod, "SDL_SetTextureColorMod");
    lib.bindSymbol(cast(void**)&SDL_GetTextureColorMod, "SDL_GetTextureColorMod");
    lib.bindSymbol(cast(void**)&SDL_SetTextureAlphaMod, "SDL_SetTextureAlphaMod");
    lib.bindSymbol(cast(void**)&SDL_GetTextureAlphaMod, "SDL_GetTextureAlphaMod");
    lib.bindSymbol(cast(void**)&SDL_SetTextureBlendMode, "SDL_SetTextureBlendMode");
    lib.bindSymbol(cast(void**)&SDL_GetTextureBlendMode, "SDL_GetTextureBlendMode");
    lib.bindSymbol(cast(void**)&SDL_UpdateTexture, "SDL_UpdateTexture");
    lib.bindSymbol(cast(void**)&SDL_LockTexture, "SDL_LockTexture");
    lib.bindSymbol(cast(void**)&SDL_UnlockTexture, "SDL_UnlockTexture");
    lib.bindSymbol(cast(void**)&SDL_RenderTargetSupported, "SDL_RenderTargetSupported");
    lib.bindSymbol(cast(void**)&SDL_SetRenderTarget, "SDL_SetRenderTarget");
    lib.bindSymbol(cast(void**)&SDL_GetRenderTarget, "SDL_GetRenderTarget");
    lib.bindSymbol(cast(void**)&SDL_RenderSetClipRect, "SDL_RenderSetClipRect");
    lib.bindSymbol(cast(void**)&SDL_RenderGetClipRect, "SDL_RenderGetClipRect");
    lib.bindSymbol(cast(void**)&SDL_RenderSetLogicalSize, "SDL_RenderSetLogicalSize");
    lib.bindSymbol(cast(void**)&SDL_RenderGetLogicalSize, "SDL_RenderGetLogicalSize");
    lib.bindSymbol(cast(void**)&SDL_RenderSetViewport, "SDL_RenderSetViewport");
    lib.bindSymbol(cast(void**)&SDL_RenderGetViewport, "SDL_RenderGetViewport");
    lib.bindSymbol(cast(void**)&SDL_RenderSetScale, "SDL_RenderSetScale");
    lib.bindSymbol(cast(void**)&SDL_RenderGetScale, "SDL_RenderGetScale");
    lib.bindSymbol(cast(void**)&SDL_SetRenderDrawColor, "SDL_SetRenderDrawColor");
    lib.bindSymbol(cast(void**)&SDL_GetRenderDrawColor, "SDL_GetRenderDrawColor");
    lib.bindSymbol(cast(void**)&SDL_SetRenderDrawBlendMode, "SDL_SetRenderDrawBlendMode");
    lib.bindSymbol(cast(void**)&SDL_GetRenderDrawBlendMode, "SDL_GetRenderDrawBlendMode");
    lib.bindSymbol(cast(void**)&SDL_RenderClear, "SDL_RenderClear");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawPoint, "SDL_RenderDrawPoint");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawPoints, "SDL_RenderDrawPoints");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawLine, "SDL_RenderDrawLine");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawLines, "SDL_RenderDrawLines");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawRect, "SDL_RenderDrawRect");
    lib.bindSymbol(cast(void**)&SDL_RenderDrawRects, "SDL_RenderDrawRects");
    lib.bindSymbol(cast(void**)&SDL_RenderFillRect, "SDL_RenderFillRect");
    lib.bindSymbol(cast(void**)&SDL_RenderFillRects, "SDL_RenderFillRects");
    lib.bindSymbol(cast(void**)&SDL_RenderCopy, "SDL_RenderCopy");
    lib.bindSymbol(cast(void**)&SDL_RenderCopyEx, "SDL_RenderCopyEx");
    lib.bindSymbol(cast(void**)&SDL_RenderReadPixels, "SDL_RenderReadPixels");
    lib.bindSymbol(cast(void**)&SDL_RenderPresent, "SDL_RenderPresent");
    lib.bindSymbol(cast(void**)&SDL_DestroyTexture, "SDL_DestroyTexture");
    lib.bindSymbol(cast(void**)&SDL_DestroyRenderer, "SDL_DestroyRenderer");
    lib.bindSymbol(cast(void**)&SDL_GL_BindTexture, "SDL_GL_BindTexture");
    lib.bindSymbol(cast(void**)&SDL_GL_UnbindTexture, "SDL_GL_UnbindTexture");
    lib.bindSymbol(cast(void**)&SDL_RWFromFile, "SDL_RWFromFile");
    lib.bindSymbol(cast(void**)&SDL_RWFromFP, "SDL_RWFromFP");
    lib.bindSymbol(cast(void**)&SDL_RWFromMem, "SDL_RWFromMem");
    lib.bindSymbol(cast(void**)&SDL_RWFromConstMem, "SDL_RWFromConstMem");
    lib.bindSymbol(cast(void**)&SDL_AllocRW, "SDL_AllocRW");
    lib.bindSymbol(cast(void**)&SDL_FreeRW, "SDL_FreeRW");
    lib.bindSymbol(cast(void**)&SDL_ReadU8, "SDL_ReadU8");
    lib.bindSymbol(cast(void**)&SDL_ReadLE16, "SDL_ReadLE16");
    lib.bindSymbol(cast(void**)&SDL_ReadBE16, "SDL_ReadBE16");
    lib.bindSymbol(cast(void**)&SDL_ReadLE32, "SDL_ReadLE32");
    lib.bindSymbol(cast(void**)&SDL_ReadBE32, "SDL_ReadBE32");
    lib.bindSymbol(cast(void**)&SDL_ReadLE64, "SDL_ReadLE64");
    lib.bindSymbol(cast(void**)&SDL_ReadBE64, "SDL_ReadBE64");
    lib.bindSymbol(cast(void**)&SDL_WriteU8, "SDL_WriteU8");
    lib.bindSymbol(cast(void**)&SDL_WriteLE16, "SDL_WriteLE16");
    lib.bindSymbol(cast(void**)&SDL_WriteBE16, "SDL_WriteBE16");
    lib.bindSymbol(cast(void**)&SDL_WriteLE32, "SDL_WriteLE32");
    lib.bindSymbol(cast(void**)&SDL_WriteBE32, "SDL_WriteBE32");
    lib.bindSymbol(cast(void**)&SDL_WriteLE64, "SDL_WriteLE64");
    lib.bindSymbol(cast(void**)&SDL_WriteBE64, "SDL_WriteBE64");
    lib.bindSymbol(cast(void**)&SDL_CreateShapedWindow, "SDL_CreateShapedWindow");
    lib.bindSymbol(cast(void**)&SDL_IsShapedWindow, "SDL_IsShapedWindow");
    lib.bindSymbol(cast(void**)&SDL_SetWindowShape, "SDL_SetWindowShape");
    lib.bindSymbol(cast(void**)&SDL_GetShapedWindowMode, "SDL_GetShapedWindowMode");
    lib.bindSymbol(cast(void**)&SDL_free, "SDL_free");
    lib.bindSymbol(cast(void**)&SDL_CreateRGBSurface, "SDL_CreateRGBSurface");
    lib.bindSymbol(cast(void**)&SDL_CreateRGBSurfaceFrom, "SDL_CreateRGBSurfaceFrom");
    lib.bindSymbol(cast(void**)&SDL_FreeSurface, "SDL_FreeSurface");
    lib.bindSymbol(cast(void**)&SDL_SetSurfacePalette, "SDL_SetSurfacePalette");
    lib.bindSymbol(cast(void**)&SDL_LockSurface, "SDL_LockSurface");
    lib.bindSymbol(cast(void**)&SDL_UnlockSurface, "SDL_UnlockSurface");
    lib.bindSymbol(cast(void**)&SDL_LoadBMP_RW, "SDL_LoadBMP_RW");
    lib.bindSymbol(cast(void**)&SDL_SaveBMP_RW, "SDL_SaveBMP_RW");
    lib.bindSymbol(cast(void**)&SDL_SetSurfaceRLE, "SDL_SetSurfaceRLE");
    lib.bindSymbol(cast(void**)&SDL_SetColorKey, "SDL_SetColorKey");
    lib.bindSymbol(cast(void**)&SDL_GetColorKey, "SDL_GetColorKey");
    lib.bindSymbol(cast(void**)&SDL_SetSurfaceColorMod, "SDL_SetSurfaceColorMod");
    lib.bindSymbol(cast(void**)&SDL_GetSurfaceColorMod, "SDL_GetSurfaceColorMod");
    lib.bindSymbol(cast(void**)&SDL_SetSurfaceAlphaMod, "SDL_SetSurfaceAlphaMod");
    lib.bindSymbol(cast(void**)&SDL_GetSurfaceAlphaMod, "SDL_GetSurfaceAlphaMod");
    lib.bindSymbol(cast(void**)&SDL_SetSurfaceBlendMode, "SDL_SetSurfaceBlendMode");
    lib.bindSymbol(cast(void**)&SDL_GetSurfaceBlendMode, "SDL_GetSurfaceBlendMode");
    lib.bindSymbol(cast(void**)&SDL_SetClipRect, "SDL_SetClipRect");
    lib.bindSymbol(cast(void**)&SDL_GetClipRect, "SDL_GetClipRect");
    lib.bindSymbol(cast(void**)&SDL_ConvertSurface, "SDL_ConvertSurface");
    lib.bindSymbol(cast(void**)&SDL_ConvertSurfaceFormat, "SDL_ConvertSurfaceFormat");
    lib.bindSymbol(cast(void**)&SDL_ConvertPixels, "SDL_ConvertPixels");
    lib.bindSymbol(cast(void**)&SDL_FillRect, "SDL_FillRect");
    lib.bindSymbol(cast(void**)&SDL_FillRects, "SDL_FillRects");
    lib.bindSymbol(cast(void**)&SDL_UpperBlit, "SDL_UpperBlit");
    lib.bindSymbol(cast(void**)&SDL_LowerBlit, "SDL_LowerBlit");
    lib.bindSymbol(cast(void**)&SDL_SoftStretch, "SDL_SoftStretch");
    lib.bindSymbol(cast(void**)&SDL_UpperBlitScaled, "SDL_UpperBlitScaled");
    lib.bindSymbol(cast(void**)&SDL_LowerBlitScaled, "SDL_LowerBlitScaled");
    version(Android) {
        lib.bindSymbol(cast(void**)&SDL_AndroidGetJNIEnv, "SDL_AndroidGetJNIEnv");
        lib.bindSymbol(cast(void**)&SDL_AndroidGetActivity, "SDL_AndroidGetActivity");

        lib.bindSymbol(cast(void**)&SDL_AndroidGetInternalStoragePath, "SDL_AndroidGetInternalStoragePath");
        lib.bindSymbol(cast(void**)&SDL_AndroidGetInternalStorageState, "SDL_AndroidGetInternalStorageState");
        lib.bindSymbol(cast(void**)&SDL_AndroidGetExternalStoragePath, "SDL_AndroidGetExternalStoragePath");
    }

    lib.bindSymbol(cast(void**)&SDL_GetWindowWMInfo, "SDL_GetWindowWMInfo");
    lib.bindSymbol(cast(void**)&SDL_CreateThread, "SDL_CreateThread");
    lib.bindSymbol(cast(void**)&SDL_GetThreadName, "SDL_GetThreadName");
    lib.bindSymbol(cast(void**)&SDL_ThreadID, "SDL_ThreadID");
    lib.bindSymbol(cast(void**)&SDL_GetThreadID, "SDL_GetThreadID");
    lib.bindSymbol(cast(void**)&SDL_SetThreadPriority, "SDL_SetThreadPriority");
    lib.bindSymbol(cast(void**)&SDL_WaitThread, "SDL_WaitThread");
    lib.bindSymbol(cast(void**)&SDL_TLSCreate, "SDL_TLSCreate");
    lib.bindSymbol(cast(void**)&SDL_TLSGet, "SDL_TLSGet");
    lib.bindSymbol(cast(void**)&SDL_TLSSet, "SDL_TLSSet");
    lib.bindSymbol(cast(void**)&SDL_GetTicks, "SDL_GetTicks");
    lib.bindSymbol(cast(void**)&SDL_GetPerformanceCounter, "SDL_GetPerformanceCounter");
    lib.bindSymbol(cast(void**)&SDL_GetPerformanceFrequency, "SDL_GetPerformanceFrequency");
    lib.bindSymbol(cast(void**)&SDL_Delay, "SDL_Delay");
    lib.bindSymbol(cast(void**)&SDL_AddTimer, "SDL_AddTimer");
    lib.bindSymbol(cast(void**)&SDL_RemoveTimer, "SDL_RemoveTimer");
    lib.bindSymbol(cast(void**)&SDL_GetNumTouchDevices, "SDL_GetNumTouchDevices");
    lib.bindSymbol(cast(void**)&SDL_GetTouchDevice, "SDL_GetTouchDevice");
    lib.bindSymbol(cast(void**)&SDL_GetNumTouchFingers, "SDL_GetNumTouchFingers");
    lib.bindSymbol(cast(void**)&SDL_GetTouchFinger, "SDL_GetTouchFinger");
    lib.bindSymbol(cast(void**)&SDL_GetVersion, "SDL_GetVersion");
    lib.bindSymbol(cast(void**)&SDL_GetRevision, "SDL_GetRevision");
    lib.bindSymbol(cast(void**)&SDL_GetRevisionNumber, "SDL_GetRevisionNumber");
    lib.bindSymbol(cast(void**)&SDL_GetNumVideoDrivers, "SDL_GetNumVideoDrivers");
    lib.bindSymbol(cast(void**)&SDL_GetVideoDriver, "SDL_GetVideoDriver");
    lib.bindSymbol(cast(void**)&SDL_VideoInit, "SDL_VideoInit");
    lib.bindSymbol(cast(void**)&SDL_VideoQuit, "SDL_VideoQuit");
    lib.bindSymbol(cast(void**)&SDL_GetCurrentVideoDriver, "SDL_GetCurrentVideoDriver");
    lib.bindSymbol(cast(void**)&SDL_GetNumVideoDisplays, "SDL_GetNumVideoDisplays");
    lib.bindSymbol(cast(void**)&SDL_GetDisplayName, "SDL_GetDisplayName");
    lib.bindSymbol(cast(void**)&SDL_GetDisplayBounds, "SDL_GetDisplayBounds");
    lib.bindSymbol(cast(void**)&SDL_GetNumDisplayModes, "SDL_GetNumDisplayModes");
    lib.bindSymbol(cast(void**)&SDL_GetDisplayMode, "SDL_GetDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetDesktopDisplayMode, "SDL_GetDesktopDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetCurrentDisplayMode, "SDL_GetCurrentDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetClosestDisplayMode, "SDL_GetClosestDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetWindowDisplayIndex, "SDL_GetWindowDisplayIndex");
    lib.bindSymbol(cast(void**)&SDL_SetWindowDisplayMode, "SDL_SetWindowDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetWindowDisplayMode, "SDL_GetWindowDisplayMode");
    lib.bindSymbol(cast(void**)&SDL_GetWindowPixelFormat, "SDL_GetWindowPixelFormat");
    lib.bindSymbol(cast(void**)&SDL_CreateWindow, "SDL_CreateWindow");
    lib.bindSymbol(cast(void**)&SDL_CreateWindowFrom, "SDL_CreateWindowFrom");
    lib.bindSymbol(cast(void**)&SDL_GetWindowID, "SDL_GetWindowID");
    lib.bindSymbol(cast(void**)&SDL_GetWindowFromID, "SDL_GetWindowFromID");
    lib.bindSymbol(cast(void**)&SDL_GetWindowFlags, "SDL_GetWindowFlags");
    lib.bindSymbol(cast(void**)&SDL_SetWindowTitle, "SDL_SetWindowTitle");
    lib.bindSymbol(cast(void**)&SDL_GetWindowTitle, "SDL_GetWindowTitle");
    lib.bindSymbol(cast(void**)&SDL_SetWindowIcon, "SDL_SetWindowIcon");
    lib.bindSymbol(cast(void**)&SDL_SetWindowData, "SDL_SetWindowData");
    lib.bindSymbol(cast(void**)&SDL_GetWindowData, "SDL_GetWindowData");
    lib.bindSymbol(cast(void**)&SDL_SetWindowPosition, "SDL_SetWindowPosition");
    lib.bindSymbol(cast(void**)&SDL_GetWindowPosition, "SDL_GetWindowPosition");
    lib.bindSymbol(cast(void**)&SDL_SetWindowSize, "SDL_SetWindowSize");
    lib.bindSymbol(cast(void**)&SDL_GetWindowSize, "SDL_GetWindowSize");
    lib.bindSymbol(cast(void**)&SDL_SetWindowMinimumSize, "SDL_SetWindowMinimumSize");
    lib.bindSymbol(cast(void**)&SDL_GetWindowMinimumSize, "SDL_GetWindowMinimumSize");
    lib.bindSymbol(cast(void**)&SDL_SetWindowMaximumSize, "SDL_SetWindowMaximumSize");
    lib.bindSymbol(cast(void**)&SDL_GetWindowMaximumSize, "SDL_GetWindowMaximumSize");
    lib.bindSymbol(cast(void**)&SDL_SetWindowBordered, "SDL_SetWindowBordered");
    lib.bindSymbol(cast(void**)&SDL_ShowWindow, "SDL_ShowWindow");
    lib.bindSymbol(cast(void**)&SDL_HideWindow, "SDL_HideWindow");
    lib.bindSymbol(cast(void**)&SDL_RaiseWindow, "SDL_RaiseWindow");
    lib.bindSymbol(cast(void**)&SDL_MaximizeWindow, "SDL_MaximizeWindow");
    lib.bindSymbol(cast(void**)&SDL_MinimizeWindow, "SDL_MinimizeWindow");
    lib.bindSymbol(cast(void**)&SDL_RestoreWindow, "SDL_RestoreWindow");
    lib.bindSymbol(cast(void**)&SDL_SetWindowFullscreen, "SDL_SetWindowFullscreen");
    lib.bindSymbol(cast(void**)&SDL_GetWindowSurface, "SDL_GetWindowSurface");
    lib.bindSymbol(cast(void**)&SDL_UpdateWindowSurface, "SDL_UpdateWindowSurface");
    lib.bindSymbol(cast(void**)&SDL_UpdateWindowSurfaceRects, "SDL_UpdateWindowSurfaceRects");
    lib.bindSymbol(cast(void**)&SDL_SetWindowGrab, "SDL_SetWindowGrab");
    lib.bindSymbol(cast(void**)&SDL_GetWindowGrab, "SDL_GetWindowGrab");
    lib.bindSymbol(cast(void**)&SDL_SetWindowBrightness, "SDL_SetWindowBrightness");
    lib.bindSymbol(cast(void**)&SDL_GetWindowBrightness, "SDL_GetWindowBrightness");
    lib.bindSymbol(cast(void**)&SDL_SetWindowGammaRamp, "SDL_SetWindowGammaRamp");
    lib.bindSymbol(cast(void**)&SDL_GetWindowGammaRamp, "SDL_GetWindowGammaRamp");
    lib.bindSymbol(cast(void**)&SDL_DestroyWindow, "SDL_DestroyWindow");
    lib.bindSymbol(cast(void**)&SDL_IsScreenSaverEnabled, "SDL_IsScreenSaverEnabled");
    lib.bindSymbol(cast(void**)&SDL_EnableScreenSaver, "SDL_EnableScreenSaver");
    lib.bindSymbol(cast(void**)&SDL_DisableScreenSaver, "SDL_DisableScreenSaver");
    lib.bindSymbol(cast(void**)&SDL_GL_LoadLibrary, "SDL_GL_LoadLibrary");
    lib.bindSymbol(cast(void**)&SDL_GL_GetProcAddress, "SDL_GL_GetProcAddress");
    lib.bindSymbol(cast(void**)&SDL_GL_UnloadLibrary, "SDL_GL_UnloadLibrary");
    lib.bindSymbol(cast(void**)&SDL_GL_ExtensionSupported, "SDL_GL_ExtensionSupported");
    lib.bindSymbol(cast(void**)&SDL_GL_SetAttribute, "SDL_GL_SetAttribute");
    lib.bindSymbol(cast(void**)&SDL_GL_GetAttribute, "SDL_GL_GetAttribute");
    lib.bindSymbol(cast(void**)&SDL_GL_CreateContext, "SDL_GL_CreateContext");
    lib.bindSymbol(cast(void**)&SDL_GL_MakeCurrent, "SDL_GL_MakeCurrent");
    lib.bindSymbol(cast(void**)&SDL_GL_GetCurrentWindow, "SDL_GL_GetCurrentWindow");
    lib.bindSymbol(cast(void**)&SDL_GL_GetCurrentContext, "SDL_GL_GetCurrentContext");
    lib.bindSymbol(cast(void**)&SDL_GL_SetSwapInterval, "SDL_GL_SetSwapInterval");
    lib.bindSymbol(cast(void**)&SDL_GL_GetSwapInterval, "SDL_GL_GetSwapInterval");
    lib.bindSymbol(cast(void**)&SDL_GL_SwapWindow, "SDL_GL_SwapWindow");
    lib.bindSymbol(cast(void**)&SDL_GL_DeleteContext, "SDL_GL_DeleteContext");

    if(errorCount() != errCount) return SDLSupport.badLibrary;
    else loadedVersion = SDLSupport.sdl200;

    static if(sdlSupport >= SDLSupport.sdl201) {
        lib.bindSymbol(cast(void**)&SDL_GetSystemRAM, "SDL_GetSystemRAM");
        lib.bindSymbol(cast(void**)&SDL_GetBasePath, "SDL_GetBasePath");
        lib.bindSymbol(cast(void**)&SDL_GetPrefPath, "SDL_GetPrefPath");
        lib.bindSymbol(cast(void**)&SDL_UpdateYUVTexture, "SDL_UpdateYUVTexture");
        lib.bindSymbol(cast(void**)&SDL_GL_GetDrawableSize, "SDL_GL_GetDrawableSize");

        version(Windows) {
            lib.bindSymbol(cast(void**)&SDL_Direct3D9GetAdapterIndex, "SDL_Direct3D9GetAdapterIndex") ;
            lib.bindSymbol(cast(void**)&SDL_RenderGetD3D9Device, "SDL_RenderGetD3D9Device");
        }

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl201;
    }

    static if(sdlSupport >= SDLSupport.sdl202) {
        lib.bindSymbol(cast(void**)&SDL_GetDefaultAssertionHandler, "SDL_GetDefaultAssertionHandler");
        lib.bindSymbol(cast(void**)&SDL_GetAssertionHandler, "SDL_GetAssertionHandler");
        lib.bindSymbol(cast(void**)&SDL_HasAVX, "SDL_HasAVX");
        lib.bindSymbol(cast(void**)&SDL_GameControllerAddMappingsFromRW, "SDL_GameControllerAddMappingsFromRW");
        lib.bindSymbol(cast(void**)&SDL_GL_ResetAttributes, "SDL_GL_ResetAttributes");
        lib.bindSymbol(cast(void**)&SDL_DetachThread, "SDL_DetachThread");

        version(Windows) {
            lib.bindSymbol(cast(void**)&SDL_DXGIGetOutputInfo, "SDL_DXGIGetOutputInfo");
        }

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl202;
    }

    static if(sdlSupport >= SDLSupport.sdl203) {
        loadedVersion = SDLSupport.sdl203;
    }

    static if(sdlSupport >= SDLSupport.sdl204) {
        lib.bindSymbol(cast(void**)&SDL_ClearQueuedAudio, "SDL_ClearQueuedAudio");
        lib.bindSymbol(cast(void**)&SDL_GetQueuedAudioSize, "SDL_GetQueuedAudioSize");
        lib.bindSymbol(cast(void**)&SDL_QueueAudio, "SDL_QueueAudio");
        lib.bindSymbol(cast(void**)&SDL_HasAVX2, "SDL_HasAVX2");
        lib.bindSymbol(cast(void**)&SDL_GameControllerFromInstanceID, "SDL_GameControllerFromInstanceID");
        lib.bindSymbol(cast(void**)&SDL_JoystickCurrentPowerLevel, "SDL_JoystickCurrentPowerLevel");
        lib.bindSymbol(cast(void**)&SDL_JoystickFromInstanceID, "SDL_JoystickFromInstanceID");
        lib.bindSymbol(cast(void**)&SDL_CaptureMouse, "SDL_CaptureMouse");
        lib.bindSymbol(cast(void**)&SDL_GetGlobalMouseState, "SDL_GetGlobalMouseState");
        lib.bindSymbol(cast(void**)&SDL_WarpMouseGlobal, "SDL_WarpMouseGlobal");
        lib.bindSymbol(cast(void**)&SDL_RenderIsClipEnabled, "SDL_RenderIsClipEnabled");
        lib.bindSymbol(cast(void**)&SDL_GetDisplayDPI, "SDL_GetDisplayDPI");
        lib.bindSymbol(cast(void**)&SDL_GetGrabbedWindow, "SDL_GetGrabbedWindow");
        lib.bindSymbol(cast(void**)&SDL_SetWindowHitTest, "SDL_SetWindowHitTest");

        version(Windows) {
            lib.bindSymbol(cast(void**)&SDL_SetWindowsMessageHook, "SDL_SetWindowsMessageHook");
        }

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl204;
    }

    static if(sdlSupport >= SDLSupport.sdl205) {
        lib.bindSymbol(cast(void**)&SDL_DequeueAudio, "SDL_DequeueAudio");
        lib.bindSymbol(cast(void**)&SDL_GetHintBoolean, "SDL_GetHintBoolean");
        lib.bindSymbol(cast(void**)&SDL_RenderGetIntegerScale, "SDL_RenderGetIntegerScale");
        lib.bindSymbol(cast(void**)&SDL_RenderSetIntegerScale, "SDL_RenderSetIntegerScale");
        lib.bindSymbol(cast(void**)&SDL_CreateRGBSurfaceWithFormat, "SDL_CreateRGBSurfaceWithFormat");
        lib.bindSymbol(cast(void**)&SDL_CreateRGBSurfaceWithFormatFrom, "SDL_CreateRGBSurfaceWithFormatFrom");
        lib.bindSymbol(cast(void**)&SDL_GetDisplayUsableBounds, "SDL_GetDisplayUsableBounds");
        lib.bindSymbol(cast(void**)&SDL_GetWindowBordersSize, "SDL_GetWindowBordersSize");
        lib.bindSymbol(cast(void**)&SDL_GetWindowOpacity, "SDL_GetWindowOpacity");
        lib.bindSymbol(cast(void**)&SDL_SetWindowInputFocus, "SDL_SetWindowInputFocus");
        lib.bindSymbol(cast(void**)&SDL_SetWindowModalFor, "SDL_SetWindowModalFor");
        lib.bindSymbol(cast(void**)&SDL_SetWindowOpacity, "SDL_SetWindowOpacity");
        lib.bindSymbol(cast(void**)&SDL_SetWindowResizable, "SDL_SetWindowResizable");

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl205;
    }

    static if(sdlSupport >= SDLSupport.sdl206) {
        lib.bindSymbol(cast(void**)&SDL_ComposeCustomBlendMode, "SDL_ComposeCustomBlendMode");
        lib.bindSymbol(cast(void**)&SDL_HasNEON, "SDL_HasNEON");
        lib.bindSymbol(cast(void**)&SDL_GameControllerGetVendor, "SDL_GameControllerGetVendor");
        lib.bindSymbol(cast(void**)&SDL_GameControllerGetProduct, "SDL_GameControllerGetProduct");
        lib.bindSymbol(cast(void**)&SDL_GameControllerGetProductVersion, "SDL_GameControllerGetProductVersion");
        lib.bindSymbol(cast(void**)&SDL_GameControllerMappingForIndex, "SDL_GameControllerMappingForIndex");
        lib.bindSymbol(cast(void**)&SDL_GameControllerNumMappings, "SDL_GameControllerNumMappings");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetAxisInitialState, "SDL_JoystickGetAxisInitialState");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceVendor, "SDL_JoystickGetDeviceVendor");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceProduct, "SDL_JoystickGetDeviceProduct");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceProductVersion, "SDL_JoystickGetDeviceProductVersion");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceInstanceID, "SDL_JoystickGetDeviceInstanceID");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceType, "SDL_JoystickGetDeviceType");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetProduct, "SDL_JoystickGetProduct");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetProductVersion, "SDL_JoystickGetProductVersion");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetType, "SDL_JoystickGetType");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetVendor, "SDL_JoystickGetVendor");
        lib.bindSymbol(cast(void**)&SDL_LoadFile_RW, "SDL_LoadFile_RW");
        lib.bindSymbol(cast(void**)&SDL_DuplicateSurface, "SDL_DuplicateSurface");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_CreateSurface, "SDL_Vulkan_CreateSurface");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetDrawableSize, "SDL_Vulkan_GetDrawableSize");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetInstanceExtensions, "SDL_Vulkan_GetInstanceExtensions");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetVkGetInstanceProcAddr, "SDL_Vulkan_GetVkGetInstanceProcAddr");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_LoadLibrary, "SDL_Vulkan_LoadLibrary");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_UnloadLibrary, "SDL_Vulkan_UnloadLibrary");

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl206;
    }

    static if(sdlSupport >= SDLSupport.sdl207) {
        lib.bindSymbol(cast(void**)&SDL_NewAudioStream, "SDL_NewAudioStream");
        lib.bindSymbol(cast(void**)&SDL_AudioStreamPut, "SDL_AudioStreamPut");
        lib.bindSymbol(cast(void**)&SDL_AudioStreamGet, "SDL_AudioStreamGet");
        lib.bindSymbol(cast(void**)&SDL_AudioStreamAvailable, "SDL_AudioStreamAvailable");
        lib.bindSymbol(cast(void**)&SDL_AudioStreamFlush, "SDL_AudioStreamFlush");
        lib.bindSymbol(cast(void**)&SDL_AudioStreamClear, "SDL_AudioStreamClear");
        lib.bindSymbol(cast(void**)&SDL_FreeAudioStream, "SDL_FreeAudioStream");
        lib.bindSymbol(cast(void**)&SDL_LockJoysticks, "SDL_LockJoysticks");
        lib.bindSymbol(cast(void**)&SDL_UnlockJoysticks, "SDL_UnlockJoysticks");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceProduct, "SDL_JoystickGetDeviceProduct");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceProductVersion, "SDL_JoystickGetDeviceProductVersion");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceInstanceID, "SDL_JoystickGetDeviceInstanceID");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDeviceType, "SDL_JoystickGetDeviceType");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetProduct, "SDL_JoystickGetProduct");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetProductVersion, "SDL_JoystickGetProductVersion");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetType, "SDL_JoystickGetType");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetVendor, "SDL_JoystickGetVendor");
        lib.bindSymbol(cast(void**)&SDL_LoadFile_RW, "SDL_LoadFile_RW");
        lib.bindSymbol(cast(void**)&SDL_DuplicateSurface, "SDL_DuplicateSurface");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_CreateSurface, "SDL_Vulkan_CreateSurface");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetDrawableSize, "SDL_Vulkan_GetDrawableSize");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetInstanceExtensions, "SDL_Vulkan_GetInstanceExtensions");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_GetVkGetInstanceProcAddr, "SDL_Vulkan_GetVkGetInstanceProcAddr");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_LoadLibrary, "SDL_Vulkan_LoadLibrary");
        lib.bindSymbol(cast(void**)&SDL_Vulkan_UnloadLibrary, "SDL_Vulkan_UnloadLibrary");

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl207;
    }

    static if(sdlSupport >= SDLSupport.sdl208) {
        lib.bindSymbol(cast(void**)&SDL_RenderGetMetalLayer, "SDL_RenderGetMetalLayer");
        lib.bindSymbol(cast(void**)&SDL_RenderGetMetalCommandEncoder, "SDL_RenderGetMetalCommandEncoder");
        lib.bindSymbol(cast(void**)&SDL_SetYUVConversionMode, "SDL_SetYUVConversionMode");
        lib.bindSymbol(cast(void**)&SDL_GetYUVConversionMode, "SDL_GetYUVConversionMode");
        lib.bindSymbol(cast(void**)&SDL_GetYUVConversionModeForResolution, "SDL_GetYUVConversionModeForResolution");

        version(Android) {
            lib.bindSymbol(cast(void**)&SDL_IsAndroidTV, "SDL_IsAndroidTV");
        }

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl208;
    }

    static if(sdlSupport >= SDLSupport.sdl209) {
        lib.bindSymbol(cast(void**)&SDL_HasAVX512F, "SDL_HasAVX512F");
        lib.bindSymbol(cast(void**)&SDL_GameControllerMappingForDeviceIndex, "SDL_GameControllerMappingForDeviceIndex");
        lib.bindSymbol(cast(void**)&SDL_GameControllerRumble, "SDL_GameControllerRumble");
        lib.bindSymbol(cast(void**)&SDL_JoystickRumble, "SDL_JoystickRumble");
        lib.bindSymbol(cast(void**)&SDL_HasColorKey, "SDL_HasColorKey");
        lib.bindSymbol(cast(void**)&SDL_GetDisplayOrientation, "SDL_GetDisplayOrientation");
        lib.bindSymbol(cast(void**)&SDL_CreateThreadWithStackSize, "SDL_CreateThreadWithStackSize");

        version(linux) {
            lib.bindSymbol(cast(void**)&SDL_LinuxSetThreadPriority, "SDL_LinuxSetThreadPriority");
        }
        else version(Android) {
            lib.bindSymbol(cast(void**)&SDL_IsChromebook, "SDL_IsChromebook");
            lib.bindSymbol(cast(void**)&SDL_IsDeXMode, "SDL_IsDeXMode");
            lib.bindSymbol(cast(void**)&SDL_AndroidBackButton, "SDL_AndroidBackButton");
        }

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl209;
    }

    static if(sdlSupport >= SDLSupport.sdl2010) {
        lib.bindSymbol(cast(void**)&SDL_SIMDGetAlignment, "SDL_SIMDGetAlignment");
        lib.bindSymbol(cast(void**)&SDL_SIMDAlloc, "SDL_SIMDAlloc");
        lib.bindSymbol(cast(void**)&SDL_SIMDFree, "SDL_SIMDFree");
        lib.bindSymbol(cast(void**)&SDL_GameControllerGetPlayerIndex, "SDL_GameControllerGetPlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetDevicePlayerIndex, "SDL_JoystickGetDevicePlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetPlayerIndex, "SDL_JoystickGetPlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawPointF, "SDL_RenderDrawPointF");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawPointsF, "SDL_RenderDrawPointsF");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawLineF, "SDL_RenderDrawLineF");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawLinesF, "SDL_RenderDrawLinesF");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawRectF, "SDL_RenderDrawRectF");
        lib.bindSymbol(cast(void**)&SDL_RenderDrawRectsF, "SDL_RenderDrawRectsF");
        lib.bindSymbol(cast(void**)&SDL_RenderFillRectF, "SDL_RenderFillRectF");
        lib.bindSymbol(cast(void**)&SDL_RenderFillRectsF, "SDL_RenderFillRectsF");
        lib.bindSymbol(cast(void**)&SDL_RenderCopyF, "SDL_RenderCopyF");
        lib.bindSymbol(cast(void**)&SDL_RenderCopyExF, "SDL_RenderCopyExF");
        lib.bindSymbol(cast(void**)&SDL_RenderFlush, "SDL_RenderFlush");lib.bindSymbol(cast(void**)&SDL_Vulkan_CreateSurface, "SDL_Vulkan_CreateSurface");
        lib.bindSymbol(cast(void**)&SDL_RWsize, "SDL_RWsize");
        lib.bindSymbol(cast(void**)&SDL_RWseek, "SDL_RWseek");
        lib.bindSymbol(cast(void**)&SDL_RWtell, "SDL_RWtell");
        lib.bindSymbol(cast(void**)&SDL_RWread, "SDL_RWread");
        lib.bindSymbol(cast(void**)&SDL_RWwrite, "SDL_RWwrite");
        lib.bindSymbol(cast(void**)&SDL_RWclose, "SDL_RWclose");
        lib.bindSymbol(cast(void**)&SDL_GetTouchDeviceType, "SDL_GetTouchDeviceType");

        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl2010;
    }

    static if(sdlSupport >= SDLSupport.sdl2012) {
        lib.bindSymbol(cast(void**)&SDL_HasARMSIMD, "SDL_HasARMSIMD");
        lib.bindSymbol(cast(void**)&SDL_GameControllerTypeForIndex, "SDL_GameControllerTypeForIndex");
        lib.bindSymbol(cast(void**)&SDL_GameControllerFromPlayerIndex, "SDL_GameControllerFromPlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_GameControllerGetType, "SDL_GameControllerGetType");
        lib.bindSymbol(cast(void**)&SDL_GameControllerSetPlayerIndex, "SDL_GameControllerSetPlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_JoystickFromPlayerIndex, "SDL_JoystickFromPlayerIndex");
        lib.bindSymbol(cast(void**)&SDL_JoystickGetGUID, "SDL_JoystickGetGUID");
        lib.bindSymbol(cast(void**)&SDL_SetTextureScaleMode, "SDL_SetTextureScaleMode");
        lib.bindSymbol(cast(void**)&SDL_GetTextureScaleMode, "SDL_GetTextureScaleMode");
        lib.bindSymbol(cast(void**)&SDL_LockTextureToSurface, "SDL_LockTextureToSurface");
        version(Android) {
            lib.bindSymbol(cast(void**)&SDL_GetAndroidSDKVersion, "SDL_GetAndroidSDKVersion");
        }


        if(errorCount() != errCount) return SDLSupport.badLibrary;
        else loadedVersion = SDLSupport.sdl2012;
    }

    return loadedVersion;
}