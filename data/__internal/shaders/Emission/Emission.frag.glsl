#version 400 core

uniform sampler2D emissionBuffer;

uniform vec2 resolution;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec4 emission = texture(emissionBuffer, texCoord);
    fragColor = emission;
}
