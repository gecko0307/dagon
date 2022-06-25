
//          Copyright Mateusz Muszyński 2019.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.nuklear.binddynamic;

version(BindNuklear_Static) {}
else version = BindNuklear_Dynamic;

version(BindNuklear_Dynamic):

import bindbc.loader;
import bindbc.nuklear.types;

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

version(NK_INCLUDE_STANDARD_VARARGS) {
    import core.stdc.stdarg;
} 

extern(C) @nogc nothrow {
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        alias pnk_init_default = int function(nk_context*, const(nk_user_font)*);
    }
    alias pnk_init_fixed = int function(nk_context*, void* memory, nk_size size, const(nk_user_font)*);
    alias pnk_init = int function(nk_context*, nk_allocator*, const(nk_user_font)*);
    alias pnk_init_custom = int function(nk_context*, nk_buffer* cmds, nk_buffer* pool, const(nk_user_font)*);
    alias pnk_clear = void function(nk_context*);
    alias pnk_free = void function(nk_context*);
    version(NK_INCLUDE_COMMAND_USERDATA) {
        alias pnk_set_user_data = void function(nk_context*, nk_handle handle);
    }
    alias pnk_input_begin = void function(nk_context*);
    alias pnk_input_motion = void function(nk_context*, int x, int y);
    alias pnk_input_key = void function(nk_context*, nk_keys, int down);
    alias pnk_input_button = void function(nk_context*, nk_buttons, int x, int y, int down);
    alias pnk_input_scroll = void function(nk_context*, nk_vec2 val);
    alias pnk_input_char = void function(nk_context*, char);
    alias pnk_input_glyph = void function(nk_context*, const(char)*);
    alias pnk_input_unicode = void function(nk_context*, nk_rune);
    alias pnk_input_end = void function(nk_context*);
    alias pnk__begin = const(nk_command)* function(nk_context*);
    alias pnk__next = const(nk_command)* function(nk_context*, const(nk_command)*);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        alias pnk_convert = nk_flags function(nk_context*, nk_buffer* cmds, nk_buffer* vertices, nk_buffer* elements, const(nk_convert_config)*);
        alias pnk__draw_begin = const(nk_draw_command)* function(const(nk_context)*, const(nk_buffer)*);
        alias pnk__draw_end = const(nk_draw_command)* function(const(nk_context)*, const(nk_buffer)*);
        alias pnk__draw_next = const(nk_draw_command)* function(const(nk_draw_command)*, const(nk_buffer)*, const(nk_context)*);
    }
    alias pnk_begin = int function(nk_context* ctx, const(char)* title, nk_rect bounds, nk_flags flags);
    alias pnk_begin_titled = int function(nk_context* ctx, const(char)* name, const(char)* title, nk_rect bounds, nk_flags flags);
    alias pnk_end = void function(nk_context* ctx);
    alias pnk_window_find = nk_window* function(nk_context* ctx, const(char)* name);
    alias pnk_window_get_bounds = nk_rect function(const(nk_context)* ctx);
    alias pnk_window_get_position = nk_vec2 function(const(nk_context)* ctx);
    alias pnk_window_get_size = nk_vec2 function(const(nk_context)*);
    alias pnk_window_get_width = float function(const(nk_context)*);
    alias pnk_window_get_height = float function(const(nk_context)*);
    alias pnk_window_get_panel = nk_panel* function(nk_context*);
    alias pnk_window_get_content_region = nk_rect function(nk_context*);
    alias pnk_window_get_content_region_min = nk_vec2 function(nk_context*);
    alias pnk_window_get_content_region_max = nk_vec2 function(nk_context*);
    alias pnk_window_get_content_region_size = nk_vec2 function(nk_context*);
    alias pnk_window_get_canvas = nk_command_buffer* function(nk_context*);
    alias pnk_window_get_scroll = void function(nk_context*, nk_uint *offset_x, nk_uint *offset_y);  // 4.01.0
    alias pnk_window_has_focus = int function(const(nk_context)*);
    alias pnk_window_is_hovered = int function(nk_context*);
    alias pnk_window_is_collapsed = int function(nk_context* ctx, const(char)* name);
    alias pnk_window_is_closed = int function(nk_context*, const(char)*);
    alias pnk_window_is_hidden = int function(nk_context*, const(char)*);
    alias pnk_window_is_active = int function(nk_context*, const(char)*);
    alias pnk_window_is_any_hovered = int function(nk_context*);
    alias pnk_item_is_any_active = int function(nk_context*);
    alias pnk_window_set_bounds = void function(nk_context*, const(char)* name, nk_rect bounds);
    alias pnk_window_set_position = void function(nk_context*, const(char)* name, nk_vec2 pos);
    alias pnk_window_set_size = void function(nk_context*, const(char)* name, nk_vec2);
    alias pnk_window_set_focus = void function(nk_context*, const(char)* name);
    alias pnk_window_set_scroll = void function(nk_context*, nk_uint offset_x, nk_uint offset_y); // 4.01.0
    alias pnk_window_close = void function(nk_context* ctx, const(char)* name);
    alias pnk_window_collapse = void function(nk_context*, const(char)* name, nk_collapse_states state);
    alias pnk_window_collapse_if = void function(nk_context*, const(char)* name, nk_collapse_states, int cond);
    alias pnk_window_show = void function(nk_context*, const(char)* name, nk_show_states);
    alias pnk_window_show_if = void function(nk_context*, const(char)* name, nk_show_states, int cond);
    alias pnk_layout_set_min_row_height = void function(nk_context*, float height);
    alias pnk_layout_reset_min_row_height = void function(nk_context*);
    alias pnk_layout_widget_bounds = nk_rect function(nk_context*);
    alias pnk_layout_ratio_from_pixel = float function(nk_context*, float pixel_width);
    alias pnk_layout_row_dynamic = void function(nk_context* ctx, float height, int cols);
    alias pnk_layout_row_static = void function(nk_context* ctx, float height, int item_width, int cols);
    alias pnk_layout_row_begin = void function(nk_context* ctx, nk_layout_format fmt, float row_height, int cols);
    alias pnk_layout_row_push = void function(nk_context*, float value);
    alias pnk_layout_row_end = void function(nk_context*);
    alias pnk_layout_row = void function(nk_context*, nk_layout_format, float height, int cols, const(float)* ratio);
    alias pnk_layout_row_template_begin = void function(nk_context*, float row_height);
    alias pnk_layout_row_template_push_dynamic = void function(nk_context*);
    alias pnk_layout_row_template_push_variable = void function(nk_context*, float min_width);
    alias pnk_layout_row_template_push_static = void function(nk_context*, float width);
    alias pnk_layout_row_template_end = void function(nk_context*);
    alias pnk_layout_space_begin = void function(nk_context*, nk_layout_format, float height, int widget_count);
    alias pnk_layout_space_push = void function(nk_context*, nk_rect bounds);
    alias pnk_layout_space_end = void function(nk_context*);
    alias pnk_layout_space_bounds = nk_rect function(nk_context*);
    alias pnk_layout_space_to_screen = nk_vec2 function(nk_context*, nk_vec2);
    alias pnk_layout_space_to_local = nk_vec2 function(nk_context*, nk_vec2);
    alias pnk_layout_space_rect_to_screen = nk_rect function(nk_context*, nk_rect);
    alias pnk_layout_space_rect_to_local = nk_rect function(nk_context*, nk_rect);
    alias pnk_group_begin = int function(nk_context*, const(char)* title, nk_flags);
    alias pnk_group_begin_titled = int function(nk_context*, const(char)* name, const(char)* title, nk_flags);
    alias pnk_group_end = void function(nk_context*);
    alias pnk_group_scrolled_offset_begin = int function(nk_context*, nk_uint* x_offset, nk_uint* y_offset, const(char)* title, nk_flags flags);
    alias pnk_group_scrolled_begin = int function(nk_context*, nk_scroll* off, const(char)* title, nk_flags);
    alias pnk_group_scrolled_end = void function(nk_context*);
    alias pnk_group_get_scroll = void function(nk_context*, const(char)* id, nk_uint* x_offset, nk_uint* y_offset); // 4.01.0
    alias pnk_group_set_scroll = void function(nk_context*, const(char)* id, nk_uint x_offset, nk_uint y_offset); // 4.01.0
    alias pnk_tree_push_hashed = int function(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states initial_state, const(char)* hash, int len, int seed);
    alias pnk_tree_image_push_hashed = int function(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states initial_state, const(char)* hash, int len, int seed);
    alias pnk_tree_pop = void function(nk_context*);
    alias pnk_tree_state_push = int function(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states* state);
    alias pnk_tree_state_image_push = int function(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states* state);
    alias pnk_tree_state_pop = void function(nk_context*);
    alias pnk_tree_element_push_hashed = int function(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states initial_state, int* selected, const(char)* hash, int len, int seed);
    alias pnk_tree_element_image_push_hashed = int function(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states initial_state, int* selected, const(char)* hash, int len, int seed);
    alias pnk_tree_element_pop = void function(nk_context*);
    alias pnk_list_view_begin = int function(nk_context*, nk_list_view* out_, const(char)* id, nk_flags, int row_height, int row_count);
    alias pnk_list_view_end = void function(nk_list_view*);
    alias pnk_widget = nk_widget_layout_states function(nk_rect*, const(nk_context)*);
    alias pnk_widget_fitting = nk_widget_layout_states function(nk_rect*, nk_context*, nk_vec2);
    alias pnk_widget_bounds = nk_rect function(nk_context*);
    alias pnk_widget_position = nk_vec2 function(nk_context*);
    alias pnk_widget_size = nk_vec2 function(nk_context*);
    alias pnk_widget_width = float function(nk_context*);
    alias pnk_widget_height = float function(nk_context*);
    alias pnk_widget_is_hovered = int function(nk_context*);
    alias pnk_widget_is_mouse_clicked = int function(nk_context*, nk_buttons);
    alias pnk_widget_has_mouse_click_down = int function(nk_context*, nk_buttons, int down);
    alias pnk_spacing = void function(nk_context*, int cols);
    alias pnk_text = void function(nk_context*, const(char)*, int, nk_flags);
    alias pnk_text_colored = void function(nk_context*, const(char)*, int, nk_flags, nk_color);
    alias pnk_text_wrap = void function(nk_context*, const(char)*, int);
    alias pnk_text_wrap_colored = void function(nk_context*, const(char)*, int, nk_color);
    alias pnk_label = void function(nk_context*, const(char)*, nk_flags align_);
    alias pnk_label_colored = void function(nk_context*, const(char)*, nk_flags align_, nk_color);
    alias pnk_label_wrap = void function(nk_context*, const(char)*);
    alias pnk_label_colored_wrap = void function(nk_context*, const(char)*, nk_color);
    alias pnk_image = void function(nk_context*, nk_image);
    alias pnk_image_color = void function(nk_context*, nk_image, nk_color);
    version(NK_INCLUDE_STANDARD_VARARGS) {
        alias pnk_labelf = void function(nk_context*, nk_flags, const(char)*, ...);
        alias pnk_labelf_colored = void function(nk_context*, nk_flags, nk_color, const(char)*, ...);
        alias pnk_labelf_wrap = void function(nk_context*, const(char)*, ...);
        alias pnk_labelf_colored_wrap = void function(nk_context*, nk_color, const(char)*, ...);
        alias pnk_labelfv = void function(nk_context*, nk_flags, const(char)*, va_list);
        alias pnk_labelfv_colored = void function(nk_context*, nk_flags, nk_color, const(char)*, va_list);
        alias pnk_labelfv_wrap = void function(nk_context*, const(char)*, va_list);
        alias pnk_labelfv_colored_wrap = void function(nk_context*, nk_color, const(char)*, va_list);
        alias pnk_value_bool = void function(nk_context*, const(char)* prefix, int);
        alias pnk_value_int = void function(nk_context*, const(char)* prefix, int);
        alias pnk_value_uint = void function(nk_context*, const(char)* prefix, uint);
        alias pnk_value_float = void function(nk_context*, const(char)* prefix, float);
        alias pnk_value_color_byte = void function(nk_context*, const(char)* prefix, nk_color);
        alias pnk_value_color_float = void function(nk_context*, const(char)* prefix, nk_color);
        alias pnk_value_color_hex = void function(nk_context*, const(char)* prefix, nk_color);
    }
    alias pnk_button_text = int function(nk_context*, const(char)* title, int len);
    alias pnk_button_label = int function(nk_context*, const(char)* title);
    alias pnk_button_color = int function(nk_context*, nk_color);
    alias pnk_button_symbol = int function(nk_context*, nk_symbol_type);
    alias pnk_button_image = int function(nk_context*, nk_image img);
    alias pnk_button_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags text_alignment);
    alias pnk_button_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags alignment);
    alias pnk_button_image_label = int function(nk_context*, nk_image img, const(char)*, nk_flags text_alignment);
    alias pnk_button_image_text = int function(nk_context*, nk_image img, const(char)*, int, nk_flags alignment);
    alias pnk_button_text_styled = int function(nk_context*, const(nk_style_button)*, const(char)* title, int len);
    alias pnk_button_label_styled = int function(nk_context*, const(nk_style_button)*, const(char)* title);
    alias pnk_button_symbol_styled = int function(nk_context*, const(nk_style_button)*, nk_symbol_type);
    alias pnk_button_image_styled = int function(nk_context*, const(nk_style_button)*, nk_image img);
    alias pnk_button_symbol_text_styled = int function(nk_context*, const(nk_style_button)*, nk_symbol_type, const(char)*, int, nk_flags alignment);
    alias pnk_button_symbol_label_styled = int function(nk_context* ctx, const(nk_style_button)* style, nk_symbol_type symbol, const(char)* title, nk_flags align_);
    alias pnk_button_image_label_styled = int function(nk_context*, const(nk_style_button)*, nk_image img, const(char)*, nk_flags text_alignment);
    alias pnk_button_image_text_styled = int function(nk_context*, const(nk_style_button)*, nk_image img, const(char)*, int, nk_flags alignment);
    alias pnk_button_set_behavior = void function(nk_context*, nk_button_behavior);
    alias pnk_button_push_behavior = int function(nk_context*, nk_button_behavior);
    alias pnk_button_pop_behavior = int function(nk_context*);
    alias pnk_check_label = int function(nk_context*, const(char)*, int active);
    alias pnk_check_text = int function(nk_context*, const(char)*, int, int active);
    alias pnk_check_flags_label = uint function(nk_context*, const(char)*, uint flags, uint value);
    alias pnk_check_flags_text = uint function(nk_context*, const(char)*, int, uint flags, uint value);
    alias pnk_checkbox_label = int function(nk_context*, const(char)*, int* active);
    alias pnk_checkbox_text = int function(nk_context*, const(char)*, int, int* active);
    alias pnk_checkbox_flags_label = int function(nk_context*, const(char)*, uint* flags, uint value);
    alias pnk_checkbox_flags_text = int function(nk_context*, const(char)*, int, uint* flags, uint value);
    alias pnk_radio_label = int function(nk_context*, const(char)*, int* active);
    alias pnk_radio_text = int function(nk_context*, const(char)*, int, int* active);
    alias pnk_option_label = int function(nk_context*, const(char)*, int active);
    alias pnk_option_text = int function(nk_context*, const(char)*, int, int active);
    alias pnk_selectable_label = int function(nk_context*, const(char)*, nk_flags align_, int* value);
    alias pnk_selectable_text = int function(nk_context*, const(char)*, int, nk_flags align_, int* value);
    alias pnk_selectable_image_label = int function(nk_context*, nk_image, const(char)*, nk_flags align_, int* value);
    alias pnk_selectable_image_text = int function(nk_context*, nk_image, const(char)*, int, nk_flags align_, int* value);
    alias pnk_selectable_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags align_, int* value);
    alias pnk_selectable_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_, int* value);
    alias pnk_select_label = int function(nk_context*, const(char)*, nk_flags align_, int value);
    alias pnk_select_text = int function(nk_context*, const(char)*, int, nk_flags align_, int value);
    alias pnk_select_image_label = int function(nk_context*, nk_image, const(char)*, nk_flags align_, int value);
    alias pnk_select_image_text = int function(nk_context*, nk_image, const(char)*, int, nk_flags align_, int value);
    alias pnk_select_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags align_, int value);
    alias pnk_select_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_, int value);
    alias pnk_slide_float = float function(nk_context*, float min, float val, float max, float step);
    alias pnk_slide_int = int function(nk_context*, int min, int val, int max, int step);
    alias pnk_slider_float = int function(nk_context*, float min, float* val, float max, float step);
    alias pnk_slider_int = int function(nk_context*, int min, int* val, int max, int step);
    alias pnk_progress = int function(nk_context*, nk_size* cur, nk_size max, int modifyable);
    alias pnk_prog = nk_size function(nk_context*, nk_size cur, nk_size max, int modifyable);
    alias pnk_color_picker = nk_colorf function(nk_context*, nk_colorf, nk_color_format);
    alias pnk_color_pick = int function(nk_context*, nk_colorf*, nk_color_format);
    alias pnk_property_int = void function(nk_context*, const(char)* name, int min, int* val, int max, int step, float inc_per_pixel);
    alias pnk_property_float = void function(nk_context*, const(char)* name, float min, float* val, float max, float step, float inc_per_pixel);
    alias pnk_property_double = void function(nk_context*, const(char)* name, double min, double* val, double max, double step, float inc_per_pixel);
    alias pnk_propertyi = int function(nk_context*, const(char)* name, int min, int val, int max, int step, float inc_per_pixel);
    alias pnk_propertyf = float function(nk_context*, const(char)* name, float min, float val, float max, float step, float inc_per_pixel);
    alias pnk_propertyd = double function(nk_context*, const(char)* name, double min, double val, double max, double step, float inc_per_pixel);
    alias pnk_edit_string = nk_flags function(nk_context*, nk_flags, char* buffer, int* len, int max, nk_plugin_filter);
    alias pnk_edit_string_zero_terminated = nk_flags function(nk_context*, nk_flags, char* buffer, int max, nk_plugin_filter);
    alias pnk_edit_buffer = nk_flags function(nk_context*, nk_flags, nk_text_edit*, nk_plugin_filter);
    alias pnk_edit_focus = void function(nk_context*, nk_flags flags);
    alias pnk_edit_unfocus = void function(nk_context*);
    alias pnk_chart_begin = int function(nk_context*, nk_chart_type, int num, float min, float max);
    alias pnk_chart_begin_colored = int function(nk_context*, nk_chart_type, nk_color, nk_color active, int num, float min, float max);
    alias pnk_chart_add_slot = void function(nk_context* ctx, const(nk_chart_type), int count, float min_value, float max_value);
    alias pnk_chart_add_slot_colored = void function(nk_context* ctx, const(nk_chart_type), nk_color, nk_color active, int count, float min_value, float max_value);
    alias pnk_chart_push = nk_flags function(nk_context*, float);
    alias pnk_chart_push_slot = nk_flags function(nk_context*, float, int);
    alias pnk_chart_end = void function(nk_context*);
    alias pnk_plot = void function(nk_context*, nk_chart_type, const(float)* values, int count, int offset);
    alias pnk_plot_function = void function(nk_context*, nk_chart_type, void *userdata, float function(void* user, int index), int count, int offset);
    alias pnk_popup_begin = int function(nk_context*, nk_popup_type, const(char)*, nk_flags, nk_rect bounds);
    alias pnk_popup_close = void function(nk_context*);
    alias pnk_popup_end = void function(nk_context*);
    alias pnk_popup_get_scroll = void function(nk_context* , nk_uint* offset_x, nk_uint* offset_y); // 4.01.0
    alias pnk_popup_set_scroll = void function(nk_context* , nk_uint offset_x, nk_uint offset_y); // 4.01.0
    alias pnk_combo = int function(nk_context*, const(char)** items, int count, int selected, int item_height, nk_vec2 size);
    alias pnk_combo_separator = int function(nk_context*, const(char)* items_separated_by_separator, int separator, int selected, int count, int item_height, nk_vec2 size);
    alias pnk_combo_string = int function(nk_context*, const(char)* items_separated_by_zeros, int selected, int count, int item_height, nk_vec2 size);
    alias pnk_combo_callback = int function(nk_context*, void function(void*, int, const(char) **), void *userdata, int selected, int count, int item_height, nk_vec2 size);
    alias pnk_combobox = void function(nk_context*, const(char)** items, int count, int* selected, int item_height, nk_vec2 size);
    alias pnk_combobox_string = void function(nk_context*, const(char)* items_separated_by_zeros, int* selected, int count, int item_height, nk_vec2 size);
    alias pnk_combobox_separator = void function(nk_context*, const(char)* items_separated_by_separator, int separator, int* selected, int count, int item_height, nk_vec2 size);
    alias pnk_combobox_callback = void function(nk_context*, void function(void*, int, const(char) **), void*, int *selected, int count, int item_height, nk_vec2 size);;
    alias pnk_combo_begin_text = int function(nk_context*, const(char)* selected, int, nk_vec2 size);
    alias pnk_combo_begin_label = int function(nk_context*, const(char)* selected, nk_vec2 size);
    alias pnk_combo_begin_color = int function(nk_context*, nk_color color, nk_vec2 size);
    alias pnk_combo_begin_symbol = int function(nk_context*, nk_symbol_type, nk_vec2 size);
    alias pnk_combo_begin_symbol_label = int function(nk_context*, const(char)* selected, nk_symbol_type, nk_vec2 size);
    alias pnk_combo_begin_symbol_text = int function(nk_context*, const(char)* selected, int, nk_symbol_type, nk_vec2 size);
    alias pnk_combo_begin_image = int function(nk_context*, nk_image img, nk_vec2 size);
    alias pnk_combo_begin_image_label = int function(nk_context*, const(char)* selected, nk_image, nk_vec2 size);
    alias pnk_combo_begin_image_text = int function(nk_context*, const(char)* selected, int, nk_image, nk_vec2 size);
    alias pnk_combo_item_label = int function(nk_context*, const(char)*, nk_flags alignment);
    alias pnk_combo_item_text = int function(nk_context*, const(char)*, int, nk_flags alignment);
    alias pnk_combo_item_image_label = int function(nk_context*, nk_image, const(char)*, nk_flags alignment);
    alias pnk_combo_item_image_text = int function(nk_context*, nk_image, const(char)*, int, nk_flags alignment);
    alias pnk_combo_item_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags alignment);
    alias pnk_combo_item_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags alignment);
    alias pnk_combo_close = void function(nk_context*);
    alias pnk_combo_end = void function(nk_context*);
    alias pnk_contextual_begin = int function(nk_context*, nk_flags, nk_vec2, nk_rect trigger_bounds);
    alias pnk_contextual_item_text = int function(nk_context*, const(char)*, int, nk_flags align_);
    alias pnk_contextual_item_label = int function(nk_context*, const(char)*, nk_flags align_);
    alias pnk_contextual_item_image_label = int function(nk_context*, nk_image, const(char)*, nk_flags alignment);
    alias pnk_contextual_item_image_text = int function(nk_context*, nk_image, const(char)*, int len, nk_flags alignment);
    alias pnk_contextual_item_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags alignment);
    alias pnk_contextual_item_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags alignment);
    alias pnk_contextual_close = void function(nk_context*);
    alias pnk_contextual_end = void function(nk_context*);
    alias pnk_tooltip = void function(nk_context*, const(char)*);
    version(NK_INCLUDE_STANDARD_VARARGS) {
        alias pnk_tooltipf = void function(nk_context*, const(char)*, ...);
        alias pnk_tooltipfv = void function(nk_context*, const(char)*, va_list);
    }
    alias pnk_tooltip_begin = int function(nk_context*, float width);
    alias pnk_tooltip_end = void function(nk_context*);
    alias pnk_menubar_begin = void function(nk_context*);
    alias pnk_menubar_end = void function(nk_context*);
    alias pnk_menu_begin_text = int function(nk_context*, const(char)* title, int title_len, nk_flags align_, nk_vec2 size);
    alias pnk_menu_begin_label = int function(nk_context*, const(char)*, nk_flags align_, nk_vec2 size);
    alias pnk_menu_begin_image = int function(nk_context*, const(char)*, nk_image, nk_vec2 size);
    alias pnk_menu_begin_image_text = int function(nk_context*, const(char)*, int, nk_flags align_, nk_image, nk_vec2 size);
    alias pnk_menu_begin_image_label = int function(nk_context*, const(char)*, nk_flags align_, nk_image, nk_vec2 size);
    alias pnk_menu_begin_symbol = int function(nk_context*, const(char)*, nk_symbol_type, nk_vec2 size);
    alias pnk_menu_begin_symbol_text = int function(nk_context*, const(char)*, int, nk_flags align_, nk_symbol_type, nk_vec2 size);
    alias pnk_menu_begin_symbol_label = int function(nk_context*, const(char)*, nk_flags align_, nk_symbol_type, nk_vec2 size);
    alias pnk_menu_item_text = int function(nk_context*, const(char)*, int, nk_flags align_);
    alias pnk_menu_item_label = int function(nk_context*, const(char)*, nk_flags alignment);
    alias pnk_menu_item_image_label = int function(nk_context*, nk_image, const(char)*, nk_flags alignment);
    alias pnk_menu_item_image_text = int function(nk_context*, nk_image, const(char)*, int len, nk_flags alignment);
    alias pnk_menu_item_symbol_text = int function(nk_context*, nk_symbol_type, const(char)*, int, nk_flags alignment);
    alias pnk_menu_item_symbol_label = int function(nk_context*, nk_symbol_type, const(char)*, nk_flags alignment);
    alias pnk_menu_close = void function(nk_context*);
    alias pnk_menu_end = void function(nk_context*);
    alias pnk_style_default = void function(nk_context*);
    alias pnk_style_from_table = void function(nk_context*, const(nk_color)*);
    alias pnk_style_load_cursor = void function(nk_context*, nk_style_cursor, const(nk_cursor)*);
    alias pnk_style_load_all_cursors = void function(nk_context*, nk_cursor*);
    alias pnk_style_get_color_by_name = const(char)* function(nk_style_colors);
    alias pnk_style_set_font = void function(nk_context*, const(nk_user_font)*);
    alias pnk_style_set_cursor = int function(nk_context*, nk_style_cursor);
    alias pnk_style_show_cursor = void function(nk_context*);
    alias pnk_style_hide_cursor = void function(nk_context*);
    alias pnk_style_push_font = int function(nk_context*, const(nk_user_font)*);
    alias pnk_style_push_float = int function(nk_context*, float*, float);
    alias pnk_style_push_vec2 = int function(nk_context*, nk_vec2*, nk_vec2);
    alias pnk_style_push_style_item = int function(nk_context*, nk_style_item*, nk_style_item);
    alias pnk_style_push_flags = int function(nk_context*, nk_flags*, nk_flags);
    alias pnk_style_push_color = int function(nk_context*, nk_color*, nk_color);
    alias pnk_style_pop_font = int function(nk_context*);
    alias pnk_style_pop_float = int function(nk_context*);
    alias pnk_style_pop_vec2 = int function(nk_context*);
    alias pnk_style_pop_style_item = int function(nk_context*);
    alias pnk_style_pop_flags = int function(nk_context*);
    alias pnk_style_pop_color = int function(nk_context*);
    alias pnk_rgb = nk_color function(int r, int g, int b);
    alias pnk_rgb_iv = nk_color function(const(int)* rgb);
    alias pnk_rgb_bv = nk_color function(const(nk_byte)* rgb);
    alias pnk_rgb_f = nk_color function(float r, float g, float b);
    alias pnk_rgb_fv = nk_color function(const(float)* rgb);
    alias pnk_rgb_cf = nk_color function(nk_colorf c);
    alias pnk_rgb_hex = nk_color function(const(char)* rgb);
    alias pnk_rgba = nk_color function(int r, int g, int b, int a);
    alias pnk_rgba_u32 = nk_color function(nk_uint);
    alias pnk_rgba_iv = nk_color function(const(int)* rgba);
    alias pnk_rgba_bv = nk_color function(const(nk_byte)* rgba);
    alias pnk_rgba_f = nk_color function(float r, float g, float b, float a);
    alias pnk_rgba_fv = nk_color function(const(float)* rgba);
    alias pnk_rgba_cf = nk_color function(nk_colorf c);
    alias pnk_rgba_hex = nk_color function(const(char)* rgb);
    alias pnk_hsva_colorf = nk_colorf function(float h, float s, float v, float a);
    alias pnk_hsva_colorfv = nk_colorf function(float* c);
    alias pnk_colorf_hsva_f = void function(float* out_h, float* out_s, float* out_v, float* out_a, nk_colorf in_);
    alias pnk_colorf_hsva_fv = void function(float* hsva, nk_colorf in_);
    alias pnk_hsv = nk_color function(int h, int s, int v);
    alias pnk_hsv_iv = nk_color function(const(int)* hsv);
    alias pnk_hsv_bv = nk_color function(const(nk_byte)* hsv);
    alias pnk_hsv_f = nk_color function(float h, float s, float v);
    alias pnk_hsv_fv = nk_color function(const(float)* hsv);
    alias pnk_hsva = nk_color function(int h, int s, int v, int a);
    alias pnk_hsva_iv = nk_color function(const(int)* hsva);
    alias pnk_hsva_bv = nk_color function(const(nk_byte)* hsva);
    alias pnk_hsva_f = nk_color function(float h, float s, float v, float a);
    alias pnk_hsva_fv = nk_color function(const(float)* hsva);
    alias pnk_color_f = void function(float* r, float* g, float* b, float* a, nk_color);
    alias pnk_color_fv = void function(float* rgba_out, nk_color);
    alias pnk_color_cf = nk_colorf function(nk_color);
    alias pnk_color_d = void function(double* r, double* g, double* b, double* a, nk_color);
    alias pnk_color_dv = void function(double* rgba_out, nk_color);
    alias pnk_color_u32 = nk_uint function(nk_color);
    alias pnk_color_hex_rgba = void function(char* output, nk_color);
    alias pnk_color_hex_rgb = void function(char* output, nk_color);
    alias pnk_color_hsv_i = void function(int* out_h, int* out_s, int* out_v, nk_color);
    alias pnk_color_hsv_b = void function(nk_byte* out_h, nk_byte* out_s, nk_byte* out_v, nk_color);
    alias pnk_color_hsv_iv = void function(int* hsv_out, nk_color);
    alias pnk_color_hsv_bv = void function(nk_byte* hsv_out, nk_color);
    alias pnk_color_hsv_f = void function(float* out_h, float* out_s, float* out_v, nk_color);
    alias pnk_color_hsv_fv = void function(float* hsv_out, nk_color);
    alias pnk_color_hsva_i = void function(int* h, int* s, int* v, int* a, nk_color);
    alias pnk_color_hsva_b = void function(nk_byte* h, nk_byte* s, nk_byte* v, nk_byte* a, nk_color);
    alias pnk_color_hsva_iv = void function(int* hsva_out, nk_color);
    alias pnk_color_hsva_bv = void function(nk_byte* hsva_out, nk_color);
    alias pnk_color_hsva_f = void function(float* out_h, float* out_s, float* out_v, float* out_a, nk_color);
    alias pnk_color_hsva_fv = void function(float* hsva_out, nk_color);
    alias pnk_handle_ptr = nk_handle function(void*);
    alias pnk_handle_id = nk_handle function(int);
    alias pnk_image_handle = nk_image function(nk_handle);
    alias pnk_image_ptr = nk_image function(void*);
    alias pnk_image_id = nk_image function(int);
    alias pnk_image_is_subimage = int function(const(nk_image)* img);
    alias pnk_subimage_ptr = nk_image function(void*, ushort w, ushort h, nk_rect sub_region);
    alias pnk_subimage_id = nk_image function(int, ushort w, ushort h, nk_rect sub_region);
    alias pnk_subimage_handle = nk_image function(nk_handle, ushort w, ushort h, nk_rect sub_region);
    alias pnk_murmur_hash = nk_hash function(const(void)* key, int len, nk_hash seed);
    alias pnk_triangle_from_direction = void function(nk_vec2* result, nk_rect r, float pad_x, float pad_y, nk_heading);
    alias pnk_vec2 = nk_vec2 function(float x, float y);
    alias pnk_vec2i = nk_vec2 function(int x, int y);
    alias pnk_vec2v = nk_vec2 function(const(float)* xy);
    alias pnk_vec2iv = nk_vec2 function(const(int)* xy);
    alias pnk_get_null_rect = nk_rect function();
    alias pnk_rect = nk_rect function(float x, float y, float w, float h);
    alias pnk_recti = nk_rect function(int x, int y, int w, int h);
    alias pnk_recta = nk_rect function(nk_vec2 pos, nk_vec2 size);
    alias pnk_rectv = nk_rect function(const(float)* xywh);
    alias pnk_rectiv = nk_rect function(const(int)* xywh);
    alias pnk_rect_pos = nk_vec2 function(nk_rect);
    alias pnk_rect_size = nk_vec2 function(nk_rect);
    alias pnk_strlen = int function(const(char)* str);
    alias pnk_stricmp = int function(const(char)* s1, const(char)* s2);
    alias pnk_stricmpn = int function(const(char)* s1, const(char)* s2, int n);
    alias pnk_strtoi = int function(const(char)* str, const(char)** endptr);
    alias pnk_strtof = float function(const(char)* str, const(char)** endptr);
    alias pnk_strtod = double function(const(char)* str, const(char)** endptr);
    alias pnk_strfilter = int function(const(char)* text, const(char)* regexp);
    alias pnk_strmatch_fuzzy_string = int function(const(char)* str, const(char)* pattern, int* out_score);
    alias pnk_strmatch_fuzzy_text = int function(const(char)* txt, int txt_len, const(char)* pattern, int* out_score);
    alias pnk_utf_decode = int function(const(char)*, nk_rune*, int);
    alias pnk_utf_encode = int function(nk_rune, char*, int);
    alias pnk_utf_len = int function(const(char)*, int byte_len);
    alias pnk_utf_at = const(char)* function(const(char)* buffer, int length, int index, nk_rune* unicode, int* len);
    version(NK_INCLUDE_FONT_BAKING) {
        alias pnk_font_default_glyph_ranges = const(nk_rune)* function();
        alias pnk_font_chinese_glyph_ranges = const(nk_rune)* function();
        alias pnk_font_cyrillic_glyph_ranges = const(nk_rune)* function();
        alias pnk_font_korean_glyph_ranges = const(nk_rune)* function();
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            alias pnk_font_atlas_init_default = void function(nk_font_atlas*);
        }
        alias pnk_font_atlas_init = void function(nk_font_atlas*, nk_allocator*);
        alias pnk_font_atlas_init_custom = void function(nk_font_atlas*, nk_allocator* persistent, nk_allocator* transient);
        alias pnk_font_atlas_begin = void function(nk_font_atlas*);
        alias pnk_font_config = nk_font_config function(float pixel_height);
        alias pnk_font_atlas_add = nk_font* function(nk_font_atlas*, const(nk_font_config)*);
        version(NK_INCLUDE_DEFAULT_FONT) {
            alias pnk_font_atlas_add_default = nk_font* function(nk_font_atlas*, float height, const(nk_font_config)*);
        }
        alias pnk_font_atlas_add_from_memory = nk_font* function(nk_font_atlas* atlas, void* memory, nk_size size, float height, const(nk_font_config)* config);
        version(NK_INCLUDE_STANDARD_IO) {
            alias pnk_font_atlas_add_from_file = nk_font* function(nk_font_atlas* atlas, const(char)* file_path, float height, const(nk_font_config)*);
        }
        alias pnk_font_atlas_add_compressed = nk_font* function(nk_font_atlas*, void* memory, nk_size size, float height, const(nk_font_config)*);
        alias pnk_font_atlas_add_compressed_base85 = nk_font* function(nk_font_atlas*, const(char)* data, float height, const(nk_font_config)* config);
        alias pnk_font_atlas_bake = const(void)* function(nk_font_atlas*, int* width, int* height, nk_font_atlas_format);
        alias pnk_font_atlas_end = void function(nk_font_atlas*, nk_handle tex, nk_draw_null_texture*);
        alias pnk_font_find_glyph = const(nk_font_glyph)* function(nk_font*, nk_rune unicode);
        alias pnk_font_atlas_cleanup = void function(nk_font_atlas* atlas);
        alias pnk_font_atlas_clear = void function(nk_font_atlas*);
    }
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        alias pnk_buffer_init_default = void function(nk_buffer*);
    }
    alias pnk_buffer_init = void function(nk_buffer*, const(nk_allocator)*, nk_size size);
    alias pnk_buffer_init_fixed = void function(nk_buffer*, void* memory, nk_size size);
    alias pnk_buffer_info = void function(nk_memory_status*, nk_buffer*);
    alias pnk_buffer_push = void function(nk_buffer*, nk_buffer_allocation_type type, const(void)* memory, nk_size size, nk_size align_);
    alias pnk_buffer_mark = void function(nk_buffer*, nk_buffer_allocation_type type);
    alias pnk_buffer_reset = void function(nk_buffer*, nk_buffer_allocation_type type);
    alias pnk_buffer_clear = void function(nk_buffer*);
    alias pnk_buffer_free = void function(nk_buffer*);
    alias pnk_buffer_memory = void* function(nk_buffer*);
    alias pnk_buffer_memory_const = const(void)* function(const(nk_buffer)*);
    alias pnk_buffer_total = nk_size function(nk_buffer*);
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        alias pnk_str_init_default = void function(nk_str*);
    }
    alias pnk_str_init = void function(nk_str*, const(nk_allocator)*, nk_size size);
    alias pnk_str_init_fixed = void function(nk_str*, void* memory, nk_size size);
    alias pnk_str_clear = void function(nk_str*);
    alias pnk_str_free = void function(nk_str*);
    alias pnk_str_append_text_char = int function(nk_str*, const(char)*, int);
    alias pnk_str_append_str_char = int function(nk_str*, const(char)*);
    alias pnk_str_append_text_utf8 = int function(nk_str*, const(char)*, int);
    alias pnk_str_append_str_utf8 = int function(nk_str*, const(char)*);
    alias pnk_str_append_text_runes = int function(nk_str*, const(nk_rune)*, int);
    alias pnk_str_append_str_runes = int function(nk_str*, const(nk_rune)*);
    alias pnk_str_insert_at_char = int function(nk_str*, int pos, const(char)*, int);
    alias pnk_str_insert_at_rune = int function(nk_str*, int pos, const(char)*, int);
    alias pnk_str_insert_text_char = int function(nk_str*, int pos, const(char)*, int);
    alias pnk_str_insert_str_char = int function(nk_str*, int pos, const(char)*);
    alias pnk_str_insert_text_utf8 = int function(nk_str*, int pos, const(char)*, int);
    alias pnk_str_insert_str_utf8 = int function(nk_str*, int pos, const(char)*);
    alias pnk_str_insert_text_runes = int function(nk_str*, int pos, const(nk_rune)*, int);
    alias pnk_str_insert_str_runes = int function(nk_str*, int pos, const(nk_rune)*);
    alias pnk_str_remove_chars = void function(nk_str*, int len);
    alias pnk_str_remove_runes = void function(nk_str* str, int len);
    alias pnk_str_delete_chars = void function(nk_str*, int pos, int len);
    alias pnk_str_delete_runes = void function(nk_str*, int pos, int len);
    alias pnk_str_at_char = char* function(nk_str*, int pos);
    alias pnk_str_at_rune = char* function(nk_str*, int pos, nk_rune* unicode, int* len);
    alias pnk_str_rune_at = nk_rune function(const(nk_str)*, int pos);
    alias pnk_str_at_char_const = const(char)* function(const(nk_str)*, int pos);
    alias pnk_str_at_const = const(char)* function(const(nk_str)*, int pos, nk_rune* unicode, int* len);
    alias pnk_str_get = char* function(nk_str*);
    alias pnk_str_get_const = const(char)* function(const(nk_str)*);
    alias pnk_str_len = int function(nk_str*);
    alias pnk_str_len_char = int function(nk_str*);
    alias pnk_filter_default = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_ascii = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_float = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_decimal = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_hex = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_oct = int function(const(nk_text_edit)*, nk_rune unicode);
    alias pnk_filter_binary = int function(const(nk_text_edit)*, nk_rune unicode);
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        alias pnk_textedit_init_default = void function(nk_text_edit*);
    }
    alias pnk_textedit_init = void function(nk_text_edit*, nk_allocator*, nk_size size);
    alias pnk_textedit_init_fixed = void function(nk_text_edit*, void* memory, nk_size size);
    alias pnk_textedit_free = void function(nk_text_edit*);
    alias pnk_textedit_text = void function(nk_text_edit*, const(char)*, int total_len);
    alias pnk_textedit_delete = void function(nk_text_edit*, int where, int len);
    alias pnk_textedit_delete_selection = void function(nk_text_edit*);
    alias pnk_textedit_select_all = void function(nk_text_edit*);
    alias pnk_textedit_cut = int function(nk_text_edit*);
    alias pnk_textedit_paste = int function(nk_text_edit*, const(char)*, int);
    alias pnk_textedit_undo = void function(nk_text_edit*);
    alias pnk_textedit_redo = void function(nk_text_edit*);
    alias pnk_stroke_line = void function(nk_command_buffer* b, float x0, float y0, float x1, float y1, float line_thickness, nk_color);
    alias pnk_stroke_curve = void function(nk_command_buffer*, float, float, float, float, float, float, float, float, float line_thickness, nk_color);
    alias pnk_stroke_rect = void function(nk_command_buffer*, nk_rect, float rounding, float line_thickness, nk_color);
    alias pnk_stroke_circle = void function(nk_command_buffer*, nk_rect, float line_thickness, nk_color);
    alias pnk_stroke_arc = void function(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, float line_thickness, nk_color);
    alias pnk_stroke_triangle = void function(nk_command_buffer*, float, float, float, float, float, float, float line_thichness, nk_color);
    alias pnk_stroke_polyline = void function(nk_command_buffer*, float* points, int point_count, float line_thickness, nk_color col);
    alias pnk_stroke_polygon = void function(nk_command_buffer*, float*, int point_count, float line_thickness, nk_color);
    alias pnk_fill_rect = void function(nk_command_buffer*, nk_rect, float rounding, nk_color);
    alias pnk_fill_rect_multi_color = void function(nk_command_buffer*, nk_rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
    alias pnk_fill_circle = void function(nk_command_buffer*, nk_rect, nk_color);
    alias pnk_fill_arc = void function(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, nk_color);
    alias pnk_fill_triangle = void function(nk_command_buffer*, float x0, float y0, float x1, float y1, float x2, float y2, nk_color);
    alias pnk_fill_polygon = void function(nk_command_buffer*, float*, int point_count, nk_color);
    alias pnk_draw_image = void function(nk_command_buffer*, nk_rect, const(nk_image)*, nk_color);
    alias pnk_draw_text = void function(nk_command_buffer*, nk_rect, const(char)* text, int len, const(nk_user_font)*, nk_color, nk_color);
    alias pnk_push_scissor = void function(nk_command_buffer*, nk_rect);
    alias pnk_push_custom = void function(nk_command_buffer*, nk_rect, nk_command_custom_callback, nk_handle usr);
    alias pnk_input_has_mouse_click = int function(const(nk_input)*, nk_buttons);
    alias pnk_input_has_mouse_click_in_rect = int function(const(nk_input)*, nk_buttons, nk_rect);
    alias pnk_input_has_mouse_click_down_in_rect = int function(const(nk_input)*, nk_buttons, nk_rect, int down);
    alias pnk_input_is_mouse_click_in_rect = int function(const(nk_input)*, nk_buttons, nk_rect);
    alias pnk_input_is_mouse_click_down_in_rect = int function(const(nk_input)* i, nk_buttons id, nk_rect b, int down);
    alias pnk_input_any_mouse_click_in_rect = int function(const(nk_input)*, nk_rect);
    alias pnk_input_is_mouse_prev_hovering_rect = int function(const(nk_input)*, nk_rect);
    alias pnk_input_is_mouse_hovering_rect = int function(const(nk_input)*, nk_rect);
    alias pnk_input_mouse_clicked = int function(const(nk_input)*, nk_buttons, nk_rect);
    alias pnk_input_is_mouse_down = int function(const(nk_input)*, nk_buttons);
    alias pnk_input_is_mouse_pressed = int function(const(nk_input)*, nk_buttons);
    alias pnk_input_is_mouse_released = int function(const(nk_input)*, nk_buttons);
    alias pnk_input_is_key_pressed = int function(const(nk_input)*, nk_keys);
    alias pnk_input_is_key_released = int function(const(nk_input)*, nk_keys);
    alias pnk_input_is_key_down = int function(const(nk_input)*, nk_keys);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        alias pnk_draw_list_init = void function(nk_draw_list*);
        alias pnk_draw_list_setup = void function(nk_draw_list*, const(nk_convert_config)*, nk_buffer* cmds, nk_buffer* vertices, nk_buffer* elements, nk_anti_aliasing line_aa, nk_anti_aliasing shape_aa);
        alias pnk__draw_list_begin = const(nk_draw_command)* function(const(nk_draw_list)*, const(nk_buffer)*);
        alias pnk__draw_list_next = const(nk_draw_command)* function(const(nk_draw_command)*, const(nk_buffer)*, const(nk_draw_list)*);
        alias pnk__draw_list_end = const(nk_draw_command)* function(const(nk_draw_list)*, const(nk_buffer)*);
        alias pnk_draw_list_path_clear = void function(nk_draw_list*);
        alias pnk_draw_list_path_line_to = void function(nk_draw_list*, nk_vec2 pos);
        alias pnk_draw_list_path_arc_to_fast = void function(nk_draw_list*, nk_vec2 center, float radius, int a_min, int a_max);
        alias pnk_draw_list_path_arc_to = void function(nk_draw_list*, nk_vec2 center, float radius, float a_min, float a_max, uint segments);
        alias pnk_draw_list_path_rect_to = void function(nk_draw_list*, nk_vec2 a, nk_vec2 b, float rounding);
        alias pnk_draw_list_path_curve_to = void function(nk_draw_list*, nk_vec2 p2, nk_vec2 p3, nk_vec2 p4, uint num_segments);
        alias pnk_draw_list_path_fill = void function(nk_draw_list*, nk_color);
        alias pnk_draw_list_path_stroke = void function(nk_draw_list*, nk_color, nk_draw_list_stroke closed, float thickness);
        alias pnk_draw_list_stroke_line = void function(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_color, float thickness);
        alias pnk_draw_list_stroke_rect = void function(nk_draw_list*, nk_rect rect, nk_color, float rounding, float thickness);
        alias pnk_draw_list_stroke_triangle = void function(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color, float thickness);
        alias pnk_draw_list_stroke_circle = void function(nk_draw_list*, nk_vec2 center, float radius, nk_color, uint segs, float thickness);
        alias pnk_draw_list_stroke_curve = void function(nk_draw_list*, nk_vec2 p0, nk_vec2 cp0, nk_vec2 cp1, nk_vec2 p1, nk_color, uint segments, float thickness);
        alias pnk_draw_list_stroke_poly_line = void function(nk_draw_list*, const(nk_vec2)* pnts, const(uint) cnt, nk_color, nk_draw_list_stroke, float thickness, nk_anti_aliasing);
        alias pnk_draw_list_fill_rect = void function(nk_draw_list*, nk_rect rect, nk_color, float rounding);
        alias pnk_draw_list_fill_rect_multi_color = void function(nk_draw_list*, nk_rect rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
        alias pnk_draw_list_fill_triangle = void function(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color);
        alias pnk_draw_list_fill_circle = void function(nk_draw_list*, nk_vec2 center, float radius, nk_color col, uint segs);
        alias pnk_draw_list_fill_poly_convex = void function(nk_draw_list*, const(nk_vec2)* points, const(uint) count, nk_color, nk_anti_aliasing);
        alias pnk_draw_list_add_image = void function(nk_draw_list*, nk_image texture, nk_rect rect, nk_color);
        alias pnk_draw_list_add_text = void function(nk_draw_list*, const(nk_user_font)*, nk_rect, const(char)* text, int len, float font_height, nk_color);
        version(NK_INCLUDE_COMMAND_USERDATA) {
            alias pnk_draw_list_push_userdata = void function(nk_draw_list*, nk_handle userdata);
        }
    }
    alias pnk_style_item_image = nk_style_item function(nk_image img);
    alias pnk_style_item_color = nk_style_item function(nk_color);
    alias pnk_style_item_hide = nk_style_item function();

    __gshared {
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            pnk_init_default nk_init_default;
        }
        pnk_init_fixed nk_init_fixed;
        pnk_init nk_init;
        pnk_init_custom nk_init_custom;
        pnk_clear nk_clear;
        pnk_free nk_free;
        version(NK_INCLUDE_COMMAND_USERDATA) {
            pnk_set_user_data nk_set_user_data;
        }
        pnk_input_begin nk_input_begin;
        pnk_input_motion nk_input_motion;
        pnk_input_key nk_input_key;
        pnk_input_button nk_input_button;
        pnk_input_scroll nk_input_scroll;
        pnk_input_char nk_input_char;
        pnk_input_glyph nk_input_glyph;
        pnk_input_unicode nk_input_unicode;
        pnk_input_end nk_input_end;
        pnk__begin nk__begin;
        pnk__next nk__next;
        version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
            pnk_convert nk_convert;
            pnk__draw_begin nk__draw_begin;
            pnk__draw_end nk__draw_end;
            pnk__draw_next nk__draw_next;
        }
        pnk_begin nk_begin;
        pnk_begin_titled nk_begin_titled;
        pnk_end nk_end;
        pnk_window_find nk_window_find;
        pnk_window_get_bounds nk_window_get_bounds;
        pnk_window_get_position nk_window_get_position;
        pnk_window_get_size nk_window_get_size;
        pnk_window_get_width nk_window_get_width;
        pnk_window_get_height nk_window_get_height;
        pnk_window_get_panel nk_window_get_panel;
        pnk_window_get_content_region nk_window_get_content_region;
        pnk_window_get_content_region_min nk_window_get_content_region_min;
        pnk_window_get_content_region_max nk_window_get_content_region_max;
        pnk_window_get_content_region_size nk_window_get_content_region_size;
        pnk_window_get_canvas nk_window_get_canvas;
        pnk_window_get_scroll nk_window_get_scroll; // 4.01.0
        pnk_window_has_focus nk_window_has_focus;
        pnk_window_is_hovered nk_window_is_hovered;
        pnk_window_is_collapsed nk_window_is_collapsed;
        pnk_window_is_closed nk_window_is_closed;
        pnk_window_is_hidden nk_window_is_hidden;
        pnk_window_is_active nk_window_is_active;
        pnk_window_is_any_hovered nk_window_is_any_hovered;
        pnk_item_is_any_active nk_item_is_any_active;
        pnk_window_set_bounds nk_window_set_bounds;
        pnk_window_set_position nk_window_set_position;
        pnk_window_set_size nk_window_set_size;
        pnk_window_set_focus nk_window_set_focus;
        pnk_window_set_scroll nk_window_set_scroll; // 4.01.0
        pnk_window_close nk_window_close;
        pnk_window_collapse nk_window_collapse;
        pnk_window_collapse_if nk_window_collapse_if;
        pnk_window_show nk_window_show;
        pnk_window_show_if nk_window_show_if;
        pnk_layout_set_min_row_height nk_layout_set_min_row_height;
        pnk_layout_reset_min_row_height nk_layout_reset_min_row_height;
        pnk_layout_widget_bounds nk_layout_widget_bounds;
        pnk_layout_ratio_from_pixel nk_layout_ratio_from_pixel;
        pnk_layout_row_dynamic nk_layout_row_dynamic;
        pnk_layout_row_static nk_layout_row_static;
        pnk_layout_row_begin nk_layout_row_begin;
        pnk_layout_row_push nk_layout_row_push;
        pnk_layout_row_end nk_layout_row_end;
        pnk_layout_row nk_layout_row;
        pnk_layout_row_template_begin nk_layout_row_template_begin;
        pnk_layout_row_template_push_dynamic nk_layout_row_template_push_dynamic;
        pnk_layout_row_template_push_variable nk_layout_row_template_push_variable;
        pnk_layout_row_template_push_static nk_layout_row_template_push_static;
        pnk_layout_row_template_end nk_layout_row_template_end;
        pnk_layout_space_begin nk_layout_space_begin;
        pnk_layout_space_push nk_layout_space_push;
        pnk_layout_space_end nk_layout_space_end;
        pnk_layout_space_bounds nk_layout_space_bounds;
        pnk_layout_space_to_screen nk_layout_space_to_screen;
        pnk_layout_space_to_local nk_layout_space_to_local;
        pnk_layout_space_rect_to_screen nk_layout_space_rect_to_screen;
        pnk_layout_space_rect_to_local nk_layout_space_rect_to_local;
        pnk_group_begin nk_group_begin;
        pnk_group_begin_titled nk_group_begin_titled;
        pnk_group_end nk_group_end;
        pnk_group_scrolled_offset_begin nk_group_scrolled_offset_begin;
        pnk_group_scrolled_begin nk_group_scrolled_begin;
        pnk_group_scrolled_end nk_group_scrolled_end;
        pnk_group_get_scroll nk_group_get_scroll; // 4.01.0
        pnk_group_set_scroll nk_group_set_scroll; // 4.01.0
        pnk_tree_push_hashed nk_tree_push_hashed;
        pnk_tree_image_push_hashed nk_tree_image_push_hashed;
        pnk_tree_pop nk_tree_pop;
        pnk_tree_state_push nk_tree_state_push;
        pnk_tree_state_image_push nk_tree_state_image_push;
        pnk_tree_state_pop nk_tree_state_pop;
        pnk_tree_element_push_hashed nk_tree_element_push_hashed;
        pnk_tree_element_image_push_hashed nk_tree_element_image_push_hashed;
        pnk_tree_element_pop nk_tree_element_pop;
        pnk_list_view_begin nk_list_view_begin;
        pnk_list_view_end nk_list_view_end;
        pnk_widget nk_widget;
        pnk_widget_fitting nk_widget_fitting;
        pnk_widget_bounds nk_widget_bounds;
        pnk_widget_position nk_widget_position;
        pnk_widget_size nk_widget_size;
        pnk_widget_width nk_widget_width;
        pnk_widget_height nk_widget_height;
        pnk_widget_is_hovered nk_widget_is_hovered;
        pnk_widget_is_mouse_clicked nk_widget_is_mouse_clicked;
        pnk_widget_has_mouse_click_down nk_widget_has_mouse_click_down;
        pnk_spacing nk_spacing;
        pnk_text nk_text;
        pnk_text_colored nk_text_colored;
        pnk_text_wrap nk_text_wrap;
        pnk_text_wrap_colored nk_text_wrap_colored;
        pnk_label nk_label;
        pnk_label_colored nk_label_colored;
        pnk_label_wrap nk_label_wrap;
        pnk_label_colored_wrap nk_label_colored_wrap;
        pnk_image nk_image_;
        pnk_image_color nk_image_color;
        version(NK_INCLUDE_STANDARD_VARARGS) {
            pnk_labelf nk_labelf;
            pnk_labelf_colored nk_labelf_colored;
            pnk_labelf_wrap nk_labelf_wrap;
            pnk_labelf_colored_wrap nk_labelf_colored_wrap;
            pnk_labelfv nk_labelfv;
            pnk_labelfv_colored nk_labelfv_colored;
            pnk_labelfv_wrap nk_labelfv_wrap;
            pnk_labelfv_colored_wrap nk_labelfv_colored_wrap;
            pnk_value_bool nk_value_bool;
            pnk_value_int nk_value_int;
            pnk_value_uint nk_value_uint;
            pnk_value_float nk_value_float;
            pnk_value_color_byte nk_value_color_byte;
            pnk_value_color_float nk_value_color_float;
            pnk_value_color_hex nk_value_color_hex;
        }
        pnk_button_text nk_button_text;
        pnk_button_label nk_button_label;
        pnk_button_color nk_button_color;
        pnk_button_symbol nk_button_symbol;
        pnk_button_image nk_button_image;
        pnk_button_symbol_label nk_button_symbol_label;
        pnk_button_symbol_text nk_button_symbol_text;
        pnk_button_image_label nk_button_image_label;
        pnk_button_image_text nk_button_image_text;
        pnk_button_text_styled nk_button_text_styled;
        pnk_button_label_styled nk_button_label_styled;
        pnk_button_symbol_styled nk_button_symbol_styled;
        pnk_button_image_styled nk_button_image_styled;
        pnk_button_symbol_text_styled nk_button_symbol_text_styled;
        pnk_button_symbol_label_styled nk_button_symbol_label_styled;
        pnk_button_image_label_styled nk_button_image_label_styled;
        pnk_button_image_text_styled nk_button_image_text_styled;
        pnk_button_set_behavior nk_button_set_behavior;
        pnk_button_push_behavior nk_button_push_behavior;
        pnk_button_pop_behavior nk_button_pop_behavior;
        pnk_check_label nk_check_label;
        pnk_check_text nk_check_text;
        pnk_check_flags_label nk_check_flags_label;
        pnk_check_flags_text nk_check_flags_text;
        pnk_checkbox_label nk_checkbox_label;
        pnk_checkbox_text nk_checkbox_text;
        pnk_checkbox_flags_label nk_checkbox_flags_label;
        pnk_checkbox_flags_text nk_checkbox_flags_text;
        pnk_radio_label nk_radio_label;
        pnk_radio_text nk_radio_text;
        pnk_option_label nk_option_label;
        pnk_option_text nk_option_text;
        pnk_selectable_label nk_selectable_label;
        pnk_selectable_text nk_selectable_text;
        pnk_selectable_image_label nk_selectable_image_label;
        pnk_selectable_image_text nk_selectable_image_text;
        pnk_selectable_symbol_label nk_selectable_symbol_label;
        pnk_selectable_symbol_text nk_selectable_symbol_text;
        pnk_select_label nk_select_label;
        pnk_select_text nk_select_text;
        pnk_select_image_label nk_select_image_label;
        pnk_select_image_text nk_select_image_text;
        pnk_select_symbol_label nk_select_symbol_label;
        pnk_select_symbol_text nk_select_symbol_text;
        pnk_slide_float nk_slide_float;
        pnk_slide_int nk_slide_int;
        pnk_slider_float nk_slider_float;
        pnk_slider_int nk_slider_int;
        pnk_progress nk_progress;
        pnk_prog nk_prog;
        pnk_color_picker nk_color_picker;
        pnk_color_pick nk_color_pick;
        pnk_property_int nk_property_int;
        pnk_property_float nk_property_float;
        pnk_property_double nk_property_double;
        pnk_propertyi nk_propertyi;
        pnk_propertyf nk_propertyf;
        pnk_propertyd nk_propertyd;
        pnk_edit_string nk_edit_string;
        pnk_edit_string_zero_terminated nk_edit_string_zero_terminated;
        pnk_edit_buffer nk_edit_buffer;
        pnk_edit_focus nk_edit_focus;
        pnk_edit_unfocus nk_edit_unfocus;
        pnk_chart_begin nk_chart_begin;
        pnk_chart_begin_colored nk_chart_begin_colored;
        pnk_chart_add_slot nk_chart_add_slot;
        pnk_chart_add_slot_colored nk_chart_add_slot_colored;
        pnk_chart_push nk_chart_push;
        pnk_chart_push_slot nk_chart_push_slot;
        pnk_chart_end nk_chart_end;
        pnk_plot nk_plot;
        pnk_plot_function nk_plot_function;
        pnk_popup_begin nk_popup_begin;
        pnk_popup_close nk_popup_close;
        pnk_popup_end nk_popup_end;
        pnk_popup_get_scroll nk_popup_get_scroll; // 4.01.0
        pnk_popup_set_scroll nk_popup_set_scroll; // 4.01.0
        pnk_combo nk_combo;
        pnk_combo_separator nk_combo_separator;
        pnk_combo_string nk_combo_string;
        pnk_combo_callback nk_combo_callback;
        pnk_combobox nk_combobox;
        pnk_combobox_string nk_combobox_string;
        pnk_combobox_separator nk_combobox_separator;
        pnk_combobox_callback nk_combobox_callback;
        pnk_combo_begin_text nk_combo_begin_text;
        pnk_combo_begin_label nk_combo_begin_label;
        pnk_combo_begin_color nk_combo_begin_color;
        pnk_combo_begin_symbol nk_combo_begin_symbol;
        pnk_combo_begin_symbol_label nk_combo_begin_symbol_label;
        pnk_combo_begin_symbol_text nk_combo_begin_symbol_text;
        pnk_combo_begin_image nk_combo_begin_image;
        pnk_combo_begin_image_label nk_combo_begin_image_label;
        pnk_combo_begin_image_text nk_combo_begin_image_text;
        pnk_combo_item_label nk_combo_item_label;
        pnk_combo_item_text nk_combo_item_text;
        pnk_combo_item_image_label nk_combo_item_image_label;
        pnk_combo_item_image_text nk_combo_item_image_text;
        pnk_combo_item_symbol_label nk_combo_item_symbol_label;
        pnk_combo_item_symbol_text nk_combo_item_symbol_text;
        pnk_combo_close nk_combo_close;
        pnk_combo_end nk_combo_end;
        pnk_contextual_begin nk_contextual_begin;
        pnk_contextual_item_text nk_contextual_item_text;
        pnk_contextual_item_label nk_contextual_item_label;
        pnk_contextual_item_image_label nk_contextual_item_image_label;
        pnk_contextual_item_image_text nk_contextual_item_image_text;
        pnk_contextual_item_symbol_label nk_contextual_item_symbol_label;
        pnk_contextual_item_symbol_text nk_contextual_item_symbol_text;
        pnk_contextual_close nk_contextual_close;
        pnk_contextual_end nk_contextual_end;
        pnk_tooltip nk_tooltip;
        version(NK_INCLUDE_STANDARD_VARARGS) {
            pnk_tooltipf nk_tooltipf;
            pnk_tooltipfv nk_tooltipfv;
        }
        pnk_tooltip_begin nk_tooltip_begin;
        pnk_tooltip_end nk_tooltip_end;
        pnk_menubar_begin nk_menubar_begin;
        pnk_menubar_end nk_menubar_end;
        pnk_menu_begin_text nk_menu_begin_text;
        pnk_menu_begin_label nk_menu_begin_label;
        pnk_menu_begin_image nk_menu_begin_image;
        pnk_menu_begin_image_text nk_menu_begin_image_text;
        pnk_menu_begin_image_label nk_menu_begin_image_label;
        pnk_menu_begin_symbol nk_menu_begin_symbol;
        pnk_menu_begin_symbol_text nk_menu_begin_symbol_text;
        pnk_menu_begin_symbol_label nk_menu_begin_symbol_label;
        pnk_menu_item_text nk_menu_item_text;
        pnk_menu_item_label nk_menu_item_label;
        pnk_menu_item_image_label nk_menu_item_image_label;
        pnk_menu_item_image_text nk_menu_item_image_text;
        pnk_menu_item_symbol_text nk_menu_item_symbol_text;
        pnk_menu_item_symbol_label nk_menu_item_symbol_label;
        pnk_menu_close nk_menu_close;
        pnk_menu_end nk_menu_end;
        pnk_style_default nk_style_default;
        pnk_style_from_table nk_style_from_table;
        pnk_style_load_cursor nk_style_load_cursor;
        pnk_style_load_all_cursors nk_style_load_all_cursors;
        pnk_style_get_color_by_name nk_style_get_color_by_name;
        pnk_style_set_font nk_style_set_font;
        pnk_style_set_cursor nk_style_set_cursor;
        pnk_style_show_cursor nk_style_show_cursor;
        pnk_style_hide_cursor nk_style_hide_cursor;
        pnk_style_push_font nk_style_push_font;
        pnk_style_push_float nk_style_push_float;
        pnk_style_push_vec2 nk_style_push_vec2;
        pnk_style_push_style_item nk_style_push_style_item;
        pnk_style_push_flags nk_style_push_flags;
        pnk_style_push_color nk_style_push_color;
        pnk_style_pop_font nk_style_pop_font;
        pnk_style_pop_float nk_style_pop_float;
        pnk_style_pop_vec2 nk_style_pop_vec2;
        pnk_style_pop_style_item nk_style_pop_style_item;
        pnk_style_pop_flags nk_style_pop_flags;
        pnk_style_pop_color nk_style_pop_color;
        pnk_rgb nk_rgb;
        pnk_rgb_iv nk_rgb_iv;
        pnk_rgb_bv nk_rgb_bv;
        pnk_rgb_f nk_rgb_f;
        pnk_rgb_fv nk_rgb_fv;
        pnk_rgb_cf nk_rgb_cf;
        pnk_rgb_hex nk_rgb_hex;
        pnk_rgba nk_rgba;
        pnk_rgba_u32 nk_rgba_u32;
        pnk_rgba_iv nk_rgba_iv;
        pnk_rgba_bv nk_rgba_bv;
        pnk_rgba_f nk_rgba_f;
        pnk_rgba_fv nk_rgba_fv;
        pnk_rgba_cf nk_rgba_cf;
        pnk_rgba_hex nk_rgba_hex;
        pnk_hsva_colorf nk_hsva_colorf;
        pnk_hsva_colorfv nk_hsva_colorfv;
        pnk_colorf_hsva_f nk_colorf_hsva_f;
        pnk_colorf_hsva_fv nk_colorf_hsva_fv;
        pnk_hsv nk_hsv;
        pnk_hsv_iv nk_hsv_iv;
        pnk_hsv_bv nk_hsv_bv;
        pnk_hsv_f nk_hsv_f;
        pnk_hsv_fv nk_hsv_fv;
        pnk_hsva nk_hsva;
        pnk_hsva_iv nk_hsva_iv;
        pnk_hsva_bv nk_hsva_bv;
        pnk_hsva_f nk_hsva_f;
        pnk_hsva_fv nk_hsva_fv;
        pnk_color_f nk_color_f;
        pnk_color_fv nk_color_fv;
        pnk_color_cf nk_color_cf;
        pnk_color_d nk_color_d;
        pnk_color_dv nk_color_dv;
        pnk_color_u32 nk_color_u32;
        pnk_color_hex_rgba nk_color_hex_rgba;
        pnk_color_hex_rgb nk_color_hex_rgb;
        pnk_color_hsv_i nk_color_hsv_i;
        pnk_color_hsv_b nk_color_hsv_b;
        pnk_color_hsv_iv nk_color_hsv_iv;
        pnk_color_hsv_bv nk_color_hsv_bv;
        pnk_color_hsv_f nk_color_hsv_f;
        pnk_color_hsv_fv nk_color_hsv_fv;
        pnk_color_hsva_i nk_color_hsva_i;
        pnk_color_hsva_b nk_color_hsva_b;
        pnk_color_hsva_iv nk_color_hsva_iv;
        pnk_color_hsva_bv nk_color_hsva_bv;
        pnk_color_hsva_f nk_color_hsva_f;
        pnk_color_hsva_fv nk_color_hsva_fv;
        pnk_handle_ptr nk_handle_ptr;
        pnk_handle_id nk_handle_id;
        pnk_image_handle nk_image_handle;
        pnk_image_ptr nk_image_ptr;
        pnk_image_id nk_image_id;
        pnk_image_is_subimage nk_image_is_subimage;
        pnk_subimage_ptr nk_subimage_ptr;
        pnk_subimage_id nk_subimage_id;
        pnk_subimage_handle nk_subimage_handle;
        pnk_murmur_hash nk_murmur_hash;
        pnk_triangle_from_direction nk_triangle_from_direction;
        pnk_vec2 nk_vec2_;
        pnk_vec2i nk_vec2i_;
        pnk_vec2v nk_vec2v;
        pnk_vec2iv nk_vec2iv;
        pnk_get_null_rect nk_get_null_rect;
        pnk_rect nk_rect_;
        pnk_recti nk_recti;
        pnk_recta nk_recta;
        pnk_rectv nk_rectv;
        pnk_rectiv nk_rectiv;
        pnk_rect_pos nk_rect_pos;
        pnk_rect_size nk_rect_size;
        pnk_strlen nk_strlen;
        pnk_stricmp nk_stricmp;
        pnk_stricmpn nk_stricmpn;
        pnk_strtoi nk_strtoi;
        pnk_strtof nk_strtof;
        pnk_strtod nk_strtod;
        pnk_strfilter nk_strfilter;
        pnk_strmatch_fuzzy_string nk_strmatch_fuzzy_string;
        pnk_strmatch_fuzzy_text nk_strmatch_fuzzy_text;
        pnk_utf_decode nk_utf_decode;
        pnk_utf_encode nk_utf_encode;
        pnk_utf_len nk_utf_len;
        pnk_utf_at nk_utf_at;
        version(NK_INCLUDE_FONT_BAKING) {
            pnk_font_default_glyph_ranges nk_font_default_glyph_ranges;
            pnk_font_chinese_glyph_ranges nk_font_chinese_glyph_ranges;
            pnk_font_cyrillic_glyph_ranges nk_font_cyrillic_glyph_ranges;
            pnk_font_korean_glyph_ranges nk_font_korean_glyph_ranges;
            version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
                pnk_font_atlas_init_default nk_font_atlas_init_default;
            }
            pnk_font_atlas_init nk_font_atlas_init;
            pnk_font_atlas_init_custom nk_font_atlas_init_custom;
            pnk_font_atlas_begin nk_font_atlas_begin;
            pnk_font_config nk_font_config_;
            pnk_font_atlas_add nk_font_atlas_add;
            version(NK_INCLUDE_DEFAULT_FONT) {
                pnk_font_atlas_add_default nk_font_atlas_add_default;
            }
            pnk_font_atlas_add_from_memory nk_font_atlas_add_from_memory;
            version(NK_INCLUDE_STANDARD_IO) {
                pnk_font_atlas_add_from_file nk_font_atlas_add_from_file;
            }
            pnk_font_atlas_add_compressed nk_font_atlas_add_compressed;
            pnk_font_atlas_add_compressed_base85 nk_font_atlas_add_compressed_base85;
            pnk_font_atlas_bake nk_font_atlas_bake;
            pnk_font_atlas_end nk_font_atlas_end;
            pnk_font_find_glyph nk_font_find_glyph;
            pnk_font_atlas_cleanup nk_font_atlas_cleanup;
            pnk_font_atlas_clear nk_font_atlas_clear;
        }
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            pnk_buffer_init_default nk_buffer_init_default;
        }
        pnk_buffer_init nk_buffer_init;
        pnk_buffer_init_fixed nk_buffer_init_fixed;
        pnk_buffer_info nk_buffer_info;
        pnk_buffer_push nk_buffer_push;
        pnk_buffer_mark nk_buffer_mark;
        pnk_buffer_reset nk_buffer_reset;
        pnk_buffer_clear nk_buffer_clear;
        pnk_buffer_free nk_buffer_free;
        pnk_buffer_memory nk_buffer_memory;
        pnk_buffer_memory_const nk_buffer_memory_const;
        pnk_buffer_total nk_buffer_total;
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            pnk_str_init_default nk_str_init_default;
        }
        pnk_str_init nk_str_init;
        pnk_str_init_fixed nk_str_init_fixed;
        pnk_str_clear nk_str_clear;
        pnk_str_free nk_str_free;
        pnk_str_append_text_char nk_str_append_text_char;
        pnk_str_append_str_char nk_str_append_str_char;
        pnk_str_append_text_utf8 nk_str_append_text_utf8;
        pnk_str_append_str_utf8 nk_str_append_str_utf8;
        pnk_str_append_text_runes nk_str_append_text_runes;
        pnk_str_append_str_runes nk_str_append_str_runes;
        pnk_str_insert_at_char nk_str_insert_at_char;
        pnk_str_insert_at_rune nk_str_insert_at_rune;
        pnk_str_insert_text_char nk_str_insert_text_char;
        pnk_str_insert_str_char nk_str_insert_str_char;
        pnk_str_insert_text_utf8 nk_str_insert_text_utf8;
        pnk_str_insert_str_utf8 nk_str_insert_str_utf8;
        pnk_str_insert_text_runes nk_str_insert_text_runes;
        pnk_str_insert_str_runes nk_str_insert_str_runes;
        pnk_str_remove_chars nk_str_remove_chars;
        pnk_str_remove_runes nk_str_remove_runes;
        pnk_str_delete_chars nk_str_delete_chars;
        pnk_str_delete_runes nk_str_delete_runes;
        pnk_str_at_char nk_str_at_char;
        pnk_str_at_rune nk_str_at_rune;
        pnk_str_rune_at nk_str_rune_at;
        pnk_str_at_char_const nk_str_at_char_const;
        pnk_str_at_const nk_str_at_const;
        pnk_str_get nk_str_get;
        pnk_str_get_const nk_str_get_const;
        pnk_str_len nk_str_len;
        pnk_str_len_char nk_str_len_char;
        pnk_filter_default nk_filter_default_fptr;
        pnk_filter_ascii   nk_filter_ascii_fptr;
        pnk_filter_float   nk_filter_float_fptr;
        pnk_filter_decimal nk_filter_decimal_fptr;
        pnk_filter_hex     nk_filter_hex_fptr;
        pnk_filter_oct     nk_filter_oct_fptr;
        pnk_filter_binary  nk_filter_binary_fptr;

        int nk_filter_default(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_default_fptr(e, unicode);
        }

        int nk_filter_ascii(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_ascii_fptr(e, unicode);
        }

        int nk_filter_float(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_float_fptr(e, unicode);
        }

        int nk_filter_decimal(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_decimal_fptr(e, unicode);
        }

        int nk_filter_hex(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_hex_fptr(e, unicode);
        }

        int nk_filter_oct(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_oct_fptr(e, unicode);
        }

        int nk_filter_binary(const(nk_text_edit)* e, nk_rune unicode)
        {
            return nk_filter_binary_fptr(e, unicode);
        }

        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            pnk_textedit_init_default nk_textedit_init_default;
        }
        pnk_textedit_init nk_textedit_init;
        pnk_textedit_init_fixed nk_textedit_init_fixed;
        pnk_textedit_free nk_textedit_free;
        pnk_textedit_text nk_textedit_text;
        pnk_textedit_delete nk_textedit_delete;
        pnk_textedit_delete_selection nk_textedit_delete_selection;
        pnk_textedit_select_all nk_textedit_select_all;
        pnk_textedit_cut nk_textedit_cut;
        pnk_textedit_paste nk_textedit_paste;
        pnk_textedit_undo nk_textedit_undo;
        pnk_textedit_redo nk_textedit_redo;
        pnk_stroke_line nk_stroke_line;
        pnk_stroke_curve nk_stroke_curve;
        pnk_stroke_rect nk_stroke_rect;
        pnk_stroke_circle nk_stroke_circle;
        pnk_stroke_arc nk_stroke_arc;
        pnk_stroke_triangle nk_stroke_triangle;
        pnk_stroke_polyline nk_stroke_polyline;
        pnk_stroke_polygon nk_stroke_polygon;
        pnk_fill_rect nk_fill_rect;
        pnk_fill_rect_multi_color nk_fill_rect_multi_color;
        pnk_fill_circle nk_fill_circle;
        pnk_fill_arc nk_fill_arc;
        pnk_fill_triangle nk_fill_triangle;
        pnk_fill_polygon nk_fill_polygon;
        pnk_draw_image nk_draw_image;
        pnk_draw_text nk_draw_text;
        pnk_push_scissor nk_push_scissor;
        pnk_push_custom nk_push_custom;
        pnk_input_has_mouse_click nk_input_has_mouse_click;
        pnk_input_has_mouse_click_in_rect nk_input_has_mouse_click_in_rect;
        pnk_input_has_mouse_click_down_in_rect nk_input_has_mouse_click_down_in_rect;
        pnk_input_is_mouse_click_in_rect nk_input_is_mouse_click_in_rect;
        pnk_input_is_mouse_click_down_in_rect nk_input_is_mouse_click_down_in_rect;
        pnk_input_any_mouse_click_in_rect nk_input_any_mouse_click_in_rect;
        pnk_input_is_mouse_prev_hovering_rect nk_input_is_mouse_prev_hovering_rect;
        pnk_input_is_mouse_hovering_rect nk_input_is_mouse_hovering_rect;
        pnk_input_mouse_clicked nk_input_mouse_clicked;
        pnk_input_is_mouse_down nk_input_is_mouse_down;
        pnk_input_is_mouse_pressed nk_input_is_mouse_pressed;
        pnk_input_is_mouse_released nk_input_is_mouse_released;
        pnk_input_is_key_pressed nk_input_is_key_pressed;
        pnk_input_is_key_released nk_input_is_key_released;
        pnk_input_is_key_down nk_input_is_key_down;
        version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
            pnk_draw_list_init nk_draw_list_init;
            pnk_draw_list_setup nk_draw_list_setup;
            pnk__draw_list_begin nk__draw_list_begin;
            pnk__draw_list_next nk__draw_list_next;
            pnk__draw_list_end nk__draw_list_end;
            pnk_draw_list_path_clear nk_draw_list_path_clear;
            pnk_draw_list_path_line_to nk_draw_list_path_line_to;
            pnk_draw_list_path_arc_to_fast nk_draw_list_path_arc_to_fast;
            pnk_draw_list_path_arc_to nk_draw_list_path_arc_to;
            pnk_draw_list_path_rect_to nk_draw_list_path_rect_to;
            pnk_draw_list_path_curve_to nk_draw_list_path_curve_to;
            pnk_draw_list_path_fill nk_draw_list_path_fill;
            pnk_draw_list_path_stroke nk_draw_list_path_stroke;
            pnk_draw_list_stroke_line nk_draw_list_stroke_line;
            pnk_draw_list_stroke_rect nk_draw_list_stroke_rect;
            pnk_draw_list_stroke_triangle nk_draw_list_stroke_triangle;
            pnk_draw_list_stroke_circle nk_draw_list_stroke_circle;
            pnk_draw_list_stroke_curve nk_draw_list_stroke_curve;
            pnk_draw_list_stroke_poly_line nk_draw_list_stroke_poly_line;
            pnk_draw_list_fill_rect nk_draw_list_fill_rect;
            pnk_draw_list_fill_rect_multi_color nk_draw_list_fill_rect_multi_color;
            pnk_draw_list_fill_triangle nk_draw_list_fill_triangle;
            pnk_draw_list_fill_circle nk_draw_list_fill_circle;
            pnk_draw_list_fill_poly_convex nk_draw_list_fill_poly_convex;
            pnk_draw_list_add_image nk_draw_list_add_image;
            pnk_draw_list_add_text nk_draw_list_add_text;
            version(NK_INCLUDE_COMMAND_USERDATA) {
                pnk_draw_list_push_userdata nk_draw_list_push_userdata;
            }
        }
        pnk_style_item_image nk_style_item_image;
        pnk_style_item_color nk_style_item_color;
        pnk_style_item_hide nk_style_item_hide;
    }
}
private {
    SharedLib lib;
    NuklearSupport loadedVersion;
}

void unloadNuklear()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

NuklearSupport loadedNuklearVersion() { return loadedVersion; }
bool isNuklearLoaded() { return lib != invalidHandle; }

NuklearSupport loadNuklear()
{
    version(Windows) {
        const(char)[][1] libNames = ["nuklear.dll"];
    }
    else version(OSX) {
        const(char)[][1] libNames = ["nuklear.dylib"];
    }
    else version(Posix) {
        const(char)[][2] libNames = [
            "nuklear.so",
            "/usr/local/lib/nuklear.so",
        ];
    }
    else static assert(0, "bindbc-nuklear is not yet supported on this platform.");

    NuklearSupport ret;
    foreach(name; libNames) {
        ret = loadNuklear(name.ptr);
        if(ret != NuklearSupport.noLibrary) break;
    }
    return ret;
}

NuklearSupport loadNuklear(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle) {
        return NuklearSupport.noLibrary;
    }

    auto errCount = errorCount();
    loadedVersion = NuklearSupport.badLibrary;

    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        lib.bindSymbol(cast(void**)&nk_init_default,"nk_init_default");
    }
    lib.bindSymbol(cast(void**)&nk_init_fixed,"nk_init_fixed");
    lib.bindSymbol(cast(void**)&nk_init,"nk_init");
    lib.bindSymbol(cast(void**)&nk_init_custom,"nk_init_custom");
    lib.bindSymbol(cast(void**)&nk_clear,"nk_clear");
    lib.bindSymbol(cast(void**)&nk_free,"nk_free");
    version(NK_INCLUDE_COMMAND_USERDATA) {
        lib.bindSymbol(cast(void**)&nk_set_user_data,"nk_set_user_data");
    }
    lib.bindSymbol(cast(void**)&nk_input_begin,"nk_input_begin");
    lib.bindSymbol(cast(void**)&nk_input_motion,"nk_input_motion");
    lib.bindSymbol(cast(void**)&nk_input_key,"nk_input_key");
    lib.bindSymbol(cast(void**)&nk_input_button,"nk_input_button");
    lib.bindSymbol(cast(void**)&nk_input_scroll,"nk_input_scroll");
    lib.bindSymbol(cast(void**)&nk_input_char,"nk_input_char");
    lib.bindSymbol(cast(void**)&nk_input_glyph,"nk_input_glyph");
    lib.bindSymbol(cast(void**)&nk_input_unicode,"nk_input_unicode");
    lib.bindSymbol(cast(void**)&nk_input_end,"nk_input_end");
    lib.bindSymbol(cast(void**)&nk__begin,"nk__begin");
    lib.bindSymbol(cast(void**)&nk__next,"nk__next");
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        lib.bindSymbol(cast(void**)&nk_convert,"nk_convert");
        lib.bindSymbol(cast(void**)&nk__draw_begin,"nk__draw_begin");
        lib.bindSymbol(cast(void**)&nk__draw_end,"nk__draw_end");
        lib.bindSymbol(cast(void**)&nk__draw_next,"nk__draw_next");
    }
    lib.bindSymbol(cast(void**)&nk_begin,"nk_begin");
    lib.bindSymbol(cast(void**)&nk_begin_titled,"nk_begin_titled");
    lib.bindSymbol(cast(void**)&nk_end,"nk_end");
    lib.bindSymbol(cast(void**)&nk_window_find,"nk_window_find");
    lib.bindSymbol(cast(void**)&nk_window_get_bounds,"nk_window_get_bounds");
    lib.bindSymbol(cast(void**)&nk_window_get_position,"nk_window_get_position");
    lib.bindSymbol(cast(void**)&nk_window_get_size,"nk_window_get_size");
    lib.bindSymbol(cast(void**)&nk_window_get_width,"nk_window_get_width");
    lib.bindSymbol(cast(void**)&nk_window_get_height,"nk_window_get_height");
    lib.bindSymbol(cast(void**)&nk_window_get_panel,"nk_window_get_panel");
    lib.bindSymbol(cast(void**)&nk_window_get_content_region,"nk_window_get_content_region");
    lib.bindSymbol(cast(void**)&nk_window_get_content_region_min,"nk_window_get_content_region_min");
    lib.bindSymbol(cast(void**)&nk_window_get_content_region_max,"nk_window_get_content_region_max");
    lib.bindSymbol(cast(void**)&nk_window_get_content_region_size,"nk_window_get_content_region_size");
    lib.bindSymbol(cast(void**)&nk_window_get_canvas,"nk_window_get_canvas");
    lib.bindSymbol(cast(void**)&nk_window_get_scroll,"nk_window_get_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_window_has_focus,"nk_window_has_focus");
    lib.bindSymbol(cast(void**)&nk_window_is_hovered,"nk_window_is_hovered");
    lib.bindSymbol(cast(void**)&nk_window_is_collapsed,"nk_window_is_collapsed");
    lib.bindSymbol(cast(void**)&nk_window_is_closed,"nk_window_is_closed");
    lib.bindSymbol(cast(void**)&nk_window_is_hidden,"nk_window_is_hidden");
    lib.bindSymbol(cast(void**)&nk_window_is_active,"nk_window_is_active");
    lib.bindSymbol(cast(void**)&nk_window_is_any_hovered,"nk_window_is_any_hovered");
    lib.bindSymbol(cast(void**)&nk_item_is_any_active,"nk_item_is_any_active");
    lib.bindSymbol(cast(void**)&nk_window_set_bounds,"nk_window_set_bounds");
    lib.bindSymbol(cast(void**)&nk_window_set_position,"nk_window_set_position");
    lib.bindSymbol(cast(void**)&nk_window_set_size,"nk_window_set_size");
    lib.bindSymbol(cast(void**)&nk_window_set_focus,"nk_window_set_focus");
    lib.bindSymbol(cast(void**)&nk_window_set_scroll,"nk_window_set_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_window_close,"nk_window_close");
    lib.bindSymbol(cast(void**)&nk_window_collapse,"nk_window_collapse");
    lib.bindSymbol(cast(void**)&nk_window_collapse_if,"nk_window_collapse_if");
    lib.bindSymbol(cast(void**)&nk_window_show,"nk_window_show");
    lib.bindSymbol(cast(void**)&nk_window_show_if,"nk_window_show_if");
    lib.bindSymbol(cast(void**)&nk_layout_set_min_row_height,"nk_layout_set_min_row_height");
    lib.bindSymbol(cast(void**)&nk_layout_reset_min_row_height,"nk_layout_reset_min_row_height");
    lib.bindSymbol(cast(void**)&nk_layout_widget_bounds,"nk_layout_widget_bounds");
    lib.bindSymbol(cast(void**)&nk_layout_ratio_from_pixel,"nk_layout_ratio_from_pixel");
    lib.bindSymbol(cast(void**)&nk_layout_row_dynamic,"nk_layout_row_dynamic");
    lib.bindSymbol(cast(void**)&nk_layout_row_static,"nk_layout_row_static");
    lib.bindSymbol(cast(void**)&nk_layout_row_begin,"nk_layout_row_begin");
    lib.bindSymbol(cast(void**)&nk_layout_row_push,"nk_layout_row_push");
    lib.bindSymbol(cast(void**)&nk_layout_row_end,"nk_layout_row_end");
    lib.bindSymbol(cast(void**)&nk_layout_row,"nk_layout_row");
    lib.bindSymbol(cast(void**)&nk_layout_row_template_begin,"nk_layout_row_template_begin");
    lib.bindSymbol(cast(void**)&nk_layout_row_template_push_dynamic,"nk_layout_row_template_push_dynamic");
    lib.bindSymbol(cast(void**)&nk_layout_row_template_push_variable,"nk_layout_row_template_push_variable");
    lib.bindSymbol(cast(void**)&nk_layout_row_template_push_static,"nk_layout_row_template_push_static");
    lib.bindSymbol(cast(void**)&nk_layout_row_template_end,"nk_layout_row_template_end");
    lib.bindSymbol(cast(void**)&nk_layout_space_begin,"nk_layout_space_begin");
    lib.bindSymbol(cast(void**)&nk_layout_space_push,"nk_layout_space_push");
    lib.bindSymbol(cast(void**)&nk_layout_space_end,"nk_layout_space_end");
    lib.bindSymbol(cast(void**)&nk_layout_space_bounds,"nk_layout_space_bounds");
    lib.bindSymbol(cast(void**)&nk_layout_space_to_screen,"nk_layout_space_to_screen");
    lib.bindSymbol(cast(void**)&nk_layout_space_to_local,"nk_layout_space_to_local");
    lib.bindSymbol(cast(void**)&nk_layout_space_rect_to_screen,"nk_layout_space_rect_to_screen");
    lib.bindSymbol(cast(void**)&nk_layout_space_rect_to_local,"nk_layout_space_rect_to_local");
    lib.bindSymbol(cast(void**)&nk_group_begin,"nk_group_begin");
    lib.bindSymbol(cast(void**)&nk_group_begin_titled,"nk_group_begin_titled");
    lib.bindSymbol(cast(void**)&nk_group_end,"nk_group_end");
    lib.bindSymbol(cast(void**)&nk_group_scrolled_offset_begin,"nk_group_scrolled_offset_begin");
    lib.bindSymbol(cast(void**)&nk_group_scrolled_begin,"nk_group_scrolled_begin");
    lib.bindSymbol(cast(void**)&nk_group_scrolled_end,"nk_group_scrolled_end");
    lib.bindSymbol(cast(void**)&nk_group_get_scroll,"nk_group_get_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_group_set_scroll,"nk_group_set_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_tree_push_hashed,"nk_tree_push_hashed");
    lib.bindSymbol(cast(void**)&nk_tree_image_push_hashed,"nk_tree_image_push_hashed");
    lib.bindSymbol(cast(void**)&nk_tree_pop,"nk_tree_pop");
    lib.bindSymbol(cast(void**)&nk_tree_state_push,"nk_tree_state_push");
    lib.bindSymbol(cast(void**)&nk_tree_state_image_push,"nk_tree_state_image_push");
    lib.bindSymbol(cast(void**)&nk_tree_state_pop,"nk_tree_state_pop");
    lib.bindSymbol(cast(void**)&nk_tree_element_push_hashed,"nk_tree_element_push_hashed");
    lib.bindSymbol(cast(void**)&nk_tree_element_image_push_hashed,"nk_tree_element_image_push_hashed");
    lib.bindSymbol(cast(void**)&nk_tree_element_pop,"nk_tree_element_pop");
    lib.bindSymbol(cast(void**)&nk_list_view_begin,"nk_list_view_begin");
    lib.bindSymbol(cast(void**)&nk_list_view_end,"nk_list_view_end");
    lib.bindSymbol(cast(void**)&nk_widget,"nk_widget");
    lib.bindSymbol(cast(void**)&nk_widget_fitting,"nk_widget_fitting");
    lib.bindSymbol(cast(void**)&nk_widget_bounds,"nk_widget_bounds");
    lib.bindSymbol(cast(void**)&nk_widget_position,"nk_widget_position");
    lib.bindSymbol(cast(void**)&nk_widget_size,"nk_widget_size");
    lib.bindSymbol(cast(void**)&nk_widget_width,"nk_widget_width");
    lib.bindSymbol(cast(void**)&nk_widget_height,"nk_widget_height");
    lib.bindSymbol(cast(void**)&nk_widget_is_hovered,"nk_widget_is_hovered");
    lib.bindSymbol(cast(void**)&nk_widget_is_mouse_clicked,"nk_widget_is_mouse_clicked");
    lib.bindSymbol(cast(void**)&nk_widget_has_mouse_click_down,"nk_widget_has_mouse_click_down");
    lib.bindSymbol(cast(void**)&nk_spacing,"nk_spacing");
    lib.bindSymbol(cast(void**)&nk_text,"nk_text");
    lib.bindSymbol(cast(void**)&nk_text_colored,"nk_text_colored");
    lib.bindSymbol(cast(void**)&nk_text_wrap,"nk_text_wrap");
    lib.bindSymbol(cast(void**)&nk_text_wrap_colored,"nk_text_wrap_colored");
    lib.bindSymbol(cast(void**)&nk_label,"nk_label");
    lib.bindSymbol(cast(void**)&nk_label_colored,"nk_label_colored");
    lib.bindSymbol(cast(void**)&nk_label_wrap,"nk_label_wrap");
    lib.bindSymbol(cast(void**)&nk_label_colored_wrap,"nk_label_colored_wrap");
    lib.bindSymbol(cast(void**)&nk_image_,"nk_image");
    lib.bindSymbol(cast(void**)&nk_image_color,"nk_image_color");
    version(NK_INCLUDE_STANDARD_VARARGS) {
        lib.bindSymbol(cast(void**)&nk_labelf,"nk_labelf");
        lib.bindSymbol(cast(void**)&nk_labelf_colored,"nk_labelf_colored");
        lib.bindSymbol(cast(void**)&nk_labelf_wrap,"nk_labelf_wrap");
        lib.bindSymbol(cast(void**)&nk_labelf_colored_wrap,"nk_labelf_colored_wrap");
        lib.bindSymbol(cast(void**)&nk_labelfv,"nk_labelfv");
        lib.bindSymbol(cast(void**)&nk_labelfv_colored,"nk_labelfv_colored");
        lib.bindSymbol(cast(void**)&nk_labelfv_wrap,"nk_labelfv_wrap");
        lib.bindSymbol(cast(void**)&nk_labelfv_colored_wrap,"nk_labelfv_colored_wrap");
        lib.bindSymbol(cast(void**)&nk_value_bool,"nk_value_bool");
        lib.bindSymbol(cast(void**)&nk_value_int,"nk_value_int");
        lib.bindSymbol(cast(void**)&nk_value_uint,"nk_value_uint");
        lib.bindSymbol(cast(void**)&nk_value_float,"nk_value_float");
        lib.bindSymbol(cast(void**)&nk_value_color_byte,"nk_value_color_byte");
        lib.bindSymbol(cast(void**)&nk_value_color_float,"nk_value_color_float");
        lib.bindSymbol(cast(void**)&nk_value_color_hex,"nk_value_color_hex");
    }
    lib.bindSymbol(cast(void**)&nk_button_text,"nk_button_text");
    lib.bindSymbol(cast(void**)&nk_button_label,"nk_button_label");
    lib.bindSymbol(cast(void**)&nk_button_color,"nk_button_color");
    lib.bindSymbol(cast(void**)&nk_button_symbol,"nk_button_symbol");
    lib.bindSymbol(cast(void**)&nk_button_image,"nk_button_image");
    lib.bindSymbol(cast(void**)&nk_button_symbol_label,"nk_button_symbol_label");
    lib.bindSymbol(cast(void**)&nk_button_symbol_text,"nk_button_symbol_text");
    lib.bindSymbol(cast(void**)&nk_button_image_label,"nk_button_image_label");
    lib.bindSymbol(cast(void**)&nk_button_image_text,"nk_button_image_text");
    lib.bindSymbol(cast(void**)&nk_button_text_styled,"nk_button_text_styled");
    lib.bindSymbol(cast(void**)&nk_button_label_styled,"nk_button_label_styled");
    lib.bindSymbol(cast(void**)&nk_button_symbol_styled,"nk_button_symbol_styled");
    lib.bindSymbol(cast(void**)&nk_button_image_styled,"nk_button_image_styled");
    lib.bindSymbol(cast(void**)&nk_button_symbol_text_styled,"nk_button_symbol_text_styled");
    lib.bindSymbol(cast(void**)&nk_button_symbol_label_styled,"nk_button_symbol_label_styled");
    lib.bindSymbol(cast(void**)&nk_button_image_label_styled,"nk_button_image_label_styled");
    lib.bindSymbol(cast(void**)&nk_button_image_text_styled,"nk_button_image_text_styled");
    lib.bindSymbol(cast(void**)&nk_button_set_behavior,"nk_button_set_behavior");
    lib.bindSymbol(cast(void**)&nk_button_push_behavior,"nk_button_push_behavior");
    lib.bindSymbol(cast(void**)&nk_button_pop_behavior,"nk_button_pop_behavior");
    lib.bindSymbol(cast(void**)&nk_check_label,"nk_check_label");
    lib.bindSymbol(cast(void**)&nk_check_text,"nk_check_text");
    lib.bindSymbol(cast(void**)&nk_check_flags_label,"nk_check_flags_label");
    lib.bindSymbol(cast(void**)&nk_check_flags_text,"nk_check_flags_text");
    lib.bindSymbol(cast(void**)&nk_checkbox_label,"nk_checkbox_label");
    lib.bindSymbol(cast(void**)&nk_checkbox_text,"nk_checkbox_text");
    lib.bindSymbol(cast(void**)&nk_checkbox_flags_label,"nk_checkbox_flags_label");
    lib.bindSymbol(cast(void**)&nk_checkbox_flags_text,"nk_checkbox_flags_text");
    lib.bindSymbol(cast(void**)&nk_radio_label,"nk_radio_label");
    lib.bindSymbol(cast(void**)&nk_radio_text,"nk_radio_text");
    lib.bindSymbol(cast(void**)&nk_option_label,"nk_option_label");
    lib.bindSymbol(cast(void**)&nk_option_text,"nk_option_text");
    lib.bindSymbol(cast(void**)&nk_selectable_label,"nk_selectable_label");
    lib.bindSymbol(cast(void**)&nk_selectable_text,"nk_selectable_text");
    lib.bindSymbol(cast(void**)&nk_selectable_image_label,"nk_selectable_image_label");
    lib.bindSymbol(cast(void**)&nk_selectable_image_text,"nk_selectable_image_text");
    lib.bindSymbol(cast(void**)&nk_selectable_symbol_label,"nk_selectable_symbol_label");
    lib.bindSymbol(cast(void**)&nk_selectable_symbol_text,"nk_selectable_symbol_text");
    lib.bindSymbol(cast(void**)&nk_select_label,"nk_select_label");
    lib.bindSymbol(cast(void**)&nk_select_text,"nk_select_text");
    lib.bindSymbol(cast(void**)&nk_select_image_label,"nk_select_image_label");
    lib.bindSymbol(cast(void**)&nk_select_image_text,"nk_select_image_text");
    lib.bindSymbol(cast(void**)&nk_select_symbol_label,"nk_select_symbol_label");
    lib.bindSymbol(cast(void**)&nk_select_symbol_text,"nk_select_symbol_text");
    lib.bindSymbol(cast(void**)&nk_slide_float,"nk_slide_float");
    lib.bindSymbol(cast(void**)&nk_slide_int,"nk_slide_int");
    lib.bindSymbol(cast(void**)&nk_slider_float,"nk_slider_float");
    lib.bindSymbol(cast(void**)&nk_slider_int,"nk_slider_int");
    lib.bindSymbol(cast(void**)&nk_progress,"nk_progress");
    lib.bindSymbol(cast(void**)&nk_prog,"nk_prog");
    lib.bindSymbol(cast(void**)&nk_color_picker,"nk_color_picker");
    lib.bindSymbol(cast(void**)&nk_color_pick,"nk_color_pick");
    lib.bindSymbol(cast(void**)&nk_property_int,"nk_property_int");
    lib.bindSymbol(cast(void**)&nk_property_float,"nk_property_float");
    lib.bindSymbol(cast(void**)&nk_property_double,"nk_property_double");
    lib.bindSymbol(cast(void**)&nk_propertyi,"nk_propertyi");
    lib.bindSymbol(cast(void**)&nk_propertyf,"nk_propertyf");
    lib.bindSymbol(cast(void**)&nk_propertyd,"nk_propertyd");
    lib.bindSymbol(cast(void**)&nk_edit_string,"nk_edit_string");
    lib.bindSymbol(cast(void**)&nk_edit_string_zero_terminated,"nk_edit_string_zero_terminated");
    lib.bindSymbol(cast(void**)&nk_edit_buffer,"nk_edit_buffer");
    lib.bindSymbol(cast(void**)&nk_edit_focus,"nk_edit_focus");
    lib.bindSymbol(cast(void**)&nk_edit_unfocus,"nk_edit_unfocus");
    lib.bindSymbol(cast(void**)&nk_chart_begin,"nk_chart_begin");
    lib.bindSymbol(cast(void**)&nk_chart_begin_colored,"nk_chart_begin_colored");
    lib.bindSymbol(cast(void**)&nk_chart_add_slot,"nk_chart_add_slot");
    lib.bindSymbol(cast(void**)&nk_chart_add_slot_colored,"nk_chart_add_slot_colored");
    lib.bindSymbol(cast(void**)&nk_chart_push,"nk_chart_push");
    lib.bindSymbol(cast(void**)&nk_chart_push_slot,"nk_chart_push_slot");
    lib.bindSymbol(cast(void**)&nk_chart_end,"nk_chart_end");
    lib.bindSymbol(cast(void**)&nk_plot,"nk_plot");
    lib.bindSymbol(cast(void**)&nk_plot_function,"nk_plot_function");
    lib.bindSymbol(cast(void**)&nk_popup_begin,"nk_popup_begin");
    lib.bindSymbol(cast(void**)&nk_popup_close,"nk_popup_close");
    lib.bindSymbol(cast(void**)&nk_popup_end,"nk_popup_end");
    lib.bindSymbol(cast(void**)&nk_popup_get_scroll,"nk_popup_get_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_popup_set_scroll,"nk_popup_set_scroll"); // 4.01.0
    lib.bindSymbol(cast(void**)&nk_combo,"nk_combo");
    lib.bindSymbol(cast(void**)&nk_combo_separator,"nk_combo_separator");
    lib.bindSymbol(cast(void**)&nk_combo_string,"nk_combo_string");
    lib.bindSymbol(cast(void**)&nk_combo_callback,"nk_combo_callback");
    lib.bindSymbol(cast(void**)&nk_combobox,"nk_combobox");
    lib.bindSymbol(cast(void**)&nk_combobox_string,"nk_combobox_string");
    lib.bindSymbol(cast(void**)&nk_combobox_separator,"nk_combobox_separator");
    lib.bindSymbol(cast(void**)&nk_combobox_callback,"nk_combobox_callback");
    lib.bindSymbol(cast(void**)&nk_combo_begin_text,"nk_combo_begin_text");
    lib.bindSymbol(cast(void**)&nk_combo_begin_label,"nk_combo_begin_label");
    lib.bindSymbol(cast(void**)&nk_combo_begin_color,"nk_combo_begin_color");
    lib.bindSymbol(cast(void**)&nk_combo_begin_symbol,"nk_combo_begin_symbol");
    lib.bindSymbol(cast(void**)&nk_combo_begin_symbol_label,"nk_combo_begin_symbol_label");
    lib.bindSymbol(cast(void**)&nk_combo_begin_symbol_text,"nk_combo_begin_symbol_text");
    lib.bindSymbol(cast(void**)&nk_combo_begin_image,"nk_combo_begin_image");
    lib.bindSymbol(cast(void**)&nk_combo_begin_image_label,"nk_combo_begin_image_label");
    lib.bindSymbol(cast(void**)&nk_combo_begin_image_text,"nk_combo_begin_image_text");
    lib.bindSymbol(cast(void**)&nk_combo_item_label,"nk_combo_item_label");
    lib.bindSymbol(cast(void**)&nk_combo_item_text,"nk_combo_item_text");
    lib.bindSymbol(cast(void**)&nk_combo_item_image_label,"nk_combo_item_image_label");
    lib.bindSymbol(cast(void**)&nk_combo_item_image_text,"nk_combo_item_image_text");
    lib.bindSymbol(cast(void**)&nk_combo_item_symbol_label,"nk_combo_item_symbol_label");
    lib.bindSymbol(cast(void**)&nk_combo_item_symbol_text,"nk_combo_item_symbol_text");
    lib.bindSymbol(cast(void**)&nk_combo_close,"nk_combo_close");
    lib.bindSymbol(cast(void**)&nk_combo_end,"nk_combo_end");
    lib.bindSymbol(cast(void**)&nk_contextual_begin,"nk_contextual_begin");
    lib.bindSymbol(cast(void**)&nk_contextual_item_text,"nk_contextual_item_text");
    lib.bindSymbol(cast(void**)&nk_contextual_item_label,"nk_contextual_item_label");
    lib.bindSymbol(cast(void**)&nk_contextual_item_image_label,"nk_contextual_item_image_label");
    lib.bindSymbol(cast(void**)&nk_contextual_item_image_text,"nk_contextual_item_image_text");
    lib.bindSymbol(cast(void**)&nk_contextual_item_symbol_label,"nk_contextual_item_symbol_label");
    lib.bindSymbol(cast(void**)&nk_contextual_item_symbol_text,"nk_contextual_item_symbol_text");
    lib.bindSymbol(cast(void**)&nk_contextual_close,"nk_contextual_close");
    lib.bindSymbol(cast(void**)&nk_contextual_end,"nk_contextual_end");
    lib.bindSymbol(cast(void**)&nk_tooltip,"nk_tooltip");
    version(NK_INCLUDE_STANDARD_VARARGS) {
        lib.bindSymbol(cast(void**)&nk_tooltipf,"nk_tooltipf");
        lib.bindSymbol(cast(void**)&nk_tooltipfv,"nk_tooltipfv");
    }
    lib.bindSymbol(cast(void**)&nk_tooltip_begin,"nk_tooltip_begin");
    lib.bindSymbol(cast(void**)&nk_tooltip_end,"nk_tooltip_end");
    lib.bindSymbol(cast(void**)&nk_menubar_begin,"nk_menubar_begin");
    lib.bindSymbol(cast(void**)&nk_menubar_end,"nk_menubar_end");
    lib.bindSymbol(cast(void**)&nk_menu_begin_text,"nk_menu_begin_text");
    lib.bindSymbol(cast(void**)&nk_menu_begin_label,"nk_menu_begin_label");
    lib.bindSymbol(cast(void**)&nk_menu_begin_image,"nk_menu_begin_image");
    lib.bindSymbol(cast(void**)&nk_menu_begin_image_text,"nk_menu_begin_image_text");
    lib.bindSymbol(cast(void**)&nk_menu_begin_image_label,"nk_menu_begin_image_label");
    lib.bindSymbol(cast(void**)&nk_menu_begin_symbol,"nk_menu_begin_symbol");
    lib.bindSymbol(cast(void**)&nk_menu_begin_symbol_text,"nk_menu_begin_symbol_text");
    lib.bindSymbol(cast(void**)&nk_menu_begin_symbol_label,"nk_menu_begin_symbol_label");
    lib.bindSymbol(cast(void**)&nk_menu_item_text,"nk_menu_item_text");
    lib.bindSymbol(cast(void**)&nk_menu_item_label,"nk_menu_item_label");
    lib.bindSymbol(cast(void**)&nk_menu_item_image_label,"nk_menu_item_image_label");
    lib.bindSymbol(cast(void**)&nk_menu_item_image_text,"nk_menu_item_image_text");
    lib.bindSymbol(cast(void**)&nk_menu_item_symbol_text,"nk_menu_item_symbol_text");
    lib.bindSymbol(cast(void**)&nk_menu_item_symbol_label,"nk_menu_item_symbol_label");
    lib.bindSymbol(cast(void**)&nk_menu_close,"nk_menu_close");
    lib.bindSymbol(cast(void**)&nk_menu_end,"nk_menu_end");
    lib.bindSymbol(cast(void**)&nk_style_default,"nk_style_default");
    lib.bindSymbol(cast(void**)&nk_style_from_table,"nk_style_from_table");
    lib.bindSymbol(cast(void**)&nk_style_load_cursor,"nk_style_load_cursor");
    lib.bindSymbol(cast(void**)&nk_style_load_all_cursors,"nk_style_load_all_cursors");
    lib.bindSymbol(cast(void**)&nk_style_get_color_by_name,"nk_style_get_color_by_name");
    lib.bindSymbol(cast(void**)&nk_style_set_font,"nk_style_set_font");
    lib.bindSymbol(cast(void**)&nk_style_set_cursor,"nk_style_set_cursor");
    lib.bindSymbol(cast(void**)&nk_style_show_cursor,"nk_style_show_cursor");
    lib.bindSymbol(cast(void**)&nk_style_hide_cursor,"nk_style_hide_cursor");
    lib.bindSymbol(cast(void**)&nk_style_push_font,"nk_style_push_font");
    lib.bindSymbol(cast(void**)&nk_style_push_float,"nk_style_push_float");
    lib.bindSymbol(cast(void**)&nk_style_push_vec2,"nk_style_push_vec2");
    lib.bindSymbol(cast(void**)&nk_style_push_style_item,"nk_style_push_style_item");
    lib.bindSymbol(cast(void**)&nk_style_push_flags,"nk_style_push_flags");
    lib.bindSymbol(cast(void**)&nk_style_push_color,"nk_style_push_color");
    lib.bindSymbol(cast(void**)&nk_style_pop_font,"nk_style_pop_font");
    lib.bindSymbol(cast(void**)&nk_style_pop_float,"nk_style_pop_float");
    lib.bindSymbol(cast(void**)&nk_style_pop_vec2,"nk_style_pop_vec2");
    lib.bindSymbol(cast(void**)&nk_style_pop_style_item,"nk_style_pop_style_item");
    lib.bindSymbol(cast(void**)&nk_style_pop_flags,"nk_style_pop_flags");
    lib.bindSymbol(cast(void**)&nk_style_pop_color,"nk_style_pop_color");
    lib.bindSymbol(cast(void**)&nk_rgb,"nk_rgb");
    lib.bindSymbol(cast(void**)&nk_rgb_iv,"nk_rgb_iv");
    lib.bindSymbol(cast(void**)&nk_rgb_bv,"nk_rgb_bv");
    lib.bindSymbol(cast(void**)&nk_rgb_f,"nk_rgb_f");
    lib.bindSymbol(cast(void**)&nk_rgb_fv,"nk_rgb_fv");
    lib.bindSymbol(cast(void**)&nk_rgb_cf,"nk_rgb_cf");
    lib.bindSymbol(cast(void**)&nk_rgb_hex,"nk_rgb_hex");
    lib.bindSymbol(cast(void**)&nk_rgba,"nk_rgba");
    lib.bindSymbol(cast(void**)&nk_rgba_u32,"nk_rgba_u32");
    lib.bindSymbol(cast(void**)&nk_rgba_iv,"nk_rgba_iv");
    lib.bindSymbol(cast(void**)&nk_rgba_bv,"nk_rgba_bv");
    lib.bindSymbol(cast(void**)&nk_rgba_f,"nk_rgba_f");
    lib.bindSymbol(cast(void**)&nk_rgba_fv,"nk_rgba_fv");
    lib.bindSymbol(cast(void**)&nk_rgba_cf,"nk_rgba_cf");
    lib.bindSymbol(cast(void**)&nk_rgba_hex,"nk_rgba_hex");
    lib.bindSymbol(cast(void**)&nk_hsva_colorf,"nk_hsva_colorf");
    lib.bindSymbol(cast(void**)&nk_hsva_colorfv,"nk_hsva_colorfv");
    lib.bindSymbol(cast(void**)&nk_colorf_hsva_f,"nk_colorf_hsva_f");
    lib.bindSymbol(cast(void**)&nk_colorf_hsva_fv,"nk_colorf_hsva_fv");
    lib.bindSymbol(cast(void**)&nk_hsv,"nk_hsv");
    lib.bindSymbol(cast(void**)&nk_hsv_iv,"nk_hsv_iv");
    lib.bindSymbol(cast(void**)&nk_hsv_bv,"nk_hsv_bv");
    lib.bindSymbol(cast(void**)&nk_hsv_f,"nk_hsv_f");
    lib.bindSymbol(cast(void**)&nk_hsv_fv,"nk_hsv_fv");
    lib.bindSymbol(cast(void**)&nk_hsva,"nk_hsva");
    lib.bindSymbol(cast(void**)&nk_hsva_iv,"nk_hsva_iv");
    lib.bindSymbol(cast(void**)&nk_hsva_bv,"nk_hsva_bv");
    lib.bindSymbol(cast(void**)&nk_hsva_f,"nk_hsva_f");
    lib.bindSymbol(cast(void**)&nk_hsva_fv,"nk_hsva_fv");
    lib.bindSymbol(cast(void**)&nk_color_f,"nk_color_f");
    lib.bindSymbol(cast(void**)&nk_color_fv,"nk_color_fv");
    lib.bindSymbol(cast(void**)&nk_color_cf,"nk_color_cf");
    lib.bindSymbol(cast(void**)&nk_color_d,"nk_color_d");
    lib.bindSymbol(cast(void**)&nk_color_dv,"nk_color_dv");
    lib.bindSymbol(cast(void**)&nk_color_u32,"nk_color_u32");
    lib.bindSymbol(cast(void**)&nk_color_hex_rgba,"nk_color_hex_rgba");
    lib.bindSymbol(cast(void**)&nk_color_hex_rgb,"nk_color_hex_rgb");
    lib.bindSymbol(cast(void**)&nk_color_hsv_i,"nk_color_hsv_i");
    lib.bindSymbol(cast(void**)&nk_color_hsv_b,"nk_color_hsv_b");
    lib.bindSymbol(cast(void**)&nk_color_hsv_iv,"nk_color_hsv_iv");
    lib.bindSymbol(cast(void**)&nk_color_hsv_bv,"nk_color_hsv_bv");
    lib.bindSymbol(cast(void**)&nk_color_hsv_f,"nk_color_hsv_f");
    lib.bindSymbol(cast(void**)&nk_color_hsv_fv,"nk_color_hsv_fv");
    lib.bindSymbol(cast(void**)&nk_color_hsva_i,"nk_color_hsva_i");
    lib.bindSymbol(cast(void**)&nk_color_hsva_b,"nk_color_hsva_b");
    lib.bindSymbol(cast(void**)&nk_color_hsva_iv,"nk_color_hsva_iv");
    lib.bindSymbol(cast(void**)&nk_color_hsva_bv,"nk_color_hsva_bv");
    lib.bindSymbol(cast(void**)&nk_color_hsva_f,"nk_color_hsva_f");
    lib.bindSymbol(cast(void**)&nk_color_hsva_fv,"nk_color_hsva_fv");
    lib.bindSymbol(cast(void**)&nk_handle_ptr,"nk_handle_ptr");
    lib.bindSymbol(cast(void**)&nk_handle_id,"nk_handle_id");
    lib.bindSymbol(cast(void**)&nk_image_handle,"nk_image_handle");
    lib.bindSymbol(cast(void**)&nk_image_ptr,"nk_image_ptr");
    lib.bindSymbol(cast(void**)&nk_image_id,"nk_image_id");
    lib.bindSymbol(cast(void**)&nk_image_is_subimage,"nk_image_is_subimage");
    lib.bindSymbol(cast(void**)&nk_subimage_ptr,"nk_subimage_ptr");
    lib.bindSymbol(cast(void**)&nk_subimage_id,"nk_subimage_id");
    lib.bindSymbol(cast(void**)&nk_subimage_handle,"nk_subimage_handle");
    lib.bindSymbol(cast(void**)&nk_murmur_hash,"nk_murmur_hash");
    lib.bindSymbol(cast(void**)&nk_triangle_from_direction,"nk_triangle_from_direction");
    lib.bindSymbol(cast(void**)&nk_vec2_,"nk_vec2");
    lib.bindSymbol(cast(void**)&nk_vec2i_,"nk_vec2i");
    lib.bindSymbol(cast(void**)&nk_vec2v,"nk_vec2v");
    lib.bindSymbol(cast(void**)&nk_vec2iv,"nk_vec2iv");
    lib.bindSymbol(cast(void**)&nk_get_null_rect,"nk_get_null_rect");
    lib.bindSymbol(cast(void**)&nk_rect_,"nk_rect");
    lib.bindSymbol(cast(void**)&nk_recti,"nk_recti");
    lib.bindSymbol(cast(void**)&nk_recta,"nk_recta");
    lib.bindSymbol(cast(void**)&nk_rectv,"nk_rectv");
    lib.bindSymbol(cast(void**)&nk_rectiv,"nk_rectiv");
    lib.bindSymbol(cast(void**)&nk_rect_pos,"nk_rect_pos");
    lib.bindSymbol(cast(void**)&nk_rect_size,"nk_rect_size");
    lib.bindSymbol(cast(void**)&nk_strlen,"nk_strlen");
    lib.bindSymbol(cast(void**)&nk_stricmp,"nk_stricmp");
    lib.bindSymbol(cast(void**)&nk_stricmpn,"nk_stricmpn");
    lib.bindSymbol(cast(void**)&nk_strtoi,"nk_strtoi");
    lib.bindSymbol(cast(void**)&nk_strtof,"nk_strtof");
    lib.bindSymbol(cast(void**)&nk_strtod,"nk_strtod");
    lib.bindSymbol(cast(void**)&nk_strfilter,"nk_strfilter");
    lib.bindSymbol(cast(void**)&nk_strmatch_fuzzy_string,"nk_strmatch_fuzzy_string");
    lib.bindSymbol(cast(void**)&nk_strmatch_fuzzy_text,"nk_strmatch_fuzzy_text");
    lib.bindSymbol(cast(void**)&nk_utf_decode,"nk_utf_decode");
    lib.bindSymbol(cast(void**)&nk_utf_encode,"nk_utf_encode");
    lib.bindSymbol(cast(void**)&nk_utf_len,"nk_utf_len");
    lib.bindSymbol(cast(void**)&nk_utf_at,"nk_utf_at");
    version(NK_INCLUDE_FONT_BAKING) {
        lib.bindSymbol(cast(void**)&nk_font_default_glyph_ranges,"nk_font_default_glyph_ranges");
        lib.bindSymbol(cast(void**)&nk_font_chinese_glyph_ranges,"nk_font_chinese_glyph_ranges");
        lib.bindSymbol(cast(void**)&nk_font_cyrillic_glyph_ranges,"nk_font_cyrillic_glyph_ranges");
        lib.bindSymbol(cast(void**)&nk_font_korean_glyph_ranges,"nk_font_korean_glyph_ranges");
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            lib.bindSymbol(cast(void**)&nk_font_atlas_init_default,"nk_font_atlas_init_default");
        }
        lib.bindSymbol(cast(void**)&nk_font_atlas_init,"nk_font_atlas_init");
        lib.bindSymbol(cast(void**)&nk_font_atlas_init_custom,"nk_font_atlas_init_custom");
        lib.bindSymbol(cast(void**)&nk_font_atlas_begin,"nk_font_atlas_begin");
        lib.bindSymbol(cast(void**)&nk_font_config_,"nk_font_config");
        lib.bindSymbol(cast(void**)&nk_font_atlas_add,"nk_font_atlas_add");
        version(NK_INCLUDE_DEFAULT_FONT) {
            lib.bindSymbol(cast(void**)&nk_font_atlas_add_default,"nk_font_atlas_add_default");
        }
        lib.bindSymbol(cast(void**)&nk_font_atlas_add_from_memory,"nk_font_atlas_add_from_memory");
        version(NK_INCLUDE_STANDARD_IO) {
            lib.bindSymbol(cast(void**)&nk_font_atlas_add_from_file,"nk_font_atlas_add_from_file");
        }
        lib.bindSymbol(cast(void**)&nk_font_atlas_add_compressed,"nk_font_atlas_add_compressed");
        lib.bindSymbol(cast(void**)&nk_font_atlas_add_compressed_base85,"nk_font_atlas_add_compressed_base85");
        lib.bindSymbol(cast(void**)&nk_font_atlas_bake,"nk_font_atlas_bake");
        lib.bindSymbol(cast(void**)&nk_font_atlas_end,"nk_font_atlas_end");
        lib.bindSymbol(cast(void**)&nk_font_find_glyph,"nk_font_find_glyph");
        lib.bindSymbol(cast(void**)&nk_font_atlas_cleanup,"nk_font_atlas_cleanup");
        lib.bindSymbol(cast(void**)&nk_font_atlas_clear,"nk_font_atlas_clear");
    }
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        lib.bindSymbol(cast(void**)&nk_buffer_init_default,"nk_buffer_init_default");
    }
    lib.bindSymbol(cast(void**)&nk_buffer_init,"nk_buffer_init");
    lib.bindSymbol(cast(void**)&nk_buffer_init_fixed,"nk_buffer_init_fixed");
    lib.bindSymbol(cast(void**)&nk_buffer_info,"nk_buffer_info");
    lib.bindSymbol(cast(void**)&nk_buffer_push,"nk_buffer_push");
    lib.bindSymbol(cast(void**)&nk_buffer_mark,"nk_buffer_mark");
    lib.bindSymbol(cast(void**)&nk_buffer_reset,"nk_buffer_reset");
    lib.bindSymbol(cast(void**)&nk_buffer_clear,"nk_buffer_clear");
    lib.bindSymbol(cast(void**)&nk_buffer_free,"nk_buffer_free");
    lib.bindSymbol(cast(void**)&nk_buffer_memory,"nk_buffer_memory");
    lib.bindSymbol(cast(void**)&nk_buffer_memory_const,"nk_buffer_memory_const");
    lib.bindSymbol(cast(void**)&nk_buffer_total,"nk_buffer_total");
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        lib.bindSymbol(cast(void**)&nk_str_init_default,"nk_str_init_default");
    }
    lib.bindSymbol(cast(void**)&nk_str_init,"nk_str_init");
    lib.bindSymbol(cast(void**)&nk_str_init_fixed,"nk_str_init_fixed");
    lib.bindSymbol(cast(void**)&nk_str_clear,"nk_str_clear");
    lib.bindSymbol(cast(void**)&nk_str_free,"nk_str_free");
    lib.bindSymbol(cast(void**)&nk_str_append_text_char,"nk_str_append_text_char");
    lib.bindSymbol(cast(void**)&nk_str_append_str_char,"nk_str_append_str_char");
    lib.bindSymbol(cast(void**)&nk_str_append_text_utf8,"nk_str_append_text_utf8");
    lib.bindSymbol(cast(void**)&nk_str_append_str_utf8,"nk_str_append_str_utf8");
    lib.bindSymbol(cast(void**)&nk_str_append_text_runes,"nk_str_append_text_runes");
    lib.bindSymbol(cast(void**)&nk_str_append_str_runes,"nk_str_append_str_runes");
    lib.bindSymbol(cast(void**)&nk_str_insert_at_char,"nk_str_insert_at_char");
    lib.bindSymbol(cast(void**)&nk_str_insert_at_rune,"nk_str_insert_at_rune");
    lib.bindSymbol(cast(void**)&nk_str_insert_text_char,"nk_str_insert_text_char");
    lib.bindSymbol(cast(void**)&nk_str_insert_str_char,"nk_str_insert_str_char");
    lib.bindSymbol(cast(void**)&nk_str_insert_text_utf8,"nk_str_insert_text_utf8");
    lib.bindSymbol(cast(void**)&nk_str_insert_str_utf8,"nk_str_insert_str_utf8");
    lib.bindSymbol(cast(void**)&nk_str_insert_text_runes,"nk_str_insert_text_runes");
    lib.bindSymbol(cast(void**)&nk_str_insert_str_runes,"nk_str_insert_str_runes");
    lib.bindSymbol(cast(void**)&nk_str_remove_chars,"nk_str_remove_chars");
    lib.bindSymbol(cast(void**)&nk_str_remove_runes,"nk_str_remove_runes");
    lib.bindSymbol(cast(void**)&nk_str_delete_chars,"nk_str_delete_chars");
    lib.bindSymbol(cast(void**)&nk_str_delete_runes,"nk_str_delete_runes");
    lib.bindSymbol(cast(void**)&nk_str_at_char,"nk_str_at_char");
    lib.bindSymbol(cast(void**)&nk_str_at_rune,"nk_str_at_rune");
    lib.bindSymbol(cast(void**)&nk_str_rune_at,"nk_str_rune_at");
    lib.bindSymbol(cast(void**)&nk_str_at_char_const,"nk_str_at_char_const");
    lib.bindSymbol(cast(void**)&nk_str_at_const,"nk_str_at_const");
    lib.bindSymbol(cast(void**)&nk_str_get,"nk_str_get");
    lib.bindSymbol(cast(void**)&nk_str_get_const,"nk_str_get_const");
    lib.bindSymbol(cast(void**)&nk_str_len,"nk_str_len");
    lib.bindSymbol(cast(void**)&nk_str_len_char,"nk_str_len_char");
    lib.bindSymbol(cast(void**)&nk_filter_default_fptr,"nk_filter_default");
    lib.bindSymbol(cast(void**)&nk_filter_ascii_fptr,"nk_filter_ascii");
    lib.bindSymbol(cast(void**)&nk_filter_float_fptr,"nk_filter_float");
    lib.bindSymbol(cast(void**)&nk_filter_decimal_fptr,"nk_filter_decimal");
    lib.bindSymbol(cast(void**)&nk_filter_hex_fptr,"nk_filter_hex");
    lib.bindSymbol(cast(void**)&nk_filter_oct_fptr,"nk_filter_oct");
    lib.bindSymbol(cast(void**)&nk_filter_binary_fptr,"nk_filter_binary");
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        lib.bindSymbol(cast(void**)&nk_textedit_init_default,"nk_textedit_init_default");
    }
    lib.bindSymbol(cast(void**)&nk_textedit_init,"nk_textedit_init");
    lib.bindSymbol(cast(void**)&nk_textedit_init_fixed,"nk_textedit_init_fixed");
    lib.bindSymbol(cast(void**)&nk_textedit_free,"nk_textedit_free");
    lib.bindSymbol(cast(void**)&nk_textedit_text,"nk_textedit_text");
    lib.bindSymbol(cast(void**)&nk_textedit_delete,"nk_textedit_delete");
    lib.bindSymbol(cast(void**)&nk_textedit_delete_selection,"nk_textedit_delete_selection");
    lib.bindSymbol(cast(void**)&nk_textedit_select_all,"nk_textedit_select_all");
    lib.bindSymbol(cast(void**)&nk_textedit_cut,"nk_textedit_cut");
    lib.bindSymbol(cast(void**)&nk_textedit_paste,"nk_textedit_paste");
    lib.bindSymbol(cast(void**)&nk_textedit_undo,"nk_textedit_undo");
    lib.bindSymbol(cast(void**)&nk_textedit_redo,"nk_textedit_redo");
    lib.bindSymbol(cast(void**)&nk_stroke_line,"nk_stroke_line");
    lib.bindSymbol(cast(void**)&nk_stroke_curve,"nk_stroke_curve");
    lib.bindSymbol(cast(void**)&nk_stroke_rect,"nk_stroke_rect");
    lib.bindSymbol(cast(void**)&nk_stroke_circle,"nk_stroke_circle");
    lib.bindSymbol(cast(void**)&nk_stroke_arc,"nk_stroke_arc");
    lib.bindSymbol(cast(void**)&nk_stroke_triangle,"nk_stroke_triangle");
    lib.bindSymbol(cast(void**)&nk_stroke_polyline,"nk_stroke_polyline");
    lib.bindSymbol(cast(void**)&nk_stroke_polygon,"nk_stroke_polygon");
    lib.bindSymbol(cast(void**)&nk_fill_rect,"nk_fill_rect");
    lib.bindSymbol(cast(void**)&nk_fill_rect_multi_color,"nk_fill_rect_multi_color");
    lib.bindSymbol(cast(void**)&nk_fill_circle,"nk_fill_circle");
    lib.bindSymbol(cast(void**)&nk_fill_arc,"nk_fill_arc");
    lib.bindSymbol(cast(void**)&nk_fill_triangle,"nk_fill_triangle");
    lib.bindSymbol(cast(void**)&nk_fill_polygon,"nk_fill_polygon");
    lib.bindSymbol(cast(void**)&nk_draw_image,"nk_draw_image");
    lib.bindSymbol(cast(void**)&nk_draw_text,"nk_draw_text");
    lib.bindSymbol(cast(void**)&nk_push_scissor,"nk_push_scissor");
    lib.bindSymbol(cast(void**)&nk_push_custom,"nk_push_custom");
    lib.bindSymbol(cast(void**)&nk_input_has_mouse_click,"nk_input_has_mouse_click");
    lib.bindSymbol(cast(void**)&nk_input_has_mouse_click_in_rect,"nk_input_has_mouse_click_in_rect");
    lib.bindSymbol(cast(void**)&nk_input_has_mouse_click_down_in_rect,"nk_input_has_mouse_click_down_in_rect");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_click_in_rect,"nk_input_is_mouse_click_in_rect");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_click_down_in_rect,"nk_input_is_mouse_click_down_in_rect");
    lib.bindSymbol(cast(void**)&nk_input_any_mouse_click_in_rect,"nk_input_any_mouse_click_in_rect");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_prev_hovering_rect,"nk_input_is_mouse_prev_hovering_rect");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_hovering_rect,"nk_input_is_mouse_hovering_rect");
    lib.bindSymbol(cast(void**)&nk_input_mouse_clicked,"nk_input_mouse_clicked");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_down,"nk_input_is_mouse_down");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_pressed,"nk_input_is_mouse_pressed");
    lib.bindSymbol(cast(void**)&nk_input_is_mouse_released,"nk_input_is_mouse_released");
    lib.bindSymbol(cast(void**)&nk_input_is_key_pressed,"nk_input_is_key_pressed");
    lib.bindSymbol(cast(void**)&nk_input_is_key_released,"nk_input_is_key_released");
    lib.bindSymbol(cast(void**)&nk_input_is_key_down,"nk_input_is_key_down");
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        lib.bindSymbol(cast(void**)&nk_draw_list_init,"nk_draw_list_init");
        lib.bindSymbol(cast(void**)&nk_draw_list_setup,"nk_draw_list_setup");
        lib.bindSymbol(cast(void**)&nk__draw_list_begin,"nk__draw_list_begin");
        lib.bindSymbol(cast(void**)&nk__draw_list_next,"nk__draw_list_next");
        lib.bindSymbol(cast(void**)&nk__draw_list_end,"nk__draw_list_end");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_clear,"nk_draw_list_path_clear");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_line_to,"nk_draw_list_path_line_to");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_arc_to_fast,"nk_draw_list_path_arc_to_fast");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_arc_to,"nk_draw_list_path_arc_to");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_rect_to,"nk_draw_list_path_rect_to");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_curve_to,"nk_draw_list_path_curve_to");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_fill,"nk_draw_list_path_fill");
        lib.bindSymbol(cast(void**)&nk_draw_list_path_stroke,"nk_draw_list_path_stroke");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_line,"nk_draw_list_stroke_line");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_rect,"nk_draw_list_stroke_rect");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_triangle,"nk_draw_list_stroke_triangle");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_circle,"nk_draw_list_stroke_circle");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_curve,"nk_draw_list_stroke_curve");
        lib.bindSymbol(cast(void**)&nk_draw_list_stroke_poly_line,"nk_draw_list_stroke_poly_line");
        lib.bindSymbol(cast(void**)&nk_draw_list_fill_rect,"nk_draw_list_fill_rect");
        lib.bindSymbol(cast(void**)&nk_draw_list_fill_rect_multi_color,"nk_draw_list_fill_rect_multi_color");
        lib.bindSymbol(cast(void**)&nk_draw_list_fill_triangle,"nk_draw_list_fill_triangle");
        lib.bindSymbol(cast(void**)&nk_draw_list_fill_circle,"nk_draw_list_fill_circle");
        lib.bindSymbol(cast(void**)&nk_draw_list_fill_poly_convex,"nk_draw_list_fill_poly_convex");
        lib.bindSymbol(cast(void**)&nk_draw_list_add_image,"nk_draw_list_add_image");
        lib.bindSymbol(cast(void**)&nk_draw_list_add_text,"nk_draw_list_add_text");
        version(NK_INCLUDE_COMMAND_USERDATA) {
            lib.bindSymbol(cast(void**)&nk_draw_list_push_userdata,"nk_draw_list_push_userdata");
        }
    }
    lib.bindSymbol(cast(void**)&nk_style_item_image,"nk_style_item_image");
    lib.bindSymbol(cast(void**)&nk_style_item_color,"nk_style_item_color");
    lib.bindSymbol(cast(void**)&nk_style_item_hide,"nk_style_item_hide");

    loadedVersion = NuklearSupport.Nuklear4;

    if(errorCount() != errCount) return NuklearSupport.badLibrary;

    return loadedVersion;
}