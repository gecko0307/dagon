# Dagon Editor

Dagon Editor allows you to build scenes from 3D models. It is written using Dagon Engine itself, so it guarantees WYSIWYG experience: given the same renderer settings, edited scene looks exactly the same as in the engine.

Dagon Editor is not a self-contained game development tool like Unity or Godot; it doesn't manage entire projects. How you use the data created in it is fully up to you.

## The Basics

The Editor uses industry-standard interface layout common to many level editors. In the center of the window is a Viewport, an area that renders a 3D world. On the left side of the window is an Inspector panel, a hierarchical view of all the Entities in the scene. At the right side is a Properties panel which allows to edit currently selected Entity. At the bottom is an Asset Browser which displays files and folders that are found on the disk alongside with the edited scene. At the top of the window there are menu bar and a toolbar.

Note that in a newly created scene, the Asset Browser is disabled, because the scene does not yet have an asset root directory set. You need to save the scene to a file (Ctrl+S or File -> Save as...), after which the Asset Browser will use the parent directory of this file as the root directory.

To import a model, copy it to the root directory (it's better to make a subdirectory for that, such as `meshes` or `models`) and then drag and drop it to the Viewport.

## Transformations

TODO

## Materials and Textures

TODO

## Loading Scenes in the Game

Scenes exported by the Editor are loaded using the `SceneAsset`. This is very easy:

```d
class TestScene: Scene
{
    MyGame game;
    LoadingScreen loadingScreen;
    SceneAsset aScene;

    this(MyGame game)
    {
        super(game);
        this.game = game;
        loadingScreen = New!LoadingScreen(game, this);
    }

    override void beforeLoad()
    {
        aScene = addSceneAsset("scenes/gameLevel.json");
    }
    
    override void onLoad(Time t, float progress)
    {
        loadingScreen.update(t, progress);
        loadingScreen.render();
    }

    override void afterLoad()
    {
        /*
         * Now the loaded data can be accessed.
         * Note that all entities are already in the scene,
         * unless you specify your own World object before loading.
         */
    }
}
```
