#version 400 core
layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 vertexTexcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

out vec3 eyePosition;
out vec3 eyeNormal;
out vec2 texcoord;

void main()
{
    vec4 eye = modelViewMatrix * vec4(position, 1.0);
    eyePosition = eye.xyz;
    eyeNormal = (normalMatrix * vec4(normal, 0.0)).xyz;
    texcoord = vertexTexcoord;
    gl_Position = projectionMatrix * eye;
}
