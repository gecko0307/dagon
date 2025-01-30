#version 400 core

uniform sampler2D depthBuffer;

uniform vec2 resolution;

uniform mat4 invViewMatrix;
uniform mat4 invModelMatrix;
uniform mat4 invProjectionMatrix;
uniform mat3 textureMatrix;

#include <unproject.glsl>
#include <gamma.glsl>
#include <cotangentFrame.glsl>

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
 * Height mapping subroutines.
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
uniform sampler2D roughnessMetallicTexture;
uniform vec4 roughnessMetallicFactor;

subroutine float srtRoughness(in vec2 uv);

uniform float roughnessScalar;
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

uniform float metallicScalar;
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
subroutine vec4 srtEmission(in vec2 uv);

uniform vec4 emissionFactor;
subroutine(srtEmission) vec4 emissionColorValue(in vec2 uv)
{
    return emissionFactor;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec4 emissionColorTexture(in vec2 uv)
{
    return texture(emissionTexture, uv);
}

subroutine uniform srtEmission emission;

uniform float emissionEnergy;


layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragEmission;

void main()
{
    vec2 gbufTexCoord = gl_FragCoord.xy / resolution;

    float depth = texture(depthBuffer, gbufTexCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(gbufTexCoord, depth));
    
    vec3 E = normalize(-eyePos);

    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 objPos = (invModelMatrix * vec4(worldPos, 1.0)).xyz;

    // Perform bounds check to discard fragments outside the decal box
    if (abs(objPos.x) > 1.0) discard;
    if (abs(objPos.y) > 1.0) discard;
    if (abs(objPos.z) > 1.0) discard;
    
    // Normal
    vec3 fdx = dFdx(eyePos);
    vec3 fdy = dFdy(eyePos);
    vec3 N = normalize(cross(fdx, fdy));
    
    // Texcoord (go from -1..1 to 0..1)
    vec2 texCoord = objPos.xz * 0.5 + 0.5;
    texCoord = (textureMatrix * vec3(texCoord, 1.0)).xy;
    
    mat3 tangentToEye = cotangentFrame(N, eyePos, texCoord);
    vec3 tE = normalize(E * tangentToEye);
    
    vec2 shiftedTexCoord = parallax(tE, texCoord, height(texCoord));
    N = normal(shiftedTexCoord, -1.0, tangentToEye);
    
    vec4 diffuseColor = diffuse(shiftedTexCoord);
    vec3 albedo = diffuseColor.rgb; //toLinear(diffuseColor.rgb);
    
    vec3 emiss = toLinear(emission(shiftedTexCoord).rgb) * emissionEnergy;
    
    const float specularity = 1.0;
    
    fragColor = vec4(albedo, diffuseColor.a);
    fragNormal = vec4(N, diffuseColor.a);
    fragPBR = vec4(roughness(shiftedTexCoord), metallic(shiftedTexCoord), specularity, diffuseColor.a);
    fragEmission = vec4(emiss, diffuseColor.a);
}
