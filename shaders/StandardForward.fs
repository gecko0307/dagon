#version 400 core

#define EPSILON 0.000001
#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec3 eyePosition;
in vec3 eyeNormal;
in vec2 texCoord;
in vec3 worldPosition;
in vec3 worldView;

in vec4 shadowCoord1;
in vec4 shadowCoord2;
in vec4 shadowCoord3;

in vec4 blurPosition;
in vec4 prevPosition;

uniform float blurMask;

uniform mat4 viewMatrix;

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
        
        
/*
 * Shadow subroutines.
 */
subroutine float srtShadow();

uniform sampler2DArrayShadow shadowTextureArray;
uniform float shadowTextureSize;

float shadowLookup(in float layer, in vec4 coord, in vec2 offset)
{
    float texelSize = 1.0 / shadowTextureSize;
    vec2 v = offset * texelSize * coord.w;
    vec4 c = (coord + vec4(v.x, v.y, 0.0, 0.0)) / coord.w;
    c.w = c.z;
    c.z = layer;
    float s = texture(shadowTextureArray, c);
    return s;
}

float shadowUnfiltered(in float layer, in vec4 coord, in float yshift)
{
    return shadowLookup(layer, coord, vec2(0.0, yshift));
}

float shadowPCF(in float layer, in vec4 coord, in float radius, in float yshift)
{
    float s = 0.0;
    float x, y;
	for (y = -radius ; y < radius ; y += 1.0)
	for (x = -radius ; x < radius ; x += 1.0)
    {
	    s += shadowLookup(layer, coord, vec2(x, y + yshift));
    }
	s /= radius * radius * 4.0;
    return s;
}

float cascadeWeight(in vec4 tc, in float coef)
{
    vec2 proj = vec2(tc.x / tc.w, tc.y / tc.w);
    proj = (1.0 - abs(proj * 2.0 - 1.0)) * coef;
    proj = clamp(proj, 0.0, 1.0);
    return min(proj.x, proj.y);
}

subroutine(srtShadow) float shadowCSM()
{
    float s1, s2, s3;

    vec4 scoord1 = shadowCoord1;
    vec4 scoord2 = shadowCoord2;
    vec4 scoord3 = shadowCoord3;

    s1 = shadowPCF(0.0, scoord1, 2.0, 0.0); 
    s2 = shadowUnfiltered(1.0, scoord2, 0.0);
    s3 = shadowUnfiltered(2.0, scoord3, 0.0);

    float w1 = cascadeWeight(scoord1, 8.0);
    float w2 = cascadeWeight(scoord2, 8.0);
    float w3 = cascadeWeight(scoord3, 8.0);

    s3 = mix(1.0, s3, w3); 
    s2 = mix(s3, s2, w2);
    s1 = mix(s2, s1, w1);

    return s1;
}

subroutine(srtShadow) float shadowNone()
{
    return 1.0;
}

subroutine uniform srtShadow shadow;


/*
 * BRDF subroutines.
 * Implement different shading models. Currently only PBR (Cook-Torrance + IBL) and emission BRDFs are supported.
 */
subroutine vec3 srtBRDF(in vec3 albedo, in float roughness, in float metallic, in vec3 N);

vec3 fresnel(float cosTheta, vec3 f0)
{
    return f0 + (1.0 - f0) * pow(1.0 - cosTheta, 5.0);
}

vec3 fresnelRoughness(in float cosTheta, in vec3 f0, in float roughness)
{
    return f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(1.0 - cosTheta, 5.0);
}

float distributionGGX(in vec3 N, in vec3 H, in float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NH = max(dot(N, H), 0.0);
    float NH2 = NH * NH;
    float num = a2;
    float denom = max(NH2 * (a2 - 1.0) + 1.0, 0.001);
    denom = PI * denom * denom;
    return num / denom;
}

float geometrySchlickGGX(in float NE, in float roughness)
{
    float r = roughness + 1.0;
    float k = (r * r) / 8.0;
    float num = NE;
    float denom = NE * (1.0 - k) + k;
    return num / denom;
}

float geometrySmith(in vec3 N, in vec3 E, in vec3 L, in float roughness)
{
    float NE = max(dot(N, E), 0.0);
    float NL = max(dot(N, L), 0.0);
    float ggx2 = geometrySchlickGGX(NE, roughness);
    float ggx1 = geometrySchlickGGX(NL, roughness);
    return ggx1 * ggx2;
}

uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
subroutine(srtBRDF) vec3 brdfPBR(in vec3 albedo, in float roughness, in float metallic, in vec3 N)
{
    vec3 Lo = vec3(0.0);

    //vec3 N = normalize(eyeNormal);
    vec3 E = normalize(-eyePosition);

    vec3 worldN = N * mat3(viewMatrix);
    vec3 worldR = reflect(normalize(worldView), worldN);
    vec3 worldSun = sunDirection * mat3(viewMatrix); // TODO: move to vertex shader

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);
            
    // Environment light
    {
        vec3 envDiffuse = environment(worldN, worldSun, 0.9);
        vec3 envSpecular = environment(worldR, worldSun, roughness);
        
        float NE = max(dot(N, E), 0.0);
        vec3 F = fresnelRoughness(NE, f0, roughness);
        vec3 kS = F;
        vec3 kD = 1.0 - kS;
        kD *= 1.0 - metallic;
    
        Lo += kD * envDiffuse * albedo + F * envSpecular;
    }

    // Sun light
    {
        vec3 L = sunDirection;
        float NL = max(dot(N, L), 0.0);
        vec3 H = normalize(E + L);

        float NDF = distributionGGX(N, H, roughness);        
        float G = geometrySmith(N, E, L, roughness);
        vec3 F = fresnel(max(dot(H, E), 0.0), f0);

        vec3 kS = F;
        vec3 kD = vec3(1.0) - kS;
        kD *= 1.0 - metallic;
        vec3 numerator = NDF * G * F;
        float denominator = 4.0 * max(dot(N, E), 0.0) * NL;
        vec3 specular = numerator / max(denominator, 0.001);
        
        vec3 radiance = toLinear(sunColor.rgb) * sunEnergy * shadow() * NL;
        Lo += (kD * albedo / PI + specular) * radiance; 
    }

    return Lo;
}

subroutine(srtBRDF) vec3 brdfEmission(in vec3 albedo, in float roughness, in float metallic, in vec3 N)
{
    return albedo;
}

subroutine uniform srtBRDF brdf;


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


float luminance(in vec3 col)
{
    return (
        col.x * 0.27 +
        col.y * 0.67 +
        col.z * 0.06
    );
}

uniform sampler2D pbrTexture;

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luminance;
layout(location = 2) out vec4 frag_velocity;

void main()
{
    vec3 N = normalize(eyeNormal);
    vec3 E = normalize(-eyePosition);

    mat3 tangentToEye = cotangentFrame(N, eyePosition, texCoord);
    N = normal(texCoord, -1.0, tangentToEye);
    vec3 tE = normalize(E * tangentToEye);
    
    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;

    vec4 diff = diffuse(texCoord);
    
    vec3 albedo = toLinear(diff.rgb);
    vec4 rms = texture(pbrTexture, texCoord);
    vec3 emiss = emission(texCoord).rgb * emissionEnergy;

    vec3 Lo = brdf(albedo, rms.r, rms.g, N) + emiss;

    frag_color = vec4(Lo, diff.a);
    frag_luminance = vec4(luminance(Lo) * diff.a, 0.0, 0.0, 1.0);
    frag_velocity = vec4(screenVelocity, 0.0, blurMask);
}
