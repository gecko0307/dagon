#version 400 core

in float z;

out vec4 fragColor;

void main()
{
    fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    gl_FragDepth = z;
}
