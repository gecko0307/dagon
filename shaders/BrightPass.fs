#version 400 core

uniform sampler2D fbColor;
uniform vec2 viewSize;

uniform float luminanceThreshold;

in vec2 texCoord;

out vec4 frag_color;

void main()
{
    vec3 res = texture(fbColor, texCoord).rgb;
    float lum = res.r * 0.2126 + res.g * 0.7152 + res.b * 0.0722;
    res = mix(vec3(0.0), res, float(lum >= luminanceThreshold));
    frag_color = vec4(res, 1.0); 
}
