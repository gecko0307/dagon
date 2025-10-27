#version 400 core

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

uniform bool lightVolumeCulling;

in vec3 lightVolumeEyePos;

layout(location = 0) out vec4 fragColor;

#include <unproject.glsl>
#include <gamma.glsl>

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
    float r = scatteringRadius;

    // Solve quadratic: |O + t D - C|^2 = r^2
    vec3 OC = O - C; // = -C
    float b = 2.0 * dot(D, OC);
    float c = dot(OC, OC) - r * r;
    float discriminant = b * b - 4.0 * c;
    float thickness = 0.0;
    if (discriminant > 0.0)
    {
        float sqrtD = sqrt(discriminant);
        float t0 = (-b - sqrtD) * 0.5;
        float t1 = (-b + sqrtD) * 0.5;
        thickness = max(0.0, t1 - t0);
    }

    const float falloffPower = 8.0;
    const float geomOcclusionDistance = 5.0;

    thickness = clamp(thickness, 0.0, lightRadius * 2.0);
    float falloff = pow(clamp(thickness / (scatteringRadius * 2.0), 0.0, 1.0), falloffPower);

    if (lightVolumeCulling)
    {
        // Rendering front faces, smoothly occlude with geometry
        float geomFalloff = clamp(abs(eyePos.z) - abs(lightVolumeEyePos.z), 0.0, geomOcclusionDistance) / geomOcclusionDistance;
        falloff *= geomFalloff;
    }

    // Mitigate "ghosting" artifact when light is behind the camera
    falloff *= 1.0 - clamp(lightPosition.z, 0.0, 1.0);

    vec3 radiance = toLinear(lightColor.rgb) * falloff * lightScatteringDensity;
    
    // Fog
    float linearDepth = abs(lightVolumeEyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;
    
    fragColor = vec4(radiance, 1.0);
}
