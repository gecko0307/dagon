module dagon.resource.gltf.animation;

import dagon.resource.gltf.accessor: GLTFAccessor;
import dlib.core.ownership: Owner;
import dlib.container.array;

//~ import dagon.graphics.drawable;
//~ import dagon.graphics.state;
//~ import dagon.resource.gltf.meshprimitive;

enum InterpolationType : string
{
    LINEAR = "LINEAR",
}

class AnimationSample: Owner
{
    InterpolationType interpolation;
    GLTFAccessor input;
    GLTFAccessor output;

    this(Owner o)
    {
        super(o);
    }
}

class GLTFAnimation: Owner
{
    Array!AnimationSample samples;

    this(Owner o)
    {
        super(o);
    }

    ~this()
    {
        samples.free();
    }
}
