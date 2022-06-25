#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

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

in vec2 texCoord;

#include <unproject.glsl>
#include <gamma.glsl>
#include <fresnel.glsl>
#include <envMapEquirect.glsl>

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

uniform sampler2D ambientBRDF;
uniform bool haveAmbientBRDF;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec4 col = texture(colorBuffer, texCoord);
    if (col.a < 1.0)
        discard;
    
    vec3 albedo = toLinear(col.rgb);
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);
    float NE = max(dot(N, E), 0.0);
    
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize((vec4(N, 0.0) * viewMatrix).xyz);
    vec3 worldR = reflect(worldE, worldN);
    
    vec4 pbr = texture(pbrBuffer, texCoord);
    float roughness = pbr.r;
    float metallic = pbr.g;
    float reflectivity = pbr.b;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;
    
    vec3 f0 = mix(vec3(0.04), albedo, metallic);

    // Ambient light
    vec3 irradiance = ambient(worldN, 0.99); // TODO: support separate irradiance map
    vec3 reflection = ambient(worldR, roughness) * reflectivity;
    vec3 F = clamp(fresnelRoughness(NE, f0, roughness), 0.0, 1.0);
    vec3 kD = (1.0 - F) * (1.0 - metallic);
    vec2 brdf = haveAmbientBRDF? texture(ambientBRDF, vec2(NE, roughness)).rg : vec2(1.0, 0.0);
    vec3 specular = reflection * clamp(F * brdf.x + brdf.y, 0.0, 1.0);
    vec3 radiance = (kD * irradiance * albedo + specular) * occlusion;
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);

    fragColor = vec4(radiance, 1.0);
}
