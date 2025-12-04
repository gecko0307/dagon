#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;
const float invPI = 1.0 / PI;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D pbrBuffer;
uniform sampler2D occlusionBuffer;
uniform bool haveOcclusionBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform mat4 shadowViewMatrix;
uniform float zNear;
uniform float zFar;

uniform bool useShadowViewMatrix;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform float lightEnergy;
uniform bool lightScattering;
uniform float lightScatteringG;
uniform float lightScatteringDensity;
uniform int lightScatteringSamples;
uniform float lightScatteringMaxRandomStepOffset;
uniform bool lightScatteringShadow;
uniform float lightSpecular;
uniform float lightDiffuse;

uniform float time;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>
#include <gamma.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>
#include <shadow.glsl>
#include <hash.glsl>

float schlickFresnel(float u)
{
    float m = clamp(1.0 - u, 0.0, 1.0);
    float m2 = m * m;
    return m2 * m2 * m;
}

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

// Mie scattering approximated with Henyey-Greenstein phase function.
float scattering(float lightDotView)
{
    float result = 1.0 - lightScatteringG * lightScatteringG;
    result /= 4.0 * PI * pow(1.0 + lightScatteringG * lightScatteringG - (2.0 * lightScatteringG) * lightDotView, 1.5);
    return result;
}

void main()
{
    vec4 col = texture(colorBuffer, texCoord);

    vec3 albedo = toLinear(col.rgb);
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 clipPos = vec3(texCoord, depth);
    vec3 eyePos = unproject(invProjectionMatrix, clipPos);
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);
    
    vec4 pbr = texture(pbrBuffer, texCoord);
    float roughness = pbr.r;
    float metallic = pbr.g;
    float subsurface = pbr.b;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;
    
    vec3 f0 = mix(vec3(0.04), albedo, metallic);

    vec3 shadowEyePos;
    if (useShadowViewMatrix)
        shadowEyePos = (shadowViewMatrix * vec4(worldPos, 1.0)).xyz;
    else
        shadowEyePos = eyePos;
    float shadow = shadowMap(shadowEyePos, N);
    
    vec3 radiance = vec3(0.0);

    // Sun light
    vec3 L = lightDirection;
    
    float NL = max(dot(N, L), 0.0);
    float NE = max(dot(N, E), 0.0);
    vec3 H = normalize(E + L);
    float LH = max(dot(L, H), 0.0);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);
    vec3 F = fresnelRoughness(max(dot(H, E), 0.0), f0, roughness);

    vec3 kD = (1.0 - F);
    vec3 specular = (NDF * G * F) / max(4.0 * max(dot(N, E), 0.0) * NL, 0.001);
    
    vec3 incomingLight = toLinear(lightColor.rgb) * lightEnergy;
    
    // Based on Hanrahan-Krueger BRDF approximation of isotropic BSSRDF
    // 1.25 scale is used to (roughly) preserve albedo
    // fss90 used to "flatten" retroreflection based on roughness
    float FL = schlickFresnel(NL);
    float FV = schlickFresnel(NE);
    float fss90 = LH * LH * max(roughness, 0.001);
    float fss = mix(1.0, fss90, FL) * mix(1.0, fss90, FV);
    float ss = 1.25 * (fss * (1.0 / max(NL + NE, 0.1) - 0.5) + 0.5);
    
    vec3 diffuse = invPI * albedo * mix(kD * shadow * NL * occlusion, vec3(ss), subsurface) * (1.0 - metallic);
    
    radiance += (diffuse * lightDiffuse + (specular * lightSpecular * shadow * NL)) * incomingLight;
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;
    
    // Clip background surfaces
    radiance *= col.a;
    
    if (lightScattering)
    {
        float opticalDepth = 1.0;
        
        if (lightScatteringShadow)
        {
            vec3 startPosition = vec3(0.0);
            vec3 rayVector = eyePos;
            float rayLength = length(rayVector);
            vec3 rayDirection = rayVector / rayLength;
            float stepSize = rayLength / float(lightScatteringSamples);
            vec3 currentPosition = startPosition;
            float invSamples = 1.0 / float(lightScatteringSamples);
            float offset = hash((texCoord * 467.759 + time) * eyePos.z);
            opticalDepth = 0.0;
            for (float i = 0; i < float(lightScatteringSamples); i+=1.0)
            {
                opticalDepth += shadowLookup(shadowTextureArray, 1.0, shadowMatrix2 * vec4(currentPosition, 1.0), vec2(0.0));
                currentPosition += rayDirection * (stepSize - offset * lightScatteringMaxRandomStepOffset);
            }
            opticalDepth *= invSamples;
        }
        
        float scattFactor = clamp(opticalDepth * scattering(dot(-L, E)) * lightScatteringDensity, 0.0, 1.0);
        radiance = mix(radiance, toLinear(lightColor.rgb) * lightEnergy, scattFactor);
    }
    
    fragColor = vec4(radiance, 1.0);
}
