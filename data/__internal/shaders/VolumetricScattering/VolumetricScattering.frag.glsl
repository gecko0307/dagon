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
    vec3 L = lightVolumeEyePos - lightPosition;
    vec3 backFace = lightPosition + normalize(L) * scatteringRadius;
    vec3 OC = backFace - lightPosition;
    float b = dot(OC, E);
    float c = dot(OC, OC) - scatteringRadius * scatteringRadius;
    float discriminant = b * b - c;
    // Distance to the front face of the volume along the eye vector
    float thickness = max(0.0, -b + sqrt(discriminant));
    thickness = clamp(thickness, 0.0, lightRadius * 2.0);
    float falloff = pow(clamp(thickness / (scatteringRadius * 2.0), 0.0, 1.0), 16.0);
    // Mitigate "ghosting" artifact when light is behind the camera
    falloff *= 1.0 - clamp(lightPosition.z, 0.0, 1.0);
    vec3 radiance = toLinear(lightColor.rgb) * falloff * lightScatteringDensity;
    
    // Fog
    float linearDepth = abs(lightVolumeEyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance *= fogFactor;
    
    fragColor = vec4(radiance, 1.0);
}
