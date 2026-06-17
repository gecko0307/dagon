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
uniform float sunAngularRadius;
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
uniform vec4 diffuseVector;
uniform sampler2D diffuseTexture;
uniform int diffuseFunc;

/*
 * Normal mapping
 */
uniform vec3 normalVector;
uniform sampler2D normalTexture;
uniform int normalFunc;
uniform bool generateTBN;
uniform float normalYSign;

/*
 * Height mapping
 */
uniform float heightScalar;
uniform sampler2D heightTexture;
uniform int heightFunc;

/*
 * Parallax mapping
 */
uniform float parallaxScale;
uniform float parallaxBias;

vec2 parallaxSimple(in vec3 E, in vec2 uv, in float h)
{
    float currentHeight = h * parallaxScale + parallaxBias;
    return uv + (currentHeight * E.xy);
}

// Based on code written by Igor Dykhta (Sun and Black Cat)
// http://sunandblackcat.com/tipFullView.php?topicid=28
vec2 parallaxOcclusionMapping(in vec3 E, in vec2 uv, in float h)
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
        currentHeight = texture(heightTexture, currentTextureCoords).r;
    }

    vec2 prevTCoords = currentTextureCoords - dtex;
    float nextH = currentHeight - curLayerHeight;
    float prevH = texture(heightTexture, prevTCoords).r - curLayerHeight + layerHeight;
    float weight = nextH / (nextH - prevH);
    return prevTCoords * weight + currentTextureCoords * (1.0 - weight);
}

uniform int parallaxFunc;

/*
 * Roughness/Metallic
 */
uniform sampler2D roughnessMetallicTexture;
uniform vec4 roughnessMetallicFactor;
uniform int roughnessMetallicFunc;

/*
 * Emission
 */
uniform vec4 emissionFactor;
uniform sampler2D emissionTexture;
uniform int emissionFunc;

/*
 * Ambient
 */
uniform vec4 ambientVector;
uniform sampler2D ambientTexture;
vec3 ambientEquirectangularMap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTexture, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTexture, envMapEquirect(wN), lod).rgb;
}

uniform samplerCube ambientTextureCube;
vec3 ambientCubemap(in vec3 wN, in float perceptualRoughness)
{
    ivec2 envMapSize = textureSize(ambientTextureCube, 0);
    float resolution = float(max(envMapSize.x, envMapSize.y));
    float lod = log2(resolution) * perceptualRoughness;
    return textureLod(ambientTextureCube, wN, lod).rgb;
}

uniform int ambientFunc;

uniform float ambientEnergy;

/*
 * Shadow
 */
const float eyeSpaceNormalShift = 0.008;
float shadowMapCascaded(in vec3 pos, in vec3 N)
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

uniform int shadowFunc;

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
        float height = texture(heightTexture, texCoord).r;
        if (parallaxFunc == 1)
            uv = parallaxSimple(tE, texCoord, height);
        else if (parallaxFunc == 2)
            uv = parallaxOcclusionMapping(tE, texCoord, height);
        
        N = normalVector;
        if (normalFunc == 1)
            N = normalize(texture(normalTexture, uv).rgb * 2.0 - 1.0);
        N.y *= normalYSign;
        N = normalize(tangentToEye * N);
    }
    
    vec3 R = reflect(E, N);
    
    vec3 worldPos = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    vec3 worldCamPos = (invViewMatrix[3]).xyz;
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldN = normalize(N * mat3(viewMatrix));
    vec3 worldR = reflect(worldE, worldN);
    
    vec3 L = sunDirection;

    vec4 diff = diffuseVector;
    if (diffuseFunc == 1)
        diff = texture(diffuseTexture, uv);
    
    vec3 albedo = toLinear(diff.rgb);
    
    vec4 roughnessMetallic = roughnessMetallicFactor;
    if (roughnessMetallicFunc == 1)
        roughnessMetallic = texture(roughnessMetallicTexture, uv);
    float roughness = roughnessMetallic.g;
    float metallic = roughnessMetallic.b;
    vec3 f0 = mix(vec3(0.04), albedo, metallic);
    
    float shadow = 1.0;
    if (shadowFunc == 1)
        shadow = shadowMapCascaded(eyePosition, N);
    
    vec3 emission;
    if (emissionFunc == 1)
        emission = texture(emissionTexture, uv).rgb * emissionFactor.rgb * energy;
    else
        emission = emissionFactor.rgb * energy;
    
    vec3 radiance = toLinear(emission);
    float alpha;
    
    if (shaded)
    {
        vec3 reflected = radiance;
        
        // Ambient light
        {
            float perceptualRoughness = sqrt(roughness);
            
            vec3 irradiance, reflection;
            if (ambientFunc == 1)
            {
                irradiance = ambientEquirectangularMap(worldN, 0.99);
                reflection = ambientEquirectangularMap(worldR, perceptualRoughness);
            }
            else if (ambientFunc == 2)
            {
                irradiance = ambientCubemap(worldN, 0.99);
                reflection = ambientCubemap(worldR, perceptualRoughness);
            }
            else
            {
                irradiance = toLinear(ambientVector.rgb);
                reflection = irradiance;
            }
            
            vec3 F = clamp(fresnelRoughness(dot(N, E), f0, roughness), 0.0, 1.0);
            vec3 kD = (1.0 - F) * (1.0 - metallic);
            vec2 brdf = haveAmbientBRDF? texture(ambientBRDF, vec2(dot(N, E), roughness)).rg : vec2(1.0, 0.0);
            vec3 specular = reflection * clamp(F * brdf.x + brdf.y, 0.0, 1.0) * ambientEnergy;
            radiance += kD * irradiance * ambientEnergy * albedo + specular;
            reflected += specular;
        }
        
        // Sun light
        {
            float NL = max(dot(N, L), 0.0);
            vec3 H = normalize(E + L);
            
            float NDF = distributionGGX(N, H, roughness);
            float G = geometrySmith(N, E, L, roughness);
            vec3 F = fresnelRoughness(max(dot(H, E), 0.0), f0, max(roughness, sunAngularRadius));
            
            vec3 kD = (1.0 - F) * (1.0 - metallic);
            vec3 specular = (NDF * G *  F) / max(4.0 * max(dot(N, E), 0.0) * NL, 0.00001);
            
            vec3 incomingLight = toLinear(sunColor.rgb) * sunEnergy;
            vec3 diffuse = albedo * invPI;
            
            radiance += (kD * diffuse + specular) * NL * incomingLight * shadow;
            reflected += specular * NL * incomingLight * shadow;
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
                for (float i = 0; i < float(sunScatteringSamples); i += 1.0)
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
        alpha = stateOpacity * mix(mix(diff.a * materialOpacity, 1.0, alphaFresnel), 1.0, reflectedLuminance);
    }
    else
    {
        alpha = stateOpacity * diff.a * materialOpacity;
    }
    
    // Velocity
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    
    fragColor = vec4(radiance, alpha);
    fragVelocity = vec4(screenVelocity, blurMask, 0.0);
}
