#version 400 core

#define PI 3.14159265359

in vec2 texCoord;

uniform sampler2D envmap;
uniform mat4 pixelToWorldMatrix;

layout(location = 0) out vec4 fragColor;

vec2 equirectProj(vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / (PI * 2.0), phi / PI);
}

void main()
{
    vec2 ndc = vec2(texCoord.x, 1.0 - texCoord.y) * 2.0 - 1.0;
    vec3 ray = normalize(vec3(ndc, 1.0f));
    vec3 rayWorld = (pixelToWorldMatrix * vec4(ray, 0.0f)).xyz;
    vec2 sampleTexCoord = equirectProj(rayWorld);
    fragColor = texture(envmap, sampleTexCoord);
}
