#version 400 core

in vec3 normal;

layout(location = 0) out vec4 fragColor;

uniform mat4 viewMatrix;
const vec3 sunDirectionMain = normalize(vec3(1.0, 1.0, 1.0));
const vec3 sunDirectionSecondary = normalize(vec3(-1.0, -1.0, -1.0));

void main()
{
    vec3 N = normalize(normal);
    vec3 L1 = normalize((viewMatrix * vec4(sunDirectionMain, 0.0)).xyz);
    vec3 L2 = normalize((viewMatrix * vec4(sunDirectionSecondary, 0.0)).xyz);
    float light1 = max(0.0, dot(N, L1));
    float light2 = max(0.0, dot(N, L2));
    vec3 color = vec3(1.0) * light1 + vec3(0.0, 0.5, 1.0) * light2;
    fragColor = vec4(color, 1.0);
}
