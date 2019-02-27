#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;

uniform mat4 modelViewMatrix;
uniform mat4 normalMatrix;
uniform mat4 projectionMatrix;
uniform mat4 invViewMatrix;

uniform mat4 prevModelViewProjMatrix;
uniform mat4 blurModelViewProjMatrix;

out vec3 eyePosition;
out vec3 worldNormal;
out vec4 blurPosition;
out vec4 prevPosition;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    eyePosition = pos.xyz;
    
    vec3 vWorldPosition = (invViewMatrix * pos).xyz;

    worldNormal = -normalize(va_Vertex); //va_Normal;

    blurPosition = blurModelViewProjMatrix * vec4(va_Vertex, 1.0);
    prevPosition = prevModelViewProjMatrix * vec4(va_Vertex, 1.0);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
}
