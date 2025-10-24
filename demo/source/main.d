module main;

import dagon;

class TestScene: Scene
{
    MyGame game;
    OBJAsset aOBJSuzanne;

    this(MyGame game)
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
        freeview.setZoom(5);
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
    
    override void onUpdate(Time t) { }
    override void onKeyDown(int key) { }
    override void onKeyUp(int key) { }
    override void onTextInput(dchar code) { }
    override void onMouseButtonDown(int button) { }
    override void onMouseButtonUp(int button) { }
    override void onMouseWheel(int x, int y) { }
    override void onControllerButtonDown(uint deviceIndex, int btn) { }
    override void onControllerButtonUp(uint deviceIndex, int btn) { }
    override void onControllerAxisMotion(uint deviceIndex, int axis, float value) { }
    override void onResize(int width, int height) { }
    override void onFocusLoss() { }
    override void onFocusGain() { }
    override void onDropFile(string filename) { }
    override void onUserEvent(int code) { }
    override void onQuit() { }
}

class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        currentScene = New!TestScene(this);
    }
}

void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, false, "Dagon Demo", args);
    game.run();
    Delete(game);
    debug logDebug("Leaked memory: ", allocatedMemory, " byte(s)");
}
