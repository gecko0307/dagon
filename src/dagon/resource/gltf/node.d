/*
Copyright (c) 2021-2025 Timur Gafarov

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
module dagon.resource.gltf.node;

import std.stdio;

import dlib.core.ownership;
import dlib.core.memory;
import dlib.container.array;
import dlib.math.vector;
import dlib.math.quaternion;
import dlib.math.matrix;
import dlib.math.transformation;

import dagon.graphics.entity;
import dagon.resource.gltf.mesh;
import dagon.resource.gltf.skin;

class GLTFNode: Owner
{
    size_t index;
    string name;
    Entity entity;
    
    GLTFNode parent;
    GLTFNode[] children;
    size_t[] childrenIndices;
    
    GLTFMesh mesh;
    
    GLTFSkin skin;
    int skinIndex = -1;
    
    TransformMode transformMode;
    
    Vector3f bindPosePosition;
    Quaternionf bindPoseRotation;
    Vector3f bindPoseScaling;
    Matrix4x4f bindPoseTransform;
    
    Vector3f position;
    Quaternionf rotation;
    Vector3f scaling;
    Matrix4x4f localTransform;
    
    this(Owner o)
    {
        super(o);
        position = Vector3f(0.0f, 0.0f, 0.0f);
        rotation = Quaternionf.identity;
        scaling = Vector3f(1.0f, 1.0f, 1.0f);
        bindPosePosition = Vector3f(0.0f, 0.0f, 0.0f);
        bindPoseRotation = Quaternionf.identity;
        bindPoseScaling = Vector3f(1.0f, 1.0f, 1.0f);
        bindPoseTransform = Matrix4x4f.identity;
        localTransform = Matrix4x4f.identity;
        entity = New!Entity(this);
    }
    
    void updateBindPoseTransform()
    {
        bindPoseTransform = trsMatrix(
            bindPosePosition,
            bindPoseRotation,
            bindPoseScaling);
    }
    
    void updateLocalTransform()
    {
        if (transformMode == TransformMode.TRS)
        {
            localTransform = trsMatrix(position, rotation, scaling);
        }
        else if (transformMode == TransformMode.Matrix)
        {
            localTransform = bindPoseTransform;
        }
    }
    
    Matrix4x4f globalTransform() @property
    {
        if (parent)
            return parent.globalTransform() * localTransform;
        else
            return localTransform;
    }
    
    ~this()
    {
        if (childrenIndices.length)
            Delete(childrenIndices);
        
        if (children.length)
            Delete(children);
    }
}

Matrix4x4f trsMatrix(Vector3f t, Quaternionf r, Vector3f s)
{
    Matrix4x4f res = Matrix4x4f.identity;
    Matrix3x3f rm = r.toMatrix3x3;
    res.a11 = rm.a11 * s.x; res.a12 = rm.a12 * s.x; res.a13 = rm.a13 * s.x;
    res.a21 = rm.a21 * s.y; res.a22 = rm.a22 * s.y; res.a23 = rm.a23 * s.y;
    res.a31 = rm.a31 * s.z; res.a32 = rm.a32 * s.z; res.a33 = rm.a33 * s.z;
    res.a14 = t.x;
    res.a24 = t.y;
    res.a34 = t.z;
    return res;
}
