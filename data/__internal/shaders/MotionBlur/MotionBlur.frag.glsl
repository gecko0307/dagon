#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D velocityBuffer;

uniform vec2 viewSize;

uniform float zNear;
uniform float zFar;

in vec2 texCoord;
out vec4 fragColor;

uniform float blurScale;
uniform int samples;
uniform float offsetRandomCoef;
uniform float time;
uniform float minDistance;
uniform float maxDistance;

uniform mat4 invProjectionMatrix;

#include <unproject.glsl>
#include <hash.glsl>

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    vec3 velocity = texture(velocityBuffer, texCoord).rgb;
    
    if (enabled)
    {
        vec2 blurVec = velocity.xy;
        float len = length(blurVec);
        
        float blurVecLen = clamp(len - minDistance, 0.0, maxDistance) / (maxDistance - minDistance) * blurScale;
        blurVec = normalize(blurVec) * blurVecLen;
        
        float speed = length(blurVec * viewSize);
        int nSamples = clamp(int(speed), 1, samples);

        float invSamplesMinusOne = 1.0 / max(float(nSamples) - 1.0, 1.0);
        float usedSamples = 1.0;
        
        float zCenter = unproject(invProjectionMatrix, vec3(texCoord, texture(depthBuffer, texCoord).x)).z;
        
        float rnd = mix(0.5, hash(texCoord * 467.759 + time), offsetRandomCoef);

        for (int i = 1; i < nSamples; i++)
        {
            vec2 offset = blurVec * (float(i) * invSamplesMinusOne - rnd);
            float mask = texture(velocityBuffer, texCoord + offset).z;
            float z = unproject(invProjectionMatrix, vec3(texCoord, texture(depthBuffer, texCoord + offset).x)).z; 
            //mask *= 1.0 - clamp(abs(zCenter - z), 0.0, 1.0) / 1.0;
            res += texture(colorBuffer, texCoord + offset).rgb * mask;
            usedSamples += mask;
        }

        res = max(res, vec3(0.0));
        res = res / max(usedSamples, 1.0);
    }

    fragColor = vec4(res, 1.0);
}
