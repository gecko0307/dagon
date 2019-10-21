#version 400 core

uniform sampler2D Texture;

in vec2 texCoord;
in vec4 color;

out vec4 fragColor;

void main()
{
    fragColor = color * texture(Texture, texCoord);
}
