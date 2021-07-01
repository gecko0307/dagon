# Dagon Application Architecture
## Game
Dagon is object oriented: all entities in it are classes. At the root of an application hierarchy there is an `Application` object. Usually you'll want to use its more feature-rich derived class, `Game`. Typical use case is to make a custom game class that derives from `Game` and encapsulates your components:

```d
import dagon;

class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        // Some initialization...
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

Note that Dagon doesn't use D's built-in memory allocator (`new` operator), instead it allocates all its data with `New` and `Delete` functions from `dlib.core.memory`. You are also expected to do so. You still can use garbage collected data in Dagon, but this may result in weird bugs, so you are strongly recommended to do things our way. Most part of the engine is built around dlib's ownership model - every object belongs to some other object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management - you have to manually delete only root owner, which usually is a game object.

## Scene
Dagon's core logic is based on a concept of a scene. A scene is an incapsulator for assets and game objects (which are called entities) and any custom data logically tied to them. Scene loads assets, allocates entities, configurates them and initiates game loop. Only one scene is active at any given time. Switching an active scene can optionally cause releasing current assets and loading new ones, as you would expect when going from one game level or location to another.

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

You have a great control over the logic of your scenes thanks to method overriding. You can define your own `onUpdate`, `beforeLoad`, `onLoad`, `afterLoad` methods.
* `onUpdate(Time t)` is called each fixed time step (60 times per second, independent of rendering framerate). This is a place where your runtime logic happens: AI, physics, character control, animation, etc.
* `beforeLoad()` is called once after scene is started, before the assets loading phase. In this method you can request assets that should be loaded (`addOBJAsset`, `addTextureAsset` and others).
* `onLoad(Time t, float progress)` is called each fixed time step, similarly to `onUpdate`, during the loading phase, while the assets are loading in the background. In this method you can update the animation of a loading progress bar, for example.
* `afterLoad()` is called after all the assets have been loaded. This is a place to create game objects and assign assets to them. Typically you create `Entity` and `Material` objects and assign loaded meshes and textures to them, respectively. Note that you can also create game objects at loading phase, using custom `Asset` objects, by reading scene description from a file.

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
