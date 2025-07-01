#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec3 worldPosition;
in vec2 texCoord;

uniform vec4 debugHighlightColor;
uniform float debugHighlightCoef;

uniform float opacity;
uniform bool shaded;
uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform float gloss;
uniform vec4 ambientColor;
uniform float ambientEnergy;
uniform float alphaTestThreshold;
uniform int textureMappingMode;
uniform bool shadowEnabled;
uniform float shadowMinRadius;
uniform float shadowMaxRadius;
uniform float shadowOpacity;
uniform vec3 shadowCenter;
uniform bool celShading;
uniform bool rimLight;

#include <gamma.glsl>
#include <matcap.glsl>

/*
 * Diffuse
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

layout(location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    
    if (textureMappingMode == 1)
        uv = matcap(E, N);
    
    vec3 L = sunDirection;
    
    vec4 color = diffuse(uv);
    vec3 diffuseColor = toLinear(color.rgb);
    
    vec3 outputColor = diffuseColor;
    float outputAlpha = color.a * opacity;
    
    if (outputAlpha < alphaTestThreshold)
        discard;
    
    // Sun light
    if (shaded)
    {
        float NL = max(dot(N, L), 0.0);
        vec3 H = normalize(E + L);
        float NH = max(dot(N, H), 0.0);
        
        float diffuseEnergy = NL;
        float specularEnergy = pow(NH, 128.0 * gloss) * gloss;
        
        if (celShading)
        {
            diffuseEnergy = diffuseEnergy > 0.001? 1.0 : 0.0;
            specularEnergy = specularEnergy > 0.2? 1.0 : 0.0;
            if (rimLight)
            {
                float rim = (1.0 - dot(E, N)) * NL;
                specularEnergy += rim > 0.6? 1.0 : 0.0;
            }
        }
        
        vec3 lightColor = toLinear(sunColor.rgb);
        
        outputColor =
            diffuseColor * (ambientColor.rgb * ambientEnergy + lightColor * diffuseEnergy * sunEnergy) +
            lightColor * specularEnergy * sunEnergy;
    }
    
    // Shadow
    if (shadowEnabled)
    {
        float shadow = clamp((distance(worldPosition.xz, shadowCenter.xz) - shadowMinRadius) / (shadowMaxRadius - shadowMinRadius), 0.0, 1.0);
        outputColor *= mix(1.0 - shadowOpacity, 1.0, shadow);
    }
    
    fragColor = vec4(mix(outputColor, debugHighlightColor.rgb, debugHighlightCoef), outputAlpha);
}
