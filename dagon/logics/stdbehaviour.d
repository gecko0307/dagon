module dagon.logics.stdbehaviour;

import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.affine;
import dlib.math.quaternion;
import derelict.opengl.gl;
import dagon.logics.entity;
import dagon.logics.behaviour;

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
            //Transformation pt = parent.behaviour!Transformation;
            parentMatrix = parent.transformation;
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

