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
    InterpolationType interpolation; // optional, LINEAR by default
    GLTFAccessor input; // required, contains times (in seconds) for each keyframe.
    GLTFAccessor output; // required, contains values (of any Accessor.Type) for the animated property at each keyframe.

    this(Owner o)
    {
        super(o);
    }

    void getSampleByTime(T)(in Time t, out T from, out T to)
    {
        assert(input.dataType = GLTFDataType.Scalar);
        assert(input.componentType = GLenum.GL_FLOAT);

        const timeline = input.getSlice!float;
        assert(timeline.length > 1);

        foreach(i; 0 .. timeline.length - 1)
        {
            //TODO: One comparison could be removed here, but I'm too lazy
            //Or this search approach can be optimized more radically?
            if(timeline[i] >= t && t < timeline[i+1])
            {
                from = timeline[i];
                to = timeline[i+1];

                return;
            }
        }

        assert(false);
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
