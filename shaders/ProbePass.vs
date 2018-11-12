#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 invViewMatrix;

layout (location = 0) in vec3 va_Vertex;

out vec3 worldView;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    
    vec3 worldPosition = (invViewMatrix * pos).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    worldView = worldPosition - worldCamPos;
    
    gl_Position = projectionMatrix * pos;
}
