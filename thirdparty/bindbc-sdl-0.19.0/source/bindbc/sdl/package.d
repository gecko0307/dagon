
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl;

public import bindbc.sdl.config,
              bindbc.sdl.bind;

static if(!staticBinding) public import bindbc.sdl.dynload;
static if(bindSDLImage) public import bindbc.sdl.image;
static if(bindSDLMixer) public import bindbc.sdl.mixer;
static if(bindSDLNet) public import bindbc.sdl.net;
static if(bindSDLTTF) public import bindbc.sdl.ttf;

/*
 Putting this here allows me to match the SDL_thread.h interface without any
 internal conflicts (which cause a runtime crash when the loader tries to
 load the SDL_CreateThread* functions into these aliases--actual functions--
 rather than the funcion pointers).
*/
version(Windows) {
    alias SDL_CreateThread = SDL_CreateThreadImpl;

    static if(sdlSupport >= SDLSupport.sdl209) {
        alias SDL_CreateThreadWithStackSize = SDL_CreateThreadWithStackSizeImpl;
    }
}
