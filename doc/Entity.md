# Entity

An Entity (known as Scene Node or simply Object in some other engines) is a fundamental concept in Dagon, a representation of a "thing" in the game world. It primarily acts as an abstract container for arbitrary 3D or 2D object. Entity supports spatial transformation and has 9 degrees of freedom (position, rotation, and scaling), which are combined into a 4x4 affine transformation matrix.

## Transformation Spaces and Coordinate Systems

The internals of the engine work in four distinct transformation spaces: model space, world space, eye space and screen space.

Model space is the space where vertex coordinates are defined. It is relative to Entity transformation, thus enabling different Entities to use the same mesh data. In Dagon, transformation is always relative; if an Entity has a parent, it inherits the parent's transformation as a reference frame. Absolute reference frame, relative to which the root entities' transformation is defined, is called a world space.

The rendering pipeline works in eye space, which means that the camera is fixed at (0, 0, 0). Moving and rotating the camera is accomplished by moving and rotating the entire scene in the opposite direction, which allows to avoid complex world-space perspective projection; the transition to screen space on GPU becomes simple and effective. Also doing all the lighting calculations in eye space guarantees highest floating-point precision near the camera.

Dagon sticks to the OpenGL's standard right-handed coordinate system, where the +X points right, +Y points up, and +Z points towards the viewer (out of the screen). This means that the camera looks down the negative Z-axis in its model space. The projection matrix flips Z-coordinates, making depth values positive in NDC.

Coordinate systems used for 3D transformations often cause confusion and are the root cause of many bugs and incompatibilities between different graphics pipelines. In computer graphics, the coordinate system choise is arbitrary. It doesn't matter what CS you use as long as the data and math are consistent. Problems arise with assets imported from external tools with different CS. For example, here is the mapping between Blender's CS and Dagon's:

- Blender's +X = Dagon's +X
- Blender's +Y = Dagon's -Z
- Blender's +Z = Dagon's +Y

## Algebra of 3D Transformations

Transformation is stored as a composition of translation (position), rotation, and scaling.

Position is an XYZ vector conventionally measured in meters.

Rotation is stored as a [quaternion](https://en.wikipedia.org/wiki/Quaternion) (XYZW vector), however, it is possible to define rotations with more intuitive pitch-turn-roll system using `Entity.setRotation`, `Entity.pitch`, `Entity.turn`, `Entity.roll` methods. `setRotation` constructs an orientation quaternion with three given angles at once. `pitch`, `turn` and `roll` rotate the current quaternion about X, Y, or Z axes, respectively, by the given delta angle. Angles are measured in degrees.

Note: while pitch-turn-roll approach is convenient for dynamic steering, quaternions are nice for pre-baked animation. You can use `slerp` function to interpolate between two quaternions and animate rotation using keyframe method, in the same way as position can be animated via `lerp`. This ensures a robust transition along the shortest rotational path, avoiding the gimbal lock and jitter issues common with Euler angle interpolation.

Scaling is a unitless XYZ vector where 1.0 means identity scale, and 0.0 means infinitesimal scale. Dagon supports non-uniform scaling, but it may interfere with geometric logic in unexpected ways, and using it in 3D graphics is generally discouraged.

## Screen Space

TODO
