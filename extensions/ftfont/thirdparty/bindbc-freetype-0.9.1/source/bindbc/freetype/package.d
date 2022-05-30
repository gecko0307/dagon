
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype;

public import bindbc.freetype.config,
              bindbc.freetype.bind;

version(BindFT_Static) {}
else public import bindbc.freetype.dynload;