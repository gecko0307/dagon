
//          Copyright Mateusz Muszyński 2019.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.nuklear;

public import bindbc.nuklear.types;
public import bindbc.nuklear.macros;

version(BindBC_Static) version = BindNuklear_Static;
version(BindNuklear_Static) public import bindbc.nuklear.bindstatic;
else public import bindbc.nuklear.binddynamic;