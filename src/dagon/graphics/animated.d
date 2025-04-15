module dagon.graphics.animated;

import dagon.core.event: EventManager;
import dagon.core.time: Time;
import dagon.graphics.entity: EntityComponent, Entity;
import dlib.container.array;
import dlib.core.ownership: Owner;
import dlib.math.quaternion;
import dlib.math.matrix;
import dlib.math.transformation;

class AnimatedEntity: Entity
{
    //FIXME: use interface instead of gltf import
    import dagon.resource.gltf.animation;
    Array!GLTFAnimation animations;
    size_t animationIdx = -1;

    Matrix4x4f animation_transformation;

    this(Owner owner)
    {
        animation_transformation = Matrix4x4f.identity;
        super(owner);
    }

    override void updateTransformation()
    {
        prevTransformation = transformation;

        //TODO: deduplicate this translation code with Entity code
        transformation =
            animation_transformation *
            translationMatrix(position) *
            rotation.toMatrix4x4 *
            scaleMatrix(scaling);

        updateAbsoluteTransformation();
    }

    void applyAnimations(in Time t)
    {
        auto animation = animations[animationIdx];

        foreach(ch; animation.channels)
        {
            float prevTime=void;
            float nextTime=void;
            float loopTime=void;

            const prevIdx = ch.sampler.getSampleByTime(t, prevTime, nextTime, loopTime);
            const nextIdx = prevIdx + 1;

            const float interpRatio = (loopTime - prevTime) / (nextTime - prevTime);

            if(ch.target_path == TRSType.Rotation)
            {
                const Quaternionf prev_rot = ch.sampler.output.getSlice!Quaternionf[prevIdx];
                const Quaternionf next_rot = ch.sampler.output.getSlice!Quaternionf[nextIdx];

                Quaternionf rot = slerp(prev_rot, next_rot, interpRatio);

                import std.stdio;
                writeln("===");
                writeln("loopTime=", loopTime);
                writeln("ratio=", interpRatio);
                writeln("prevIdx=", prevIdx);
                writeln("nextIdx=", nextIdx);
                writeln(prev_rot);
                writeln(next_rot);
                writeln(rot);

                animation_transformation = rot.toMatrix4x4;
            }
            else
            {
                assert(false, "access to Vector3f slice not implemented");
            }
        }
    }
}

class AnimatedComponent: EntityComponent
{
    this(EventManager em, Entity e)
    {
        super(em, e);
    }

    //~ override void update(Time t)
    //~ {
    //~ }
}
