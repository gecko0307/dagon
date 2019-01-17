#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform sampler2D colorBuffer;
uniform sampler2D rmsBuffer;
uniform sampler2D positionBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D emissionBuffer;
uniform vec2 viewSize;

uniform mat4 camViewMatrix;
uniform mat4 camInvViewMatrix;
uniform mat4 camProjectionMatrix;

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;

in vec2 texCoord;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowTextureSize;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;
const float eyeSpaceNormalShift = 0.05;

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

subroutine float srtShadow(in vec3 pos, in vec3 N);

subroutine(srtShadow) float shadowMapNone(in vec3 pos, in vec3 N)
{
    return 1.0;
}

subroutine(srtShadow) float shadowMapCascaded(in vec3 pos, in vec3 N)
{
    vec4 posShifted = vec4(pos, 1.0) + vec4(N * eyeSpaceNormalShift, 0.0);
    vec4 shadowCoord1 = shadowMatrix1 * posShifted;
    vec4 shadowCoord2 = shadowMatrix2 * posShifted;
    vec4 shadowCoord3 = shadowMatrix3 * posShifted;
    
    // CSM
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
        s1 = mix(s2, s1, w1);
    }
    
    return s1;
}

subroutine uniform srtShadow shadowMap;


float rescale(float x, float mi, float ma)
{
    return (max(x, mi) - mi) / (ma - mi);
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

    vec3 radiance = vec3(0.0, 0.0, 0.0);

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    float sh = shadowMap(eyePos, N);

    // Sun light
    {
        vec3 L = -sunDirection;
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

        radiance += (kD * albedo / PI + specular) * toLinear(sunColor.rgb) * NL * sunEnergy; // * sh;
    }

    frag_color = vec4(radiance, 1.0);
    frag_luminance = vec4(luminance(radiance), 0.0, 0.0, 1.0);
}
