
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlhaptic;

import bindbc.sdl.config;
import bindbc.sdl.bind.sdljoystick : SDL_Joystick;

struct SDL_Haptic;

enum : ushort {
    SDL_HAPTIC_CONSTANT = 1u<<0,
    SDL_HAPTIC_SINE = 1u<<1,
    SDL_HAPTIC_LEFTRIGHT = 1u<<2,
    SDL_HAPTIC_TRIANGLE = 1u<<3,
    SDL_HAPTIC_SAWTOOTHUP = 1u<<4,
    SDL_HAPTIC_SAWTOOTHDOWN = 1u<<5,
    SDL_HAPTIC_RAMP = 1u<<6,
    SDL_HAPTIC_SPRING = 1u<<7,
    SDL_HAPTIC_DAMPER = 1u<<8,
    SDL_HAPTIC_INERTIA = 1u<<9,
    SDL_HAPTIC_FRICTION = 1u<<10,
    SDL_HAPTIC_CUSTOM = 1u<<11,
    SDL_HAPTIC_GAIN = 1u<<12,
    SDL_HAPTIC_AUTOCENTER = 1u<<13,
    SDL_HAPTIC_STATUS = 1u<<14,
    SDL_HAPTIC_PAUSE = 1u<<15,
}

enum {
    SDL_HAPTIC_POLAR = 0,
    SDL_HAPTIC_CARTESIAN = 1,
    SDL_HAPTIC_SPHERICAL = 2,
}

enum SDL_HAPTIC_INFINITY = 4294967295U;

struct SDL_HapticDirection {
    ubyte type;
    int[3] dir;
}

struct SDL_HapticConstant {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short level;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticPeriodic {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    uint delay;
    ushort button;
    ushort interval;
    ushort period;
    short magnitude;
    short offset;
    ushort phase;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticCondition {
    ushort type;
    SDL_HapticDirection direciton;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ushort[3] right_sat;
    ushort[3] left_sat;
    short[3] right_coeff;
    short[3] left_coeff;
    ushort[3] deadband;
    ushort[3] center;
}

struct SDL_HapticRamp {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short start;
    short end;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

struct SDL_HapticLeftRight {
    ushort type;
    uint length;
    ushort large_magnitude;
    ushort small_magnitude;
}

struct SDL_HapticCustom {
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ubyte channels;
    ushort period;
    ushort samples;
    ushort* data;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}

union SDL_HapticEffect {
    ushort type;
    SDL_HapticConstant constant;
    SDL_HapticPeriodic periodic;
    SDL_HapticCondition condition;
    SDL_HapticRamp ramp;
    SDL_HapticLeftRight leftright;
    SDL_HapticCustom custom;
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        int SDL_NumHaptics();
        const(char)* SDL_HapticName(int);
        SDL_Haptic* SDL_HapticOpen(int);
        int SDL_HapticOpened(int);
        int SDL_HapticIndex(SDL_Haptic*);
        int SDL_MouseIsHaptic();
        SDL_Haptic* SDL_HapticOpenFromMouse();
        int SDL_JoystickIsHaptic(SDL_Joystick*);
        SDL_Haptic* SDL_HapticOpenFromJoystick(SDL_Joystick*);
        int SDL_HapticClose(SDL_Haptic*);
        int SDL_HapticNumEffects(SDL_Haptic*);
        int SDL_HapticNumEffectsPlaying(SDL_Haptic*);
        uint SDL_HapticQuery(SDL_Haptic*);
        int SDL_HapticNumAxes(SDL_Haptic*);
        int SDL_HapticEffectSupported(SDL_Haptic*,SDL_HapticEffect*);
        int SDL_HapticNewEffect(SDL_Haptic*,SDL_HapticEffect*);
        int SDL_HapticUpdateEffect(SDL_Haptic*,int,SDL_HapticEffect*);
        int SDL_HapticRunEffect(SDL_Haptic*,int,uint);
        int SDL_HapticStopEffect(SDL_Haptic*,int);
        int SDL_HapticDestroyEffect(SDL_Haptic*,int);
        int SDL_HapticGetEffectStatus(SDL_Haptic*,int);
        int SDL_HapticSetGain(SDL_Haptic*,int);
        int SDL_HapticSetAutocenter(SDL_Haptic*,int);
        int SDL_HapticPause(SDL_Haptic*);
        int SDL_HapticUnpause(SDL_Haptic*);
        int SDL_HapticStopAll(SDL_Haptic*);
        int SDL_HapticRumbleSupported(SDL_Haptic*);
        int SDL_HapticRumbleInit(SDL_Haptic*);
        int SDL_HapticRumblePlay(SDL_Haptic*,float,uint);
        int SDL_HapticRumbleStop(SDL_Haptic*);
    }
}
else {
    extern(C) @nogc nothrow {
        alias pSDL_NumHaptics = int function();
        alias pSDL_HapticName = const(char)* function(int);
        alias pSDL_HapticOpen = SDL_Haptic* function(int);
        alias pSDL_HapticOpened = int function(int);
        alias pSDL_HapticIndex = int function(SDL_Haptic*);
        alias pSDL_MouseIsHaptic = int function();
        alias pSDL_HapticOpenFromMouse = SDL_Haptic* function();
        alias pSDL_JoystickIsHaptic = int function(SDL_Joystick*);
        alias pSDL_HapticOpenFromJoystick = SDL_Haptic* function(SDL_Joystick*);
        alias pSDL_HapticClose = int function(SDL_Haptic*);
        alias pSDL_HapticNumEffects = int function(SDL_Haptic*);
        alias pSDL_HapticNumEffectsPlaying = int function(SDL_Haptic*);
        alias pSDL_HapticQuery = uint function(SDL_Haptic*);
        alias pSDL_HapticNumAxes = int function(SDL_Haptic*);
        alias pSDL_HapticEffectSupported = int function(SDL_Haptic*,SDL_HapticEffect*);
        alias pSDL_HapticNewEffect = int function(SDL_Haptic*,SDL_HapticEffect*);
        alias pSDL_HapticUpdateEffect = int function(SDL_Haptic*,int,SDL_HapticEffect*);
        alias pSDL_HapticRunEffect = int function(SDL_Haptic*,int,uint);
        alias pSDL_HapticStopEffect = int function(SDL_Haptic*,int);
        alias pSDL_HapticDestroyEffect = int function(SDL_Haptic*,int);
        alias pSDL_HapticGetEffectStatus = int function(SDL_Haptic*,int);
        alias pSDL_HapticSetGain = int function(SDL_Haptic*,int);
        alias pSDL_HapticSetAutocenter = int function(SDL_Haptic*,int);
        alias pSDL_HapticPause = int function(SDL_Haptic*);
        alias pSDL_HapticUnpause = int function(SDL_Haptic*);
        alias pSDL_HapticStopAll = int function(SDL_Haptic*);
        alias pSDL_HapticRumbleSupported = int function(SDL_Haptic*);
        alias pSDL_HapticRumbleInit = int function(SDL_Haptic*);
        alias pSDL_HapticRumblePlay = int function(SDL_Haptic*,float,uint);
        alias pSDL_HapticRumbleStop = int function(SDL_Haptic*);
    }

    __gshared {
        pSDL_NumHaptics SDL_NumHaptics;
        pSDL_HapticName SDL_HapticName;
        pSDL_HapticOpen SDL_HapticOpen;
        pSDL_HapticOpened SDL_HapticOpened;
        pSDL_HapticIndex SDL_HapticIndex;
        pSDL_MouseIsHaptic SDL_MouseIsHaptic;
        pSDL_HapticOpenFromMouse SDL_HapticOpenFromMouse;
        pSDL_JoystickIsHaptic SDL_JoystickIsHaptic;
        pSDL_HapticOpenFromJoystick SDL_HapticOpenFromJoystick;
        pSDL_HapticClose SDL_HapticClose;
        pSDL_HapticNumEffects SDL_HapticNumEffects;
        pSDL_HapticNumEffectsPlaying SDL_HapticNumEffectsPlaying;
        pSDL_HapticQuery SDL_HapticQuery;
        pSDL_HapticNumAxes SDL_HapticNumAxes;
        pSDL_HapticEffectSupported SDL_HapticEffectSupported;
        pSDL_HapticNewEffect SDL_HapticNewEffect;
        pSDL_HapticUpdateEffect SDL_HapticUpdateEffect;
        pSDL_HapticRunEffect SDL_HapticRunEffect;
        pSDL_HapticStopEffect SDL_HapticStopEffect;
        pSDL_HapticDestroyEffect SDL_HapticDestroyEffect;
        pSDL_HapticGetEffectStatus SDL_HapticGetEffectStatus;
        pSDL_HapticSetGain SDL_HapticSetGain;
        pSDL_HapticSetAutocenter SDL_HapticSetAutocenter;
        pSDL_HapticPause SDL_HapticPause;
        pSDL_HapticUnpause SDL_HapticUnpause;
        pSDL_HapticStopAll SDL_HapticStopAll;
        pSDL_HapticRumbleSupported SDL_HapticRumbleSupported;
        pSDL_HapticRumbleInit SDL_HapticRumbleInit;
        pSDL_HapticRumblePlay SDL_HapticRumblePlay;
        pSDL_HapticRumbleStop SDL_HapticRumbleStop;
    }
}