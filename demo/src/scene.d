module scene;

import dagon;

class MyScene: Scene
{
    Game game;
    TextureAsset stoneBaseColor;
    TextureAsset stoneNormal;

    this(Game game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        stoneBaseColor = addTextureAsset("data/stone-basecolor.png");
        stoneNormal = addTextureAsset("data/stone-normal.png");
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
        sun.rotation =
            rotationQuaternion!float(Axis.y, degtorad(-90.0f)) *
            rotationQuaternion!float(Axis.x, degtorad(-20.0f));
        environment.sun = sun;
        environment.backgroundColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
        environment.ambientColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
        ePlane.material = addMaterial();
        ePlane.material.baseColorFactor = Color4f(1.0, 0.5, 0.5, 1.0);
        ePlane.material.baseColorTexture = stoneBaseColor.texture;
        ePlane.material.normalTexture = stoneNormal.texture;
        
        auto eCube = addEntity();
        eCube.drawable = New!ShapeBox(1, 1, 1, assetManager);
        
        game.postProc.lensDistortionEnabled = false;
        game.postProc.tonemapper = Tonemapper.Filmic;
    }
    
    override void onUpdate(Time t) { }
    override void onKeyDown(int key) { }
    override void onKeyUp(int key) { }
    override void onMouseButtonDown(int button) { }
    override void onMouseButtonUp(int button) { }
}
