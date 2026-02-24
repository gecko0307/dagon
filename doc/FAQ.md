# Frequently Asked Questions

## Why Dagon doesn't support multiple graphics APIs?
Support for multiple graphics backends (such as Direct3D + different versions of OpenGL + Metal + whatever) brings little benefit, but requires huge resources to implement and maintain. It also limits the GPU features that can be used by the application to a common denominator across all target platforms. Using multiple APIs won't make the engine faster and more reliable, won't add new features, but will increase code complexity and introduce too many otherwise unnecessary abstractions, which is something we would like to avoid.

## Why not Vulkan?
Due to the specificity of Vulkan's architecture, it is not a drop-in OpenGL replacement for an engine like Dagon. OpenGL functionality doesn't map one-to-one to Vulkan, the engine would be heavily adapted and rewritten in many places, and some important features may be dropped.

## What's the point of `New`/`Delete`? Why not just stop worrying and start using GC?
We understand that avoiding GC makes code less "D-ish". Indeed, garbage collector is not evil or something; in many cases there's no reason not to use it. But GC is not a silver bullet either. It shines in cases where the program cannot predict what and when it allocates. Games are different: their memory usage is usually deterministic, since runtime allocations are expensive and cause frame drops. That's why games typically preallocate most data in advance. In such conditions, GC brings little benefit—there are more efficient memory management strategies for this. Dagon uses dlib's ownership system and treats heap data as a tree of objects. Every object has a strictly defined lifetime and is automatically released when its owner is released. If used idiomatically, this approach lets you write applications with virtually no risk of memory leaks, while avoiding the performance pitfalls inherent in garbage collection.

## How to fix game stuttering?
The most likely cause of stuttering is VSync enabled in windowed/borderless mode. VSync is a frame timing mode where the output is synchronized with the monitor's refresh rate to eliminate tearing. Enabling VSync limits the FPS to the monitor's refresh rate (usually 60Hz) and forces the renderer to wait for the next vertical refresh, essentially capping performance to 60, 30, or 20 FPS (refresh rate divisors). If the system cannot maintain 60 FPS, VSync forces a drop to 30 FPS, causing a perceptible, sudden jump in frame pacing. For this reason, Dagon disables VSync by default. As a general rule, it should only be enabled if you are experiencing screen tearing, and it only makes sense in exclusive fullscreen mode. For monitors with adaptive sync (FreeSync/G-Sync compatible), it's best to always keep VSync disabled.

On Windows, VSync in OpenGL cause stuttering in windowed mode due to the issues in the window manager and frame presentation mechanism, even if the FPS is stable. If you use NVIDIA graphics card, there's a workaround in driver settings: set "Vulkan/OpenGL present method" to "Prefer layered on DXGI Swapchain" in the Control Panel.

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
