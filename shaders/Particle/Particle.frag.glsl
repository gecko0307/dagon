#version 400 core

in vec3 eyePosition;
in vec2 texCoord;

in vec3 worldPosition;
in vec3 worldView;

in vec4 currPosition;
in vec4 prevPosition;

uniform mat4 invProjectionMatrix;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

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


uniform vec2 viewSize;
uniform sampler2D depthTexture;

uniform vec4 particleColor;
uniform float particleAlpha;
uniform bool alphaCutout;
uniform float alphaCutoutThreshold;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragVelocity;

void main()
{
    vec2 screenTexcoord = gl_FragCoord.xy / viewSize;
    float depth = texture(depthTexture, screenTexcoord).x;
    vec3 referenceEyePos = unproject(vec3(screenTexcoord, depth));
    
    // TODO: make uniform
    const float softDistance = 3.0;
    float soft = alphaCutout? 1.0 : clamp((eyePosition.z - referenceEyePos.z) / softDistance, 0.0, 1.0);
        
    vec4 diff = diffuse(texCoord);
    vec3 outColor = toLinear(diff.rgb) * toLinear(particleColor.rgb);
    float outAlpha = diff.a * particleColor.a * particleAlpha * soft;
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    outColor = mix(toLinear(fogColor.rgb), outColor, fogFactor);
    
    fragColor = vec4(outColor, outAlpha);
    fragVelocity = vec4(0.0, 0.0, 0.0, 1.0);
}
