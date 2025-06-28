module bindbc.libvlc.nativefuncs;

import core.stdc.stdint;
import bindbc.libvlc.funcs;

int64_t libvlc_delay(int64_t pts)
{
    return pts - libvlc_clock();
}