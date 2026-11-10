# Entity

An entity (known as "scene node" or simply "object" in some other engines) is a fundamental concept in Dagon, a representation of a "thing" in the game world. It primarily acts as an abstract container for arbitrary 3D or 2D object. Entity supports spatial transformation and has 9 degrees of freedom (position, rotation, and scaling), which are combined into a 4x4 affine transformation matrix.

## Transformation Spaces and Coordinate Systems

The internals of the engine work in four distinct transformation spaces: model space, world space, eye space and screen space.

Model space is the space where vertex coordinates are defined. It is relative to Entity transformation, thus enabling different Entities to use the same mesh data. In Dagon, transformation is always relative; if an Entity has a parent, it inherits the parent's transformation as a reference frame. Absolute reference frame, relative to which the root entities' transformation is defined, is called a world space.

The rendering pipeline works in eye space, which means that the camera is fixed at (0, 0, 0). Moving and rotating the camera is accomplished by moving and rotating the entire scene in the opposite direction, which allows to avoid complex world-space perspective projection; the transition to screen space on GPU becomes simple and effective. Also doing all the lighting calculations in eye space guarantees highest floating-point precision near the camera.

Dagon sticks to the OpenGL's standard right-handed coordinate system, where +X points right, +Y points up, and +Z points towards the viewer (out of the screen). This means that the camera looks down the negative Z-axis in its model space. Dagon uses the conventional OpenGL perspective matrix internally, where the projected Z coordinate is in the [-1, 1] normalized device coordinate range.

Coordinate systems used for 3D transformations often cause confusion and are the root cause of many bugs and incompatibilities between different graphics pipelines. In computer graphics, the coordinate system choise is arbitrary. It doesn't matter what CS you use as long as the data and math are consistent. Problems arise with assets imported from external tools with different CS. For example, here is the mapping between Blender's CS and Dagon's:

- Blender's +X = Dagon's +X
- Blender's +Y = Dagon's -Z
- Blender's +Z = Dagon's +Y

## Algebra of 3D Transformations

Transformation is stored as a composition of translation (position), rotation, and scaling.

Position is an XYZ vector conventionally measured in meters.

Rotation is stored as a quaternion, however, it is possible to define rotations with more intuitive pitch-turn-roll system using `Entity.setRotation`, `Entity.pitch`, `Entity.turn`, `Entity.roll` methods. `setRotation` constructs an orientation quaternion with three given angles at once. `pitch`, `turn` and `roll` rotate the current quaternion about X, Y, or Z axes, respectively, by the given delta angle. Angles are measured in degrees.

Note: while pitch-turn-roll approach is convenient for dynamic steering, quaternions are nice for pre-baked animation. You can use `slerp` function to interpolate between two quaternions and animate rotation using keyframe method, in the same way as position can be animated via `lerp`. This ensures a smooth, constant-speed transition along the shortest rotational path, avoiding the gimbal lock and jitter issues common with Euler angle interpolation.

Scaling is a unitless XYZ vector where 1.0 means identity scale, and 0.0 means infinitesimal scale. Dagon supports non-uniform scaling, but it may interfere with geometric operations that assume an orthonormal basis. It should therefore be used with care when entities participate in physics, spatial queries, or other geometry-dependent systems.

Combined transformation makes up a 4x4 column-major floating-point matrix (`Matrix4x4f`) of the following layout:

```
[Lx, Ux, Fx, Tx]
[Ly, Uy, Fy, Ty]
[Lz, Uz, Fz, Tz]
[0,  0,  0,  1 ]
```

where `[Tx, Ty, Tz]` is a translation vector, `[Lx, Ly, Lz]` is a left basis vector, `[Ux, Uy, Uz]` is an up basis vector, `[Fx, Fy, Fz]` is a forward basis vector.

Basis vectors represent orthogonal directions of an entity. Given a matrix with identity scaling, they are also already normalized. These directions are often used for simple kinematics and motion planning. For example, if an entity represents a character, you can make it walk forward or backward by incrementing position in "forward" direction (negated to move backward), or strafe by incrementing position in "left" direction (negated to move right).

## Screen Space

Screen space is the final coordinate system used to describe positions on the rendered image. Unlike model, world, and eye space, it is two-dimensional: positions are expressed in terms of the screen's horizontal and vertical coordinates.

The conversion from eye space to screen space is performed by the projection matrix and the viewport transformation. A point in 3D space is first transformed into clip space, then divided by its homogeneous `w` coordinate to obtain normalized device coordinates (NDC), and finally mapped to the viewport.

Conceptually, the transformation is:

```text
model → world → eye → clip → NDC → screen
```

The reverse operation, commonly called unprojection, reconstructs a 3D ray from a screen-space position. This is useful for mouse picking and other screen-to-world interactions. For example, a mouse click can be converted into a ray originating at the camera and passing through the clicked pixel. Intersecting this ray with scene geometry allows the application to determine which entity was selected.

## Entity Properties

- `string name` - symbolic name of an entity, mainly for serialization and script access.
- `Array!Entity children` - dynamic array of child entities. This property should be normally used only for reading, to add children use `addChild` or `setParent` methods.
- `Array!EntityComponent components` - dynamic array of attached components. This property should be normally used only for reading, to add a component use `addComponent` method.
- `Entity parent` - parent entity. If `null`, entity is at the root level in the scene.
- `Matrix4x4f transformation` - local transformation matrix from position/rotation/scale.
- `Matrix4x4f invTransformation` - inverse of local transformation.
- `Matrix4x4f absoluteTransformation` - local-to-world matrix (local combined with parent chain transformation).
- `Matrix4x4f invAbsoluteTransformation` - inverse of `absoluteTransformation`.
- `Matrix4x4f prevTransformation` -  previous frame `transformation`.
- `Matrix4x4f prevAbsoluteTransformation` - previous frame `absoluteTransformation`. This can be used to compute world-space deltas for different tasks such as screen-space effects.
- `Vector3f position` - local position.
- `Quaternionf rotation` - local orientation.
- `Vector3f scaling` - local scale. It is named `scaling` to avoid conflict with dlib's `scale` function.
- `Drawable drawable` - optional drawable object for rendering. This is usually an indexed triangle mesh.
- `Material material` - optional material for rendering. This material can be overridden in the drawable, if it is a multi-material mesh.
- `EntityLayer layer` - logical layer this entity belongs to. Supported values are `EntityLayer.Background`, `EntityLayer.Spatial`, `EntityLayer.Foreground`. Exact semantics of the logical layers are renderer-dependent. Default is `EntityLayer.Spatial`.
- `int renderLayer` - render layer this entity belongs to. Supported only in `SimpleRenderer`.
- `bool transparent` - if true, the entity is treated as transparent by the renderer.
- `float opacity` - base visibility alpha. This is multiplied with material's opacity. Default is `1.0f`. Note that the deferred pipeline doesn't support semi-transparency (opacity is used for alpha clipping). To render semi-transparent entities via the forward pipeline, change material's `blendMode` to `BlendMode.Transparent`.
- `float blurMask` - entity's contribution to the screen-space motion blur. If set to 0, it will not be blurred. Usually this should be set to 0 for objects that are attached to the camera (for example, a weapon in a first-person shooter). Default is `1.0f`.
- `bool visible` - visibility flag. Invisible objects are not rendered. Note that invisible parent can have visible children, and vice-versa. Default is `true`.
- `bool castShadow` - cast shadows flag. If set to `false`, the entity won't cast any shadows. Default is `true`.
- `bool dynamic` - if true, the entity is treated as moving/animated, and its transforms are recomputed each frame. Default is `false` (because the vast majority of 3D scenery in games is static).
- `bool decal` - if true, the entity is treated as a deferred decal.
- `TransformMode transformMode` - transformation mode. Determines how the engine updates entity's `transformation` matrix. Possible values are the following:
  - `TransformMode.TRS` (default) - `transformation` is computed from `position`, `rotation` and `scaling`
  - `TransformMode.Matrix` - `transformation` is used-defined; `position`, `rotation` and `scaling` are ignored.
