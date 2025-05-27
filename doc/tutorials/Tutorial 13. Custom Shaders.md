# Tutorial 13. Custom Shaders

Dagon's material system can be extended using custom GLSL shaders. Shaders provide virtually unlimited possibilities for fine-tuning your game's visuals. From custom BRDFs to NPR and procedural textures — Dagon lets you do anything.

⚠️ **Note:** Using custom shaders on objects completely overrides Dagon's built-in rendering for those objects. You'll need to implement basic effects such as lighting and environment mapping yourself.

## Creating a Custom Shader

To define a custom shader, derive from the `Shader` class. Typically, a shader creates a `ShaderProgram` in its constructor, calls the base constructor, and defines `ShaderParameter` objects for uniform parameters.

```d
class SimpleShader: Shader
{
    ShaderParameter!float someFloatUniform;
    ShaderParameter!Vector4f someVectorUniform;
    ShaderParameter!Matrix4x4f someMatrixUniform;
    
    this(Owner owner)
    {
        string vs = ""; // provide your vertex shader source here
        string fs = ""; // provide your fragment shader source here
        auto shaderProgram = New!ShaderProgram(vs, fs, this);
        super(shaderProgram, owner);
        
        // Parameter names are the same as in GLSL
        someFloatUniform = createParameter!float("someFloat");
        someVectorUniform = createParameter!Vector4f("someVector");
        someMatrixUniform = createParameter!Matrix4x4f("someMatrix");
    }
    
    override void bindParameters(GraphicsState* state)
    {
        someFloatUniform = 1.0f;
        someVectorUniform = Vector4f(1.0f, 0.5f, 0.0f, 1.0f);
        someMatrixUniform = translationMatrix(Vector3f(2.0f, 0.0f, 1.0f));
        
        // It is important to call this after all parameters have been updated!
        super.bindParameters(state);
    }
}
```

Although you can update uniform values from anywhere in your application, it's recommended to rely on an external state and update them only in the `bindParameters` method to ensure consistency with the rendering pipeline.

You can use the `GraphicsState` pointer to access pipeline data, such as the `modelViewMatrix`, `projectionMatrix`, the current `Environment`, and the active `Material`.

## Example GLSL Shader Code

It is recommended to use GLSL 4.0 (`#version 400 core`). Here's an example vertex and fragment shader matching the layout above:

```glsl
#version 400 core

// Dagon uses fixed attribute locations:
// 0 = positions, 1 = texcoords, 2 = normals
layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec2 va_Texcoord;
layout (location = 2) in vec3 va_Normal;

uniform mat4 someMatrix;

void main()
{
    vec4 pos = someMatrix * vec4(va_Vertex, 1.0);
    gl_Position = pos;
}
```

```glsl
#version 400 core

uniform float someFloat;
uniform vec4 someVector;
uniform mat4 someMatrix;

layout(location = 0) out vec4 fragColor;

void main()
{
    fragColor = vec4(someVector.rgb, someFloat);
}
```

## Textures

To use textures in shaders, you'll need access to `Texture` objects with an underlying `texture` property (OpenGL texture handle). Texture management is up to you: you can store textures directly in the shader (if the texture is shared across all objects using the shader), or use the standard PBR textures available in `Matrial` (`baseColorTexture`, `normalTexture`, `roughnessMetallicTexture`). You can also derive your own material class, add custom properties, and use them in your shaders. For example, suppose you have a `CustomMaterial` class with `someCustomTexture` field. Here's how you could bind it:

```d
ShaderParameter!int someTexureUnitUniform;

this(Owner owner)
{
    // Initialization omitted
    
    someTexureUnitUniform = createParameter!int("someCustomTexture");
}

override void bindParameters(GraphicsState* state)
{
    auto mat = cast(CustomMaterial)state.material;
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mat.someCustomTexture.texture);
    
    // Must match the texture unit specified in glActiveTexture
    someTexureUnitUniform = 0;
}
```

## Limitations

* Custom shaders are not supported in the **deferred rendering pipeline**. Objects using them are rendered in the **forward pipeline**, after deferred rendering is complete.
* If you want to use lights in your custom shader, you must implement lighting yourself. The simplest approach is to rely on a single global directional light (`Environment.sun`), similar to what the default forward shader does, but more sophisticated techniques are of course possible, too.
* **Decals only work with deferred rendering**, so they won't appear on objects with custom shaders.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t13-custom-shaders)
