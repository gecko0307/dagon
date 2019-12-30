#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D colorTable;

in vec2 texCoord;
out vec4 fragColor;

vec3 lookupColor(sampler2D lookupTable, vec3 textureColor)
{
    textureColor = clamp(textureColor, 0.0, 1.0);

    float blueColor = textureColor.b * 63.0;

    vec2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);

    vec2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);

    vec2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);

    vec2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);

    vec3 newColor1 = texture(lookupTable, texPos1).rgb;
    vec3 newColor2 = texture(lookupTable, texPos2).rgb;

    vec3 newColor = mix(newColor1, newColor2, fract(blueColor));
    return newColor;
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    if (enabled)
        res = lookupColor(colorTable, res);
    fragColor = vec4(res, 1.0);
}
