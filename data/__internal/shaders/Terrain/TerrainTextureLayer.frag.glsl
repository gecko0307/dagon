#version 400 core

uniform sampler2D terrainNormalBuffer;
uniform sampler2D terrainTexcoordBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

in vec2 texCoord;

#include <unproject.glsl>

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragRadiance;

void main()
{
    vec4 nor = texture(terrainNormalBuffer, texCoord);
    if (nor.a < 1.0)
        discard;
    
    vec3 N = normalize(nor.rgb);
    vec2 terrTexCoord = texture(terrainTexcoordBuffer, texCoord).xy;
    
    float mask = 1.0;
    vec4 diff = vec4(0.5, 0.25, 0.0, 1.0);
    vec3 albedo = diff.rgb;
    vec4 pbr = vec4(0.0, 0.5, 0.0, 1.0);
    float roughness = pbr.g;
    float metallic = pbr.b;
    vec4 emission = vec4(0.0, 0.0, 0.0, 1.0);
    float opacity = 1.0;
    
    // TODO: sample mask and material textures
    
    mask *= opacity;
    
    fragColor = vec4(albedo, mask);
    fragNormal = vec4(N, mask);
    fragPBR = vec4(roughness, metallic, 1.0, mask);
    fragRadiance = vec4(emission.rgb, mask);
}
