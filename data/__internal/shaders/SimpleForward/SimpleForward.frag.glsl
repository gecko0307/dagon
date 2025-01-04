#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

uniform float opacity;

/*
 * Diffuse
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColorValue(in vec2 uv)
{
    return diffuseVector;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseColorTexture(in vec2 uv)
{
    return texture(diffuseTexture, uv);
}

subroutine uniform srtColor diffuse;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    vec3 E = normalize(-eyePosition);
    vec3 N = normalize(eyeNormal);
    
    vec4 diffuseColor = diffuse(uv);
    float alpha = diffuseColor.a * opacity;
    
    fragColor = vec4(diffuseColor.rgb, alpha);
}
