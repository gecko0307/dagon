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
import dagon.graphics.material;
import dagon.graphics.rc;

class Entity: Owner
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

    Vector3f position;
    Quaternionf rotation;
    Vector3f scaling;

    Matrix4x4f transformation;
    Matrix4x4f invTransformation;

    EntityController controller;
    DefaultEntityController defaultController;

    Material material;
    RenderingContext rcLocal;

    this(EventManager emngr, Owner owner)
    {
        super(owner);
        eventManager = emngr;

        transformation = Matrix4x4f.identity;
        invTransformation = Matrix4x4f.identity;

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
        return this.behaviour!T() !is null;
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

    void render(RenderingContext* rc)
    {
        foreach(i, ble; behaviours)
        {
            if (ble.valid)
                ble.behaviour.bind();
        }

        glPushMatrix();
        glMultMatrixf(transformation.arrayof.ptr);

        rcLocal = *rc;
        rcLocal.position = position;
        rcLocal.rotation = rotation.toMatrix3x3;
        rcLocal.scaling = scaling;
        rcLocal.modelMatrix = transformation;
        rcLocal.invModelMatrix = invTransformation;

        if (material)
            material.bind(&rcLocal);
        if (drawable)
            drawable.render();
        if (material)
            material.unbind();

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

unittest
{
    class B1 : Behaviour
    {
        this(Entity e) {super(e);}
    }
    class B2 : Behaviour
    {
        this(Entity e) {super(e);}
    }
    auto e = New!Entity(null, null);
    New!B1(e);
    assert(e.hasBehaviour!B1());
    New!B2(e);
    assert(e.hasBehaviour!B2());

    auto b1 = e.behaviour!B1();
    assert(b1);
    auto b2 = e.behaviour!B2();
    assert(b2);

    // sets `valid` to false, but does not delete the behaviour
    e.removeBehaviour(b1);
    // ... so hasBehaviour reports true
    assert(e.hasBehaviour!B1());
}
