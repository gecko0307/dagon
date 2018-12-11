#version 400 core

#define PI 3.14159265359

uniform sampler2D fbColor;
uniform sampler2D fbBlurred;
uniform vec2 viewSize;

uniform mat4 perspectiveMatrix;

uniform bool useGlow;
uniform float glowBrightness;
uniform float glowMinLuminanceThreshold = 0.01;
uniform float glowMaxLuminanceThreshold = 0.5;

in vec2 texCoord;

out vec4 frag_color;

void main()
{
    vec3 res = texture(fbColor, texCoord).rgb;

    if (useGlow)
    {
        vec3 glow = texture(fbBlurred, texCoord).rgb;
        float lum = glow.r * 0.2126 + glow.g * 0.7152 + glow.b * 0.0722;
        lum = (clamp(lum, glowMinLuminanceThreshold, glowMaxLuminanceThreshold) - glowMinLuminanceThreshold) / (glowMaxLuminanceThreshold - glowMinLuminanceThreshold);
        res = mix(res, res + glow * glowBrightness, lum);
    }

    frag_color = vec4(res, 1.0); 
}
