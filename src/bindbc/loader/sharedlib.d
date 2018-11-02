
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.loader.sharedlib;

import core.stdc.stdlib;
import core.stdc.string;

pragma(inline, false):

/// Handle to a shared library
struct SharedLib {
    private void* _handle;
}

/// Indicates an uninitialized or unassigned handle.
enum invalidHandle = SharedLib.init;

// Contains information about shared library and symbol load failures.
struct ErrorInfo {
private:
    char[32] _error;
    char[96] _message;

public @nogc nothrow @property:
    /**
        Returns the string "Missing Symbol" to indicate a symbol load failure, and
        the name of a library to indicate a library load failure.
    */
    const(char)* error() const { return _error.ptr; }

    /**
        Returns a symbol name for symbol load failures, and a system-specific error
        message for library load failures.
    */
    const(char)* message() const { return _message.ptr; }
}

private {
    ErrorInfo[] _errors;
    size_t _errorCount;
}

@nogc nothrow:

/**
    Returns an slice containing all errors that have been accumulated by the
    `load` and `bindSymbol` functions since the last call to `resetErrors`.
*/
const(ErrorInfo)[] errors()
{
    return _errors[0 .. _errorCount];
}

/**
    Returns the total number of errors that have been accumulated by the
    `load` and `bindSymbol` functions since the last call to `resetErrors`.
*/
size_t errorCount()
{
    return _errorCount;
}

/**
    Sets the error count to 0 and erases all accumulated errors. This function
    does not release any memory allocated for the error list.
*/
void resetErrors()
{
    _errorCount = 0;
    memset(_errors.ptr, 0, _errors.length * ErrorInfo.sizeof);
}

/*
void freeErrors()
{
    free(_errors.ptr);
    _errors.length = _errorCount = 0;
}
*/

/**
    Loads a symbol from a shared library and assigns it to a caller-supplied pointer.

    Params:
        lib =           a valid handle to a shared library loaded via the `load` function.
        ptr =           a pointer to a function or variable pointer whose declaration is
                        appropriate for the symbol being bound (it is up to the caller to
                        verify the types match).
        symbolName =    the name of the symbol to bind.
*/
void bindSymbol(SharedLib lib, void** ptr, const(char)* symbolName)
{
    assert(lib._handle);
    auto sym = loadSymbol(lib._handle, symbolName);
    if(sym) {
        *ptr = sym;
    }
    else {
        addErr("Missing Symbol", symbolName);
    }
}

/**
    Loads a shared library from disk, using the system-specific API and search rules.

    libName =           the name of the library to load. May include the full or relative
                        path for the file.
*/
SharedLib load(const(char)* libName)
{
    auto handle = loadLib(libName);
    if(handle) return SharedLib(handle);
    else {
        addErr(libName, null);
        return invalidHandle;
    }
}

/**
    Unloads a shared library from process memory.

    Generally, it is not necessary to call this function at program exit, as the system will ensure
    any shared libraries loaded by the process will be unloaded then. However, any loaded shared
    libraries that are no longer needed by the program during runtime, such as those that are part
    of a "hot swap" mechanism, should be unloaded to free up resources.
*/
void unload(ref SharedLib lib) {
    if(lib._handle) {
        unloadLib(lib._handle);
        lib = invalidHandle;
    }
}

private:
void allocErrs() {
    size_t newSize = _errorCount == 0 ? 16 : _errors.length * 2;
    auto errs = cast(ErrorInfo*)malloc(ErrorInfo.sizeof * newSize);
    if(!errs) exit(EXIT_FAILURE);

    if(_errorCount > 0) {
        memcpy(errs, _errors.ptr, ErrorInfo.sizeof * _errors.length);
        free(_errors.ptr);
    }

    _errors = errs[0 .. newSize];
}

void addErr(const(char)* errstr, const(char)* message)
{
    if(_errors.length == 0 || _errorCount >= _errors.length) {
        allocErrs();
    }

    auto pinfo = &_errors[_errorCount];
    strcpy(pinfo._error.ptr, errstr);

    if(message) {
        strncpy(pinfo._message.ptr, message, pinfo._message.length);
        pinfo._message[pinfo._message.length - 1] = 0;
    }
    else {
        sysError(pinfo._message.ptr, pinfo._message.length);
    }
    ++_errorCount;
}

version(Windows)
{
    import core.sys.windows.windows;

    void* loadLib(const(char)* name)
    {
        return LoadLibraryA(name);
    }

    void unloadLib(void* lib)
    {
        FreeLibrary(lib);
    }

    void* loadSymbol(void* lib, const(char)* symbolName)
    {
        return GetProcAddress(lib, symbolName);
    }

    void sysError(char* buf, size_t len)
    {
        char* msgBuf;
        enum uint langID = MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT);

        FormatMessageA(
            FORMAT_MESSAGE_ALLOCATE_BUFFER |
            FORMAT_MESSAGE_FROM_SYSTEM |
            FORMAT_MESSAGE_IGNORE_INSERTS,
            null,
            GetLastError(),
            langID,
            cast(char*)&msgBuf,
            0,
            null
        );

        if(msgBuf) {
            strncpy(buf, msgBuf, len);
            buf[len - 1] = 0;
            LocalFree(msgBuf);
        }
        else strncpy(buf, "Unknown Error\0", len);
    }
}
else version(Posix) {
    import core.sys.posix.dlfcn;

    void* loadLib(const(char)* name)
    {
        return dlopen(name, RTLD_NOW);
    }

    void unloadLib(void* lib)
    {
        dlclose(lib);
    }

    void* loadSymbol(void* lib, const(char)* symbolName)
    {
        return dlsym(lib, symbolName);
    }

    void sysError(char* buf, size_t len)
    {
        char* msg = dlerror();
        strncpy(buf, msg != null ? msg : "Unknown Error", len);
        buf[len - 1] = 0;
    }
}
else static assert(0, "bindbc-loader is not implemented on this platform.");