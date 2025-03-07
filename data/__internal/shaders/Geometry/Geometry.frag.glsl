#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

in vec4 currPosition;
in vec4 prevPosition;

uniform float energy;
uniform float opacity;
uniform float clipThreshold;
uniform float gbufferMask;
uniform float blurMask;
uniform int textureMappingMode;

#include <gamma.glsl>
#include <matcap.glsl>
#include <cotangentFrame.glsl>

/*
 * Diffuse color
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
 * Subsurface
 */
uniform float subsurfaceFactor;
 
float subsurface(in vec2 uv)
{
    return subsurfaceFactor;
}

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

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragEmission;
layout(location = 4) out vec4 fragVelocity;
//layout(location = 5) out vec4 fragRadiance;

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
    
    vec4 fragDiffuse = diffuse(uv);
    
    if ((fragDiffuse.a * opacity) < clipThreshold)
        discard;
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    
    fragColor = vec4(fragDiffuse.rgb, gbufferMask);
    fragNormal = vec4(N, 0.0);
    fragPBR = vec4(
        max(roughness(uv), 0.0001),
        metallic(uv),
        subsurface(uv),
        0.0);
    fragEmission = vec4(toLinear(emission(uv)), 1.0);
    fragVelocity = vec4(velocity, blurMask, 1.0);
}
