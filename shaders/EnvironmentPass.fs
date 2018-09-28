#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform sampler2D colorBuffer;
uniform sampler2D rmsBuffer;
uniform sampler2D positionBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D emissionBuffer;
uniform vec2 viewSize;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowTextureSize;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

uniform sampler2D environmentMap;
//uniform bool useEnvironmentMap;

uniform mat4 camViewMatrix;
uniform mat4 camInvViewMatrix;
uniform mat4 camProjectionMatrix;

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform bool enableSSAO;

in vec2 texCoord;

const float eyeSpaceNormalShift = 0.05;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

float shadowLookup(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in vec2 offset)
{
    float texelSize = 1.0 / shadowTextureSize;
    vec2 v = offset * texelSize * coord.w;
    vec4 c = (coord + vec4(v.x, v.y, 0.0, 0.0)) / coord.w;
    c.w = c.z;
    c.z = layer;
    float s = texture(depths, c);
    return s;
}

float shadow(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in float yshift)
{
    return shadowLookup(depths, layer, coord, vec2(0.0, yshift));
}

float shadowPCF(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in float radius, in float yshift)
{
    float s = 0.0;
    float x, y;
	for (y = -radius ; y < radius ; y += 1.0)
	for (x = -radius ; x < radius ; x += 1.0)
    {
	    s += shadowLookup(depths, layer, coord, vec2(x, y + yshift));
    }
	s /= radius * radius * 4.0;
    return s;
}

float weight(in vec4 tc, in float coef)
{
    vec2 proj = vec2(tc.x / tc.w, tc.y / tc.w);
    proj = (1.0 - abs(proj * 2.0 - 1.0)) * coef;
    proj = clamp(proj, 0.0, 1.0);
    return min(proj.x, proj.y);
}

float rescale(float x, float mi, float ma)
{
    return (max(x, mi) - mi) / (ma - mi);
}

/*
float sigmoid(float x, float k)
{
    float s = (x + x * k - k * 0.5 - 0.5) / (abs(x * k * 4.0 - k * 2.0) - k + 1.0) + 0.5;
    return clamp(s, 0.0, 1.0);
}
*/

/*
 * Environment subroutines.
 * Used to switch sky/envmap.
 */
subroutine vec3 srtEnv(in vec3 wN, in vec3 wSun, in float roughness);

uniform vec4 skyZenithColor;
uniform vec4 skyHorizonColor;
uniform vec4 groundColor;
uniform float skyEnergy;
uniform float groundEnergy;
subroutine(srtEnv) vec3 environmentSky(in vec3 wN, in vec3 wSun, in float roughness)
{
    float p1 = clamp(roughness, 0.5, 1.0);
    float p2 = clamp(roughness, 0.4, 1.0);

    float horizonOrZenith = pow(clamp(dot(wN, vec3(0, 1, 0)), 0.0, 1.0), p1);
    float groundOrSky = pow(clamp(dot(wN, vec3(0, -1, 0)), 0.0, 1.0), p2);

    vec3 env = mix(
        mix(toLinear(skyHorizonColor.rgb) * skyEnergy, 
            toLinear(groundColor.rgb) * groundEnergy, groundOrSky), 
            toLinear(skyZenithColor.rgb) * skyEnergy, horizonOrZenith);
            
    return env;
}

vec2 envMapEquirect(in vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / PI2, phi / PI);
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec3 environmentTexture(in vec3 wN, in vec3 wSun, in float roughness)
{
    ivec2 envMapSize = textureSize(envTexture, 0);
    float maxLod = log2(float(max(envMapSize.x, envMapSize.y)));
    float lod = maxLod * roughness;
    //float lod = roughness * 16.0;
    return textureLod(envTexture, envMapEquirect(wN), lod).rgb;
}

subroutine uniform srtEnv environment;

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

vec3 noise(vec2 coord)
{
    float noiseX, noiseY, noiseZ;
    const float noiseamount = 0.0002;
    noiseX = clamp(fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453), 0.0, 1.0) * 2.0 - 1.0;
    noiseY = clamp(fract(sin(dot(coord, vec2(12.9898, 78.233)*2.0)) * 43758.5453), 0.0, 1.0) * 2.0 - 1.0;
    noiseZ = clamp(fract(sin(dot(coord, vec2(12.9898, 78.233)*3.0)) * 43758.5453), 0.0, 1.0) * 2.0 - 1.0;
    return vec3(noiseX, noiseY, noiseZ) * noiseamount;
}

const vec3 uKernelOffsets[10] = vec3[](
    vec3(-0.010735935, 0.01647018, 0.0062425877),
    vec3(-0.06533369, 0.3647007, -0.13746321),
    vec3(-0.6539235, -0.016726388, -0.53000957),
    vec3(0.40958285, 0.0052428036, -0.5591124),
    vec3(-0.1465366, 0.09899267, 0.15571679),
    vec3(-0.44122112, -0.5458797, 0.04912532),
    vec3(0.03755566, -0.10961345, -0.33040273),
    vec3(0.019100213, 0.29652783, 0.066237666),
    vec3(0.8765323, 0.011236004, 0.28265962),
    vec3(0.29264435, -0.40794238, 0.15964167));
    
const int SSAO_SAMPLE_COUNT = 8;

// TODO: make uniform
const float ssaoRadius = 0.5;
const float ssaoFalloff = 100.0;

float luminance(vec3 color)
{
    return (
        color.x * 0.27 +
        color.y * 0.67 +
        color.z * 0.06
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luminance;

void main()
{
    vec2 invViewSize = 1.0 / viewSize;
    
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
    vec3 R = reflect(E, N);

    vec3 worldPos = (camInvViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 worldCamPos = (camInvViewMatrix[3]).xyz;
    vec3 worldView = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize(N * mat3(camViewMatrix));
    vec3 worldR = reflect(worldView, worldN);
    vec3 worldSun = sunDirection * mat3(camViewMatrix);

    vec4 posShifted = vec4(eyePos, 1.0) + vec4(N * eyeSpaceNormalShift, 0.0);
    vec4 shadowCoord1 = shadowMatrix1 * posShifted;
    vec4 shadowCoord2 = shadowMatrix2 * posShifted;
    vec4 shadowCoord3 = shadowMatrix3 * posShifted;
    
    // Calculate shadow from 3 cascades   
    float s1, s2, s3;
    {    
        s1 = shadowPCF(shadowTextureArray, 0.0, shadowCoord1, 2.0, 0.0);
        s2 = shadow(shadowTextureArray, 1.0, shadowCoord2, 0.0);
        s3 = shadow(shadowTextureArray, 2.0, shadowCoord3, 0.0);
        float w1 = weight(shadowCoord1, 8.0);
        float w2 = weight(shadowCoord2, 8.0);
        float w3 = weight(shadowCoord3, 8.0);
        s3 = mix(1.0, s3, w3); 
        s2 = mix(s3, s2, w2);
        s1 = mix(s2, s1, w1); // s1 stores resulting shadow value
    }
    
    // SSAO
    float occlusion = 1.0;
    if (enableSSAO)
    {
        occlusion = 0.0;
        vec3 rvec = noise(texCoord);
        vec3 tangent = normalize(rvec - N * dot(rvec, N));
        vec3 bitangent = cross(tangent, N);
        mat3 kernelBasis = mat3(tangent, bitangent, N);
        for (int s = 0; s < SSAO_SAMPLE_COUNT; s++)
        {
            vec3 delta = kernelBasis * uKernelOffsets[s];
            delta *= float(dot(N, delta) >= 0.0) * 2.0 - 1.0;
            vec3 samplePos = eyePos + delta * ssaoRadius;

            vec4 projSamplePos = camProjectionMatrix * vec4(samplePos, 1.0);
            vec2 sampleUV = (projSamplePos.xy / projSamplePos.w) * 0.5 + 0.5;
    
            vec3 dstPosition = texture(positionBuffer, sampleUV).xyz;
            vec3 positionVec = dstPosition - samplePos;

            float bias = 0.5; //0.375;
            float intensity = max(dot(normalize(positionVec), N) - bias, 0.0);
            float dist = length(positionVec) / ssaoRadius;
            float attenuation = 1.0 / (1.0 + dist);
            occlusion += intensity * attenuation;
        }
        occlusion = clamp(1.0 - occlusion, 0.0, 1.0);
    }
    
    vec3 radiance = vec3(0.0, 0.0, 0.0);
    
    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);
    
    // Sun light
    {
        vec3 L = sunDirection;
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

        radiance += (kD * albedo / PI + specular) * toLinear(sunColor.rgb) * NL * sunEnergy * s1;
    }
    
    // Ambient light
    {
        vec3 ambientDiffuse = environment(worldN, worldSun, 0.9);
        vec3 ambientSpecular = environment(worldR, worldSun, roughness);
    
        vec3 F = fresnelRoughness(max(dot(N, E), 0.0), f0, roughness);
        vec3 kS = F;
        vec3 kD = 1.0 - kS;
        kD *= 1.0 - metallic;
        radiance += kD * ambientDiffuse * albedo + F * ambientSpecular;
    }
    
    // Emission
    radiance += texture(emissionBuffer, texCoord).rgb;
    
    // Occlusion
    radiance *= occlusion;
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);

    frag_color = vec4(radiance, 1.0);
    frag_luminance = vec4(luminance(radiance), 0.0, 0.0, 1.0);
}
