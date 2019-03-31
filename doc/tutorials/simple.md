# Tutorial 1. Simple Application

This tutorial will guide you through creating your first Dagon application.

1. Create a new Dub project and add `"dagon": "~master"` dependency to your `dub.json`. You can use a release instead of the master branch if you want stability, but that way you won't get all the latest features (remember that Dagon is not production-ready).

2. Import `dagon` module and create a class that inherits from `Scene`:

```d
module main;

import dagon;

class TestScene: Scene
{
    OBJAsset aOBJSuzanne;

    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onAssetsRequest()
    {    
        aOBJSuzanne = addOBJAsset("data/suzanne.obj");
    }

    override void onAllocate()
    {
        super.onAllocate();
        
        view = New!Freeview(eventManager, assetManager);

        mainSun = createLightSun(Quaternionf.identity, environment.sunColor, environment.sunEnergy);
        mainSun.shadow = true;
        environment.setDayTime(9, 00, 00);
        
        auto mat = createMaterial();
        mat.diffuse = Color4f(1.0, 0.2, 0.2, 1.0);

        auto eSuzanne = createEntity3D();
        eSuzanne.drawable = aOBJSuzanne.mesh;
        eSuzanne.material = mat;
        eSuzanne.position = Vector3f(0, 1, 0);
        
        auto ePlane = createEntity3D();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
    }
}
```

In the example above we load a model from OBJ file (`data/suzanne.obj`) and attach it to an entity. We also create a plane object in the same manner. Assigning `Freeview` object to the `view` property allows the user to navigate the scene with mouse.

3. Create a class that inherits from `SceneApplication` and add your scene to it:
```d
class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(1280, 720, false, "Dagon demo", args);

        TestScene test = New!TestScene(sceneManager);
        sceneManager.addScene(test, "TestScene");
        sceneManager.goToScene("TestScene");
    }
}
```

The code is obvious: we create an instance of our `TestScene` and switch to it.

4. Add a `main` function, create an instance of `MyApplication` and call its `run` method:
```d
void main(string[] args)
{
    MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);
}
```

5. Compile and run (`dub build`). Make sure to have latest SDL2, Freetype and Nuklear installed. If you're on Windows, Dub will automatically copy the libraries after each build to the project directory, so you don't have to do it manually. It will also copy some internal data files used by the engine and put them to `data/__internal` folder. Please, don't delete it, otherwise the application will work incorrectly.

You should see something like this:

![](https://www.dropbox.com/s/6j0fujgyor7wjci/app.jpg?raw=1)

Use left mouse button to rotate the view, right mouse button to translate, and mouse wheel (or LMB+Ctrl) to zoom.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial1)