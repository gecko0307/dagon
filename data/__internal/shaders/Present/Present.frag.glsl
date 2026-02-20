#version 400 core

#include <dagon>

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;

uniform vec2 viewSize;

uniform bool pixelization;
uniform float pixelSize;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

#if DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_SRGB
vec3 sRGB(vec3 v)
{
    return mix(12.92 * v, 1.055 * pow(v, vec3(0.41666)) - 0.055, lessThan(vec3(0.0031308), v));
}
#endif

void main()
{
    vec2 uv = texCoord;
    
    if (pixelization)
    {
        vec2 pixels = viewSize / pixelSize;
        uv.x -= mod(uv.x, 1.0 / pixels.x);
        uv.y -= mod(uv.y, 1.0 / pixels.y);
    }
    
    vec4 color = texture(colorBuffer, uv);
    
    #if DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_SRGB
        fragColor = vec4(sRGB(color.rgb), 1.0);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_LINEAR
        fragColor = vec4(color.rgb, 1.0);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA24
        fragColor = vec4(pow(color.rgb, vec3(1.0 / 2.4)), 1.0);
    #elif DAGON_OUTPUT_COLOR_PROFILE == DAGON_COLOR_PROFILE_GAMMA22
        fragColor = vec4(pow(color.rgb, vec3(1.0 / 2.2)), 1.0);
    #else
        fragColor = vec4(pow(color.rgb, vec3(1.0 / 2.2)), 1.0);
    #endif
    
    gl_FragDepth = texture(depthBuffer, uv).r;
}
