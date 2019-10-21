#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

in vec4 currPosition;
in vec4 prevPosition;

uniform float layer;
uniform float energy;
uniform float opacity;

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

mat3 cotangentFrame(in vec3 N, in vec3 p, in vec2 uv)
{
    vec3 dp1 = dFdx(p);
    vec3 dp2 = dFdy(p);
    vec2 duv1 = dFdx(uv);
    vec2 duv2 = dFdy(uv);
    vec3 dp2perp = cross(dp2, N);
    vec3 dp1perp = cross(N, dp1);
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
    float invmax = inversesqrt(max(dot(T, T), dot(B, B)));
    return mat3(T * invmax, B * invmax, N);
}

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


layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragRadiance;
layout(location = 4) out vec4 fragVelocity;

void main()
{
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    
    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    vec3 tE = normalize(E * tangentToEye);
    
    vec2 shiftedTexCoord = parallax(tE, texCoord, height(texCoord));

    N = normal(shiftedTexCoord, -1.0, tangentToEye);
    
    vec4 fragDiffuse = diffuse(shiftedTexCoord);
    
    if ((fragDiffuse.a * opacity) < 0.5)
        discard;
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    const float blurMask = 1.0; 
    
    fragColor = vec4(fragDiffuse.rgb, layer);
    fragNormal = vec4(N, 0.0);
    fragPBR = vec4(roughness(shiftedTexCoord), metallic(shiftedTexCoord), specularity(shiftedTexCoord), 0.0);
    fragRadiance = vec4(emission(shiftedTexCoord), 1.0);
    fragVelocity = vec4(velocity, blurMask, 0.0);
}
