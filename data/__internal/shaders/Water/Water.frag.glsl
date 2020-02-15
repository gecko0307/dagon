#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec3 eyePosition;
in vec3 eyeNormal;
in vec2 texCoord;
in vec4 blurPosition;
in vec4 prevPosition;
in vec3 worldView;

uniform vec2 viewSize;
uniform sampler2D depthBuffer;

uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;

uniform bool shaded;
uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform bool sunScattering;
uniform float sunScatteringG;
uniform float sunScatteringDensity;
uniform int sunScatteringSamples;
uniform float sunScatteringMaxRandomStepOffset;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

#include <unproject.glsl>
#include <gamma.glsl>
#include <envMapEquirect.glsl>
#include <shadow.glsl>
#include <hash.glsl>

/*
 * Ambient
 */
uniform float ambientEnergy;

subroutine vec3 srtAmbient(in vec3 wN, in float roughness);

uniform vec4 ambientVector;
subroutine(srtAmbient) vec3 ambientColor(in vec3 wN, in float roughness)
{
    return toLinear(ambientVector.rgb) * ambientEnergy;
}

uniform sampler2D ambientTexture;
subroutine(srtAmbient) vec3 ambientEquirectangularMap(in vec3 wN, in float roughness)
{
    ivec2 envMapSize = textureSize(ambientTexture, 0);
    float size = float(max(envMapSize.x, envMapSize.y));
    float glossyExponent = 2.0 / pow(roughness, 4.0) - 2.0;
    float lod = log2(size * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    return textureLod(ambientTexture, envMapEquirect(wN), lod).rgb * ambientEnergy;
}

uniform samplerCube ambientTextureCube;
subroutine(srtAmbient) vec3 ambientCubemap(in vec3 wN, in float roughness)
{
    ivec2 envMapSize = textureSize(ambientTextureCube, 0);
    float size = float(max(envMapSize.x, envMapSize.y));
    float glossyExponent = 2.0 / pow(roughness, 4.0) - 2.0;
    float lod = log2(size * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    return textureLod(ambientTextureCube, wN, lod).rgb * ambientEnergy;
}

subroutine uniform srtAmbient ambient;


subroutine float srtShadow(in vec3 pos, in vec3 N);

subroutine(srtShadow) float shadowMapNone(in vec3 pos, in vec3 N)
{
    return 1.0;
}

const float eyeSpaceNormalShift = 0.008;
subroutine(srtShadow) float shadowMapCascaded(in vec3 pos, in vec3 N)
{
    vec3 posShifted = pos + N * eyeSpaceNormalShift;
    vec4 shadowCoord1 = shadowMatrix1 * vec4(posShifted, 1.0);
    vec4 shadowCoord2 = shadowMatrix2 * vec4(posShifted, 1.0);
    vec4 shadowCoord3 = shadowMatrix3 * vec4(posShifted, 1.0);
    
    float s1 = shadowLookupPCF(shadowTextureArray, 0.0, shadowCoord1, 2.0);
    float s2 = shadowLookup(shadowTextureArray, 1.0, shadowCoord2, vec2(0.0, 0.0));
    float s3 = shadowLookup(shadowTextureArray, 2.0, shadowCoord3, vec2(0.0, 0.0));
    
    float w1 = shadowCascadeWeight(shadowCoord1, 8.0);
    float w2 = shadowCascadeWeight(shadowCoord2, 8.0);
    float w3 = shadowCascadeWeight(shadowCoord3, 8.0);
    s3 = mix(1.0, s3, w3); 
    s2 = mix(s3, s2, w2);
    s1 = mix(s2, s1, w1);
    
    return s1;
}

subroutine uniform srtShadow shadowMap;


// Mie scaterring approximated with Henyey-Greenstein phase function.
float scattering(float lightDotView)
{
    float result = 1.0 - sunScatteringG * sunScatteringG;
    result /= 4.0 * PI * pow(1.0 + sunScatteringG * sunScatteringG - (2.0 * sunScatteringG) * lightDotView, 1.5);
    return result;
}


uniform sampler2D rippleTexture;
uniform vec4 rippleTimes;
const float textureScale = 4.0;
const float rainIntensity = 2.0;

vec3 computeRipple(vec2 uv, float currentTime, float weight)
{
    vec4 ripple = texture(rippleTexture, uv);
    ripple.yz = ripple.yz * 2.0 - 1.0;
    float dropFrac = fract(ripple.w + currentTime);
    float timeFrac = dropFrac - 1.0 + ripple.x;
    float dropFactor = clamp(0.2 + weight * 0.8 - dropFrac, 0.0, 1.0);
    float finalFactor = dropFactor * ripple.x * sin(clamp(timeFrac * 9.0, 0.0, 3.0) * PI);
    return vec3(ripple.yz * finalFactor * 0.35, 1.0);
}

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_velocity;

void main()
{
    vec2 screenTexcoord = gl_FragCoord.xy / viewSize;
    float depth = texture(depthBuffer, screenTexcoord).x;
    vec3 referenceEyePos = unproject(invProjectionMatrix, vec3(screenTexcoord, depth));
    vec3 referenceWorldPos = (invViewMatrix * vec4(referenceEyePos, 1.0)).xyz;
    
    vec3 N = normalize(eyeNormal);
    vec3 E = normalize(-eyePosition);
    
    vec3 L = sunDirection;
    
    vec3 worldPosition = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    
    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    
    vec2 uv = texCoord * textureScale;
    vec4 weights = rainIntensity - vec4(0, 0.25, 0.5, 0.75);
    weights = clamp(weights * 4.0, 0.0, 1.0);
    
    vec3 ripple1 = computeRipple(uv + vec2( 0.25, 0.0), rippleTimes.x, weights.x);
    vec3 ripple2 = computeRipple(uv + vec2(-0.55, 0.3), rippleTimes.y, weights.y);
    vec3 ripple3 = computeRipple(uv + vec2( 0.6, 0.85), rippleTimes.z, weights.z);
    vec3 ripple4 = computeRipple(uv + vec2( 0.5,-0.75), rippleTimes.w, weights.w);
    
    vec4 Z = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(ripple1.z, ripple2.z, ripple3.z, ripple4.z), weights);
    vec3 n = vec3(
        weights.x * ripple1.xy +
        weights.y * ripple2.xy + 
        weights.z * ripple3.xy + 
        weights.w * ripple4.xy, 
        Z.x * Z.y * Z.z * Z.w);                             
    n = normalize(n);

    vec3 worldN = n.xzy;
    vec3 worldR = reflect(normalize(worldView), worldN);
    //worldR = normalize(vec3(-worldR.x, worldR.y, -worldR.z));
    vec3 worldSun = L * mat3(viewMatrix);
    
    // TODO: make uniforms
    vec3 waterColor = vec3(0.02, 0.1, 0.01);
    float waterAlpha = 0.8;
    
    // TODO: make uniform
    const float softDistance = 0.5;
    float soft = clamp((worldPosition.y - referenceWorldPos.y) / softDistance, 0.0, 1.0);
    
    float shadow = shadowMap(eyePosition, N);
    float light = max(dot(N, L), 0.0);
    // TODO: sun color, energy
    
    const float fresnelPower = 3.0;
    const float f0 = 0.03;
    float fresnel = f0 + pow(1.0 - dot(N, E), fresnelPower);
    
    float alpha = soft * mix(waterAlpha, 1.0, fresnel);
    
    vec3 radiance = vec3(0.0); 
    
    // Light
    {
        vec3 diffuseLight = waterColor * light * toLinear(sunColor.rgb) * sunEnergy * shadow * alpha;
        vec3 reflection = ambient(worldR, pow(fresnel, 2.0));
        radiance += mix(diffuseLight, reflection, fresnel);
    }

    if (sunScattering)
    {
        float scattFactor = scattering(dot(-L, E)) * sunScatteringDensity;
        radiance += toLinear(sunColor.rgb) * sunEnergy * scattFactor;
    }
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);
    
    frag_color = vec4(radiance, alpha);
    frag_velocity = vec4(screenVelocity, 0.0, 1.0);
}
