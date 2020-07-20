module node_editor;

import bindbc.nuklear;

import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import core.stdc.math;

struct node {
    int ID;
    char[32] name;
    nk_rect bounds;
    float value;
    nk_color color;
    int input_count;
    int output_count;
    node *next;
    node *prev;
}

struct node_link {
    int input_id;
    int input_slot;
    int output_id;
    int output_slot;
    nk_vec2 in_;
    nk_vec2 out_;
}

struct node_linking {
    int active;
    node *node_;
    int input_id;
    int input_slot;
}

struct node_editor_ {
    int initialized;
    node[32] node_buf;
    node_link[64] links;
    node *begin;
    node *end;
    int node_count;
    int link_count;
    nk_rect bounds;
    node *selected;
    int show_grid;
    nk_vec2 scrolling;
    node_linking linking;
}

node_editor_ nodeEditor;

static void
node_editor_push(node_editor_ *editor, node *node)
{
    if (!editor.begin) {
        node.next = null;
        node.prev = null;
        editor.begin = node;
        editor.end = node;
    } else {
        node.prev = editor.end;
        if (editor.end)
            editor.end.next = node;
        node.next = null;
        editor.end = node;
    }
}

static void
node_editor_pop(node_editor_ *editor, node *node)
{
    if (node.next)
        node.next.prev = node.prev;
    if (node.prev)
        node.prev.next = node.next;
    if (editor.end == node)
        editor.end = node.prev;
    if (editor.begin == node)
        editor.begin = node.next;
    node.next = null;
    node.prev = null;
}

static node*
node_editor_find(node_editor_ *editor, int ID)
{
    node *iter = editor.begin;
    while (iter) {
        if (iter.ID == ID)
            return iter;
        iter = iter.next;
    }
    return null;
}

static void
node_editor_add(node_editor_ *editor, const(char) *name, nk_rect bounds,
                nk_color col, int in_count, int out_count)
{
    static int IDs = 0;
    node *node;
    assert(cast(nk_size)editor.node_count < editor.node_buf.length);
    node = &editor.node_buf[editor.node_count++];
    node.ID = IDs++;
    node.value = 0;
    node.color = nk_rgb(255, 0, 0);
    node.input_count = in_count;
    node.output_count = out_count;
    node.color = col;
    node.bounds = bounds;
    strcpy(node.name.ptr, name);
    node_editor_push(editor, node);
}

static void
node_editor_link(node_editor_ *editor, int in_id, int in_slot,
                 int out_id, int out_slot)
{
    node_link *link;
    assert(cast(nk_size)editor.link_count < editor.links.length);
    link = &editor.links[editor.link_count++];
    link.input_id = in_id;
    link.input_slot = in_slot;
    link.output_id = out_id;
    link.output_slot = out_slot;
}

static void
node_editor_init(node_editor_ *editor)
{
    memset(editor, 0, (*editor).sizeof);
    editor.begin = null;
    editor.end = null;
    node_editor_add(editor, "Source", nk_rect(40, 10, 180, 220), nk_rgb(255, 0, 0), 0, 1);
    node_editor_add(editor, "Source", nk_rect(40, 260, 180, 220), nk_rgb(0, 255, 0), 0, 1);
    node_editor_add(editor, "Combine", nk_rect(400, 100, 180, 220), nk_rgb(0,0,255), 2, 2);
    node_editor_link(editor, 0, 0, 2, 0);
    node_editor_link(editor, 1, 0, 2, 1);
    editor.show_grid = nk_true;
}

static int
node_editor(nk_context *ctx)
{
    int n = 0;
    nk_rect total_space;
    const(nk_input) *in_ = &ctx.input;
    nk_command_buffer *canvas;
    node *updated = null;
    node_editor_ *nodedit = &nodeEditor;

    if (!nodeEditor.initialized) {
        node_editor_init(&nodeEditor);
        nodeEditor.initialized = 1;
    }

    if (nk_begin(ctx, "NodeEdit", nk_rect(0, 0, 800, 600),
                 NK_WINDOW_BORDER|NK_WINDOW_NO_SCROLLBAR|NK_WINDOW_MOVABLE|NK_WINDOW_CLOSABLE))
    {
        /* allocate complete window space */
        canvas = nk_window_get_canvas(ctx);
        total_space = nk_window_get_content_region(ctx);
        nk_layout_space_begin(ctx, NK_STATIC, total_space.h, nodedit.node_count);
        {
            node *it = nodedit.begin;
            nk_rect size = nk_layout_space_bounds(ctx);
            nk_panel *node_panel = null;

            if (nodedit.show_grid) {
                /* display grid */
                float x, y;
                const float grid_size = 32.0f;
                const nk_color grid_color = nk_rgb(50, 50, 50);
                for (x = cast(float)fmod(size.x - nodedit.scrolling.x, grid_size); x < size.w; x += grid_size)
                    nk_stroke_line(canvas, x+size.x, size.y, x+size.x, size.y+size.h, 1.0f, grid_color);
                for (y = cast(float)fmod(size.y - nodedit.scrolling.y, grid_size); y < size.h; y += grid_size)
                    nk_stroke_line(canvas, size.x, y+size.y, size.x+size.w, y+size.y, 1.0f, grid_color);
            }

            /* execute each node as a movable group */
            while (it) {
                /* calculate scrolled node window position and size */
                nk_layout_space_push(ctx, nk_rect(it.bounds.x - nodedit.scrolling.x,
                                                  it.bounds.y - nodedit.scrolling.y, it.bounds.w, it.bounds.h));

                /* execute node window */
                if (nk_group_begin(ctx, it.name.ptr, NK_WINDOW_MOVABLE|NK_WINDOW_NO_SCROLLBAR|NK_WINDOW_BORDER|NK_WINDOW_TITLE))
                {
                    /* always have last selected node on top */

                    node_panel = nk_window_get_panel(ctx);
                    if (nk_input_mouse_clicked(in_, NK_BUTTON_LEFT, node_panel.bounds) &&
                        (!(it.prev && nk_input_mouse_clicked(in_, NK_BUTTON_LEFT,
                                                              nk_layout_space_rect_to_screen(ctx, node_panel.bounds)))) &&
                        nodedit.end != it)
                    {
                        updated = it;
                    }

                    /* ================= NODE CONTENT =====================*/
                    nk_layout_row_dynamic(ctx, 25, 1);
                    nk_button_color(ctx, it.color);
                    it.color.r = cast(nk_byte)nk_propertyi(ctx, "#R:", 0, it.color.r, 255, 1,1);
                    it.color.g = cast(nk_byte)nk_propertyi(ctx, "#G:", 0, it.color.g, 255, 1,1);
                    it.color.b = cast(nk_byte)nk_propertyi(ctx, "#B:", 0, it.color.b, 255, 1,1);
                    it.color.a = cast(nk_byte)nk_propertyi(ctx, "#A:", 0, it.color.a, 255, 1,1);
                    /* ====================================================*/
                    nk_group_end(ctx);
                }
                {
                    /* node connector and linking */
                    float space;
                    nk_rect bounds;
                    bounds = nk_layout_space_rect_to_local(ctx, node_panel.bounds);
                    bounds.x += nodedit.scrolling.x;
                    bounds.y += nodedit.scrolling.y;
                    it.bounds = bounds;

                    /* output connector */
                    space = node_panel.bounds.h / cast(float)((it.output_count) + 1);
                    for (n = 0; n < it.output_count; ++n) {
                        nk_rect circle;
                        circle.x = node_panel.bounds.x + node_panel.bounds.w-4;
                        circle.y = node_panel.bounds.y + space * cast(float)(n+1);
                        circle.w = 8; circle.h = 8;
                        nk_fill_circle(canvas, circle, nk_rgb(100, 100, 100));

                        /* start linking process */
                        if (nk_input_has_mouse_click_down_in_rect(in_, NK_BUTTON_LEFT, circle, nk_true)) {
                            nodedit.linking.active = nk_true;
                            nodedit.linking.node_ = it;
                            nodedit.linking.input_id = it.ID;
                            nodedit.linking.input_slot = n;
                        }

                        /* draw curve from linked node slot to mouse position */
                        if (nodedit.linking.active && nodedit.linking.node_ == it &&
                            nodedit.linking.input_slot == n) {
                                nk_vec2 l0 = nk_vec2(circle.x + 3, circle.y + 3);
                                nk_vec2 l1 = in_.mouse.pos;
                                nk_stroke_curve(canvas, l0.x, l0.y, l0.x + 50.0f, l0.y,
                                                l1.x - 50.0f, l1.y, l1.x, l1.y, 1.0f, nk_rgb(100, 100, 100));
                            }
                    }

                    /* input connector */
                    space = node_panel.bounds.h / cast(float)((it.input_count) + 1);
                    for (n = 0; n < it.input_count; ++n) {
                        nk_rect circle;
                        circle.x = node_panel.bounds.x-4;
                        circle.y = node_panel.bounds.y + space * cast(float)(n+1);
                        circle.w = 8; circle.h = 8;
                        nk_fill_circle(canvas, circle, nk_rgb(100, 100, 100));
                        if (nk_input_is_mouse_released(in_, NK_BUTTON_LEFT) &&
                            nk_input_is_mouse_hovering_rect(in_, circle) &&
                            nodedit.linking.active && nodedit.linking.node_ != it) {
                                nodedit.linking.active = nk_false;
                                node_editor_link(nodedit, nodedit.linking.input_id,
                                                 nodedit.linking.input_slot, it.ID, n);
                            }
                    }
                }
                it = it.next;
            }

            /* reset linking connection */
            if (nodedit.linking.active && nk_input_is_mouse_released(in_, NK_BUTTON_LEFT)) {
                nodedit.linking.active = nk_false;
                nodedit.linking.node_ = null;
                fprintf(stdout, "linking failed\n");
            }

            /* draw each link */
            for (n = 0; n < nodedit.link_count; ++n) {
                node_link *link = &nodedit.links[n];
                node *ni = node_editor_find(nodedit, link.input_id);
                node *no = node_editor_find(nodedit, link.output_id);
                float spacei = node_panel.bounds.h / cast(float)((ni.output_count) + 1);
                float spaceo = node_panel.bounds.h / cast(float)((no.input_count) + 1);
                nk_vec2 l0 = nk_layout_space_to_screen(ctx,
                                                              nk_vec2(ni.bounds.x + ni.bounds.w, 3.0f + ni.bounds.y + spacei * cast(float)(link.input_slot+1)));
                nk_vec2 l1 = nk_layout_space_to_screen(ctx,
                                                              nk_vec2(no.bounds.x, 3.0f + no.bounds.y + spaceo * cast(float)(link.output_slot+1)));

                l0.x -= nodedit.scrolling.x;
                l0.y -= nodedit.scrolling.y;
                l1.x -= nodedit.scrolling.x;
                l1.y -= nodedit.scrolling.y;
                nk_stroke_curve(canvas, l0.x, l0.y, l0.x + 50.0f, l0.y,
                                l1.x - 50.0f, l1.y, l1.x, l1.y, 1.0f, nk_rgb(100, 100, 100));
            }

            if (updated) {
                /* reshuffle nodes to have least recently selected node on top */
                node_editor_pop(nodedit, updated);
                node_editor_push(nodedit, updated);
            }

            /* node selection */
            if (nk_input_mouse_clicked(in_, NK_BUTTON_LEFT, nk_layout_space_bounds(ctx))) {
                it = nodedit.begin;
                nodedit.selected = null;
                nodedit.bounds = nk_rect(in_.mouse.pos.x, in_.mouse.pos.y, 100, 200);
                while (it) {
                    nk_rect b = nk_layout_space_rect_to_screen(ctx, it.bounds);
                    b.x -= nodedit.scrolling.x;
                    b.y -= nodedit.scrolling.y;
                    if (nk_input_is_mouse_hovering_rect(in_, b))
                        nodedit.selected = it;
                    it = it.next;
                }
            }

            /* contextual menu */
            if (nk_contextual_begin(ctx, 0, nk_vec2(100, 220), nk_window_get_bounds(ctx))) {
                const(char) *[2]grid_option = ["Show Grid", "Hide Grid"];
                nk_layout_row_dynamic(ctx, 25, 1);
                if (nk_contextual_item_label(ctx, "New", NK_TEXT_CENTERED))
                    node_editor_add(nodedit, "New", nk_rect(400, 260, 180, 220),
                                    nk_rgb(255, 255, 255), 1, 2);
                if (nk_contextual_item_label(ctx, grid_option[nodedit.show_grid],NK_TEXT_CENTERED))
                    nodedit.show_grid = !nodedit.show_grid;
                nk_contextual_end(ctx);
            }
        }
        nk_layout_space_end(ctx);

        /* window content scrolling */
        if (nk_input_is_mouse_hovering_rect(in_, nk_window_get_bounds(ctx)) &&
            nk_input_is_mouse_down(in_, NK_BUTTON_MIDDLE)) {
                nodedit.scrolling.x += in_.mouse.delta.x;
                nodedit.scrolling.y += in_.mouse.delta.y;
            }
    }
    nk_end(ctx);
    return !nk_window_is_closed(ctx, "NodeEdit");
}
