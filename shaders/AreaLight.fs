#version 400 core

#define PI 3.14159265359

uniform sampler2D colorBuffer;
uniform sampler2D rmsBuffer;
uniform sampler2D positionBuffer;
uniform sampler2D normalBuffer;

uniform vec2 viewSize;

uniform vec3 lightPosition;
uniform vec3 lightPosition2;
uniform float lightRadius;
uniform float lightAreaRadius;
uniform vec3 lightColor;
uniform float lightEnergy;
//uniform float lightSpotCutoff;
uniform float lightSpotCosCutoff;
uniform float lightSpotCosInnerCutoff;
uniform float lightSpotExponent;
uniform vec3 lightSpotDirection;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

vec3 fresnel(float cosTheta, vec3 f0)
{
    return f0 + (1.0 - f0) * pow(1.0 - cosTheta, 5.0);
}

vec3 fresnelRoughness(float cosTheta, vec3 f0, float roughness)
{
    return f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(1.0 - cosTheta, 5.0);
}

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

float geometrySchlickGGX(float NdotV, float roughness)
{
    float r = (roughness + 1.0);
    float k = (r*r) / 8.0;
    float num = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    return num / denom;
}

float geometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2  = geometrySchlickGGX(NdotV, roughness);
    float ggx1  = geometrySchlickGGX(NdotL, roughness);
    return ggx1 * ggx2;
}

/*
 * Light radiance subroutines
 */
subroutine vec3 srtLightRadiance(in vec3 pos, in vec3 N, in vec3 E, in vec3 albedo, in float roughness, in float metallic);

subroutine(srtLightRadiance) vec3 lightRadianceFallback(in vec3 pos, in vec3 N, in vec3 E, in vec3 albedo, in float roughness, in float metallic)
{
    return vec3(0.0);
}

subroutine(srtLightRadiance) vec3 lightRadianceAreaSphere(in vec3 pos, in vec3 N, in vec3 E, in vec3 albedo, in float roughness, in float metallic)
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

    vec3 radiance = (kD * albedo / PI + specular) * toLinear(lightColor) * attenuation * NL;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceAreaTube(in vec3 pos, in vec3 N, in vec3 E, in vec3 albedo, in float roughness, in float metallic)
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

    vec3 radiance = (kD * albedo / PI + specular) * toLinear(lightColor) * attenuation * NL;

    return radiance;
}

subroutine(srtLightRadiance) vec3 lightRadianceSpot(in vec3 pos, in vec3 N, in vec3 E, in vec3 albedo, in float roughness, in float metallic)
{
    vec3 R = reflect(E, N);
    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    vec3 positionToLightSource = lightPosition - pos;
    float distanceToLight = length(positionToLightSource);
    vec3 L = normalize(positionToLightSource);
    float attenuation = pow(clamp(1.0 - (distanceToLight / lightRadius), 0.0, 1.0), 2.0) * lightEnergy;

    float spotCos = clamp(dot(L, normalize(lightSpotDirection)), 0.0, 1.0);
    //float spotValue = float(spotCos > lightSpotCosCutoff);
    //spotValue *= pow(spotCos, lightSpotExponent);
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

    vec3 radiance = (kD * albedo / PI + specular) * toLinear(lightColor) * attenuation * NL;

    return radiance;
}

subroutine uniform srtLightRadiance lightRadiance;


float luminance(vec3 color)
{
    return (
        color.x * 0.2126 +
        color.y * 0.7152 +
        color.z * 0.0722
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luminance;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / viewSize;

    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = toLinear(col.rgb);

    vec4 rms = texture(rmsBuffer, texCoord);
    float roughness = rms.r;
    float metallic = rms.g;

    vec3 eyePos = texture(positionBuffer, texCoord).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).xyz);
    vec3 E = normalize(-eyePos);

    vec3 radiance = lightRadiance(eyePos, N, E, albedo, roughness, metallic);

    frag_color = vec4(radiance, 1.0);
    frag_luminance = vec4(luminance(radiance), 0.0, 0.0, 1.0);
}
