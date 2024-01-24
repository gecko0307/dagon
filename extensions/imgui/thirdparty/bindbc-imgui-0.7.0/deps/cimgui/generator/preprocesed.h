
struct SDL_Window;
struct SDL_Renderer;
typedef union SDL_Event SDL_Event;
 bool     ImGui_ImplSDL2_InitForOpenGL(SDL_Window* window, void* sdl_gl_context);
 bool     ImGui_ImplSDL2_InitForVulkan(SDL_Window* window);
 bool     ImGui_ImplSDL2_InitForD3D(SDL_Window* window);
 bool     ImGui_ImplSDL2_InitForMetal(SDL_Window* window);
 bool     ImGui_ImplSDL2_InitForSDLRenderer(SDL_Window* window, SDL_Renderer* renderer);
 void     ImGui_ImplSDL2_Shutdown();
 void     ImGui_ImplSDL2_NewFrame();
 bool     ImGui_ImplSDL2_ProcessEvent(const SDL_Event* event);