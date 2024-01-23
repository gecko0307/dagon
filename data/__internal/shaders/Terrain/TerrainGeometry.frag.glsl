#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;
in vec2 texCoord;

in vec4 currPosition;
in vec4 prevPosition;

uniform float gbufferMask;
uniform float blurMask;

layout(location = 0) out vec4 fragNormal;
layout(location = 1) out vec4 fragTexcoord;
layout(location = 2) out vec4 fragVelocity;
layout(location = 3) out vec4 fragEmission;

void main()
{
    vec3 N = normalize(eyeNormal);
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    
    fragNormal = vec4(N, gbufferMask);
    fragTexcoord = vec4(texCoord, gl_FragCoord.z, 1.0);
    fragVelocity = vec4(velocity, blurMask, 1.0);
    fragEmission = vec4(0.0, 0.0, 0.0, 0.0);
}
