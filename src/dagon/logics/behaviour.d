module dagon.logics.behaviour;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.core.event;
import dagon.logics.entity;

class Behaviour: EventListener, Owned, Drawable
{
    Entity entity;

    this(Entity e)
    {
        super(e.eventManager, e);
        e.addBehaviour(this);
        entity = e;
    }

    void update(double dt) {}
    void bind() {}
    void unbind() {}
    void render() {}
}

