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
uniform float zNear;
uniform float zFar;

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

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

vec3 toGamma(vec3 v)
{
    return pow(v, vec3(1.0 / 2.2));
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

float shadowLookup(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in vec2 offset)
{
    float texelSize = 1.0 / shadowResolution;
    vec2 v = offset * texelSize * coord.w;
    vec4 c = (coord + vec4(v.x, v.y, 0.0, 0.0)) / coord.w;
    c.w = c.z;
    c.z = layer;
    float s = texture(depths, c);
    return s;
}

float shadowLookupPCF(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in float radius)
{
    float s = 0.0;
    float x, y;
    for (y = -radius ; y < radius ; y += 1.0)
    for (x = -radius ; x < radius ; x += 1.0)
    {
        s += shadowLookup(depths, layer, coord, vec2(x, y));
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
    
    float w1 = weight(shadowCoord1, 8.0);
    float w2 = weight(shadowCoord2, 8.0);
    float w3 = weight(shadowCoord3, 8.0);
    s3 = mix(1.0, s3, w3); 
    s2 = mix(s3, s2, w2);
    s1 = mix(s2, s1, w1);
    
    return s1;
}

subroutine uniform srtShadow shadowMap;


// Mie scaterring approximated with Henyey-Greenstein phase function.
float scattering(float lightDotView)
{
    float result = 1.0 - lightScatteringG * lightScatteringG;
    result /= 4.0 * PI * pow(1.0 + lightScatteringG * lightScatteringG - (2.0 * lightScatteringG) * lightDotView, 1.5);
    return result;
}

float hash(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.11369, 0.13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

void main()
{
    vec4 col = texture(colorBuffer, texCoord);

    vec3 albedo = toLinear(col.rgb);
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);
    
    vec4 pbr = texture(pbrBuffer, texCoord);
    float roughness = pbr.r;
    float metallic = pbr.g;
    float specularity = pbr.b;
    float translucency = pbr.a;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;
    
    vec3 f0 = mix(vec3(0.04), albedo, metallic);

    float shadow = shadowMap(eyePos, N);
    
    vec3 radiance = vec3(0.0);

    // Sun light
    vec3 L = lightDirection;
    
    if (col.a == 1.0)
    {
        float NL = max(dot(N, L), 0.0);
        vec3 H = normalize(E + L);

        float NDF = distributionGGX(N, H, roughness);
        float G = geometrySmith(N, E, L, roughness);
        vec3 F = fresnelRoughness(max(dot(H, E), 0.0), f0, roughness);

        vec3 kD = (1.0 - F) * (1.0 - metallic);
        vec3 specular = (NDF * G * F) / max(4.0 * max(dot(N, E), 0.0) * NL, 0.001);
        
        vec3 incomingLight = toLinear(lightColor.rgb) * lightEnergy;
        vec3 diffuse = albedo * invPI * occlusion;

        radiance += (kD * diffuse + specular * specularity) * NL * incomingLight * shadow;
        
        // Fake SSS
        float rim = pow(1.0 - abs(min(dot(N, L), 0.0)), 10.0);
        radiance += (rim * kD * diffuse) * incomingLight * translucency;
        
        // Fog
        float linearDepth = abs(eyePos.z);
        float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
        radiance *= fogFactor;
    }
    
    float scattFactor = 0.0;
    if (lightScattering)
    {
        vec3 startPosition = vec3(0.0);    
        vec3 rayVector = eyePos;
        float rayLength = length(rayVector);
        vec3 rayDirection = rayVector / rayLength;
        float stepSize = rayLength / float(lightScatteringSamples);
        vec3 currentPosition = startPosition;
        float accumScatter = 0.0;
        float invSamples = 1.0 / float(lightScatteringSamples);
        float prevValue = 0.0;
        float offset = hash(texCoord * 467.759 * eyePos.z);
        for (float i = 0; i < float(lightScatteringSamples); i+=1.0)
        {
            accumScatter += shadowLookup(shadowTextureArray, 1.0, shadowMatrix2 * vec4(currentPosition, 1.0), vec2(0.0));
            currentPosition += rayDirection * (stepSize - offset * lightScatteringMaxRandomStepOffset);
        }
        accumScatter *= invSamples;
        scattFactor = accumScatter * scattering(dot(-L, E)) * lightScatteringDensity;
        radiance += toLinear(lightColor.rgb) * lightEnergy * scattFactor;
    }
    
    fragColor = vec4(radiance, 1.0);
}
