# Tutorial 17. Character Controller

A character controller is a kinematic model of a game character's locomotion behaviour. In other words, it is a code that basically allows a character to walk and jump, taking collisions with the static scenery into account.

Dagon provides two distinct methods to implement character kinematics: native collision system (`dagon.collision` package) and the `NewtonCharacterController` on top of the Newton physics engine.

## dagon.collision

Dagon's collision framework is for games with basic interactivity (first-person adventures, puzzles, platformers and such). It doesn't provide physically-correct behaviour, but aims stability and predictable results.

With this method, the character is represented with a single sphere that reacts to collisions with static colliders. The framework has no notion of mass and velocity. It is designed in such way that most of the movement logic is on user side: to make the character move, you just update its position, via `Entity.translate` or any other method. For example, to implement basic character controller with jumping, you can do the following:

```d
CollisionWorld world;

Camera camera;
FirstPersonViewComponent firstPersonView;

Entity character;
DynamicCollider characterCollider;
float verticalSpeed = 0.0f;
bool jumped = false;

override void afterLoad()
{
    world = New!CollisionWorld(this);
    auto infinitePlane = New!PlaneCollider(world,
        Vector3f(0.0f, 0.0f, 0.0f),
        Vector3f(0.0f, 1.0f, 0.0f), this);
    
    character = addEntity();
    character.position = Vector3f(0.0f, 1.0, 0.0f);
    characterCollider = New!DynamicCollider(eventManager, world, character, 1.0f); // spherical dynamic collider
    
    Entity cameraPivot = addEntity(character);
    camera = addCamera(cameraPivot);
    camera.fov = 50.0f;
    firstPersonView = New!FirstPersonViewComponent(eventManager, cameraPivot);
    game.renderer.activeCamera = camera;
    
    auto box = addEntity();
    Vector3f extents = Vector3f(1.0f, 1.0f, 1.0f);
    box.drawable = New!ShapeBox(extents, assetManager);
    box.position = Vector3f(2.0f, 1.0f, 0.0f);
    auto boxCollider = New!BoxCollider(eventManager, world, box, extents);
}

override void onUpdate(Time t)
{
    const float speed = 3.0f;
    const float gravity = -30.0f;
    const float jumpSpeed = 10.0f;
    
    Vector3f velocity = Vector3f(0.0f, 0.0f, 0.0f);
    
    Vector3f groundForward = -firstPersonView.directionHorizontal;
    Vector3f groundRight = firstPersonView.right;
    Vector3f groundUp = firstPersonView.up;
    
    if (characterCollider.onGround)
    {
        // Use ground basis vectors for better movement on slopes
        groundUp = characterCollider.groundNormal;
        groundForward = cross(groundUp, groundRight);
        groundRight = cross(groundForward, groundUp);
    }
    
    if (inputManager.getButton("left"))    velocity -= groundRight * speed;
    if (inputManager.getButton("right"))   velocity += groundRight * speed;
    if (inputManager.getButton("forward")) velocity += groundForward * speed;
    if (inputManager.getButton("back"))    velocity -= groundForward * speed;
    
    float verticalAcceleration = 0.0f;
    if (characterCollider.onGround)
    {
        verticalSpeed = 0.0f;
        if (inputManager.getButton("jump"))
        {
            if (!jumped)
            {
                verticalSpeed = jumpSpeed;
                jumped = true;
            }
        }
        else
            jumped = false;
    }
    else
    {
        verticalAcceleration = gravity;
    }
    
    verticalSpeed += verticalAcceleration * t.delta;
    velocity += Vector3f(0.0f, verticalSpeed, 0.0f);
    
    character.translate(velocity * t.delta);
}
```

Note that in this example `directionHorizontal` is used instead of `direction`, because we only want to move in XZ plane of the basis.

## NewtonCharacterController

More generic solution that fits classic first person shooters and games with realistic interactivity, provided by `dagon:newton` extension. Best choice if the character should be able to interact with rigid bodies. 

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

It is advisable to construct the simulation in such a way that these values closely match the real world.

`NewtonCharacterController` supports crouching, and due to that, its collision shape is composed of two spheres one on top of another. They are automatically placed to match given height, so it is not recommended to set the radius substantially larger than 1/4 of the height. Recommended radius is 0.4-0.5 for an average human height 1.6-1.8.

The origin of the controlled entity matches character's feet point.

To control the character, normal `Entity` methods should not be used. Instead, you should use `move` and `jump` methods of the controller. For example, you can use a `FirstPersonViewComponent` directions for movement:

```d
void characterControls()
{
    float walkSpeed = 3.0f; // speed in m/s
    float jumpSpeed = 3.0f;
    
    if (inputManager.getButton("left"))    character.move(firstPersonView.right, -walkSpeed);
    if (inputManager.getButton("right"))   character.move(firstPersonView.right, walkSpeed);
    if (inputManager.getButton("forward")) character.move(firstPersonView.directionHorizontal, -walkSpeed);
    if (inputManager.getButton("back"))    character.move(firstPersonView.directionHorizontal, walkSpeed);
    
    if (inputManager.getButton("jump")) character.jump(jumpSpeed);
    
    if (inputManager.getButton("crouch"))
        character.crouch(true);
    else
        character.crouch(false);
    
    character.updateVelocity();
}
```

`character.updateVelocity()` should be called when all the control logics is done. This method applies a velocity change to the rigid body to produce the kinematic movement.

The character's underlying rigid body interacts with other dynamic bodies in the world: the character can walk over boxes, etc. But it will not react to dynamic collision impacts from other bodies (there will be no energy conservation).

To correctly sync the camera with the character, you can make it child of `eCharacter` and place at the character's local `eyePoint`:

```d
override void onUpdate(Time t)
{
    characterControls();
    physicsWorld.update(t.delta);
    camera.position = character.eyePoint;
}
```
