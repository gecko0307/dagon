
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
    GLSupport contextVersion = GLSupport.noContext;
    GLSupport loadedVersion = GLSupport.noContext;
}

@nogc nothrow:

GLSupport openGLContextVersion() { return contextVersion; }
GLSupport loadedOpenGLVersion() { return loadedVersion; }
bool isOpenGLLoaded() { return lib != invalidHandle; }


void unloadOpenGL()
{
    if(lib != invalidHandle) {
        lib.unload();
        contextVersion = loadedVersion = GLSupport.noContext;
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
            "libGL.so.1",
            "libGL.so"
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
    else loadedVersion = GLSupport.gl11;

    // Now load the context-dependent stuff. `glSupport` is set to OpenGL 2.1
    // by default and can't be lower. Load higher only if configured to do so.
    with (GLSupport)
    static foreach(ver; [ gl12, gl13, gl14, gl15, gl20, gl21, gl30, gl31,
        gl32, gl33, gl40, gl41, gl42, gl43, gl44, gl45, gl46 ])
    {
        static if(ver <= glSupport)
        {
            // lib.loadGL30(contextVersion)
            if(mixin("lib.loadGL" ~ (cast(int)ver).stringof ~ "(contextVersion)"))
                loadedVersion = ver;
            else
                goto LoadARB;
        }
    }

    LoadARB:

    // From any GL versions higher than the one loaded, load the core ARB
    // extensions.
    with (GLSupport)
    static foreach(ver; [ gl30, gl31, gl32, gl33, gl40, gl41, gl42, gl43,
        gl44, gl45, gl46 ])
    {
        if(ver > loadedVersion)
            // lib.loadARB30(contextVersion)
            mixin("lib.loadARB" ~ (cast(int)ver).stringof ~ "(loadedVersion);");
    }

    // Load all other supported extensions
    loadARB(lib, contextVersion);
    loadNV(lib, contextVersion);

    return loadedVersion;
}

package:
    SharedLib libGL() { return lib; }
