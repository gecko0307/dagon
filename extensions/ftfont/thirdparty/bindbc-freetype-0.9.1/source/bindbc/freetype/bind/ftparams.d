
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.freetype.bind.ftparams;

import bindbc.freetype.bind.fttypes;

enum FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_FAMILY = FT_MAKE_TAG('i', 'g', 'p', 'f');
enum FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_SUBFAMILY = FT_MAKE_TAG('i','g','p','s');
alias FT_PARAM_TAG_IGNORE_PREFERRED_FAMILY = FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_FAMILY;
alias FT_PARAM_TAG_IGNORE_PREFERRED_SUBFAMILY = FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_SUBFAMILY;

enum FT_PARAM_TAG_INCREMENTAL = FT_MAKE_TAG('i', 'n', 'c', 'r');
enum FT_PARAM_TAG_LCD_FILTER_WEIGHTS = FT_MAKE_TAG('l', 'c', 'd', 'f');
enum FT_PARAM_TAG_RANDOM_SEED = FT_MAKE_TAG('s', 'e', 'e', 'd');
enum FT_PARAM_TAG_STEM_DARKENING = FT_MAKE_TAG('d', 'a', 'r', 'k');

// Deprecated
enum T_PARAM_TAG_UNPATENTED_HINTING = FT_MAKE_TAG( 'u', 'n', 'p', 'a' );
