#version 400 core

layout (location = 0) in vec3 va_Vertex;

uniform mat4 modelMatrix;
uniform vec4 lightPosition;
uniform float lightRadius;
uniform float direction;

out vec3 dir;
out float distanceToLight;

void main()
{
    vec4 modelPosHmg = vec4(va_Vertex, 1.0);
    vec4 worldPos = modelMatrix * modelPosHmg;
    
    vec3 lightSpacePos = worldPos.xyz - lightPosition.xyz;
    distanceToLight = length(lightSpacePos);
    
    dir = normalize(lightSpacePos);
    dir.z *= direction;
    vec2 xy = dir.xy / (1.0 + dir.z);
    float z = distanceToLight / lightRadius;
    gl_Position = vec4(xy, z, 1.0);
}
