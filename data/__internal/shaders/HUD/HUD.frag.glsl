#version 400 core

in vec2 texCoord;

/*
 * Diffuse color subroutines.
 * Used to switch color/texture.
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
    return textureLod(diffuseTexture, uv, 0.0);
}

subroutine uniform srtColor diffuse;

uniform float opacity;

out vec4 fragColor;

void main()
{
    vec4 color = diffuse(texCoord);
    fragColor = vec4(color.rgb, color.a * opacity);
}
