
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
    sdl2010     = 2010,
    sdl2012     = 2012,
}

version(BindBC_Static) version = BindSDL_Static;
version(BindSDL_Static) enum staticBinding = true;
else enum staticBinding = false;

version(SDL_2012) enum sdlSupport = SDLSupport.sdl2012;
else version(SDL_2010) enum sdlSupport = SDLSupport.sdl2010;
else version(SDL_209) enum sdlSupport = SDLSupport.sdl209;
else version(SDL_208) enum sdlSupport = SDLSupport.sdl208;
else version(SDL_207) enum sdlSupport = SDLSupport.sdl207;
else version(SDL_206) enum sdlSupport = SDLSupport.sdl206;
else version(SDL_205) enum sdlSupport = SDLSupport.sdl205;
else version(SDL_204) enum sdlSupport = SDLSupport.sdl204;
else version(SDL_203) enum sdlSupport = SDLSupport.sdl203;
else version(SDL_202) enum sdlSupport = SDLSupport.sdl202;
else version(SDL_201) enum sdlSupport = SDLSupport.sdl201;
else enum sdlSupport = SDLSupport.sdl200;

version(SDL_Image) version = BindSDL_Image;
else version(SDL_Image_200) version = BindSDL_Image;
else version(SDL_Image_201) version = BindSDL_Image;
else version(SDL_Image_202) version = BindSDL_Image;
else version(SDL_Image_203) version = BindSDL_Image;
else version(SDL_Image_204) version = BindSDL_Image;
else version(SDL_Image_205) version = BindSDL_Image;
version(BindSDL_Image) enum bindSDLImage = true;
else enum bindSDLImage = false;

version(SDL_Mixer) version = BindSDL_Mixer;
else version(SDL_Mixer_200) version = BindSDL_Mixer;
else version(SDL_Mixer_201) version = BindSDL_Mixer;
else version(SDL_Mixer_202) version = BindSDL_Mixer;
else version(SDL_Mixer_204) version = BindSDL_Mixer;
version(BindSDL_Mixer) enum bindSDLMixer = true;
else enum bindSDLMixer = false;

version(SDL_Net) version = BindSDL_Net;
else version(SDL_Net_200) version = BindSDL_Net;
else version(SDL_Net_201) version = BindSDL_Net;
version(BindSDL_Net) enum bindSDLNet = true;
else enum bindSDLNet = false;

version(SDL_TTF) version = BindSDL_TTF;
else version(SDL_TTF_2012) version = BindSDL_TTF;
else version(SDL_TTF_2013) version = BindSDL_TTF;
else version(SDL_TTF_2014) version = BindSDL_TTF;
version(BindSDL_TTF) enum bindSDLTTF = true;
else enum bindSDLTTF = false;

enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = (){
    string expandEnum = "enum {";
    foreach(m;__traits(allMembers, EnumType)) {
        expandEnum ~= m ~ " = " ~ fqnEnumType ~ "." ~ m ~ ",";
    }
    expandEnum  ~= "}";
    return expandEnum;
}();