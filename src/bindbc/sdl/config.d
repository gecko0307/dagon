
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.config;

enum SDLSupport {
    noLibrary,
    badLibrary,
    sdl200      = 200,
    sdl201      = 201,
    sdl202      = 202,
    sdl203      = 203,
    sdl204      = 204,
    sdl205      = 205,
    sdl206      = 206,
    sdl207      = 207,
    sdl208      = 208,
    sdl209      = 209,
}

version(SDL_209) enum sdlSupport = SDLSupport.sdl209;
else version(SDL_208) enum sdlSupport = SDLSupport.sdl208;
else version(SDL_207) enum sdlSupport = SDLSupport.sdl207;
else version(SDL_206) enum sdlSupport = SDLSupport.sdl206;
else version(SDL_205) enum sdlSupport = SDLSupport.sdl205;
else version(SDL_204) enum sdlSupport = SDLSupport.sdl204;
else version(SDL_203) enum sdlSupport = SDLSupport.sdl203;
else version(SDL_202) enum sdlSupport = SDLSupport.sdl202;
else version(SDL_201) enum sdlSupport = SDLSupport.sdl201;
else enum sdlSupport = SDLSupport.sdl200;

enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = (){
    string expandEnum = "enum {";
    foreach(m;__traits(allMembers, EnumType)) {
        expandEnum ~= m ~ " = " ~ fqnEnumType ~ "." ~ m ~ ",";
    }
    expandEnum  ~= "}";
    return expandEnum;
}();