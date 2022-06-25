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

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb * exposure;
    
    if (tonemapper == 6)
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
