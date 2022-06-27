#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;

uniform mat4 modelViewMatrix;
uniform mat4 normalMatrix;
uniform mat4 projectionMatrix;
uniform mat4 invViewMatrix;
uniform mat4 prevModelViewMatrix;

out vec4 currPosition;
out vec4 prevPosition;

out vec3 vWorldPosition;
out float vSunfade;
out vec3 vBetaR;
out vec3 vBetaM;
out float vSunE;

uniform vec3 sunDirection;

const float turbidity = 5.0;
const float rayleigh = 4.0;
const float mieCoefficient = 0.005;
const vec3 up = vec3(0.0, 1.0, 0.0);

const float e = 2.71828182845904523536028747135266249775724709369995957;

const vec3 lambda = vec3(680E-9, 550E-9, 450E-9);
const vec3 totalRayleigh = vec3(5.804542996261093E-6, 1.3562911419845635E-5, 3.0265902468824876E-5);

const float v = 4.0;
const vec3 K = vec3(0.686, 0.678, 0.666);
const vec3 MieConst = vec3(1.8399918514433978E14, 2.7798023919660528E14, 4.0790479543861094E14);

const float cutoffAngle = 1.6110731556870734;
const float steepness = 1.5;

float sunIntensity(float zenithAngleCos)
{
    zenithAngleCos = clamp(zenithAngleCos, -1.0, 1.0);
    return 100.0 * max(0.0, 1.0 - pow(e, -((cutoffAngle - acos(zenithAngleCos)) / steepness)));
}

vec3 totalMie(float T)
{
    float c = (0.2 * T) * 10E-18;
    return 0.434 * c * MieConst;
}

void main()
{
    vec4 pos = modelViewMatrix * vec4(va_Vertex, 1.0);
    vWorldPosition = (invViewMatrix * pos).xyz;
    
    vec3 sunPosition = sunDirection * 400000;
    
    vSunE = sunIntensity(dot(sunDirection, up));
    vSunfade = 1.0 - clamp(1.0 - exp((sunPosition.y / 450000.0)), 0.0, 1.0);
    float rayleighCoefficient = rayleigh - (1.0 * (1.0 - vSunfade));
    vBetaR = totalRayleigh * rayleighCoefficient;
    vBetaM = totalMie(turbidity) * mieCoefficient;
    
    currPosition = projectionMatrix * pos;
    prevPosition = projectionMatrix * prevModelViewMatrix * vec4(va_Vertex, 1.0);

    gl_Position = currPosition;
}
