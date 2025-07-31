#version 400 core

#define PI 3.14159265359
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
uniform float zNear;
uniform float zFar;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform vec3 lightPositionWorld;
uniform vec3 lightPosition;
uniform vec3 lightPosition2;
uniform float lightRadius;
uniform float lightAreaRadius;
uniform vec4 lightColor;
uniform float lightEnergy;
uniform float lightSpotCosCutoff;
uniform float lightSpotCosInnerCutoff;
uniform vec3 lightSpotDirection;
uniform float lightSpecular;
uniform float lightDiffuse;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>
#include <gamma.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>

float schlickFresnel(float u)
{
    float m = clamp(1.0 - u, 0.0, 1.0);
    float m2 = m * m;
    return m2 * m2 * m;
}

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
    in float subsurface,
    in float occlusion);

subroutine(srtLightRadiance) vec3 lightRadianceFallback(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float subsurface,
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
    in float subsurface,
    in float occlusion)
{
    vec3 R = reflect(E, N);

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 positionToLightSource = lightPosition - pos;
    float distanceToLight = length(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / max(lightRadius, 0.001)), 0.0, 1.0), 4.0) * lightEnergy;

    vec3 Lpt = normalize(positionToLightSource);

    vec3 centerToRay = dot(positionToLightSource, R) * R - positionToLightSource;
    vec3 closestPoint = positionToLightSource + centerToRay * clamp(lightAreaRadius / max(length(centerToRay), 0.001), 0.0, 1.0);
    vec3 L = normalize(closestPoint);  

    float NL = max(dot(N, Lpt), 0.0);
    float NE = max(dot(N, E), 0.0);
    vec3 H = normalize(E + L);
    float LH = max(dot(L, H), 0.0);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);
    
    vec3 kD = vec3(1.0) - F;
    
    // Based on Hanrahan-Krueger BRDF approximation of isotropic BSSRDF
    // 1.25 scale is used to (roughly) preserve albedo
    // fss90 used to "flatten" retroreflection based on roughness
    float FL = schlickFresnel(NL);
    float FV = schlickFresnel(NE);
    float fss90 = LH * LH * max(roughness, 0.001);
    float fss = mix(1.0, fss90, FL) * mix(1.0, fss90, FV);
    float ss = 1.25 * (fss * (1.0 / max(NL + NE, 0.1) - 0.5) + 0.5);
    
    vec3 diffuse = invPI * albedo * mix(kD * NL * occlusion, vec3(ss), subsurface) * (1.0 - metallic);

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);
    
    vec3 incomingLight = toLinear(lightColor.rgb) * attenuation;
    vec3 radiance = (diffuse * lightDiffuse + specular * lightSpecular * NL) * incomingLight;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceAreaTube(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float subsurface, 
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
    float attenuation = pow(clamp(1.0 - (distanceToLight / max(lightRadius, 0.001)), 0.0, 1.0), 4.0) * lightEnergy;

    vec3 Lpt = normalize(positionToLightSource);

    float NL = max(dot(N, Lpt), 0.0);
    float NE = max(dot(N, E), 0.0);
    vec3 H = normalize(E + L);
    float LH = max(dot(L, H), 0.0);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);
    
    vec3 kD = vec3(1.0) - F;
    
    // Based on Hanrahan-Krueger BRDF approximation of isotropic BSSRDF
    // 1.25 scale is used to (roughly) preserve albedo
    // fss90 used to "flatten" retroreflection based on roughness
    float FL = schlickFresnel(NL);
    float FV = schlickFresnel(NE);
    float fss90 = LH * LH * max(roughness, 0.001);
    float fss = mix(1.0, fss90, FL) * mix(1.0, fss90, FV);
    float ss = 1.25 * (fss * (1.0 / max(NL + NE, 0.1) - 0.5) + 0.5);
    
    vec3 diffuse = invPI * albedo * mix(kD * NL * occlusion, vec3(ss), subsurface) * (1.0 - metallic);
    
    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);
    
    vec3 incomingLight = toLinear(lightColor.rgb) * attenuation;
    vec3 radiance = (diffuse * lightDiffuse + specular * lightSpecular * NL) * incomingLight;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceSpot(
    in vec3 pos, 
    in vec3 N, 
    in vec3 E, 
    in vec3 albedo, 
    in float roughness, 
    in float metallic, 
    in float subsurface,
    in float occlusion)
{
    vec3 R = reflect(E, N);
    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 positionToLightSource = lightPosition - pos;
    float distanceToLight = length(positionToLightSource);
    vec3 L = normalize(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / max(lightRadius, 0.001)), 0.0, 1.0), 2.0) * lightEnergy;

    float spotCos = clamp(dot(L, normalize(lightSpotDirection)), 0.0, 1.0);
    float spotValue = smoothstep(lightSpotCosCutoff, lightSpotCosInnerCutoff, spotCos);
    attenuation *= spotValue;

    float NL = max(dot(N, L), 0.0);
    float NE = max(dot(N, E), 0.0);
    vec3 H = normalize(E + L);
    float LH = max(dot(L, H), 0.0);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, E, L, roughness);
    vec3 F = fresnel(max(dot(H, E), 0.0), f0);
    
    vec3 kD = vec3(1.0) - F;
    
    // Based on Hanrahan-Krueger BRDF approximation of isotropic BSSRDF
    // 1.25 scale is used to (roughly) preserve albedo
    // fss90 used to "flatten" retroreflection based on roughness
    float FL = schlickFresnel(NL);
    float FV = schlickFresnel(NE);
    float fss90 = LH * LH * max(roughness, 0.001);
    float fss = mix(1.0, fss90, FL) * mix(1.0, fss90, FV);
    float ss = 1.25 * (fss * (1.0 / max(NL + NE, 0.1) - 0.5) + 0.5);
    
    vec3 diffuse = invPI * albedo * mix(kD * NL * occlusion, vec3(ss), subsurface) * (1.0 - metallic);

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
    vec3 specular = numerator / max(denominator, 0.001);
    
    vec3 incomingLight = toLinear(lightColor.rgb) * attenuation;
    vec3 radiance = (diffuse * lightDiffuse + specular * lightSpecular * NL) * incomingLight;

    return radiance;
}

subroutine uniform srtLightRadiance lightRadiance;

subroutine float srtShadow(in vec3 pos);

subroutine(srtShadow) float shadowMapNone(in vec3 pos)
{
    return 1.0;
}

const float bias = 0.01;
subroutine(srtShadow) float shadowMapDualParaboloid(in vec3 worldPos)
{
    vec3 lightSpacePos = worldPos - lightPositionWorld;
    float distanceToLight = length(lightSpacePos);
    vec3 dir = normalize(lightSpacePos);
    vec2 uv = dir.xy / (1.0 + abs(dir.z));
    uv = uv * 0.5 + 0.5;
    float layer = 1.0 - float(dir.z >= 0.0);
    float z = distanceToLight / max(0.001, lightRadius) - bias;
    float shadow = texture(shadowTextureArray, vec4(uv, layer, z));
    return shadow;
}

subroutine uniform srtShadow shadowMap;


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
    float subsurface = pbr.b;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;
    float shadow = shadowMap(worldPos);
    
    vec3 radiance = lightRadiance(eyePos, N, E, albedo, roughness, metallic, subsurface, occlusion) * shadow;
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;
    
    fragColor = vec4(radiance, 1.0);
}
