# dagon:openxr

[OpenXR](https://www.khronos.org/openxr/) integration.

## Usage Example

```d
module main;

import dagon;
import dagon.ext.openxr;

class VRScene: Scene
{
    MyGame game;
    TextureAsset aEnvmap;
    OBJAsset aOBJSuzanne;
    Entity player;
    Camera camera;

    this(MyGame game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        aEnvmap = addTextureAsset("data/envmap.dds");
        aOBJSuzanne = addOBJAsset("data/suzanne.obj");
    }

    override void afterLoad()
    {
        // Player object is controlled by the user
        player = addEntity();
        player.position = Vector3f(0, 1, 5);
        
        // Camera object is controlled by the OpenXR manager,
        // but is also child for the player, which allows
        // to move it in the scene
        camera = addCamera(player);
        game.xr.camera = camera;

        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.pitch(-45.0f);
        
        auto eSky = addEntity();
        auto psync = New!PositionSync(eventManager, eSky, camera);
        eSky.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
        eSky.scaling = Vector3f(100.0f, 100.0f, 100.0f);
        eSky.layer = EntityLayer.Background;
        eSky.material = New!Material(assetManager);
        eSky.material.depthWrite = false;
        eSky.material.useCulling = false;
        eSky.material.shader = New!SkyShader(assetManager);
        eSky.material.baseColorTexture = aEnvmap.texture;
        eSky.material.linearColor = true;
        eSky.gbufferMask = 0.0f;
        
        auto matSuzanne = addMaterial();
        matSuzanne.baseColorFactor = Color4f(1.0, 0.2, 0.2, 1.0);

        auto eSuzanne = addEntity();
        eSuzanne.drawable = aOBJSuzanne.mesh;
        eSuzanne.material = matSuzanne;
        eSuzanne.position = Vector3f(0, 1, 0);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
    }
    
    override void onUpdate(Time t)
    {
        // World-space camera basis (head direction from the device)
        Vector3f dir = camera.direction;
        Vector3f right = camera.right;
        
        float speed = 3.0f;
        if (eventManager.controllerButtonPressed[0][GB_DPLEFT]) player.translate(-right * speed * t.delta);
        if (eventManager.controllerButtonPressed[0][GB_DPRIGHT]) player.translate(right * speed * t.delta);
        if (eventManager.controllerButtonPressed[0][GB_DPUP]) player.translate(-dir * speed * t.delta);
        if (eventManager.controllerButtonPressed[0][GB_DPDOWN]) player.translate(dir * speed * t.delta);
    }
}

class MyGame: BaseGame
{
    OpenXRManager xr;
    SimpleStereoRenderer renderer;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        xr = New!OpenXRManager(this, this);
        renderer = New!SimpleStereoRenderer(xr, this, this);
        currentScene = New!VRScene(this);
    }
    
    override void onUpdate(Time t)
    {
        super.onUpdate(t);
        xr.update(t);
        
        if (renderer && currentScene)
        {
            renderer.scene = currentScene;
            renderer.update(t);
        }
    }
    
    override void onRender()
    {
        if (renderer && currentScene)
        {
            if (currentScene.canRender)
            {
                renderer.render();
            }
        }
    }
}

void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, false, "Dagon OpenXR Demo", args);
    game.run();
    Delete(game);
}
```
