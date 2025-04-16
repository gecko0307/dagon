# dagon:physfs

PhysFS-based virtual filesystem extension. Allows to use archives as asset sources in `assetManager.fs`.

## Usage

```d
import dagon.ext.physfs;

class TestScene: Scene
{
    this(Game game)
    {
        super(game);
        
        PhysFS pfs = New!PhysFS(null);
        pfs.addSearchPath("./data");
        pfs.addSearchPath("data.zip");
        assetManager.fs.mount(pfs);
    }
}
```
