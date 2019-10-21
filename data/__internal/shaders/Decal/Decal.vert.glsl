#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

layout (location = 0) in vec3 va_Vertex;

void main()
{
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
}
