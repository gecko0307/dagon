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
subroutine float srtLayerMask(in vec2 uv);

uniform float maskFactor;
subroutine(srtLayerMask) float layerMaskValue(in vec2 uv)
{
    return maskFactor;
}

uniform sampler2D maskTexture;
subroutine(srtLayerMask) float layerMaskTexture(in vec2 uv)
{
    return texture(maskTexture, uv).r;
}

subroutine uniform srtLayerMask layerMask;


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
subroutine(srtEmission) vec3 emissionColorValue(in vec2 uv)
{
    return emissionFactor.rgb * energy;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec3 emissionColorTexture(in vec2 uv)
{
    return texture(emissionTexture, uv).rgb * energy;
}

subroutine uniform srtEmission emission;

//

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
    
    vec4 diff = diffuse(uv);
    vec3 albedo = diff.rgb;
    
    vec4 normalSample = texture(terrainNormalBuffer, texCoord);
    vec3 N = normalize(normalSample.xyz);
    vec3 E = normalize(-eyePos);
    
    if (generateTBN)
    {
        mat3 tangentToEye = cotangentFrame(N, eyePos, terrTexCoord);
        vec3 tE = normalize(E * tangentToEye);
        uv = parallax(tE, uv, height(uv));
        N = normal(uv, normalYSign, tangentToEye);
    }
    
    float gbufferMask = normalSample.a;
    float mask = layerMask(terrTexCoord) * opacity * gbufferMask;
    
    if (mask < clipThreshold)
        discard;
    
    fragColor = vec4(albedo, mask);
    fragNormal = vec4(N, mask);
    fragPBR = vec4(
        max(roughness(uv), 0.0001),
        metallic(uv),
        0.0,
        mask);
    fragEmission = vec4(toLinear(emission(uv)), mask);
}
