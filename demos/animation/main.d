module main;

import std.stdio;
import dagon;

class MyScene: Scene
{
    LightManager lightManager;
    Environment env;

    RenderingContext rc3d; 
    Freeview freeview;

    DynamicArray!Entity entities;

    IQMAsset iqm;
    Entity mrfixit;
    Actor actor;

    this(SceneManager smngr)
    {
        super(smngr);
        assetManager.mountDirectory("data/iqm");
        assetManager.liveUpdate = false;
    }

    override void onAssetsRequest()
    {
        iqm = New!IQMAsset();
        addAsset(iqm, "data/iqm/mrfixit.iqm");
    }

    Entity createEntity3D()
    {
        Entity e = New!Entity(eventManager, this);
        auto lr = New!LightReceiver(e, lightManager);
        return e;
    }

    override void onAllocate()
    {
        lightManager = New!LightManager(this);
        lightManager.addPointLight(Vector3f(3, 3, 0), Color4f(1.0, 0.0, 0.0, 1.0));
        lightManager.addPointLight(Vector3f(-3, 3, 0), Color4f(1.0, 1.0, 1.0, 1.0));
    
        freeview = New!Freeview(eventManager, this);
        freeview.camera.setZoom(6.0f);

        actor = New!Actor(iqm.model, this);
        mrfixit = createEntity3D();
        mrfixit.drawable = actor;
        entities.append(mrfixit);

        env = New!Environment(this);

        auto mat = New!GenericMaterial(this);
        mat.roughness = 0.2f;
        mat.shadeless = false;
        mrfixit.material = mat;

        auto plane = New!ShapePlane(8, 8, this);
        auto p = createEntity3D();
        p.drawable = plane;
        entities.append(p);
    }

    override void onRelease()
    {
        entities.free();
    }

    override void onStart()
    {
        writeln("Allocated memory after scene switch: ", allocatedMemory);

        rc3d.init(eventManager, env);
        rc3d.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 100.0f);

        actor.play();

        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
    }

    override void onEnd()
    {
    }

    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
            exitApplication();
    }

    override void onUpdate(double dt)
    {   
        freeview.update(dt);
        freeview.prepareRC(&rc3d);

        foreach(e; entities)
            e.update(dt);

/*
        rc3d.viewMatrix = freeview.viewMatrix();
        rc3d.invViewMatrix = freeview.invViewMatrix();
        rc3d.normalMatrix = matrix4x4to3x3(rc3d.invViewMatrix).transposed;
*/
    }

    override void onRender()
    {     
        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

/*
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf(rc3d.projectionMatrix.arrayof.ptr);
        glMatrixMode(GL_MODELVIEW);
        glLoadMatrixf(rc3d.viewMatrix.arrayof.ptr);
*/

        rc3d.apply();

        foreach(e; entities)
            e.render(&rc3d);
    } 
}

class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(800, 600, "Dagon IQM Animation Demo", args);

        MyScene scene = New!MyScene(sceneManager);
        sceneManager.addScene(scene, "MyScene");
        sceneManager.loadAndSwitchToScene("MyScene");
    }
}

void main(string[] args)
{
    writeln("Allocated memory at start: ", allocatedMemory);
    MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);
    writeln("Allocated memory at end: ", allocatedMemory);
}

