#version 400 core

uniform bool enabled;

uniform sampler2D fbColor;
uniform vec2 viewSize;
uniform vec2 direction;

in vec2 texCoord;
out vec4 frag_color;

/*
 * Gaussian blur implementation is based on code by Matt DesLauriers:
 * https://github.com/Jam3/glsl-fast-gaussian-blur
 */
vec4 blur(sampler2D image, vec2 uv, vec2 resolution, vec2 direction)
{
    vec4 color = vec4(0.0);
    vec2 off1 = vec2(1.3846153846) * direction;
    vec2 off2 = vec2(3.2307692308) * direction;
    color += texture(image, uv) * 0.2270270270;
    color += texture(image, uv + (off1 / resolution)) * 0.3162162162;
    color += texture(image, uv - (off1 / resolution)) * 0.3162162162;
    color += texture(image, uv + (off2 / resolution)) * 0.0702702703;
    color += texture(image, uv - (off2 / resolution)) * 0.0702702703;
    return color;
}

const float weight[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

void main()
{
    vec2 fragCoord = gl_FragCoord.xy;
    vec2 invScreenSize = 1.0 / viewSize;

    vec3 color;
    if (enabled)
    {
        color = blur(fbColor, texCoord, viewSize, direction).rgb;
        color = max(color, vec3(0.0));
    }
    else
    {
        color = vec3(0.0, 0.0, 0.0);
    }

    frag_color = vec4(color, 1.0); 
}
