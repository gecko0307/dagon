#version 400 core

#include <dagon>

uniform sampler2D glyphTexture;
uniform vec4 glyphColor;

in vec2 texCoord;

layout (location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    vec4 t = texture(glyphTexture, uv);
    
    #if DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_SRGB
        fragColor = vec4(t.rrr, t.g) * glyphColor;
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_LINEAR
        vec4 color = vec4(t.rrr, t.g) * glyphColor;
        fragColor = vec4(pow(color.rgb, vec3(2.2)), color.a);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA24
        vec4 color = vec4(t.rrr, t.g) * glyphColor;
        vec3 linearColor = pow(color.rgb, vec3(2.2));
        fragColor = vec4(pow(linearColor, vec3(1.0 / 2.4)), color.a);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA22
        fragColor = vec4(t.rrr, t.g) * glyphColor;
    #else
        fragColor = vec4(t.rrr, t.g) * glyphColor;
    #endif
}
