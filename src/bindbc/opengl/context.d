
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.context;

import bindbc.loader;
import bindbc.opengl.config;

private {
    enum uint glVersion = 0x1F02;
    enum uint glExtensions = 0x1F03;
    enum uint glNumExtensions = 0x821D;
    extern(System) @nogc nothrow {
        alias GetString = const(char)* function(uint);
        alias GetStringi = const(char)* function(uint,uint);
        alias GetIntegerv = void function(uint, int*);
    }
    __gshared {
        GetString getString;
        GetStringi getStringi;
        GetIntegerv getIntegerv;
    }

    extern(System) @nogc nothrow {
        alias GetCurrentContext = void* function();
        alias GetProcAddress = void* function(const(char)*);
    }
    __gshared {
        GetCurrentContext getCurrentContext;
        GetProcAddress getProcAddress;
    }

    version(Windows) {
        enum getCurrentContextName = "wglGetCurrentContext";
        enum getProcAddressName = "wglGetProcAddress";
    }
    else version(OSX) {
        enum getCurrentContextName = "CGLGetCurrentContext";
    }
    else version(Posix) {
        enum getCurrentContextName = "glXGetCurrentContext";
        enum getProcAddressName = "glXGetProcAddress";
    }
    else static assert(0, "Platform Problem!!!");
}

@nogc nothrow:

package GLSupport getContextVersion(SharedLib lib)
{
    // Lazy load the appropriate symbols for fetching the current context
    // and getting OpenGL symbols from it.
    if(getCurrentContext == null) {
        lib.bindSymbol(cast(void**)&getCurrentContext, getCurrentContextName);
        if(getCurrentContext == null) return GLSupport.badLibrary;

        version(OSX) { /* Nothing to do */ }
        else {
            lib.bindSymbol(cast(void**)&getProcAddress, getProcAddressName);
            if(getProcAddress == null) return GLSupport.badLibrary;
        }
    }

    // Check if a context is current
    if(getCurrentContext() == null) return GLSupport.noContext;

    // Lazy load glGetString to check the context version
    if(getString == null) {
        lib.bindSymbol(cast(void**)&getString, "glGetString");
        if(getString == null) return GLSupport.badLibrary;
    }

    /* glGetString(GL_VERSION) is guaranteed to return a constant string
      of the format "[major].[minor].[build] xxxx", where xxxx is vendor-specific
      information. Here, I'm pulling two characters out of the string, the major
      and minor version numbers. */
    auto verstr = getString(glVersion);
    char major = *verstr;
    char minor = *(verstr + 2);

    GLSupport support = GLSupport.noLibrary;

    switch(major) {
        case '4':
            if(minor == '5') support = GLSupport.gl45;
            else if(minor == '4') support = GLSupport.gl44;
            else if(minor == '3') support = GLSupport.gl43;
            else if(minor == '2') support = GLSupport.gl42;
            else if(minor == '1') support = GLSupport.gl41;
            else if(minor == '0') support = GLSupport.gl40;

            /* No default condition here, since it's possible for new
             minor versions of the 4.x series to be released before
             support is added. That case is handled outside
             of the switch. When no more 4.x versions are released, this
             should be changed to return GL40 by default. */
            break;

        case '3':
            if(minor == '3') support = GLSupport.gl33;
            else if(minor == '2') support = GLSupport.gl32;
            else if(minor == '1') support = GLSupport.gl31;
            else support = GLSupport.gl30;
            break;

        case '2':
            if(minor == '1') support = GLSupport.gl21;
            else support = GLSupport.gl20;
            break;

        case '1':
            if(minor == '5') support = GLSupport.gl15;
            else if(minor == '4') support = GLSupport.gl14;
            else if(minor == '3') support = GLSupport.gl13;
            else if(minor == '2') support = GLSupport.gl12;
            else support = GLSupport.gl11;
            break;

        default:
            /* glGetString(GL_VERSION) is guaranteed to return a result
             of a specific format, so if this point is reached it is
             going to be because a major version higher than what BindBC
             supports was encountered. That case is handled outside the
             switch. */
            break;
    }

    // If support hasn't yet been set, it means the context has a higher
    // version than the binding knows about. Set to the compile-time version.
    if(support == GLSupport.noLibrary) support = glSupport;

    // For contexts >= 3.0, make sure glGetStringi & glGetIntegerv are avaliable.
    if(support >= GLSupport.gl30) {
        lib.bindGLSymbol(cast(void**)&getStringi, "glGetStringi");

        // Use bindSymbol here, since it's a base function
        lib.bindSymbol(cast(void**)&getIntegerv, "glGetIntegerv");

        if(getStringi == null || getIntegerv == null)
            return GLSupport.badLibrary;
    }

    return support;
}

private uint numErrors;

package(bindbc.opengl):

uint errorCountGL() { return numErrors; }

bool resetErrorCountGL()
{
    if(numErrors != 0) {
        numErrors = 0;
        return false;
    }
    else return true;
}

void bindGLSymbol(SharedLib lib, void** ptr, const(char)* symName)
{
    // Use dlopen on Mac
    version(OSX) {
        auto startErrorCount = errorCount();
        lib.bindSymbol(ptr, symName);
        numErrors += errorCount() - startErrorCount;
    }
    else {
        *ptr = getProcAddress(symName);
        if(*ptr == null) ++numErrors;
    }
}

bool hasExtension(GLSupport contextVersion, const(char)* extName)
{
    import core.stdc.string : strcmp, strstr, strlen;

    // With a modern context, use the modern approach
    if(contextVersion >= GLSupport.gl30) {
        int count;
        getIntegerv(glNumExtensions, &count);

        const(char)* ext;
        for(int i=0; i<count; ++i) {
            ext = getStringi(glExtensions, i);
            if(ext && strcmp(ext, extName) == 0) return true;
        }
    }
    // Otherwise, use the classic approach
    else {
        auto extstr = getString(glExtensions);
        if(!extstr) return false;

        auto len = strlen(extName);
        auto ext = strstr(extstr, extName);
        while(ext) {
            /* It's possible that the extension name is actually a substring of
             another extension. If not, then the character following the name in
             the extension string should be a space (or possibly the null character).
            */
            if(ext[len] == ' ' || ext[len] == '\0') return true;
            ext = strstr(ext + len, extName);
        }
    }

    return false;
}