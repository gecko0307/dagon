# Scene and Asset Management

Most user-defined logic happen in `Scene` objects. Each `Scene` stores its own collection of assets (game resources such as models and textures). `Game` object orchestrates scenes and allows to switch them using `Game.setCurrentScene` method, optionally deleting the current running scene from memory. This way, your game doesn't need to preload all of its resources in advance and can be as big as you want - break the game into multiple levels (or zones) and only load a portion of the world at a time.

## Scenes

The way in which scenes are created largely depend on the architecture of the game. For a simple start, you can create a bunch of scenes in your `Game` object's constructor:

```d
class MyGame: Game
{
    MyScene1 scene1;
    MyScene2 scene2;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        
        scene1 = New!MyScene1(this);
        scene2 = New!MyScene2(this);
        setCurrentScene(scene1);
    }
}

```

In a more complex scenario, scene creation is deferred to the moment when it is needed, and when the user quits the scene, it is deleted. You should not directly delete the scene while it is running using `Delete` function because there will be no synchronization in thatcase - use `Game.setCurrentScene` instead. If the optional `releaseCurrent` argument is set to `true`, the current scene will be safely deleted at the next loop iteration:

```d
class MyScene1: Scene
{
    MyGame game;
    
    this(MyGame game)
    {
        this.game = game;
    }
    
    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
        {
            game.setCurrentScene(New!MyScene2(game), true);
        }
    }
}
```

# Assets

Assets (`Asset` objects) are loaded via `Scene.assetManager`. `Asset` base class works as an abstract proxy for any type of resource. Format-specific asset types are implemented as derived classes: `TextureAsset`, `OBJAsset`, `GLTFAsset`, etc. Each type of asset stores decoded data, such as `Texture` object for a `TextureAsset`. Once loaded, you can use the asset to access its data at the scene construction phase:

```d
class MyScene: Scene
{
    TextureAsset aTexture;
    
    override void beforeLoad()
    {
        aTexture = addTextureAsset("assets/texture.png");
    }
    
    override void afterLoad()
    {
        // aTexture.texture can now be referenced:
        someMaterial.baseColorTexture = aTexture.texture;
    }
}
```
