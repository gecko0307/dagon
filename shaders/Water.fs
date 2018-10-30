#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec3 eyePosition;
in vec3 eyeNormal;
in vec2 texCoord;
in vec4 blurPosition;
in vec4 prevPosition;
in vec3 worldView;

uniform vec2 viewSize;
uniform sampler2D positionTexture;

uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;

uniform vec3 sunDirection;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

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
    return textureLod(envTexture, envMapEquirect(wN), lod).rgb;
}

subroutine uniform srtEnv environment;

uniform sampler2D rippleTexture;
uniform vec4 rippleTimes;
const float textureScale = 4.0;
const float rainIntensity = 2.0;

vec3 computeRipple(vec2 uv, float currentTime, float weight)
{
    vec4 ripple = texture(rippleTexture, uv);
    ripple.yz = ripple.yz * 2.0 - 1.0;
    float dropFrac = fract(ripple.w + currentTime);
    float timeFrac = dropFrac - 1.0 + ripple.x;
    float dropFactor = clamp(0.2 + weight * 0.8 - dropFrac, 0.0, 1.0);
    float finalFactor = dropFactor * ripple.x * sin(clamp(timeFrac * 9.0, 0.0, 3.0) * PI);
    return vec3(ripple.yz * finalFactor * 0.35, 1.0);
}

float luminance(vec3 color)
{
    return (
        color.x * 0.2126 +
        color.y * 0.7152 +
        color.z * 0.0722
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luma;
layout(location = 2) out vec4 frag_velocity;

void main()
{
    vec3 N = normalize(eyeNormal);
    vec3 E = normalize(-eyePosition);
    
    vec2 posScreen = (blurPosition.xy / blurPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 screenVelocity = posScreen - prevPosScreen;
    
    vec3 worldPosition = (invViewMatrix * vec4(eyePosition, 1.0)).xyz;
    vec4 pos = texture(positionTexture, gl_FragCoord.xy / viewSize);
    vec3 referenceEyePos = (invViewMatrix * pos).xyz;
    
    vec2 uv = texCoord * textureScale;
    vec4 weights = rainIntensity - vec4(0, 0.25, 0.5, 0.75);
    weights = clamp(weights * 4.0, 0.0, 1.0);
    
    vec3 ripple1 = computeRipple(uv + vec2( 0.25, 0.0), rippleTimes.x, weights.x);
    vec3 ripple2 = computeRipple(uv + vec2(-0.55, 0.3), rippleTimes.y, weights.y);
    vec3 ripple3 = computeRipple(uv + vec2( 0.6, 0.85), rippleTimes.z, weights.z);
    vec3 ripple4 = computeRipple(uv + vec2( 0.5,-0.75), rippleTimes.w, weights.w);
    
    vec4 Z = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(ripple1.z, ripple2.z, ripple3.z, ripple4.z), weights);
    vec3 n = vec3(
        weights.x * ripple1.xy +
        weights.y * ripple2.xy + 
        weights.z * ripple3.xy + 
        weights.w * ripple4.xy, 
        Z.x * Z.y * Z.z * Z.w);                             
    n = normalize(n);

    vec3 worldN = n.xzy;
    vec3 worldR = reflect(normalize(worldView), worldN);
    //worldR = normalize(vec3(-worldR.x, worldR.y, -worldR.z));
    vec3 worldSun = sunDirection * mat3(viewMatrix);
    
    // TODO: make uniforms
    vec3 waterColor = vec3(0.1, 0.1, 0.0);
    float waterAlpha = 0.95;
    
    vec3 reflection = environment(worldR, worldSun, 0.0);
    
    const float softDistance = 0.5;
    float soft = ((pos.w > 0.0)? clamp((worldPosition.y - referenceEyePos.y) / softDistance, 0.0, 1.0) : 1.0);
    
    const float fresnelPower = 3.0;
    const float f0 = 0.03;
    float fresnel = f0 + pow(1.0 - dot(N, E), fresnelPower);
    
    float light = max(dot(N, sunDirection), 0.0);
    
    vec3 col = mix(waterColor * light, reflection, fresnel);
    float alpha = soft * mix(waterAlpha, 1.0, fresnel);
    frag_color = vec4(col, alpha);
    frag_luma = vec4(luminance(col) * alpha);
    frag_velocity = vec4(screenVelocity, 0.0, 1.0);
}
