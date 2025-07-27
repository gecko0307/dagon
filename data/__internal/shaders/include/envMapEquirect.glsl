vec2 envMapEquirect(vec3 dir)
{
    float u = 1.0 - (atan(dir.x, dir.z) / PI2 + 0.5);
    float v = acos(dir.y) / PI;
    return vec2(u, v);
}
