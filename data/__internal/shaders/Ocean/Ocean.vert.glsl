#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

#include <hash.glsl>

layout(location = 0) in vec3 va_Vertex;
layout(location = 1) in vec3 va_Normal;
layout(location = 2) in vec2 va_Texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform mat4 prevModelViewMatrix;
uniform mat3 textureMatrix;

uniform float time1;
uniform float time2;

uniform vec3 cameraPosition;

// TODO: support custom wave layers
//uniform int numWaves;
//uniform vec4 waves[16]; // x: amplitude, y: wavelength, z: speed, w: choppiness
//uniform vec2 directions[16];

int numWaves = 4;
vec4 waves[4] = vec4[4](
    vec4(0.2, 0.08, time1, 2.0),
    vec4(0.1, 0.1, time2, 2.0),
    vec4(0.1, 0.15, time1, 2.0),
    vec4(0.2, 0.12, time2, 2.0)
);
vec2 directions[4] = vec2[4](
    vec2(1.0, 0.0),
    vec2(1.0, 1.0),
    vec2(-1.0, -1.0),
    vec2(0.0, -1.0)
);

vec3 gerstnerDisplace(vec3 pos, out vec3 normal)
{
    vec3 P = pos + cameraPosition;
    normal = vec3(0.0, 1.0, 0.0);
    
    vec4 wave = vec4(0.5, 0.1, 1.0, 2.0);
    vec2 direction = vec2(1.0, 0.0);
    
    const float steepness = 1.0;

    for (int i = 0; i < numWaves; ++i)
    {
        float A = waves[i].x;
        float invLambda = waves[i].y;
        float c = waves[i].z;
        float Q = waves[i].w;
        vec2 D = normalize(directions[i]);

        float w = PI2 * invLambda;
        float phase = w * dot(D, P.xz) + mix(-PI2, PI2, c);
        float cos_p = cos(phase);
        float sin_p = sin(phase);

        P.x += Q * A * D.x * cos_p;
        P.z += Q * A * D.y * cos_p;
        P.y += A * sin_p;
        
        float wA = w * A;

        float Qi = steepness / (wA * float(numWaves));
        normal.xz -= D * wA * cos_p;
        normal.y -= Qi * wA * sin_p;
    }
    
    normal = normalize(normal);

    return P - cameraPosition;
}

out vec3 eyePosition;
out vec3 eyeNormal;
out vec2 texCoord;

out vec4 currPosition;
out vec4 prevPosition;

out float height;

void main()
{
    vec3 normal;
    vec3 modelPos = gerstnerDisplace(va_Vertex, normal);
    
    height = clamp(modelPos.y * 0.5 + 0.5, 0.0, 1.0);
    
    vec4 modelPosHmg = vec4(modelPos, 1.0);
    vec4 eyePosHmg = modelViewMatrix * modelPosHmg;
    eyePosition = eyePosHmg.xyz;
    
    vec4 modelNormalHmg = vec4(normal, 0.0);
    eyeNormal = (normalMatrix * modelNormalHmg).xyz;
    
    texCoord = (textureMatrix * vec3(va_Texcoord + cameraPosition.xz, 1.0)).xy;
    
    currPosition = projectionMatrix * eyePosHmg;
    prevPosition = projectionMatrix * prevModelViewMatrix * modelPosHmg;
    
    gl_Position = currPosition;
}
