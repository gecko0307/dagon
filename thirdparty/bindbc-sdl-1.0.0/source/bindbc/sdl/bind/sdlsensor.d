
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlsensor;

import bindbc.sdl.config;

static if(sdlSupport >= SDLSupport.sdl209) {
    struct SDL_Sensor;
    alias int SDL_SensorID;

    enum SDL_SensorType {
        SDL_SENSOR_INVALID = -1,
        SDL_SENSOR_UNKNOWN,
        SDL_SENSOR_ACCEL,
        SDL_SENSOR_GYRO,
    }
    mixin(expandEnum!SDL_SensorType);

    enum SDL_STANDARD_GRAVITY = 9.80665f;

    static if(staticBinding) {
        extern(C) @nogc nothrow {
            int SDL_NumSensors();
            const(char)* SDL_SensorGetDeviceName(int device_index);
            SDL_SensorType SDL_SensorGetDeviceType(int device_index);
            int SDL_SensorGetDeviceNonPortableType(int device_index);
            SDL_SensorID SDL_SensorGetDeviceInstanceID(int device_index);
            SDL_Sensor* SDL_SensorOpen(int device_index);
            SDL_Sensor* SDL_SensorFromInstanceID(SDL_SensorID instance_id);
            const(char)* SDL_SensorGetName(SDL_Sensor* sensor);
            SDL_SensorType SDL_SensorGetType(SDL_Sensor* sensor);
            int SDL_SensorGetNonPortableType(SDL_Sensor* sensor);
            int SDL_SensorGetData(SDL_Sensor* sensor, float* data, int num_values);
            void SDL_SensorClose(SDL_Sensor* sensor);
            void SDL_SensorUpdate();
        }
    }
    else {
        extern(C) @nogc nothrow {
            alias pSDL_NumSensors = int function();
            alias pSDL_SensorGetDeviceName = const(char)* function(int device_index);
            alias pSDL_SensorGetDeviceType = SDL_SensorType function(int device_index);
            alias pSDL_SensorGetDeviceNonPortableType = int function(int device_index);
            alias pSDL_SensorGetDeviceInstanceID = SDL_SensorID function(int device_index);
            alias pSDL_SensorOpen = SDL_Sensor* function(int device_index);
            alias pSDL_SensorFromInstanceID = SDL_Sensor* function(SDL_SensorID instance_id);
            alias pSDL_SensorGetName = const(char)* function(SDL_Sensor* sensor);
            alias pSDL_SensorGetType = SDL_SensorType function(SDL_Sensor* sensor);
            alias pSDL_SensorGetNonPortableType = int function(SDL_Sensor* sensor);
            alias pSDL_SensorGetData = int function(SDL_Sensor* sensor, float* data, int num_values);
            alias pSDL_SensorClose = void function(SDL_Sensor* sensor);
            alias pSDL_SensorUpdate = void function();
        }

        __gshared {
            pSDL_NumSensors SDL_NumSensors;
            pSDL_SensorGetDeviceName SDL_SensorGetDeviceName;
            pSDL_SensorGetDeviceType SDL_SensorGetDeviceType;
            pSDL_SensorGetDeviceNonPortableType SDL_SensorGetDeviceNonPortableType;
            pSDL_SensorGetDeviceInstanceID SDL_SensorGetDeviceInstanceID;
            pSDL_SensorOpen SDL_SensorOpen;
            pSDL_SensorFromInstanceID SDL_SensorFromInstanceID;
            pSDL_SensorGetName SDL_SensorGetName;
            pSDL_SensorGetType SDL_SensorGetType;
            pSDL_SensorGetNonPortableType SDL_SensorGetNonPortableType;
            pSDL_SensorGetData SDL_SensorGetData;
            pSDL_SensorClose SDL_SensorClose;
            pSDL_SensorUpdate SDL_SensorUpdate;
        }
    }
}