#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;
const float invPI = 1.0 / PI;

#include <gamma.glsl>
#include <cotangentFrame.glsl>

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

in vec4 currPosition;
in vec4 prevPosition;

in float height;

uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;

uniform vec4 waterColor;
uniform vec4 scatteringColor;
uniform vec4 reflectionColor;

uniform sampler2D normalTexture1;
uniform sampler2D normalTexture2;

uniform float rippleTime;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragVelocity;

void main()
{
    vec2 uv = texCoord;
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    vec3 R = reflect(E, N);
    
    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    
    const float bumpiness = 0.8;
    
    vec2 scrolluv1 = vec2(uv.x, uv.y + rippleTime);
    vec2 scrolluv2 = vec2(uv.x + rippleTime, uv.y);
    vec3 wave1N = normalize(texture(normalTexture1, scrolluv1).rgb * 2.0 - 1.0);
    vec3 wave2N = normalize(texture(normalTexture2, scrolluv2).rgb * 2.0 - 1.0);
    N = mix(vec3(0.0, 0.0, 1.0), (wave1N + wave2N) * 0.5, bumpiness);
    N = normalize(tangentToEye * N);
    
    // Sun light
    vec3 L = sunDirection;
    float NL = max(dot(N, L), 0.0);
    vec3 H = normalize(E + L);
    float NH = max(dot(N, H), 0.0);
    float LE = clamp(dot(L, E), 0.0, 1.0);
    float specular = float(NH > 0.998);
    
    // Scattering and Fresnel reflection
    vec3 baseColor = toLinear(waterColor.rgb);
    baseColor += (1.0 - LE) * clamp(dot(N, E), 0.0, 1.0) * mix(vec3(0.0), toLinear(scatteringColor.rgb), height);
    const float fresnelPower = 8.0;
    const float f0 = 0.1;
    float fresnel = clamp(f0 + pow(1.0 - dot(N, E), fresnelPower), 0.0, 1.0);
    
    vec3 radiance = mix(baseColor, toLinear(reflectionColor.rgb), fresnel) + toLinear(sunColor.rgb) * sunEnergy * specular;
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);
    
    // Velocity
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    const float blurMask = 1.0;
    
    fragColor = vec4(radiance, 1.0);
    fragVelocity = vec4(screenVelocity, blurMask, 0.0);
}
