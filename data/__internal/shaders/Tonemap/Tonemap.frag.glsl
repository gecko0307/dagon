#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;

uniform int tonemapper;
uniform float exposure;

in vec2 texCoord;
out vec4 fragColor;

/*
 * tonemapHable is based on a function by John Hable
 * http://filmicworlds.com/blog/filmic-tonemapping-operators
 *
 * tonemapACES is based on a function by Krzysztof Narkowicz
 * https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve
 *
 * tonemapFilmic is based on a function by Jim Hejl and Richard Burgess-Dawson
 * http://filmicworlds.com/blog/filmic-tonemapping-operators
 *
 * tonemapAgX is based on code by Don McCurdy, which in turn is based on Blender and Filament implementations
 * https://github.com/mrdoob/three.js/pull/27618
 */

vec3 hableFunc(vec3 x)
{
    const float A = 0.15;
    const float B = 0.50;
    const float C = 0.10;
    const float D = 0.20;
    const float E = 0.02;
    const float F = 0.30;
    const float W = 11.2;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 tonemapHable(vec3 color)
{
    const float W = 11.2;
    const float exposureBias = 2.0;
    vec3 curr = hableFunc(exposureBias * color);
    vec3 whiteScale = vec3(1.0) / hableFunc(vec3(W));
    return curr * whiteScale;
}

vec3 tonemapReinhard(vec3 color)
{
    return color / (color + vec3(1.0));
}

vec3 tonemapACES(vec3 x)
{
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), 0.0, 1.0);
}

vec3 tonemapFilmic(vec3 color)
{
    vec3 x = max(vec3(0.0), color - 0.004);
    vec3 result = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
    return pow(result, vec3(2.2));
}

vec3 tonemapReinhard2(vec3 color)
{
    const float L_white = 4.0;
    return (color * (vec3(1.0) + color / (L_white * L_white))) / (vec3(1.0) + color);
}

vec3 tonemapUnreal(vec3 color)
{
    vec3 result = color / (color + 0.155) * 1.019;
    return pow(result, vec3(2.2));
}

// Matrices for rec 2020 <> rec 709 color space conversion
// matrix provided in row-major order so it has been transposed
// https://www.itu.int/pub/R-REP-BT.2407-2017
const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
    vec3(1.6605, -0.1246, -0.0182),
    vec3(-0.5876, 1.1329, -0.1006),
    vec3(-0.0728, -0.0083, 1.1187)
);

const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
    vec3(0.6274, 0.0691, 0.0164),
    vec3(0.3293, 0.9195, 0.0880),
    vec3(0.0433, 0.0113, 0.8956)
);

// AgX Tone Mapping implementation based on Filament, which in turn is based
// on Blender's implementation using rec 2020 primaries
// https://github.com/google/filament/pull/7236
// Inputs and outputs are encoded as Linear-sRGB.

#define AGX_LOOK_BASE 0
#define AGX_LOOK_PUNCHY 1

// https://iolite-engine.com/blog_posts/minimal_agx_implementation
// Mean error^2: 3.6705141e-06
vec3 agxDefaultContrastApprox(vec3 x)
{
    vec3 x2 = x * x;
    vec3 x4 = x2 * x2;
    return + 15.5 * x4 * x2
        - 40.14 * x4 * x
        + 31.96 * x4
        - 6.868 * x2 * x
        + 0.4298 * x2
        + 0.1191 * x
        - 0.00232;
}

vec3 agxLook(vec3 color, int look)
{
    if (look == AGX_LOOK_BASE)
        return color;

    const vec3 lw = vec3(0.2126, 0.7152, 0.0722);

    float luma = dot(color, lw);

    vec3 offset = vec3(0.0);
    vec3 slope = vec3(1.0);
    vec3 power = vec3(1.0);
    float sat = 1.0;

    if (look == AGX_LOOK_PUNCHY)
    {
        slope = vec3(1.0);
        power = vec3(1.35, 1.35, 1.35);
        sat = 1.4;
    }

    // ASC CDL
    color = pow(color * slope + offset, power);

    return luma + sat * (color - luma);
}

vec3 tonemapAgX(vec3 color, int look)
{
    // AgX constants
    const mat3 AgXInsetMatrix = mat3(
        vec3(0.856627153315983, 0.137318972929847, 0.11189821299995),
        vec3(0.0951212405381588, 0.761241990602591, 0.0767994186031903),
        vec3(0.0482516061458583, 0.101439036467562, 0.811302368396859)
    );

    // explicit AgXOutsetMatrix generated from Filaments AgXOutsetMatrixInv
    const mat3 AgXOutsetMatrix = mat3(
        vec3(1.1271005818144368, -0.1413297634984383, -0.14132976349843826),
        vec3(-0.11060664309660323, 1.157823702216272, -0.11060664309660294),
        vec3(-0.016493938717834573, -0.016493938717834257, 1.2519364065950405)
    );

    // LOG2_MIN = -10.0
    // LOG2_MAX =  +6.5
    // MIDDLE_GRAY = 0.18
    const float AgxMinEv = -12.47393; // log2(pow(2, LOG2_MIN) * MIDDLE_GRAY)
    const float AgxMaxEv = 4.026069;  // log2(pow(2, LOG2_MAX) * MIDDLE_GRAY)

    color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;
    color = AgXInsetMatrix * color;

    // Log2 encoding
    color = max(color, 1e-10); // avoid 0 or negative numbers for log2
    color = log2(color);
    color = (color - AgxMinEv) / (AgxMaxEv - AgxMinEv);
    color = clamp(color, 0.0, 1.0);

    // Apply sigmoid
    color = agxDefaultContrastApprox(color);

    // Apply AgX look
    color = agxLook(color, look);

    color = AgXOutsetMatrix * color;

    // Linearize
    color = pow(max(vec3(0.0), color), vec3(2.2));

    color = LINEAR_REC2020_TO_LINEAR_SRGB * color;

    // Gamut mapping. Simple clamp for now
    color = clamp(color, 0.0, 1.0);

    return color;
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb * exposure;
    
    if (tonemapper == 8)
        res = tonemapAgX(res, AGX_LOOK_PUNCHY);
    else if (tonemapper == 7)
        res = tonemapAgX(res, AGX_LOOK_BASE);
    else if (tonemapper == 6)
        res = tonemapUnreal(res);
    else if (tonemapper == 5)
        res = tonemapReinhard2(res);
    else if (tonemapper == 4)
        res = tonemapFilmic(res);
    else if (tonemapper == 3)
        res = tonemapACES(res); // * 0.6
    else if (tonemapper == 2)
        res = tonemapHable(res);
    else if (tonemapper == 1)
        res = tonemapReinhard(res);
    
    res = pow(res, vec3(1.0 / 2.2));
    
    fragColor = vec4(res, 1.0);
}
