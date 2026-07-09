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
 * Diffuse color
 */
uniform vec4 diffuseVector;
uniform sampler2D diffuseTexture;
uniform int diffuseFunc;

/*
 * Normal
 */
uniform vec3 normalVector;
uniform sampler2D normalTexture;
uniform int normalFunc;

/*
 * Height
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
    
    float height = heightScalar;
    if (heightFunc == 1)
        height = texture(heightTexture, texCoord).r;
    
    // Parallax mapping
    if (parallaxFunc == 1)
        texCoord = parallaxSimple(tE, texCoord, height);
    else if (parallaxFunc == 2)
        texCoord = parallaxOcclusionMapping(tE, texCoord, height);
    
    // Normal mapping
    N = normalVector;
    if (normalFunc == 1)
        N = normalize(texture(normalTexture, texCoord).rgb * 2.0 - 1.0);
    N.y *= -1.0;
    N = normalize(tangentToEye * N);
    
    vec4 diffuseColor = diffuseVector;
    if (diffuseFunc == 1)
        diffuseColor = texture(diffuseTexture, texCoord);
    vec3 albedo = diffuseColor.rgb;
    
    vec4 emission = emissionFactor;
    if (emissionFunc == 1)
        emission = texture(emissionTexture, texCoord);
    vec3 emiss = toLinear(emission.rgb) * emissionEnergy;
    
    vec4 roughnessMetallic = roughnessMetallicFactor;
    if (roughnessMetallicFunc == 1)
        roughnessMetallic = texture(roughnessMetallicTexture, texCoord);
    
    fragColor = vec4(albedo, diffuseColor.a);
    fragNormal = vec4(N, diffuseColor.a);
    fragPBR = vec4(
        roughnessMetallic.g,
        roughnessMetallic.b,
        0.0, // TODO: SSS
        diffuseColor.a);
    fragEmission = vec4(emiss, diffuseColor.a);
}
