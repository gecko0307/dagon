#version 400 core

uniform sampler2D fbColor;
uniform vec2 viewSize;

in vec2 texCoord;
out vec4 frag_color;

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

vec4 spectrumOffset(float t)
{
    vec4 ret;
    float lo = step(t, 0.5);
    float hi = 1.0 - lo;
    float w = linterp(remap(t, 1.0/6.0, 5.0/6.0));
    ret = vec4(lo, 1.0, hi, 1.0) * vec4(1.0 - w, w, 1.0 - w, 1.0);
    return pow(ret, vec4(1.0 / 2.2));
}

uniform float scale;
uniform float dispersion;

const int num_iter = 12;
const float reci_num_iter_f = 1.0 / float(num_iter);

void main()
{	
    vec2 uv = texCoord * scale + (1.0 - scale) * 0.5;

    vec4 sumcol = vec4(0.0);
    vec4 sumw = vec4(0.0);	
    for(int i = 0; i < num_iter; ++i)
    {
        float t = float(i) * reci_num_iter_f;
        vec4 w = spectrumOffset(t);
        sumw += w;
        sumcol += w * texture(fbColor, barrelDistortion(uv, 0.6 * dispersion * t));
    }

    frag_color = sumcol / sumw;
    frag_color.a = 1.0;
}
