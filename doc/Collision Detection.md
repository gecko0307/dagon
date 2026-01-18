# Collision Detection

## Overview

Collision detection and response in games are very complex tasks. There is no universal algorithm for them, since each game mechanic has its own characteristics and requirements for accuracy and performance. For example, an arcade platformer usually tolerates a simplistic collision model consisting of basic shapes such as spheres and axis-aligned boxes, while a complex physics-based game like racing simulator requires precise ray casting and collision detection of convex geometry with arbitrary meshes.

All approaches have a lot in common. The basic principle of any collision detection algorithm is to output four data fields:
- Intersection fact—true or false;
- Intersection point (a point at the second shape's surface where intersection normal is defined);
- Intersection normal—the unit vector representing the direction of the shortest translation required to separate the shapes. It is perpendicular to the surface of the second shape at the intersection point;
- Penetration depth along the normal—that is, the shortest overlap distance between the shapes' surfaces.

The most efficient CD algorithms deal with convex shapes due to their convenient geometric properties. Convex shape is a closed figure for which any line segment connecting two points on the surface stays entirely within the figure. For 3D geometry, these include ellipsoid, prism, cylinder and many others, including irregular polygonal convex shapes.

Convex CD is largely based on Minkowski theory. Specifically, intersection between convex objects A and B occurs if and only if the origin lies within the Minkowski difference of A and B: `A ⊕ -B`. The Gilbert-Johnson-Keerthi (GJK) algorithm is a classic example, efficiently finding the distance between convex shapes by searching for the point in the Minkowski difference closest to the origin; if that distance is zero, they intersect.

Dagon's `collision` package implements a number of popular CD algorithms, including GJK and Minkowski Portal Refinement (MPR), which is generally more numerically stable, and also provides a simple sphere-based CD framework that easily integrates with Dagon's ECS (`dagon.collision.collision`).

Collision response is a process of resolving collisions, which is necessary for rigid body mechanics. Physically-based collision solver is the heart of a dynamics engine; if you want your objects to behave realistically, you need that. However, in many games you can get by using a simplified (usually, position-based) form of collision response. Instead of tracking velocities and impulses and caching contacts, like in a full-featured physics engine, you can simply iterate through all collisions and shift the object by penetration depth along each intersection normal. This works perfectly for kinematic movement model where Newton's first law of motion does not hold (inertia is not taken into account). This is necessary in genres where characters are expected to move fully predictably at constant speeds, platformers and RPGs being typical examples. That being said, nothing stops you from including dynamic characteristics such as mass in your kinematic system if you need them.

## dagon.collision.collision

TODO
