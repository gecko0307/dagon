module dagon.resource.gltf.animation;

import bindbc.opengl.bind.gl11: GL_FLOAT;
import dagon.core.bindings: GLenum;
import dagon.core.time: Time;
import dagon.resource.gltf.accessor: GLTFAccessor, GLTFDataType;
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

    /// Returns: beginning translation sample number
    size_t getSampleByTime(in Time t, out float previousTime, out float nextTime, out float loopTime)
    {
        assert(input.dataType == GLTFDataType.Scalar);
        assert(input.componentType == GL_FLOAT);

        const timeline = input.getSlice!float;
        assert(timeline.length > 1);

        loopTime = t.elapsed % timeline[$-1];

        //FIXME: wrong clamping before/after sampler input range

        foreach(i; 0 .. timeline.length - 1)
        {
            //TODO: One comparison could be removed here, but I'm too lazy
            //Or this search approach can be optimized more radically?
            if(timeline[i] >= loopTime && loopTime < timeline[i+1])
            {
                previousTime = timeline[i];
                nextTime = timeline[i+1];
                return i;
            }
        }

        return 0; //no translation found, so using first translation
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
