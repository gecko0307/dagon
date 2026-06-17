#version 400 core

in vec2 texCoord;

uniform sampler2D texChannel0;
uniform sampler2D texChannel1;
uniform sampler2D texChannel2;
uniform sampler2D texChannel3;

uniform float valueChannel0;
uniform float valueChannel1;
uniform float valueChannel2;
uniform float valueChannel3;

uniform int channel0Func;
uniform int channel1Func;
uniform int channel2Func;
uniform int channel3Func;

layout(location = 0) out vec4 fragColor;

void main()
{
    float channel0 = valueChannel0;
    if (channel0Func == 1)
        channel0 = texture(texChannel0, uv).r;
    
    float channel1 = valueChannel1;
    if (channel1Func == 1)
        channel1 = texture(texChannel1, uv).r;
    
    float channel2 = valueChannel2;
    if (channel2Func == 1)
        channel2 = texture(texChannel2, uv).r;
    
    float channel3 = valueChannel3;
    if (channel3Func == 1)
        channel3 = texture(texChannel3, uv).r;
    
    fragColor = vec4(channel0, channel1, channel2, channel3);
}
