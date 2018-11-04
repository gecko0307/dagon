#version 330 core

uniform sampler2D glyphTexture;
uniform vec4 glyphColor;

in vec2 texCoord;
out vec4 frag_color;

void main()
{
    vec4 t = texture(glyphTexture, texCoord);
    frag_color = vec4(t.rrr, t.g) * glyphColor;
}
