#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform mat4 invViewMatrix;
uniform float gbufferMask;
uniform float blurMask;
uniform bool linearize;
uniform float energy;

in vec3 eyePosition;
in vec3 worldNormal;

in vec4 currPosition;
in vec4 prevPosition;

#include <envMapEquirect.glsl>
#include <gamma.glsl>

/*
 * Diffuse color
 */
subroutine vec4 srtEnv(in vec3 dir);

uniform vec4 envColor;
subroutine(srtEnv) vec4 environmentColor(in vec3 dir)
{
    return envColor;
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec4 environmentTexture(in vec3 dir)
{
    return texture(envTexture, envMapEquirect(dir));
}

uniform samplerCube envTextureCube;
subroutine(srtEnv) vec4 environmentCubemap(in vec3 dir)
{
    return texture(envTextureCube, dir);
}

subroutine uniform srtEnv environment;


layout(location = 0) out vec4 fragColor;
layout(location = 3) out vec4 fragEmission;
layout(location = 4) out vec4 fragVelocity;
layout(location = 5) out vec4 fragRadiance;

void main()
{
    vec4 color = environment(normalize(worldNormal));
    if (color.a < 0.5)
        discard;
    
    vec3 radiance;
    if (linearize)
        radiance = toLinear(color.rgb) * energy;
    else
        radiance = color.rgb * energy;
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    
    fragColor = vec4(color.rgb, gbufferMask);
    fragEmission = vec4(0.0, 0.0, 0.0, 1.0);
    fragVelocity = vec4(velocity, blurMask, 1.0);
    fragRadiance = vec4(radiance, 1.0);
}
