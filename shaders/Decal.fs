#version 400 core

uniform sampler2D positionBuffer;

uniform vec2 viewSize;

uniform mat4 invViewMatrix;
uniform mat4 invModelMatrix;

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

/*
 * Diffuse color subroutines.
 * Used to switch color/texture.
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColorValue(in vec2 uv)
{
    return diffuseVector;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseColorTexture(in vec2 uv)
{
    return texture(diffuseTexture, uv);
}

subroutine uniform srtColor diffuse;

layout(location = 0) out vec4 frag_color;

void main()
{
    vec2 gbufTexCoord = gl_FragCoord.xy / viewSize;

    vec3 eyePos = texture(positionBuffer, gbufTexCoord).xyz;

    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 objPos = (invModelMatrix * vec4(worldPos, 1.0)).xyz;

    // Perform bounds check to discard fragments outside the decal box
    if (abs(objPos.x) > 1.0) discard;
    if (abs(objPos.y) > 1.0) discard;
    if (abs(objPos.z) > 1.0) discard;
    
    // Texcoord (go from -1..1 to 0..1)
    vec2 texCoord = objPos.xz * 0.5 + 0.5;
    
    // Normal
    vec3 ddxWp = dFdx(worldPos);
    vec3 ddyWp = dFdy(worldPos);
    vec3 N = normalize(cross(ddyWp, ddxWp));
    
    vec4 d = diffuse(texCoord);
    vec3 color = toLinear(d.rgb);
    
    frag_color = vec4(color, d.a);
}
