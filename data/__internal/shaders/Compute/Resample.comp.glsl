#version 430
layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(rgba8, binding = 0) readonly uniform image2D srcTex;
layout(binding = 1) writeonly uniform image2D destTex;

uniform vec2 srcSize;
uniform vec2 destSize;

void main()
{
    ivec2 destCoord = ivec2(gl_GlobalInvocationID.xy);

    if (destCoord.x >= destSize.x || destCoord.y >= destSize.y)
        return;

    vec2 uv = vec2(destCoord) / vec2(destSize);

    vec2 srcPos = uv * vec2(srcSize) - 0.5;

    ivec2 iPos = ivec2(floor(srcPos));
    vec2 f = fract(srcPos);

    vec4 c00 = imageLoad(srcTex, iPos);
    vec4 c10 = imageLoad(srcTex, iPos + ivec2(1, 0));
    vec4 c01 = imageLoad(srcTex, iPos + ivec2(0, 1));
    vec4 c11 = imageLoad(srcTex, iPos + ivec2(1, 1));

    vec4 c0 = mix(c00, c10, f.x);
    vec4 c1 = mix(c01, c11, f.x);
    vec4 color = mix(c0, c1, f.y);

    imageStore(destTex, destCoord, color);
}
