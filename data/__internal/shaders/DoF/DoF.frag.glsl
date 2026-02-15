#version 400 core

#define PI 3.14159265
const float PI2 = PI * 2.0;

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;

/*
 * Depth of Field effect based on code by Martins Upitis (martinsh).
 * Licensed under a Creative Commons Attribution 3.0 Unported License.
 */

uniform vec2 viewSize;
float width = viewSize.x;
float height = viewSize.y;
vec2 texel = vec2(1.0 / width, 1.0 / height);

uniform float zNear;
uniform float zFar;
uniform mat4 invProjectionMatrix;

uniform bool autofocus; // use autofocus in shader?
uniform float focalDepth; // focal distance in meters for manual focus
uniform float focalLength; // focal length in mm
uniform float fstop; // f-stop value

uniform bool manual; //manual dof calculation
uniform float nearStart; // near dof blur start
uniform float nearDistance; // near dof blur falloff distance
uniform float farStart; // far dof blur start
uniform float farDistance; // far dof blur falloff distance

uniform float CoC = 0.03; // circle of confusion size in mm (35mm film = 0.03mm)

const bool showFocus = false; //show debug focus point and focal range (red = focal point, green = focal range)

const int samples = 4; // samples on the first ring
const int rings = 5; // ring count

const vec2 focus = vec2(0.5, 0.5); // autofocus point on screen (0.0, 0.0 - left lower corner, 1.0, 1.0 - upper right)
const float maxblur = 2.0; //clamp value of max blur (0.0 = no blur, 1.0 default)

const float bias = 0.5; // bokeh edge bias
const float fringe = 0.7; // bokeh chromatic aberration/fringing

const bool noise = true; // use noise instead of pattern for sample dithering
const float namount = 0.0001; // dither amount

const bool depthblur = false; // blur the depth buffer?
const float dbsize = 1.25; // depthblursize

/*
 * Next part is experimental. Not looking good with small sample and ring count.
 * Looks okay starting from samples = 4, rings = 4
 */
uniform bool pentagon; // use pentagon as bokeh shape?
uniform float feather; // pentagon shape feather

in vec2 texCoord;
out vec4 fragColor;

float penta(vec2 coords) //pentagonal shape
{
    float scale = float(rings) - 1.3;
    vec4  HS0 = vec4( 1.0,         0.0,         0.0,  1.0);
    vec4  HS1 = vec4( 0.309016994, 0.951056516, 0.0,  1.0);
    vec4  HS2 = vec4(-0.809016994, 0.587785252, 0.0,  1.0);
    vec4  HS3 = vec4(-0.809016994,-0.587785252, 0.0,  1.0);
    vec4  HS4 = vec4( 0.309016994,-0.951056516, 0.0,  1.0);
    vec4  HS5 = vec4( 0.0        ,0.0         , 1.0,  1.0);
    
    vec4  one = vec4( 1.0 );
    
    vec4 P = vec4((coords),vec2(scale, scale)); 
    
    vec4 dist = vec4(0.0);
    float inorout = -4.0;
    
    dist.x = dot( P, HS0 );
    dist.y = dot( P, HS1 );
    dist.z = dot( P, HS2 );
    dist.w = dot( P, HS3 );
    
    dist = smoothstep( -feather, feather, dist );
    
    inorout += dot( dist, one );
    
    dist.x = dot( P, HS4 );
    dist.y = HS5.w - abs( P.z );
    
    dist = smoothstep( -feather, feather, dist );
    inorout += dist.x;
    
    return clamp( inorout, 0.0, 1.0 );
}

float bdepth(vec2 coords) // blurring depth
{
    float d = 0.0;
    float kernel[9];
    vec2 offset[9];
    
    vec2 wh = vec2(texel.x, texel.y) * dbsize;
    
    offset[0] = vec2(-wh.x,-wh.y);
    offset[1] = vec2( 0.0, -wh.y);
    offset[2] = vec2( wh.x -wh.y);
    
    offset[3] = vec2(-wh.x,  0.0);
    offset[4] = vec2( 0.0,   0.0);
    offset[5] = vec2( wh.x,  0.0);
    
    offset[6] = vec2(-wh.x, wh.y);
    offset[7] = vec2( 0.0,  wh.y);
    offset[8] = vec2( wh.x, wh.y);
    
    kernel[0] = 1.0/16.0;   kernel[1] = 2.0/16.0;   kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;   kernel[4] = 4.0/16.0;   kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;   kernel[7] = 2.0/16.0;   kernel[8] = 1.0/16.0;
    
    for( int i=0; i<9; i++ )
    {
        float tmp = texture(depthBuffer, coords + offset[i]).r;
        d += tmp * kernel[i];
    }
    
    return d;
}

vec3 color(vec2 coords, float blur) // processing the sample
{
    vec3 col = vec3(0.0);
    col.r = texture(colorBuffer, coords + vec2(0.0, 1.0) * texel * fringe * blur).r;
    col.g = texture(colorBuffer, coords + vec2(-0.866, -0.5) * texel * fringe * blur).g;
    col.b = texture(colorBuffer, coords + vec2(0.866, -0.5) * texel * fringe * blur).b;
    return col;
}

vec2 rand(vec2 coord) // generating noise/pattern texture for dithering
{
    float noiseX = ((fract(1.0-coord.s*(width/2.0))*0.25)+(fract(coord.t*(height/2.0))*0.75))*2.0-1.0;
    float noiseY = ((fract(1.0-coord.s*(width/2.0))*0.75)+(fract(coord.t*(height/2.0))*0.25))*2.0-1.0;
    
    if (noise)
    {
        noiseX = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233))) * 43758.5453),0.0,1.0)*2.0-1.0;
        noiseY = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233)*2.0)) * 43758.5453),0.0,1.0)*2.0-1.0;
    }
    return vec2(noiseX,noiseY);
}

vec3 debugFocus(vec3 col, float blur, float depth)
{
    float edge = 0.002*depth; // distance based edge smoothing
    float m = clamp(smoothstep(0.0,edge,blur),0.0,1.0);
    float e = clamp(smoothstep(1.0-edge,1.0,blur),0.0,1.0);
    
    col = mix(col,vec3(1.0,0.5,0.0),(1.0-m)*0.6);
    col = mix(col,vec3(0.0,0.5,1.0),((1.0-e)-(1.0-m))*0.2);

    return col;
}

float linearize(float depth)
{
    return -zFar * zNear / (depth * (zFar - zNear) - zFar);
}

void main() 
{
    //scene depth calculation
    vec3 col = texture(colorBuffer, texCoord).rgb;
    
    if (enabled)
    {
        float depth = linearize(texture(depthBuffer, texCoord.xy).x);
        if (depthblur)
        {
            depth = linearize(bdepth(texCoord.xy));
        }
        
        // focal plane calculation
        float fDepth = focalDepth;
        if (autofocus)
        {
            fDepth = linearize(texture(depthBuffer, focus).x);
        }
        
        // dof blur factor calculation
        float blur = 0.0;
        if (manual)
        {    
            float a = depth-fDepth; // focal plane
            float b = (a - farStart) / farDistance; // far DoF
            float c = (-a - nearStart) / nearDistance; // near Dof
            blur = (a > 0.0)? b : c;
        }
        else
        {
            float f = focalLength; // focal length in mm
            float d = fDepth * 1000.0; // focal plane in mm
            float o = depth * 1000.0; // depth in mm
            float a = (o * f) / (o - f); 
            float b = (d * f) / (d - f); 
            float c = (d - f) / (d * fstop * CoC); 
            blur = abs(a - b) * c;
        }
        
        blur = clamp(blur, 0.0, 1.0);
        
        // calculation of pattern for ditering
        vec2 noise = rand(texCoord.xy) * namount * blur;
        
        // getting blur x and y step factor
        float w = (1.0 / width) * blur * maxblur + noise.x;
        float h = (1.0 / height) * blur * maxblur + noise.y;
        
        // calculation of final color
        if (blur >= 0.05)
        {
            col = texture(colorBuffer, texCoord.xy).rgb;
            float s = 1.0;
            int ringsamples;
            
            for (int i = 1; i <= rings; i += 1)
            {   
                ringsamples = i * samples;
                
                for (int j = 0 ; j < ringsamples ; j += 1)
                {
                    float step = PI * 2.0 / float(ringsamples);
                    float pw = (cos(float(j) * step) * float(i));
                    float ph = (sin(float(j) * step) * float(i));
                    float p = 1.0;
                    if (pentagon)
                    { 
                        p = penta(vec2(pw, ph));
                    }
                    col += color(texCoord.xy + vec2(pw * w, ph * h), blur) * 
                           mix(1.0, (float(i)) / (float(rings)), bias) * p;
                    s += 1.0*mix(1.0, (float(i)) / (float(rings)), bias) * p;
                }
            }
            col /= s; //divide by sample count
        }
        
        if (showFocus)
        {
            col = debugFocus(col, blur, depth);
        }
    }
    
    fragColor = vec4(col, 1.0);
}
