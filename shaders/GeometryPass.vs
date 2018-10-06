#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
        
uniform mat4 prevModelViewProjMatrix;
uniform mat4 blurModelViewProjMatrix;
        
layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;
        
out vec2 texCoord;
out vec3 eyePosition;
out vec3 eyeNormal;
        
out vec4 blurPosition;
out vec4 prevPosition;
        
void main()
{
    texCoord = va_Texcoord;
    eyeNormal = (normalMatrix * vec4(va_Normal, 0.0)).xyz;
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;

    vec4 position = projectionMatrix * pos;

    blurPosition = blurModelViewProjMatrix * vec4(va_Vertex, 1.0);
    prevPosition = prevModelViewProjMatrix * vec4(va_Vertex, 1.0);

    gl_Position = position;
}
