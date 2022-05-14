module scene;

import dagon;
import dagon.ext.stbi;

class MyScene: Scene
{
    Game game;
    GLTFAsset aModel;
    TextureAsset stoneBaseColor;
    TextureAsset stoneNormal;
    TextureAsset aEnvmap;
    TextureAsset aBRDF;

    this(Game game)
    {
        super(game);
        this.game = game;
        stbiRegister(assetManager);
    }

    override void beforeLoad()
    {
        aModel = addGLTFAsset("data/suzanne.gltf");
        stoneBaseColor = addTextureAsset("data/stone-basecolor.png");
        stoneNormal = addTextureAsset("data/stone-normal.png");
        aEnvmap = addTextureAsset("data/envmap.hdr");
        aBRDF = addTextureAsset("data/brdf.dds");
    }
    
    override void onLoad(Time t, float progress)
    {
    }

    override void afterLoad()
    {
        auto camera = addCamera();
        camera.fov = 50.0f;
        
        auto freeview = New!FreeviewComponent(eventManager, camera);
        freeview.zoom(10);
        freeview.pitch(-30.0f);
        freeview.turn(10.0f);
        game.renderer.activeCamera = camera;

        auto sun = addLight(LightType.Sun);
        sun.color = Color4f(1.0f, 1.0f, 1.0f, 1.0f);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.turn(-90.0f);
        sun.pitch(-24.0f);
        
        environment.sun = sun;
        environment.backgroundColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
        environment.ambientColor = environment.backgroundColor;
        environment.ambientMap = aEnvmap.texture;
        environment.ambientEnergy = 1.0f;
        environment.ambientBRDF = aBRDF.texture;
        aBRDF.texture.useMipmapFiltering = false;
        //aBRDF.texture.enableRepeat(false); // TODO
        
        Entity modelRoot = aModel.rootEntity;
        useEntity(modelRoot);
        foreach(node; aModel.nodes)
            useEntity(node.entity);
        
        auto ePlane = addEntity();
        ePlane.position.y = -1.0f;
        ePlane.drawable = New!ShapePlane(6, 6, 1, assetManager);
        ePlane.material = addMaterial();
        ePlane.material.baseColorFactor = Color4f(1.0, 0.5, 0.5, 1.0);
        ePlane.material.baseColorTexture = stoneBaseColor.texture;
        ePlane.material.normalTexture = stoneNormal.texture;
        
        auto eSky = addEntity();
        eSky.layer = EntityLayer.Background;
        auto psync = New!PositionSync(eventManager, eSky, camera);
        eSky.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
        eSky.scaling = Vector3f(100.0f, 100.0f, 100.0f);
        eSky.material = addMaterial();
        eSky.material.depthWrite = false;
        eSky.material.useCulling = false;
        eSky.material.baseColorTexture = aEnvmap.texture;
        
        game.postProc.lensDistortionEnabled = false;
        game.postProc.tonemapper = Tonemapper.Filmic;
    }
    
    override void onUpdate(Time t) { }
    override void onKeyDown(int key) { }
    override void onKeyUp(int key) { }
    override void onMouseButtonDown(int button) { }
    override void onMouseButtonUp(int button) { }
}
