#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec3 worldPosition;
in vec2 texCoord;

uniform vec4 debugHighlightColor;
uniform float debugHighlightCoef;

uniform float opacity;
uniform bool shaded;
uniform float energy;
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

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

struct Light
{
    vec4 position;
    vec4 direction;
    vec4 color;
    
    // x = type, y = volumeRadius, z = spotOuterCutoff, w = spotInnerCutoff
    vec4 geometryParams;
    
    // x = energy, y = diffuseCoef, z = specularCoef, w = reserved (should be zero)
    vec4 energyParams;
};

#define MAX_FIXED_LIGHTS 8

layout(std140) uniform Lights
{
    Light lights[MAX_FIXED_LIGHTS];
};

uniform int numFixedLights;

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

/*
 * Emission
 */
subroutine vec3 srtEmission(in vec2 uv);

uniform vec4 emissionFactor;
subroutine(srtEmission) vec3 emissionValue(in vec2 uv)
{
    return emissionFactor.rgb * energy;
}

uniform sampler2D emissionTexture;
subroutine(srtEmission) vec3 emissionMap(in vec2 uv)
{
    return texture(emissionTexture, uv).rgb * emissionFactor.rgb * energy;
}

subroutine uniform srtEmission emission;

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
    
    if (shaded)
    {
        // Sun light
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
        
        // Fixed lights (maximum 8 lights per pass)
        if (!celShading)
        {
            for (int i = 0; i < numFixedLights; i++)
            {
                vec3 lightPosition = lights[i].position.xyz;
                vec3 lightDirection = lights[i].direction.xyz;
                lightColor = toLinear(lights[i].color.rgb);
                float lightType = lights[i].geometryParams.x;
                float lightVolumeRadius = lights[i].geometryParams.y;
                float lightSpotOuterCutoff = lights[i].geometryParams.z;
                float lightSpotInnerCutoff = lights[i].geometryParams.w;
                float lightEnergy = lights[i].energyParams.x;
                float lightDiffuseCoef = lights[i].energyParams.y;
                float lightSpecularCoef = lights[i].energyParams.z;
                
                float attenuation = 0.0;
                
                vec3 positionToLight = lightPosition - eyePosition;
                float distanceToLight = length(positionToLight);
                
                if (lightType == 0.0)
                {
                    // Point light
                    L = normalize(positionToLight);
                    attenuation = pow(clamp(1.0 - (distanceToLight / max(lightVolumeRadius, 0.001)), 0.0, 1.0), 4.0) * lightEnergy;
                }
                else if (lightType == 1.0)
                {
                    // Spot light
                    L = normalize(positionToLight);
                    attenuation = pow(clamp(1.0 - (distanceToLight / max(lightVolumeRadius, 0.001)), 0.0, 1.0), 2.0) * lightEnergy;
                    float spotCos = clamp(dot(L, normalize(lightDirection)), 0.0, 1.0);
                    float spotValue = smoothstep(lightSpotOuterCutoff, lightSpotInnerCutoff, spotCos);
                    attenuation *= spotValue;
                }
                else if (lightType == 2.0)
                {
                    // Sun light
                    L = lightDirection;
                    attenuation = lightEnergy;
                }
                
                NL = max(dot(N, L), 0.0);
                H = normalize(E + L);
                NH = max(dot(N, H), 0.0);
                
                diffuseEnergy = NL;
                specularEnergy = pow(NH, 128.0 * gloss) * gloss;
                
                outputColor +=
                    (diffuseColor * lightColor * diffuseEnergy * lightDiffuseCoef +
                     lightColor * specularEnergy * lightSpecularCoef) * attenuation;
            }
        }
    }
    
    // Shadow
    if (shadowEnabled)
    {
        // TODO: multiple shadows
        float shadow = clamp((distance(worldPosition, shadowCenter) - shadowMinRadius) / (shadowMaxRadius - shadowMinRadius), 0.0, 1.0);
        outputColor *= mix(1.0 - shadowOpacity, 1.0, shadow);
    }
    
    // Fog
    float linearDepth = abs(eyePosition.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    outputColor = mix(toLinear(fogColor.rgb), outputColor, fogFactor);
    
    outputColor += toLinear(emission(uv));
    
    fragColor = vec4(mix(outputColor, debugHighlightColor.rgb, debugHighlightCoef), outputAlpha);
}
