#version 400 core

uniform sampler2D terrainNormalBuffer;
uniform sampler2D terrainTexcoordBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

uniform mat3 textureMatrix;

uniform float energy;
uniform float opacity;
uniform float clipThreshold;

in vec2 texCoord;

#include <unproject.glsl>
#include <cotangentFrame.glsl>
#include <gamma.glsl>

/*
 * Layer mask
 */
uniform float maskFactor;
uniform sampler2D maskTexture;
uniform int maskFunc;

/*
 * Diffuse
 */
uniform vec4 diffuseVector;
uniform sampler2D diffuseTexture;
uniform int diffuseFunc;

/*
 * Normal map
 */
uniform vec3 normalVector;
uniform sampler2D normalTexture;
uniform int normalFunc;
uniform bool generateTBN;
uniform float normalYSign;

/*
 * Height map
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

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragEmission;

void main()
{
    vec4 terrTexCoordSample = texture(terrainTexcoordBuffer, texCoord);
    vec2 terrTexCoord = terrTexCoordSample.xy;
    vec2 uv = (textureMatrix * vec3(terrTexCoord, 1.0)).xy;
    
    float depth = terrTexCoordSample.z;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    
    vec4 diff = diffuseVector;
    if (diffuseFunc == 1)
        diff = texture(diffuseTexture, uv);
    vec3 albedo = diff.rgb;
    
    vec4 normalSample = texture(terrainNormalBuffer, texCoord);
    vec3 N = normalize(normalSample.xyz);
    vec3 E = normalize(-eyePos);
    
    if (generateTBN)
    {
        mat3 tangentToEye = cotangentFrame(N, eyePos, terrTexCoord);
        vec3 tE = normalize(E * tangentToEye);
        
        float height = texture(heightTexture, uv).r;
        if (parallaxFunc == 1)
            uv = parallaxSimple(tE, uv, height);
        else if (parallaxFunc == 2)
            uv = parallaxOcclusionMapping(tE, uv, height);
        
        N = normalVector;
        if (normalFunc == 1)
            N = normalize(texture(normalTexture, uv).rgb * 2.0 - 1.0);
        N.y *= normalYSign;
        N = normalize(tangentToEye * N);
    }
    
    float gbufferMask = normalSample.a;
    float mask = maskFactor;
    if (maskFunc == 1)
        mask = texture(maskTexture, terrTexCoord).r;
    mask *= opacity * gbufferMask;
    
    if (mask < clipThreshold)
        discard;
    
    vec4 roughnessMetallic = roughnessMetallicFactor;
    if (roughnessMetallicFunc == 1)
        roughnessMetallic = texture(roughnessMetallicTexture, uv);
    float roughness = roughnessMetallic.g;
    float metallic = roughnessMetallic.b;
    
    vec3 emission;
    if (emissionFunc == 1)
        emission = texture(emissionTexture, uv).rgb * energy;
    else
        emission = emissionFactor.rgb * energy;
    
    fragColor = vec4(albedo, mask);
    fragNormal = vec4(N, mask);
    fragPBR = vec4(
        max(roughness, 0.0001),
        metallic,
        0.0,
        mask);
    fragEmission = vec4(toLinear(emission), mask);
}
