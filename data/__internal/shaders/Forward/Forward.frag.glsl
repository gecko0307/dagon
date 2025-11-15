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
uniform float materialOpacity;
uniform float stateOpacity;

uniform bool shaded;
uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform bool sunScattering;
uniform float sunScatteringG;
uniform float sunScatteringDensity;
uniform int sunScatteringSamples;
uniform float sunScatteringMaxRandomStepOffset;
uniform bool sunScatteringShadow;

uniform float time;

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowResolution;
uniform mat4 shadowMatrix1;
uniform mat4 shadowMatrix2;
uniform mat4 shadowMatrix3;

uniform int textureMappingMode;

uniform float blurMask;

#include <gamma.glsl>
#include <matcap.glsl>
#include <cotangentFrame.glsl>
#include <envMapEquirect.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>
#include <shadow.glsl>
#include <hash.glsl>

/*
 * Diffuse
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
 * Normal mapping
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

uniform bool generateTBN;
uniform float normalYSign;


/*
 * Height mapping
 */
subroutine float srtHeight(in vec2 uv);

uniform float heightScalar;
subroutine(srtHeight) float heightValue(in vec2 uv)
{
    return heightScalar;
}

uniform sampler2D heightTexture;
subroutine(srtHeight) float heightMap(in vec2 uv)
{
    return texture(heightTexture, uv).r;
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
 * PBR
 */
uniform sampler2D roughnessMetallicTexture;
uniform vec4 roughnessMetallicFactor;

/*
 * Roughness
 */
subroutine float srtRoughness(in vec2 uv);

subroutine(srtRoughness) float roughnessValue(in vec2 uv)
{
    return roughnessMetallicFactor.g;
}

subroutine(srtRoughness) float roughnessMap(in vec2 uv)
{
    return texture(roughnessMetallicTexture, uv).g;
}

subroutine uniform srtRoughness roughness;


/*
 * Metallic
 */
subroutine float srtMetallic(in vec2 uv);

subroutine(srtMetallic) float metallicValue(in vec2 uv)
{
    return roughnessMetallicFactor.b;
}

subroutine(srtMetallic) float metallicMap(in vec2 uv)
{
    return texture(roughnessMetallicTexture, uv).b;
}

subroutine uniform srtMetallic metallic;


/*
 * Emission
 */
subroutine vec3 srtEmission(in vec2 uv);

uniform vec4 emissionFactor;
subroutine(srtEmission) vec3 emissionValue(in vec2 uv)
{
    return emissionFactor.rgb * energy;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec3 emissionMap(in vec2 uv)
{
    return texture(emissionTexture, uv).rgb * emissionFactor.rgb * energy;
}

subroutine uniform srtEmission emission;


/*
 * Ambient
 */
uniform float ambientEnergy;

subroutine vec3 srtAmbient(in vec3 wN, in float perceptualRoughness);

uniform vec4 ambientVector;
subroutine(srtAmbient) vec3 ambientColor(in vec3 wN, in float perceptualRoughness)
{
    return ambientVector.rgb;
}

uniform sampler2D ambientTexture;
subroutine(srtAmbient) vec3 ambientEquirectangularMap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTexture, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    //float glossyExponent = 2.0 / pow(perceptualRoughness, 4.0) - 2.0;
    //float lod = log2(resolution * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTexture, envMapEquirect(wN), lod).rgb;
}

uniform samplerCube ambientTextureCube;
subroutine(srtAmbient) vec3 ambientCubemap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTextureCube, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    //float glossyExponent = 2.0 / pow(perceptualRoughness, 4.0) - 2.0;
    //float lod = log2(resolution * sqrt(3.0)) - 0.5 * log2(glossyExponent + 1.0);
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTextureCube, wN, lod).rgb;
}

subroutine uniform srtAmbient ambient;


/*
 * Shadow
 */
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


uniform sampler2D ambientBRDF;
uniform bool haveAmbientBRDF;


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
    vec2 uv = texCoord;
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    
    if (textureMappingMode == 1)
        uv = matcap(E, N);
    
    if (generateTBN)
    {
        mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
        vec3 tE = normalize(E * tangentToEye);
        uv = parallax(tE, texCoord, height(texCoord));
        N = normal(uv, normalYSign, tangentToEye);
    }
    
    vec3 R = reflect(E, N);
    
    vec3 worldPos = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize(N * mat3(viewMatrix));
    vec3 worldR = reflect(worldE, worldN);
    
    vec3 L = sunDirection;

    vec4 diff = diffuse(uv);
    vec3 albedo = toLinear(diff.rgb);
    float r = roughness(uv);
    float m = metallic(uv);
    float s = 1.0;
    vec3 f0 = mix(vec3(0.04), albedo, m);
    
    float shadow = shadowMap(eyePosition, N);
    
    vec3 radiance = toLinear(emission(uv));
    
    vec3 reflected = radiance;
    
    // Ambient light
    {
        vec3 irradiance = ambient(worldN, 0.99);
        vec3 reflection = ambient(worldR, sqrt(r)) * s;
        vec3 F = clamp(fresnelRoughness(dot(N, E), f0, r), 0.0, 1.0);
        vec3 kD = (1.0 - F) * (1.0 - m);
        vec2 brdf = haveAmbientBRDF? texture(ambientBRDF, vec2(dot(N, E), r)).rg : vec2(1.0, 0.0);
        vec3 specular = reflection * clamp(F * brdf.x + brdf.y, 0.0, 1.0) * ambientEnergy;
        radiance += kD * irradiance * ambientEnergy * albedo + specular;
        reflected += specular;
    }
    
    // Sun light
    {
        float NL = max(dot(N, L), 0.0);
        vec3 H = normalize(E + L);
        
        float NDF = distributionGGX(N, H, r);
        float G = geometrySmith(N, E, L, r);
        vec3 F = fresnelRoughness(max(dot(H, E), 0.0), f0, r);
        
        vec3 kD = (1.0 - F) * (1.0 - m);
        vec3 specular = (NDF * G *  F) / max(4.0 * max(dot(N, E), 0.0) * NL, 0.001);
        
        vec3 incomingLight = toLinear(sunColor.rgb) * sunEnergy;
        vec3 diffuse = albedo * invPI;
        
        radiance += (kD * diffuse + specular * s) * NL * incomingLight * shadow;
        reflected += specular * s * NL * incomingLight * shadow;
    }
    
    // TODO: fixed number of area lights
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);
    reflected = mix(toLinear(fogColor.rgb), reflected, fogFactor);
    
    // Sun light scattering
    if (sunScattering)
    {
        float accumScatter = 1.0;
        
        if (sunScatteringShadow)
        {
            vec3 startPosition = vec3(0.0);
            vec3 rayVector = eyePosition;
            float rayLength = length(rayVector);
            vec3 rayDirection = rayVector / rayLength;
            float stepSize = rayLength / float(sunScatteringSamples);
            vec3 currentPosition = startPosition;
            float invSamples = 1.0 / float(sunScatteringSamples);
            float offset = hash((texCoord * 467.759 + time) * eyePosition.z);
            accumScatter = 0.0;
            for (float i = 0; i < float(sunScatteringSamples); i+=1.0)
            {
                accumScatter += shadowLookup(shadowTextureArray, 1.0, shadowMatrix2 * vec4(currentPosition, 1.0), vec2(0.0));
                currentPosition += rayDirection * (stepSize - offset * sunScatteringMaxRandomStepOffset);
            }
            accumScatter *= invSamples;
        }
        
        float scattFactor = clamp(accumScatter * scattering(dot(-L, E)) * sunScatteringDensity, 0.0, 1.0);
        radiance = mix(radiance, toLinear(sunColor.rgb) * sunEnergy, scattFactor);
        reflected = mix(reflected, toLinear(sunColor.rgb) * sunEnergy, scattFactor);
    }
    
    float reflectedLuminance = clamp(dot(reflected, vec3(0.2125, 0.7154, 0.0721)), 0.0, 1.0);
    float alphaFresnel = clamp(fresnel(dot(N, E), 0.04), 0.0, 1.0);
    float alpha = stateOpacity * mix(mix(diff.a * materialOpacity, 1.0, alphaFresnel), 1.0, reflectedLuminance);
    
    // Velocity
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    
    fragColor = vec4(radiance, alpha);
    fragVelocity = vec4(screenVelocity, blurMask, 0.0);
}
