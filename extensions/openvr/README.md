# dagon:openvr

Proof-of-concept VR support for Dagon using Valve's [OpenVR](https://github.com/ValveSoftware/openvr). This is in early stages of development. The extension implements its own basic renderer because existing pipeline in Dagon requires heavy modifications to support stereo rendering.

## Usage Example

```d
module main;

import dagon;
import dagon.ext.openvr;

class VRScene: Scene
{
    MyGame game;
    TextureAsset aEnvmap;
    OBJAsset aOBJSuzanne;
    Entity playerHead;
    Camera leftEyeCamera;
    Camera rightEyeCamera;
    EyeViewComponent leftEyeView;
    EyeViewComponent rightEyeView;

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
        playerHead = addEntity();
        playerHead.position = Vector3f(0, 1, 5);
        
        leftEyeCamera = addCamera(playerHead);
        rightEyeCamera = addCamera(playerHead);
        leftEyeView = New!EyeViewComponent(game.ovr, EVREye.Left, leftEyeCamera);
        rightEyeView = New!EyeViewComponent(game.ovr, EVREye.Right, rightEyeCamera);
        
        game.renderer.activeCameras(leftEyeCamera, rightEyeCamera);

        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.pitch(-45.0f);
        
        auto eSky = addEntity();
        auto psync = New!PositionSync(eventManager, eSky, leftEyeCamera);
        eSky.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
        eSky.scaling = Vector3f(100.0f, 100.0f, 100.0f);
        eSky.layer = EntityLayer.Background;
        eSky.material = New!Material(assetManager);
        eSky.material.depthWrite = false;
        eSky.material.useCulling = false;
        eSky.material.shader = New!SkyShader(assetManager);
        eSky.material.baseColorTexture = aEnvmap.texture;
        eSky.material.linearColor = false;
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
}

class MyGame: BaseGame
{
    OpenVRManager ovr;
    StereoRenderer renderer;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        ovr = New!OpenVRManager(this, this);
        renderer = New!StereoRenderer(ovr, eventManager, this);
        currentScene = New!VRScene(this);
    }
    
    override void onUpdate(Time t)
    {
        ovr.getHMD();
        super.onUpdate(t);
        
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
    MyGame game = New!MyGame(1280, 720, false, "Dagon OpenVR Demo", args);
    game.run();
    Delete(game);
}
```
