#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D blurredBuffer;

uniform float intensity;

in vec2 texCoord;
out vec4 fragColor;

void main()
{
    vec3 col = texture(colorBuffer, texCoord).rgb;
    vec3 blurred = texture(blurredBuffer, texCoord).rgb;

    fragColor = vec4(col + blurred * intensity, 1.0);
}
