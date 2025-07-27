#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec2 texCoord;

uniform sampler2D envmap;
uniform mat4 pixelToWorldMatrix;

layout(location = 0) out vec4 fragColor;

#include <envMapEquirect.glsl>

void main()
{
    vec2 ndc = vec2(texCoord.x, 1.0 - texCoord.y) * 2.0 - 1.0;
    vec3 ray = normalize(vec3(ndc, 1.0f));
    vec3 rayWorld = (pixelToWorldMatrix * vec4(ray, 0.0f)).xyz;
    vec2 sampleTexCoord = envMapEquirect(rayWorld);
    fragColor = texture(envmap, sampleTexCoord);
}
