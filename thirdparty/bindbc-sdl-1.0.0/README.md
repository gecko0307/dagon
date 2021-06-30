# bindbc-sdl
This project provides both static and dynamic bindings to the [Simple Direct Media Library (SDL)](https://libsdl.org/) and its satellite libraries. They are compatible with `@nogc` and `nothrow` and can be compiled with `-betterC` compatibility. This package is intended as a replacement of [DerelictSDL2](https://github.com/DerelictOrg/DerelictSDL2), which does not provide the same level of compatibility.

## Usage
__NOTE__: This documentation describes how to use bindbc-sdl. As the maintainer of this library, I do not provide instructions on using the SDL library. However, since this is a direct binding to the SDL API, the existing SDL documentation and tutorials can be adapted to D with few modifications (those being minor differences in the language, such as array declaration syntax). See [the SDL Wiki](https://wiki.libsdl.org/FrontPage) for documentation on the SDL API. [The SDL 2 tutorials from Lazy Foo' Productions](https://lazyfoo.net/tutorials/SDL/index.php) are a good start for those unfamiliar with the API.

By default, bindbc-sdl is configured to compile as dynamic bindings that are not `-betterC` compatible. The dynamic bindings have no link-time dependency on the SDL libraries, so the SDL shared libraries must be manually loaded at runtime. When configured as static bindings, there is a link-time dependency on the SDL libraries&mdash;either the static libraries or the appropriate files for linking with shared libraries on your system (see below).

When using DUB to manage your project, the static bindings can be enabled via a DUB `subConfiguration` statement in your project's package file. `-betterC` compatibility is also enabled via subconfigurations.

To use any of the supported SDL libraries, add bindbc-sdl as a dependency to your project's package config file and include the appropriate version for any of the satellite libraries you want to use. For example, the following is configured to use `SDL_image` and `SDL_ttf`, in addition to the base SDL binding, as dynamic bindings that are not `-betterC` compatible:

__dub.json__
```
dependencies {
    "bindbc-sdl": "~>1.0.0",
}
"versions": [
    "SDL_Image",
    "SDL_TTF"
],
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>1.0.0"
versions "SDL_Image" "SDL_TTF"
```

__NOTE__: Previously, the version identifiers for the satellite libraries took the form `BindSDL_Image`, `BindSDL_TTF`, etc., and required an additional version identifier to specify the library version, e.g., `SDL_Image_204`. Those version identifiers are still accepted, so existing projects will continue to compile without modification. However, now it is necessary to specify only a single version identifier per library, e.g., `SDL_Image_204` by itself will activate the `SDL_image` binding. Without the library version number, e.g., `SDL_Image`, the lowest supported version of the library is enabled.

__NOTE__: The C API from `SDL_atomics.h` is only partially implemented. It also has a dependency on the `core.atomic.atomicFence` template. In BetterC mode, this is not a problem as long as the source of DRuntime is available. The template instantiation will not require linking to DRuntime. However, if the `SDL_atomics` binding causes trouble and you don't need to use it, you can specify the version `SDL_No_Atomics` and the module's contents will not be compiled. If it's causing trouble and you need it, please report an issue.

### The dynamic bindings
The dynamic bindings require no special configuration when using DUB to manage your project. There is no link-time dependency. At runtime, the SDL shared libraries are required to be on the shared library search path of the user's system. On Windows, this is typically handled by distributing the SDL DLLs with your program. On other systems, it usually means installing the SDL runtime libraries through a package manager.

To load the shared libraries, you need to call the appropriate load function. This returns a member of the `SDLSupport` enumeration:

* `SDLsupport.noLibrary` indicating that the library failed to load (it couldn't be found)
* `SDLsupport.badLibrary` indicating that one or more symbols in the library failed to load
* a member of `SDLsupport` indicating a version number that matches the version of SDL that bindbc-sdl was configured at compile-time to load. By default, that is `SDLsupport.glfw30`, but can be configured via a version identifier (see below). This value will match the global manifest constant, `sdlSupport`.

```d
import bindbc.sdl;

/*
 This version attempts to load the SDL shared library using well-known variations of the library name for the host
 system.
*/
SDLSupport ret = loadSDL();
if(ret !=sdlSupport) {

    /*
     Handle error. For most use cases, it's reasonable to use the the error handling API in bindbc-loader to retrieve
     error messages for logging and then abort. If necessary, it's possible to determine the root cause via the return
     value:
    */

    if(ret == SDLSupport.noLibrary) {
        // The SDL shared library failed to load
    }
    else if(SDLSupport.badLibrary) {
        /*
         One or more symbols failed to load. The likely cause is that the shared library is for a lower version than bindbc-sdl was configured to load (via SDL_204, GLFW_2010 etc.)
        */
    }
}
/*
 This version attempts to load the SDL library using a user-supplied file name. Usually, the name and/or path used
 will be platform specific, as in this example which attempts to load `sdl2.dll` from the `libs` subdirectory,
 relative to the executable, only on Windows.
*/
version(Windows) loadSDL("libs/sdl2.dll");
```

[The error reporting API](https://github.com/BindBC/bindbc-loader#error-handling) in bindbc-loader can be used to log error messages.

```d
// Import the dependent package
import bindbc.sdl;

/*
 Import the sharedlib module for error handling. Assigning an alias ensures the function names do not conflict with
 other public APIs. This isn't strictly necessary, but the API names are common enough that they could appear in other
 packages.
*/
import loader = bindbc.loader.sharedlib;

bool loadLib() {
    /*
     Compare the return value of loadSDL with the global `sdlSupport` constant to determine if the version of GLFW
     configured at compile time is the version that was loaded.
    */
    auto ret = loadSDL();
    if(ret != sdlSupport) {
        // Log the error info
        foreach(info; loader.errors) {
            /*
             A hypothetical logging function. Note that `info.error` and `info.message` are `const(char)*`, not
             `string`.
            */
            logError(info.error, info.message);
        }

        // Optionally construct a user-friendly error message for the user
        string msg;
        if(ret == SDLSupport.noLibrary) {
            msg = "This application requires the SDL library.";
        } else {
            msg = "The version of the SDL library on your system is too low. Please upgrade."
        }
        // A hypothetical message box function
        showMessageBox(msg);
        return false;
    }
    return true;
}
```

By default, each bindbc-sdl binding is configured to compile bindings for the lowest supported version of the C libraries. This ensures the widest level of compatibility at runtime. This behavior can be overridden via specific version identifiers. It is recommended that you always select the minimum version you require _and no higher_. In this example, the SDL dynamic binding is compiled to support SDL 2.0.4:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>1.0.0"
},
"versions": ["SDL_204"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>1.0.0"
versions "SDL_204"
```

With this example configuration, `sdlSupport` is configured at compile time as `SDLSupport.sdl204`. If SDL 2.0.4 or later is installed on the system, `loadSDL` will return `SDLSupport.sdl204`. If a lower version of SDL is installed, `loadSDL` will return `SDLSupport.badLibrary`. In this scenario, calling `loadedSDLVersion()` will return an `SDLSupport` member indicating which version of SDL, if any, actually loaded.

If a lower version is loaded, it's still possible to call functions from that version of SDL, but any calls to functions from versions between that version and the one you configured will result in a null pointer access. For example, if you configured `SDL 2.0.4` and loaded `SDL 2.0.2`, then function pointers from both 2.0.3 and 2.0.4 will be `null`. For this reason, it's recommended to always specify your required version of the SDL library at compile time and abort when you receive an `SDLSupport.badLibrary` return value from `loadSDL`.

No matter which version was configured, the successfully loaded version can be obtained via a call to `loadedSDLVersion`. It returns one of the following:

* `SDLSupport.noLibrary` if `loadSDL` returned `SDLSupport.noLibrary`
* `SDLSupport.badLibrary` if `loadSDL` returned `SDLSupport.badLibrary` and no version of SDL successfully loaded
* a member of `SDLSupport` indicating the version of SDL that successfully loaded. When `loadSDL` returns `GLFWSupport.badLibrary`, this will be a version number lower than the one configured at compile time. Otherwise, it will be the same as the manifest constant `sdlSupport`.

The function `isSDLLoaded` returns `true` if any version of the shared library has been loaded and `false` if not.

```d
SDLSupport ret = loadSDL();
if(ret != sdlSupport) {
    if(SDLSupport.badLibrary) {
        /*
         Let's say we've configured support for SDL 2.0.10 for some of the functions added to the SDL renderer API in
         that version and don't use them if they aren't available. Let's further say that the absolute minimum version
         of SDL we require is 2.0.4, because we rely on some of the functions that version added to the SDL API.

         In this scenario, `SDLSupport.badLibrary` indicates that we have loaded a version of SDL that is less than
         2.0.10. Maybe it's 2.0.9, or 2.0.2. We require at least 2.0.4, so we can check.
        */
        if(loadedSDLVersion < SDLSupport.sdl204) {
            // Version too low. Handle the error.
        }
    }
    /*
     The only other possible return value is `SDLSupport.noLibrary`, indicating the SDL library or one of its
     dependencies could not be found.
    */
    else {
        // No library. Handle the error.
    }
}
```

The satellite libraries provide similar functions, e.g., `loadedSDLImageVersion` and `isSDLImageLoaded`.

For most use cases, it's probably not necessary to check for `SDLSupport.badLibrary` or `SDLSupport.noLibrary`. The bindbc-loader package provides [a means to fetch error information](https://github.com/BindBC/bindbc-loader#error-handling) regarding load failures. This information can be written to a log file before aborting the program.

Following are the supported versions of each SDL library and the corresponding version IDs to pass to the compiler.

| Library & Version  | Version ID       |
|--------------------|------------------|
|SDL 2.0.0           | Default          |
|SDL 2.0.1           | SDL_201          |
|SDL 2.0.2           | SDL_202          |
|SDL 2.0.3           | SDL_203          |
|SDL 2.0.4           | SDL_204          |
|SDL 2.0.5           | SDL_205          |
|SDL 2.0.6           | SDL_206          |
|SDL 2.0.7           | SDL_207          |
|SDL 2.0.8           | SDL_208          |
|SDL 2.0.9           | SDL_209          |
|SDL 2.0.10          | SDL_2010         |
|SDL 2.0.12          | SDL_2012         |
|SDL 2.0.14          | SDL_2014         |
|--                  | --               |
|SDL_image 2.0.0     | SDL_Image, SDL_Image_200|
|SDL_image 2.0.1     | SDL_Image_201    |
|SDL_image 2.0.2     | SDL_Image_202    |
|SDL_image 2.0.3     | SDL_Image_203    |
|SDL_image 2.0.4     | SDL_Image_204    |
|SDL_image 2.0.5     | SDL_Image_205    |
|--                  | --               |
|SDL_mixer 2.0.0     | SDL_Mixer, SDL_Mixer_200|
|SDL_mixer 2.0.1     | SDL_Mixer_201    |
|SDL_mixer 2.0.2     | SDL_Mixer_202    |
|SDL_mixer 2.0.4     | SDL_Mixer_204    |
|--                  | --               |
|SDL_net 2.0.0       | SDL_Net, SDL_Net_200|
|SDL_net 2.0.1       | SDL_Net_201      |
|--                  | --               |
|SDL_ttf 2.0.12      | SDL_TTF, SDL_TTF_2012|
|SDL_ttf 2.0.13      | SDL_TTF_2013     |
|SDL_ttf 2.0.14      | SDL_TTF_2014     |

__Note__: Beginning with SDL 2.0.10, all releases are even numbered (2.0.12, 2.0.14, etc.). Odd numbered versions, beginning with 2.0.11, are development versions, which are not supported by bindbc-sdl. The same is true for SDL_mixer beginning with version 2.0.4 (there is no public release of SDL_mixer 2.0.3).

__Note__: There are no differences in the public API between SDL_image versions 2.0.0 and 2.0.1, and then between versions 2.0.2, 2.0.3, 2.0.4, and 2.0.5, other than the value of `SDL_IMAGE_PATCHLEVEL`.

__Note__: There are no differences in the public API between SDL_net versions 2.0.0 and 2.0.1 other than the value of `SDL_NET_PATCHLEVEL`.

__Note__: [SDL's Filesystem](https://wiki.libsdl.org/CategoryFilesystem) API was added in SDL 2.0.1. However, there was a bug on Windows that prevented `SDL_GetPrefPath` from creating the path when it doesn't exist. When using this API on Windows, it's fine to compile with `SDL_201`&mdash;just make sure to ship SDL 2.0.2 or later with your app on Windows and _verify_ that [the loaded SDL version](https://wiki.libsdl.org/CategoryVersion) is 2.0.2 or later via the `SDL_GetVersion` function. Alternatively, you can compile your app with version `SDL_202` on Windows and `SDL_201` on other platforms, thereby guaranteeing errors if the user does not have at least SDL 2.0.2 or higher on Windows.

## The static bindings
First things first: static _bindings_ do not require static _linking_. The static bindings have a link-time dependency on either the shared _or_ static SDL libraries and any satellite SDL libraries the program uses. On Windows, you can link with the static libraries or, to use the DLLs, the import libraries. On other systems, you can link with either the static libraries or directly with the shared libraries.

Static bindings require1 the SDL development packages be installed on your system. The [SDL download page](https://www.libsdl.org/download-2.0.php) provides development packages for Windows and Mac OS X. On other systems, you can install them via your system package manager. For example, on Debian-based systems, `apt install sdl2`, or `apt-get install sdl2`, will install both the development and runtime packages.

When linking with the shared (or import) libraries, there is a runtime dependency on the shared library just as there is when using the dynamic bindings. The difference is that the shared libraries are no longer loaded manually&mdash;loading is handled automatically by the system when the program is launched. Attempting to call `loadGLFW` with the static binding enabled will result in a compilation error.

When linking with the static libraries, there is no runtime dependency on SDL. The SDL homepage does not distribute pre-compiled static libraries. If you decide to obtain static libraries from another source, or by compiling them yourself, you will also need to ensure that you link with all of SDL's link-time dependencies (such as the OpenGL library and system API libraries).

Personally, I recommend you avoid using any static SDL libraries. Using the static bindings is pefectly fine; just link with the shared libraries.

Enabling the static bindings can be done in two ways.

### Via the compiler's `-version` switch or DUB's `versions` directive
Pass the `BindSDL_Static` version to the compiler and link with the appropriate libraries. Note that `BindSDL_Static` will also enable the static bindings for any satellite libraries used.

When using the compiler command line or a build system that doesn't support DUB, this is the only option. The `-version=BindSDL_Static` option should be passed to the compiler when building your program. All of the required C libraries, as well as the bindbc-sdl static libraries, must also be passed to the compiler on the command line or via your build system's configuration.

__NOTE__: The version identifier `BindBC_Static` can be used to configure all of the _official_ BindBC packages used in your program, i.e., those maintained in [the BindBC GitHub organization](https://github.com/BindBC). Some third-party BindBC packages may support it as well.

For example, when using the static bindings for SDL and SDL_image with DUB:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>1.0.0"
},
"versions": ["BindSDL_Static", "SDL_Image"],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>1.0.0"
versions "BindSDL_Static" "SDL_Image"
libs "SDL2" "SDL2_image"
```

### Via DUB subconfigurations
Instead of using DUB's `versions` directive, a `subConfiguration` can be used. Enable the `static` subconfiguration for the bindbc-sdl dependency:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>1.0.0"
},
"subConfigurations": {
    "bindbc-sdl": "static"
},
"versions": [
    "SDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>1.0.0"
subConfiguration "bindbc-sdl" "static"
versions "SDL_Image"
libs "SDL2" "SDL2_image"
```

This has the benefit of completely excluding from the build any source modules related to the dynamic bindings, i.e., they will never be passed to the compiler. Using the version approach, the related modules are still passed to the compiler, but their contents are versioned out.

## `-betterC` support
`-betterC` support is enabled via the `dynamicBC` and `staticBC` subconfigurations, for dynamic and static bindings respectively. To enable the static bindings with `-betterC` support:

__dub.json__
```
"dependencies": {
    "bindbc-sdl": "~>1.0.0"
},
"subConfigurations": {
    "bindbc-sdl": "staticBC"
},
"versions": [
    "SDL_Image"
],
"libs": ["SDL2", "SDL2_image"]
```

__dub.sdl__
```
dependency "bindbc-sdl" version="~>1.0.0"
subConfiguration "bindbc-sdl" "staticBC"
versions "SDL_Image"
libs "SDL2" "SDL2_image"
```

Replace `staticBC` with `dynamicBC` to enable `-betterC` support with the dynamic bindings.

When not using DUB to manage your project, first use DUB to compile the BindBC libraries with the `dynamicBC` or `staticBC` configuration, then pass `-betterC` to the compiler when building your project (and `-version=BindSDL_Static` if you used the `staticBC` configuration).

## Loading from outside the DLL search path on Windows
The SDL libraries load some dependency DLLs dynamically in the same way that BindBC can load libraries dynamically. There is an issue that can arise on Windows when putting some of the SDL DLLs in a subdirectory of your executable directory. That is, if your executable is in, e.g., the directory `myapp`, and the SDL DLLs are in, e.g., the directory `myapp\libs`, you may find that one or more of the SDL libraries fails to load. To solve or prevent this problem, take the following steps.

First, make sure the non-system libraries on which the SDL libraries depend (such as `zlib.dll`) are in the same directory as the SDL libraries.

Second, you'll want to add your subdirectory path to the Windows DLL search path. This can be accomplished via the function `setCustomLoaderSearchPath` in bindbc.loader. For details on and a full example of how to properly use this function, see the section of the bindbc.loader README titled ["Default Windows search path"](https://github.com/BindBC/bindbc-loader#default-windows-search-path).

The idea is that you call the function with the path to all of the DLLs before calling any of the load functions, then call it again with a `null` argument to reset the default search path. Bear in mind that some of the satellite libraries load their dependencies lazily. For example, `SDL_image` will only load `libpng` when `IMG_Init` is called with the `IMG_INIT_PNG` flag, so the second call should not occur until after the libraries have been initialized.

```d
import bindbc.loader,
       bindbc.sdl;

// Assume the DLLs are stored in the "dlls" subdirectory
version(Windows) setCustomLoaderSearchPath("dlls");

if(loadSDL() < sdlSupport) { /* handle error */ }
if(loadSDL_Image() < sdlImageSupport) { /* handle error */ }

// Give SDL_image a chance to load libpng and libjpeg
auto flags = IMG_INIT_PNG | IMG_INIT_JPEG;
if(IMG_Init(flags) != flags) { /* handle error */ }

// Now reset the default loader search path
version(Windows) setCustomLoaderSearchPath(null);
```

It is not strictly necessary to reset the default search path, but doing so can avoid unexpected issues for any other dependencies that may be loaded dynamically by an application's process.

`setCustomLoaderSearchPath` is only implemented on Windows. I know of no way to programmatically manipulate the default search path on Linux or other platforms (please correct me if I'm wrong). Then again, this issue doesn't generally arise on those platforms.
