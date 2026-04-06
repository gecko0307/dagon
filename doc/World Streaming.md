# World Streaming

World streaming is a technique utilized in games with huge open worlds. It allows the game to load and unload fixed-sized parts of the map as the player travels through it.

The system assumes that the player travels predominantly on a planar surface (XZ plane). The world is divided into a 2D grid of chunks with a predefined size (for example, 100x100 meters). At any given time, the system only keeps a window of 9 chunks around the traveler. If the traveler moves to an adjacent chunk, the game loads new "visible" neighboring chunks and unloads "invisible" ones. Loading is done at the background using thread-safe functions.

## Core concepts
- `WorldChunk`. An abstract container for user-defined data. For example, a `WorldChunk` implementation can store assets and entitites, include their initilization code and probably some game-specific logic (physics, sound, etc). Typically the world will be built from chunks of the same type (but with different data), but this is not necessary, some chunks may require special initialization code.
- `OpenWorldManager`. A class that stores a predefined map of chunks and manages the core streaming logic. It updates chunks based on the traveler's location. It also stores traveler's chunk coordinates (integer x, y) and calculates an offset vector for coordinate wrapping.
- Traveler is an `Entity` for the player-controlled character that moves through the world. When player crosses a border between chunks, a wrap offset vector is applied to all managed objects, so that the geometry and calculations are kept in a limited area around the origin. This allows to keep highest possible numeric precision while maintaining an illusion of large travel distances.

The system at its core is very simple and minimalistic. It covers only state tracking; all game-specific logic is implemented in custom chunk classes. It is your responsibility to keep it fast enough for best user experience.

## Usage

A simple chunk class that keeps track of a glTF asset for rendering and a static rigid body for collisions can look like this:

```d
class MeshChunk: WorldChunk
{
    /// Scene that the chunk exists in
    MyScene scene;
    
    /// Root entity of the asset
    Entity root;
    
    /// Asset object
    GLTFAsset asset;
    
    /// Asset filename
    string filename;
    
    /// Collision shape
    JoltMeshShape shape;
    
    /// Static body for collisions
    JoltRigidBody rigidBody;
    
    /// Wrapped-world space coordinates of the chunk center
    Vector3f rootOrigin;
    
    this(MyScene scene, string filename, float chunkSize, uint x, uint z, Owner owner)
    {
        super(x, z, false, owner);
        this.scene = scene;
        this.filename = filename;
        rootOrigin = Vector3f(chunkSize * x, 0.0f, chunkSize * z);
        
        if (active)
            onActivate();
        else
            onDeactivate();
    }
    
    override void onWrap(Vector3f offset)
    {
        rootOrigin += offset;
        if (root)
            root.position = rootOrigin;
        if (rigidBody)
            rigidBody.position = rootOrigin;
    }
    
    override void onActivate()
    {
        asset = New!GLTFAsset(scene.assetManager);
        scene.assetManager.reloadAsset(asset, filename);
        asset.markTransparentEntities();
        root = asset.rootEntity;
        root.position = rootOrigin;
        root.updateTransformation();
        scene.useEntity(root, true);
        
        shape = New!JoltMeshShape(asset, this);
        if (rigidBody is null)
        {
            rigidBody = scene.physicsWorld.addStaticBody(root, shape);
            rigidBody.friction = 0.5f;
        }
        else
        {
            rigidBody.setShape(shape);
        }
        
        root.show();
    }
    
    override void onDeactivate()
    {
        if (root)
        {
            root.hide();
            root.drawable = null;
            scene.removeEntity(root, true);
            root = null;
        }
        
        if (asset)
        {
            deleteOwnedObject(asset);
            asset = null;
        }
        
        if (shape)
        {
            deleteOwnedObject(shape);
            shape = null;
        }
    }
}
```

Then in the scene class we can create `OpenWorldManager` and add some `MeshChunk`s:

```
enum float chunkSize = 100.0f;

// 10x10 chunk map
openWorld = New!OpenWorldManager(10, 10, chunkSize, character, this);
openWorld.onTravelerWrap = &onTravelerWrap;

auto chunk_0_0 = New!MeshChunk(this, "data/maps/chunk_0_0.gltf", chunkSize, 0, 0, openWorld);
openWorld.addChunk(chunk_0_0);

auto chunk_1_0 = New!MeshChunk(this, "data/maps/chunk_1_0.gltf", chunkSize, 1, 0, openWorld);
openWorld.addChunk(chunk_1_0);

auto chunk_0_1 = New!MeshChunk(this, "data/maps/chunk_0_1.gltf", chunkSize, 0, 1, openWorld);
openWorld.addChunk(chunk_0_1);

chunk_0_0.activate();
```

`onTravelerWrap` callback method is used to wrap character object's position when it crosses a border between chunks:

```
void onTravelerWrap(Entity traveler, Vector3f offset)
{
    traveler.position += offset;
}
```

This is not done automatically by the manager because, depending on the game, the wrap may require additional synchronization logic where the order of operations matter.
