module dagon.graphics.filters.lens;

import dagon.core.ownership;
import dagon.graphics.postproc;
import dagon.graphics.framebuffer;

class PostFilterLensDistortion: PostFilter
{
    string vs = q{
        void main()
        {	
            gl_Position = ftransform();		
            gl_TexCoord[0] = gl_MultiTexCoord0;
        }
    };

    string fs = q{
        #version 120
        uniform sampler2D fbColor;

        const float k = 0.1;
        const float kcube = 0.1;
        const float scale = 0.84;
        const float dispersion = 0.01;

        void main()
        {
            vec3 eta = vec3(1.0 + dispersion * 0.9, 1.0 + dispersion * 0.6, 1.0 + dispersion * 0.3);
            vec2 texcoord = gl_TexCoord[0].st;
            vec2 cancoord = gl_TexCoord[0].st;
            float r2 = (cancoord.x - 0.5) * (cancoord.x - 0.5) + (cancoord.y - 0.5) * (cancoord.y - 0.5);       
            float f = 0.0;
            f = (kcube == 0.0)? 1.0 + r2 * (k + kcube * sqrt(r2)) : 1.0 + r2 * k;
            vec2 coef = f * scale * (texcoord.xy - 0.5);
            vec2 rCoords = eta.r * coef + 0.5;
            vec2 gCoords = eta.g * coef + 0.5;
            vec2 bCoords = eta.b * coef + 0.5;
            vec4 inputDistort = vec4(0.0); 
            inputDistort.r = texture2D(fbColor, rCoords).r;
            inputDistort.g = texture2D(fbColor, gCoords).g;
            inputDistort.b = texture2D(fbColor, bCoords).b;
            inputDistort.a = 1.0;
            gl_FragColor = inputDistort;
            gl_FragColor.a = 1.0;
        }
    };

    override string vertexShader()
    {
        return vs;
    }

    override string fragmentShader()
    {
        return fs;
    }

    this(Framebuffer fb, Owner o)
    {
        super(fb, o);
    }
}
