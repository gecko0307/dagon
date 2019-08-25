#version 400 core

uniform sampler2D colorBuffer;
uniform vec2 viewSize;

uniform float luminanceThreshold;

in vec2 texCoord;

out vec4 fragColor;

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    float lum = dot(res, vec3(0.2126, 0.7152, 0.0722)); //res.r * 0.2126 + res.g * 0.7152 + res.b * 0.0722;
    res = mix(vec3(0.0), res, float(lum >= luminanceThreshold));
    fragColor = vec4(res, 1.0); 
}
