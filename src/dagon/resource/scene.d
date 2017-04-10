module dagon.resource.scene;

import std.stdio;

import dlib.core.memory;

import dlib.container.array;
import dlib.container.dict;
import dlib.math.matrix;
import dlib.math.affine;

import derelict.opengl.gl;

import dagon.core.ownership;
import dagon.core.event;
import dagon.core.application;
import dagon.resource.asset;
import dagon.resource.textasset;
import dagon.resource.textureasset;
import dagon.resource.fontasset;
import dagon.graphics.rc;

class Scene: EventListener
{
    SceneManager sceneManager;
    AssetManager assetManager;
    bool canRun = false;

    this(SceneManager smngr)
    {
        super(smngr.eventManager, null);
        sceneManager = smngr;
        assetManager = New!AssetManager();
    }

    ~this()
    {
        if (!released)
            onRelease();

        Delete(assetManager);
    }

    // Set preload to true if you want to load the asset immediately
    // before actual loading (e.g., to render a loading screen)

    Asset addAsset(Asset asset, string filename, bool preload = false)
    {
        if (preload)
            assetManager.preloadAsset(asset, filename);
        else
            assetManager.addAsset(asset, filename);
        return asset;
    }

    TextAsset addTextAsset(string filename, bool preload = false)
    {
        TextAsset text;
        if (assetManager.assetExists(filename))
            text = cast(TextAsset)assetManager.getAsset(filename);
        else
        {
            text = New!TextAsset();
            addAsset(text, filename, preload);
        }
        return text;
    }

    TextureAsset addTextureAsset(string filename, bool preload = false)
    {
        TextureAsset tex;
        if (assetManager.assetExists(filename))
            tex = cast(TextureAsset)assetManager.getAsset(filename);
        else
        {
            tex = New!TextureAsset(assetManager.imageFactory);
            addAsset(tex, filename, preload);
        }
        return tex;
    }

    FontAsset addFontAsset(string filename, uint height, bool preload = false)
    {
        FontAsset font;
        if (assetManager.assetExists(filename))
            font = cast(FontAsset)assetManager.getAsset(filename);
        else
        {
            font = New!FontAsset(height);
            addAsset(font, filename, preload);
        }
        return font;
    }

    void onAssetsRequest()
    {
        // Add your assets here
    }

    void onLoading(float percentage)
    {
        // Render your loading screen here

        glDisable(GL_DEPTH_TEST);

        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glMatrixMode(GL_PROJECTION);
        auto projectionMatrix2D = orthoMatrix(
            0.0f, eventManager.windowWidth, 0.0f, eventManager.windowHeight, 0.0f, 100.0f);
        glLoadMatrixf(projectionMatrix2D.arrayof.ptr);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

        glColor4f(1, 1, 1, 1);
        float margin = 2.0f;
        float w = percentage * eventManager.windowWidth;
        glBegin(GL_QUADS);
        glVertex2f(margin, 10);
        glVertex2f(margin, margin);
        glVertex2f(w - margin, margin);
        glVertex2f(w - margin, 10);
        glEnd();
    }

    void onAllocate()
    {
        // Allocate your objects here
    }

    void onRelease()
    {
        // Release your objects here
    }

    void onStart()
    {
        // Do your (re)initialization here
    }

    void onEnd()
    {
        // Do your finalization here
    }

    void onUpdate(double dt)
    {
        // Do your animation and logics here
    }

    void onRender()
    {
        // Do your rendering here
    }

    void exitApplication()
    {
        generateUserEvent(DagonEvent.Exit);
    }

    void load()
    {
        onAssetsRequest();

        float p = assetManager.nextLoadingPercentage;

        assetManager.loadThreadSafePart();
        while(assetManager.isLoading)
        {
            sceneManager.application.beginRender();
            onLoading(p);
            sceneManager.application.endRender();
            p = assetManager.nextLoadingPercentage;
        }

        bool loaded = assetManager.loadThreadUnsafePart();

        if (loaded)
        {
            onAllocate();
            released = false;
            canRun = true;
        }
        else
        {
            eventManager.running = false;
        }
    }

    bool released = true;

    void release()
    {
        if (!released)
        {
            onRelease();
            clearOwnedObjects();
            assetManager.releaseAssets();

            released = true;
        }

        canRun = false;
    }

    void start()
    {
        if (canRun)
            onStart();
    }

    void end()
    {
        if (canRun)
            onEnd();
    }

    void update(double dt)
    {
        processEvents();
        if (canRun)
        {
            assetManager.updateMonitor(dt);
            onUpdate(dt);
        }
    }

    void render()
    {
        if (canRun)
            onRender();
    }
}

class SceneManager: Owner
{
    SceneApplication application;
    Dict!(Scene, string) scenesByName;
    EventManager eventManager;
    Scene currentScene;

    this(EventManager emngr, SceneApplication app)
    {
        super(app);
        application = app;
        eventManager = emngr;
        scenesByName = New!(Dict!(Scene, string));
    }

    ~this()
    {
        foreach(i, s; scenesByName)
        {
            Delete(s);
        }
        Delete(scenesByName);
    }

    Scene addScene(Scene scene, string name)
    {
        scenesByName[name] = scene;
        return scene;
    }

    void removeScene(string name)
    {
        Delete(scenesByName[name]);
        scenesByName.remove(name);
    }

    void setCurrentScene(Scene scene)
    {
        if (currentScene)
            currentScene.end();

        currentScene = scene;
        currentScene.start();
    }

    void setCurrentScene(string name)
    {
        setCurrentScene(scenesByName[name]);
    }

    void loadAndSwitchToScene(string name, bool releaseCurrentScene = true)
    {
        if (currentScene)
        {
            currentScene.end();
            if (releaseCurrentScene)
            {
                currentScene.release();
            }
        }

        Scene scene = scenesByName[name];
        writefln("Loading scene \"%s\"...", name);
        scene.load();
        writeln("OK");

        writefln("Starting scene \"%s\"...", name);
        currentScene = scene;
        currentScene.start();
        writeln("OK");

        writefln("Running...", name);
    }

/*
    void preloadScene(string name)
    {
        scenesByName[name].load();
    }

    void releaseScene(string name)
    {
        scenesByName[name].release();
    }
*/

    void update(double dt)
    {
        if (currentScene)
        {
            currentScene.update(dt);
        }
    }

    void render()
    {
        if (currentScene)
        {
            currentScene.render();
        }
    } 
}

class SceneApplication: Application
{
    SceneManager sceneManager;

    this(uint w, uint h, string windowTitle, string[] args)
    {
        super(w, h, windowTitle, args);

        sceneManager = New!SceneManager(eventManager, this);
    }
    
    override void onUpdate(double dt)
    {
        sceneManager.update(dt);
    }
    
    override void onRender()
    {
        sceneManager.render();
    }
}

