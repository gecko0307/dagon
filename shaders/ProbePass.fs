#version 400 core

#define PI 3.14159265359

uniform sampler2D colorBuffer;
uniform sampler2D rmsBuffer;
uniform sampler2D positionBuffer;
uniform sampler2D normalBuffer;
uniform samplerCube cubemap;

uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;

uniform vec2 viewSize;

uniform vec3 probePosition;

in vec3 worldView;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

vec3 fresnel(float cosTheta, vec3 f0)
{
    return f0 + (1.0 - f0) * pow(1.0 - cosTheta, 5.0);
}

vec3 fresnelRoughness(float cosTheta, vec3 f0, float roughness)
{
    return f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(1.0 - cosTheta, 5.0);
}

vec3 bpcem(in vec3 pos, in vec3 v, in vec3 Emax, in vec3 Emin, in vec3 Epos)
{
    vec3 localPos = pos - Epos;
	vec3 nrdir = normalize(v);
	vec3 rbmax = (Emax - localPos)/nrdir;
	vec3 rbmin = (Emin - localPos)/nrdir;
	vec3 rbminmax = max(rbmax, rbmin);
	//rbminmax.x = (nrdir.x > 0.0)? rbmax.x : rbmin.x;
	//rbminmax.y = (nrdir.y > 0.0)? rbmax.y : rbmin.y;
	//rbminmax.z = (nrdir.z > 0.0)? rbmax.z : rbmin.z;		
	float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);
	vec3 posonbox = pos + nrdir * fa;
	return posonbox - Epos;
}

float luminance(vec3 color)
{
    return (
        color.x * 0.2126 +
        color.y * 0.7152 +
        color.z * 0.0722
    );
}

layout(location = 0) out vec4 frag_color;
layout(location = 1) out vec4 frag_luminance;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / viewSize;

    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = toLinear(col.rgb);

    vec4 rms = texture(rmsBuffer, texCoord);
    float roughness = rms.r;
    float metallic = rms.g;

    vec3 eyePos = texture(positionBuffer, texCoord).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).xyz);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);

    vec3 f0 = vec3(0.04); 
    f0 = mix(f0, albedo, metallic);
    
    vec3 worldCamPos = (invViewMatrix[3]).xyz;

    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 worldN = N * mat3(viewMatrix);
    vec3 worldE = normalize(worldPos - worldCamPos);
    vec3 worldR = reflect(normalize(worldE), worldN);
    
    vec3 radiance = vec3(0.0, 0.0, 0.0);
    
        const float probeRadius = 5.0;
        vec3 positionToProbe = probePosition - eyePos;
        float distanceToProbe = length(positionToProbe);   
        float attenuation = pow(clamp(1.0 - (distanceToProbe / probeRadius), 0.0, 1.0), 2.0);
    
    // Ambient light
    {       
        vec3 cR = bpcem(worldPos, worldR, vec3(5, 5, 5), vec3(-5, -5, -5), probePosition);
        vec3 cN = bpcem(worldPos, worldN, vec3(5, 5, 5), vec3(-5, -5, -5), probePosition);
        
        vec3 ambientDiffuse = textureLod(cubemap, cN, 10.0).rgb;
        vec3 ambientSpecular = textureLod(cubemap, cR, 10.0 * roughness).rgb;

        vec3 F = fresnelRoughness(max(dot(N, E), 0.0), f0, roughness);
        vec3 kS = F;
        vec3 kD = 1.0 - kS;
        kD *= 1.0 - metallic;
        radiance += kD * ambientDiffuse * albedo + F * ambientSpecular;
    }

    frag_color = vec4(radiance, attenuation);
    frag_luminance = vec4(luminance(radiance), 0.0, 0.0, attenuation);
}
