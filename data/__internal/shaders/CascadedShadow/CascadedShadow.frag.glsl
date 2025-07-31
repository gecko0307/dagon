#version 400 core

in vec2 texCoord;

uniform float opacity;

/*
 * Diffuse color
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColorValue(in vec2 uv)
{
    return diffuseVector;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseColorTexture(in vec2 uv)
{
    return texture(diffuseTexture, uv);
}

subroutine uniform srtColor diffuse;

out vec4 fragColor;

void main()
{    
    vec4 fragDiffuse = diffuse(texCoord);
    
    if ((fragDiffuse.a * opacity) < 0.5)
        discard;
    
    fragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
