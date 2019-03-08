#version 400 core

uniform int layer;
uniform float blurMask;

in vec2 texCoord;
in vec2 splatTexCoord;

in vec3 eyePosition;
in vec3 eyeNormal;

in vec4 blurPosition;
in vec4 prevPosition;

uniform vec2 textureScale1;
uniform vec2 textureScale2;
uniform vec2 textureScale3;
uniform vec2 textureScale4;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

uniform sampler2D splatmap;

/*
 * Diffuse color subroutines.
 * Used to switch color/texture.
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuse1Vector;
subroutine(srtColor) vec4 diffuse1ColorValue(in vec2 uv)
{
    return diffuse1Vector;
}

uniform sampler2D diffuse1Texture;
subroutine(srtColor) vec4 diffuse1ColorTexture(in vec2 uv)
{
    return texture(diffuse1Texture, uv);
}

subroutine uniform srtColor diffuse1;


uniform vec4 diffuse2Vector;
subroutine(srtColor) vec4 diffuse2ColorValue(in vec2 uv)
{
    return diffuse2Vector;
}

uniform sampler2D diffuse2Texture;
subroutine(srtColor) vec4 diffuse2ColorTexture(in vec2 uv)
{
    return texture(diffuse2Texture, uv);
}

subroutine uniform srtColor diffuse2;


uniform vec4 diffuse3Vector;
subroutine(srtColor) vec4 diffuse3ColorValue(in vec2 uv)
{
    return diffuse3Vector;
}

uniform sampler2D diffuse3Texture;
subroutine(srtColor) vec4 diffuse3ColorTexture(in vec2 uv)
{
    return texture(diffuse3Texture, uv);
}

subroutine uniform srtColor diffuse3;


uniform vec4 diffuse4Vector;
subroutine(srtColor) vec4 diffuse4ColorValue(in vec2 uv)
{
    return diffuse4Vector;
}

uniform sampler2D diffuse4Texture;
subroutine(srtColor) vec4 diffuse4ColorTexture(in vec2 uv)
{
    return texture(diffuse4Texture, uv);
}

subroutine uniform srtColor diffuse4;


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

uniform vec3 normal1Vector;
subroutine(srtNormal) vec3 normal1Value(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normal1Vector;
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

uniform sampler2D normal1Texture;
subroutine(srtNormal) vec3 normal1Map(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalize(texture(normal1Texture, uv).rgb * 2.0 - 1.0);
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal1;

uniform vec3 normal2Vector;
subroutine(srtNormal) vec3 normal2Value(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normal2Vector;
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

uniform sampler2D normal2Texture;
subroutine(srtNormal) vec3 normal2Map(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalize(texture(normal2Texture, uv).rgb * 2.0 - 1.0);
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal2;

uniform vec3 normal3Vector;
subroutine(srtNormal) vec3 normal3Value(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normal3Vector;
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

uniform sampler2D normal3Texture;
subroutine(srtNormal) vec3 normal3Map(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalize(texture(normal3Texture, uv).rgb * 2.0 - 1.0);
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal3;

uniform vec3 normal4Vector;
subroutine(srtNormal) vec3 normal4Value(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normal4Vector;
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

uniform sampler2D normal4Texture;
subroutine(srtNormal) vec3 normal4Map(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    vec3 tN = normalize(texture(normal4Texture, uv).rgb * 2.0 - 1.0);
    tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal4;


uniform vec4 rms1;
uniform vec4 rms2;
uniform vec4 rms3;
uniform vec4 rms4;


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
    //vec3 tE = normalize(E * tangentToEye);

    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;

    vec2 shiftedTexCoord = texCoord; //parallax(tE, texCoord, height(texCoord));
    
    vec4 splat = texture(splatmap, splatTexCoord);

    vec3 N1 = normal1(shiftedTexCoord * textureScale1, -1.0, tangentToEye);
    vec3 N2 = normal2(shiftedTexCoord * textureScale2, -1.0, tangentToEye);
    vec3 N3 = normal3(shiftedTexCoord * textureScale3, -1.0, tangentToEye);
    vec3 N4 = normal4(shiftedTexCoord * textureScale4, -1.0, tangentToEye);

    N = mix(N, N1, splat.r);
    N = mix(N, N2, splat.g);
    N = mix(N, N3, splat.b);
    N = mix(N, N4, splat.a);

    vec4 diffuseColor1 = diffuse1(shiftedTexCoord * textureScale1);
    vec4 diffuseColor2 = diffuse2(shiftedTexCoord * textureScale2);
    vec4 diffuseColor3 = diffuse3(shiftedTexCoord * textureScale3);
    vec4 diffuseColor4 = diffuse4(shiftedTexCoord * textureScale4);
    
    vec3 diffuseColor = vec3(0.0, 0.0, 0.0);
    diffuseColor = mix(diffuseColor, diffuseColor1.rgb, splat.r);
    diffuseColor = mix(diffuseColor, diffuseColor2.rgb, splat.g);
    diffuseColor = mix(diffuseColor, diffuseColor3.rgb, splat.b);
    diffuseColor = mix(diffuseColor, diffuseColor4.rgb, splat.a);
    
    vec4 rms = vec4(1.0, 0.0, 1.0, 1.0);
    rms = mix(rms, rms1, splat.r);
    rms = mix(rms, rms2, splat.g);
    rms = mix(rms, rms3, splat.b);
    rms = mix(rms, rms4, splat.a);

    // This is written to frag_color.w and frag_position.w
    // and determines that the fragment belongs to foreground object
    float geometryMask = float(layer > 0);

    frag_color = vec4(diffuseColor, geometryMask);
    frag_rms = vec4(rms.r, rms.g, 1.0, 1.0);
    frag_position = vec4(eyePosition, geometryMask);
    frag_normal = vec4(N, 1.0);
    frag_velocity = vec4(screenVelocity, 0.0, blurMask);
    frag_emission = vec4(0.0, 0.0, 0.0, 1.0);
}
