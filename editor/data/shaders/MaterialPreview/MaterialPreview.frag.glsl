#version 400 core
const float PI = 3.14159265359;

#include <gamma.glsl>
#include <fresnel.glsl>
#include <ggx.glsl>
#include <cotangentFrame.glsl>

uniform sampler2D baseColorTexture;
uniform sampler2D roughnessMetallicTexture;
uniform sampler2D emissionTexture;
uniform sampler2D normalTexture;

uniform bool hasBaseColorTexture;
uniform bool hasRoughnessMetallicTexture;
uniform bool hasEmissionTexture;
uniform bool hasNormalTexture;
uniform bool transparent;

uniform bool linearColor;
uniform mat3 textureTransformation;
uniform vec4 baseColorFactor;
uniform vec4 emissionFactor;
uniform vec3 normalFactor;
uniform float roughnessFactor;
uniform float metallicFactor;
uniform float emissionEnergy;
uniform float opacity;
uniform float alphaTestThreshold;
uniform float normalYSign;

uniform vec3 lightDirection;
uniform vec3 lightColor;
uniform float lightEnergy;
uniform float lightAngularRadius;

in vec3 eyePosition;
in vec3 eyeNormal;
in vec2 texcoord;
out vec4 fragmentColor;

vec3 toneMapACES(vec3 color)
{
    return clamp((color * (2.51 * color + 0.03)) /
        (color * (2.43 * color + 0.59) + 0.14), 0.0, 1.0);
}

void main()
{
    vec2 uv = (textureTransformation * vec3(texcoord, 1.0)).xy;
    vec4 baseColor = hasBaseColorTexture
        ? texture(baseColorTexture, uv)
        : baseColorFactor;
    vec3 albedo = linearColor
        ? baseColor.rgb
        : toLinear(max(baseColor.rgb, vec3(0.0)));

    float roughness = roughnessFactor;
    float metallic = metallicFactor;
    if (hasRoughnessMetallicTexture)
    {
        vec3 roughnessMetallic = texture(roughnessMetallicTexture, uv).rgb;
        roughness = roughnessMetallic.g;
        metallic = roughnessMetallic.b;
    }
    roughness = max(roughness, lightAngularRadius);

    vec3 N = normalize(eyeNormal);
    vec3 tangentNormal = normalFactor;
    if (hasNormalTexture)
        tangentNormal = texture(normalTexture, uv).rgb * 2.0 - 1.0;
    tangentNormal.y *= normalYSign;
    N = normalize(cotangentFrame(N, eyePosition, uv) * tangentNormal);
    vec3 V = normalize(-eyePosition);
    vec3 L = normalize(lightDirection);
    float NdotL = max(dot(N, L), 0.0);
    float NdotV = max(dot(N, V), 0.0);
    vec3 H = normalize(V + L);

    vec3 F0 = mix(vec3(0.04), albedo, metallic);
    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, V, L, roughness);
    vec3 F = fresnelRoughness(max(dot(H, V), 0.0), F0, roughness);
    vec3 specular = (NDF * G * F) /
        max(4.0 * NdotV * NdotL, 0.00001);
    vec3 diffuse = (1.0 - F) * albedo * (1.0 - metallic) / PI;
    vec3 incomingLight = toLinear(max(lightColor, vec3(0.0))) * lightEnergy;
    vec3 radiance = (diffuse + specular) * incomingLight * NdotL;

    vec3 emission = toLinear(max(emissionFactor.rgb, vec3(0.0)));
    if (hasEmissionTexture)
        emission *= toLinear(max(texture(emissionTexture, uv).rgb, vec3(0.0)));
    radiance += emission * emissionEnergy;

    if (baseColor.a * opacity < alphaTestThreshold)
        discard;
    float alpha = transparent ? clamp(baseColor.a * opacity, 0.0, 1.0) : 1.0;
    fragmentColor = vec4(toneMapACES(radiance), alpha);
}
