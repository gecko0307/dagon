/*
Copyright (c) 2025 Denis Feklushkin, Timur Gafarov

Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

/**
 * GLTF 2.0 animation.
 *
 * Description:
 * The `dagon.resource.gltf.animation` module defines classes for representing
 * and evaluating GLTF animation samplers, channels, and animation clips.
 * Animation playback, blending, and update logic are included.
 *
 * Copyright: Denis Feklushkin, Timur Gafarov 2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Denis Feklushkin, Timur Gafarov
 */
module dagon.resource.gltf.animation;

import std.stdio;
import std.algorithm;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.container.array;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.quaternion;
import dlib.math.interpolation;
import dlib.serialization.json;

import dagon.core.bindings;
import dagon.core.event;
import dagon.core.time;
import dagon.graphics.entity;
import dagon.graphics.pose;
import dagon.resource.gltf.accessor;
import dagon.resource.gltf.node;
import dagon.resource.gltf.skin;

/**
 * Interpolation types supported by GLTF animation samplers.
 */
enum InterpolationType: string
{
    Linear = "LINEAR",
    Step = "STEP",
    CubicSpline = "CUBICSPLINE"
}

/**
 * Animation target property types (translation, rotation, scale).
 */
enum TRSType: string
{
    Translation = "translation",
    Rotation = "rotation",
    Scale = "scale",
}

/**
 * Represents a GLTF animation sampler, which defines keyframe times,
 * values, and interpolation.
 */
class GLTFAnimationSampler: Owner
{
    /// Interpolation type (linear, step, cubic spline). Only LINEAR is supported at the moment
    InterpolationType interpolation;

    /// Accessor for keyframe times (in seconds).
    GLTFAccessor input;

    /// Accessor for keyframe values.
    GLTFAccessor output;
    
    /// Application-specific data.
    JSONObject extras;
    
    this(Owner o)
    {
        super(o);
    }
    
    /**
     * Returns the duration of the animation sampler in seconds.
     */
    float duration()
    {
        const timeline = input.getSlice!float;
        if (timeline.length)
            return timeline[$ - 1];
        else
            return 0.0f;
    }
    
    /**
     * Finds the keyframe sample indices and times for a given animation time.
     *
     * Params:
     *   t            = Current animation time.
     *   previousTime = Output: previous keyframe time.
     *   nextTime     = Output: next keyframe time.
     *   loopTime     = Output: wrapped time within the animation duration.
     * Returns:
     *   Index of the previous keyframe.
     */
    size_t getSampleByTime(in Time t, out float previousTime, out float nextTime, out float loopTime)
    {
        assert(input.dataType == GLTFDataType.Scalar);
        assert(input.componentType == GL_FLOAT);
        
        const timeline = input.getSlice!float;
        assert(timeline.length > 1, "GLTF animation sampler input must have at least two keyframes");
        
        float duration = timeline[$ - 1];
        loopTime = t.elapsed % duration;
        
        // Clamp to the input interval
        if (loopTime < timeline[0])
        {
            previousTime = timeline[0];
            nextTime = timeline[1];
            return 0;
        }
        if (loopTime >= timeline[$ - 1])
        {
            previousTime = timeline[$ - 2];
            nextTime = timeline[$ - 1];
            return timeline.length - 2;
        }
        
        foreach (i; 0..timeline.length - 1)
        {
            if (timeline[i] <= loopTime && loopTime < timeline[i + 1])
            {
                previousTime = timeline[i];
                nextTime = timeline[i + 1];
                return i;
            }
        }
        
        // Fallback
        previousTime = timeline[0];
        nextTime = timeline[1];
        return 0; // No translation found, so using first translation
    }
}

/**
 * Represents a GLTF animation channel, which targets a node and property (TRS).
 */
class GLTFAnimationChannel: Owner
{
    /// The animation sampler for this channel.
    GLTFAnimationSampler sampler;

    /// The property being animated (translation, rotation, scale).
    TRSType targetPath;

    /// The node being animated.
    GLTFNode targetNode;

    /// Application-specific data.
    JSONObject extras;

    this(Owner o)
    {
        super(o);
    }
}

/**
 * Represents a GLTF animation clip, containing samplers and channels.
 */
class GLTFAnimation: Owner
{
    /// Animation name.
    string name;

    /// Animation samplers.
    Array!GLTFAnimationSampler samplers;

    /// Animation channels.
    Array!GLTFAnimationChannel channels;

    /// Application-specific data.
    JSONObject extras;

    this(Owner o)
    {
        super(o);
    }
    
    ~this()
    {
        samplers.free();
        channels.free();
    }
    
    /**
     * Returns the duration of the animation in seconds.
     */
    float duration()
    {
        float d = 0.0f;
        foreach(ch; channels)
        {
            d = max(d, ch.sampler.duration);
        }
        return d;
    }
}

/**
 * `Entity`` component for playing a GLTF animation on an entity.
 */
class GLTFAnimationComponent: EntityComponent
{
    /// The animation to play.
    GLTFAnimation animation;

    /// Current animation time.
    Time time;

    /// True if the animation is playing.
    bool playing;

    this(EventManager em, Entity e, GLTFAnimation animation, bool playing = false)
    {
        super(em, e);
        this.animation = animation;
        this.time = Time(0.0, 0.0);
        this.playing = playing;
        e.transformMode = TransformMode.Matrix;
    }
    
    /// Starts animation playback.
    void play()
    {
        playing = true;
    }
    
    /// Pauses animation playback.
    void pause()
    {
        playing = false;
    }
    
    /// Resets animation time to zero.
    void reset()
    {
        time.elapsed = 0;
    }
    
    /// Updates the animation and applies transforms to the entity.
    override void update(Time t)
    {
        if (playing)
        {
            time.elapsed += t.delta;
            time.delta = t.delta;
        }
        
        Vector3f trans = entity.position;
        Quaternionf rot = entity.rotation;
        Vector3f scaling = entity.scaling;
        
        foreach(ch; animation.channels)
        {
            float prevTime = 0.0f;
            float nextTime = 0.0f;
            float loopTime = 0.0f;
            
            const prevIdx = ch.sampler.getSampleByTime(time, prevTime, nextTime, loopTime);
            const nextIdx = prevIdx + 1;
            
            const float interpRatio = (loopTime - prevTime) / (nextTime - prevTime);
            
            // TODO: support all interpolation types
            
            if (ch.targetPath == TRSType.Translation)
            {
                const Vector3f prevTrans = ch.sampler.output.getSlice!Vector3f[prevIdx];
                const Vector3f nextTrans = ch.sampler.output.getSlice!Vector3f[nextIdx];
                trans = lerp(prevTrans, nextTrans, interpRatio);
            }
            else if (ch.targetPath == TRSType.Rotation)
            {
                const Quaternionf prevRot = ch.sampler.output.getSlice!Quaternionf[prevIdx];
                const Quaternionf nextRot = ch.sampler.output.getSlice!Quaternionf[nextIdx];
                rot = slerp(prevRot, nextRot, interpRatio);
            }
            else if (ch.targetPath == TRSType.Scale)
            {
                const Vector3f prevScale = ch.sampler.output.getSlice!Vector3f[prevIdx];
                const Vector3f nextScale = ch.sampler.output.getSlice!Vector3f[nextIdx];
                scaling = lerp(prevScale, nextScale, interpRatio);
            }
        }
        
        entity.transformation =
            translationMatrix(trans) *
            rot.toMatrix4x4 *
            scaleMatrix(scaling);
        
        entity.updateAbsoluteTransformation();
    }
}

/**
 * GPU skinning pose for a GLTF skin and animation.
 */
class GLTFPose: Pose
{
    /// The GLTFSkin being posed.
    GLTFSkin skin;

    /// The animation to play.
    GLTFAnimation animation;
    
    this(GLTFSkin skin, Owner o)
    {
        super(o);
        this.skin = skin;
        
        if (skin.joints.length)
        {
            boneMatrices = New!(Matrix4x4f[])(skin.joints.length);
            boneMatrices[] = Matrix4x4f.identity;
            valid = true;
        }
    }
    
    ~this()
    {
        if (boneMatrices.length)
            Delete(boneMatrices);
    }
    
    /// Updates the pose for the current animation time.
    override void update(Time t)
    {
        if (playing)
        {
            time.elapsed += t.delta;
            time.delta = t.delta;
        }
        
        if (animation)
        {
            foreach(ch; animation.channels)
            {
                if (ch.targetNode is null || ch.sampler is null)
                    continue;
                
                auto node = ch.targetNode;
                auto sampler = ch.sampler;
                
                float prevTime = 0.0f;
                float nextTime = 0.0f;
                float loopTime = 0.0f;
                
                const prevIdx = sampler.getSampleByTime(time, prevTime, nextTime, loopTime);
                const nextIdx = prevIdx + 1;
                
                const float denom = nextTime - prevTime;
                const float interpRatio = denom != 0 ? (loopTime - prevTime) / denom : 0.0f;
                
                // TODO: support all interpolation types
                
                if (ch.targetPath == TRSType.Translation)
                {
                    const Vector3f prevTrans = sampler.output.getSlice!Vector3f[prevIdx];
                    const Vector3f nextTrans = sampler.output.getSlice!Vector3f[nextIdx];
                    node.position = lerp(prevTrans, nextTrans, interpRatio);
                    node.entity.position = node.position;
                }
                else if (ch.targetPath == TRSType.Rotation)
                {
                    const Quaternionf prevRot = sampler.output.getSlice!Quaternionf[prevIdx];
                    const Quaternionf nextRot = sampler.output.getSlice!Quaternionf[nextIdx];
                    node.rotation = slerp(prevRot, nextRot, interpRatio);
                    node.entity.rotation = node.rotation;
                }
                else if (ch.targetPath == TRSType.Scale)
                {
                    const Vector3f prevScale = sampler.output.getSlice!Vector3f[prevIdx];
                    const Vector3f nextScale = sampler.output.getSlice!Vector3f[nextIdx];
                    node.scaling = lerp(prevScale, nextScale, interpRatio);
                    node.entity.scaling = node.scaling;
                }
            }
            
            foreach(i, joint; skin.joints)
            {
                joint.updateLocalTransform();
                joint.entity.updateTransformation();
            }
        }
        else
        {
            foreach(i, joint; skin.joints)
            {
                joint.position = joint.bindPosePosition;
                joint.rotation = joint.bindPoseRotation;
                joint.scaling = joint.bindPoseScaling;
                joint.updateLocalTransform();
                
                joint.entity.position = joint.bindPosePosition;
                joint.entity.rotation = joint.bindPoseRotation;
                joint.entity.scaling = joint.bindPoseScaling;
                joint.entity.updateTransformation();
            }
        }
        
        foreach(i, joint; skin.joints)
        {
            boneMatrices[i] = joint.globalTransform * skin.invBindMatrices[i];
        }
    }
}

/**
 * TRS (Translation, Rotation, Scale) structure for joint transforms.
 */
struct TRS
{
    Vector3f translation;
    Quaternionf rotation;
    Vector3f scaling;
}

/**
 * Animation playback mode (loop or once).
 */
enum PlayMode
{
    Loop,
    Once
}

/**
 * A pose that supports smooth blending between GLTF animations.
 */
class GLTFBlendedPose: Pose
{
    /// The GLTFSkin being posed.
    GLTFSkin skin;
    
    /// Current TRS pose for each joint.
    TRS[] currentPose;

    /// Next TRS pose for blending.
    TRS[] nextPose;
    
    /// Previous animation.
    GLTFAnimation previousAnimation;

    /// Current animation.
    GLTFAnimation animation;

    /// Next animation.
    GLTFAnimation nextAnimation;

    /// Blend factor between animations.
    float blendAlpha = 0.0f;

    /// Blend speed.
    float blendSpeed = 0.0f;

    float previousBlendSpeed = 0.0f;

    /// Duration of the current animation.
    float animationDuration = 0.0f;

    /// Playback mode (loop or once).
    PlayMode playMode = PlayMode.Loop;
    
    this(GLTFSkin skin, Owner owner)
    {
        super(owner);
        this.skin = skin;
        
        if (skin.joints.length)
        {
            boneMatrices = New!(Matrix4x4f[])(skin.joints.length);
            boneMatrices[] = Matrix4x4f.identity;
            valid = true;
            
            currentPose = New!(TRS[])(skin.joints.length);
            nextPose = New!(TRS[])(skin.joints.length);
        }
    }
    
    ~this()
    {
        if (boneMatrices.length)
            Delete(boneMatrices);
        if (currentPose.length)
            Delete(currentPose);
        if (nextPose.length)
            Delete(nextPose);
    }
    
    /**
     * Applies an animation to the pose at a given time.
     *
     * Params:
     *   anim    = The animation to apply.
     *   time    = The animation time.
     *   outPose = Output array of TRS for each joint.
     */
    void applyAnimation(GLTFAnimation anim, Time time, TRS[] outPose)
    {
        if (anim)
        {
            foreach(i, joint; skin.joints)
            {
                outPose[i].translation = joint.position;
                outPose[i].rotation = joint.rotation;
                outPose[i].scaling = joint.scaling;
            }
            
            foreach(ch; anim.channels)
            {
                if (ch.targetNode is null || ch.sampler is null)
                    continue;
                
                auto node = ch.targetNode;
                auto sampler = ch.sampler;
                
                float prevTime = 0.0f;
                float nextTime = 0.0f;
                float loopTime = 0.0f;
                
                const prevIdx = sampler.getSampleByTime(time, prevTime, nextTime, loopTime);
                const nextIdx = prevIdx + 1;
                
                const float denom = nextTime - prevTime;
                const float interpRatio = denom != 0 ? (loopTime - prevTime) / denom : 0.0f;

                auto boneIndex = countUntil(skin.joints.data, node);
                if (boneIndex == -1) continue;
                
                if (ch.targetPath == TRSType.Translation)
                {
                    const Vector3f prevTrans = sampler.output.getSlice!Vector3f[prevIdx];
                    const Vector3f nextTrans = sampler.output.getSlice!Vector3f[nextIdx];
                    outPose[boneIndex].translation = lerp(prevTrans, nextTrans, interpRatio);
                }
                else if (ch.targetPath == TRSType.Rotation)
                {
                    const Quaternionf prevRot = sampler.output.getSlice!Quaternionf[prevIdx];
                    const Quaternionf nextRot = sampler.output.getSlice!Quaternionf[nextIdx];
                    outPose[boneIndex].rotation = slerp(prevRot, nextRot, interpRatio);
                }
                else if (ch.targetPath == TRSType.Scale)
                {
                    const Vector3f prevScale = sampler.output.getSlice!Vector3f[prevIdx];
                    const Vector3f nextScale = sampler.output.getSlice!Vector3f[nextIdx];
                    outPose[boneIndex].scaling = lerp(prevScale, nextScale, interpRatio);
                }
            }
        }
        else
        {
            foreach(i, joint; skin.joints)
            {
                outPose[i].translation = joint.bindPosePosition;
                outPose[i].rotation = joint.bindPoseRotation;
                outPose[i].scaling = joint.bindPoseScaling;
            }
        }
    }
    
    /**
     * Switches to a new animation immediately.
     *
     * Params:
     *   anim              = The new animation.
     *   playMode          = Playback mode (loop or once).
     */
    void switchToAnimation(GLTFAnimation anim, PlayMode playMode = PlayMode.Loop)
    {
        if (anim !is animation)
        {
            nextAnimation = anim;
            animationDuration = nextAnimation.duration;
            blendAlpha = 1.0f;
            blendSpeed = 0.0f;
            this.playMode = playMode;
        }
    }
    
    /**
     * Switches to a new animation smoothly.
     *
     * Params:
     *   anim               = The new animation.
     *   transitionDuration = Duration of the blend (optional).
     *   playMode           = Playback mode (loop or once).
     */
    void switchToAnimation(GLTFAnimation anim, float transitionDuration, PlayMode playMode = PlayMode.Loop)
    {
        if (anim !is animation)
        {
            nextAnimation = anim;
            if (anim is null)
                animationDuration = 0.0f;
            else
                animationDuration = nextAnimation.duration;
            blendAlpha = 0.0f;
            blendSpeed = 1.0f / transitionDuration;
            this.playMode = playMode;
        }
    }
    
    /// Updates the blended pose and applies transforms to the skin.
    override void update(Time t)
    {
        applyAnimation(animation, time, currentPose);
        applyAnimation(nextAnimation, Time(0.0f, 0.0f), nextPose);
        
        foreach(i, joint; skin.joints)
        {
            TRS a = currentPose[i];
            TRS b = nextPose[i];

            joint.position = lerp(a.translation, b.translation, blendAlpha);
            joint.rotation = slerp(a.rotation, b.rotation, blendAlpha);
            joint.scaling  = lerp(a.scaling, b.scaling, blendAlpha);

            joint.entity.position = joint.position;
            joint.entity.rotation = joint.rotation;
            joint.entity.scaling  = joint.scaling;

            joint.updateLocalTransform();
            joint.entity.updateTransformation();
        }
        
        foreach(i, joint; skin.joints)
        {
            boneMatrices[i] = joint.globalTransform * skin.invBindMatrices[i];
        }
        
        if (playing)
        {
            time.elapsed += t.delta;
            time.delta = t.delta;
            
            if (blendAlpha < 1.0f)
            {
                blendAlpha += blendSpeed * t.delta;
                blendAlpha = min(blendAlpha, 1.0f);
            }
            else
            {
                time.elapsed = 0.0f;
                previousAnimation = animation;
                animation = nextAnimation;
                nextAnimation = null;
                blendAlpha = 0.0f;
                previousBlendSpeed = blendSpeed;
                blendSpeed = 0.0f;
            }
            
            if (nextAnimation is null && time.elapsed >= animationDuration)
            {
                if (playMode == PlayMode.Once)
                {
                    time.elapsed = 0.0f;
                    
                    nextAnimation = previousAnimation;
                    previousAnimation = null;
                    if (nextAnimation is null)
                        animationDuration = 0.0f;
                    else
                        animationDuration = nextAnimation.duration;
                    blendAlpha = 0.0f;
                    blendSpeed = previousBlendSpeed;
                    playMode = PlayMode.Loop;
                }
            }
        }
    }
}
