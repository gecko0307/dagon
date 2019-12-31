#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;

in vec2 texCoord;
out vec4 fragColor;

/*
 * Implementation is based on a code by Jaume Sanchez:
 * https://github.com/spite/Wagner
 */

vec2 barrelDistortion(vec2 coord, float amt)
{
    vec2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * dist * amt;
}

float sat(float t)
{
    return clamp(t, 0.0, 1.0);
}

float linterp(float t)
{
    return sat(1.0 - abs(2.0 * t - 1.0));
}

float remap(float t, float a, float b)
{
    return sat((t - a) / (b - a));
}

vec3 spectrumOffset(float t)
{
    vec3 ret;
    float lo = step(t, 0.5);
    float hi = 1.0 - lo;
    float w = linterp(remap(t, 1.0/6.0, 5.0/6.0));
    ret = vec3(lo, 1.0, hi) * vec3(1.0 - w, w, 1.0 - w);
    return pow(ret, vec3(1.0 / 2.2));
}

uniform float scale;
uniform float dispersion;

const int num_iter = 12;
const float reci_num_iter_f = 1.0 / float(num_iter);

void main()
{
    vec2 uv = texCoord * scale + (1.0 - scale) * 0.5;

    vec3 sumcol = vec3(0.0);
    vec3 sumw = vec3(0.0);	
    for(int i = 0; i < num_iter; ++i)
    {
        float t = float(i) * reci_num_iter_f;
        vec3 w = spectrumOffset(t);
        sumw += w;
        sumcol += w * texture(colorBuffer, barrelDistortion(uv, 0.6 * dispersion * t)).rgb;
    }
    fragColor = vec4(sumcol / sumw, 1.0);
}
