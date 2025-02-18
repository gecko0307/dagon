# Tutorial 17. Character Controller

`dagon:newton` extension provides built-in character controller that is very easy to use. For any Entity that represents your character's visual model, you can do the following:

```d
Entity eCharacter = addEntity();
eCharacter.position = Vector3f(0, 1, 0); // Start position will be taken into account by the controller
NewtonCharacterController character = eCharacter.makeCharacter(world, 1.8f, 0.45f, 80.0f);
```

`makeCharacter` takes the following parameters:
* `NewtonPhysicsWorld world` - the world object that the character should exist in;
* `float height` - height of the character in meters;
* `float radius` - radius of the character's bounding spheres in meters;
* `float mass` - mass of the character in kg.

It is advisable to construct the world in such a way that these values closely match the real world.

The character's collision shape is composed of two bounding spheres one on top of another. They are automatically placed to match given height, so it is not recommended to set the radius substantially larger than 1/4 of the height. Recommended radius is 0.4-0.5 for a normal human height 1.6-1.8.

The origin of the controlled entity matches character's feet point.

To control the character, normal `Entity` methods should not be used. Instead, you should use `move` and `jump` methods of the controller. For example, you can use a `FirstPersonViewComponent` directions for movement:

```d
void characterControls()
{
    float speed = 3.0f; // speed in m/s
    if (inputManager.getButton("left")) character.move(fpview.right, -speed);
    if (inputManager.getButton("right")) character.move(fpview.right, speed);
    if (inputManager.getButton("forward")) character.move(fpview.directionHorizontal, -speed);
    if (inputManager.getButton("back")) character.move(fpview.directionHorizontal, speed);
    
    if (inputManager.getButton("jump")) character.jump(1.0f);
    
    if (inputManager.getButton("crouch")) character.crouch(true);
    else character.crouch(false);
    
    character.updateVelocity();
}
```

Note that in this example `directionHorizontal` is used instead of `direction`, because we only want to move in XZ plane.

`character.updateVelocity()` should be called when all the control logics is done. This method applies a velocity change to the rigid body to produce the kinematic movement.

The character's underlying rigid body interacts with other dynamic bodies in the world: the character can walk over boxes, etc. But it will not react to collision impacts from other bodies.

To correctly sync the camera with the character, you can make it child of `eCharacter` and place at the character's local `eyePoint`:

```d
override void onUpdate(Time t)
{
    characterControls();
    physicsWorld.update(t.delta);
    camera.position = character.eyePoint;
}
```

See also [[First Person Camera tutorial|Tutorial 7. First Person Camera]].
