#version 400 core

#define PI 3.14159265359

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D pbrBuffer;
uniform sampler2D occlusionBuffer;
uniform bool haveOcclusionBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

uniform vec3 lightPositionWorld;
uniform vec3 lightPosition;
uniform float lightRadius;
uniform vec4 lightColor;
uniform float lightEnergy;

uniform float lightScatteringDensity;
uniform int lightScatteringSamples;

uniform bool lightVolumeCulling;
uniform float lightCameraDistanceParam;

uniform bool lightIsSpot;
uniform float lightSpotCosCutoff;
uniform float lightSpotCosInnerCutoff;
uniform vec3 lightSpotDirection;

in vec3 lightVolumeEyePos;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>
#include <gamma.glsl>
#include <hash.glsl>

void main()
{
    vec2 texCoord = gl_FragCoord.xy / resolution;
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(invProjectionMatrix, vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    
    float scatteringRadius = lightRadius * 0.9;

    // Ray from the camera through this pixel in eye space.
    // Origin at O = (0,0,0), direction D points from camera to the sample point.
    vec3 O = vec3(0.0);
    vec3 D = normalize(eyePos); // camera -> fragment
    vec3 C = lightPosition;     // sphere center in eye space

    // Solve quadratic: (O + tD - C)^2 = r^2
    vec3 OC = -C; // O - C
    float b = 2.0 * dot(D, OC);
    float c = dot(OC, OC) - scatteringRadius * scatteringRadius;
    float discriminant = b * b - 4.0 * c;
    float volumeThickness = 0.0;
    float t0 = 0.0;
    float t1 = 0.0;
    if (discriminant > 0.0)
    {
        float sqrtD = sqrt(discriminant);
        float root1 = (-b - sqrtD) * 0.5;
        float root2 = (-b + sqrtD) * 0.5;
        t0 = min(root1, root2);
        t1 = max(root1, root2);
        volumeThickness = max(0.0, t1 - t0);
    }

    volumeThickness = clamp(volumeThickness, 0.0, scatteringRadius * 2.0);
    
    // TODO: make uniform
    const float radialFalloffPower = 8.0;
    
    float opticalDepth = pow(clamp(volumeThickness / (scatteringRadius * 2.0), 0.0, 1.0), radialFalloffPower);

    if (lightIsSpot)
    {
        // Ray-march a spot light cone
        float stepSize = volumeThickness / float(lightScatteringSamples);
        float totalScattering = 0.0;
        
        float offset = hash((texCoord * 467.759) * eyePos.z);

        for (int i = 0; i < lightScatteringSamples; i++)
        {
            float t = max(0.0, t0) + (float(i) + offset) * stepSize;
            vec3 P = O + D * t;
            vec3 L = P - C;
            float distToLight = length(L);
            vec3 Ldir = L / distToLight;
            float cosAngle = dot(Ldir, lightSpotDirection);
            totalScattering += smoothstep(lightSpotCosCutoff, lightSpotCosInnerCutoff, cosAngle);
        }

        opticalDepth *= totalScattering / float(lightScatteringSamples);
    }

    if (lightVolumeCulling)
    {
        // Smoothly occlude with geometry
        float geometryFactor = clamp(abs(eyePos.z) - abs(lightVolumeEyePos.z), 0.0, lightRadius) / lightRadius;
        opticalDepth *= mix(1.0, geometryFactor, lightCameraDistanceParam);
    }

    // Mitigate "ghosting" artifact when light is behind the camera
    opticalDepth *= 1.0 - clamp(lightPosition.z, 0.0, 1.0);

    vec3 radiance = toLinear(lightColor.rgb) * opticalDepth * lightScatteringDensity * lightEnergy;
    
    // Fog
    float linearDepth = abs(lightVolumeEyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;
    
    fragColor = vec4(radiance, 1.0);
}
