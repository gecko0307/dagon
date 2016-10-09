module dagon.core.scene;

import dlib.core.memory;

import dlib.container.array;
import dlib.container.dict;

import dagon.core.ownership;
import dagon.core.event;
import dagon.core.application;

class Scene: EventListener
{
    SceneManager sceneManager;

    this(SceneManager smngr)
    {
        super(smngr.eventManager, null);
        sceneManager = smngr;
    }

    void exitApplication()
    {
        generateUserEvent(DagonEvent.Exit);
    }

    void onStart()
    {
        // Override me
    }

    void onEnd()
    {
        // Override me
    }

    void onUpdate(double dt)
    {
        // Override me
    }

    void onRender()
    {
        // Override me
    }

    void start()
    {
        onStart();
    }

    void end()
    {
        onEnd();
    }

    void update(double dt)
    {
        processEvents();
        onUpdate(dt);
    }

    void render()
    {
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

    Scene addScene(string name)
    {
        Scene scene = New!Scene(this);
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

