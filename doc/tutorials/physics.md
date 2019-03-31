# Tutorial 10. Physics Integration

Basically you want to synchronize your entities with rigid bodies from a physics engine. This can be done with a custom controller. An `EntityController` is an object that is responsible for calculating entity's transformation matrix every time step. Our controller class for interaction with [dmech](https://github.com/gecko0307/dmech) physics engine may look like this:
```d
class RigidBodyController: EntityController
{
    RigidBody rbody;

    this(Entity e, RigidBody b)
    {
        super(e);
        rbody = b;
        b.position = e.position;
        b.orientation = e.rotation;
    }

    override void update(double dt)
    {
        entity.position = rbody.position;
        entity.rotation = rbody.orientation; 
        entity.transformation = rbody.transformation * scaleMatrix(entity.scaling);
        entity.invTransformation = entity.transformation.inverse;
    }
}
```
Now we have to create a controller instance and apply it to an entity:
```d
auto eDynamic = createEntity3D();
eDynamic.controller = New!RigidBodyController(eDynamic, someRigidBody);
```