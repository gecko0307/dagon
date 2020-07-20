
//          Copyright Mateusz Muszyński 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.nuklear.macros;

import bindbc.nuklear.types;
import bindbc.nuklear.binddynamic;
import bindbc.nuklear.bindstatic;

version (NK_ALL)
{
    version = NK_INCLUDE_FIXED_TYPES;
    version = NK_INCLUDE_DEFAULT_ALLOCATOR;
    version = NK_INCLUDE_STANDARD_IO;
    version = NK_INCLUDE_STANDARD_VARARGS;
    version = NK_INCLUDE_VERTEX_BUFFER_OUTPUT;
    version = NK_INCLUDE_FONT_BAKING;
    version = NK_INCLUDE_DEFAULT_FONT;
    version = NK_INCLUDE_COMMAND_USERDATA;
    version = NK_BUTTON_TRIGGER_ON_RELEASE;
    version = NK_ZERO_COMMAND_MEMORY;
    version = NK_UINT_DRAW_INDEX;
}

version (D_BetterC)
{
}
else
{
    version = gc_and_throw;
}

@nogc nothrow {
    alias nk_command_delegate = void delegate(const(nk_command)*);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        alias nk_draw_command_delegate = void delegate(const(nk_draw_command)*);
    }
}

version(gc_and_throw) {
    alias nk_command_delegate_gc = void delegate(const(nk_command)*);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        alias nk_draw_command_delegate_gc = void delegate(const(nk_draw_command)*);
    }
}

pragma(inline, true) {
    @nogc nothrow
    void nk_foreach(nk_context* ctx, nk_command_delegate block) {
        for (auto c = nk__begin(ctx); c != null; c = nk__next(ctx, c)) {
            block(c);
        }
    }

    @nogc nothrow
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        void nk_draw_foreach(nk_context *ctx, const(nk_buffer) *b, nk_draw_command_delegate block) {
            for (auto c = nk__draw_begin(ctx, b); c != null; c = nk__draw_next(c, b, ctx)) {
                block(c);
            }
        }
    }
    version(gc_and_throw) {
        void nk_foreach(nk_context* ctx, nk_command_delegate_gc block) {
            for (auto c = nk__begin(ctx); c != null; c = nk__next(ctx, c)) {
                block(c);
            }
        }

        version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
            void nk_draw_foreach(nk_context *ctx, const(nk_buffer) *b, nk_draw_command_delegate_gc block) {
                for (auto c = nk__draw_begin(ctx, b); c != null; c = nk__draw_next(c, b, ctx)) {
                    block(c);
                }
            }
        }
    }
}

@nogc nothrow {
    pragma(inline, true) {
        auto nk_tree_push(size_t line = __LINE__)(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state) {
            return nk_tree_push_hashed(ctx, type, title, state, null, 0, line);
        }

        auto nk_tree_push_id(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state, int id) {
            return nk_tree_push_hashed(ctx, type, title, state, null, 0, id);
        }

        auto nk_tree_image_push(size_t line = __LINE__)(nk_context *ctx, nk_tree_type type, nk_image img, const(char) *title, nk_collapse_states state) {
            return nk_tree_image_push_hashed(ctx, type, img, title, state, null, 0, line);
        }
        auto nk_tree_image_push_id(nk_context *ctx, nk_tree_type type, nk_image img, const(char) *title, nk_collapse_states state, int id) {
            return nk_tree_image_push_hashed(ctx, type, img, title, state, null, 0, id);
        }

        auto nk_tree_element_push(size_t line = __LINE__)(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state, int* selected) {
            return nk_tree_element_push_hashed(ctx, type, title, state, selected, null, 0, line);
        }
        auto nk_tree_element_push_id(nk_context *ctx, nk_tree_type type, const(char) *title, nk_collapse_states state, int* selected, int id) {
            return nk_tree_element_push_hashed(ctx, type, title, state, selected, null, 0, id);
        }

        version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
            void nk_draw_list_foreach(const(nk_draw_list) *can, const(nk_buffer) *b, nk_draw_command_delegate block) {
                for (auto c = nk__draw_list_begin(can, b); c != null; c = nk__draw_list_next(c, b, can)) {
                    block(c);
                }
            }
        }
    }
}
version(gc_and_throw) {
    pragma(inline, true) {
        version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
            void nk_draw_list_foreach(const(nk_draw_list) *can, const(nk_buffer) *b, nk_draw_command_delegate_gc block) {
                for (auto c = nk__draw_list_begin(can, b); c != null; c = nk__draw_list_next(c, b, can)) {
                    block(c);
                }
            }
        }
    }
}