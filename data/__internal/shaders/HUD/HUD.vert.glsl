#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat3 textureMatrix;

layout (location = 0) in vec2 va_Vertex;
layout (location = 2) in vec2 va_Texcoord;

out vec2 texCoord;

void main()
{
    texCoord = (textureMatrix * vec3(va_Texcoord, 1.0)).xy;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 0.0, 1.0);
}
