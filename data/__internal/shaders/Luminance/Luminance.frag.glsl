#version 400 core

uniform sampler2D colorBuffer;

in vec2 texCoord;

out vec4 fragColor;

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    float lum = dot(res, vec3(0.2126, 0.7152, 0.0722));
    fragColor = vec4(lum, lum, lum, 1.0); 
}
