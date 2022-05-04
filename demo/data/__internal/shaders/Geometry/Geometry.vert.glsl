#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat4 prevModelViewMatrix;

uniform vec2 textureScale;

uniform bool sphericalNormal;

out vec3 eyeNormal;
out vec3 eyePosition;
out vec2 texCoord;

out vec4 currPosition;
out vec4 prevPosition;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;
    
    vec4 modelNormal = (sphericalNormal)? vec4(normalize(va_Vertex), 0.0) : vec4(va_Normal, 0.0);
    eyeNormal = (normalMatrix * modelNormal).xyz;
    
    texCoord = va_Texcoord * textureScale;
    
    currPosition = projectionMatrix * pos;
    prevPosition = projectionMatrix * prevModelViewMatrix * vec4(va_Vertex, 1.0);

    gl_Position = currPosition;
}
