#version 400 core

uniform int layer;
uniform float blurMask;

in vec2 texCoord;
in vec3 eyePosition;
in vec3 eyeNormal;

in vec4 blurPosition;
in vec4 prevPosition;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}


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
 * Height mapping subroutines.
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
 * PBR parameters
 */
uniform sampler2D pbrTexture;

/*
 * Emission
 */
subroutine vec4 srtEmission(in vec2 uv);

uniform vec4 emissionVector;
subroutine(srtEmission) vec4 emissionValue(in vec2 uv)
{
    return emissionVector;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec4 emissionMap(in vec2 uv)
{
    return texture(emissionTexture, uv);
}

subroutine uniform srtEmission emission;

uniform float emissionEnergy;

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_rms;
layout(location = 2) out vec4 frag_position;
layout(location = 3) out vec4 frag_normal;
layout(location = 4) out vec4 frag_velocity;
layout(location = 5) out vec4 frag_emission;

void main()
{
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);

    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    vec3 tE = normalize(E * tangentToEye);

    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;

    vec2 shiftedTexCoord = parallax(tE, texCoord, height(texCoord));

    N = normal(shiftedTexCoord, -1.0, tangentToEye);

    vec4 diffuseColor = diffuse(shiftedTexCoord);

    vec4 rms = texture(pbrTexture, shiftedTexCoord);
    vec3 emiss = emission(shiftedTexCoord).rgb * emissionEnergy;

    // This is written to frag_color.w and frag_position.w
    // and determines that the fragment belongs to foreground object
    float geometryMask = float(layer > 0);

    frag_color = vec4(diffuseColor.rgb, geometryMask);
    frag_rms = vec4(rms.r, rms.g, 1.0, 1.0);
    frag_position = vec4(eyePosition, geometryMask);
    frag_normal = vec4(N, 1.0);
    frag_velocity = vec4(screenVelocity, 0.0, blurMask);
    frag_emission = vec4(emiss, 1.0);
}
