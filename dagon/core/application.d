module dagon.core.application;

import std.stdio;
import std.conv;
import std.getopt;
import std.string;
import std.c.process;

import derelict.sdl2.sdl;
import derelict.opengl.gl;
import derelict.opengl.glu;

import dagon.core.event;

void exitWithError(string message)
{
    writeln(message);
    std.c.process.exit(1);
}

enum DagonEvent
{
    Exit = -1
}

class Application: EventListener
{
    uint width;
    uint height;
    SDL_Window* window = null;
    SDL_GLContext glcontext;
    string libdir;
    
    this(uint w, uint h, string[] args)
    {
        try
        { 
            getopt(
                args,
                "libdir", &libdir,
            );
        }
        catch(Exception)
        {
        }

        DerelictGL.load();
        DerelictGLU.load();
        if (libdir.length)
        {
            version(linux)
            {
                DerelictSDL2.load(format("%s/libSDL2-2.0.so", libdir));
            }
            version(Windows)
            {
                DerelictSDL2.load(format("%s/SDL2.dll", libdir));
            }
        }
        else
        {
            DerelictSDL2.load();
        }

        if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
            exitWithError("Failed to init SDL: " ~ to!string(SDL_GetError()));
        
        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
	    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 1);
	    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);

        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    
        width = w;
        height = h;
        
        window = SDL_CreateWindow("Dagon Application", 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);
        if (window is null)
            exitWithError("Failed to create window: " ~ to!string(SDL_GetError()));
        SDL_GL_SetSwapInterval(1);
            
        glcontext = SDL_GL_CreateContext(window);

        DerelictGL.loadClassicVersions(GLVersion.GL13);
        DerelictGL.loadExtensions();
            
        EventManager eventManager = new EventManager(width, height);
        super(eventManager, null);
            
        // Initialize OpenGL
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClearDepth(1.0);
        glDepthFunc(GL_LESS);
        glEnable(GL_DEPTH_TEST);
        
        checkGLError();
    }

    override void onUserEvent(int code)
    {
        if (code == DagonEvent.Exit)
        {
            exit();
        }
    }
    
    void onUpdate(double dt)
    {
        // Override me
    }
    
    void onRender()
    {
        // Override me
    }
    
    void checkGLError()
    {
        GLenum error = GL_NO_ERROR;
        error = glGetError();
        if (error != GL_NO_ERROR)
        {
            writeln("OpenGL error: ", error);
            eventManager.running = false;
        }
    }
    
    void run()
    {
        while(eventManager.running)
        {
            eventManager.update();
            processEvents();
            
            onUpdate(eventManager.deltaTime);
            
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            onRender();
            
            checkGLError();
            
            SDL_GL_SwapWindow(window);
        }
    }
    
    void exit()
    {
        eventManager.running = false;
    }
    
    ~this()
    {
        SDL_GL_DeleteContext(glcontext);
        SDL_DestroyWindow(window);
        SDL_Quit();
    }
}

