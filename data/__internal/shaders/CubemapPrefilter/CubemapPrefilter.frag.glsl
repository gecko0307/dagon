#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

in vec2 texCoord;

uniform vec2 resolution;
uniform int cubemapFaceIndex;
uniform float roughness;
uniform float inputMipLevel;
uniform samplerCube envmap;
uniform float inputScale = 2.0;
uniform float inputThreshold = 10.0;

const uint numSamples = 1024u;

vec3 importanceSampleGGX(vec2 Xi, float roughness, vec3 N)
{
    float a = roughness * roughness;
    float phi = PI2 * Xi.x;
    float cosTheta = sqrt((1.0 - Xi.y) / (1.0 + (a * a - 1.0) * Xi.y));
    float sinTheta = sqrt(1.0 - cosTheta * cosTheta);
    
    vec3 H;
    H.x = sinTheta * cos(phi);
    H.y = sinTheta * sin(phi);
    H.z = cosTheta;
    
    vec3 upVector = abs(N.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
    vec3 tangentX = normalize(cross(upVector, N));
    vec3 tangentY = cross(N, tangentX);
    
    // Tangent to world space
    return tangentX * H.x + tangentY * H.y + N * H.z;
}

// Generates the i-th 2D Hammersley point out of N
vec2 hammersley(uint i, uint N) 
{
    // Radical inverse based on http://holger.dammertz.org/stuff/notes_HammersleyOnHemisphere.html
    uint bits = (i << 16u) | (i >> 16u);
    bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
    bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
    bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
    bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
    float rdi = float(bits) * 2.3283064365386963e-10;
    return vec2(float(i) / float(N), rdi);
}

vec3 prefilterEnvMap(float roughness, vec3 R)
{
    vec3 N = R;
    vec3 V = R;
    vec3 result = vec3(0.0, 0.0, 0.0);
    float totalWeight = 0.0;
    
    for (uint i = 0u; i < numSamples; i++)
    {
        vec2 Xi = hammersley(i, numSamples);
        vec3 H = importanceSampleGGX(Xi, roughness, N);
        vec3 L = 2.0 * dot(V, H) * H - V;
        float NL = clamp(dot(N, L), 0.0, 1.0);
        if (NL > 0.0)
        {
            vec3 inputColor = clamp(textureLod(envmap, L, inputMipLevel).rgb, vec3(0.0), vec3(inputThreshold)) * inputScale;
            result += inputColor * NL;
            totalWeight += NL;
        }
    }
    
    if (totalWeight == 0.0)
        return result;
    else
        return result / totalWeight;
}

vec3 getDirectionForCubemapFace(int faceIndex, vec2 uv)
{
    uv = uv * 2.0 - 1.0;
    vec3 dir;
    if (faceIndex == 0)      dir = normalize(vec3(1.0,   -uv.y, -uv.x)); // +X
    else if (faceIndex == 1) dir = normalize(vec3(-1.0,  -uv.y,  uv.x)); // -X
    else if (faceIndex == 2) dir = normalize(vec3(uv.x,   1.0,   uv.y)); // +Y
    else if (faceIndex == 3) dir = normalize(vec3(uv.x,  -1.0,  -uv.y)); // -Y
    else if (faceIndex == 4) dir = normalize(vec3(uv.x,  -uv.y,  1.0));  // +Z
    else if (faceIndex == 5) dir = normalize(vec3(-uv.x, -uv.y, -1.0));  // -Z
    return dir;
}

layout(location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    vec3 R = getDirectionForCubemapFace(cubemapFaceIndex, uv);
    vec3 result;
    if (roughness > 0.0)
        result = prefilterEnvMap(roughness, R);
    else
        result = clamp(textureLod(envmap, R, inputMipLevel).rgb, vec3(0.0), vec3(inputThreshold)) * inputScale;
    fragColor = vec4(result, 1.0);
}
