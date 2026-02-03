# dagon:newton

Rigid body physics simulation extension that uses [Newton Dynamics](https://newtondynamics.com/forum/newton.php) library via [bindbc-newton](https://github.com/gecko0307/bindbc-newton) dynamic binding. Provides a basic object-oriented wrapper for Newton functions.

## Usage

To use the extension, some groundwork is required. First, Newton shared library must be loaded:

```d
import std.stdio;
import std.conv;

import dagon;
import dagon.ext.newton;

void main(string[] args)
{
    NewtonSupport sup = loadNewton();

    debug
    {
        import loader = bindbc.loader.sharedlib;
        foreach(info; loader.errors)
            logError(info.error.to!string, " ", info.message.to!string);
    }

    // Create your game and scenes...
}
```

All Newton functionality require `NewtonPhysicsWorld` object. Think of it as a global state which manages bodies and their interactions. To run the simulation step, you should call `world.update`.

```d
class PhysicsScene: Scene
{
    NewtonPhysicsWorld world;

    // ...

    override void afterLoad()
    {
        world = New!NewtonPhysicsWorld(eventManager, assetManager);

        // ...
    }

    override void onUpdate(Time t)
    {
        world.update(t.delta);
    }
}
```

Now we can create bodies, which is very easy. Any body requires a shape - an object that is used to detect collisions. For example, this is how a box shape is created:

```d
auto box = New!NewtonBoxShape(Vector3f(0.5f, 0.5f, 0.5f), world);
```

Then, given you already have an `Entity`, you can create a rigid body controller for it (the last parameter is the mass):

```d
auto controller = yourEntity.makeDynamicBody(world, box, 100.0f);
```

Or you can create a static body instead:

```d
auto controller = yourEntity.makeStaticBody(world, box);
```

Newton supports the following shapes: Box, Sphere, Cylinder, ChamferCylinder, Capsule, Cone, ConvexHull, Mesh, Heightmap. It is also possible to combine multiple shapes into one using Compound shape.

```d
auto box = New!NewtonBoxShape(Vector3f(0.5f, 0.5f, 0.5f), world); // extents = [0.5, 0.5, 0.5]
auto sphere = New!NewtonSphereShape(0.5f, world); // radius = 0.5
auto cylinder = New!NewtonCylinderShape(0.5f, 0.5f, 1.0f, world); // radius1 = 0.5, radius2 = 0.5, height = 1
auto chamferCylinder = NewtonChamferCylinderShape(0.5f, 1.0f, world); // radius = 0.5, height = 1
auto capsule = NewtonCapsuleShape(0.5f, 1.0f, world); // radius = 0.5, height = 1
auto cone = NewtonConeShape(0.5f, 1.0f, world); // radius = 0.5, height = 1
```

ConvexHulls and Meshes are a bit different. They rely on `TriangleSet` interface which is designed to be as abstract as possible, making it possible to create Newton shapes from almost anything. The simplest way is to use `Mesh` object (for example, loaded from OBJ file) which already implements `TriangleSet`:

```d
auto convexHull = New!NewtonConvexHullShape(objAsset.mesh, 0.0f, world);
```

`NewtonMeshShape` (concave mesh) is created in the same way:

```d
auto mesh = New!NewtonMeshShape(objAsset.mesh, world);
```

If you want to load an entire level for static collisions, we recommend using [glTF](https://www.khronos.org/gltf/) format. `GLTFAsset` also implements `TriangleSet`, so it can be used directly with Newton:

```d
class PhysicsScene: Scene
{
    GLTFAsset levelAsset;

    // ...

    override void beforeLoad()
    {
        levelAsset = New!GLTFAsset(assetManager);
        addAsset(levelAsset, "data/level.gltf");
    }

    override void afterLoad()
    {
        // ...

        useEntity(levelAsset.rootEntity);
        foreach(node; levelAsset.nodes)
        {
            useEntity(node.entity);
        }

        auto levelEntity = addEntity();
        auto levelMesh = New!NewtonMeshShape(levelAsset, world);
        levelEntity.makeStaticBody(world, levelMesh);
    }
}
```

Convex hulls can be both static and dynamic. Concave meshes can be only static.
