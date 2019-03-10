#version 400 core

#define PI 3.14159265359

uniform sampler2D fbColor;
uniform sampler2D fbBlurred;
uniform vec2 viewSize;

uniform mat4 perspectiveMatrix;

uniform bool useGlow;
uniform float glowBrightness;

in vec2 texCoord;

out vec4 frag_color;

void main()
{
    vec3 res = texture(fbColor, texCoord).rgb;

    if (useGlow)
    {
        vec3 glow = texture(fbBlurred, texCoord).rgb;
        res += glow * glowBrightness;
    }

    frag_color = vec4(res, 1.0); 
}
