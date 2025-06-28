module bindbc.libvlc.loader;

import core.stdc.stdint;
import bindbc.loader;
import bindbc.libvlc.types;
import bindbc.libvlc.funcs;

enum VLCSupport
{
    noLibrary,
    badLibrary,
    v3021
}

private
{
    SharedLib lib;
    VLCSupport loadedVersion;
}

void unloadVLC()
{
    if (lib != invalidHandle)
    {
        lib.unload();
    }
}

VLCSupport loadedVLCVersion()
{
    return loadedVersion;
}

bool isVLCLoaded()
{
    return lib != invalidHandle;
}

VLCSupport loadVLC()
{
    version(Windows)
    {
        const(char)[][1] libNames =
        [
            "libvlc.dll"
        ];
    }
    else version(OSX)
    {
        const(char)[][1] libNames =
        [
            "libvlc.dylib"
        ];
    }
    else version(Posix)
    {
        const(char)[][2] libNames =
        [
            "libvlc.so",
            "/usr/local/lib/libvlc.so",
        ];
    }
    else static assert(0, "libvlc is not yet supported on this platform.");
    
    VLCSupport ret;
    foreach(name; libNames)
    {
        ret = loadVLC(name.ptr);
        if (ret != VLCSupport.noLibrary)
            break;
    }
    return ret;
}

VLCSupport loadVLC(const(char)* libName)
{
    lib = load(libName);
    if (lib == invalidHandle)
    {
        return VLCSupport.noLibrary;
    }
    
    auto errCount = errorCount();
    loadedVersion = VLCSupport.badLibrary;
    
    import std.algorithm.searching: startsWith;
    static foreach(symbol; __traits(allMembers, bindbc.libvlc.funcs))
    {
        static if (symbol.startsWith("libvlc_"))
            lib.bindSymbol(
                cast(void**)&__traits(getMember, bindbc.libvlc.funcs, symbol),
                __traits(getMember, bindbc.libvlc.funcs, symbol).stringof);
    }
    
    loadedVersion = VLCSupport.v3021;
    
    if (errorCount() != errCount)
        return VLCSupport.badLibrary;
    
    return loadedVersion;
}
