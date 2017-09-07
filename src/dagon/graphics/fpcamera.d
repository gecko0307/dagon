module dagon.graphics.fpcamera;

import derelict.opengl.gl;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.utils;

import dagon.core.ownership;

class FirstPersonCamera: Owner
{
    Matrix4x4f transformation;
    Matrix4x4f characterMatrix;
    Matrix4x4f invTransformation;
    Vector3f position;
    float turn = 0.0f;
    float pitch = 0.0f;
    float roll = 0.0f;
    
    this(Vector3f position, Owner o)
    {
        super(o);
        this.position = position;
        transformation = worldTrans();       
        invTransformation = transformation.inverse;
    }
    
    Matrix4x4f worldTrans()
    {  
        Matrix4x4f m = translationMatrix(position + Vector3f(0, 1, 0));
        m *= rotationMatrix(Axis.y, degtorad(turn));
        characterMatrix = m;
        m *= rotationMatrix(Axis.x, degtorad(pitch));
        m *= rotationMatrix(Axis.z, degtorad(roll));
        return m;
    }

    void update(double dt)
    {
        transformation = worldTrans();       
        invTransformation = transformation.inverse;
    }

    Matrix4x4f viewMatrix()
    {
        return invTransformation;
    }
    
    Matrix4x4f invViewMatrix()
    {
        return transformation;
    }
}

