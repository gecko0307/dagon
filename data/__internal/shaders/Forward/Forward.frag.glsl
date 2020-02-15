#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;
const float invPI = 1.0 / PI;

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

in vec4 currPosition;
in vec4 prevPosition;

uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;

uniform float layer;
uniform float energy;
uniform float opacity;

uniform bool shaded;
uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform bool sunScattering;
uniform float sunScatteringG;
uniform float sunScatteringDensity;
uniform int sunScatteringSamples;
uniform float sunScatteringMaxRandomStepOffset;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

#include <gamma.glsl>
#include <cotangentFrame.glsl>
#include <envMapEquirect.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>
#include <shadow.glsl>
#include <hash.glsl>

/*
 * Diffuse color subroutines.
 * Used to switch color/texture.
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColorValue(in vec2 uv)
{
    return diffuseVector;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseColorTexture(in vec2 uv)
{
    return texture(diffuseTexture, uv);
}

subroutine uniform srtColor diffuse;

/*
 * Normal mapping subroutines.
 */
subroutine vec3 srtNormal(in vec2 uv, in float ysign, in mat3 tangentToEye);

uniform vec3 normalVector;
subroutine(srtNormal) vec3 normalValue(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalVector;
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

uniform sampler2D normalTexture;
subroutine(srtNormal) vec3 normalMap(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalize(texture(normalTexture, uv).rgb * 2.0 - 1.0);
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal;


/*
 * Height mapping
 */
subroutine float srtHeight(in vec2 uv);

uniform float heightScalar;
subroutine(srtHeight) float heightValue(in vec2 uv)
{
    return heightScalar;
}

subroutine(srtHeight) float heightMap(in vec2 uv)
{
    return texture(normalTexture, uv).a;
}

subroutine uniform srtHeight height;


/*
 * Parallax mapping
 */
subroutine vec2 srtParallax(in vec3 E, in vec2 uv, in float h);

uniform float parallaxScale;
uniform float parallaxBias;

subroutine(srtParallax) vec2 parallaxNone(in vec3 E, in vec2 uv, in float h)
{
    return uv;
}

subroutine(srtParallax) vec2 parallaxSimple(in vec3 E, in vec2 uv, in float h)
{
    float currentHeight = h * parallaxScale + parallaxBias;
    return uv + (currentHeight * E.xy);
}

// Based on code written by Igor Dykhta (Sun and Black Cat)
// http://sunandblackcat.com/tipFullView.php?topicid=28
subroutine(srtParallax) vec2 parallaxOcclusionMapping(in vec3 E, in vec2 uv, in float h)
{
    const float minLayers = 10.0;
    const float maxLayers = 15.0;
    float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), E)));
    float layerHeight = 1.0 / numLayers;
    float curLayerHeight = 0.0;
    vec2 dtex = parallaxScale * E.xy / E.z / numLayers;
    vec2 currentTextureCoords = uv;

    float currentHeight = h;
    while(currentHeight > curLayerHeight)
    {
        curLayerHeight += layerHeight;
        currentTextureCoords += dtex;
        currentHeight = height(currentTextureCoords);
    }

    vec2 prevTCoords = currentTextureCoords - dtex;
    float nextH = currentHeight - curLayerHeight;
    float prevH = height(prevTCoords) - curLayerHeight + layerHeight;
    float weight = nextH / (nextH - prevH);
    return prevTCoords * weight + currentTextureCoords * (1.0 - weight);
}

subroutine uniform srtParallax parallax;


/*
 * Roughness
 */
uniform sampler2D pbrTexture;

subroutine float srtRoughness(in vec2 uv);

uniform float roughnessScalar;
subroutine(srtRoughness) float roughnessValue(in vec2 uv)
{
    return roughnessScalar;
}

subroutine(srtRoughness) float roughnessMap(in vec2 uv)
{
    return texture(pbrTexture, uv).r;
}

subroutine uniform srtRoughness roughness;


/*
 * Metallic
 */
subroutine float srtMetallic(in vec2 uv);

uniform float metallicScalar;
subroutine(srtMetallic) float metallicValue(in vec2 uv)
{
    return metallicScalar;
}

subroutine(srtMetallic) float metallicMap(in vec2 uv)
{
    return texture(pbrTexture, uv).g;
}

subroutine uniform srtMetallic metallic;


/*
 * Specularity
 */
subroutine float srtSpecularity(in vec2 uv);

uniform float specularityScalar;
subroutine(srtSpecularity) float specularityValue(in vec2 uv)
{
    return specularityScalar;
}

subroutine(srtSpecularity) float specularityMap(in vec2 uv)
{
    return texture(pbrTexture, uv).b;
}

subroutine uniform srtSpecularity specularity;


/*
 * Emission
 */
subroutine vec3 srtEmission(in vec2 uv);

uniform vec4 emissionVector;
subroutine(srtEmission) vec3 emissionColorValue(in vec2 uv)
{
    return emissionVector.rgb * energy;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec3 emissionColorTexture(in vec2 uv)
{
    return texture(emissionTexture, uv).rgb * energy;
}

subroutine uniform srtEmission emission;


/*
 * Ambient
 */
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


// Mie scaterring approximated with Henyey-Greenstein phase function.
float scattering(float lightDotView)
{
    float result = 1.0 - sunScatteringG * sunScatteringG;
    result /= 4.0 * PI * pow(1.0 + sunScatteringG * sunScatteringG - (2.0 * sunScatteringG) * lightDotView, 1.5);
    return result;
}


uniform vec2 viewSize;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragVelocity;

void main()
{
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    
    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    vec3 tE = normalize(E * tangentToEye);
    vec2 shiftedTexCoord = parallax(tE, texCoord, height(texCoord));

    N = normal(shiftedTexCoord, -1.0, tangentToEye);
    vec3 R = reflect(E, N);
    
    vec3 worldPos = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize(N * mat3(viewMatrix));
    vec3 worldR = reflect(worldE, worldN);
    
    vec3 L = sunDirection;

    vec4 diff = diffuse(shiftedTexCoord);
    vec3 albedo = toLinear(diff.rgb);
    float alpha = diff.a * opacity;
    float r = roughness(shiftedTexCoord);
    float m = metallic(shiftedTexCoord);
    float s = specularity(shiftedTexCoord);
    vec3 f0 = mix(vec3(0.04), albedo, m);
    
    float shadow = shadowMap(eyePosition, N);
    
    vec3 radiance = vec3(0.0);
    
    // Ambient light
    {
        vec3 ambientDiffuse = ambient(worldN, 0.99);
        vec3 ambientSpecular = ambient(worldR, r) * s;
        vec3 F = fresnelRoughness(max(dot(N, E), 0.0), f0, r);
        vec3 kD = (1.0 - F) * (1.0 - m);
        radiance += kD * ambientDiffuse * albedo + F * ambientSpecular;
    }
    
    // Sun light
    {
        float NL = max(dot(N, L), 0.0);
        vec3 H = normalize(E + L);
        
        float NDF = distributionGGX(N, H, r);
        float G = geometrySmith(N, E, L, r);
        vec3 F = fresnelRoughness(max(dot(H, E), 0.0), f0, r);
        
        vec3 kD = (1.0 - F) * (1.0 - m);
        vec3 specular = (NDF * G * F) / max(4.0 * max(dot(N, E), 0.0) * NL, 0.001);
        
        vec3 incomingLight = toLinear(sunColor.rgb) * sunEnergy * shadow;
        
        radiance += (kD * albedo * invPI + specular * s) * NL * incomingLight;
    }
    
    // TODO: fixed number of area lights
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);
    
    // Sun light scattering
    if (sunScattering)
    {
        vec3 startPosition = vec3(0.0);    
        vec3 rayVector = eyePosition;
        float rayLength = length(rayVector);
        vec3 rayDirection = rayVector / rayLength;
        float stepSize = rayLength / float(sunScatteringSamples);
        vec3 currentPosition = startPosition;
        float accumScatter = 0.0;
        // TODO: disable shadow
        float invSamples = 1.0 / float(sunScatteringSamples);
        float offset = hash(texCoord * 467.759 * eyePosition.z);
        for (float i = 0; i < float(sunScatteringSamples); i += 1.0)
        {
            accumScatter += shadowLookup(shadowTextureArray, 1.0, shadowMatrix2 * vec4(currentPosition, 1.0), vec2(0.0));
            currentPosition += rayDirection * (stepSize - offset * sunScatteringMaxRandomStepOffset);
        }
        accumScatter *= invSamples;
        float scattFactor = accumScatter * scattering(dot(-L, E)) * sunScatteringDensity;
        radiance += toLinear(sunColor.rgb) * sunEnergy * scattFactor;
    }
    
    // Velocity
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    
    fragColor = vec4(radiance, alpha);
    fragVelocity = vec4(screenVelocity, 0.0, 1.0);
}
