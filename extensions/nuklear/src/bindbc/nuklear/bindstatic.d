
//          Copyright Mateusz Muszyński 2019.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.nuklear.bindstatic;

version(BindNuklear_Static):

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
        int nk_init_default(nk_context*, const(nk_user_font)*);
    }
    int nk_init_fixed(nk_context*, void* memory, nk_size size, const(nk_user_font)*);
    int nk_init(nk_context*, nk_allocator*, const(nk_user_font)*);
    int nk_init_custom(nk_context*, nk_buffer* cmds, nk_buffer* pool, const(nk_user_font)*);
    void nk_clear(nk_context*);
    void nk_free(nk_context*);
    version(NK_INCLUDE_COMMAND_USERDATA) {
        void nk_set_user_data(nk_context*, nk_handle handle);
    }
    void nk_input_begin(nk_context*);
    void nk_input_motion(nk_context*, int x, int y);
    void nk_input_key(nk_context*, nk_keys, int down);
    void nk_input_button(nk_context*, nk_buttons, int x, int y, int down);
    void nk_input_scroll(nk_context*, nk_vec2 val);
    void nk_input_char(nk_context*, char);
    void nk_input_glyph(nk_context*, const(char)*);
    void nk_input_unicode(nk_context*, nk_rune);
    void nk_input_end(nk_context*);
    const(nk_command)* nk__begin(nk_context*);
    const(nk_command)* nk__next(nk_context*, const(nk_command)*);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        nk_flags nk_convert(nk_context*, nk_buffer* cmds, nk_buffer* vertices, nk_buffer* elements, const(nk_convert_config)*);
        const(nk_draw_command)* nk__draw_begin(const(nk_context)*, const(nk_buffer)*);
        const(nk_draw_command)* nk__draw_end(const(nk_context)*, const(nk_buffer)*);
        const(nk_draw_command)* nk__draw_next(const(nk_draw_command)*, const(nk_buffer)*, const(nk_context)*);
    }
    int nk_begin(nk_context* ctx, const(char)* title, nk_rect bounds, nk_flags flags);
    int nk_begin_titled(nk_context* ctx, const(char)* name, const(char)* title, nk_rect bounds, nk_flags flags);
    void nk_end(nk_context* ctx);
    nk_window* nk_window_find(nk_context* ctx, const(char)* name);
    nk_rect nk_window_get_bounds(const(nk_context)* ctx);
    nk_vec2 nk_window_get_position(const(nk_context)* ctx);
    nk_vec2 nk_window_get_size(const(nk_context)*);
    float nk_window_get_width(const(nk_context)*);
    float nk_window_get_height(const(nk_context)*);
    nk_panel* nk_window_get_panel(nk_context*);
    nk_rect nk_window_get_content_region(nk_context*);
    nk_vec2 nk_window_get_content_region_min(nk_context*);
    nk_vec2 nk_window_get_content_region_max(nk_context*);
    nk_vec2 nk_window_get_content_region_size(nk_context*);
    nk_command_buffer* nk_window_get_canvas(nk_context*);
    void nk_window_get_scroll(nk_context*, nk_uint* offset_x, nk_uint* offset_y); // 4.01.0
    int nk_window_has_focus(const(nk_context)*);
    int nk_window_is_hovered(nk_context*);
    int nk_window_is_collapsed(nk_context* ctx, const(char)* name);
    int nk_window_is_closed(nk_context*, const(char)*);
    int nk_window_is_hidden(nk_context*, const(char)*);
    int nk_window_is_active(nk_context*, const(char)*);
    int nk_window_is_any_hovered(nk_context*);
    int nk_item_is_any_active(nk_context*);
    void nk_window_set_bounds(nk_context*, const(char)* name, nk_rect bounds);
    void nk_window_set_position(nk_context*, const(char)* name, nk_vec2 pos);
    void nk_window_set_size(nk_context*, const(char)* name, nk_vec2);
    void nk_window_set_focus(nk_context*, const(char)* name);
    void nk_window_set_scroll(nk_context*, nk_uint offset_x, nk_uint offset_y); // 4.01.0
    void nk_window_close(nk_context* ctx, const(char)* name);
    void nk_window_collapse(nk_context*, const(char)* name, nk_collapse_states state);
    void nk_window_collapse_if(nk_context*, const(char)* name, nk_collapse_states, int cond);
    void nk_window_show(nk_context*, const(char)* name, nk_show_states);
    void nk_window_show_if(nk_context*, const(char)* name, nk_show_states, int cond);
    void nk_layout_set_min_row_height(nk_context*, float height);
    void nk_layout_reset_min_row_height(nk_context*);
    nk_rect nk_layout_widget_bounds(nk_context*);
    float nk_layout_ratio_from_pixel(nk_context*, float pixel_width);
    void nk_layout_row_dynamic(nk_context* ctx, float height, int cols);
    void nk_layout_row_static(nk_context* ctx, float height, int item_width, int cols);
    void nk_layout_row_begin(nk_context* ctx, nk_layout_format fmt, float row_height, int cols);
    void nk_layout_row_push(nk_context*, float value);
    void nk_layout_row_end(nk_context*);
    void nk_layout_row(nk_context*, nk_layout_format, float height, int cols, const(float)* ratio);
    void nk_layout_row_template_begin(nk_context*, float row_height);
    void nk_layout_row_template_push_dynamic(nk_context*);
    void nk_layout_row_template_push_variable(nk_context*, float min_width);
    void nk_layout_row_template_push_static(nk_context*, float width);
    void nk_layout_row_template_end(nk_context*);
    void nk_layout_space_begin(nk_context*, nk_layout_format, float height, int widget_count);
    void nk_layout_space_push(nk_context*, nk_rect bounds);
    void nk_layout_space_end(nk_context*);
    nk_rect nk_layout_space_bounds(nk_context*);
    nk_vec2 nk_layout_space_to_screen(nk_context*, nk_vec2);
    nk_vec2 nk_layout_space_to_local(nk_context*, nk_vec2);
    nk_rect nk_layout_space_rect_to_screen(nk_context*, nk_rect);
    nk_rect nk_layout_space_rect_to_local(nk_context*, nk_rect);
    int nk_group_begin(nk_context*, const(char)* title, nk_flags);
    int nk_group_begin_titled(nk_context*, const(char)* name, const(char)* title, nk_flags);
    void nk_group_end(nk_context*);
    int nk_group_scrolled_offset_begin(nk_context*, nk_uint* x_offset, nk_uint* y_offset, const(char)* title, nk_flags flags);
    int nk_group_scrolled_begin(nk_context*, nk_scroll* off, const(char)* title, nk_flags);
    void nk_group_scrolled_end(nk_context*);
    void nk_group_get_scroll(nk_context*, const(char)* id, nk_uint *x_offset, nk_uint *y_offset); // 4.01.0
    void nk_group_set_scroll(nk_context*, const(char)* id, nk_uint x_offset, nk_uint y_offset); // 4.01.0
    int nk_tree_push_hashed(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states initial_state, const(char)* hash, int len, int seed);
    int nk_tree_image_push_hashed(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states initial_state, const(char)* hash, int len, int seed);
    void nk_tree_pop(nk_context*);
    int nk_tree_state_push(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states* state);
    int nk_tree_state_image_push(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states* state);
    void nk_tree_state_pop(nk_context*);
    int nk_tree_element_push_hashed(nk_context*, nk_tree_type, const(char)* title, nk_collapse_states initial_state, int* selected, const(char)* hash, int len, int seed);
    int nk_tree_element_image_push_hashed(nk_context*, nk_tree_type, nk_image, const(char)* title, nk_collapse_states initial_state, int* selected, const(char)* hash, int len, int seed);
    void nk_tree_element_pop(nk_context*);
    int nk_list_view_begin(nk_context*, nk_list_view* out_, const(char)* id, nk_flags, int row_height, int row_count);
    void nk_list_view_end(nk_list_view*);
    nk_widget_layout_states nk_widget(nk_rect*, const(nk_context)*);
    nk_widget_layout_states nk_widget_fitting(nk_rect*, nk_context*, nk_vec2);
    nk_rect nk_widget_bounds(nk_context*);
    nk_vec2 nk_widget_position(nk_context*);
    nk_vec2 nk_widget_size(nk_context*);
    float nk_widget_width(nk_context*);
    float nk_widget_height(nk_context*);
    int nk_widget_is_hovered(nk_context*);
    int nk_widget_is_mouse_clicked(nk_context*, nk_buttons);
    int nk_widget_has_mouse_click_down(nk_context*, nk_buttons, int down);
    void nk_spacing(nk_context*, int cols);
    void nk_text(nk_context*, const(char)*, int, nk_flags);
    void nk_text_colored(nk_context*, const(char)*, int, nk_flags, nk_color);
    void nk_text_wrap(nk_context*, const(char)*, int);
    void nk_text_wrap_colored(nk_context*, const(char)*, int, nk_color);
    void nk_label(nk_context*, const(char)*, nk_flags align__);
    void nk_label_colored(nk_context*, const(char)*, nk_flags align__, nk_color);
    void nk_label_wrap(nk_context*, const(char)*);
    void nk_label_colored_wrap(nk_context*, const(char)*, nk_color);
    pragma(mangle, "nk_image")
        void nk_image_(nk_context*, nk_image);
    void nk_image_color(nk_context*, nk_image, nk_color);
    version(NK_INCLUDE_STANDARD_VARARGS) {
        void nk_labelf(nk_context*, nk_flags, const(char)*, ...);
        void nk_labelf_colored(nk_context*, nk_flags, nk_color, const(char)*, ...);
        void nk_labelf_wrap(nk_context*, const(char)*, ...);
        void nk_labelf_colored_wrap(nk_context*, nk_color, const(char)*, ...);
        void nk_labelfv(nk_context*, nk_flags, const(char)*, va_list);
        void nk_labelfv_colored(nk_context*, nk_flags, nk_color, const(char)*, va_list);
        void nk_labelfv_wrap(nk_context*, const(char)*, va_list);
        void nk_labelfv_colored_wrap(nk_context*, nk_color, const(char)*, va_list);
        void nk_value_bool(nk_context*, const(char)* prefix, int);
        void nk_value_int(nk_context*, const(char)* prefix, int);
        void nk_value_uint(nk_context*, const(char)* prefix, uint);
        void nk_value_float(nk_context*, const(char)* prefix, float);
        void nk_value_color_byte(nk_context*, const(char)* prefix, nk_color);
        void nk_value_color_float(nk_context*, const(char)* prefix, nk_color);
        void nk_value_color_hex(nk_context*, const(char)* prefix, nk_color);
    }
    int nk_button_text(nk_context*, const(char)* title, int len);
    int nk_button_label(nk_context*, const(char)* title);
    int nk_button_color(nk_context*, nk_color);
    int nk_button_symbol(nk_context*, nk_symbol_type);
    int nk_button_image(nk_context*, nk_image img);
    int nk_button_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags text_alignment);
    int nk_button_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_ment);
    int nk_button_image_label(nk_context*, nk_image img, const(char)*, nk_flags text_alignment);
    int nk_button_image_text(nk_context*, nk_image img, const(char)*, int, nk_flags align_ment);
    int nk_button_text_styled(nk_context*, const(nk_style_button)*, const(char)* title, int len);
    int nk_button_label_styled(nk_context*, const(nk_style_button)*, const(char)* title);
    int nk_button_symbol_styled(nk_context*, const(nk_style_button)*, nk_symbol_type);
    int nk_button_image_styled(nk_context*, const(nk_style_button)*, nk_image img);
    int nk_button_symbol_text_styled(nk_context*, const(nk_style_button)*, nk_symbol_type, const(char)*, int, nk_flags align_ment);
    int nk_button_symbol_label_styled(nk_context* ctx, const(nk_style_button)* style, nk_symbol_type symbol, const(char)* title, nk_flags align_);
    int nk_button_image_label_styled(nk_context*, const(nk_style_button)*, nk_image img, const(char)*, nk_flags text_alignment);
    int nk_button_image_text_styled(nk_context*, const(nk_style_button)*, nk_image img, const(char)*, int, nk_flags align_ment);
    void nk_button_set_behavior(nk_context*, nk_button_behavior);
    int nk_button_push_behavior(nk_context*, nk_button_behavior);
    int nk_button_pop_behavior(nk_context*);
    int nk_check_label(nk_context*, const(char)*, int active);
    int nk_check_text(nk_context*, const(char)*, int, int active);
    uint nk_check_flags_label(nk_context*, const(char)*, uint flags, uint value);
    uint nk_check_flags_text(nk_context*, const(char)*, int, uint flags, uint value);
    int nk_checkbox_label(nk_context*, const(char)*, int* active);
    int nk_checkbox_text(nk_context*, const(char)*, int, int* active);
    int nk_checkbox_flags_label(nk_context*, const(char)*, uint* flags, uint value);
    int nk_checkbox_flags_text(nk_context*, const(char)*, int, uint* flags, uint value);
    int nk_radio_label(nk_context*, const(char)*, int* active);
    int nk_radio_text(nk_context*, const(char)*, int, int* active);
    int nk_option_label(nk_context*, const(char)*, int active);
    int nk_option_text(nk_context*, const(char)*, int, int active);
    int nk_selectable_label(nk_context*, const(char)*, nk_flags align_, int* value);
    int nk_selectable_text(nk_context*, const(char)*, int, nk_flags align_, int* value);
    int nk_selectable_image_label(nk_context*, nk_image, const(char)*, nk_flags align_, int* value);
    int nk_selectable_image_text(nk_context*, nk_image, const(char)*, int, nk_flags align_, int* value);
    int nk_selectable_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags align_, int* value);
    int nk_selectable_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_, int* value);
    int nk_select_label(nk_context*, const(char)*, nk_flags align_, int value);
    int nk_select_text(nk_context*, const(char)*, int, nk_flags align_, int value);
    int nk_select_image_label(nk_context*, nk_image, const(char)*, nk_flags align_, int value);
    int nk_select_image_text(nk_context*, nk_image, const(char)*, int, nk_flags align_, int value);
    int nk_select_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags align_, int value);
    int nk_select_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_, int value);
    float nk_slide_float(nk_context*, float min, float val, float max, float step);
    int nk_slide_int(nk_context*, int min, int val, int max, int step);
    int nk_slider_float(nk_context*, float min, float* val, float max, float step);
    int nk_slider_int(nk_context*, int min, int* val, int max, int step);
    int nk_progress(nk_context*, nk_size* cur, nk_size max, int modifyable);
    nk_size nk_prog(nk_context*, nk_size cur, nk_size max, int modifyable);
    nk_colorf nk_color_picker(nk_context*, nk_colorf, nk_color_format);
    int nk_color_pick(nk_context*, nk_colorf*, nk_color_format);
    void nk_property_int(nk_context*, const(char)* name, int min, int* val, int max, int step, float inc_per_pixel);
    void nk_property_float(nk_context*, const(char)* name, float min, float* val, float max, float step, float inc_per_pixel);
    void nk_property_double(nk_context*, const(char)* name, double min, double* val, double max, double step, float inc_per_pixel);
    int nk_propertyi(nk_context*, const(char)* name, int min, int val, int max, int step, float inc_per_pixel);
    float nk_propertyf(nk_context*, const(char)* name, float min, float val, float max, float step, float inc_per_pixel);
    double nk_propertyd(nk_context*, const(char)* name, double min, double val, double max, double step, float inc_per_pixel);
    nk_flags nk_edit_string(nk_context*, nk_flags, char* buffer, int* len, int max, nk_plugin_filter);
    nk_flags nk_edit_string_zero_terminated(nk_context*, nk_flags, char* buffer, int max, nk_plugin_filter);
    nk_flags nk_edit_buffer(nk_context*, nk_flags, nk_text_edit*, nk_plugin_filter);
    void nk_edit_focus(nk_context*, nk_flags flags);
    void nk_edit_unfocus(nk_context*);
    int nk_chart_begin(nk_context*, nk_chart_type, int num, float min, float max);
    int nk_chart_begin_colored(nk_context*, nk_chart_type, nk_color, nk_color active, int num, float min, float max);
    void nk_chart_add_slot(nk_context* ctx, const(nk_chart_type), int count, float min_value, float max_value);
    void nk_chart_add_slot_colored(nk_context* ctx, const(nk_chart_type), nk_color, nk_color active, int count, float min_value, float max_value);
    nk_flags nk_chart_push(nk_context*, float);
    nk_flags nk_chart_push_slot(nk_context*, float, int);
    void nk_chart_end(nk_context*);
    void nk_plot(nk_context*, nk_chart_type, const(float)* values, int count, int offset);
    void nk_plot_function(nk_context*, nk_chart_type, void *userdata, float function(void* user, int index), int count, int offset);
    int nk_popup_begin(nk_context*, nk_popup_type, const(char)*, nk_flags, nk_rect bounds);
    void nk_popup_close(nk_context*);
    void nk_popup_end(nk_context*);
    void nk_popup_get_scroll(nk_context*, nk_uint *offset_x, nk_uint *offset_y); // 4.01.0
    void nk_popup_set_scroll(nk_context*, nk_uint offset_x, nk_uint offset_y); // 4.01.0
    int nk_combo(nk_context*, const(char)** items, int count, int selected, int item_height, nk_vec2 size);
    int nk_combo_separator(nk_context*, const(char)* items_separated_by_separator, int separator, int selected, int count, int item_height, nk_vec2 size);
    int nk_combo_string(nk_context*, const(char)* items_separated_by_zeros, int selected, int count, int item_height, nk_vec2 size);
    int nk_combo_callback(nk_context*, void function(void*, int, const(char) **), void *userdata, int selected, int count, int item_height, nk_vec2 size);
    void nk_combobox(nk_context*, const(char)** items, int count, int* selected, int item_height, nk_vec2 size);
    void nk_combobox_string(nk_context*, const(char)* items_separated_by_zeros, int* selected, int count, int item_height, nk_vec2 size);
    void nk_combobox_separator(nk_context*, const(char)* items_separated_by_separator, int separator, int* selected, int count, int item_height, nk_vec2 size);
    void nk_combobox_callback(nk_context*, void function(void*, int, const(char) **), void*, int *selected, int count, int item_height, nk_vec2 size);
    int nk_combo_begin_text(nk_context*, const(char)* selected, int, nk_vec2 size);
    int nk_combo_begin_label(nk_context*, const(char)* selected, nk_vec2 size);
    int nk_combo_begin_color(nk_context*, nk_color color, nk_vec2 size);
    int nk_combo_begin_symbol(nk_context*, nk_symbol_type, nk_vec2 size);
    int nk_combo_begin_symbol_label(nk_context*, const(char)* selected, nk_symbol_type, nk_vec2 size);
    int nk_combo_begin_symbol_text(nk_context*, const(char)* selected, int, nk_symbol_type, nk_vec2 size);
    int nk_combo_begin_image(nk_context*, nk_image img, nk_vec2 size);
    int nk_combo_begin_image_label(nk_context*, const(char)* selected, nk_image, nk_vec2 size);
    int nk_combo_begin_image_text(nk_context*, const(char)* selected, int, nk_image, nk_vec2 size);
    int nk_combo_item_label(nk_context*, const(char)*, nk_flags align_ment);
    int nk_combo_item_text(nk_context*, const(char)*, int, nk_flags align_ment);
    int nk_combo_item_image_label(nk_context*, nk_image, const(char)*, nk_flags align_ment);
    int nk_combo_item_image_text(nk_context*, nk_image, const(char)*, int, nk_flags align_ment);
    int nk_combo_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags align_ment);
    int nk_combo_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_ment);
    void nk_combo_close(nk_context*);
    void nk_combo_end(nk_context*);
    int nk_contextual_begin(nk_context*, nk_flags, nk_vec2, nk_rect trigger_bounds);
    int nk_contextual_item_text(nk_context*, const(char)*, int, nk_flags align_);
    int nk_contextual_item_label(nk_context*, const(char)*, nk_flags align_);
    int nk_contextual_item_image_label(nk_context*, nk_image, const(char)*, nk_flags align_ment);
    int nk_contextual_item_image_text(nk_context*, nk_image, const(char)*, int len, nk_flags align_ment);
    int nk_contextual_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags align_ment);
    int nk_contextual_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_ment);
    void nk_contextual_close(nk_context*);
    void nk_contextual_end(nk_context*);
    void nk_tooltip(nk_context*, const(char)*);
    version(NK_INCLUDE_STANDARD_VARARGS) {
        void nk_tooltipf(nk_context*, const(char)*, ...);
        void nk_tooltipfv(nk_context*, const(char)*, va_list);
    }
    int nk_tooltip_begin(nk_context*, float width);
    void nk_tooltip_end(nk_context*);
    void nk_menubar_begin(nk_context*);
    void nk_menubar_end(nk_context*);
    int nk_menu_begin_text(nk_context*, const(char)* title, int title_len, nk_flags align_, nk_vec2 size);
    int nk_menu_begin_label(nk_context*, const(char)*, nk_flags align_, nk_vec2 size);
    int nk_menu_begin_image(nk_context*, const(char)*, nk_image, nk_vec2 size);
    int nk_menu_begin_image_text(nk_context*, const(char)*, int, nk_flags align_, nk_image, nk_vec2 size);
    int nk_menu_begin_image_label(nk_context*, const(char)*, nk_flags align_, nk_image, nk_vec2 size);
    int nk_menu_begin_symbol(nk_context*, const(char)*, nk_symbol_type, nk_vec2 size);
    int nk_menu_begin_symbol_text(nk_context*, const(char)*, int, nk_flags align_, nk_symbol_type, nk_vec2 size);
    int nk_menu_begin_symbol_label(nk_context*, const(char)*, nk_flags align_, nk_symbol_type, nk_vec2 size);
    int nk_menu_item_text(nk_context*, const(char)*, int, nk_flags align_);
    int nk_menu_item_label(nk_context*, const(char)*, nk_flags align_ment);
    int nk_menu_item_image_label(nk_context*, nk_image, const(char)*, nk_flags align_ment);
    int nk_menu_item_image_text(nk_context*, nk_image, const(char)*, int len, nk_flags align_ment);
    int nk_menu_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags align_ment);
    int nk_menu_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags align_ment);
    void nk_menu_close(nk_context*);
    void nk_menu_end(nk_context*);
    void nk_style_default(nk_context*);
    void nk_style_from_table(nk_context*, const(nk_color)*);
    void nk_style_load_cursor(nk_context*, nk_style_cursor, const(nk_cursor)*);
    void nk_style_load_all_cursors(nk_context*, nk_cursor*);
    const(char)* nk_style_get_color_by_name(nk_style_colors);
    void nk_style_set_font(nk_context*, const(nk_user_font)*);
    int nk_style_set_cursor(nk_context*, nk_style_cursor);
    void nk_style_show_cursor(nk_context*);
    void nk_style_hide_cursor(nk_context*);
    int nk_style_push_font(nk_context*, const(nk_user_font)*);
    int nk_style_push_float(nk_context*, float*, float);
    int nk_style_push_vec2(nk_context*, nk_vec2*, nk_vec2);
    int nk_style_push_style_item(nk_context*, nk_style_item*, nk_style_item);
    int nk_style_push_flags(nk_context*, nk_flags*, nk_flags);
    int nk_style_push_color(nk_context*, nk_color*, nk_color);
    int nk_style_pop_font(nk_context*);
    int nk_style_pop_float(nk_context*);
    int nk_style_pop_vec2(nk_context*);
    int nk_style_pop_style_item(nk_context*);
    int nk_style_pop_flags(nk_context*);
    int nk_style_pop_color(nk_context*);
    nk_color nk_rgb(int r, int g, int b);
    nk_color nk_rgb_iv(const(int)* rgb);
    nk_color nk_rgb_bv(const(nk_byte)* rgb);
    nk_color nk_rgb_f(float r, float g, float b);
    nk_color nk_rgb_fv(const(float)* rgb);
    nk_color nk_rgb_cf(nk_colorf c);
    nk_color nk_rgb_hex(const(char)* rgb);
    nk_color nk_rgba(int r, int g, int b, int a);
    nk_color nk_rgba_u32(nk_uint);
    nk_color nk_rgba_iv(const(int)* rgba);
    nk_color nk_rgba_bv(const(nk_byte)* rgba);
    nk_color nk_rgba_f(float r, float g, float b, float a);
    nk_color nk_rgba_fv(const(float)* rgba);
    nk_color nk_rgba_cf(nk_colorf c);
    nk_color nk_rgba_hex(const(char)* rgb);
    nk_colorf nk_hsva_colorf(float h, float s, float v, float a);
    nk_colorf nk_hsva_colorfv(float* c);
    void nk_colorf_hsva_f(float* out_h, float* out_s, float* out_v, float* out_a, nk_colorf in_);
    void nk_colorf_hsva_fv(float* hsva, nk_colorf in_);
    nk_color nk_hsv(int h, int s, int v);
    nk_color nk_hsv_iv(const(int)* hsv);
    nk_color nk_hsv_bv(const(nk_byte)* hsv);
    nk_color nk_hsv_f(float h, float s, float v);
    nk_color nk_hsv_fv(const(float)* hsv);
    nk_color nk_hsva(int h, int s, int v, int a);
    nk_color nk_hsva_iv(const(int)* hsva);
    nk_color nk_hsva_bv(const(nk_byte)* hsva);
    nk_color nk_hsva_f(float h, float s, float v, float a);
    nk_color nk_hsva_fv(const(float)* hsva);
    void nk_color_f(float* r, float* g, float* b, float* a, nk_color);
    void nk_color_fv(float* rgba_out, nk_color);
    nk_colorf nk_color_cf(nk_color);
    void nk_color_d(double* r, double* g, double* b, double* a, nk_color);
    void nk_color_dv(double* rgba_out, nk_color);
    nk_uint nk_color_u32(nk_color);
    void nk_color_hex_rgba(char* output, nk_color);
    void nk_color_hex_rgb(char* output, nk_color);
    void nk_color_hsv_i(int* out_h, int* out_s, int* out_v, nk_color);
    void nk_color_hsv_b(nk_byte* out_h, nk_byte* out_s, nk_byte* out_v, nk_color);
    void nk_color_hsv_iv(int* hsv_out, nk_color);
    void nk_color_hsv_bv(nk_byte* hsv_out, nk_color);
    void nk_color_hsv_f(float* out_h, float* out_s, float* out_v, nk_color);
    void nk_color_hsv_fv(float* hsv_out, nk_color);
    void nk_color_hsva_i(int* h, int* s, int* v, int* a, nk_color);
    void nk_color_hsva_b(nk_byte* h, nk_byte* s, nk_byte* v, nk_byte* a, nk_color);
    void nk_color_hsva_iv(int* hsva_out, nk_color);
    void nk_color_hsva_bv(nk_byte* hsva_out, nk_color);
    void nk_color_hsva_f(float* out_h, float* out_s, float* out_v, float* out_a, nk_color);
    void nk_color_hsva_fv(float* hsva_out, nk_color);
    nk_handle nk_handle_ptr(void*);
    nk_handle nk_handle_id(int);
    nk_image nk_image_handle(nk_handle);
    nk_image nk_image_ptr(void*);
    nk_image nk_image_id(int);
    int nk_image_is_subimage(const(nk_image)* img);
    nk_image nk_subimage_ptr(void*, ushort w, ushort h, nk_rect sub_region);
    nk_image nk_subimage_id(int, ushort w, ushort h, nk_rect sub_region);
    nk_image nk_subimage_handle(nk_handle, ushort w, ushort h, nk_rect sub_region);
    nk_hash nk_murmur_hash(const(void)* key, int len, nk_hash seed);
    void nk_triangle_from_direction(nk_vec2* result, nk_rect r, float pad_x, float pad_y, nk_heading);
    pragma(mangle, "nk_vec2")
        nk_vec2 nk_vec2_(float x, float y);
    pragma(mangle, "nk_vec2i")
        nk_vec2 nk_vec2i_(int x, int y);
    nk_vec2 nk_vec2v(const(float)* xy);
    nk_vec2 nk_vec2iv(const(int)* xy);
    nk_rect nk_get_null_rect();
    pragma(mangle, "nk_rect")
        nk_rect nk_rect_(float x, float y, float w, float h);
    nk_rect nk_recti(int x, int y, int w, int h);
    nk_rect nk_recta(nk_vec2 pos, nk_vec2 size);
    nk_rect nk_rectv(const(float)* xywh);
    nk_rect nk_rectiv(const(int)* xywh);
    nk_vec2 nk_rect_pos(nk_rect);
    nk_vec2 nk_rect_size(nk_rect);
    int nk_strlen(const(char)* str);
    int nk_stricmp(const(char)* s1, const(char)* s2);
    int nk_stricmpn(const(char)* s1, const(char)* s2, int n);
    int nk_strtoi(const(char)* str, const(char)** endptr);
    float nk_strtof(const(char)* str, const(char)** endptr);
    double nk_strtod(const(char)* str, const(char)** endptr);
    int nk_strfilter(const(char)* text, const(char)* regexp);
    int nk_strmatch_fuzzy_string(const(char)* str, const(char)* pattern, int* out_score);
    int nk_strmatch_fuzzy_text(const(char)* txt, int txt_len, const(char)* pattern, int* out_score);
    int nk_utf_decode(const(char)*, nk_rune*, int);
    int nk_utf_encode(nk_rune, char*, int);
    int nk_utf_len(const(char)*, int byte_len);
    const(char)* nk_utf_at(const(char)* buffer, int length, int index, nk_rune* unicode, int* len);
    version(NK_INCLUDE_FONT_BAKING) {
        const(nk_rune)* nk_font_default_glyph_ranges();
        const(nk_rune)* nk_font_chinese_glyph_ranges();
        const(nk_rune)* nk_font_cyrillic_glyph_ranges();
        const(nk_rune)* nk_font_korean_glyph_ranges();
        version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
            void nk_font_atlas_init_default(nk_font_atlas*);
        }
        void nk_font_atlas_init(nk_font_atlas*, nk_allocator*);
        void nk_font_atlas_init_custom(nk_font_atlas*, nk_allocator* persistent, nk_allocator* transient);
        void nk_font_atlas_begin(nk_font_atlas*);
        pragma(mangle, "nk_font_config")
            nk_font_config nk_font_config_(float pixel_height);
        nk_font* nk_font_atlas_add(nk_font_atlas*, const(nk_font_config)*);
        version(NK_INCLUDE_DEFAULT_FONT) {
            nk_font* nk_font_atlas_add_default(nk_font_atlas*, float height, const(nk_font_config)*);
        }
        nk_font* nk_font_atlas_add_from_memory(nk_font_atlas* atlas, void* memory, nk_size size, float height, const(nk_font_config)* config);
        version(NK_INCLUDE_STANDARD_IO) {
            nk_font* nk_font_atlas_add_from_file(nk_font_atlas* atlas, const(char)* file_path, float height, const(nk_font_config)*);
        }
        nk_font* nk_font_atlas_add_compressed(nk_font_atlas*, void* memory, nk_size size, float height, const(nk_font_config)*);
        nk_font* nk_font_atlas_add_compressed_base85(nk_font_atlas*, const(char)* data, float height, const(nk_font_config)* config);
        const(void)* nk_font_atlas_bake(nk_font_atlas*, int* width, int* height, nk_font_atlas_format);
        void nk_font_atlas_end(nk_font_atlas*, nk_handle tex, nk_draw_null_texture*);
        const(nk_font_glyph)* nk_font_find_glyph(nk_font*, nk_rune unicode);
        void nk_font_atlas_cleanup(nk_font_atlas* atlas);
        void nk_font_atlas_clear(nk_font_atlas*);
    }
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        void nk_buffer_init_default(nk_buffer*);
    }
    void nk_buffer_init(nk_buffer*, const(nk_allocator)*, nk_size size);
    void nk_buffer_init_fixed(nk_buffer*, void* memory, nk_size size);
    void nk_buffer_info(nk_memory_status*, nk_buffer*);
    void nk_buffer_push(nk_buffer*, nk_buffer_allocation_type type, const(void)* memory, nk_size size, nk_size align_);
    void nk_buffer_mark(nk_buffer*, nk_buffer_allocation_type type);
    void nk_buffer_reset(nk_buffer*, nk_buffer_allocation_type type);
    void nk_buffer_clear(nk_buffer*);
    void nk_buffer_free(nk_buffer*);
    void* nk_buffer_memory(nk_buffer*);
    const(void)* nk_buffer_memory_const(const(nk_buffer)*);
    nk_size nk_buffer_total(nk_buffer*);
    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        void nk_str_init_default(nk_str*);
    }
    void nk_str_init(nk_str*, const(nk_allocator)*, nk_size size);
    void nk_str_init_fixed(nk_str*, void* memory, nk_size size);
    void nk_str_clear(nk_str*);
    void nk_str_free(nk_str*);
    int nk_str_append_text_char(nk_str*, const(char)*, int);
    int nk_str_append_str_char(nk_str*, const(char)*);
    int nk_str_append_text_utf8(nk_str*, const(char)*, int);
    int nk_str_append_str_utf8(nk_str*, const(char)*);
    int nk_str_append_text_runes(nk_str*, const(nk_rune)*, int);
    int nk_str_append_str_runes(nk_str*, const(nk_rune)*);
    int nk_str_insert_at_char(nk_str*, int pos, const(char)*, int);
    int nk_str_insert_at_rune(nk_str*, int pos, const(char)*, int);
    int nk_str_insert_text_char(nk_str*, int pos, const(char)*, int);
    int nk_str_insert_str_char(nk_str*, int pos, const(char)*);
    int nk_str_insert_text_utf8(nk_str*, int pos, const(char)*, int);
    int nk_str_insert_str_utf8(nk_str*, int pos, const(char)*);
    int nk_str_insert_text_runes(nk_str*, int pos, const(nk_rune)*, int);
    int nk_str_insert_str_runes(nk_str*, int pos, const(nk_rune)*);
    void nk_str_remove_chars(nk_str*, int len);
    void nk_str_remove_runes(nk_str* str, int len);
    void nk_str_delete_chars(nk_str*, int pos, int len);
    void nk_str_delete_runes(nk_str*, int pos, int len);
    char* nk_str_at_char(nk_str*, int pos);
    char* nk_str_at_rune(nk_str*, int pos, nk_rune* unicode, int* len);
    nk_rune nk_str_rune_at(const(nk_str)*, int pos);
    const(char)* nk_str_at_char_const(const(nk_str)*, int pos);
    const(char)* nk_str_at_const(const(nk_str)*, int pos, nk_rune* unicode, int* len);
    char* nk_str_get(nk_str*);
    const(char)* nk_str_get_const(const(nk_str)*);
    int nk_str_len(nk_str*);
    int nk_str_len_char(nk_str*);
    int nk_filter_default(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_ascii(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_float(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_decimal(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_hex(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_oct(const(nk_text_edit)*, nk_rune unicode);
    int nk_filter_binary(const(nk_text_edit)*, nk_rune unicode);

    auto nk_filter_default_fptr = &nk_filter_default;
    auto nk_filter_ascii_fptr   = &nk_filter_ascii;
    auto nk_filter_float_fptr   = &nk_filter_float;
    auto nk_filter_decimal_fptr = &nk_filter_decimal;
    auto nk_filter_hex_fptr     = &nk_filter_hex;
    auto nk_filter_oct_fptr     = &nk_filter_oct;
    auto nk_filter_binary_fptr  = &nk_filter_binary;

    version(NK_INCLUDE_DEFAULT_ALLOCATOR) {
        void nk_textedit_init_default(nk_text_edit*);
    }
    void nk_textedit_init(nk_text_edit*, nk_allocator*, nk_size size);
    void nk_textedit_init_fixed(nk_text_edit*, void* memory, nk_size size);
    void nk_textedit_free(nk_text_edit*);
    void nk_textedit_text(nk_text_edit*, const(char)*, int total_len);
    void nk_textedit_delete(nk_text_edit*, int where, int len);
    void nk_textedit_delete_selection(nk_text_edit*);
    void nk_textedit_select_all(nk_text_edit*);
    int nk_textedit_cut(nk_text_edit*);
    int nk_textedit_paste(nk_text_edit*, const(char)*, int len);
    void nk_textedit_undo(nk_text_edit*);
    void nk_textedit_redo(nk_text_edit*);
    void nk_stroke_line(nk_command_buffer* b, float x0, float y0, float x1, float y1, float line_thickness, nk_color);
    void nk_stroke_curve(nk_command_buffer*, float, float, float, float, float, float, float, float, float line_thickness, nk_color);
    void nk_stroke_rect(nk_command_buffer*, nk_rect, float rounding, float line_thickness, nk_color);
    void nk_stroke_circle(nk_command_buffer*, nk_rect, float line_thickness, nk_color);
    void nk_stroke_arc(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, float line_thickness, nk_color);
    void nk_stroke_triangle(nk_command_buffer*, float, float, float, float, float, float, float line_thichness, nk_color);
    void nk_stroke_polyline(nk_command_buffer*, float* points, int point_count, float line_thickness, nk_color col);
    void nk_stroke_polygon(nk_command_buffer*, float*, int point_count, float line_thickness, nk_color);
    void nk_fill_rect(nk_command_buffer*, nk_rect, float rounding, nk_color);
    void nk_fill_rect_multi_color(nk_command_buffer*, nk_rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
    void nk_fill_circle(nk_command_buffer*, nk_rect, nk_color);
    void nk_fill_arc(nk_command_buffer*, float cx, float cy, float radius, float a_min, float a_max, nk_color);
    void nk_fill_triangle(nk_command_buffer*, float x0, float y0, float x1, float y1, float x2, float y2, nk_color);
    void nk_fill_polygon(nk_command_buffer*, float*, int point_count, nk_color);
    void nk_draw_image(nk_command_buffer*, nk_rect, const(nk_image)*, nk_color);
    void nk_draw_text(nk_command_buffer*, nk_rect, const(char)* text, int len, const(nk_user_font)*, nk_color, nk_color);
    void nk_push_scissor(nk_command_buffer*, nk_rect);
    void nk_push_custom(nk_command_buffer*, nk_rect, nk_command_custom_callback, nk_handle usr);
    int nk_input_has_mouse_click(const(nk_input)*, nk_buttons);
    int nk_input_has_mouse_click_in_rect(const(nk_input)*, nk_buttons, nk_rect);
    int nk_input_has_mouse_click_down_in_rect(const(nk_input)*, nk_buttons, nk_rect, int down);
    int nk_input_is_mouse_click_in_rect(const(nk_input)*, nk_buttons, nk_rect);
    int nk_input_is_mouse_click_down_in_rect(const(nk_input)* i, nk_buttons id, nk_rect b, int down);
    int nk_input_any_mouse_click_in_rect(const(nk_input)*, nk_rect);
    int nk_input_is_mouse_prev_hovering_rect(const(nk_input)*, nk_rect);
    int nk_input_is_mouse_hovering_rect(const(nk_input)*, nk_rect);
    int nk_input_mouse_clicked(const(nk_input)*, nk_buttons, nk_rect);
    int nk_input_is_mouse_down(const(nk_input)*, nk_buttons);
    int nk_input_is_mouse_pressed(const(nk_input)*, nk_buttons);
    int nk_input_is_mouse_released(const(nk_input)*, nk_buttons);
    int nk_input_is_key_pressed(const(nk_input)*, nk_keys);
    int nk_input_is_key_released(const(nk_input)*, nk_keys);
    int nk_input_is_key_down(const(nk_input)*, nk_keys);
    version(NK_INCLUDE_VERTEX_BUFFER_OUTPUT) {
        void nk_draw_list_init(nk_draw_list*);
        void nk_draw_list_setup(nk_draw_list*, const(nk_convert_config)*, nk_buffer* cmds, nk_buffer* vertices, nk_buffer* elements, nk_anti_aliasing line_aa, nk_anti_aliasing shape_aa);
        const(nk_draw_command)* nk__draw_list_begin(const(nk_draw_list)*, const(nk_buffer)*);
        const(nk_draw_command)* nk__draw_list_next(const(nk_draw_command)*, const(nk_buffer)*, const(nk_draw_list)*);
        const(nk_draw_command)* nk__draw_list_end(const(nk_draw_list)*, const(nk_buffer)*);
        void nk_draw_list_path_clear(nk_draw_list*);
        void nk_draw_list_path_line_to(nk_draw_list*, nk_vec2 pos);
        void nk_draw_list_path_arc_to_fast(nk_draw_list*, nk_vec2 center, float radius, int a_min, int a_max);
        void nk_draw_list_path_arc_to(nk_draw_list*, nk_vec2 center, float radius, float a_min, float a_max, uint segments);
        void nk_draw_list_path_rect_to(nk_draw_list*, nk_vec2 a, nk_vec2 b, float rounding);
        void nk_draw_list_path_curve_to(nk_draw_list*, nk_vec2 p2, nk_vec2 p3, nk_vec2 p4, uint num_segments);
        void nk_draw_list_path_fill(nk_draw_list*, nk_color);
        void nk_draw_list_path_stroke(nk_draw_list*, nk_color, nk_draw_list_stroke closed, float thickness);
        void nk_draw_list_stroke_line(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_color, float thickness);
        void nk_draw_list_stroke_rect(nk_draw_list*, nk_rect rect, nk_color, float rounding, float thickness);
        void nk_draw_list_stroke_triangle(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color, float thickness);
        void nk_draw_list_stroke_circle(nk_draw_list*, nk_vec2 center, float radius, nk_color, uint segs, float thickness);
        void nk_draw_list_stroke_curve(nk_draw_list*, nk_vec2 p0, nk_vec2 cp0, nk_vec2 cp1, nk_vec2 p1, nk_color, uint segments, float thickness);
        void nk_draw_list_stroke_poly_line(nk_draw_list*, const(nk_vec2)* pnts, const(uint) cnt, nk_color, nk_draw_list_stroke, float thickness, nk_anti_aliasing);
        void nk_draw_list_fill_rect(nk_draw_list*, nk_rect rect, nk_color, float rounding);
        void nk_draw_list_fill_rect_multi_color(nk_draw_list*, nk_rect rect, nk_color left, nk_color top, nk_color right, nk_color bottom);
        void nk_draw_list_fill_triangle(nk_draw_list*, nk_vec2 a, nk_vec2 b, nk_vec2 c, nk_color);
        void nk_draw_list_fill_circle(nk_draw_list*, nk_vec2 center, float radius, nk_color col, uint segs);
        void nk_draw_list_fill_poly_convex(nk_draw_list*, const(nk_vec2)* points, const(uint) count, nk_color, nk_anti_aliasing);
        void nk_draw_list_add_image(nk_draw_list*, nk_image texture, nk_rect rect, nk_color);
        void nk_draw_list_add_text(nk_draw_list*, const(nk_user_font)*, nk_rect, const(char)* text, int len, float font_height, nk_color);
        version(NK_INCLUDE_COMMAND_USERDATA) {
            void nk_draw_list_push_userdata(nk_draw_list*, nk_handle userdata);
        }
    }
    nk_style_item nk_style_item_image(nk_image img);
    nk_style_item nk_style_item_color(nk_color);
    nk_style_item nk_style_item_hide();
}
