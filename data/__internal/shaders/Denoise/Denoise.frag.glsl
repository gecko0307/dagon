#version 400 core

uniform sampler2D colorBuffer;
uniform vec2 viewSize;

uniform float factor;
uniform bool depthAware;

const float radius = 2.0;
const float depthSigma = 0.01;

in vec2 texCoord;

out vec4 fragColor;

float bilateral()
{
    vec2 invViewSize = 1.0 / viewSize;
    
    vec4 center = texture(colorBuffer, texCoord);
    float centerAO = center.r;
    float centerDepth = center.g;
    
    float res = 0.0;
    float total = 0.0;
    
    for (float x = -radius; x <= radius; x += 1)
    {
        for (float y = -radius; y <= radius; y += 1)
        {
            vec2 offset = vec2(x, y) * invViewSize;
            vec4 bufSample = texture(colorBuffer, texCoord + offset);
            float sampleAO = bufSample.r;
            
            float weight;
            if (depthAware)
            {
                float sampleDepth = bufSample.g;
                float depthDiff = abs(sampleDepth - centerDepth);
                weight = max(0.0, 1.0 - pow(depthDiff, 0.1));
            }
            else
            {
                weight = max(0.0, 1.0 - abs(sampleAO - centerAO ) * 0.25);
            }
            
            res += sampleAO * weight;
            total += weight;
       }
    }
    
    return mix(centerAO, res / total, factor);
}

void main()
{
    float res = bilateral();
    fragColor = vec4(vec3(res), 1.0); 
}
