module scene;

import dagon;

class MyScene: Scene
{
    Game game;

    this(Game game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        // Create assets
        // aModel = addOBJAsset("data/model.obj");
        // aTexture = addTextureAsset("data/texture.png");
    }
    
    override void onLoad(Time t, float progress)
    {
    }

    override void afterLoad()
    {
        auto camera = addCamera();
        auto freeview = New!FreeviewComponent(eventManager, camera);
        freeview.zoom(10);
        freeview.pitch(-30.0f);
        freeview.turn(10.0f);
        game.renderer.activeCamera = camera;

        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.pitch(-45.0f);
        
        auto matRed = addMaterial();
        matRed.diffuse = Color4f(1.0, 0.2, 0.2, 1.0);

        auto eCube = addEntity();
        eCube.drawable = New!ShapeBox(Vector3f(1, 1, 1), assetManager);
        eCube.material = matRed;
        eCube.position = Vector3f(0, 1, 0);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
        
        game.deferredRenderer.ssaoEnabled = true;
        game.deferredRenderer.ssaoPower = 6.0;
        game.postProcessingRenderer.fxaaEnabled = true;
    }
    
    override void onUpdate(Time t) { }
    override void onKeyDown(int key) { }
    override void onKeyUp(int key) { }
    override void onMouseButtonDown(int button) { }
    override void onMouseButtonUp(int button) { }
}
