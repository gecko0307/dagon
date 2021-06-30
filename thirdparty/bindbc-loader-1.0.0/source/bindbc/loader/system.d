
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.loader.system;

static if((void*).sizeof == 8) {
    enum bind64 = true;
    enum bind32 = false;
}
else {
    enum bind64 = false;
    enum bind32 = true;
}

version(Windows) enum bindWindows = true;
else enum bindWindows = false;

version(OSX) enum bindMac = true;
else enum bindMac = false;

version(linux) enum bindLinux = true;
else enum bindLinux = false;

version(Posix) enum bindPosix = true;
else enum bindPosix = false;

version(Android) enum bindAndroid = true;
else enum bindAndroid = false;

enum bindIOS = false;
enum bindWinRT = false;

version(FreeBSD) {
    enum bindBSD = true;
    enum bindFreeBSD = true;
    enum bindOpenBSD = false;
}
else version(OpenBSD) {
    enum bindBSD = true;
    enum bindFreeBSD = false;
    enum bindOpenBSD = true;
}
else version(BSD) {
    enum bindBSD = true;
    enum bindFreeBSD = false;
    enum bindOpenBSD = false;
}
else {
    enum bindBSD = false;
    enum bindFreeBSD = false;
    enum bindOpenBSD = false;
}