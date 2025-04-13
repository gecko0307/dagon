module dagon.resource.gltf.animation;

import dagon.resource.gltf.accessor: GLTFAccessor;
import dagon.resource.gltf.node: GLTFNode;
import dlib.core.ownership: Owner;
import dlib.container.array;

enum InterpolationType : string
{
    LINEAR = "LINEAR",
}

enum TRSType : string
{
    Translation = "translation",
    Rotation = "rotation",
    Scale = "scale",
}

class AnimationSampler: Owner
{
    InterpolationType interpolation;
    GLTFAccessor input;
    GLTFAccessor output;

    this(Owner o)
    {
        super(o);
    }
}

class AnimationChannel: Owner
{
    AnimationSampler sampler; // required
    TRSType target_path; // required
    GLTFNode target_node; // optional: When undefined, the animated object MAY be defined by an extension.

    this(Owner o)
    {
        super(o);
    }
}

class GLTFAnimation: Owner
{
    Array!AnimationSampler samplers;
    Array!AnimationChannel channels;

    this(Owner o)
    {
        super(o);
    }

    ~this()
    {
        samplers.free();
        channels.free();
    }
}
