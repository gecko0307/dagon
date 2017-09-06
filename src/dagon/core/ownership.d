module dagon.core.ownership;

import dlib.core.memory;
import dlib.container.array;

interface Owned
{
}

class Owner: Owned
{
    DynamicArray!Owned ownedObjects;

    this(Owner owner)
    {
        if (owner)
            owner.addOwnedObject(this);
    }

    void addOwnedObject(Owned obj)
    {
        ownedObjects.append(obj);
    }

    void clearOwnedObjects()
    {
        foreach(i, obj; ownedObjects)
            Delete(obj);
        ownedObjects.free();
    }

    ~this()
    {
        clearOwnedObjects();
    }
}

