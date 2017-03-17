module character;

import std.math;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.affine;
import dlib.math.utils;

import dagon.core.ownership;

import dmech.world;
import dmech.rigidbody;
import dmech.geometry;
import dmech.shape;
import dmech.contact;
import dmech.raycast;

/*
 * CharacterController implements kinematic body on top of dmech dynamics: it allows direct
 * velocity changes for a RigidBody. CharacterController is intended for generic action game
 * character movement.
 */
class CharacterController: Owner
{
    PhysicsWorld world;
    RigidBody rbody;
    bool onGround = false;
    Vector3f direction = Vector3f(0, 0, 1);
    float speed = 0.0f;
    float jSpeed = 0.0f;
    float maxVelocityChange = 0.75f;
    float artificalGravity = 50.0f;
    Vector3f rotation;
    RigidBody floorBody;
    Vector3f floorNormal;
    bool flyMode = false;
    bool clampY = true;
    ShapeComponent sensor;
    float selfTurn = 0.0f;

    this(PhysicsWorld world, Vector3f pos, float mass, Geometry geom, Owner o)
    {
        super(o);
        this.world = world;
        rbody = world.addDynamicBody(pos);
        rbody.bounce = 0.0f;
        rbody.friction = 1.0f;
        rbody.enableRotation = false;
        rbody.useOwnGravity = true;
        rbody.gravity = Vector3f(0.0f, -artificalGravity, 0.0f);
        rbody.raycastable = false;
        world.addShapeComponent(rbody, geom, Vector3f(0, 0, 0), mass);
        rotation = Vector3f(0, 0, 0);
    }

    ShapeComponent createSensor(Geometry geom, Vector3f point)
    {
        if (sensor is null)
            sensor = world.addSensor(rbody, geom, point);
        return sensor;
    }
    
    void enableGravity(bool mode)
    {
        flyMode = !mode;
        
        if (mode)
        {
            rbody.gravity = Vector3f(0.0f, -artificalGravity, 0.0f);
        }
        else
        {
            rbody.gravity = Vector3f(0, 0, 0);
        }
    }

    void update()
    {
        Vector3f targetVelocity = direction * speed;

        Vector3f velocityChange = targetVelocity - rbody.linearVelocity;
        velocityChange.x = clamp(velocityChange.x, -maxVelocityChange, maxVelocityChange);
        velocityChange.z = clamp(velocityChange.z, -maxVelocityChange, maxVelocityChange);
        
        if (clampY && !flyMode)
            velocityChange.y = 0;
        else
            velocityChange.y = clamp(velocityChange.y, -maxVelocityChange, maxVelocityChange);
            
        rbody.linearVelocity += velocityChange;

        if (!flyMode)
        {
            onGround = checkOnGround();
        
            if (onGround)
                rbody.gravity = Vector3f(0.0f, -artificalGravity * 0.1f, 0.0f);
            else
                rbody.gravity = Vector3f(0.0f, -artificalGravity, 0.0f);
                
            selfTurn = 0.0f;
            if (onGround && floorBody && speed == 0.0f && jSpeed == 0.0f)
            {
                Vector3f relPos = rbody.position - floorBody.position;
                Vector3f rotVel = cross(floorBody.angularVelocity, relPos);
                rbody.linearVelocity = floorBody.linearVelocity;
                if (!floorBody.dynamic)
                {
                    rbody.linearVelocity += rotVel;
                    selfTurn = -floorBody.angularVelocity.y;
                }
            }
            
            speed = 0.0f;
            jSpeed = 0.0f;
        }
        else
        {
            speed *= 0.95f;
            jSpeed *= 0.95f;
        }
    }

    bool checkOnGround()
    {
        floorBody = null;
        CastResult cr;
        bool hit = world.raycast(rbody.position, Vector3f(0, -1, 0), 10, cr, true, true);
        if (hit)
        {
            floorBody = cr.rbody;
            floorNormal = cr.normal;
        }
    
        if (sensor)
        {
            if (sensor.numCollisions > 0)
                return true;
        }
        
        return false;
    }

    void turn(float angle)
    {
        rotation.y += angle;
    }

    void move(Vector3f direction, float spd)
    {
        this.direction = direction;
        this.speed = spd;
    }

    void jump(float height)
    {
        if (onGround || flyMode)
        {
            jSpeed = jumpSpeed(height);
            rbody.linearVelocity.y = jSpeed;
        }
    }

    float jumpSpeed(float jumpHeight)
    {
        return sqrt(2.0f * jumpHeight * artificalGravity);
    }
}

