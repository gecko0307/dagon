float shadowLookup(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in vec2 offset)
{
    float texelSize = 1.0 / shadowResolution;
    vec2 v = offset * texelSize * coord.w;
    vec4 c = (coord + vec4(v.x, v.y, 0.0, 0.0)) / coord.w;
    c.w = c.z;
    c.z = layer;
    float s = texture(depths, c);
    return s;
}

float shadowLookupPCF(in sampler2DArrayShadow depths, in float layer, in vec4 coord, in float radius)
{
    float s = 0.0;
    float x, y;
    for (y = -radius ; y < radius ; y += 1.0)
    for (x = -radius ; x < radius ; x += 1.0)
    {
        s += shadowLookup(depths, layer, coord, vec2(x, y));
    }
    s /= radius * radius * 4.0;
    return s;
}

float shadowCascadeWeight(in vec4 tc, in float coef)
{
    vec2 proj = vec2(tc.x / tc.w, tc.y / tc.w);
    proj = (1.0 - abs(proj * 2.0 - 1.0)) * coef;
    proj = clamp(proj, 0.0, 1.0);
    return min(proj.x, proj.y);
}
