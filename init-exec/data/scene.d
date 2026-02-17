/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the software
to the public domain. We make this dedication for the benefit of the
public at large and to the detriment of our heirs and successors.
We intend this dedication to be an overt act of relinquishment in 
perpetuity of all present and future rights to this software under
copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
*/
module scene;

import dagon;

class MyScene: Scene
{
    Game game;
    
    // OBJAsset aModel;
    // TextureAsset aTexture;

    this(Game game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        // Create assets here, for example:
        // aModel = addOBJAsset("data/model.obj");
        // aTexture = addTextureAsset("data/texture.png");
    }
    
    override void onLoad(Time t, float progress)
    {
        // Do something each frame while assets are loading
    }

    override void afterLoad()
    {
        // Create entities, materials, initialize game logic
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
        
        auto matRed = addMaterial();
        matRed.baseColorFactor = Color4f(1.0, 0.2, 0.2, 1.0);

        auto eCube = addEntity();
        eCube.drawable = New!ShapeBox(Vector3f(1, 1, 1), assetManager);
        eCube.material = matRed;
        eCube.position = Vector3f(0, 1, 0);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
    }
    
    // Event callbacks:
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
    override void onUserEvent(int code, void* payload) { }
    override void onQuit() { }
}
