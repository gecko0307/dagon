// Converts normalized device coordinates to eye space position
vec3 unproject(mat4 invProjMatrix, vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjMatrix * clipPos;
    return res.xyz / res.w;
}
