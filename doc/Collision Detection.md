# Collision Detection

## Overview

Collision detection and response in games are very complex tasks. There is no universal algorithm for them, since each game mechanic has its own requirements for collision detection accuracy and performance. For example, an arcade platformer usually tolerates a simplistic collision model consisting of basic shapes such as spheres and axis-aligned boxes, while a complex physics-based game like racing simulator requires precise ray casting and collision detection of convex geometry with arbitrary meshes.

All approaches have a lot in common. The basic principle of any CD algorithm is to output four data fields:
- Intersection fact—true or false;
- Intersection point (a point at the second shape's surface where intersection normal is defined);
- Intersection normal—the unit vector representing the direction of the shortest translation required to separate the shapes. It is perpendicular to the surface of the second shape at the intersection point;
- Penetration depth along the normal—that is, the shortest overlap distance between the shapes' surfaces.

The most efficient CD algorithms deal with convex shapes due to their convenient geometric properties. Convex shape is a closed figure in which any line segment connecting two points stays entirely within the figure. For 3D geometry, these include ellipsoid, prism, cylinder and many others, including irregular polygonal convex shapes.

Convex CD is largely based on the theory formulated by Hermann Minkowski. Specifically, intersection between convex sets A and B occurs if and only if the origin belongs to the Minkowski difference of A and B: `A ⊕ -B`. The Gilbert-Johnson-Keerthi (GJK) algorithm is a classic application of this theory, efficiently finding the distance between convex shapes by searching for the point in the Minkowski difference closest to the origin; if that distance is zero, they intersect.

Dagon's `collision` package implements a number of popular CD algorithms, including GJK and Minkowski Portal Refinement (MPR), which is generally more numerically stable. The package also provides a simple sphere-based CD framework (`dagon.collision.collision`) that easily integrates with Dagon's ECS.

Collision response is a process of resolving collisions, which is necessary for rigid body mechanics widely used in games to approximate real-world behaviour. Physically-based collision solver is the heart of a dynamics engine; if you want your objects to behave as realistically as possible in real time, you need that. However, in many games you can get by using a simplified (usually, position-based) form of collision response. Instead of tracking velocities and impulses and caching contacts, like in a full-featured physics engine, you can simply iterate through all collisions and translate the object by penetration depth along each intersection normal. This works perfectly for kinematic movement models where Newton's first law of motion does not hold (inertia is not taken into account), which is commonly seen in game genres where characters are expected to move fully predictably at constant speeds, platformers and RPGs being typical examples. That being said, nothing stops you from including dynamic characteristics such as mass in your kinematic system if you need them.

## dagon.collision.collision

Dagon's collision framework is built around components that synchronize convex colliders with `Entity` objects and compute basic collision responses for dynamic colliders. It uses spheres as bounding geometry for dynamic colliders and supports arbitrary convex shapes for static colliders, which fits most simple use cases.

Usage:

```d
CollisionWorld world;

Entity character;
DynamicCollider characterCollider;

override void afterLoad()
{
    world = New!CollisionWorld(this);
    auto infinitePlane = New!PlaneCollider(world, Vector3f(0.0f, 0.0f, 0.0f), Vector3f(0.0f, 1.0f, 0.0f), this);
    
    character = addEntity();
    character.position = Vector3f(0.0f, 1.0, 0.0f);
    characterCollider = New!DynamicCollider(eventManager, world, character, 1.0f);
    
    auto cube = addEntity();
    cube.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
    cube.position = Vector3f(2.0f, 1.0f, 0.0f);
    auto cubeCollider = New!BoxCollider(eventManager, world, cube, Vector3f(1.0f, 1.0f, 1.0f));
}
```

Now the character collider will react to collisions with the cube and apply kinematic response. Character's movement is entirely on user side. For example, to implement basic character controller with jumping, you can do the following:

```d
float verticalSpeed = 0.0f;

override void onUpdate(Time t)
{
    const float speed = 3.0f;
    const float gravity = -30.0f;
    const float jumpSpeed = 10.0f;
    
    Vector3f velocity = Vector3f(0.0f, 0.0f, 0.0f);
    
    if (inputManager.getButton("left"))    velocity -= rightDirection * speed;
    if (inputManager.getButton("right"))   velocity += rightDirection * speed;
    if (inputManager.getButton("forward")) velocity -= forwardDirection * speed;
    if (inputManager.getButton("back"))    velocity += forwardDirection * speed;
    
    float verticalAcceleration = 0.0f;
    if (characterCollider.onGround)
    {
        verticalSpeed = 0.0f;
        if (inputManager.getButton("jump"))
            verticalSpeed = jumpSpeed;
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

`forwardDirection` and `rightDirection` vectors can be obtained from camera or character transformation.

## Raycasting

TODO
