#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;
in vec2 texCoord2;

in vec4 currPosition;
in vec4 prevPosition;

uniform float energy;
uniform float opacity;
uniform float clipThreshold;
uniform float gbufferMask;
uniform float blurMask;
uniform int textureMappingMode;
uniform bool gammaCorrect;
uniform float maxVelocity;

#include <gamma.glsl>
#include <matcap.glsl>
#include <cotangentFrame.glsl>

/*
 * Diffuse color
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
 * Subsurface
 */
uniform float subsurfaceFactor;

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
layout(location = 4) out vec4 fragVelocity;

vec2 clampLength(vec2 v, float maxLen)
{
    float len = length(v);
    return v * (min(len, maxLen) / max(len, 0.0001)); 
}

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
    
    vec4 fragDiffuse = diffuseVector;
    if (diffuseFunc == 1)
        fragDiffuse = texture(diffuseTexture, uv);
    
    vec3 color = fragDiffuse.rgb;
    if (gammaCorrect)
        color = toGamma(fragDiffuse.rgb);
    
    if ((fragDiffuse.a * opacity) < clipThreshold)
        discard;
    
    vec4 roughnessMetallic = roughnessMetallicFactor;
    if (roughnessMetallicFunc == 1)
        roughnessMetallic = texture(roughnessMetallicTexture, uv);
    float roughness = roughnessMetallic.g;
    float metallic = roughnessMetallic.b;
    
    vec3 emission;
    if (emissionFunc == 1)
        emission = toLinear(texture(emissionTexture, uv).rgb) * toLinear(emissionFactor.rgb) * energy;
    else
        emission = toLinear(emissionFactor.rgb) * energy;
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = clampLength(posScreen - prevPosScreen, maxVelocity);
    
    fragColor = vec4(color, gbufferMask);
    fragNormal = vec4(N, 0.0);
    fragPBR = vec4(
        max(roughness, 0.0001),
        metallic,
        subsurfaceFactor,
        0.0);
    // TODO: lightmapping support
    fragEmission = vec4(emission, 1.0);
    fragVelocity = vec4(velocity, blurMask, 1.0);
}
