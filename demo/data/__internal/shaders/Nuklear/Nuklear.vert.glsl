#version 400 core

uniform mat4 ProjMtx;

layout (location = 0) in vec2 va_Vertex;
layout (location = 1) in vec2 va_Texcoord;
layout (location = 2) in vec4 va_Color;

out vec2 texCoord;
out vec4 color;

void main()
{
    texCoord = va_Texcoord;
    color = va_Color;
    gl_Position = ProjMtx * vec4(va_Vertex, 0, 1);
}
