
//          Copyright 2018 - 2022 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.bind.sdlhidapi;

import bindbc.sdl.config;

static if(sdlSupport >= SDLSupport.sdl2018) {

    import bindbc.sdl.bind.sdlstdinc : SDL_bool;

    struct SDL_hid_device;

    struct SDL_hid_device_info {
        char* path;
        ushort vendor_id;
        ushort product_id;
        dchar* serial_number;
        ushort release_number;
        dchar* manufacturer_string;
        dchar* product_string;
        ushort usage_page;
        ushort usage;
        int interface_number;
        int interface_class;
        int interface_subclass;
        int interface_protocol;
        SDL_hid_device_info* next;
    };

    static if(staticBinding) {
        extern(C) @nogc nothrow {
            int SDL_hid_init();
            int SDL_hid_exit();
            uint SDL_hid_device_change_count();
            SDL_hid_device_info* SDL_hid_enumerate(ushort vendor_id, ushort product_id);
            void SDL_hid_free_enumeration(SDL_hid_device_info* devs);
            SDL_hid_device* SDL_hid_open(ushort vendor_id, ushort product_id, const(dchar)* serial_number);
            SDL_hid_device* SDL_hid_open_path(const(char)* path, int bExclusive = false);
            int SDL_hid_write(SDL_hid_device* dev, const(ubyte*) data, size_t length);
            int SDL_hid_read_timeout(SDL_hid_device* dev, ubyte* data, size_t length, int milliseconds);
            int SDL_hid_read(SDL_hid_device* dev, ubyte* data, size_t length);
            int SDL_hid_set_nonblocking(SDL_hid_device* dev, int nonblock);
            int SDL_hid_send_feature_report(SDL_hid_device* dev, const(ubyte)* data, size_t length);
            int SDL_hid_get_feature_report(SDL_hid_device* dev, ubyte* data, size_t length);
            int SDL_hid_get_manufacturer_string(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            int SDL_hid_get_product_string(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            int SDL_hid_get_serial_number_string(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            int SDL_hid_get_indexed_string(SDL_hid_device* dev, int string_index, dchar* string_, size_t maxlen);
            void SDL_hid_ble_scan(SDL_bool active);
        }
    }
    else {
        extern(C) @nogc nothrow {
            alias pSDL_hid_init = int function();
            alias pSDL_hid_exit = int function();
            alias pSDL_hid_device_change_count = uint function();
            alias pSDL_hid_enumerate = SDL_hid_device_info* function(ushort vendor_id, ushort product_id);
            alias pSDL_hid_free_enumeration = void function(SDL_hid_device_info* devs);
            alias pSDL_hid_open = SDL_hid_device* function(ushort vendor_id, ushort product_id, const(dchar)* serial_number);
            alias pSDL_hid_open_path = SDL_hid_device* function(const(char)* path, int bExclusive = false);
            alias pSDL_hid_write = int function(SDL_hid_device* dev, const(ubyte*) data, size_t length);
            alias pSDL_hid_read_timeout = int function(SDL_hid_device* dev, ubyte* data, size_t length, int milliseconds);
            alias pSDL_hid_read = int function(SDL_hid_device* dev, ubyte* data, size_t length);
            alias pSDL_hid_set_nonblocking = int function(SDL_hid_device* dev, int nonblock);
            alias pSDL_hid_send_feature_report = int function(SDL_hid_device* dev, const(ubyte)* data, size_t length);
            alias pSDL_hid_get_feature_report = int function(SDL_hid_device* dev, ubyte* data, size_t length);
            alias pSDL_hid_get_manufacturer_string = int function(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            alias pSDL_hid_get_product_string = int function(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            alias pSDL_hid_get_serial_number_string = int function(SDL_hid_device* dev, dchar* string_, size_t maxlen);
            alias pSDL_hid_get_indexed_string = int function(SDL_hid_device* dev, int string_index, dchar* string_, size_t maxlen);
            alias pSDL_hid_ble_scan = void function(SDL_bool active);
        }

        __gshared {
            pSDL_hid_init SDL_hid_init;
            pSDL_hid_exit SDL_hid_exit;
            pSDL_hid_device_change_count SDL_hid_device_change_count;
            pSDL_hid_enumerate SDL_hid_enumerate;
            pSDL_hid_free_enumeration SDL_hid_free_enumeration;
            pSDL_hid_open SDL_hid_open;
            pSDL_hid_open_path SDL_hid_open_path;
            pSDL_hid_write SDL_hid_write;
            pSDL_hid_read_timeout SDL_hid_read_timeout;
            pSDL_hid_read SDL_hid_read;
            pSDL_hid_set_nonblocking SDL_hid_set_nonblocking;
            pSDL_hid_send_feature_report SDL_hid_send_feature_report;
            pSDL_hid_get_feature_report SDL_hid_get_feature_report;
            pSDL_hid_get_manufacturer_string SDL_hid_get_manufacturer_string;
            pSDL_hid_get_product_string SDL_hid_get_product_string;
            pSDL_hid_get_serial_number_string SDL_hid_get_serial_number_string;
            pSDL_hid_get_indexed_string SDL_hid_get_indexed_string;
            pSDL_hid_ble_scan SDL_hid_ble_scan;
        }
    }
}
