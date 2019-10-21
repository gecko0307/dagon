#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat4 prevModelViewMatrix;

out vec3 eyePosition;
out vec3 eyeNormal;
out vec2 texCoord;
out vec2 splatTexCoord;
out vec4 currPosition;
out vec4 prevPosition;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;
    eyeNormal = (normalMatrix * vec4(va_Normal, 0.0)).xyz;
    texCoord = va_Texcoord;
    splatTexCoord = va_Texcoord;
    
    currPosition = projectionMatrix * pos;
    prevPosition = projectionMatrix * prevModelViewMatrix * vec4(va_Vertex, 1.0);
    
    gl_Position = projectionMatrix * pos;
}
