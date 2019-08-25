#version 400 core

#define EPSILON 0.000001
#define PI 3.14159265
const float PI2 = PI * 2.0;

in vec3 vWorldPosition;
in float vSunfade;
in vec3 vBetaR;
in vec3 vBetaM;
in float vSunE;

in vec4 currPosition;
in vec4 prevPosition;

uniform vec3 cameraPosition;
uniform vec3 sunDirection;

//layout(location = 0) out vec4 fragColor;
layout(location = 3) out vec4 fragRadiance;
layout(location = 4) out vec4 fragVelocity;

const float mieDirectionalG = 0.8;

const float n = 1.0003; // refractive index of air
const float N = 2.545E25; // number of molecules per unit volume for air at 288.15K and 1013mb (sea level -45 celsius)

// optical length at zenith for molecules
const float rayleighZenithLength = 8.4E3;
const float mieZenithLength = 1.25E3;
const vec3 up = vec3( 0.0, 1.0, 0.0 );

const float sunAngularDiameterCos = 0.999956676946448443553574619906976478926848692873900859324;

// 3.0 / ( 16.0 * PI )
const float THREE_OVER_SIXTEENPI = 0.05968310365946075;
// 1.0 / ( 4.0 * PI )
const float ONE_OVER_FOURPI = 0.07957747154594767;

float rayleighPhase(float cosTheta)
{
    return THREE_OVER_SIXTEENPI * ( 1.0 + pow( cosTheta, 2.0 ) );
}

float hgPhase( float cosTheta, float g )
{
    float g2 = pow( g, 2.0 );
    float inverse = 1.0 / pow( 1.0 - 2.0 * g * cosTheta + g2, 1.5 );
    return ONE_OVER_FOURPI * ( ( 1.0 - g2 ) * inverse );
}

void main()
{    
    float zenithAngle = acos( max( 0.0, dot( up, normalize( vWorldPosition - cameraPosition ) ) ) );
    float inverse = 1.0 / ( cos( zenithAngle ) + 0.15 * pow( 93.885 - ( ( zenithAngle * 180.0 ) / PI ), -1.253 ) );
    float sR = rayleighZenithLength * inverse;
    float sM = mieZenithLength * inverse;
    
    vec3 Fex = exp( -( vBetaR * sR + vBetaM * sM ) );
    
    float cosTheta = dot( normalize( vWorldPosition - cameraPosition ), sunDirection );
    float rPhase = rayleighPhase( cosTheta * 0.5 + 0.5 );
    vec3 betaRTheta = vBetaR * rPhase;
    float mPhase = hgPhase( cosTheta, mieDirectionalG );
    vec3 betaMTheta = vBetaM * mPhase;
    
    vec3 Lin = pow( vSunE * ( ( betaRTheta + betaMTheta ) / ( vBetaR + vBetaM ) ) * ( 1.0 - Fex ), vec3( 1.5 ) );
    Lin *= mix( vec3( 1.0 ), pow( vSunE * ( ( betaRTheta + betaMTheta ) / ( vBetaR + vBetaM ) ) * Fex, vec3( 1.0 / 2.0 ) ), clamp( pow( 1.0 - dot( up, sunDirection ), 5.0 ), 0.0, 1.0 ) );
    
    vec3 L0 = vec3(0.1) * Fex;
    
    float sundisk = smoothstep(sunAngularDiameterCos, sunAngularDiameterCos + 0.00002, cosTheta);
    L0 += (vSunE * 19000.0 * Fex) * sundisk;
    L0 = pow(L0, vec3(1.0 / (1.0 + (1.0 * vSunfade))));
    vec3 color = (Lin + L0) * 0.04 + vec3(0.0, 0.0003, 0.00075);
    vec3 env = color; //pow(color, vec3(1.0 / (1.0 + (1.0 * vSunfade))));
    
    vec2 posScreen = (currPosition.xy / currPosition.w) * 0.5 + 0.5;
    vec2 prevPosScreen = (prevPosition.xy / prevPosition.w) * 0.5 + 0.5;
    vec2 velocity = posScreen - prevPosScreen;
    const float blurMask = 1.0; 

    //fragColor = vec4(env, 1.0);
    fragRadiance = vec4(env, 0.0);
    fragVelocity = vec4(velocity, blurMask, 0.0);
}
