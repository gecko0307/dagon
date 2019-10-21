#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 2) in vec2 va_Texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform vec2 textureScale;

out vec2 texCoord;

void main()
{
    texCoord = va_Texcoord * textureScale;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
}
