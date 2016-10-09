module dagon.core.storage;

import dlib.core.memory;
import dlib.container.array;
import dlib.container.dict;

import dagon.core.ownership;

/*
struct StorageEntry(T)
{
    T datum;
    bool available;
}

class Storage(T): Owner
{
    DynamicArray!(StorageEntry!T) objects;
    Dict!(size_t, string) objectsByName;

    this(Owner owner)
    {
        super(owner);
        objectsByName = New!(Dict!(size_t, string));
    }

    ~this()
    {
        objects.free();
        Delete(objectsByName);
    }

    T add(T obj, string name)
    {
        objects.append(StorageEntry!T(obj, true));
        objectsByName[name] = objects.length - 1;
    }

    void remove(string name)
    {
        if (name in objectsByName)
        {
            size_t index = objectsByName[name];
            objects[index].available = false;
        }
    }

    T getByIndex(size_t index)
    {
        if (objects[index].available)
            return objects[index].datum;
        else
            return T.init;
    }

    T getByName(string name)
    {
        if (name in objectsByName)
        {
            size_t index = objectsByName[name];
            if (objects[index].available)
                return objects[index].datum;
            else
                return T.init;
        }
        else
            return T.init;
    }
}
*/

