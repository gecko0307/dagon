#version 400 core

uniform sampler2D fbColor;
uniform sampler2D fbPosition;
uniform sampler2D fbVelocity;
uniform sampler2D colorTable;
uniform sampler2D vignette;
uniform vec2 viewSize;
uniform float timeStep;

uniform bool useMotionBlur;
uniform int motionBlurSamples;
uniform float shutterFps;

uniform float exposure;
uniform int tonemapFunction;

uniform bool useLUT;
uniform bool useVignette;

in vec2 texCoord;

out vec4 frag_color;

/*
 * tonemapHable is based on a function by John Hable:
 * http://filmicworlds.com/blog/filmic-tonemapping-operators
 *
 * tonemapACES is based on a function by Krzysztof Narkowicz:
 * https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve
 *
 * LUT function (lookupColor) is based on a code by Matt DesLauriers:
 * https://github.com/mattdesl/glsl-lut
 */

vec3 hableFunc(vec3 x)
{
    return ((x * (0.15 * x + 0.1 * 0.5) + 0.2 * 0.02) / (x * (0.15 * x + 0.5) + 0.2 * 0.3)) - 0.02 / 0.3;
}

vec3 tonemapHable(vec3 x, float expo)
{
    //const vec3 whitePoint = vec3(11.2);
    const float whiteScale = 1.0748724675633854; //1.0 / hableFunc(whitePoint)
    vec3 c = x * expo;
    c = hableFunc(c * 2.0) * whiteScale;
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapReinhard(vec3 x, float expo)
{
    vec3 c = x * expo;
    c = c / (c + 1.0);
    return pow(c, vec3(1.0 / 2.2));
}

vec3 tonemapACES(vec3 x, float expo)
{
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    vec3 res = x * expo * 0.6;
    res = clamp((res*(a*res+b))/(res*(c*res+d)+e), 0.0, 1.0);
    return pow(res, vec3(1.0 / 2.2));
}

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
    vec3 res = texture(fbColor, texCoord).rgb;
    
    if (useMotionBlur)
    {
        vec2 blurVec = texture(fbVelocity, texCoord).xy;
        float depthRef = texture(fbPosition, texCoord).z;
        blurVec = blurVec / (timeStep * shutterFps);

        float speed = length(blurVec * viewSize);
        int nSamples = clamp(int(speed), 1, motionBlurSamples);

        float invSamplesMinusOne = 1.0 / float(nSamples - 1);
        float usedSamples = 1.0;
        const float depthThreshold = 20.0;

        for (int i = 1; i < nSamples; i++)
        {
            vec2 offset = blurVec * (float(i) * invSamplesMinusOne - 0.5);
            float mask = texture(fbVelocity, texCoord + offset).w;
            float depth = texture(fbPosition, texCoord + offset).z;
            float depthWeight = 1.0; //1.0 - clamp(abs(depth - depthRef), 0.0, depthThreshold) / depthThreshold;
            res += texture(fbColor, texCoord + offset).rgb * mask * depthWeight;
            usedSamples += mask * depthWeight;
        }

        res = res / usedSamples;
    }
    
    if (tonemapFunction == 2)
        res = tonemapACES(res, exposure);
    else if (tonemapFunction == 1)
        res = tonemapHable(res, exposure);
    else
        res = tonemapReinhard(res, exposure);

    if (useVignette)
        res = mix(res, res * texture(vignette, vec2(texCoord.x, 1.0 - texCoord.y)).rgb, 0.8);
    
    if (useLUT)
        res = lookupColor(colorTable, res);

    frag_color = vec4(res, 1.0);
}
