#version 400 core

#define EPSILON 0.000001
#define PI 3.14159265
const float PI2 = PI * 2.0;

in vec3 eyePosition;
in vec3 worldNormal;

in vec4 blurPosition;
in vec4 prevPosition;

float distributionGGX(vec3 N, vec3 H, float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;
    float num = a2;
    float denom = max(NdotH2 * (a2 - 1.0) + 1.0, 0.001);
    denom = PI * denom * denom;
    return num / denom;
}

vec2 envMapEquirect(vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / PI2, phi / PI);
}

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

subroutine vec3 srtEnv(in vec3 wN, in vec3 wSun);

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform vec4 skyZenithColor;
uniform vec4 skyHorizonColor;
uniform float skyEnergy;
uniform vec4 groundColor;
uniform float groundEnergy;
uniform bool showSun; // TODO: use this
uniform bool showSunHalo; // TODO: use this
uniform float sunSize;
uniform float sunScattering;
subroutine(srtEnv) vec3 environmentSky(in vec3 wN, in vec3 wSun)
{
    float horizonOrZenith = pow(clamp(dot(wN, vec3(0, 1, 0)), 0.0, 1.0), 0.5);
    float groundOrSky = pow(clamp(dot(wN, vec3(0, -1, 0)), 0.0, 1.0), 0.4);

    vec3 env = mix(
        mix(toLinear(skyHorizonColor.rgb) * skyEnergy,
            toLinear(groundColor.rgb) * groundEnergy, groundOrSky),
            toLinear(skyZenithColor.rgb) * skyEnergy, horizonOrZenith);
    float sun = clamp(dot(wN, wSun), 0.0, 1.0);
    vec3 H = normalize(wN + wSun);
    float halo = distributionGGX(wN, H, sunScattering);
    sun = min(float(sun > (1.0 - sunSize * 0.001)) + halo, 1.0);
    env += toLinear(sunColor.rgb) * sun * sunEnergy;
	return env;
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec3 environmentTexture(in vec3 wN, in vec3 wSun)
{	
	return texture(envTexture, envMapEquirect(wN)).rgb;
}

subroutine uniform srtEnv environment;

float luminance(vec3 color)
{
    return (
        color.x * 0.27 +
        color.y * 0.67 +
        color.z * 0.06
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luma;
layout(location = 2) out vec4 frag_velocity;

void main()
{
    vec3 normalWorldN = normalize(worldNormal);
    vec3 env = environment(-normalWorldN, sunDirection);

    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;

    frag_color = vec4(env, 1.0);
    frag_luma = vec4(luminance(env));
    frag_velocity = vec4(screenVelocity, 0.0, 1.0);
}
