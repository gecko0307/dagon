#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;

out vec3 eyePosition;
out vec3 eyeNormal;
out vec2 texCoord;
out vec3 worldPosition;
out vec3 worldView;

out vec4 shadowCoord1;
out vec4 shadowCoord2;
out vec4 shadowCoord3;

const float eyeSpaceNormalShift = 0.05;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat4 invViewMatrix;

uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);

    eyePosition = pos.xyz;
    texCoord = va_Texcoord;
    eyeNormal = (normalMatrix * vec4(va_Normal, 0.0)).xyz;

    worldPosition = (invViewMatrix * pos).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    worldView = worldPosition - worldCamPos;

    vec4 posShifted = pos + vec4(eyeNormal * eyeSpaceNormalShift, 0.0);
    shadowCoord1 = shadowMatrix1 * posShifted;
    shadowCoord2 = shadowMatrix2 * posShifted;
    shadowCoord3 = shadowMatrix3 * posShifted;

    gl_Position = projectionMatrix * pos;
}
