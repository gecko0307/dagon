# Virtual File System

In Dagon, all files are loaded using the built-in virtual file system (VFS). Its main purpose is to provide a consistent interface for accessing game data, regardless of where it is stored physically. The VFS allows to store files anywhere on the disk, and even mount different storage backends (such as archives, using dagon:physfs extension), and the files will be available to the application in the same way as if they were stored in the working directory.

The VFS is managed by the `Application` class and is available as `Application.vfs` property.

Key concept of the VFS is mounting. For a location to be accessed, it has to be mounted using `vfs.mount` method. File search is performed on a LIFO basis: the last mounted location has the highest priority. If the file is not found there, the previously mounted location is checked, and so on. The engine automatically mounts the following directories at the start:
- Working directory. This is always the last location to search;
- The application data directory (`C:\Users\AppData\Roaming\<appDataFolder>` on Windows and `~\<appDataFolder>` on Linux).

`<appDataFolder>` is `.dagon` by default and can be overridden in the constructor of the class inherited from the `Game` or `Application`:

```d
class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args, ".my_game");
        
        vfs.mount("data");
    }
}
```

You can mount any other locations, absolute or relative to the working directory.

The application data directory is not created by default, you can create it using `vfs.createAppDataDirectory` method. Its typical purpose is to keep user-specific game data, such as configuration files, saves, and mods. Because the application data directory overrides the working directory, any game resource can be safely modified without compromising the integrity of the original resource. This, potentially, allows total conversions, provided that the game logic does not rely on hardcoded assumptions about the structure of its resources.

## Mounting custom file systems

`vfs.mount` allows to mount any external storage system that implements `ReadOnlyFileSystem` interface. One use case for this is PhysFS integration which allows to load files from archives:

```d
import dagon.ext.physfs;

class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        
        PhysFS pfs = New!PhysFS();
        pfs.addSearchPath("./data");
        pfs.addSearchPath("data.zip");
        vfs.mount(pfs);
    }
}

void main(string[] args)
{
    PhysFSSupport sup = loadPhysFS();
    initPhysFS(args[0]);
    
    MyGame game = New!MyGame(1280, 720, false, "Dagon Demo", args);
    game.run();
    Delete(game);
    
    releasePhysFS();
}
```
