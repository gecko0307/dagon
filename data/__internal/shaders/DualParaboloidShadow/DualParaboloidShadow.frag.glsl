#version 400 core

uniform float direction;

in float clipZ;
in float z;

out vec4 fragColor;

void main()
{
    // Discard if direction and clipZ have opposite signs
    if (direction * clipZ < -0.01)
        discard;
    
    fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    gl_FragDepth = z;
}
