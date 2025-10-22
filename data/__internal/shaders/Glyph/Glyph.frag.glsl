#version 400 core

uniform sampler2D glyphTexture;
uniform vec4 glyphColor;
uniform vec2 resolution;

in vec2 texCoord;

layout (location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    vec4 t = texture(glyphTexture, uv);
    fragColor = vec4(t.rrr, t.g) * glyphColor;
}
