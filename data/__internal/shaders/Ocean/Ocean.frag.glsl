#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

#include <gamma.glsl>
#include <cotangentFrame.glsl>
#include <envMapEquirect.glsl>

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
uniform float scatteringEnergy;
uniform float gloss;
uniform float fresnelPower;

uniform sampler2D normalTexture1;
uniform sampler2D normalTexture2;
uniform float relief;

uniform float rippleTime;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform float ambientEnergy;

subroutine vec3 srtAmbient(in vec3 wN, in float perceptualRoughness);

uniform vec4 ambientVector;
subroutine(srtAmbient) vec3 ambientColor(in vec3 wN, in float perceptualRoughness)
{
    return toLinear(ambientVector.rgb);
}

uniform sampler2D ambientTexture;
subroutine(srtAmbient) vec3 ambientEquirectangularMap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTexture, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTexture, envMapEquirect(wN), lod).rgb;
}

uniform samplerCube ambientTextureCube;
subroutine(srtAmbient) vec3 ambientCubemap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTextureCube, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTextureCube, wN, lod).rgb;
}

subroutine uniform srtAmbient ambient;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragVelocity;

void main()
{
    vec2 uv = texCoord;
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    vec3 R = reflect(E, N);
    
    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    
    vec2 scrolluv1 = vec2(uv.x, uv.y + rippleTime);
    vec2 scrolluv2 = vec2(uv.x + rippleTime, uv.y);
    vec3 wave1N = normalize(texture(normalTexture1, scrolluv1).rgb * 2.0 - 1.0);
    vec3 wave2N = normalize(texture(normalTexture2, scrolluv2).rgb * 2.0 - 1.0);
    N = mix(vec3(0.0, 0.0, 1.0), (wave1N + wave2N) * 0.5, relief);
    
    float foam = clamp(dot(N, vec3(0.0, 0.0, 1.0)), 0.0, 1.0);
    foam = height * (1.0 - (foam - 0.4) / (1.0 - 0.4));
    float foam2 = float(foam * 10.0 > 0.4);
    
    N = normalize(tangentToEye * N);
    
    vec3 worldPos = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize((vec4(N, 0.0) * viewMatrix).xyz);
    vec3 worldR = reflect(worldE, worldN);
    
    // Sun light
    vec3 L = sunDirection;
    float NL = max(dot(N, L), 0.0);
    vec3 H = normalize(E + L);
    float NH = max(dot(N, H), 0.0);
    float LE = clamp(dot(L, E), 0.0, 1.0);
    float specular = float(NH > 0.997);
    
    // Scattering and Fresnel reflection
    vec3 foamColor = toLinear(vec3(0.9, 1.0, 0.8));
    vec3 scattering = toLinear(scatteringColor.rgb) * scatteringEnergy + foamColor * 10.0 * foam;
    vec3 diffuse = toLinear(waterColor.rgb);
    diffuse += (1.0 - LE) * clamp(dot(N, E), 0.0, 1.0) * mix(vec3(0.0), scattering, height) + vec3(1.0) * foam2;
    const float f0 = 0.05;
    float fresnel = clamp(f0 + pow(1.0 - dot(N, E), fresnelPower), 0.0, 1.0);
    vec3 reflection = mix(diffuse, ambient(worldR, 0.4), gloss);
    vec3 radiance = mix(diffuse, reflection, fresnel) + toLinear(sunColor.rgb) * sunEnergy * specular;
    
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
