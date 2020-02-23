#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec4 coutput = texture(colorBuffer, texCoord);
    fragColor = vec4(coutput.rgb, 1.0);
    gl_FragDepth = texture(depthBuffer, texCoord).r;
}
