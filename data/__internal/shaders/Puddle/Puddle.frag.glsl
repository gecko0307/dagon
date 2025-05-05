#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform sampler2D terrainNormalBuffer;
uniform sampler2D terrainTexcoordBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform mat4 normalMatrix;
uniform float zNear;
uniform float zFar;

uniform vec2 textureScale;
//uniform mat3 textureMatrix;

uniform float energy;
uniform float opacity;
uniform float clipThreshold;

in vec2 texCoord;

uniform vec4 waterColor;
uniform sampler2D rippleTexture;
uniform vec4 rippleTimes;
uniform float rainIntensity;
uniform float flowSpeed;
uniform float waveAmplitude;

uniform float time;
uniform sampler2D normalTexture1;
uniform sampler2D normalTexture2;

#include <unproject.glsl>
#include <cotangentFrame.glsl>
#include <gamma.glsl>

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

/*
 * Layer mask
 */
subroutine float srtLayerMask(in vec2 uv);

uniform float maskFactor;
subroutine(srtLayerMask) float layerMaskValue(in vec2 uv)
{
    return maskFactor;
}

uniform sampler2D maskTexture;
subroutine(srtLayerMask) float layerMaskTexture(in vec2 uv)
{
    return texture(maskTexture, uv).r;
}

subroutine uniform srtLayerMask layerMask;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragEmission;

void main()
{
    vec4 terrTexCoordSample = texture(terrainTexcoordBuffer, texCoord);
    vec2 terrTexCoord = terrTexCoordSample.xy;
    vec2 uv = terrTexCoord * textureScale;
    // FIXME:
    //vec2 uv = (textureMatrix * vec3(terrTexCoord, 1.0)).xy;
    float depth = terrTexCoordSample.z;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    
    vec4 normalSample = texture(terrainNormalBuffer, texCoord);
    vec3 E = normalize(-eyePos);
    
    float gbufferMask = normalSample.a;
    float mask = layerMask(terrTexCoord) * gbufferMask;
    
    if (mask < clipThreshold)
        discard;
    
    vec4 weights = rainIntensity - vec4(0, 0.25, 0.5, 0.75);
    weights = clamp(weights * 4.0, 0.0, 1.0);
    
    vec3 ripple1 = computeRipple(uv + vec2( 0.25, 0.0), rippleTimes.x, weights.x);
    vec3 ripple2 = computeRipple(uv + vec2(-0.55, 0.3), rippleTimes.y, weights.y);
    vec3 ripple3 = computeRipple(uv + vec2( 0.6, 0.85), rippleTimes.z, weights.z);
    vec3 ripple4 = computeRipple(uv + vec2( 0.5,-0.75), rippleTimes.w, weights.w);
    
    vec4 Z = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(ripple1.z, ripple2.z, ripple3.z, ripple4.z), weights);
    vec3 rippleN = vec3(
        weights.x * ripple1.xy +
        weights.y * ripple2.xy + 
        weights.z * ripple3.xy + 
        weights.w * ripple4.xy, 
        Z.x * Z.y * Z.z * Z.w);
    rippleN = normalize(rippleN);
    
    vec3 N = (normalMatrix * vec4(0.0, 1.0, 0.0, 0.0)).xyz;
    mat3 tangentToEye = cotangentFrame(N, eyePos, terrTexCoord);
    N = normalize(tangentToEye * rippleN);
    
    fragColor = vec4(0.1, 0.05, 0.0, mask * 0.2);
    fragNormal = vec4(N, mask * opacity);
    fragPBR = vec4(0.0001, 0.5, 0.0, mask);
    fragEmission = vec4(0.0, 0.0, 0.0, mask * opacity);
}
