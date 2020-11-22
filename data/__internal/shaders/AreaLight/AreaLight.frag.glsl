#version 400 core

#define PI 3.14159265359

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
uniform float zNear;
uniform float zFar;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform vec3 lightPosition;
uniform vec3 lightPosition2;
uniform float lightRadius;
uniform float lightAreaRadius;
uniform vec4 lightColor;
uniform float lightEnergy;
uniform float lightSpotCosCutoff;
uniform float lightSpotCosInnerCutoff;
uniform float lightSpotExponent;
uniform vec3 lightSpotDirection;
uniform float lightSpecular;
uniform float lightDiffuse;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>
#include <gamma.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>

/*
 * Light radiance subroutines
 */
subroutine vec3 srtLightRadiance(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float specularity, 
    in float occlusion);

subroutine(srtLightRadiance) vec3 lightRadianceFallback(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float specularity, 
    in float occlusion)
{
    return vec3(0.0);
}

subroutine(srtLightRadiance) vec3 lightRadianceAreaSphere(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float specularity, 
    in float occlusion)
{
    vec3 R = reflect(E, N);

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 positionToLightSource = lightPosition - pos;
    float distanceToLight = length(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / lightRadius), 0.0, 1.0), 2.0) * lightEnergy;

    vec3 Lpt = normalize(positionToLightSource);

    vec3 centerToRay = dot(positionToLightSource, R) * R - positionToLightSource;
    vec3 closestPoint = positionToLightSource + centerToRay * clamp(lightAreaRadius / length(centerToRay), 0.0, 1.0);
    vec3 L = normalize(closestPoint);  

    float NL = max(dot(N, Lpt), 0.0); 
    vec3 H = normalize(E + L);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);      
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);

    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);

    vec3 radiance = (kD * albedo / PI * occlusion * lightDiffuse + specular * specularity * lightSpecular) * toLinear(lightColor.rgb) * attenuation * NL;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceAreaTube(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float specularity, 
    in float occlusion)
{
    vec3 R = reflect(E, N);
    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 L0 = lightPosition - pos;
    vec3 L1 = lightPosition2 - pos;
    vec3 Ld = L1 - L0;
    float t = dot(R, L0) * dot(R, Ld) - dot(L0, Ld);
    float RLd = dot(R, Ld);
    t /= dot(Ld, Ld) - RLd * RLd;
    vec3 L = L0 + clamp(t, 0.0, 1.0) * Ld;

    vec3 centerToRay = dot(L, R) * R - L;
    vec3 closestPoint = L + centerToRay * clamp(lightAreaRadius / length(centerToRay), 0.0, 1.0);
    L = normalize(closestPoint);

    vec3 positionToLightSource = (lightPosition + lightPosition2) * 0.5 - pos;
    float distanceToLight = length(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / lightRadius), 0.0, 1.0), 2.0) * lightEnergy;

    vec3 Lpt = normalize(positionToLightSource);

    float NL = max(dot(N, Lpt), 0.0); 
    vec3 H = normalize(E + L);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);      
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);

    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);

    vec3 radiance = (kD * albedo / PI * occlusion * lightDiffuse + specular * specularity * lightSpecular) * toLinear(lightColor.rgb) * attenuation * NL;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceSpot(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float specularity, 
    in float occlusion)
{
    vec3 R = reflect(E, N);
    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 positionToLightSource = lightPosition - pos;
    float distanceToLight = length(positionToLightSource);
    vec3 L = normalize(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / lightRadius), 0.0, 1.0), 2.0) * lightEnergy;

    float spotCos = clamp(dot(L, normalize(lightSpotDirection)), 0.0, 1.0);
    float spotValue = smoothstep(lightSpotCosCutoff, lightSpotCosInnerCutoff, spotCos);
    attenuation *= spotValue;

    float NL = max(dot(N, L), 0.0); 
    vec3 H = normalize(E + L);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);      
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);

    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);

    vec3 radiance = (kD * albedo / PI * occlusion * lightDiffuse + specular * specularity * lightSpecular) * toLinear(lightColor.rgb) * attenuation * NL;

    return radiance;
}

subroutine uniform srtLightRadiance lightRadiance;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / resolution;
    
    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = toLinear(col.rgb);
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    
    vec4 pbr = texture(pbrBuffer, texCoord);
    float roughness = pbr.r;
    float metallic = pbr.g;
    float specularity = pbr.b;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;

    vec3 radiance = lightRadiance(eyePos, N, E, albedo, roughness, metallic, specularity, occlusion);
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;

    fragColor = vec4(radiance, 1.0);
}
