#version 400 core

uniform sampler2D glyphTexture;
uniform vec4 glyphColor;

in vec2 texCoord;

layout (location = 0) out vec4 fragColor;

void main()
{
    vec4 t = texture(glyphTexture, texCoord);
    fragColor = vec4(t.rrr, t.g) * glyphColor;
}
