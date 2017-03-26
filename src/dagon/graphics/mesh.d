module dagon.graphics.mesh;

import dlib.geometry.triangle;
import dagon.core.interfaces;

interface Mesh: Drawable
{
    int opApply(scope int delegate(Triangle t) dg);
}
