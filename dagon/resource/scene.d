module dagon.resource.scene;

import std.stdio;

import dlib.core.memory;

import dlib.container.array;
import dlib.container.dict;

import dagon.core.ownership;
import dagon.core.event;
import dagon.core.application;
import dagon.resource.asset;
import dagon.resource.textasset;
import dagon.resource.textureasset;

class Scene: EventListener
{
    SceneManager sceneManager;
    AssetManager assetManager;
    bool canRun = false;
    //bool allocated = false;

    this(SceneManager smngr)
    {
        super(smngr.eventManager, null);
        sceneManager = smngr;
        assetManager = New!AssetManager();
    }

    ~this()
    {
        onRelease();
        Delete(assetManager);
    }

    Asset addAsset(Asset asset, string filename)
    {
        assetManager.addAsset(asset, filename);
        return asset;
    }

    TextAsset addTextAsset(string filename)
    {
        TextAsset text = New!TextAsset();
        assetManager.addAsset(text, filename);
        return text;
    }

    TextureAsset addTextureAsset(string filename)
    {
        TextureAsset tex = New!TextureAsset(assetManager.imageFactory);
        assetManager.addAsset(tex, filename);
        return tex;
    }

    void onAssetsRequest()
    {
        // Add your assets here
    }

    void onLoading()
    {
        // Render your loading screen here
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

        // TODO: draw loading screen while loading thread-safe part
        bool loaded = assetManager.loadThreadSafePart();

        if (loaded)
        {
            loaded = assetManager.loadThreadUnsafePart();
        }

        if (loaded)
        {
            onAllocate();
            canRun = true;
        }
        else
        {
            eventManager.running = false;
        }
    }

    void release()
    {
        onRelease();
        clearOwnedObjects();
        assetManager.releaseAssets();

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
    Dict!(Scene, string) scenesByName;
    EventManager eventManager;
    Scene currentScene;

    this(EventManager emngr, Owner owner)
    {
        super(owner);
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
        scene.load();
        currentScene = scene;
        currentScene.start();

        writeln("Memory after switch: ", allocatedMemory);
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

    this(uint w, uint h, string[] args)
    {
        super(w, h, args);

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

