#version 400 core

layout (location = 0) in vec3 va_Vertex;

uniform mat4 modelMatrix;
uniform vec4 lightPosition;
uniform float lightRadius;
uniform float direction;

out float clipZ;
out float z;

void main()
{
    vec4 modelPosHmg = vec4(va_Vertex, 1.0);
    vec4 worldPos = modelMatrix * modelPosHmg;
    vec3 lightSpacePos = worldPos.xyz - lightPosition.xyz;
    float distanceToLight = length(lightSpacePos);
    vec3 dir = normalize(lightSpacePos);
    clipZ = dir.z;
    dir.z *= direction;
    vec2 xy = dir.xy / (1.0 + dir.z);
    z = distanceToLight / lightRadius;
    gl_Position = vec4(xy, z, 1.0);
}
