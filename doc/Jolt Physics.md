# Jolt Physics

[Jolt Physics](https://github.com/jrouwe/JoltPhysics) is a robust and performant Open Source real-time physics engine written by Jorrit Rouwe of Guerrilla Games. Battle-tested in AAA production, Jolt is gaining popularity and is used by major free game engines such as Godot, NeoAxis, GDevelop, Gaijin Entertainment's Dagor, and many others. Dagon includes Jolt as an alternative to Newton. They implement roughly the same feature set, but Jolt has higher potential, supporting advanced features like soft bodies, ragdolls and vehicle simulation.

Jolt is available in Dagon via dagon:jolt extension.

## Usage

### World

dagon:jolt is designed in a very similar way to dagon:newton to ensure easy migration. It provides `JoltPhysicsWorld`, an equivalent to `NewtonPhysicsWorld`. Before accessing the API, `joltInit` should be called to load the library.

```d
class MyGame: Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        
        if (!joltInit())
            exit();
        
        currentScene = New!MyScene(this);
    }
    
    ~this()
    {
        joltShutdown();
    }
}

class MyScene: Scene
{
    JoltPhysicsWorld physicsWorld;

    this(MyGame game)
    {
        super(game);
        this.game = game;
        
        physicsWorld = New!JoltPhysicsWorld(eventManager, this);
    }
}
```

### Shapes

A shape is a geometric data that is attached to a rigid body and used for collision detection. Shapes are organized in the same way as in Newton: all shapes are specializations of an abstract base class. Jolt supports almost all shape types of Newton, plus a number of additional types:

| Newton                            | Jolt                         |
|-----------------------------------|------------------------------|
| `NewtonCollisionShape` (abstract) | `JoltShape` (abstract)       |
| `NewtonSphereShape`               | `JoltSphereShape`            |
| `NewtonBoxShape`                  | `JoltBoxShape`               |
| n/a                               | `JoltPlaneShape`             |
| `NewtonCapsuleShape`              | `JoltCapsuleShape`           |
| n/a                               | `JoltTaperedCapsuleShape`    |
| `NewtonCylinderShape`             | `JoltCylinderShape`          |
| `NewtonChamferCylinderShape`      | n/a                          |
| n/a                               | `JoltTaperedCylinderShape`   |
| `NewtonConeShape`                 | `JoltConeShape`              |
| `NewtonMeshShape`                 | `JoltMeshShape`              |
| `NewtonConvexHullShape`           | `JoltConvexHullShape`        |
| `NewtonCompoundShape`             | `JoltCompoundShape`          |
| n/a                               | `JoltMutableCompoundShape`   |
| `NewtonHeightmapShape`            | `JoltHeightmapShape`         |
| n/a                               | `JoltRotatedTranslatedShape` |
| n/a                               | `JoltScaledShape`            |

Shape creation example:

```d
JoltBoxShape box = New!JoltBoxShape(Vector3f(1.0f, 1.0f, 1.0f), physicsWorld);
```

`JoltBoxShape` accepts half-extents of the box, analogous to Dagon's built-in `ShapeBox`.

### Rigid Bodies

A rigid body is a main building block in a physical simulation. It represents a 6-DOF object that reacts to collisions and external forces which make it move and rotate. Bodies can be static and dynamic.

Bodies are attached to Entities via the component mechanism. In dagon:jolt there's no distinction between a rigid body wrapper and a body controller, they are combined into one `JoltRigidBody`. Body controllers for Entities are created using `JoltPhysicsWorld.addStaticBody` and `JoltPhysicsWorld.addDynamicBody`:

```d
Entity eBox = addEntity();
const float boxMass = 10.0f;
JoltRigidBody boxBody = physicsWorld.addDynamicBody(eBox, box, boxMass);
```

### Constraints

| Newton                            | Jolt                         |
|-----------------------------------|------------------------------|
| `NewtonConstraint` (abstract)     | `JoltConstraint` (abstract)  |
| n/a                               | `JoltFixedConstraint`        |
| `NewtonBallConstraint`            | `JoltPointConstraint`        |
| n/a                               | `JoltDistanceConstraint`     |
| n/a                               | `JoltHingeConstraint`        |
| `NewtonSliderConstraint`          | `JoltSliderConstraint`       |
| n/a                               | `JoltConeConstraint`         |
| n/a                               | `JoltSwingTwistConstraint`   |
| `NewtonCorkscrewConstraint`       | n/a                          |
| `NewtonUniversalConstraint`       | `JoltSixDOFConstraint`       |
| `NewtonUpVectorConstraint`        | n/a                          |
| n/a                               | `JoltGearConstraint`         |
| `NewtonUserConstraint`            | n/a                          |

### Character Controller

TODO

### Raycasting

TODO
