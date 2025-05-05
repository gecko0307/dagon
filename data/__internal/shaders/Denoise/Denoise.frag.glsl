#version 400 core

uniform sampler2D colorBuffer;
uniform vec2 viewSize;

uniform float factor;

const int radius = 2;
const float exponent = 5.0;

in vec2 texCoord;

out vec4 fragColor;

float bilateral()
{
    vec2 invViewSize = 1.0 / viewSize;
    float center = texture(colorBuffer, texCoord).r;
    float res = 0.0;
    float total = 0.0;
    for (float x = -radius; x <= radius; x += 1)
    {
        for (float y = -radius; y <= radius; y += 1)
        {
            float s = texture(colorBuffer, texCoord + vec2(x, y) * invViewSize).r;
            float weight = 1.0 - abs(s - center) * 0.25;
            weight = pow(weight, exponent);
            res += s * weight;
            total += weight;
       }
    }
    return mix(center, res / total, factor);
}

void main()
{
    float res = bilateral();
    fragColor = vec4(vec3(res), 1.0); 
}
