#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform mat4 invViewMatrix;

in vec3 eyePosition;
in vec3 worldNormal;

in vec4 currPosition;
in vec4 prevPosition;

#include <envMapEquirect.glsl>

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
layout(location = 3) out vec4 fragRadiance;
layout(location = 4) out vec4 fragVelocity;

void main()
{
    vec3 fragDiffuse = environment(normalize(worldNormal));
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    const float blurMask = 1.0;
    
    fragColor = vec4(fragDiffuse, 1.0);
    fragRadiance = vec4(fragDiffuse, 1.0);
    fragVelocity = vec4(velocity, blurMask, 1.0);
}
