#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;

uniform int tonemapper;
uniform float exposure;

in vec2 texCoord;
out vec4 fragColor;

/*
 * tonemapHable is based on a function by John Hable:
 * http://filmicworlds.com/blog/filmic-tonemapping-operators
 *
 * tonemapACES is based on a function by Krzysztof Narkowicz:
 * https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve
 */
 
vec3 hableFunc(vec3 x)
{
    return ((x * (0.15 * x + 0.1 * 0.5) + 0.2 * 0.02) / (x * (0.15 * x + 0.5) + 0.2 * 0.3)) - 0.02 / 0.3;
}

vec3 tonemapHable(vec3 x, float expo)
{
    //const vec3 whitePoint = vec3(11.2);
    const float whiteScale = 1.0748724675633854; //1.0 / hableFunc(whitePoint)
    vec3 c = x * expo;
    c = hableFunc(c * 2.0) * whiteScale;
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapReinhard(vec3 x, float expo)
{
    vec3 c = x * expo;
    c = c / (c + 1.0);
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapACES(vec3 x, float expo)
{
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    vec3 res = x * expo * 0.6;
    res = clamp((res*(a*res+b))/(res*(c*res+d)+e), 0.0, 1.0);
    return pow(res, vec3(1.0 / 2.2));
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    
    if (tonemapper == 3)
        res = tonemapACES(res, exposure);
    else if (tonemapper == 2)
        res = tonemapHable(res, exposure);
    else if (tonemapper == 1)
        res = tonemapReinhard(res, exposure);
    else
        res = pow(res, vec3(1.0 / 2.2));

    fragColor = vec4(res, 1.0);
}
