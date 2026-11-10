# Math

Dagon comes with a powerful and highly efficient vector math library, `dlib.math`. It implements all algebraic objects necessary for real-time graphics:

- 2D, 3D and 4D vectors
- 2×2, 3×3 and 4×4 transformation matrices
- Quaternions.

## Vectors

Mathematical apparatus of 3D graphics relies on the notion of a vector space. In linear algebra, a vector is a generalization of a number for an arbitrary number of dimensions.

The simplest space is 1D space, the usual set of real numbers (scalars).

2D and 3D Euclidean vector spaces are also rather intuitive; they represent real-world spaces that we deal with in everyday life. In Dagon, they are represented by `Vector2f` and `Vector3f` types. The number denotes dimensionality, and the letter hints numeric precision: `f` stands for `float`. If you prefer, you can use the short form that omits precision symbol: `vec2`, `vec3`. There are also double-precision and integer vectors, but they are rarely used.

Vectors are value types: they are copied by value unless the programmer explicitly uses pointers or reference semantic.

Vectors can be accessed like arrays, using the indexing syntax:

```d
Vector3f v = Vector3f(1, 2, 3);
float x = v[0];
v[1] = 4;
```

Alternatively, vectors can be accessed like structures, by symbolic fields. dlib supports `xyzw`, `rgba`, and `stpq` notations, which address the same four elements. `xyzw` is used for points and directions; `rgba` is used for colors; `stpq` is used for texture coordinates.

```d
Vector3f v = Vector3f(1, 2, 3);
float x = v.x;
v.y = 4;
```

Vector swizzling is supported. Swizzling is a syntactic sugar that allows to construct a new vector from the arbitrary elements of another vector using symbolic access:

```d
Vector3f v1 = Vector3f(1, 2, 3);
Vector3f v2 = v1.xxy; // will be (1, 1, 2)
```

Vectors support per-component arithmetic: they can be added, subtracted, multiplied and divided.

```d
Vector3f v3 = v1 + v2;
```

You can also use scalars in vector arithmetic, in which cases scalars are implicitly widened to the corresponding dimensionality:

```d
Vector3f v3 = v1 + 10;
```

The length, or magnitude, of a vector is a scalar that represents the distance from the origin to the point described by the vector.

For a vector

```text
v = (x, y, z)
```

its length is defined by the Pythagorean theorem:

```text
|v| = sqrt(x² + y² + z²)
```

In `dlib.math`, the `length` function computes the magnitude of a vector:

```d
Vector3f v = Vector3f(3, 4, 0);
float len = v.length; // 5
```

Sometimes the actual length is not required. For example, when comparing distances, only their relative magnitudes matter. Computing a square root is more expensive than a few multiplications, so `lengthsqr` can be used instead:

```d
float distance1 = (a - b).lengthsqr;
float distance2 = (c - d).lengthsqr;

if (distance1 < distance2)
    // a is closer to b
```

The squared length is simply:

```text
|v|² = x² + y² + z²
```

and therefore avoids the square root operation.

A normalized vector has the same direction as the original vector but a length of one. It is obtained by dividing the vector by its length:

```text
v̂ = v / |v|
```

For example:

```d
Vector3f direction = Vector3f(3, 4, 0);
direction.normalize();
assert(direction.length == 1);
```

Normalization is particularly important in graphics because many algorithms expect vectors representing directions rather than arbitrary displacements.

A normalized vector contains no information about distance; only its direction remains.

> **Note:** a zero-length vector cannot be normalized because division by zero is undefined. Code that may encounter zero vectors should handle this case explicitly.

The dot product combines two vectors and produces a scalar:

```text
a · b = ax bx + ay by + az bz
```

The result is related to the angle between the vectors:

```text
a · b = |a| |b| cos θ
```

When both vectors are normalized, this becomes particularly useful:

```text
a · b = cos θ
```

For example, the dot product can determine whether two directions point towards each other:

```d
Vector3f a = Vector3f(1, 0, 0);
Vector3f b = Vector3f(0, 1, 0);

float d = dot(a, b); // 0
```

A positive result means that the angle between the vectors is less than 90°, zero means that they are perpendicular, and a negative result means that the angle is greater than 90°.

The dot product is one of the most frequently used operations in real-time graphics. It is used for lighting, back-face culling, visibility tests, projections, reflections, and many other algorithms.

The cross product is defined for three-dimensional vectors and produces another 3D vector:

```text
a × b =
(
    ay bz - az by,
    az bx - ax bz,
    ax by - ay bx
)
```

Unlike the dot product, the result is a vector. It is perpendicular to both input vectors.

```d
Vector3f a = Vector3f(1, 0, 0);
Vector3f b = Vector3f(0, 1, 0);
Vector3f c = cross(a, b);
// c = (0, 0, 1)
```

The direction of the resulting vector follows the right-hand rule. Swapping the operands reverses the direction:

```text
a × b = -(b × a)
```

The length of the cross product is related to the area of the parallelogram formed by the two vectors:

```text
|a × b| = |a| |b| sin θ
```

This makes the cross product useful for constructing perpendicular directions, calculating surface normals, and working with coordinate frames.

For example, a triangle normal can be calculated from two of its edges:

```d
Vector3f edge1 = p1 - p0;
Vector3f edge2 = p2 - p0;
Vector3f normal = cross(edge1, edge2).normalized;
```

## Matrices

Matrices are rectangular arrays of numbers that can represent linear transformations. In computer graphics, matrices are primarily used to transform points and vectors between coordinate spaces.

Dagon provides 2×2, 3×3 and 4×4 matrices. The most commonly used type in 3D graphics is `Matrix4f`.

A 4×4 matrix can represent translation, rotation, scaling, and combinations of these transformations.

For example, a scaling matrix can be written as:

```text
S = | sx  0   0   0 |
    | 0   sy  0   0 |
    | 0   0   sz  0 |
    | 0   0   0   1 |
```

Applying it to a point scales each coordinate independently.

A translation matrix uses the last column to store the displacement:

```text
T = | 1  0  0  tx |
    | 0  1  0  ty |
    | 0  0  1  tz |
    | 0  0  0  1  |
```

The additional fourth coordinate is known as the homogeneous coordinate. A point is represented as `(x, y, z, 1)`, while a direction is represented as `(x, y, z, 0)`. This distinction allows translation to affect points while leaving directions unchanged.

Matrices can be multiplied to combine transformations:

```text
M = T × R × S
```

The resulting matrix represents scaling, followed by rotation, followed by translation.

In Dagon, matrices can be multiplied using the usual multiplication operator:

```d
Matrix4f transform = translation * rotation * scale;
```

Matrix multiplication is not commutative:

```text
A × B ≠ B × A
```

Therefore, the order of transformations is significant.

## Quaternions

Quaternions are a mathematical representation of rotations in three-dimensional space. Dagon provides them as an alternative to representing rotations with Euler angles or rotation matrices.

A quaternion consists of four components:

```text
q = (x, y, z, w)
```

A unit quaternion represents a rotation around an arbitrary axis. Given a normalized axis `a` and an angle `θ`, the corresponding quaternion is:

```text
q = (
    ax sin(θ/2),
    ay sin(θ/2),
    az sin(θ/2),
    cos(θ/2)
)
```

For example, a rotation around the Y axis can be represented by:

```d
Quaternionf rotation = rotationQuaternion!float(Axis.y, angle);
```

Quaternions are especially useful for composing and interpolating rotations. Unlike Euler angles, they do not suffer from gimbal lock when representing arbitrary orientations.

Two rotations can be combined by quaternion multiplication:

```d
Quaternionf rotation = rotationA * rotationB;
```

Quaternions can be converted to rotation matrices when a matrix representation is required by the rendering pipeline.

In practical graphics code, quaternions are most useful for storing object orientation and composing rotations, while matrices are used when transforming geometry.
