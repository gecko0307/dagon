#version 400 core

uniform sampler2D Texture;

in vec2 texCoord;
in vec4 color;

out vec4 frag_color;

void main()
{
    frag_color = color * texture(Texture, texCoord);
}
