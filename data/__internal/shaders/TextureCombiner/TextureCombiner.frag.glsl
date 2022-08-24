#version 400 core

in vec2 texCoord;

uniform sampler2D texChannel0;
uniform sampler2D texChannel1;
uniform sampler2D texChannel2;
uniform sampler2D texChannel3;

uniform float valueChannel0;
uniform float valueChannel1;
uniform float valueChannel2;
uniform float valueChannel3;

//
subroutine float srtTexChannel0(in vec2 uv);

subroutine(srtTexChannel0) float channel0Value(in vec2 uv)
{
    return valueChannel0;
}

subroutine(srtTexChannel0) float channel0Texture(in vec2 uv)
{
    return texture(texChannel0, uv).r;
}

subroutine uniform srtTexChannel0 channel0;

//
subroutine float srtTexChannel1(in vec2 uv);

subroutine(srtTexChannel1) float channel1Value(in vec2 uv)
{
    return valueChannel1;
}

subroutine(srtTexChannel1) float channel1Texture(in vec2 uv)
{
    return texture(texChannel1, uv).r;
}

subroutine uniform srtTexChannel1 channel1;

//
subroutine float srtTexChannel2(in vec2 uv);

subroutine(srtTexChannel2) float channel2Value(in vec2 uv)
{
    return valueChannel2;
}

subroutine(srtTexChannel2) float channel2Texture(in vec2 uv)
{
    return texture(texChannel2, uv).r;
}

subroutine uniform srtTexChannel2 channel2;

//
subroutine float srtTexChannel3(in vec2 uv);

subroutine(srtTexChannel3) float channel3Value(in vec2 uv)
{
    return valueChannel3;
}

subroutine(srtTexChannel3) float channel3Texture(in vec2 uv)
{
    return texture(texChannel3, uv).r;
}

subroutine uniform srtTexChannel3 channel3;


layout(location = 0) out vec4 fragColor;

void main()
{
    fragColor = vec4(
        channel0(texCoord),
        channel1(texCoord),
        channel2(texCoord),
        channel3(texCoord)
    );
}
