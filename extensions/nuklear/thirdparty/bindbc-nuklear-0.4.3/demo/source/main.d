import bindbc.sdl;
import bindbc.opengl;
import bindbc.nuklear;

import core.stdc.string;
import core.stdc.stdlib;
import core.stdc.math;
import core.stdc.stdio;

import overview;
import calculator;
import style;
import node_editor;

struct nk_sdl_device {
    nk_buffer cmds;
    nk_draw_null_texture null_;
    GLuint vbo, vao, ebo;
    GLuint prog;
    GLuint vert_shdr;
    GLuint frag_shdr;
    GLint attrib_pos;
    GLint attrib_uv;
    GLint attrib_col;
    GLint uniform_tex;
    GLint uniform_proj;
    GLuint font_tex;
}

struct nk_sdl_vertex {
    float[2] position;
    float[2] uv;
    nk_byte[4] col;
};

struct nk_sdl {
    SDL_Window *win;
    nk_sdl_device ogl;
    nk_context ctx;
    nk_font_atlas atlas;
}

nk_sdl sdl;

void
nk_sdl_device_create()
{
    GLint status;
    const(GLchar*) vertex_shader =
        q{
            #version 300 es
            uniform mat4 ProjMtx;
            in vec2 Position;
            in vec2 TexCoord;
            in vec4 Color;
            out vec2 Frag_UV;
            out vec4 Frag_Color;
            void main() {
                Frag_UV = TexCoord;
                Frag_Color = Color;
                gl_Position = ProjMtx * vec4(Position.xy, 0, 1);
            }
        };
    const(GLchar*) fragment_shader =
        q{
            #version 300 es
            precision mediump float;
            uniform sampler2D Texture;
            in vec2 Frag_UV;
            in vec4 Frag_Color;
            out vec4 Out_Color;
            void main(){
                Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
            }
        };

    nk_sdl_device *dev = &sdl.ogl;
    nk_buffer_init_default(&dev.cmds);
    dev.prog = glCreateProgram();
    dev.vert_shdr = glCreateShader(GL_VERTEX_SHADER);
    dev.frag_shdr = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(dev.vert_shdr, 1, &vertex_shader, null);
    glShaderSource(dev.frag_shdr, 1, &fragment_shader, null);
    glCompileShader(dev.vert_shdr);
    glCompileShader(dev.frag_shdr);
    glGetShaderiv(dev.vert_shdr, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    glGetShaderiv(dev.frag_shdr, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    glAttachShader(dev.prog, dev.vert_shdr);
    glAttachShader(dev.prog, dev.frag_shdr);
    glLinkProgram(dev.prog);
    glGetProgramiv(dev.prog, GL_LINK_STATUS, &status);
    assert(status == GL_TRUE);

    dev.uniform_tex = glGetUniformLocation(dev.prog, "Texture");
    dev.uniform_proj = glGetUniformLocation(dev.prog, "ProjMtx");
    dev.attrib_pos = glGetAttribLocation(dev.prog, "Position");
    dev.attrib_uv = glGetAttribLocation(dev.prog, "TexCoord");
    dev.attrib_col = glGetAttribLocation(dev.prog, "Color");

    {
        /* buffer setup */
        GLsizei vs = nk_sdl_vertex.sizeof;
        size_t vp = nk_sdl_vertex.position.offsetof;
        size_t vt = nk_sdl_vertex.uv.offsetof;
        size_t vc = nk_sdl_vertex.col.offsetof;

        glGenBuffers(1, &dev.vbo);
        glGenBuffers(1, &dev.ebo);
        glGenVertexArrays(1, &dev.vao);

        glBindVertexArray(dev.vao);
        glBindBuffer(GL_ARRAY_BUFFER, dev.vbo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo);

        glEnableVertexAttribArray(cast(GLuint)dev.attrib_pos);
        glEnableVertexAttribArray(cast(GLuint)dev.attrib_uv);
        glEnableVertexAttribArray(cast(GLuint)dev.attrib_col);

        glVertexAttribPointer(cast(GLuint)dev.attrib_pos, 2, GL_FLOAT, GL_FALSE, vs, cast(void*)vp);
        glVertexAttribPointer(cast(GLuint)dev.attrib_uv, 2, GL_FLOAT, GL_FALSE, vs, cast(void*)vt);
        glVertexAttribPointer(cast(GLuint)dev.attrib_col, 4, GL_UNSIGNED_BYTE, GL_TRUE, vs, cast(void*)vc);
    }

    glBindTexture(GL_TEXTURE_2D, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}

void
nk_sdl_device_upload_atlas(const void *image, int width, int height)
{
    nk_sdl_device *dev = &sdl.ogl;
    glGenTextures(1, &dev.font_tex);
    glBindTexture(GL_TEXTURE_2D, dev.font_tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, cast(GLsizei)width, cast(GLsizei)height, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, image);
}

void
nk_sdl_device_destroy()
{
    nk_sdl_device* dev = &sdl.ogl;
    glDetachShader(dev.prog, dev.vert_shdr);
    glDetachShader(dev.prog, dev.frag_shdr);
    glDeleteShader(dev.vert_shdr);
    glDeleteShader(dev.frag_shdr);
    glDeleteProgram(dev.prog);
    glDeleteTextures(1, &dev.font_tex);
    glDeleteBuffers(1, &dev.vbo);
    glDeleteBuffers(1, &dev.ebo);
    nk_buffer_free(&dev.cmds);
}

void
nk_sdl_render(nk_anti_aliasing AA, int max_vertex_buffer, int max_element_buffer)
{
    nk_sdl_device *dev = &sdl.ogl;
    int width, height;
    int display_width, display_height;
    nk_vec2 scale;
    GLfloat[4][4] ortho = [
        [2.0f, 0.0f, 0.0f, 0.0f],
        [0.0f,-2.0f, 0.0f, 0.0f],
        [0.0f, 0.0f,-1.0f, 0.0f],
        [-1.0f,1.0f, 0.0f, 1.0f],
    ];
    SDL_GetWindowSize(sdl.win, &width, &height);
    SDL_GL_GetDrawableSize(sdl.win, &display_width, &display_height);
    ortho[0][0] /= cast(GLfloat)width;
    ortho[1][1] /= cast(GLfloat)height;

    scale.x = display_width/cast(float)width;
    scale.y = display_height/cast(float)height;

    /* setup global state */
    glViewport(0,0,display_width,display_height);
    glEnable(GL_BLEND);
    glBlendEquation(GL_FUNC_ADD);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDisable(GL_CULL_FACE);
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_SCISSOR_TEST);
    glActiveTexture(GL_TEXTURE0);

    /* setup program */
    glUseProgram(dev.prog);
    glUniform1i(dev.uniform_tex, 0);
    glUniformMatrix4fv(dev.uniform_proj, 1, GL_FALSE, &ortho[0][0]);
    {
        /* convert from command queue into draw list and draw to screen */
        const(nk_draw_command) *cmd;
        void *vertices;
        void *elements;
        const(nk_draw_index) *offset = null;
        nk_buffer vbuf;
        nk_buffer ebuf;

        /* allocate vertex and element buffer */
        glBindVertexArray(dev.vao);
        glBindBuffer(GL_ARRAY_BUFFER, dev.vbo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo);

        glBufferData(GL_ARRAY_BUFFER, max_vertex_buffer, null, GL_STREAM_DRAW);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, max_element_buffer, null, GL_STREAM_DRAW);

        /* load vertices/elements directly into vertex/element buffer */
        vertices = glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        elements = glMapBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY);
        {
            /* fill convert configuration */
            nk_convert_config config;
            const(nk_draw_vertex_layout_element)[4] vertex_layout = [
                {nk_draw_vertex_layout_attribute.NK_VERTEX_POSITION, nk_draw_vertex_layout_format.NK_FORMAT_FLOAT, nk_sdl_vertex.position.offsetof},
                    {nk_draw_vertex_layout_attribute.NK_VERTEX_TEXCOORD, nk_draw_vertex_layout_format.NK_FORMAT_FLOAT, nk_sdl_vertex.uv.offsetof},
                        {nk_draw_vertex_layout_attribute.NK_VERTEX_COLOR, nk_draw_vertex_layout_format.NK_FORMAT_R8G8B8A8, nk_sdl_vertex.col.offsetof},
                            NK_VERTEX_LAYOUT_END
            ];
            memset(&config, 0, config.sizeof);
            config.vertex_layout = vertex_layout.ptr;
            config.vertex_size = nk_sdl_vertex.sizeof;
            config.vertex_alignment = nk_sdl_vertex.alignof;
            config.null_ = dev.null_;
            config.circle_segment_count = 22;
            config.curve_segment_count = 22;
            config.arc_segment_count = 22;
            config.global_alpha = 1.0f;
            config.shape_AA = AA;
            config.line_AA = AA;

            /* setup buffers to load vertices and elements */
            nk_buffer_init_fixed(&vbuf, vertices, cast(nk_size)max_vertex_buffer);
            nk_buffer_init_fixed(&ebuf, elements, cast(nk_size)max_element_buffer);
            nk_convert(&sdl.ctx, &dev.cmds, &vbuf, &ebuf, &config);
        }
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER);

        /* iterate over and execute each draw command */
        nk_draw_foreach(&sdl.ctx, &dev.cmds, (cmd)
        {
            if (!cmd.elem_count) return;
            glBindTexture(GL_TEXTURE_2D, cast(GLuint)cmd.texture.id);
            glScissor(cast(GLint)(cmd.clip_rect.x * scale.x),
                      cast(GLint)((height - cast(GLint)(cmd.clip_rect.y + cmd.clip_rect.h)) * scale.y),
                      cast(GLint)(cmd.clip_rect.w * scale.x),
                      cast(GLint)(cmd.clip_rect.h * scale.y));
            glDrawElements(GL_TRIANGLES, cast(GLsizei)cmd.elem_count, GL_UNSIGNED_INT, offset);
            offset += cmd.elem_count;
        });
        nk_clear(&sdl.ctx);
    }

    glUseProgram(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    glDisable(GL_BLEND);
    glDisable(GL_SCISSOR_TEST);
}
extern(C)
void
nk_sdl_clipboard_paste(nk_handle usr, nk_text_edit *edit)
{
    const char *text = SDL_GetClipboardText();
    if (text) nk_textedit_paste(edit, text, nk_strlen(text));
}

extern(C)
void
nk_sdl_clipboard_copy(nk_handle usr, const(char) *text, int len)
{
    import core.stdc.string;
    import core.stdc.stdlib;
    char *str = null;
    if (!len) return;
    str = cast(char*)malloc(cast(size_t)len+1);
    if (!str) return;
    memcpy(str, text, cast(size_t)len);
    str[len] = '\0';
    SDL_SetClipboardText(str);
    free(str);
}


nk_context*
nk_sdl_init(SDL_Window *win)
{
    sdl.win = win;
    nk_init_default(&sdl.ctx, null);
    sdl.ctx.clip.copy = cast(nk_plugin_copy)&nk_sdl_clipboard_copy;
    sdl.ctx.clip.paste = cast(nk_plugin_paste)&nk_sdl_clipboard_paste;
    sdl.ctx.clip.userdata = nk_handle_ptr(null);
    nk_sdl_device_create();
    return &sdl.ctx;
}

void
nk_sdl_font_stash_begin(nk_font_atlas **atlas)
{
    nk_font_atlas_init_default(&sdl.atlas);
    nk_font_atlas_begin(&sdl.atlas);
    *atlas = &sdl.atlas;
}

void
nk_sdl_font_stash_end()
{
    const(void) *image; int w; int h;
    image = nk_font_atlas_bake(&sdl.atlas, &w, &h, nk_font_atlas_format.NK_FONT_ATLAS_RGBA32);
    nk_sdl_device_upload_atlas(image, w, h);
    nk_font_atlas_end(&sdl.atlas, nk_handle_id(cast(int)sdl.ogl.font_tex), &sdl.ogl.null_);
    if (sdl.atlas.default_font)
        nk_style_set_font(&sdl.ctx, &sdl.atlas.default_font.handle);
}

int
nk_sdl_handle_event(SDL_Event *evt)
{
    nk_context *ctx = &sdl.ctx;

    /* optional grabbing behavior */
    if (ctx.input.mouse.grab) {
        SDL_SetRelativeMouseMode(SDL_TRUE);
        ctx.input.mouse.grab = 0;
    } else if (ctx.input.mouse.ungrab) {
        int x = cast(int)ctx.input.mouse.prev.x, y = cast(int)ctx.input.mouse.prev.y;
        SDL_SetRelativeMouseMode(SDL_FALSE);
        SDL_WarpMouseInWindow(sdl.win, x, y);
        ctx.input.mouse.ungrab = 0;
    }
    if (evt.type == SDL_KEYUP || evt.type == SDL_KEYDOWN) {
        /* key events */
        int down = evt.type == SDL_KEYDOWN;
        const Uint8* state = SDL_GetKeyboardState(null);
        SDL_Keycode sym = evt.key.keysym.sym;
        if (sym == SDLK_RSHIFT || sym == SDLK_LSHIFT)
            nk_input_key(ctx, nk_keys.NK_KEY_SHIFT, down);
        else if (sym == SDLK_DELETE)
            nk_input_key(ctx, nk_keys.NK_KEY_DEL, down);
        else if (sym == SDLK_RETURN)
            nk_input_key(ctx, nk_keys.NK_KEY_ENTER, down);
        else if (sym == SDLK_TAB)
            nk_input_key(ctx, nk_keys.NK_KEY_TAB, down);
        else if (sym == SDLK_BACKSPACE)
            nk_input_key(ctx, nk_keys.NK_KEY_BACKSPACE, down);
        else if (sym == SDLK_HOME) {
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_START, down);
            nk_input_key(ctx, nk_keys.NK_KEY_SCROLL_START, down);
        } else if (sym == SDLK_END) {
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_END, down);
            nk_input_key(ctx, nk_keys.NK_KEY_SCROLL_END, down);
        } else if (sym == SDLK_PAGEDOWN) {
            nk_input_key(ctx, nk_keys.NK_KEY_SCROLL_DOWN, down);
        } else if (sym == SDLK_PAGEUP) {
            nk_input_key(ctx, nk_keys.NK_KEY_SCROLL_UP, down);
        } else if (sym == SDLK_z)
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_UNDO, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_r)
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_REDO, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_c)
            nk_input_key(ctx, nk_keys.NK_KEY_COPY, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_v)
            nk_input_key(ctx, nk_keys.NK_KEY_PASTE, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_x)
            nk_input_key(ctx, nk_keys.NK_KEY_CUT, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_b)
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_LINE_START, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_e)
            nk_input_key(ctx, nk_keys.NK_KEY_TEXT_LINE_END, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_UP)
            nk_input_key(ctx, nk_keys.NK_KEY_UP, down);
        else if (sym == SDLK_DOWN)
            nk_input_key(ctx, nk_keys.NK_KEY_DOWN, down);
        else if (sym == SDLK_LEFT) {
            if (state[SDL_SCANCODE_LCTRL])
                nk_input_key(ctx, nk_keys.NK_KEY_TEXT_WORD_LEFT, down);
            else nk_input_key(ctx, nk_keys.NK_KEY_LEFT, down);
        } else if (sym == SDLK_RIGHT) {
            if (state[SDL_SCANCODE_LCTRL])
                nk_input_key(ctx, nk_keys.NK_KEY_TEXT_WORD_RIGHT, down);
            else nk_input_key(ctx, nk_keys.NK_KEY_RIGHT, down);
        } else return 0;
        return 1;
    } else if (evt.type == SDL_MOUSEBUTTONDOWN || evt.type == SDL_MOUSEBUTTONUP) {
        /* mouse button */
        int down = evt.type == SDL_MOUSEBUTTONDOWN;
        const int x = evt.button.x, y = evt.button.y;
        if (evt.button.button == SDL_BUTTON_LEFT) {
            if (evt.button.clicks > 1)
                nk_input_button(ctx, nk_buttons.NK_BUTTON_DOUBLE, x, y, down);
            nk_input_button(ctx, nk_buttons.NK_BUTTON_LEFT, x, y, down);
        } else if (evt.button.button == SDL_BUTTON_MIDDLE)
            nk_input_button(ctx, nk_buttons.NK_BUTTON_MIDDLE, x, y, down);
        else if (evt.button.button == SDL_BUTTON_RIGHT)
            nk_input_button(ctx, nk_buttons.NK_BUTTON_RIGHT, x, y, down);
        return 1;
    } else if (evt.type == SDL_MOUSEMOTION) {
        /* mouse motion */
        if (ctx.input.mouse.grabbed) {
            int x = cast(int)ctx.input.mouse.prev.x, y = cast(int)ctx.input.mouse.prev.y;
            nk_input_motion(ctx, x + evt.motion.xrel, y + evt.motion.yrel);
        } else nk_input_motion(ctx, evt.motion.x, evt.motion.y);
        return 1;
    } else if (evt.type == SDL_TEXTINPUT) {
        /* text input */
        nk_glyph glyph;
        memcpy(cast(void*)glyph.ptr, cast(void*)evt.text.text, NK_UTF_SIZE);
        nk_input_glyph(ctx, glyph.ptr);
        return 1;
    } else if (evt.type == SDL_MOUSEWHEEL) {
        /* mouse wheel */
        nk_input_scroll(ctx,nk_vec2(cast(float)evt.wheel.x,cast(float)evt.wheel.y));
        return 1;
    }
    return 0;
}

void nk_sdl_shutdown()
{
    nk_font_atlas_clear(&sdl.atlas);
    nk_free(&sdl.ctx);
    nk_sdl_device_destroy();
    memset(&sdl, 0, sdl.sizeof);
}

int main(string[] args)
{
    int win_width= 1200;
    int win_height = 800;

    version(BindNuklear_Static) {}
    else
    {
        NuklearSupport nuksup = loadNuklear();
        if(nuksup != NuklearSupport.Nuklear4)
        {
            printf("Error: Nuklear library is not found.");
            return -1;
        }
    }

    version(BindSDL_Static) {}
    else
    {
        SDLSupport sdlsup = loadSDL();
        if (sdlsup != sdlSupport)
        {
            if (sdlsup == SDLSupport.badLibrary)
                printf("Warning: failed to load some SDL functions. It seems that you have an old version of SDL.");
            else
            {
                printf("Error: SDL library is not found. Please, install SDL 2.0.5");
                return -1;
            }
        }
    }

    if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
    {
        printf("Error: failed to init SDL: %s\n", SDL_GetError());
        return -1;
    }


    SDL_GL_SetAttribute (SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
    SDL_GL_SetAttribute (SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

    SDL_Window *win = SDL_CreateWindow("Demo",
                                       SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                       1200, 800, SDL_WINDOW_OPENGL|SDL_WINDOW_SHOWN);
    SDL_GLContext glContext =  SDL_GL_CreateContext(win);
    GLSupport glsup = loadOpenGL();
    if (!isOpenGLLoaded())
    {
        printf("Error: failed to load OpenGL functions. Please, update graphics card driver and make sure it supports OpenGL");
        return -1;
    }

    SDL_GL_SetSwapInterval(1);

    glViewport(0, 0, win_width, win_height);

    nk_context *ctx;
    nk_colorf bg;
    ctx = nk_sdl_init(win);

    nk_font_atlas *atlas;
    nk_sdl_font_stash_begin(&atlas);
    nk_sdl_font_stash_end();

    style.theme them = style.theme.THEME_BLUE;
    style.set_style(ctx, them);

    bg.r = 0.10f, bg.g = 0.18f, bg.b = 0.24f, bg.a = 1.0f;
    enum {EASY, HARD}
    int op = EASY;
    int property = 20;

    bool running = true;
    while(running)
    {
        /* Input */
        SDL_Event evt;
        nk_input_begin(ctx);
        while (SDL_PollEvent(&evt)) {
            if (evt.type == SDL_QUIT)
            {
                running = false;
                continue;
            }
            nk_sdl_handle_event(&evt);
        }
        nk_input_end(ctx);

        calculator.calculator(ctx);

        if (nk_begin(ctx, "Demo", nk_rect(50, 50, 230, 250),
                     NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
                     NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
        {
            nk_layout_row_static(ctx, 30, 80, 1);
            if (nk_button_label(ctx, "button"))
            {
                printf("button pressed\n");
            }
            if (nk_button_label(ctx, "style"))
            {
                them += 1;
                if(them > style.theme.max)
                    them = style.theme.min;
                style.set_style(ctx, them);
            }
            nk_layout_row_dynamic(ctx, 30, 2);
            if (nk_option_label(ctx, "easy", op == EASY)) op = EASY;
            if (nk_option_label(ctx, "hard", op == HARD)) op = HARD;
            nk_layout_row_dynamic(ctx, 25, 1);
            nk_property_int(ctx, "Compression:", 0, &property, 100, 10, 1);

            nk_layout_row_dynamic(ctx, 20, 1);
            nk_label(ctx, "background:", NK_TEXT_LEFT);
            nk_layout_row_dynamic(ctx, 25, 1);
            if (nk_combo_begin_color(ctx, nk_rgb_cf(bg), nk_vec2(nk_widget_width(ctx),400))) {
                nk_layout_row_dynamic(ctx, 120, 1);
                bg = nk_color_picker(ctx, bg, NK_RGBA);
                nk_layout_row_dynamic(ctx, 25, 1);
                bg.r = nk_propertyf(ctx, "#R:", 0, bg.r, 1.0f, 0.01f,0.005f);
                bg.g = nk_propertyf(ctx, "#G:", 0, bg.g, 1.0f, 0.01f,0.005f);
                bg.b = nk_propertyf(ctx, "#B:", 0, bg.b, 1.0f, 0.01f,0.005f);
                bg.a = nk_propertyf(ctx, "#A:", 0, bg.a, 1.0f, 0.01f,0.005f);
                nk_combo_end(ctx);
            }
        }
        nk_end(ctx);

        overview.overview(ctx);
        node_editor.node_editor(ctx);

        /* Draw */
        SDL_GetWindowSize(win, &win_width, &win_height);
        glViewport(0, 0, win_width, win_height);
        glClear(GL_COLOR_BUFFER_BIT);
        glClearColor(bg.r, bg.g, bg.b, bg.a);
        /* IMPORTANT: `nk_sdl_render` modifies some global OpenGL state
        * with blending, scissor, face culling, depth test and viewport and
        * defaults everything back into a default state.
        * Make sure to either a.) save and restore or b.) reset your own state after
        * rendering the UI. */
        nk_sdl_render(NK_ANTI_ALIASING_ON,512*1024, 128*1024);
        SDL_GL_SwapWindow(win);
    }
    nk_sdl_shutdown();
    SDL_GL_DeleteContext(glContext);
    SDL_DestroyWindow(win);
    SDL_Quit();

    return 0;
}

