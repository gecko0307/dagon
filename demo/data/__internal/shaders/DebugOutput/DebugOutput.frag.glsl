#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D pbrBuffer;
uniform sampler2D occlusionBuffer;
uniform bool haveOcclusionBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

// 0 - radiance
// 1 - color
// 2 - normal
// 3 - position
// 4 - roughness
// 5 - metallic
// 6 - occlusion
uniform int outputMode;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>

void main()
{
    vec2 invResolution = 1.0 / resolution;

    vec4 col = texture(colorBuffer, texCoord);
    vec3 albedo = col.rgb;
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    
    float roughness = texture(pbrBuffer, texCoord).r;
    float metallic = texture(pbrBuffer, texCoord).g;
    
    float occlusion = haveOcclusionBuffer? texture(occlusionBuffer, texCoord).r : 1.0;

    if (outputMode == 0)
        discard;

    vec3 coutput = 
        albedo * float(outputMode == 1) + 
        N * float(outputMode == 2) + 
        eyePos * float(outputMode == 3) +
        vec3(roughness) * float(outputMode == 4) +
        vec3(metallic) * float(outputMode == 5) +
        vec3(occlusion) * float(outputMode == 6);
    
    fragColor = vec4(coutput, 1.0);
}
