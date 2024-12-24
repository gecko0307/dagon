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
uniform mat4 invModelMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform bool useBoxProjection;

#include <unproject.glsl>
#include <gamma.glsl>
#include <fresnel.glsl>
#include <envMapEquirect.glsl>

uniform float ambientEnergy;

subroutine vec3 srtAmbient(in vec3 wN, in float perceptualRoughness);

uniform vec4 ambientVector;
subroutine(srtAmbient) vec3 ambientColor(in vec3 wN, in float perceptualRoughness)
{
    return toLinear(ambientVector.rgb);
}

uniform sampler2D ambientTexture;
subroutine(srtAmbient) vec3 ambientEquirectangularMap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTexture, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    //float glossyExponent = 2.0 / pow(roughness, 4.0) - 2.0;
    //float lod = log2(size * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTexture, envMapEquirect(wN), lod).rgb;
}

uniform samplerCube ambientTextureCube;
subroutine(srtAmbient) vec3 ambientCubemap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTextureCube, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    //float glossyExponent = 2.0 / pow(roughness, 4.0) - 2.0;
    //float lod = log2(size * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTextureCube, wN, lod).rgb;
}

subroutine uniform srtAmbient ambient;

uniform sampler2D ambientBRDF;
uniform bool haveAmbientBRDF;

// Model-space box projection
vec3 bpcem(in vec3 pos, in vec3 v)
{
    const vec3 boxMax = vec3(1.0, 1.0, 1.0);
    const vec3 boxMin = vec3(-1.0, -1.0, -1.0);
    vec3 nrdir = v;
    vec3 rbmax = (boxMax - pos) / nrdir;
    vec3 rbmin = (boxMin - pos) / nrdir;
    vec3 rbminmax;
    rbminmax.x = (nrdir.x > 0.0)? rbmax.x : rbmin.x;
    rbminmax.y = (nrdir.y > 0.0)? rbmax.y : rbmin.y;
    rbminmax.z = (nrdir.z > 0.0)? rbmax.z : rbmin.z;
    float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);
    vec3 posOnBox = pos + nrdir * fa;
    return posOnBox;
}

layout(location = 0) out vec4 fragColor;

void main()
{
    vec2 gbufTexCoord = gl_FragCoord.xy / resolution;
    
    vec4 col = texture(colorBuffer, gbufTexCoord);
    if (col.a < 1.0)
        discard;
    
    float depth = texture(depthBuffer, gbufTexCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(gbufTexCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 objPos = (invModelMatrix * vec4(worldPos, 1.0)).xyz;

    // Perform bounds check to discard fragments outside the probe geometry
    if (abs(objPos.x) > 1.0) discard;
    if (abs(objPos.y) > 1.0) discard;
    if (abs(objPos.z) > 1.0) discard;
    
    // TODO: make uniform
    float alpha = 1.0;
    
    vec3 albedo = toLinear(col.rgb);
    
    vec3 N = normalize(texture(normalBuffer, gbufTexCoord).rgb);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);
    float NE = max(dot(N, E), 0.0);
    
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize((vec4(N, 0.0) * viewMatrix).xyz);
    vec3 worldR = reflect(worldE, worldN);
    
    if (useBoxProjection)
    {
        vec3 objN = (invModelMatrix * vec4(worldN, 0.0)).xyz;
        worldN = normalize(bpcem(objPos, objN));
        vec3 objR = (invModelMatrix * vec4(worldR, 0.0)).xyz;
        worldR = normalize(bpcem(objPos, objR));
    }
    
    vec4 pbr = texture(pbrBuffer, gbufTexCoord);
    float roughness = pbr.r;
    float metallic = pbr.g;
    float reflectivity = 1.0;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, gbufTexCoord).r : 1.0;
    
    vec3 f0 = mix(vec3(0.04), albedo, metallic);

    // Ambient light
    vec3 irradiance = ambient(worldN, 0.99); // TODO: support separate irradiance map
    vec3 reflection = ambient(worldR, sqrt(roughness)) * reflectivity;
    vec3 F = clamp(fresnelRoughness(NE, f0, roughness), 0.0, 1.0);
    vec3 kD = (1.0 - F) * (1.0 - metallic);
    vec2 brdf = haveAmbientBRDF? texture(ambientBRDF, vec2(NE, roughness)).rg : vec2(1.0, 0.0);
    vec3 specular = reflection * clamp(F * brdf.x + brdf.y, 0.0, 1.0);
    vec3 radiance = (kD * irradiance * albedo + specular) * occlusion * ambientEnergy;
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);

    fragColor = vec4(radiance, alpha);
}
