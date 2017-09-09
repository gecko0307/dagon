module dagon.core.application;

import std.stdio;
import std.conv;
import std.getopt;
import std.string;
import std.file;
import core.stdc.stdlib;

import derelict.sdl2.sdl;
import derelict.opengl.gl;
import derelict.opengl.glu;
import derelict.freetype.ft;

import dagon.core.event;

void exitWithError(string message)
{
    writeln(message);
    core.stdc.stdlib.exit(1);
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
    
    this(uint w, uint h, string windowTitle, string[] args)
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
                DerelictFT.load(format("%s/libfreetype.so", libdir));
            }
            version(Windows)
            {
                version(X86)
                {
                    DerelictSDL2.load(format("%s/SDL2.dll", libdir));
                    DerelictFT.load(format("%s/freetype.dll", libdir));
                }
                version(X86_64)
                {
                    DerelictSDL2.load(format("%s/SDL2_64.dll", libdir));
                    DerelictFT.load(format("%s/freetype_64.dll", libdir));
                }
            }
        }
        else
        {  
            version(linux)
            {
                version(X86)
                {
                    if (exists("lib/libSDL2-2.0.so"))
                        DerelictSDL2.load("lib/libSDL2-2.0.so");
                    else
                        DerelictSDL2.load();

                    if (exists("lib/libfreetype271.so"))
                        DerelictFT.load("lib/libfreetype271.so");
                    else
                        DerelictFT.load();
                }
                version(X86_64)
                {
                    if (exists("lib/libSDL2-2.0_64.so"))
                        DerelictSDL2.load("lib/libSDL2-2.0_64.so");
                    else
                        DerelictSDL2.load();

                    if (exists("lib/libfreetype263_64.so"))
                        DerelictFT.load("lib/libfreetype263_64.so");
                    else
                        DerelictFT.load();
                }
            }
            version(Windows)
            {
                version(X86)
                {
                    if (exists("lib/SDL2.dll"))
                        DerelictSDL2.load("lib/SDL2.dll");
                    else
                        DerelictSDL2.load();

                    if (exists("lib/freetype271.dll"))
                        DerelictFT.load("lib/freetype271.dll");
                    else
                        DerelictFT.load();
                }
                version(X86_64)
                {
                    if (exists("lib/SDL2_64.dll"))
                        DerelictSDL2.load("lib/SDL2_64.dll");
                    else
                        DerelictSDL2.load();

                    if (exists("lib/freetype271_64.dll"))
                        DerelictFT.load("lib/freetype271_64.dll");
                    else
                        DerelictFT.load();
                }
            }
        }
        
        version(FreeBSD)
        {
            DerelictSDL2.load();
            DerelictFT.load();
        }

        version(OSX)
        {
            DerelictSDL2.load();
            DerelictFT.load();
        }

        if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
            exitWithError("Failed to init SDL: " ~ to!string(SDL_GetError()));
        
        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
	    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
	    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);

        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    
        width = w;
        height = h;
        
        window = SDL_CreateWindow(toStringz(windowTitle), 100, 100, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);
        if (window is null)
            exitWithError("Failed to create window: " ~ to!string(SDL_GetError()));
        SDL_GL_SetSwapInterval(1);
            
        glcontext = SDL_GL_CreateContext(window);

        DerelictGL.loadClassicVersions(GLVersion.GL21);
        DerelictGL.loadExtensions();
            
        EventManager eventManager = new EventManager(window, width, height);
        super(eventManager, null);
            
        // Initialize OpenGL
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClearDepth(1.0);
        glDepthFunc(GL_LESS);
        glEnable(GL_DEPTH_TEST);

        glEnable(GL_POLYGON_OFFSET_FILL);
        
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
            beginRender();
            onUpdate(eventManager.deltaTime);
            onRender();
            endRender();
        }
    }

    void beginRender()
    {
        eventManager.update();
        processEvents();
    }

    void endRender()
    {
        checkGLError();            
        SDL_GL_SwapWindow(window);
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

