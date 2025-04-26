#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 2) in vec2 va_Texcoord;
layout (location = 3) in uvec4 va_Bones;
layout (location = 4) in vec4 va_Weights;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform vec2 textureScale;

uniform bool skinned;

uniform mat4 boneMatrices[128];

out vec2 texCoord;

void main()
{
    vec4 modelPosHmg = vec4(va_Vertex, 1.0);
    
    if (skinned)
    {
        mat4 boneMatrix1 = boneMatrices[int(va_Bones.x)];
        mat4 boneMatrix2 = boneMatrices[int(va_Bones.y)];
        mat4 boneMatrix3 = boneMatrices[int(va_Bones.z)];
        mat4 boneMatrix4 = boneMatrices[int(va_Bones.w)];
        
        mat4 skinMatrix = 
            va_Weights.x * boneMatrix1 +
            va_Weights.y * boneMatrix2 +
            va_Weights.z * boneMatrix3 +
            va_Weights.w * boneMatrix4;
        
        modelPosHmg = skinMatrix * vec4(va_Vertex, 1.0);
    }
    
    texCoord = va_Texcoord * textureScale;
    gl_Position = projectionMatrix * modelViewMatrix * modelPosHmg;
}
