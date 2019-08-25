#version 400 core

layout (location = 0) in vec3 va_Vertex;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform mat4 prevModelViewMatrix;

out vec3 eyePosition;
out vec3 worldNormal;

out vec4 currPosition;
out vec4 prevPosition;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;
    worldNormal = normalize(va_Vertex);
    
    currPosition = projectionMatrix * pos;
    prevPosition = projectionMatrix * prevModelViewMatrix * vec4(va_Vertex, 1.0);
    
    gl_Position = currPosition;
}
