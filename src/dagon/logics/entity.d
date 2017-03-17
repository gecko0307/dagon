module dagon.logics.entity;

import dlib.core.memory;
import dlib.container.array;

import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.affine;
import dlib.math.quaternion;

import derelict.opengl.gl;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.core.event;
import dagon.logics.controller;
import dagon.logics.behaviour;

class Entity: Owner, Drawable
{
    uint id;
    uint groupID = 0;

    struct BehaviourListEntry
    {
        Behaviour behaviour;
        bool valid;
    }

    DynamicArray!BehaviourListEntry behaviours;
    Drawable drawable;
    EventManager eventManager;

    Matrix4x4f transformation;
    Vector3f position;
    Quaternionf rotation;
    Vector3f scaling;

    EntityController controller;
    DefaultEntityController defaultController;

    this(EventManager emngr, Owner owner)
    {
        super(owner);
        eventManager = emngr;

        transformation = Matrix4x4f.identity;
        position = Vector3f(0, 0, 0);
        rotation = Quaternionf.identity;
        scaling = Vector3f(1, 1, 1);

        defaultController = New!DefaultEntityController(this);
        controller = defaultController;
    }

    ~this()
    {
        behaviours.free();
    }

    Behaviour addBehaviour(Behaviour b)
    {
        behaviours.append(BehaviourListEntry(b, true));
        return b;
    }

    void removeBehaviour(Behaviour b)
    {
        foreach(i, ble; behaviours)
        {
            if (ble.behaviour is b)
                behaviours[i].valid = false;
        }
    }

    bool hasBehaviour(T)()
    {
        bool result = false;

        foreach(i, ble; behaviours)
        {
            T b = cast(T)ble.behaviour;
            if (b)
            {
                result = true;
                break;
            }
        }

        return result;
    }

    T behaviour(T)()
    {
        T result = null;

        foreach(i, ble; behaviours)
        {
            T b = cast(T)ble.behaviour;
            if (b)
            {
                result = b;
                break;
            }
        }

        return result;
    }

    void update(double dt)
    {
        if (controller)
            controller.update(dt);

        foreach(i, ble; behaviours)
        {
            if (ble.valid)
            {
                ble.behaviour.processEvents();
                ble.behaviour.update(dt);
            }
        }

        if (drawable)
            drawable.update(dt);
    }

    void render()
    {
        foreach(i, ble; behaviours)
        {
            if (ble.valid)
                ble.behaviour.bind();
        }

        glPushMatrix(); 
        glMultMatrixf(transformation.arrayof.ptr);

        if (drawable)
            drawable.render();

        foreach(i, ble; behaviours)
        {
            if (ble.valid)
                ble.behaviour.render();
        }

        glPopMatrix();

        foreach_reverse(i, ble; behaviours.data)
        {
            if (ble.valid)
                ble.behaviour.unbind();
        }
    }
}

