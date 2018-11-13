#version 330 core

uniform sampler2D diffuseTexture;

in vec2 texCoord;
out vec4 frag_color;

void main()
{
    frag_color = texture(diffuseTexture, texCoord);
}
