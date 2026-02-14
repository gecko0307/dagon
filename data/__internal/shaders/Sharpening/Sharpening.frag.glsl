#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform vec2 viewSize;
uniform float sharpening; // 0.0 – 1.0

float luminance(vec3 c)
{
    return dot(c, vec3(0.299, 0.587, 0.114));
}

in vec2 texCoord;
out vec4 fragColor;

void main()
{
    vec2 fragCoord = gl_FragCoord.xy;

    if (enabled)
    {
        vec2 t = 1.0 / viewSize;

        // 3x3 neighborhood
        vec3 a = texture(colorBuffer, texCoord + vec2(-t.x, -t.y)).rgb;
        vec3 b = texture(colorBuffer, texCoord + vec2( 0.0, -t.y)).rgb;
        vec3 c = texture(colorBuffer, texCoord + vec2( t.x, -t.y)).rgb;

        vec3 d = texture(colorBuffer, texCoord + vec2(-t.x,  0.0)).rgb;
        vec3 e = texture(colorBuffer, texCoord).rgb;
        vec3 f = texture(colorBuffer, texCoord + vec2( t.x,  0.0)).rgb;

        vec3 g = texture(colorBuffer, texCoord + vec2(-t.x,  t.y)).rgb;
        vec3 h = texture(colorBuffer, texCoord + vec2( 0.0,  t.y)).rgb;
        vec3 i = texture(colorBuffer, texCoord + vec2( t.x,  t.y)).rgb;

        float la = luminance(a);
        float lb = luminance(b);
        float lc = luminance(c);
        float ld = luminance(d);
        float le = luminance(e);
        float lf = luminance(f);
        float lg = luminance(g);
        float lh = luminance(h);
        float li = luminance(i);

        float mn = min(le, min(min(lb, ld), min(lf, lh)));
        float mx = max(le, max(max(lb, ld), max(lf, lh)));

        float contrast = mx - mn;
        float amp = clamp(contrast > 0.0 ? (min(mn, 1.0 - mx) / mx) : 0.0, 0.0, 1.0);
        amp = sqrt(amp);

        float peak = mix(8.0, 5.0, sharpening);
        float weight = -amp / peak;

        vec3 sharpened = (b + d + f + h) * weight + e;

        float norm = 1.0 + 4.0 * weight;
        sharpened /= norm;

        fragColor = vec4(clamp(sharpened, 0.0, 1.0), 1.0);
    }
    else
    {
        vec3 color = texture(colorBuffer, texCoord).xyz;
        fragColor = vec4(color, 1.0); 
    }
}
