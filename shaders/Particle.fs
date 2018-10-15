#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec3 eyePosition;
in vec2 texCoord;
in vec3 worldPosition;
in vec3 worldView;

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

subroutine(srtNormal) vec3 normalFunctionHemisphere(in vec2 uv, in float ysign, in mat3 tangentToEye)
{
    // Generate spherical tangent-space normal
    vec2 p = uv * 2.0 - 1.0; //vec2(uv.x * 2.0 - 1.0, uv.y * 2.0 - 1.0);
    if (dot(p, p) >= 1.0)
        p = normalize(p) * 0.999; // small bias to fight aliasing
    float vz = sqrt(1.0 - p.x * p.x - p.y * p.y);
    vec3 tN = vec3(p.x, p.y, vz);
    //tN.y *= ysign;
    return normalize(tangentToEye * tN);
}

subroutine uniform srtNormal normal;


/*
 * Environment subroutines.
 * Used to switch sky/envmap.
 */
subroutine vec3 srtEnv(in vec3 wN, in vec3 wSun, in float roughness);

uniform vec4 skyZenithColor;
uniform vec4 skyHorizonColor;
uniform vec4 groundColor;
uniform float skyEnergy;
uniform float groundEnergy;
subroutine(srtEnv) vec3 environmentSky(in vec3 wN, in vec3 wSun, in float roughness)
{
    float p1 = clamp(roughness, 0.5, 1.0);
    float p2 = clamp(roughness, 0.4, 1.0);

    float horizonOrZenith = pow(clamp(dot(wN, vec3(0, 1, 0)), 0.0, 1.0), p1);
    float groundOrSky = pow(clamp(dot(wN, vec3(0, -1, 0)), 0.0, 1.0), p2);

    vec3 env = mix(
        mix(toLinear(skyHorizonColor.rgb) * skyEnergy, 
            toLinear(groundColor.rgb) * groundEnergy, groundOrSky), 
            toLinear(skyZenithColor.rgb) * skyEnergy, horizonOrZenith);
            
    return env;
}

vec2 envMapEquirect(in vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / PI2, phi / PI);
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec3 environmentTexture(in vec3 wN, in vec3 wSun, in float roughness)
{
    ivec2 envMapSize = textureSize(envTexture, 0);
    float maxLod = log2(float(max(envMapSize.x, envMapSize.y)));
    float lod = maxLod * roughness;
    //float lod = roughness * 16.0;
    return textureLod(envTexture, envMapEquirect(wN), lod).rgb;
}

subroutine uniform srtEnv environment;


uniform vec2 viewSize;
uniform sampler2D positionTexture;

uniform mat4 viewMatrix;

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;

uniform bool shaded;
uniform vec4 particleColor;
uniform float energy;
uniform float alpha;
uniform bool alphaCutout;
uniform float alphaCutoutThreshold;
uniform vec3 particlePosition;

float luminance(vec3 color)
{
    return (
        color.x * 0.2126 +
        color.y * 0.7152 +
        color.z * 0.0722
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luminance;
layout(location = 2) out vec4 frag_velocity;

void main()
{
    vec4 pos = texture(positionTexture, gl_FragCoord.xy / viewSize);
    vec3 referenceEyePos = pos.xyz;
    vec3 E = normalize(-eyePosition);
            
    vec3 N = normalize(-particlePosition);
    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    N = normal(texCoord, -1.0, tangentToEye);

    vec3 worldN = N * mat3(viewMatrix);
    vec3 worldSun = sunDirection * mat3(viewMatrix);
    
    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
            
    // TODO: make uniform
    const float wrapFactor = 0.5f;
            
    vec3 ambient = environment(worldN, worldSun, 0.9);
            
    vec3 radiance = shaded? 
        ambient + toLinear(sunColor.rgb) * max(dot(N, sunDirection) + wrapFactor, 0.0) / (1.0 + wrapFactor) * sunEnergy :
        vec3(1.0);
    
    // TODO: make uniform
    const float softDistance = 3.0;
    float soft = alphaCutout?
        1.0 :
        ((pos.w > 0.0)? clamp((eyePosition.z - referenceEyePos.z) / softDistance, 0.0, 1.0) : 1.0);
        
    vec4 diff = diffuse(texCoord);
    vec3 outColor = toLinear(diff.rgb) * toLinear(particleColor.rgb);
    float outAlpha = diff.a * particleColor.a * alpha * soft;
            
    if (alphaCutout && outAlpha <= alphaCutoutThreshold)
        discard;
            
    frag_color = vec4(outColor * (radiance + energy), outAlpha);
    frag_luminance = vec4(luminance(frag_color.rgb) * outAlpha, 0.0, 0.0, 1.0);
    frag_velocity = vec4(screenVelocity, 0.0, outAlpha);
}
