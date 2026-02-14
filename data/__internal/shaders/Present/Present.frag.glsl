#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;

uniform vec2 viewSize;

uniform bool pixelization;
uniform float pixelSize;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec2 uv = texCoord;
    
    if (pixelization)
    {
        vec2 pixels = viewSize / pixelSize;
        uv.x -= mod(uv.x, 1.0 / pixels.x);
        uv.y -= mod(uv.y, 1.0 / pixels.y);
    }
    
    vec4 coutput = texture(colorBuffer, uv);
    fragColor = vec4(pow(coutput.rgb, vec3(1.0 / 2.2)), 1.0);
    gl_FragDepth = texture(depthBuffer, uv).r;
}
