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

/*
 * Diffuse
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

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragPBR;
layout(location = 3) out vec4 fragRadiance;

void main()
{
    vec4 terrTexCoordSample = texture(terrainTexcoordBuffer, texCoord);
    vec2 terrTexCoord = terrTexCoordSample.xy * 20.0; // TODO: uniform textureScale
    float mask = terrTexCoordSample.z;
    
    vec4 diff = diffuse(terrTexCoord);
    
    vec4 normalSample = texture(terrainNormalBuffer, texCoord);
    vec3 N = normalize(normalSample.xyz);
    float depth = normalSample.z;
    
    vec3 albedo = diff.rgb;
    
    vec4 pbr = vec4(0.0, 0.9, 0.0, 1.0);
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
