module base;

import std.stdio;
import dagon;
import basescene;

class MyScene: BaseScene3D
{
    TextureAsset tex;

    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onAssetsRequest()
    {
        tex = addTextureAsset("data/textures/crate.jpg");
    }

    override void onAllocate()
    {
        super.onAllocate();

        addPointLight(Vector3f(-3, 3, 0), Color4f(1.0, 0.0, 0.0, 1.0));
        addPointLight(Vector3f( 3, 3, 0), Color4f(0.0, 1.0, 1.0, 1.0));

        auto freeview = New!Freeview(eventManager, this);
        freeview.setZoom(6.0f);
        view = freeview;

        ShapeBox shapeBox = New!ShapeBox(1, 1, 1, this);

        auto box = createEntity3D();
        box.drawable = shapeBox;

        auto mat = New!GenericMaterial(this);
        mat.diffuse = tex.texture;
        mat.roughness = 0.2f;
        box.material = mat;
    }

    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
            exitApplication();
    }
}

class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(800, 600, "Dagon Demo Application", args);

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

