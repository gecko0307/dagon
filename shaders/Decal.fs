#version 400 core

uniform sampler2D positionBuffer;

uniform vec2 viewSize;

uniform mat4 invViewMatrix;
uniform mat4 invModelMatrix;

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


layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_normal;

void main()
{
    vec2 gbufTexCoord = gl_FragCoord.xy / viewSize;

    vec3 eyePos = texture(positionBuffer, gbufTexCoord).xyz;
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
    
    mat3 tangentToEye = cotangentFrame(N, eyePos, texCoord);
    vec3 tE = normalize(E * tangentToEye);
    
    vec2 shiftedTexCoord = parallax(tE, texCoord, height(texCoord));
    N = normal(shiftedTexCoord, -1.0, tangentToEye);
    
    vec4 d = diffuse(shiftedTexCoord);
    vec3 color = d.rgb;
    
    frag_color = vec4(color, d.a);
    frag_normal = vec4(N, d.a);
}
