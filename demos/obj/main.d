module main;

import std.stdio;
import dagon;

class MyScene: Scene
{
    LightManager lightManager;

    RenderingContext rc3d; 
    Freeview freeview;

    DynamicArray!Entity entities;
    TextureAsset tex;

    OBJAsset obj;
    GenericMaterial mat;

    this(SceneManager smngr)
    {
        super(smngr);
        assetManager.liveUpdate = true;
    }

    override void onAssetsRequest()
    {
        tex = addTextureAsset("data/imrod/imrod-diffuse.png");

        obj = New!OBJAsset();
        addAsset(obj, "data/imrod/imrod.obj");
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
        lightManager.addPointLight(Vector3f(-3, 5, 0), Color4f(1.0, 0.0, 0.0, 1.0));
        lightManager.addPointLight(Vector3f( 3, 5, 0), Color4f(0.0, 1.0, 1.0, 1.0));
    
        freeview = New!Freeview(eventManager, this);
        freeview.camera.setZoom(6.0f);

        auto imrod = createEntity3D();
        imrod.drawable = obj.mesh;
        entities.append(imrod);

        mat = New!GenericMaterial(this);
        mat.diffuse = tex.texture;
        mat.roughness = 0.2f;
        mat.shadeless = false;
        imrod.material = mat;
    }

    override void onRelease()
    {
        entities.free();
    }

    override void onStart()
    {
        writeln("Allocated memory after scene switch: ", allocatedMemory);

        rc3d.init(eventManager);
        rc3d.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 100.0f);
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
    }

    override void onRender()
    {     
        glEnable(GL_DEPTH_TEST);

        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        rc3d.apply();

        foreach(e; entities)
            e.render(&rc3d);
    } 
}

class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(800, 600, "Dagon OBJ Demo", args);

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

