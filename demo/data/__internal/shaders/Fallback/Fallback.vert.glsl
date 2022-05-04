#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

out vec3 normal;

void main()
{
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
    normal = (normalMatrix * vec4(va_Normal, 0.0)).xyz;
}
