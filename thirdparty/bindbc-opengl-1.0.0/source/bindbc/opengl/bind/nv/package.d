
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.nv;

public import bindbc.opengl.bind.nv.nv_30;
public import bindbc.opengl.bind.nv.nv_32;
public import bindbc.opengl.bind.nv.nv_44;

import bindbc.loader.sharedlib;
import bindbc.opengl.config;
package(bindbc.opengl) @nogc nothrow
void loadNV(SharedLib lib, GLSupport contextVersion) {
  loadNV_30(lib, contextVersion);
  loadNV_32(lib, contextVersion);
  loadNV_44(lib, contextVersion);
}
