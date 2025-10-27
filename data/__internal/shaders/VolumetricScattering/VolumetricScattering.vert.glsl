#version 400 core

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

out vec3 lightVolumeEyePos;

layout (location = 0) in vec3 va_Vertex;

void main()
{
    vec4 eyePos = modelViewMatrix * vec4(va_Vertex, 1.0);
    lightVolumeEyePos = eyePos.xyz;
    gl_Position = projectionMatrix * eyePos;
}
