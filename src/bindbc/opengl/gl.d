
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.gl;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;

private {
    SharedLib lib;
    GLSupport contextVersion;
    GLSupport loadedVersion;
}

@nogc nothrow:

GLSupport openGLContextVersion() { return contextVersion; }
GLSupport loadedOpenGLVersion() { return loadedVersion; }
bool isOpenGLLoaded() { return lib != invalidHandle; }


void unloadOpenGL()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

GLSupport loadOpenGL()
{
    version(Windows) {
        const(char)[][1] libNames = ["OpenGL32.dll"];
    }
    else version(OSX) {
        const(char)[][3] libNames = [
            "../Frameworks/OpenGL.framework/OpenGL",
            "/Library/Frameworks/OpenGL.framework/OpenGL",
            "/System/Library/Frameworks/OpenGL.framework/OpenGL"
        ];
    }
    else version(Posix) {
        const(char)[][2] libNames = [
            "libGL.so",
            "libGL.so.1"
        ];
    }
    else static assert(0, "bindbc-opengl is not yet supported on this platform");

    GLSupport ret;
    foreach(name; libNames) {
        ret = loadOpenGL(name.ptr);
        if(ret != GLSupport.noLibrary) break;
    }
    return ret;
}

GLSupport loadOpenGL(const(char)* libName)
{
    import bindbc.opengl.bind;

    // If the library isn't yet loaded, load it now.
    if(lib == invalidHandle) {
        lib = load(libName);
        if(lib == invalidHandle) {
            return GLSupport.noLibrary;
        }
    }

    // Before attempting to load *any* symbols, make sure a context
    // has been activated. This is only a requirement on Windows, and
    // only in specific cases, but always checking for it makes for
    // uniformity across platforms and no surprises when porting client
    // code from other platforms to Windows.
    contextVersion = getContextVersion(lib);
    if(contextVersion < GLSupport.gl11) return contextVersion;

    // Load the base library
    if(!lib.loadGL11()) return GLSupport.badLibrary;

    // Now load the context-dependent stuff. Always try to load up to
    // OpenGL 2.1 by default. Load higher only if configured to do so.
    auto loadedVersion = lib.loadGL21(contextVersion);
    static if(glSupport >= GLSupport.gl30) loadedVersion = lib.loadGL30(contextVersion);
    static if(glSupport >= GLSupport.gl31) loadedVersion = lib.loadGL31(contextVersion);
    static if(glSupport >= GLSupport.gl32) loadedVersion = lib.loadGL32(contextVersion);
    static if(glSupport >= GLSupport.gl33) loadedVersion = lib.loadGL33(contextVersion);
    static if(glSupport >= GLSupport.gl40) loadedVersion = lib.loadGL40(contextVersion);
    static if(glSupport >= GLSupport.gl41) loadedVersion = lib.loadGL41(contextVersion);
    static if(glSupport >= GLSupport.gl42) loadedVersion = lib.loadGL42(contextVersion);
    static if(glSupport >= GLSupport.gl43) loadedVersion = lib.loadGL43(contextVersion);
    static if(glSupport >= GLSupport.gl44) loadedVersion = lib.loadGL44(contextVersion);
    static if(glSupport >= GLSupport.gl45) loadedVersion = lib.loadGL45(contextVersion);
    static if(glSupport >= GLSupport.gl46) loadedVersion = lib.loadGL46(contextVersion);

    // From any GL versions higher than the one loaded, load the core ARB
    // extensions.
    if(loadedVersion < GLSupport.gl30) lib.loadARB30(loadedVersion);
    if(loadedVersion < GLSupport.gl31) lib.loadARB31(loadedVersion);
    if(loadedVersion < GLSupport.gl32) lib.loadARB32(loadedVersion);
    if(loadedVersion < GLSupport.gl33) lib.loadARB33(loadedVersion);
    if(loadedVersion < GLSupport.gl40) lib.loadARB40(loadedVersion);
    if(loadedVersion < GLSupport.gl41) lib.loadARB41(loadedVersion);
    if(loadedVersion < GLSupport.gl42) lib.loadARB42(loadedVersion);
    if(loadedVersion < GLSupport.gl43) lib.loadARB43(loadedVersion);
    if(loadedVersion < GLSupport.gl44) lib.loadARB44(loadedVersion);
    if(loadedVersion < GLSupport.gl45) lib.loadARB45(loadedVersion);
    if(loadedVersion < GLSupport.gl46) lib.loadARB46(loadedVersion);

    // Load all other supported extensions
    loadARB(lib, contextVersion);

    return loadedVersion;
}