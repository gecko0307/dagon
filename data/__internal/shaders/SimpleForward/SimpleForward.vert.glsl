#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;
layout (location = 3) in uvec4 va_Bones;
layout (location = 4) in vec4 va_Weights;

uniform mat4 modelMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat3 textureMatrix;

uniform bool skinned;

uniform mat4 boneMatrices[128];

uniform bool vertexSnapping;

out vec3 eyeNormal;
out vec3 eyePosition;
out vec3 worldPosition;
out vec2 texCoord;

void main()
{
    vec4 modelPosHmg = vec4(va_Vertex, 1.0);
    vec4 modelNorHmg = vec4(va_Normal, 0.0);
    
    if (skinned)
    {
        mat4 boneMatrix1 = boneMatrices[va_Bones.x];
        mat4 boneMatrix2 = boneMatrices[va_Bones.y];
        mat4 boneMatrix3 = boneMatrices[va_Bones.z];
        mat4 boneMatrix4 = boneMatrices[va_Bones.w];
        
        mat4 skinMatrix = 
            va_Weights.x * boneMatrix1 +
            va_Weights.y * boneMatrix2 +
            va_Weights.z * boneMatrix3 +
            va_Weights.w * boneMatrix4;
        
        modelPosHmg = skinMatrix * modelPosHmg;
        
        mat3 normalsSkinMatrix =
            va_Weights.x * mat3(boneMatrix1) +
            va_Weights.y * mat3(boneMatrix2) +
            va_Weights.z * mat3(boneMatrix3) +
            va_Weights.w * mat3(boneMatrix4);
        
        modelNorHmg = vec4(normalsSkinMatrix * va_Normal, 0.0);
    }
    
    vec4 pos = modelViewMatrix * modelPosHmg;
    
    eyePosition = pos.xyz;
    eyeNormal = (normalMatrix * modelNorHmg).xyz;
    texCoord = (textureMatrix * vec3(va_Texcoord, 1.0)).xy;
    vec4 currPosition = projectionMatrix * pos;
    worldPosition = (modelMatrix * modelPosHmg).xyz;
    
    if (vertexSnapping)
    {
        // Retro-style snapping
        vec4 vertex = currPosition;
        vertex.xyz = currPosition.xyz / currPosition.w;
        vertex.x = floor(320.0 * vertex.x) / 320.0;
        vertex.y = floor(240.0 * vertex.y) / 240.0;
        vertex.xyz *= currPosition.w;
        currPosition = vertex;
    }
    
    texCoord = (textureMatrix * vec3(va_Texcoord, 1.0)).xy;
    
    gl_Position = currPosition;
}
