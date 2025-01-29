#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

uniform vec4 debugHighlightColor;
uniform float debugHighlightCoef;

uniform float opacity;
uniform bool shaded;
uniform vec3 sunDirection;
uniform vec4 sunColor;
uniform float sunEnergy;
uniform float gloss;

#include <gamma.glsl>

uniform vec4 ambientColor;
uniform float ambientEnergy;

uniform float alphaTestThreshold;

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
        
        float diffuseEnergy = NL * sunEnergy;
        float specularEnergy = pow(NH, 128.0 * gloss) * gloss * sunEnergy;
        
        vec3 lightColor = toLinear(sunColor.rgb);
        
        outputColor =
            diffuseColor * (ambientColor.rgb * ambientEnergy + lightColor * diffuseEnergy) +
            lightColor * specularEnergy;
    }
    
    fragColor = vec4(mix(outputColor, debugHighlightColor.rgb, debugHighlightCoef), outputAlpha);
}
