#version 400 core

in vec2 texCoord;

/*
 * Diffuse color
 */
uniform vec4 diffuseVector;
uniform sampler2D diffuseTexture;
uniform int diffuseFunc;

uniform float opacity;
uniform float clipThreshold;

out vec4 fragColor;

void main()
{
    vec4 fragDiffuse = diffuseVector;
    if (diffuseFunc == 1)
        fragDiffuse = texture(diffuseTexture, texCoord);
    
    if ((fragDiffuse.a * opacity) < clipThreshold)
        discard;
    
    fragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
