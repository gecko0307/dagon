# Dagon Basics

## Game and Scene

At the root of an application hierarchy there is an `Application` object. Usually you'll want to use its more feature-rich derived class, `Game`. Typical use case is to make a custom game class that derives from `Game` and encapsulates your components:

```d
import dagon;

class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        MyScene myScene = New!MyScene(this);
        currentScene = myScene;
    }
}
```

In the `main` function you create an instance of `MyGame` and call `run` method:

```d
void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, "Window Title", args);
    game.run();
    Delete(game);
}
```

Window parameters that are passed to the game class are default ones which can be overridden by the user via the `setting.conf` file. See "Conf Files.md" for details.

Note that Dagon doesn't use D's built-in memory allocator (`new` operator), instead it allocates all its data with `New` and `Delete` functions from `dlib.core.memory`. You are also expected to do so. You still can use garbage collected data in Dagon, but this may result in weird bugs, so you are strongly recommended to do things our way. Most part of the engine is built around dlib's ownership model—every object belongs to some other object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management—you have to manually delete only root owner, which usually is a game object.

Most user-defined logic happen in `Scene` objects. Each `Scene` stores its own collection of assets (game resources such as models and textures) and game objects (which are called entities). Scene loads assets, allocates entities, configurates them and initiates game loop. Only one scene (`Game.currentScene`) is active at any given time.

Similarly to a `Game`, you have to define your own scenes that derive from standard `Scene` class:

```d
class MyScene: Scene
{
    MyGame game;

    this(MyGame game)
    {
        super(game);
        this.game = game;
    }

    // Override Scene methods...
}
```

The way in which scenes are created largely depend on the architecture of the game. For a simple start, you can create a bunch of scenes in your `Game` object's constructor:

```d
class MyGame: Game
{
    MyScene1 scene1;
    MyScene2 scene2;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        
        scene1 = New!MyScene1(this);
        scene2 = New!MyScene2(this);
        setCurrentScene(scene1);
    }
}
```

In a more complex scenario, scene creation is deferred to the moment when it is needed, and when the user quits the scene, it is deleted.  This way, your game doesn't need to preload all of its resources in advance and can be as big as you want. You should not directly delete the scene while it is running using `Delete` function because there will be no synchronization in that case—use `Game.setCurrentScene` instead. If the optional `releaseCurrent` argument is set to `true`, the current scene will be safely deleted at the next loop iteration:

```d
class MyScene1: Scene
{
    MyGame game;
    
    this(MyGame game)
    {
        this.game = game;
    }
    
    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
        {
            game.setCurrentScene(New!MyScene2(game), true);
        }
    }
}
```

You have a great control over the logic of your scenes thanks to method overriding. You can define your own `onUpdate`, `beforeLoad`, `onLoad`, `afterLoad` methods.
* `void onUpdate(Time t)` is called each fixed time step (60 times per second, independent of rendering framerate). This is a place where your runtime logic happens: AI, physics, character control, animation, etc.
* `void beforeLoad()` is called once after scene is started, before the assets loading phase. In this method you can request assets that should be loaded (`addOBJAsset`, `addTextureAsset` and others).
* `void onLoad(Time t, float progress)` is called each fixed time step, similarly to `onUpdate`, during the loading phase, while the assets are loading in the background. In this method you can update the animation of a loading progress bar, for example.
* `void afterLoad()` is called after all the assets have been loaded. This is a place to create game objects and assign assets to them. Typically you create `Entity` and `Material` objects and assign loaded meshes and textures to them, respectively. Note that you can also create game objects at loading phase, using custom `Asset` objects, by reading scene description from a file.

`Scene` is also an implementation of `EventListener`, so it can react to user input events, such as keyboard, mouse and joystick events:

```d
override void onKeyDown(int key)
{
    if (key == KEY_ESCAPE)
        application.exit();
}

override void onKeyUp(int key) { }
override void onMouseButtonDown(int button) { }
override void onMouseButtonUp(int button) { }

// Override any other event handler from `EventListener`...
```

# Assets

Assets (`Asset` objects) are loaded via `Scene.assetManager`. `Asset` base class works as an abstract proxy for any type of resource. Format-specific asset types are implemented as derived classes: `TextureAsset`, `OBJAsset`, `GLTFAsset`, etc. Each type of asset stores decoded data, such as `Texture` object for a `TextureAsset`. Once loaded, you can use the asset to access its data at the scene construction phase:

```d
class MyScene: Scene
{
    TextureAsset aTexture;
    
    override void beforeLoad()
    {
        aTexture = addTextureAsset("assets/texture.png");
    }
    
    override void afterLoad()
    {
        // aTexture.texture object can now be referenced:
        someMaterial.baseColorTexture = aTexture.texture;
    }
}
```
