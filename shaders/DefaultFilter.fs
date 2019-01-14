#version 400 core

uniform sampler2D fbColor;
uniform vec2 viewSize;

in vec2 texCoord;
out vec4 frag_color;

void main()
{
    vec4 t = texture(fbColor, texCoord);
    frag_color = t;
    frag_color.a = 1.0;
}
