# Entity

An Entity (known as Object in some other engines) is a fundamental concept in Dagon, a representation of a "thing" in the game world. It primarily acts as an abstract container for arbitrary 3D or 2D object. Entity supports spatial transformation and has 9 degrees of freedom (position, rotation, and scaling), which are combined into a 4x4 affine transformation matrix.

## Transformation Layout

### Coordinate Systems

Coordinate systems used for 3D transformations often cause confusion and are the root cause of many bugs and incompatibilities between different graphics pipelines. Dagon uses right-hand coordinate system in model/world space, where the positive X-axis points right, the positive Y-axis points up, and the positive Z-axis points forward. In eye space, positive Z-axis points out of the screen, towards the viewer (the camera looks down the negative Z-axis). The projection matrix flips the Z-axis, transforming the right-handed eye space into a left-handed normalized device coordinates (NDC), making depth values positive.

### Transformation Spaces

Model space is the space where vertex coordinates are defined. It is relative to Entity transformation, thus enabling different Entities to use the same mesh data.

Entity transformation maps model space points to Entity's local space, often called a reference frame, or simply a frame, in theoretical mechanics. In Dagon, transformation is always relative; if an Entity has a parent, it inherits the parent's transformation as a reference frame. Absolute reference frame, relative to which the root entities' transformation is defined, is called a world space.

Transformation is stored as a combination of position, rotation, and scaling.

Position is an XYZ vector conventionally measured in meters.

Rotation is stored as a [quaternion](https://en.wikipedia.org/wiki/Quaternion) (XYZW vector), however, it is possible to define rotations with more intuitive pitch-turn-roll system using `Entity.setRotation`, `Entity.pitch`, `Entity.turn`, `Entity.roll` methods. `setRotation` constructs an orientation quaternion with three given angles at once. `pitch`, `turn` and `roll` rotate the current quaternion about X, Y, or Z axes, respectively, by the given delta angle. Angles are measured in degrees.

Note: while pitch-turn-roll approach is convenient for dynamic steering, quaternions are nice for pre-baked animation. You can use `slerp` function to interpolate between two quaternions and animate rotation using keyframe method, in the same way as position can be animated via `lerp`. This ensures a smooth, constant-speed transition along the shortest rotational path, avoiding the gimbal lock and jitter issues common with Euler angle interpolation.

Scaling is a unitless XYZ vector where 1.0 means identity scale, and 0.0 means infinitesimal scale. Dagon supports non-uniform scaling, but it may interfere with geometric logic in unexpected ways, and using it in 3D graphics is generally discouraged.

Combined transformation makes up a 4x4 column-major floating-point matrix (`Matrix4x4f`) of the following layout:

```
[Rx, Ux, Fx, Tx]
[Ry, Uy, Fy, Ty]
[Rz, Uz, Fz, Tz]
[0,  0,  0,  1 ]
```

where `[Tx, Ty, Tz]` is a translation vector, `[Rx, Ry, Rz]` is a right basis vector, `[Ux, Uy, Uz]` is an up basis vector, `[Fx, Fy, Fz]` is a forward basis vector.

Basis vectors represent orthogonal directions of an Entity (given a matrix with identity scaling, they are also already normalized). These directions are often used for simple kinematics and motion planning. For example, if an Entity represents a character, you can make it walk forward or backward by incrementing position in "forward" direction (negated to move backward), or strafe by incrementing position in "right" direction (negated to move left).

## Layers

TODO

## Components

TODO
