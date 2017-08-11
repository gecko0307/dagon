module dagon.graphics.particles;

import std.random;
import std.algorithm;
import dlib.core.memory;
import dlib.image.color;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.math.utils;
import dlib.container.array;
import derelict.opengl.gl;
import dagon.core.ownership;
import dagon.logics.entity;
import dagon.logics.behaviour;
import dagon.graphics.texture;
import dagon.graphics.view;

struct Particle
{
    Color4f startColor;
    Color4f color;
    Vector3f position;
    Vector3f[8] trail;
    Vector3f acceleration;
    Vector3f velocity;
    Vector3f gravityVector;
    Vector2f scale;
    float lifetime;
    float time;
    float trailTimer;
    bool move;
}

abstract class ForceField: Behaviour
{
    this(Entity e, ParticleSystem psys)
    {
        super(e);
        psys.addForceField(this);
    }

    void upadte(double dt)
    {
    }

    void affect(ref Particle p);
}

class Attractor: ForceField
{
    float g;

    this(Entity e, ParticleSystem psys, float magnitude)
    {
        super(e, psys);
        g = magnitude;
    }

    override void affect(ref Particle p)
    {
        Vector3f r = p.position - entity.position;
        float d = max(EPSILON, r.length);
        p.acceleration += r * -g / (d * d);
    }
}

class Deflector: ForceField
{
    float g;

    this(Entity e, ParticleSystem psys, float magnitude)
    {
        super(e, psys);
        g = magnitude;
    }

    override void affect(ref Particle p)
    {
        Vector3f r = p.position - entity.position;
        float d = max(EPSILON, r.length);
        p.acceleration += r * g / (d * d);
    }
}

class Vortex: ForceField
{
    float g1;
    float g2;

    this(Entity e, ParticleSystem psys, float tangentMagnitude, float normalMagnitude)
    {
        super(e, psys);
        g1 = tangentMagnitude;
        g2 = normalMagnitude;
    }

    override void affect(ref Particle p)
    {
        Vector3f direction = entity.transformation.forward;
        float proj = dot(p.position, direction);
        Vector3f pos = entity.position + direction * proj;
        Vector3f r = p.position - pos;
        float d = max(EPSILON, r.length);
        Vector3f t = lerp(r, cross(r, direction), 0.25f);
        p.acceleration += direction * g2 - t * g1 / (d * d);
    }
}

class BlackHole: ForceField
{
    float g;

    this(Entity e, ParticleSystem psys, float magnitude)
    {
        super(e, psys);
        g = magnitude;
    }

    override void affect(ref Particle p)
    {
        Vector3f r = p.position - entity.position;
        float d = r.length;
        if (d <= 0.001f)
            p.time = p.lifetime;
        else
            p.acceleration += r * -g / (d * d);
    }
}

class ColorChanger: ForceField
{
    Color4f color;
    float outerRadius;
    float innerRadius;

    this(Entity e, ParticleSystem psys, Color4f color, float outerRadius, float innerRadius)
    {
        super(e, psys);
        this.color = color;
        this.outerRadius = outerRadius;
        this.innerRadius = innerRadius;
    }

    override void affect(ref Particle p)
    {
        Vector3f r = p.position - entity.position;
        float t = clamp((r.length - innerRadius) / outerRadius, 0.0f, 1.0f);
        p.color = lerp(color, p.color, t);
    }
}

class ParticleSystem: Behaviour
{
    Particle[] particles;
    DynamicArray!ForceField forceFields;

    Texture texture;
    View view;
    Matrix4x4f invViewMatRot;

    float gravityAcceleration = 9.8f;

    float minLifetime = 1.0f;
    float maxLifetime = 3.0f;

    float minSize = 0.25f;
    float maxSize = 1.0f;

    float initialPositionRandomRadius = 0.0f;

    Vector3f initialDirection = Vector3f(0, 1, 0);

    float initialDirectionRandomFactor = 1.0f;
    float minInitialSpeed = 1.0f;
    float maxInitialSpeed = 5.0f;
    float airFrictionDamping = 0.98f;

    Color4f startColor = Color4f(1, 0.5f, 0, 1);
    Color4f endColor = Color4f(1, 1, 1, 0);

    float trailTimeStep = 1.0f / 30.0f;

    bool haveParticlesToDraw;
    
    bool drawTrails;
    bool drawForceFields;

    this(Entity e, uint numParticles, Texture t, View v)
    {
        super(e);

        texture = t;
        view = v;

        particles = New!(Particle[])(numParticles);
        foreach(ref p; particles)
        {
            resetParticle(p);
        }
    }

    ~this()
    {
        Delete(particles);
        forceFields.free();
    }

    void addForceField(ForceField ff)
    {
        forceFields.append(ff);
    }

    override void update(double dt)
    {
        invViewMatRot = matrix3x3to4x4(matrix4x4to3x3(view.viewMatrix).transposed);

        haveParticlesToDraw = false;
        foreach(ref p; particles)
        if (p.time < p.lifetime)
        {
            p.time += dt;
            if (p.move)
            {
                p.acceleration = Vector3f(0, 0, 0);
                foreach(ref ff; forceFields)
                {
                    ff.affect(p);
                }
                p.velocity += p.acceleration * dt;
                p.velocity = p.velocity * airFrictionDamping;

                p.trailTimer += dt;
                if (p.trailTimer >= trailTimeStep)
                {
                    p.trailTimer -= trailTimeStep;
                    for(uint i = p.trail.length-1; i > 0; i--)
                    {
                        p.trail[i] = p.trail[i-1];
                    }
                    p.trail[0] = p.position;
                }

                p.position += p.velocity * dt;
            }

            float t = p.time / p.lifetime;
            p.color.a = lerp(1.0f, 0.0f, t);

            haveParticlesToDraw = true;
        }
        else
            resetParticle(p);
    }

    void resetParticle(ref Particle p)
    {
        if (initialPositionRandomRadius > 0.0f)
        {
            float randomDist = uniform(0.0f, initialPositionRandomRadius);
            p.position = entity.position + randomUnitVector3!float * randomDist;
        }
        else
            p.position = entity.position;
        p.trail[] = p.position;
        Vector3f r = randomUnitVector3!float;
        float initialSpeed = uniform(minInitialSpeed, maxInitialSpeed);
        p.velocity = lerp(initialDirection, r, initialDirectionRandomFactor) * initialSpeed;
        p.lifetime = uniform(minLifetime, maxLifetime);
        p.gravityVector = Vector3f(0, -1, 0);
        float s = uniform(minSize, maxSize);
        p.scale = Vector2f(s, s);
        p.time = 0.0f;
        p.move = true;
        p.startColor = startColor;
        p.color = p.startColor;
        p.trailTimer = 0.0f;
    }

    pragma(inline) static void drawUnitBillboard()
    {
        glBegin(GL_QUADS);
        glTexCoord2f(0.0f, 0.0f); glVertex3f(-0.5f,  0.5f, 0.0f);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(-0.5f, -0.5f, 0.0f);
        glTexCoord2f(1.0f, 1.0f); glVertex3f( 0.5f, -0.5f, 0.0f);
        glTexCoord2f(1.0f, 0.0f); glVertex3f( 0.5f,  0.5f, 0.0f);
        glEnd();
    }

    override void render()
    {
        glPushMatrix();
        // Get rid of entity's rotation/scaling - we are gonna work in world space
        glMultMatrixf(entity.invTransformation.arrayof.ptr);

        glPushAttrib(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_ENABLE_BIT);
        glDisable(GL_LIGHTING);

        if (haveParticlesToDraw)
        {
            // Draw particles
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE);
            glDepthMask(0);
            glLineWidth(5.0f);
            foreach(ref p; particles)
            if (p.time < p.lifetime)
            {
                glColor4fv(p.color.arrayof.ptr);

                texture.bind();
                glPushMatrix();  
                glTranslatef(p.position.x, p.position.y, p.position.z);
                // Fast billboard rendering trick: compensate camera rotation
                glMultMatrixf(invViewMatRot.arrayof.ptr);
                glScalef(p.scale.x, p.scale.y, 1.0f);
                drawUnitBillboard();
                glPopMatrix();
                texture.unbind();

                if (drawTrails)
                {
                    glBegin(GL_LINE_STRIP);

                    Color4f color = p.color;
                    float a = color.a / cast(float)p.trail.length;
                    glColor4fv(color.arrayof.ptr);
                    glVertex3fv(p.position.arrayof.ptr);

                    foreach(ref t; p.trail)
                    {
                        color.a -= a;
                        glColor4fv(color.arrayof.ptr);
                        glVertex3fv(t.arrayof.ptr);
                    }

                    glEnd();
                }
            }
            glLineWidth(1.0f);
            glDisable(GL_BLEND);
        }

        // Draw force fields
        if (drawForceFields)
        {
            glDisable(GL_DEPTH_TEST);
            glPointSize(5.0f);
            glColor4f(1, 1, 1, 1);
            foreach(ref ff; forceFields)
            {
                glBegin(GL_POINTS);
                glVertex3fv(ff.entity.position.arrayof.ptr);
                glEnd();
            }
            glPointSize(1.0f);
            glEnable(GL_DEPTH_TEST);
        }

        glPopAttrib();

        glPopMatrix();
    }
}

