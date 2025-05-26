# Tutorial 1. Simple Application

This tutorial will guide you through creating your first application using the Dagon engine.

1. Create a new Dub project and add the Dagon dependency.

```bash
dub init mygame
cd mygame
dub add dagon
```

2. Create a basic scene

Dagon applications are structured around scenes. A scene encapsulates all logic, assets, and entities related to a specific part of your game (such as a level, a menu, etc.).

Here's a minimal scene setup:

Import `dagon` module and create a class that inherits from `Scene`:
```d
module main;

import dagon;

class TestScene: Scene
{
    Game game;
    OBJAsset aOBJSuzanne;

    this(Game game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {    
        aOBJSuzanne = addOBJAsset("data/suzanne.obj");
    }

    override void afterLoad()
    {
        auto camera = addCamera();
        auto freeview = New!FreeviewComponent(eventManager, camera);
        freeview.zoom(5);
        freeview.setRotation(30.0f, -45.0f, 0.0f);
        freeview.translationStiffness = 0.25f;
        freeview.rotationStiffness = 0.25f;
        freeview.zoomStiffness = 0.25f;
        game.renderer.activeCamera = camera;

        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.pitch(-45.0f);
        
        auto matSuzanne = addMaterial();
        matSuzanne.baseColorFactor = Color4f(1.0, 0.2, 0.2, 1.0);

        auto eSuzanne = addEntity();
        eSuzanne.drawable = aOBJSuzanne.mesh;
        eSuzanne.material = matSuzanne;
        eSuzanne.position = Vector3f(0, 1, 0);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
    }
}
```

This creates a scene with a red Suzanne model and a plane. Adding `FreeviewComponent` to the camera allows the user to navigate the scene with mouse like in 3D editors.

3. Create a `Game` class and assign the scene:

```d
class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        currentScene = New!TestScene(this);
    }
}
```

Only one scene can be active at a time. Switching the scene can optionally cause releasing current assets and loading new ones, as you would expect when going from one game level or location to another.

4. Write the main function

```d
void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, "Dagon tutorial 1", args);
    game.run();
    Delete(game);
}
```

5. Compile and run (`dub build`). Make sure to have latest SDL2 installed. If you're on Windows, Dub will automatically copy the libraries after each build to the project directory, so you don't have to do it manually. It will also copy some internal data files used by the engine and put them to `data/__internal` folder. Do not delete it, otherwise the application will work incorrectly.

You should see this:

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial1.jpg?raw=true)

6. Camera Controls
- **Left mouse button** — rotate the view
- **Right mouse button** — pan
- **Mouse wheel** or **Ctrl + LMB** — zoom

You don't have to worry about freeing models, textures and other GPU resources manually! All objects are managed through an ownership system. Once the resource owner (typically the `AssetManager` or the current `Scene`) is destroyed, all its resources are cleaned up automatically.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t1-simple)
