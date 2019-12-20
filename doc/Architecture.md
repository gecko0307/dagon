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
`Game` usually controls one or more scene objects. Each scene has its own assets, logics, event system, etc. You can think of a scene as a game level. Similarly to a `Game`, you have to define your own scenes that derive from standard `Scene` class:
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
* `afterLoad()` is called after all the assets have been loaded. This is a place to create game objects and assign assets to them. Typically you create `Entity` and `Material` objects and assign loaded meshes and textures to them, respectively. Note that you can also create game objects at loading phase, using custom `Asset` objects, by reading scene description from a file, which is a standard mechanic for most games. Dagon includes a simple scene container, `PackageAsset`, but most likely you'll want to create your own, tailored to your game. In this case `afterLoad` can be used for physics initialization, geometry preprocessing, etc.
