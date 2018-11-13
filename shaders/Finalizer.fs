#version 400 core

uniform sampler2D fbColor;
uniform vec2 viewSize;

in vec2 texCoord;
out vec4 frag_color;

void main()
{
    vec3 color = texture(fbColor, texCoord).xyz;  
    frag_color = vec4(color, 1.0); 
}
