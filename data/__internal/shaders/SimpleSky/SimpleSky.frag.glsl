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

/*
 * Diffuse color
 */
subroutine vec3 srtEnv(in vec3 dir);

uniform vec4 envColor;
subroutine(srtEnv) vec3 environmentColor(in vec3 dir)
{
    return envColor.rgb;
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec3 environmentTexture(in vec3 dir)
{
    return texture(envTexture, envMapEquirect(dir)).rgb;
}

uniform samplerCube envTextureCube;
subroutine(srtEnv) vec3 environmentCubemap(in vec3 dir)
{
    return texture(envTextureCube, dir).rgb;
}

subroutine uniform srtEnv environment;


layout(location = 0) out vec4 fragColor;

void main()
{
    vec3 color = environment(normalize(worldNormal));
    vec3 radiance;
    if (linearize)
        radiance = toLinear(color) * energy;
    else
        radiance = color * energy;
    fragColor = vec4(radiance, 1.0);
}
