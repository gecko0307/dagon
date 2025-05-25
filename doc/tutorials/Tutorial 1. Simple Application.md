# Tutorial 1. Simple Application

This tutorial will guide you through creating your first Dagon application.

1. Create a new Dub project and run `dub add dagon`.

2. Import `dagon` module and create a class that inherits from `Scene`:
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

Dagon's core logic is based on a concept of a scene. A scene is an incapsulator for assets and game objects (which are called entities) and any custom data logically tied to them. Scene loads assets, allocates entities and configures them. In the example above we load a model from OBJ file (`data/suzanne.obj`) and attach it to an entity. We also create a plane object in the same manner. Adding `FreeviewComponent` to the camera allows the user to navigate the scene with mouse like in 3D editors.

3. Create a class that inherits from `Game`, create your scene and assign it to `currentScene`:
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

Only one scene is active at any given time. Switching an active scene can optionally cause releasing current assets and loading new ones, as you would expect when going from one game level or location to another. But scenes can represent not only levels, they are used for any logical context in a game - a menu, pause screen, options screen, inventory screen, and so on.

4. Add a `main` function, create an instance of `MyApplication` and call its `run` method:
```d
void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, "Dagon tutorial 1", args);
    game.run();
    Delete(game);
}
```

5. Compile and run (`dub build`). Make sure to have latest SDL2 installed. If you're on Windows, Dub will automatically copy the libraries after each build to the project directory, so you don't have to do it manually. It will also copy some internal data files used by the engine and put them to `data/__internal` folder. Please, don't delete it, otherwise the application will work incorrectly.

You should see something like this:

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/screenshot_tutorial1.jpg?raw=true)

Use left mouse button to rotate the view, right mouse button to translate, and mouse wheel (or LMB+Ctrl) to zoom.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t1-simple)
