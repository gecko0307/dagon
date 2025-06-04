# dagon:assimp

Assimp-based asset loader. Brings support for many additional 3D model formats to Dagon, including FBX, Collada, 3DS and others.

## Usage

```d
import dagon;
import dagon.ext.assimp;

class MyScene: Scene
{
    AssimpAsset aModel;
    
    this(Game game)
    {
        super(game);
    }
    
    override void beforeLoad()
    {
        aModel = this.addAssimpAsset("assets/model.fbx");
        aModel.loaderOption =
            aiPostProcessSteps.Triangulate | aiPostProcessSteps.FlipUVs;
    }
}
```
