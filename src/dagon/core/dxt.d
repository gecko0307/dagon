/*
BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above
   copyright notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Fast DXT1/DXT5 texture encoder based on RygsDXTc.
 *
 * Copyright: Fabian Giesen, Yann Collet
 * License: $(LINK2 http://www.opensource.org/licenses/bsd-license.php, 2-Clause BSD License).
 * Authors: Fabian Giesen, Yann Collet
 */
module dagon.core.dxt;

/*
 * RygsDXTc - real-time DXT1/DXT5 compressor
 * https://github.com/Cyan4973/RygsDXTc
 * Based on original rygDXT v1.04 by Fabian Giesen aka ryg
 * Custom version, modified by Yann Collet aka cyan
 * D port by Timur Gafarov
 *
 * Usage:
 *  call stb_compress_dxt_block() for every block (you must pad)
 *  source should be a 4x4 block of RGBA data in row-major order;
 *  A is ignored if you specify alpha = 0; you can turn on dithering
 *  and "high quality" using mode.
 *
 * Version history:
 *  v1.06  - (cyan) implement Fabian Giesen's comments
 *  v1.05  - (cyan) speed optimizations
 *  v1.04  - (ryg) default to no rounding bias for lerped colors (as per S3TC/DX10 spec);
 *           single color match fix (allow for inexact color interpolation);
 *           optimal DXT5 index finder; "high quality" mode that runs multiple refinement steps.
 *  v1.03  - (stb) endianness support
 *  v1.02  - (stb) fix alpha encoding bug
 *  v1.01  - (stb) fix bug converting to RGB that messed up quality, thanks ryg & cbloom
 *  v1.00  - (stb) first release
 */

/*
 * Yann Collet's optimizations.
 * Comment this if you want to revert to ryg's original code.
 */
version = NEW_OPTIMIZATIONS;

/// Compression mode (bitflags).
enum STB_DXT_NORMAL = 0;
enum STB_DXT_DITHER = 1;   // Use dithering. Dubious win. Never use for normal maps and the like!
enum STB_DXT_HIGHQUAL = 2; // High quality mode, does two refinement steps instead of 1. ~30-40% slower.

// TODO: remove these, not working properly

version = STB_COMPRESS_DXT_BLOCK;

/*
 * Use a rounding bias during color interpolation.
 * This is closer to what "ideal" interpolation would do but doesn't match the S3TC/DX10 spec.
 * Old versions (pre-1.03) implicitly had this turned on. 
 * In case you're targeting a specific type of hardware (e.g. consoles):
 * NVidia and Intel GPUs (as of 2010) as well as DX9 ref use DXT decoders that are closer
 * to STB_DXT_USE_ROUNDING_BIAS. AMD/ATI, S3 and DX10 ref are closer to rounding with no bias.
 * you also see "(a * 5 + b * 3) / 8" on some old GPU designs.
 */
// version = STB_DXT_USE_ROUNDING_BIAS;

import core.stdc.stdlib;
import core.stdc.math;
import core.stdc.stddef;
import core.stdc.string;
import core.stdc.assert_;

private
{
    __gshared ubyte[32] stb__Expand5;
    __gshared ubyte[64] stb__Expand6;
    __gshared ubyte[2][256] stb__OMatch5;
    __gshared ubyte[2][256] stb__OMatch6;
    __gshared ubyte[256+16] stb__QuantRBTab;
    __gshared ubyte[256+16] stb__QuantGTab;
}

private int stb__Mul8Bit(int a, int b)
{
    int t = a*b + 128;
    return (t + (t >> 8)) >> 8;
}

private void stb__From16Bit(ubyte* out_, ushort v)
{
    int rv = (v & 0xf800) >> 11;
    int gv = (v & 0x07e0) >> 5;
    int bv = (v & 0x001f) >> 0;
    out_[0] = stb__Expand5[rv];
    out_[1] = stb__Expand6[gv];
    out_[2] = stb__Expand5[bv];
    out_[3] = 0;
}

private ushort stb__As16Bit(int r, int g, int b)
{
    return cast(ushort)(
        (stb__Mul8Bit(r, 31) << 11) + 
        (stb__Mul8Bit(g, 63) << 5) + 
        stb__Mul8Bit(b, 31)
    );
}

/// Linear interpolation at 1/3 point between a and b, using desired rounding type.
private int stb__Lerp13(int a, int b)
{
    version(STB_DXT_USE_ROUNDING_BIAS)
    {
        // With rounding bias
        return a + stb__Mul8Bit(b - a, 0x55);
    }
    else
    {
        // Without rounding bias.
        // Replace "/ 3" by "* 0xaaab) >> 17"
        // if your compiler sucks or you really need every ounce of speed.
        return (2 * a + b) / 3;
    }
}

/// Lerp RGB color.
private void stb__Lerp13RGB(ubyte* out_, ubyte* p1, ubyte* p2)
{
    out_[0] = cast(ubyte)stb__Lerp13(p1[0], p2[0]);
    out_[1] = cast(ubyte)stb__Lerp13(p1[1], p2[1]);
    out_[2] = cast(ubyte)stb__Lerp13(p1[2], p2[2]);
}

/****************************************************************************/

/// Compute table to reproduce constant colors as accurately as possible
private void stb__PrepareOptTable(ubyte* Table, const(ubyte)* expand, int size)
{
    int i, mn, mx;
    for (i = 0; i < 256; i++)
    {
        int bestErr = 256;
        for (mn = 0; mn < size; mn++)
        {
            for (mx = 0; mx < size; mx++)
            {
                int mine = expand[mn];
                int maxe = expand[mx];
                int err = abs(stb__Lerp13(maxe, mine) - i);
                
                // DX10 spec says that interpolation must be within 3% of "correct" result,
                // add this as error term. (normally we'd expect a random distribution of
                // +-1.5% error, but nowhere in the spec does it say that the error has to be
                // unbiased - better safe than sorry).
                err += abs(maxe - mine) * 3 / 100;
                
                if (err < bestErr)
                {
                   Table[i * 2 + 0] = cast(ubyte)mx;
                   Table[i * 2 + 1] = cast(ubyte)mn;
                   bestErr = err;
                }
            }
        }
    }
}

private void stb__EvalColors(ubyte* color, ushort c0, ushort c1)
{
    stb__From16Bit(color + 0, c0);
    stb__From16Bit(color + 4, c1);
    stb__Lerp13RGB(color + 8, color + 0, color + 4);
    stb__Lerp13RGB(color +12, color + 4, color + 0);
}

/// Floyd-Steinberg block dithering function. Dithers a block to 565 RGB.
private void stb__DitherBlock(ubyte* dest, ubyte* block)
{
    int[8] err;
    int* ep1 = err.ptr, ep2 = err.ptr+4, et;
    int ch, y;

    // process channels seperately
    for (ch = 0; ch < 3; ++ch)
    {
        ubyte* bp = block+ch, dp = dest+ch;
        ubyte* quant = (ch == 1) ? stb__QuantGTab.ptr + 8 : stb__QuantRBTab.ptr + 8;
        memset(err.ptr, 0, err.sizeof);
        for (y = 0; y < 4; ++y)
        {
            dp[0] = quant[bp[0] + ((3 * ep2[1] + 5 * ep2[0]) >> 4)];
            ep1[0] = bp[0] - dp[0];
            dp[4] = quant[bp[4] + ((7 * ep1[0] + 3 * ep2[2] + 5 * ep2[1] + ep2[0]) >> 4)];
            ep1[1] = bp[4] - dp[4];
            dp[8] = quant[bp[8] + ((7 * ep1[1] + 3 * ep2[3] + 5 * ep2[2] + ep2[1]) >> 4)];
            ep1[2] = bp[8] - dp[8];
            dp[12] = quant[bp[12] + ((7 * ep1[2] + 5 * ep2[3] + ep2[2]) >> 4)];
            ep1[3] = bp[12] - dp[12];
            bp += 16;
            dp += 16;
            et = ep1, ep1 = ep2, ep2 = et; // swap
        }
    }
}

/// The color matching function.
private uint stb__MatchColorsBlock(ubyte* block, ubyte* color, int dither)
{
    uint mask = 0;
    int dirr = color[0 * 4 + 0] - color[1 * 4 + 0];
    int dirg = color[0 * 4 + 1] - color[1 * 4 + 1];
    int dirb = color[0 * 4 + 2] - color[1 * 4 + 2];
    int[16] dots = void;
    int[4] stops = void;
    int i = 0;
    int c0Point = void, halfPoint = void, c3Point = void;

    for (i = 0; i < 16; i++)
        dots[i] =
            block[i * 4 + 0] * dirr +
            block[i * 4 + 1] * dirg +
            block[i * 4 + 2] * dirb;

    for (i = 0; i < 4; i++)
        stops[i] =
            color[i * 4 + 0] * dirr +
            color[i * 4 + 1] * dirg +
            color[i * 4 + 2] * dirb;

    // Think of the colors as arranged on a line; project point onto that line, then choose
    // next color out of available ones. We compute the crossover points for best color in top
    // half/best in bottom half and then the same inside that subinterval.
    // Relying on this 1D approximation isn't always optimal in terms of Euclidean distance,
    // but it's very close and a lot faster.
    // http://cbloomrants.blogspot.com/2008/12/12-08-08-dxtc-summary.html
   
    c0Point   = (stops[1] + stops[3]) >> 1;
    halfPoint = (stops[3] + stops[2]) >> 1;
    c3Point   = (stops[2] + stops[0]) >> 1;

    if (!dither)
    {
        // the version without dithering is straightforward
        version (NEW_OPTIMIZATIONS)
        {
            const(int)[8] indexMap = [
                0 << 30, 2 << 30, 0 << 30, 2 << 30, 3 << 30, 3 << 30, 1 << 30, 1 << 30
            ];
            
            for (i = 0; i < 16; i++)
            {
                int dot = dots[i];
                mask >>= 2;
                int bits = ((dot < halfPoint) ? 4 : 0)
                         | ((dot < c0Point)   ? 2 : 0)
                         | ((dot < c3Point)   ? 1 : 0);
                mask |= indexMap[bits];
            }
        }
        else
        {
            for (i = 15; i >= 0; i--)
            {
                int dot = dots[i];
                mask <<= 2;
                if (dot < halfPoint)
                    mask |= (dot < c0Point) ? 1 : 3;
                else
                    mask |= (dot < c3Point) ? 2 : 0;
            }
        }
    }
    else
    {
        // Floyd-Steinberg dithering
        int[8] err;
        int* ep1 = err.ptr, ep2 = err.ptr+4;
        int* dp = dots.ptr;
        int y;

        c0Point   <<= 4;
        halfPoint <<= 4;
        c3Point   <<= 4;
        for(i = 0; i < 8; i++)
            err[i] = 0;

        for(y = 0; y < 4; y++)
        {
            int dot, lmask, step;

            dot = (dp[0] << 4) + (3 * ep2[1] + 5 * ep2[0]);
            if(dot < halfPoint)
                step = (dot < c0Point) ? 1 : 3;
            else
                step = (dot < c3Point) ? 2 : 0;
            ep1[0] = dp[0] - stops[step];
            lmask = step;

            dot = (dp[1] << 4) + (7 * ep1[0] + 3 * ep2[2] + 5 * ep2[1] + ep2[0]);
            if (dot < halfPoint)
                step = (dot < c0Point) ? 1 : 3;
            else
                step = (dot < c3Point) ? 2 : 0;
            ep1[1] = dp[1] - stops[step];
            lmask |= step << 2;

            dot = (dp[2] << 4) + (7 * ep1[1] + 3 * ep2[3] + 5 * ep2[2] + ep2[1]);
            if (dot < halfPoint)
                step = (dot < c0Point) ? 1 : 3;
            else
                step = (dot < c3Point) ? 2 : 0;
            ep1[2] = dp[2] - stops[step];
            lmask |= step << 4;

            dot = (dp[3] << 4) + (7 * ep1[2] + 5 * ep2[3] + ep2[2]);
            if (dot < halfPoint)
                step = (dot < c0Point) ? 1 : 3;
            else
                step = (dot < c3Point) ? 2 : 0;
            ep1[3] = dp[3] - stops[step];
            lmask |= step<<6;

            dp += 4;
            mask |= lmask << (y*8);
            { int* et = ep1; ep1 = ep2; ep2 = et; } // swap
        }
    }

    return mask;
}

/// The color optimization function (Clever code, part 1).
private void stb__OptimizeColorsBlock(ubyte* block, ushort* pmax16, ushort* pmin16)
{
    ubyte* minp, maxp;
    double magn = 0.0;
    int v_r, v_g, v_b;
    static const(int) nIterPower = 4;
    float[6] covf;
    float vfr = 0.0f, vfg = 0.0f, vfb = 0.0f;

    // determine color distribution
    int[6] cov;
    int[3] mu, min, max;
    int ch, i, iter;

    for(ch = 0; ch < 3; ch++)
    {
        const(ubyte)* bp = (cast(const(ubyte)*)block) + ch;
        int muv, minv, maxv;
        
        /++
        // OMG, let it rest in peace for now...
        version(NEW_OPTIMIZATIONS)
        {
            // TODO
            enum string MIN(string a,string b) = `cast(int)` ~ a ~ ` + ( (cast(int)` ~ b ~ `-` ~ a ~ `) & ( (cast(int)` ~ b ~ `-` ~ a ~ `) >> 31 ) )`;
            enum string MAX(string a,string b) = `cast(int)` ~ a ~ ` + ( (cast(int)` ~ b ~ `-` ~ a ~ `) & ( (cast(int)` ~ a ~ `-` ~ b ~ `) >> 31 ) )`;
            enum string RANGE(string a,string b,string n) = `int min##n = MIN(a,b); int max##n = a+b - min##n; muv += a+b;`;
            enum string MINMAX(string a,string b,string n) = `int min##n = MIN(min##a, min##b); int max##n = MAX(max##a, max##b); `;

            muv = 0;
            mixin(RANGE!(`bp[0]`,  `bp[4]`,  `1`));
            mixin(RANGE!(`bp[8]`,  `bp[12]`, `2`));
            mixin(RANGE!(`bp[16]`, `bp[20]`, `3`));
            mixin(RANGE!(`bp[24]`, `bp[28]`, `4`));
            mixin(RANGE!(`bp[32]`, `bp[36]`, `5`));
            mixin(RANGE!(`bp[40]`, `bp[44]`, `6`));
            mixin(RANGE!(`bp[48]`, `bp[52]`, `7`));
            mixin(RANGE!(`bp[56]`, `bp[60]`, `8`));

            mixin(MINMAX!(`1`,`2`,`9`));
            mixin(MINMAX!(`3`,`4`,`10`));
            mixin(MINMAX!(`5`,`6`,`11`));
            mixin(MINMAX!(`7`,`8`,`12`));

            mixin(MINMAX!(`9`,`10`,`13`));
            mixin(MINMAX!(`11`,`12`,`14`));

            minv = mixin(MIN!(`min13`,`min14`));
            maxv = mixin(MAX!(`max13`,`max14`));
        }
        else
        ++/
        {
            muv = minv = maxv = bp[0];
            for (i = 4; i < 64; i += 4)
            {
                muv += bp[i];
                if (bp[i] < minv)
                    minv = bp[i];
                else if (bp[i] > maxv)
                    maxv = bp[i];
            }
        }

        mu[ch] = (muv + 8) >> 4;
        min[ch] = minv;
        max[ch] = maxv;
    }

    // Determine covariance matrix
    for (i = 0; i < 6; i++)
        cov[i] = 0;

    for (i = 0; i < 16; i++)
    {
        int r = block[i * 4 + 0] - mu[0];
        int g = block[i * 4 + 1] - mu[1];
        int b = block[i * 4 + 2] - mu[2];

        cov[0] += r * r;
        cov[1] += r * g;
        cov[2] += r * b;
        cov[3] += g * g;
        cov[4] += g * b;
        cov[5] += b * b;
    }

    // Convert covariance matrix to float, find principal axis via power iter
    for (i = 0; i < 6; i++)
        covf[i] = cov[i] / 255.0f;

    vfr = cast(float)(max[0] - min[0]);
    vfg = cast(float)(max[1] - min[1]);
    vfb = cast(float)(max[2] - min[2]);

    for (iter = 0; iter < nIterPower; iter++)
    {
        float r = vfr * covf[0] + vfg * covf[1] + vfb * covf[2];
        float g = vfr * covf[1] + vfg * covf[3] + vfb * covf[4];
        float b = vfr * covf[2] + vfg * covf[4] + vfb * covf[5];

        vfr = r;
        vfg = g;
        vfb = b;
    }

    magn = fabs(vfr);
    if (fabs(vfg) > magn) magn = fabs(vfg);
    if (fabs(vfb) > magn) magn = fabs(vfb);

    if (magn < 4.0f) 
    {
        // Too small, default to luminance
        v_r = 299; // JPEG YCbCr luma coefs, scaled by 1000
        v_g = 587;
        v_b = 114;
    }
    else
    {
        magn = 512.0 / magn;
        v_r = cast(int)(vfr * magn);
        v_g = cast(int)(vfg * magn);
        v_b = cast(int)(vfb * magn);
    }

    version(NEW_OPTIMIZATIONS)
    {
        // Pick colors at extreme points
        int mind, maxd;
        mind = maxd = block[0] * v_r + block[1] * v_g + block[2] * v_b;
        minp = maxp = block;
        for (i = 1; i < 16; i++)
        {
            int dot =
                block[i * 4 + 0] * v_r +
                block[i * 4 + 1] * v_g +
                block[i * 4 + 2] * v_b;
            
            if (dot < mind)
            {
                mind = dot;
                minp = block + i * 4;
                continue;
            }

            if (dot > maxd)
            {
                maxd = dot;
                maxp = block + i * 4;
            }
        }
    }
    else
    {
        int mind = 0x7fffffff, maxd = -0x7fffffff;
        // Pick colors at extreme points
        for (i = 0; i < 16; i++)
        {
            int dot =
                block[i * 4 + 0] * v_r +
                block[i * 4 + 1] * v_g +
                block[i * 4 + 2] * v_b;
            
            if (dot < mind)
            {
                mind = dot;
                minp = block + i * 4;
            }

            if (dot > maxd)
            {
                maxd = dot;
                maxp = block + i * 4;
            }
        }
    }

    *pmax16 = stb__As16Bit(maxp[0], maxp[1], maxp[2]);
    *pmin16 = stb__As16Bit(minp[0], minp[1], minp[2]);
}

pragma(inline, true)
private int stb__sclamp(float y, int p0, int p1)
{
    int x = cast(int) y;

    version(NEW_OPTIMIZATIONS)
    {
        x = x > p1 ? p1 : x;
        return x < p0 ? p0 : x;
    }
    else
    {
        if (x < p0) return p0;
        if (x > p1) return p1;
        return x;
    }
}

/**
 * The refinement function (Clever code, part 2).
 * Tries to optimize colors to suit block contents better
 * (by solving a least squares system via normal equations + Cramer's rule).
 */
private int stb__RefineBlock(ubyte* block, ushort* pmax16, ushort* pmin16, uint mask)
{
    static const(int)[4] w1Tab = [3, 0, 2, 1];
    static const(int)[4] prods = [0x090000, 0x000900, 0x040102, 0x010402];
    // ^Some magic to save a lot of multiplies in the accumulating loop...
    // (precomputed products of weights for least squares system, accumulated inside one 32-bit register)

    float frb = 0.0f, fg = 0.0f;
    ushort oldMin, oldMax, min16, max16;
    int i, akku = 0, xx, xy, yy;
    int At1_r, At1_g, At1_b;
    int At2_r, At2_g, At2_b;
    uint cm = mask;

    oldMin = *pmin16;
    oldMax = *pmax16;

    if ((mask ^ (mask << 2)) < 4) // All pixels have the same index?
    {
        // Yes, linear system would be singular; solve using optimal
        // single-color match on average color
        int r = 8, g = 8, b = 8;
        for (i = 0; i < 16; ++i)
        {
            r += block[i * 4 + 0];
            g += block[i * 4 + 1];
            b += block[i * 4 + 2];
        }

        r >>= 4; g >>= 4; b >>= 4;

        max16 = cast(ushort)((stb__OMatch5[r][0] << 11) | (stb__OMatch6[g][0] << 5) | stb__OMatch5[b][0]);
        min16 = cast(ushort)((stb__OMatch5[r][1] << 11) | (stb__OMatch6[g][1] << 5) | stb__OMatch5[b][1]);
    }
    else
    {
        At1_r = At1_g = At1_b = 0;
        At2_r = At2_g = At2_b = 0;
        for (i = 0; i < 16; ++i, cm >>= 2) 
        {
            int step = cm & 3;
            int w1 = w1Tab[step];
            int r = block[i * 4 + 0];
            int g = block[i * 4 + 1];
            int b = block[i * 4 + 2];

            akku  += prods[step];
            At1_r += w1 * r;
            At1_g += w1 * g;
            At1_b += w1 * b;
            At2_r += r;
            At2_g += g;
            At2_b += b;
        }

        At2_r = 3 * At2_r - At1_r;
        At2_g = 3 * At2_g - At1_g;
        At2_b = 3 * At2_b - At1_b;

        // Extract solutions and decide solvability
        xx = akku >> 16;
        yy = (akku >> 8) & 0xff;
        xy = (akku >> 0) & 0xff;

        frb = 3.0f * 31.0f / 255.0f / (xx * yy - xy * xy);
        fg = frb * 63.0f / 31.0f;

        // Solve
        max16 =  cast(ushort)(stb__sclamp((At1_r * yy - At2_r * xy) * frb + 0.5f, 0, 31) << 11);
        max16 |= cast(ushort)(stb__sclamp((At1_g * yy - At2_g * xy) * fg  + 0.5f, 0, 63) << 5);
        max16 |= cast(ushort)(stb__sclamp((At1_b * yy - At2_b * xy) * frb + 0.5f, 0, 31) << 0);

        min16 =  cast(ushort)(stb__sclamp((At2_r * xx - At1_r * xy) * frb + 0.5f, 0, 31) << 11);
        min16 |= cast(ushort)(stb__sclamp((At2_g * xx - At1_g * xy) * fg  + 0.5f, 0, 63) << 5);
        min16 |= cast(ushort)(stb__sclamp((At2_b * xx - At1_b * xy) * frb + 0.5f, 0, 31) << 0);
    }

    *pmin16 = min16;
    *pmax16 = max16;
    return oldMin != min16 || oldMax != max16;
}

/// Color block compression.
private void stb__CompressColorBlock(ubyte* dest, ubyte* block, int mode)
{
    uint mask;
    int i;
    int dither;
    int refinecount;
    ushort max16, min16;
    ubyte[16 * 4] dblock;
    ubyte[4 * 4] color;
   
    dither = mode & STB_DXT_DITHER;
    refinecount = (mode & STB_DXT_HIGHQUAL) ? 2 : 1;

    // Check if block is constant
    for (i = 1; i < 16; i++)
        if ((cast(uint*)block)[i] != (cast(uint*)block)[0])
            break;

    if (i == 16) 
    {
        // Constant color
        int r = block[0], g = block[1], b = block[2];
        mask  = 0xaaaaaaaa;
        max16 = cast(ushort)((stb__OMatch5[r][0] << 11) | (stb__OMatch6[g][0] << 5) | stb__OMatch5[b][0]);
        min16 = cast(ushort)((stb__OMatch5[r][1] << 11) | (stb__OMatch6[g][1] << 5) | stb__OMatch5[b][1]);
    }
    else
    {
        // First step: compute dithered version for PCA if desired
        if (dither)
            stb__DitherBlock(dblock.ptr, block);
        
        // second step: pca+map along principal axis
        stb__OptimizeColorsBlock(dither ? dblock.ptr : block, &max16, &min16);
        if (max16 != min16) 
        {
            stb__EvalColors(color.ptr, max16, min16);
            mask = stb__MatchColorsBlock(block, color.ptr, dither);
        }
        else
            mask = 0;
        
        // Third step: refine (multiple times if requested)
        for (i = 0; i < refinecount; i++)
        {
            uint lastmask = mask;
            
            if (stb__RefineBlock(dither ? dblock.ptr : block, &max16, &min16, mask))
            {
                if (max16 != min16) 
                {
                    stb__EvalColors(color.ptr, max16, min16);
                    mask = stb__MatchColorsBlock(block, color.ptr, dither);
                }
                else
                {
                    mask = 0;
                    break;
                }
            }
            
            if (mask == lastmask)
                break;
        }
    }

    // Write the color block
    if (max16 < min16)
    {
        ushort t = min16;
        min16 = max16;
        max16 = t;
        mask ^= 0x55555555;
    }

    dest[0] = cast(ubyte)(max16);
    dest[1] = cast(ubyte)(max16 >> 8);
    dest[2] = cast(ubyte)(min16);
    dest[3] = cast(ubyte)(min16 >> 8);
    dest[4] = cast(ubyte)(mask);
    dest[5] = cast(ubyte)(mask >> 8);
    dest[6] = cast(ubyte)(mask >> 16);
    dest[7] = cast(ubyte)(mask >> 24);
}

// Alpha block compression (this is easy for a change)
private void stb__CompressAlphaBlock(ubyte* dest, ubyte* src, int mode)
{
    int i, dist, bias, dist4, dist2, bits, mask;

    // find min/max color
    int mn = void, mx = void;

    mn = mx = src[3];
    for (i = 1; i < 16; i++)
    {
        if (src[i * 4 + 3] < mn)
            mn = src[i * 4 + 3];
        else if (src[i * 4 + 3] > mx)
            mx = src[i * 4 + 3];
    }

    // Encode them
    (cast(ubyte*)dest)[0] = cast(ubyte)mx;
    (cast(ubyte*)dest)[1] = cast(ubyte)mn;
    dest += 2;

    version(NEW_OPTIMIZATIONS)
    {
        // Mono-alpha shortcut
        if (mn == mx)
        {
            *cast(ushort*)dest = 0;
            dest += 2;
            *cast(uint*)dest = 0;
            return;
        }
    }

    // Determine bias and emit color indices
    // given the choice of mx/mn, these indices are optimal:
    // http://fgiesen.wordpress.com/2009/12/15/dxt5-alpha-block-index-determination/
    dist = mx - mn;
    dist4 = dist * 4;
    dist2 = dist * 2;
    bias = (dist < 8) ? (dist - 1) : (dist / 2 + 2);
    bias -= mn * 7;
    bits = 0, mask = 0;
   
    for (i = 0; i < 16; i++)
    {
        int a = src[i * 4 + 3] * 7 + bias;
        int ind, t;

        // Select index. this is a "linear scale" lerp factor between 0 (val=min) and 7 (val=max).
        t = (a >= dist4) ? -1 : 0; ind =  t & 4; a -= dist4 & t;
        t = (a >= dist2) ? -1 : 0; ind += t & 2; a -= dist2 & t;
        ind += (a >= dist);
      
        // Turn linear scale into DXT index (0/1 are extremal pts)
        ind = -ind & 7;
        ind ^= (2 > ind);

        // Write index
        mask |= ind << bits;
        if ((bits += 3) >= 8)
        {
            *dest++ = cast(ubyte)mask;
            mask >>= 8;
            bits -= 8;
        }
    }
}

private void stb__InitDXT()
{
    int i;
    for (i = 0; i < 32; i++)
        stb__Expand5[i] = cast(ubyte)((i << 3) | (i >> 2));

    for (i = 0; i < 64; i++)
        stb__Expand6[i] = cast(ubyte)((i << 2) | (i >> 4));

    for (i = 0; i < 256 + 16; i++)
    {
        int v = i - 8 < 0 ? 0 : i - 8 > 255 ? 255 : i - 8;
        stb__QuantRBTab[i] = stb__Expand5[stb__Mul8Bit(v, 31)];
        stb__QuantGTab[i] = stb__Expand6[stb__Mul8Bit(v, 63)];
    }

    stb__PrepareOptTable(&stb__OMatch5[0][0], stb__Expand5.ptr, 32);
    stb__PrepareOptTable(&stb__OMatch6[0][0], stb__Expand6.ptr, 64);
}

void stb_compress_dxt_block(ubyte* dest, const(ubyte)* src, int alpha, int mode)
{
    static int init = 1;
    if (init) 
    {
        stb__InitDXT();
        init = 0;
    }

    if (alpha) 
    {
        stb__CompressAlphaBlock(dest, cast(ubyte*)src, mode);
        dest += 8;
    }

    stb__CompressColorBlock(dest, cast(ubyte*)src, mode);
}

int imin(int x, int y)
{
    return (x < y) ? x : y;
}

private void extractBlock(const(ubyte)* src, int x, int y, int w, int h, ubyte* block)
{
    int i, j;

    version (NEW_OPTIMIZATIONS)
    {
        if ((w - x >= 4) && (h - y >= 4))
        {
            // Full square shortcut
            src += x * 4;
            src += y * w * 4;
            for (i = 0; i < 4; ++i)
            {
                *cast(uint*)block = *cast(uint*) src; block += 4; src += 4;
                *cast(uint*)block = *cast(uint*) src; block += 4; src += 4;
                *cast(uint*)block = *cast(uint*) src; block += 4; src += 4;
                *cast(uint*)block = *cast(uint*) src; block += 4; 
                src += (w * 4) - 12;
            }
            
            return;
        }
    }

    int bw = imin(w - x, 4);
    int bh = imin(h - y, 4);
    int bx, by;
    
    const(int)[16] rem = [
        0, 0, 0, 0,
        0, 1, 0, 1,
        0, 1, 2, 0,
        0, 1, 2, 3
    ];
    
    for (i = 0; i < 4; ++i)
    {
        by = rem[(bh - 1) * 4 + i] + y;
        for(j = 0; j < 4; ++j)
        {
            bx = rem[(bw - 1) * 4 + j] + x;
            block[(i * 4 * 4) + (j * 4) + 0] = src[(by * (w * 4)) + (bx * 4) + 0];
            block[(i * 4 * 4) + (j * 4) + 1] = src[(by * (w * 4)) + (bx * 4) + 1];
            block[(i * 4 * 4) + (j * 4) + 2] = src[(by * (w * 4)) + (bx * 4) + 2];
            block[(i * 4 * 4) + (j * 4) + 3] = src[(by * (w * 4)) + (bx * 4) + 3];
        }
    }
}

// Should be a pretty optimized 0-255 clamper
pragma(inline, true) private ubyte clamp255(int n)
{
    if (n > 255) n = 255;
    if (n < 0) n = 0;
    return cast(ubyte)n;
}

void rgbToYCoCgBlock(ubyte* dst, const(ubyte)* src)
{
    // Calculate Co and Cg extents
    int extents = 0;
    int n = 0;
    int iY, iCo, iCg; // r, g, b;
    int[16] blockCo;
    int[16] blockCg;
    int i;

    const(ubyte)*px = src;
    for (i = 0; i < n; i++)
    {
        iCo = (px[0] << 1) - (px[2] << 1);
        iCg = (px[1] << 1) - px[0] - px[2];
        if (-iCo > extents) extents = -iCo;
        if ( iCo > extents) extents = iCo;
        if (-iCg > extents) extents = -iCg;
        if ( iCg > extents) extents = iCg;

        blockCo[n] = iCo;
        blockCg[n++] = iCg;

        px += 4;
    }

    // Co = -510..510
    // Cg = -510..510
    float scaleFactor = 1.0f;
    if (extents > 127)
        scaleFactor = cast(float)extents * 4.0f / 510.0f;

    // Convert to quantized scalefactor
    ubyte scaleFactorQuantized = cast(ubyte)(ceil((scaleFactor - 1.0f) * 31.0f / 3.0f));

    // Unquantize
    scaleFactor = 1.0f + cast(float)(scaleFactorQuantized / 31.0f) * 3.0f;

    ubyte bVal = cast(ubyte)((scaleFactorQuantized << 3) | (scaleFactorQuantized >> 2));

    ubyte* outPx = dst;

    n = 0;
    px = src;
    /*
    for(i=0;i<16;i++)
    {
        // Calculate components
        iY = ( px[0] + (px[1]<<1) + px[2] + 2 ) / 4;
        iCo = ((blockCo[n] / scaleFactor) + 128);
        iCg = ((blockCg[n] / scaleFactor) + 128);

        if(iCo < 0) iCo = 0; else if(iCo > 255) iCo = 255;
        if(iCg < 0) iCg = 0; else if(iCg > 255) iCg = 255;
        if(iY < 0) iY = 0; else if(iY > 255) iY = 255;

        px += 4;

        outPx[0] = (unsigned char)iCo;
        outPx[1] = (unsigned char)iCg;
        outPx[2] = bVal;
        outPx[3] = (unsigned char)iY;

        outPx += 4;
    }
    */
    for (i = 0; i < 16; i++)
    {
        // Calculate components
        int r = px[0];
        int g = (px[1] + 1) >> 1;
        int b = px[2];
        int tmp = (2 + r + b) >> 2;
        
        // Co
        iCo = clamp255(128 + ((r - b + 1) >> 1));
        // Y
        iY = clamp255(g + tmp);
        // Cg
        iCg = clamp255(128 + g - tmp);

        px += 4;

        outPx[0] = cast(ubyte)iCo;
        outPx[1] = cast(ubyte)iCg;
        outPx[2] = bVal;
        outPx[3] = cast(ubyte)iY;

        outPx += 4;
    }
}

void rygCompress(ubyte* dst, ubyte* src, int w, int h, int isDxt5)
{
    ubyte[64] block;
    int x, y;
    
    for (y = 0; y < h; y += 4)
    {
        for(x = 0; x < w; x += 4)
        {
            extractBlock(src, x, y, w, h, block.ptr);
            stb_compress_dxt_block(dst, block.ptr, isDxt5, 10);
            dst += isDxt5 ? 16 : 8;
        }
    }
}

void rygCompressYCoCg(ubyte* dst, ubyte* src, int w, int h)
{
    ubyte[64] block;
    ubyte[64] ycocgblock;
    int x, y;
   
    for(y = 0; y < h; y += 4)
    {
        for(x = 0; x < w; x += 4)
        {
            extractBlock(src, x, y, w, h, block.ptr);
            rgbToYCoCgBlock(ycocgblock.ptr, block.ptr);
            stb_compress_dxt_block(dst, ycocgblock.ptr, 1, 10);
            dst += 16;
        }
    }
}

private void stbgl__compress(ubyte* p, ubyte* rgba, int w, int h, int isDxt5)
{
    int i, j, y, y2;
    int alpha = isDxt5;
   
    for (j = 0; j < w; j += 4)
    {
        int x = 4;
        for (i = 0; i < h; i += 4)
        {
            ubyte[16 * 4] block = void;
            if (i + 3 >= w) x = w - i;
            for (y = 0; y < 4; ++y)
            {
                if (j + y >= h) break;
                memcpy(block.ptr + y * 16, rgba + w * 4 * (j + y) + i * 4, x * 4);
            }
            if (x < 4)
            {
                switch(x)
                {
                    case 0: assert(0);
                    case 1:
                        for (y2 = 0; y2 < y; ++y2)
                        {
                            memcpy(block.ptr + y2 * 16 + 1 * 4, block.ptr + y2 * 16 + 0 * 4, 4);
                            memcpy(block.ptr + y2 * 16 + 2 * 4, block.ptr + y2 * 16 + 0 * 4, 8);
                        }
                        break;
                    case 2:
                        for (y2 = 0; y2 < y; ++y2)
                            memcpy(block.ptr + y2 * 16 + 2 * 4, block.ptr + y2 * 16 + 0 * 4, 8);
                        break;
                    case 3:
                        for (y2=0; y2 < y; ++y2)
                            memcpy(block.ptr + y2 * 16 + 3 * 4, block.ptr + y2 * 16 + 1 * 4, 4);
                        break;
                    default:
                        break;
                }
            }
            y2 = 0;
            for(; y < 4; ++y, ++y2)
                memcpy(block.ptr + y * 16, block.ptr + y2 * 16, 4 * 4);
            stb_compress_dxt_block(p, block.ptr, alpha, 10);
            p += alpha ? 16 : 8;
        }
    }
}

pragma(inline, true)
private ubyte linearize(ubyte inByte)
{
    float srgbVal = (cast(float)inByte) / 255.0f;
    float linearVal = void;

    if (srgbVal < 0.04045)
        linearVal = srgbVal / 12.92f;
    else
        linearVal = pow((srgbVal + 0.055f) / 1.055f, 2.4f);

    return cast(ubyte)(floor(sqrt(linearVal) * 255.0 + 0.5));
}

void linearize(ubyte* dst, const(ubyte)* src, int n)
{
    n *= 4;
    for (int i = 0; i < n; i++)
    dst[i] = linearize(src[i]);
}
