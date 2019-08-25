#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

// SSAO implementation based on code by Reinder Nijhoff
// https://www.shadertoy.com/view/Ms33WB

uniform int ssaoSamples;
uniform float ssaoRadius;
uniform float ssaoPower;

#define SSAO_SCALE 1.0
#define SSAO_BIAS 0.05

float hash(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.11369, 0.13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

float ssao(in vec2 tcoord, in vec2 uv, in vec3 p, in vec3 cnorm)
{
    float depth = texture(depthBuffer, tcoord + uv).x;
    vec3 pos = unproject(vec3(tcoord + uv, depth));
    
    vec3 diff = pos - p;
    float l = length(diff);
    vec3 v = diff / l;
    float d = l * SSAO_SCALE;
    float ao = max(0.0, dot(cnorm, v) - SSAO_BIAS) * (1.0 / (1.0 + d));
    return ao;
}

float spiralSSAO(vec2 uv, vec3 p, vec3 n, float rad)
{
    float goldenAngle = 2.4;
    float ao = 0.0;
    float inv = 1.0 / float(ssaoSamples);
    float radius = 0.0;

    float rotatePhase = hash(uv * 467.759) * 6.28;
    float rStep = inv * rad;
    vec2 spiralUV;

    for (int i = 0; i < ssaoSamples; i++)
    {
        spiralUV.x = sin(rotatePhase);
        spiralUV.y = cos(rotatePhase);
        radius += rStep;
        ao += ssao(uv, spiralUV * radius, p, n);
        rotatePhase += goldenAngle;
    }
    ao *= inv;
    return ao;
}

void main()
{
    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;
        
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(vec3(texCoord, depth));
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);

    float occlusion = spiralSSAO(texCoord, eyePos, N, ssaoRadius / eyePos.z);
    occlusion = pow(clamp(1.0 - occlusion, 0.0, 1.0), ssaoPower);
    
    fragColor = vec4(vec3(occlusion), 1.0);
}
