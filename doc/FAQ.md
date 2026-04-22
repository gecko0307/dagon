# Frequently Asked Questions

## Is this a full-fledged game production suite like Unity/UE/Godot?
No, not at all. Dagon only provides a framework for building applications with 3D graphics. It abstracts a lot of complex tasks such as managing a window and handling user input, loading models and textures, 3D transformations, rendering, animation, sound and physics, but it doesn't include any game logics or development tools such as a scene editor.

## Why Dagon doesn't support multiple graphics APIs?
Support for multiple graphics backends (such as Direct3D + different versions of OpenGL + Metal + whatever) brings little benefit, but requires huge resources to implement and maintain. It also limits the GPU features that can be used by the application to a common denominator across all target platforms. Using multiple APIs won't make the engine faster and more reliable, won't add new features, but will increase code complexity and introduce too many otherwise unnecessary abstractions, which is something we would like to avoid.

## Why not Vulkan?
For many years OpenGL was a go-to choice for indie/niche game engines and cross-platforms multimedia applications while commercial production relied on Direct3D for performance reasons. Vulkan addressed many historic issues of OpenGL such as driver overhead and lacking thread-safety, but that was at the cost of increased architectural complexity on the application side. Vulkan is not an easy drop-in OpenGL replacement for an engine like Dagon, and we decided to wait for compromise options. Thanks to the new GPU API in SDL3, Dagon now has high potential to run over Vulkan. However, this won't happen in 1.x branch of the engine. Dagon will be heavily adapted and rewritten in many places, some important features may be dropped, and the port will break backward compatibility in many ways.

## What's the point of `New`/`Delete`? Why not just stop worrying and start using GC?
We understand that avoiding GC makes code less "D-ish". Indeed, garbage collector is not evil or something; in many cases there's no reason not to use it. But GC is not a silver bullet either. It shines in cases where the program cannot predict what and when it allocates. Games are different: their memory usage is usually deterministic, since runtime allocations are expensive and cause frame drops. That's why games typically preallocate most data in advance. In such conditions, GC brings little benefit—there are more efficient memory management strategies for this. Dagon uses dlib's ownership system and treats heap data as a tree of objects. Every object has a strictly defined lifetime and is automatically released when its owner is released. If used idiomatically, this approach lets you write applications with virtually no risk of memory leaks, while avoiding the performance pitfalls inherent in garbage collection.

## Why not `@nogc`?
Dagon is heavily based on dlib, which is not `@nogc` for historical and backward compatibility reasons (core parts of dlib were written in 2011, long before `@nogc`). This is not a big deal, because Dagon itself is not a library, but an application framework. 

## How to fix game stuttering?
The most likely cause of stuttering is VSync enabled in windowed/borderless mode. VSync (vertical synchronization) is a frame timing mode where the output is synchronized with the monitor's refresh rate to eliminate tearing. Enabling VSync limits the FPS to the monitor's refresh rate (usually 60Hz) and forces the renderer to wait for the next vertical refresh, essentially capping performance to 60, 30, or 20 FPS (refresh rate divisors). If the system cannot maintain 60 FPS, VSync forces a drop to 30 FPS, causing a perceptible, sudden jump in frame pacing. For this reason, Dagon disables VSync by default. As a general rule, it should only be enabled if you are experiencing screen tearing, and it usually only makes sense in exclusive fullscreen mode. For monitors with adaptive sync (FreeSync/G-Sync compatible), it's best to always keep VSync disabled.

On Windows, VSync in OpenGL applications usually cause stuttering in windowed mode due to the issues in the frame presentation mechanism, even if the FPS is stable 60. In Windows, all non-exclusive windows are composited by the DWM. The DWM performs a VSync for the entire desktop, regardless of the application's individual VSync settings. When a game enables its own VSync in windowed mode, it essentially creates a "double vsync" problem: buffer swapping doesn't align perfectly with the DWM's composition timing, causing a visible stutter. If you use NVIDIA graphics card, there's a workaround in driver settings: set "Vulkan/OpenGL present method" to "Prefer layered on DXGI Swapchain" in the Control Panel.

## Why my textures look blurry?
Even with high-resolution (1024x1024 and beyond) mipmapping can still smear textures down when sampling under grazing angles. With default settings the GPU ends up sampling from a lower-resolution mip level, which reduces aliasing but also causes loss of detail.

There are two ways to fight this: setting negative LOD bias and using anisotropic filtering. The latter is usually superior option. Anisotropic filtering improves this by taking multiple samples along the direction of texture distortion, effectively increasing resolution only where it is needed. This preserves detail at grazing angles. Dagon enables anisotropy up to the maximum level supported by the GPU, which is typically 16x.

```d
texture.useAnisotropicFiltering = true;
texture.anisotropy = texture.maxAnisotropy;
```

Negative LOD bias forces the GPU to prefer higher-resolution mip levels than it normally would. This can sharpen textures, but may introduce aliasing or shimmering if overused.

```d
texture.lodBias = -0.5f;
```

Use with care: anisotropic filtering usually makes negative LOD bias unnecessary.

## Why matrix-vector multiplication is inverted?
The reason behind this is an optimization under common associativity rules. Generally speaking, there is actually only multiplication of two matrices, and matrix-vector multiplication is its special case. This operation is ambiguous, since you can see the vector as Nx1 matrix (column vector) or 1xN matrix (row vector). The order of operands (and hense results) will be different in each case.

Matrix multiplication involves multiplying each row vector of one matrix by each column vector of another matrix. So in first case (Nx1) we will do `matrix * columnVector`, in second case (1xN): `rowVector * matrix`.

In dlib (and Dagon), there is only one multiplication - `matrix * columnVector`, being the most common of the two. But it is written in 'inverse' (left-associative) order: `columnVector * matrix` (defined as `opBinaryRight` overload for `Matrix` type). This goes against conventional math notation, but computationally is a lot cheaper for long chained expressions.

For example, with normal syntax, expression `m2 * m1 * v` will be evaluated as one full matrix multiplication (64 float multiplications) and then one matrix-vector multiplication (9 float multiplications in affine case). With left-associative syntax, the equivalent `v * m1 * m2` will cause only two matrix-vector multiplications (total 18 float multiplications in affine case). Without parentheses there is no way to force compiler choose optimal execution path, so left-associative syntax was preferred as more concise and requiring less caution from the programmer.

Also left-associative syntax is arguably easier to read.
