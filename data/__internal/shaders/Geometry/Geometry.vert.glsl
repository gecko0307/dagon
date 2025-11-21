#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;
layout (location = 3) in uvec4 va_Bones;
layout (location = 4) in vec4 va_Weights;
layout (location = 5) in vec2 va_Texcoord2;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat4 prevModelViewMatrix;
uniform mat3 textureMatrix;

uniform bool skinned;
uniform bool sphericalNormal;

uniform mat4 boneMatrices[128];

out vec3 eyeNormal;
out vec3 eyePosition;
out vec2 texCoord;
out vec2 texCoord2;

out vec4 currPosition;
out vec4 prevPosition;

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
    
    vec4 eyePosHmg = modelViewMatrix * modelPosHmg;
    eyePosition = eyePosHmg.xyz;
    
    vec4 modelNormal = (sphericalNormal)? vec4(normalize(modelPosHmg.xyz), 0.0) : modelNorHmg;
    eyeNormal = (normalMatrix * modelNormal).xyz;
    
    texCoord = (textureMatrix * vec3(va_Texcoord, 1.0)).xy;
    
    // TODO: lightmapping support
    texCoord2 = texCoord;
    
    currPosition = projectionMatrix * eyePosHmg;
    prevPosition = projectionMatrix * prevModelViewMatrix * modelPosHmg;

    gl_Position = currPosition;
}
