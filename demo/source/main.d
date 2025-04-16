module main;

import dagon;

class TestScene: Scene
{
    MyGame game;
    GLTFAsset aFox;
    AnimatedEntity eFox;

    this(MyGame game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        aFox = addGLTFAsset("data/AnimatedCube/glTF/AnimatedCube.gltf");
        //~ aFox = addGLTFAsset("data/Fox/glTF/Fox.gltf");
        //~ aFox = addGLTFAsset("data/FlightHelmet/glTF/FlightHelmet.gltf");
    }

    override void afterLoad()
    {  
        game.deferredRenderer.ssaoEnabled = true;
        game.deferredRenderer.ssaoPower = 6.0;
        game.postProcessingRenderer.tonemapper = Tonemapper.Filmic;
        game.postProcessingRenderer.fxaaEnabled = true;
        
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

        eFox = aFox.rootAnimatedEntity;
        eFox.animationIdx = 0; // enables first animation
        useEntity(eFox);
        foreach(node; aFox.nodes)
            useEntity(node.entity);

        eFox.position = Vector3f(0, 1, 0);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
    }
    
    override void onUpdate(Time t)
    {
        static size_t skip;

        if(skip == 0)
        {
            skip = 1;
            eFox.applyAnimations(t);
        }

        skip--;
    }

    override void onKeyDown(int key) { }
    override void onKeyUp(int key) { }
    override void onTextInput(dchar code) { }
    override void onMouseButtonDown(int button) { }
    override void onMouseButtonUp(int button) { }
    override void onMouseWheel(int x, int y) { }
    override void onJoystickButtonDown(int btn) { }
    override void onJoystickButtonUp(int btn) { }
    override void onJoystickAxisMotion(int axis, float value) { }
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
    version (none)
    {
        import etc.linux.memoryerror;
        registerMemoryAssertHandler();
    }

    MyGame game = New!MyGame(1280, 720, false, "Dagon Demo", args);
    game.run();
    Delete(game);
}
