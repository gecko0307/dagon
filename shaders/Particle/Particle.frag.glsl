#version 400 core

in vec3 eyePosition;
in vec2 texCoord;

in vec3 worldPosition;
in vec3 worldView;

in vec4 currPosition;
in vec4 prevPosition;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragVelocity;

void main()
{
    vec3 diffuseColor = vec3(1.0, 0.0, 0.0);
    fragColor = vec4(diffuseColor, 1.0);
    fragVelocity = vec4(0.0, 0.0, 0.0, 1.0);
}
