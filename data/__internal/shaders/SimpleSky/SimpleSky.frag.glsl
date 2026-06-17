#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform mat4 invViewMatrix;
uniform bool linearize;
uniform float energy;

in vec3 eyePosition;
in vec3 worldNormal;

#include <envMapEquirect.glsl>
#include <gamma.glsl>

uniform vec4 envColor;
uniform sampler2D envTexture;
uniform samplerCube envTextureCube;
uniform int envFunc;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec3 wN = normalize(worldNormal);
    
    vec3 color;
    if (envFunc == 1)
        color = texture(envTexture, envMapEquirect(wN)).rgb;
    else if (envFunc == 2)
        color = texture(envTextureCube, wN).rgb;
    else
        color = envColor.rgb;
    
    vec3 radiance;
    if (linearize)
        radiance = toLinear(color) * energy;
    else
        radiance = color * energy;
    
    fragColor = vec4(radiance, 1.0);
}
