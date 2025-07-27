#version 400 core

layout(location = 0) in vec2 va_Vertex;
layout(location = 1) in vec2 va_Texcoord;

out vec2 texCoord;

void main()
{
    texCoord = va_Texcoord;
    vec2 clipVertex = va_Vertex * 2.0 - 1.0;
    clipVertex.y = -clipVertex.y;
    gl_Position = vec4(clipVertex, 0.0, 1.0);
}
