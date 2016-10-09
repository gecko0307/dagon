module dagon.logics.stdbehaviour;

import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.affine;
import dlib.math.quaternion;
import derelict.opengl.gl;
import dagon.logics.entity;
import dagon.logics.behaviour;

class Transformation: Behaviour
{
    Matrix4x4f tmatrix;
    Vector3f position;
    Quaternionf rotation;
    Vector3f scaling;

    this(Entity e)
    {
        super(e);
        reset();
    }

    void reset()
    {
        tmatrix = Matrix4x4f.identity;
        position = Vector3f(0, 0, 0);
        rotation = Quaternionf.identity;
        scaling = Vector3f(1, 1, 1);
    }

    void move(Vector3f t)
    {
        position += t;
    }

    override void update(double dt)
    {
        tmatrix = 
            translationMatrix(position) *
            rotation.toMatrix4x4 *
            scaleMatrix(scaling);
    }

    override void bind()
    {
        glPushMatrix(); 
        glMultMatrixf(tmatrix.arrayof.ptr);
    }

    override void unbind()
    {
        glPopMatrix();
    }
}

class ParentRelation: Behaviour
{
    Entity parent;
    Matrix4x4f parentMatrix;

    this(Entity e, Entity par = null)
    {
        super(e);
        parent = par;
    }

    override void update(double dt)
    {
        if (parent)
        {
            Transformation pt = parent.behaviour!Transformation;
            parentMatrix = pt.tmatrix;
        }
        else
        {
            parentMatrix = Matrix4x4f.identity;
        }
    }

    override void bind()
    {
        glPushMatrix(); 
        glMultMatrixf(parentMatrix.arrayof.ptr);
    }

    override void unbind()
    {
        glPopMatrix();
    }
}

