vec2 matcap(vec3 eye, vec3 normal)
{
    vec3 c = normal * 0.5 + vec3(0.5);
    return vec2(c.x, 1.0 - c.y);
}
