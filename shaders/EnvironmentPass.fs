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

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform bool enableSSAO;

in vec2 texCoord;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
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

uniform samplerCube envTextureCube;
subroutine(srtEnv) vec3 environmentCubemap(in vec3 wN, in vec3 wSun, in float roughness)
{
    ivec2 envMapSize = textureSize(envTextureCube, 0);
    float maxLod = log2(float(max(envMapSize.x, envMapSize.y)));
    float lod = maxLod * roughness;
    //float lod = roughness * 16.0;
    return textureLod(envTextureCube, wN, lod).rgb;
}

subroutine uniform srtEnv environment;

uniform float environmentBrightness;

vec3 fresnel(float cosTheta, vec3 f0)
{
    return f0 + (1.0 - f0) * pow(1.0 - cosTheta, 5.0);
}

vec3 fresnelRoughness(float cosTheta, vec3 f0, float roughness)
{
    return f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(1.0 - cosTheta, 5.0);
}

// SSAO implementation based on code by Reinder Nijhoff
// https://www.shadertoy.com/view/Ms33WB

uniform int ssaoSamples;
uniform float ssaoRadius;
uniform float ssaoPower;

#define SSAO_SCALE 1.0
#define SSAO_BIAS 0.05
#define SSAO_MOD3 vec3(0.1031, 0.11369, 0.13787)
//#define SSAO_MAX_DISTANCE 0.2

float hash(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * SSAO_MOD3);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

float ssao(in vec2 tcoord, in vec2 uv, in vec3 p, in vec3 cnorm)
{
    vec3 pos = texture(positionBuffer, tcoord + uv).xyz;
    vec3 diff = pos - p;
    float l = length(diff);
    vec3 v = diff / l;
    float d = l * SSAO_SCALE;
    float ao = max(0.0, dot(cnorm, v) - SSAO_BIAS) * (1.0 / (1.0 + d));
    //ao *= smoothstep(SSAO_MAX_DISTANCE, SSAO_MAX_DISTANCE * 0.5, l);
    return ao;
}

float spiralSSAO(vec2 uv, vec3 p, vec3 n, float rad)
{
    float goldenAngle = 2.4;
    float ao = 0.0;
    float inv = 1.0 / float(ssaoSamples);
    float radius = 0.0;

    float rotatePhase = hash(uv * 100.0) * 6.28;
    float rStep = inv * rad;
    vec2 spiralUV;

    for (int i = 0; i < ssaoSamples; i++)
    {
        spiralUV.x = sin(rotatePhase);
        spiralUV.y = cos(rotatePhase);
        radius += rStep;
        ao += ssao(uv, spiralUV * radius, p, n);
        rotatePhase += goldenAngle;
    }
    ao *= inv;
    return ao;
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

    // SSAO
    float occlusion = 1.0;
    if (enableSSAO)
    {
        occlusion = spiralSSAO(texCoord, eyePos, N, ssaoRadius / eyePos.z);
        occlusion = pow(clamp(1.0 - occlusion, 0.0, 1.0), ssaoPower);
    }

    vec3 radiance = vec3(0.0, 0.0, 0.0);

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);

    // Ambient light
    {
        vec3 ambientDiffuse = environment(worldN, worldSun, 0.9);
        vec3 ambientSpecular = environment(worldR, worldSun, roughness);

        vec3 F = fresnelRoughness(max(dot(N, E), 0.0), f0, roughness);
        vec3 kS = F;
        vec3 kD = 1.0 - kS;
        kD *= 1.0 - metallic;
        radiance += (kD * ambientDiffuse * albedo * occlusion + F * ambientSpecular) * environmentBrightness;
    }

    // Emission
    radiance += texture(emissionBuffer, texCoord).rgb;

    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);

    frag_color = vec4(radiance, 1.0);
    frag_luminance = vec4(luminance(radiance), 0.0, 0.0, 1.0);
}
