#version 400 core

uniform sampler2D colorBuffer;
uniform vec2 viewSize;
uniform float luminanceThreshold;
uniform float softKnee;
uniform float maxEnergy;

in vec2 texCoord;

out vec4 fragColor;

void main()
{
    vec3 color = texture(colorBuffer, texCoord).rgb;
    color = min(color, vec3(maxEnergy));
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    
    // Soft knee formula
    float knee = softKnee + 1e-5;
    float soft = lum - luminanceThreshold + knee;
    soft = clamp(soft, 0.0, 2.0 * knee);
    soft = (soft * soft) / (4.0 * knee);
    
    float weight = max(lum - luminanceThreshold, soft) / max(lum, 1e-4);
    vec3 res = color * weight;
    res = max(res, vec3(0.0));
    fragColor = vec4(res, 1.0); 
}
