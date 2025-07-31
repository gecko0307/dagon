#version 400 core

in vec3 dir;
in float distanceToLight;

out vec4 fragColor;

void main()
{
    if (1.0 + dir.z <= 0.0)
        discard;
    
    fragColor = vec4(distanceToLight);
}
