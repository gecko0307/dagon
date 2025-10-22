#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform vec2 glyphPosition;
uniform vec2 glyphScale;
uniform vec2 glyphTexcoordScale;

uniform vec2 resolution;

layout (location = 0) in vec2 va_Vertex;
layout (location = 1) in vec2 va_Texcoord;

out vec2 texCoord;

void main()
{
    texCoord = va_Texcoord * glyphTexcoordScale;
    vec4 glyphPos = modelViewMatrix * vec4(glyphPosition + va_Vertex * glyphScale, 0.0, 1.0);
    glyphPos.x = ceil(glyphPos.x);
    glyphPos.y = ceil(glyphPos.y);
    glyphPos.z = ceil(glyphPos.z);
    vec4 pos = projectionMatrix * glyphPos;
    vec4 vertex = pos;
    vertex.x = floor(resolution.x * vertex.x) / resolution.x;
    vertex.y = floor(resolution.y * vertex.y) / resolution.y;
    gl_Position = vertex;
}
