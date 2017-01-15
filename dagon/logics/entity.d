module dagon.logics.entity;

import dlib.core.memory;
import dlib.container.array;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.core.event;
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

    this(EventManager emngr, Owner owner)
    {
        super(owner);
        eventManager = emngr;
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

        if (drawable)
            drawable.render();

        foreach(i, ble; behaviours)
        {
            if (ble.valid)
                ble.behaviour.render();
        }

        foreach_reverse(i, ble; behaviours.data)
        {
            if (ble.valid)
                ble.behaviour.unbind();
        }
    }
}

