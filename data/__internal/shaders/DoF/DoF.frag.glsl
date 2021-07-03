#version 400 core

#define PI 3.14159265
const float PI2 = PI * 2.0;

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;

uniform vec2 viewSize;
float width = viewSize.x;
float height = viewSize.y;
vec2 texel = vec2(1.0 / width, 1.0 / height);

uniform float zNear;
uniform float zFar;
uniform mat4 invProjectionMatrix;

const float focalDepth = 0.9; // overrided by autofocus option

int samples = 3; //samples on the first ring
int rings = 5; //ring count

bool autofocus = true; //use autofocus in shader?
float range = 1.0; //focal range
float maxblur = 5.0; //clamp value of max blur

float threshold = 50.0; //highlight threshold;
float gain = 8.0; //highlight gain;

float bias = 0.9; //bokeh edge bias
float fringe = 0.5; //bokeh chromatic aberration/fringing

bool noise = false; //use noise instead of pattern for sample dithering
float namount = 0.00001; //noise amount

bool depthblur = false; //blur the depth buffer?
float dbsize = 2.0; //depthblursize

in vec2 texCoord;
out vec4 fragColor;

float bdepth(vec2 coords) //blurring depth
{
    float d = 0.0;
    float kernel[9];
    vec2 offset[9];
    
    vec2 wh = vec2(texel.x, texel.y) * dbsize;
    
    offset[0] = vec2(-wh.x,-wh.y);
    offset[1] = vec2( 0.0, -wh.y);
    offset[2] = vec2( wh.x -wh.y);
    
    offset[3] = vec2( -wh.x, 0.0);
    offset[4] = vec2( 0.0,   0.0);
    offset[5] = vec2( wh.x,  0.0);
    
    offset[6] = vec2( -wh.x, wh.y);
    offset[7] = vec2( 0.0,   wh.y);
    offset[8] = vec2( wh.x,  wh.y);
    
    kernel[0] = 1.0/16.0;  kernel[1] = 2.0/16.0;  kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;  kernel[4] = 4.0/16.0;  kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;  kernel[7] = 2.0/16.0;  kernel[8] = 1.0/16.0;
    
    for( int i = 0; i < 9; i++ )
    {
        float tmp = texture(depthBuffer, coords + offset[i]).r;
        d += tmp * kernel[i];
    }
    
    return d;
}

vec3 color(vec2 coords, float blur) //processing the sample
{
    vec3 col = vec3(0.0);
    
    col.r = texture(colorBuffer, coords + vec2(0.0,1.0)*texel*fringe*blur).r;
    col.g = texture(colorBuffer, coords + vec2(-0.866,-0.5)*texel*fringe*blur).g;
    col.b = texture(colorBuffer, coords + vec2(0.866,-0.5)*texel*fringe*blur).b;
    
    vec3 lumcoeff = vec3(0.299,0.587,0.114);
    float lum = dot(col.rgb, lumcoeff);
    float thresh = max((lum - threshold)*gain, 0.0);
    return col + mix(vec3(0.0),col,thresh*blur);
}

vec2 rand(in vec2 coord) //generating noise/pattern texture for dithering
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

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    
    if (enabled)
    {
        float depth = texture(depthBuffer, texCoord).x;
        float blur = 0.0;
        
        if (depthblur)
        {
            depth = bdepth(texCoord);
        }
        
        //blur = clamp((depth - 0.95) * 6.0, 0.0, maxblur);
        blur = clamp((abs(depth - focalDepth)/range)*(maxblur/float(rings)),-maxblur,maxblur);
        
        if (autofocus)
        {
            float fDepth = texture(depthBuffer, vec2(0.5, 0.5)).x;
            blur = clamp((abs(depth - fDepth)/range)*100.0,-maxblur,maxblur);
        }
        
        vec2 noise = rand(texCoord)*namount*blur;
        
        float w = (1.0/width)*blur+noise.x;
        float h = (1.0/height)*blur+noise.y;
        
        float s = 1.0;
        
        int ringsamples;
        
        for (int i = 1; i <= rings; i += 1)
        {
            ringsamples = i * samples;
            
            for (int j = 0 ; j < ringsamples; j += 1)
            {
                float step = PI2 / float(ringsamples);
                float pw = (cos(float(j)*step)*float(i));
                float ph = (sin(float(j)*step)*float(i));
                res += color(texCoord + vec2(pw*w,ph*h), blur) * mix(1.0, (float(i))/(float(rings)),bias);
                s += 1.0 * mix(1.0,(float(i))/(float(rings)),bias);
            }
        }

        res /= s;
    }

    fragColor = vec4(res, 1.0);
}
