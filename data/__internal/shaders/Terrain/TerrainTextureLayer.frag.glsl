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
    //float depth = texture(depthBuffer, texCoord).x;
    //vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    
    float mask = 1.0;
    // TODO: sample mask and material textures
    // TODO: opacity
    
    fragColor = vec4(0.5, 0.5, 0.5, mask); // TODO
    fragNormal = vec4(N, mask);
    fragPBR = vec4(0.5, 0.0, 1.0, mask); // TODO
    fragRadiance = vec4(0.0, 0.0, 0.0, mask); // TODO
}
