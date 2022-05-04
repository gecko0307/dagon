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
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

vec3 tonemapHable(vec3 x)
{
    const float exposureBias = 2.0;
    vec3 curr = hableFunc(exposureBias * x);
    const float W = 11.2;
    vec3 whiteScale = vec3(1.0) / hableFunc(vec3(W));
    vec3 c = curr * whiteScale;
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapReinhard(vec3 x)
{
    vec3 c = x;
    c = c / (c + 1.0);
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapACES(vec3 x)
{
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    x = clamp((x * (a * x + b)) / (x * (c * x + d ) + e), 0.0, 1.0);
    return pow(x, vec3(1.0 / 2.2));
}

vec3 tonemapFilmic(vec3 x)
{
    x = max(vec3(0.0), x - 0.004);
    x = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
    return x;
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb * exposure;
    
    if (tonemapper == 4)
        res = tonemapFilmic(res);
    else if (tonemapper == 3)
        res = tonemapACES(res * 0.6);
    else if (tonemapper == 2)
        res = tonemapHable(res);
    else if (tonemapper == 1)
        res = tonemapReinhard(res);
    
    fragColor = vec4(res, 1.0);
}
