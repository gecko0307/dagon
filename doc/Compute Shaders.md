# Compute Shaders

Compute shaders are special GPU programs designed for general-purpose computations without being tied to the traditional rendering pipeline. Unlike vertex or fragment shaders, they don't need a mesh or a framebuffer to work. They operate on arbitrary data, and you can launch them explicitly to accelerate parallel algorithms such as image processing, physics simulations, particle systems, AI grid calculations, and more.

## Key Concepts

### ComputeProgram
A `ComputeProgram` represents a compiled compute shader. It plays the same role as `ShaderProgram` for rendering shaders (vertex/fragment), but contains only one stage: the compute stage. You pass the GLSL source code of your compute shader to it, it compiles and links the program. Later, you attach it to a `ComputeShader` object to actually run computations.

This separation lets you manage shader sources, recompile them, or share them between multiple `ComputeShader` specializations.

### ComputeShader
A `ComputeShader` wraps around a `ComputeProgram` and provides the higher-level runtime interface:
- Binding shader parameters
- Binding image textures for reading and writing
- Dispatching the shader with a specified workload.
- Enforcing memory barriers to guarantee correct read/write order.

You usually subclass `ComputeShader` to define your own GPU task (for example, `BlurShader`, `ParticlesUpdateShader`).

### Workgroup
A workgroup is the fundamental unit of execution. Each workgroup contains a fixed number of shader invocations (threads). The size of a workgroup (e.g. `local_size_x = 16, local_size_y = 16`) is defined in the shader code itself. Inside a workgroup, invocations can share data through shared memory and synchronize using barriers.

Tuning the workgroup size is important for performance — it should align well with your GPU's hardware thread scheduler. A shader writer defines the work group size explicitly in GLSL code. Dagon automatically queries this and helps you dispatch the correct number of groups.

### Compute Space
The compute space is the 3D grid of workgroups that you dispatch. Think of it as a box equially divided into small cells. Each invocation can query its position in this space via built-in variables like `gl_GlobalInvocationID`. You can map this space directly onto a 2D texture, a 3D voxel field, or just a flat buffer of data. For example, a blur filter might use compute space matching the width and height of the target image.

### Dispatching
Dispatching is how you invoke GPU threads to execute your compute shader code. You call `dispatch(x, y, z)` or a convenience method `run(width, height, depth)` that automatically calculates the compute space from the given data size. The GPU then launches work groups in parallel to cover the specified problem space. Dispatching is explicit: nothing happens until you tell the GPU to start. Unlike render shaders, there are no draw calls — just raw parallel computation.

### TextureAccessMode
This enum specifies how your shader is allowed to interact with a bound image texture:
- `TextureAccessMode.Read` — read-only access
- `TextureAccessMode.Write` — write-only access (e.g. generating or clearing data)
- `TextureAccessMode.ReadWrite` — both read and write in the same shader.

This mode is passed to `glBindImageTexture` under the hood. Correctly setting access prevents undefined behavior and helps the GPU optimize memory access.

### Memory Barriers
When using compute shaders, you must explicitly control memory visibility between shader passes. After a compute shader writes to a texture or buffer, the data might not be immediately visible to subsequent reads. To enforce ordering, call `ComputeShader.barrier` method with a specific `ComputeBarrier` flag. For example, use `ComputeBarrier.ShaderImageAccess` to ensure image writes are finished before sampling from the same image, or simply use `ComputeBarrier.All` if you want a safe default. This mechanism ensures that your algorithms behave deterministically and prevents race conditions.

## Basic Workflow

The typical workflow for using compute shaders in Dagon consists of the following steps:

1. **Write a Compute Shader**

   * Create a GLSL compute shader source file.
   * Define the workgroup size at the top of the shader using `layout(local_size_x=..., local_size_y=..., local_size_z=...) in;`.
   * Implement your algorithm inside `main()`. You'll usually index into your data using `gl_GlobalInvocationID`.

```glsl
#version 430
layout(local_size_x = 16, local_size_y = 16) in;

layout(rgba8, binding = 0) readwrite uniform image2D img;

void main()
{
    ivec2 coord = ivec2(gl_GlobalInvocationID.xy);
    vec4 color = imageLoad(img, coord);
    imageStore(img, coord, vec4(1.0 - color.rgb, 1.0));
}
```

2. **Derive from ComputeShader**

   * Create a subclass of `ComputeShader` that represents your specific GPU task.
   * In its constructor, load the shader source and pass it into a `ComputeProgram`. Expose shader parameters (in the same way as in ordinary `Shader`).

```d
import dagon;

class InvertShader: ComputeShader
{
    protected String cs;
    Texture inputTexture;
    
    this(Texture inputTexture, Owner owner)
    {
        this.inputTexture = inputTexture;
        
        cs = Shader.load("shaders/invert.comp");
        auto program = New!ComputeProgram(cs, owner);
        super(program, owner);
    }
    
    ~this()
    {
        cs.free();
    }
    
    override void bindParameters(GraphicsState* state)
    {
        if (inputTexture)
            bindImageTexture(0, inputTexture, TextureAccessMode.ReadWrite);
    }
    
    void run()
    {
        if (inputTexture)
            super.run(inputTexture.width, inputTexture.height);
    }
}
```

3. **Dispatch Work**

   * Call `run(width, height, depth)` to execute the shader across your data. `width`, `height` and `depth` usually match the size of the texture or buffer you're writing to. `depth` is 1 by default.
   * The system automatically calculates the number of workgroups needed based on the shader's declared `local_size`.
   * It is convenient to provide an overloaded `run` that automatically sets the output data size.

```d
auto invert = new InvertShader(myTexture, owner);
invert.run();
```

4. **Synchronize Memory (Barriers)**

   * By default, `run()` inserts a full barrier (`ComputeBarrier.All`) after the dispatch.
   * If you want more fine-grained control (e.g., running multiple compute passes in sequence), you can specify your own barrier bit.

```d
invert.run(myTexture.width, myTexture.height, ComputeBarrier.None);
invert.barrier(ComputeBarrier.ShaderImageAccess);
```

   * You can also specify `ComputeBarrier.None` to indicate that no barrier should be inserted, and you will do that manually later.

5. **Use the Results**

   * After synchronization, your texture or buffer contains the updated data.
   * You can now use it for rendering (apply to a `Material` or use in a `Shader`), read to CPU memory, or feed into another compute pass.

## Built-in: Resampling a Texture

Dagon provides a ready-to-use compute shader for resizing RGBA8 textures: `ResampleShader`.

```d
auto rs = new ResampleShader(inputTexture, outputWidth, outputHeight, owner);
rs.run();
```

The resized image is now in `rs.outputTexture`.

## Further Reading

- [OpenGL Compute Shaders Overview](https://www.khronos.org/opengl/wiki/Compute_Shader)
