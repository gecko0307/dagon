#version 400 core
const float PI = 3.14159265359;

uniform sampler2D baseColorTexture;
uniform sampler2D roughnessMetallicTexture;
uniform sampler2D emissionTexture;
uniform sampler2D normalTexture;
uniform bool hasBaseColorTexture;
uniform bool hasRoughnessMetallicTexture;
uniform bool hasEmissionTexture;
uniform bool hasNormalTexture;
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

float distributionGGX(vec3 N, vec3 H, float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;
    float denominator = max(NdotH2 * (a2 - 1.0) + 1.0, 0.00001);
    return a2 / (PI * denominator * denominator);
}

float geometrySchlickGGX(float NdotV, float k)
{
    return NdotV / (NdotV * (1.0 - k) + k);
}

float geometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float r = roughness + 1.0;
    float k = (r * r) / 8.0;
    return geometrySchlickGGX(max(dot(N, V), 0.0), k) *
        geometrySchlickGGX(max(dot(N, L), 0.0), k);
}

vec3 fresnelRoughness(float cosTheta, vec3 F0, float roughness)
{
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) *
        pow(1.0 - cosTheta, 5.0);
}

mat3 cotangentFrame(vec3 N, vec3 position, vec2 uv)
{
    vec3 dp1 = dFdx(position);
    vec3 dp2 = dFdy(position);
    vec2 duv1 = dFdx(uv);
    vec2 duv2 = dFdy(uv);
    vec3 dp2perp = cross(dp2, N);
    vec3 dp1perp = cross(N, dp1);
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
    float invmax = inversesqrt(max(max(dot(T, T), dot(B, B)), 0.00000001));
    return mat3(T * invmax, B * invmax, N);
}

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
        : pow(max(baseColor.rgb, vec3(0.0)), vec3(2.2));

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
    vec3 incomingLight = pow(max(lightColor, vec3(0.0)), vec3(2.2)) *
        lightEnergy;
    vec3 radiance = (diffuse + specular) * incomingLight * NdotL;

    vec3 emission = pow(max(emissionFactor.rgb, vec3(0.0)), vec3(2.2));
    if (hasEmissionTexture)
        emission *= pow(max(texture(emissionTexture, uv).rgb, vec3(0.0)),
            vec3(2.2));
    radiance += emission * emissionEnergy;

    if (baseColor.a * opacity < alphaTestThreshold)
        discard;
    fragmentColor = vec4(toneMapACES(radiance), 1.0);
}
