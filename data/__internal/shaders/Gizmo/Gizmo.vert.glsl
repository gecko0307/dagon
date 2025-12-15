#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 6) in vec4 va_Color;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

out vec4 color;

void main()
{
    color = va_Color;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
}
