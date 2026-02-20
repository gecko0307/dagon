#version 400 core

#include <dagon>

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
    
    #if DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_SRGB
        fragColor = vec4(color.rgb, color.a * opacity);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_LINEAR
        fragColor = vec4(pow(color.rgb, vec3(2.2)), color.a * opacity);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA24
        vec3 linearColor = pow(color.rgb, vec3(2.2));
        fragColor = vec4(pow(linearColor, vec3(1.0 / 2.4)), color.a * opacity);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA22
        fragColor = vec4(color.rgb, color.a * opacity);
    #else
        fragColor = vec4(color.rgb, color.a * opacity);
    #endif
}
