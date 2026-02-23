# Jolt Physics

[Jolt Physics](https://github.com/jrouwe/JoltPhysics) is a robust and performant Open Source real-time physics engine by Jorrit Rouwe of Guerrilla Games. Battle-tested in AAA production, Jolt is gaining popularity and is used by major free game engines such as Godot, NeoAxis, GDevelop, Gaijin Entertainment's Dagor Engine, and many others. Dagon includes Jolt as an alternative to Newton. They provide roughly the same feature set, but Jolt has higher potential, supporting advanced features like soft bodies, ragdolls and vehicle simulation.

## Comparison with Newton

dagon:jolt is designed in a very similar way to dagon:newton to ensure easy migration.

### World

dagon:jolt provides `JoltPhysicsWorld`, an equivalent to `NewtonPhysicsWorld`.

### Shapes

Shapes are organized in the same way as in Newton: all shapes are specializations of an abstract base class. Jolt supports almost all shape types of Newton, plus a number of additional types.

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

### Bodies

In dagon:jolt there's no distinction between a rigid body wrapper and a body controller, they are combined into one `JoltBodyController`. Body controllers for Entities are created using `JoltPhysicsWorld.addStaticBody` and `JoltPhysicsWorld.addDynamicBody`.

### Character Controller

TODO

### Constraints

TODO

### Raycasting

TODO
