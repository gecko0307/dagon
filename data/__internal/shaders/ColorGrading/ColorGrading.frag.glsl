#version 400 core

uniform bool useLUT;

uniform sampler2D colorBuffer;

uniform sampler2D colorTableGPUImage;
uniform sampler3D colorTableHald;

// 0 = GPUImage, 1 = Hald
uniform int lookupMode;

uniform mat4 colorMatrix;

in vec2 texCoord;
out vec4 fragColor;

// Based on Brad Larson's GPUImage3
vec3 lookupGPUImage(sampler2D lookupTable, vec3 textureColor)
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

vec3 lookupHald(sampler3D lookupTable, vec3 textureColor)
{
    return texture(lookupTable, textureColor).rgb;
}

void main()
{
    vec3 rgb = texture(colorBuffer, texCoord).rgb;
    
    if (useLUT)
    {
        // LUT color grading
        if (lookupMode == 1)
            rgb = lookupHald(colorTableHald, rgb);
        else
            rgb = lookupGPUImage(colorTableGPUImage, rgb);
        
        rgb = pow(rgb, vec3(2.2));
    }
    else
    {
        // Matrix-based color correction
        rgb = pow(rgb, vec3(2.2));
        rgb = (colorMatrix * vec4(rgb, 1.0)).rgb;
    }
    
    fragColor = vec4(rgb, 1.0);
}
