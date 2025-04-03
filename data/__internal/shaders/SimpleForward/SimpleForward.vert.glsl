#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;

uniform mat4 modelMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat3 textureMatrix;

out vec3 eyeNormal;
out vec3 eyePosition;
out vec3 worldPosition;
out vec2 texCoord;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;
    
    vec4 modelNormal = vec4(va_Normal, 0.0);
    eyeNormal = (normalMatrix * modelNormal).xyz;
    
    texCoord = (textureMatrix * vec3(va_Texcoord, 1.0)).xy;
    
    vec4 currPosition = projectionMatrix * pos;
    
    worldPosition = (modelMatrix * vec4(va_Vertex, 1.0)).xyz;
    
    gl_Position = currPosition;
}
