module dagon.graphics.light;

import derelict.opengl.gl;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.quaternion;
import dlib.image.color;
import dlib.container.array;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.logics.entity;
import dagon.logics.behaviour;
import dagon.logics.stdbehaviour;

class Light: Drawable
{
    Vector4f position;
    Color4f color;
    //Color4f ambientColor;
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
    float brightness;
    bool enabled = true;
    bool debugDraw = false;
    //bool forceOn = false;
    //bool highPriority = false;
    
    this()
    {        
        position = Vector3f(0, 0, 0);
        color = Color4f(1, 1, 1, 1);
        constantAttenuation = 0.5f;
        linearAttenuation = 0.0f;
        quadraticAttenuation = 0.1f;
    }

    this(
        Vector4f position,
        Color4f color,
        float constantAttenuation,
        float linearAttenuation,
        float quadraticAttenuation)
    {
        this.position = position;
        this.color = color;
        this.constantAttenuation = constantAttenuation;
        this.linearAttenuation = linearAttenuation;
        this.quadraticAttenuation = quadraticAttenuation;
    }

    void update(double dt)
    {
    }

    void render()
    {
        if (debugDraw)
        {
            glDisable(GL_LIGHTING);
            glColor4fv(color.arrayof.ptr);
            glPointSize(5.0f);
            glBegin(GL_POINTS);
            glVertex3f(0, 0, 0);
            glEnd();
            glPointSize(1.0f);
            glEnable(GL_LIGHTING);
        }
    }
}

Light pointLight(
    Vector3f pos,
    Color4f color,
    float constantAttenuation = 0.5f,
    float linearAttenuation = 0.0f,
    float quadraticAttenuation = 0.1f)
{
    return New!Light(
        Vector4f(pos.x, pos.y, pos.z, 1.0f),
        color,
        constantAttenuation, linearAttenuation,
        quadraticAttenuation);
}

enum maxLightsPerReceiver = 5;

class LightReceiver: Behaviour
{
    Light[maxLightsPerReceiver] significantLights;
    uint numLights = 0;
    LightManager lightManager;

    this(Entity e, LightManager lm)
    {
        super(e);
        lightManager = lm;
    }

    override void update(double dt)
    {
        foreach(i; 0..maxLightsPerReceiver)
            significantLights[i] = null;
        numLights = 0;
        
        auto lights = lightManager.lights.data;
        
        for(size_t i = 0; i < lights.length; i++)
            lightManager.calcLightBrightness(lights[i], entity.position);

        lightManager.sortLights();

        foreach(i; 0..maxLightsPerReceiver)
        if (i < lights.length)
        {
            significantLights[i] = lights[i];
            numLights++;
        }
    }

    override void bind()
    {
        //glEnable(GL_LIGHTING);
        
        foreach(i; 0..maxLightsPerReceiver)
        {
            auto light = significantLights[i];
            if (light)
            {
                glEnable(GL_LIGHT0 + i);
                glLightfv(GL_LIGHT0 + i, GL_POSITION, light.position.arrayof.ptr);
				glLightfv(GL_LIGHT0 + i, GL_SPECULAR, light.color.arrayof.ptr);
                glLightfv(GL_LIGHT0 + i, GL_DIFFUSE, light.color.arrayof.ptr);
                glLightfv(GL_LIGHT0 + i, GL_AMBIENT, light.color.arrayof.ptr);
                glLightf( GL_LIGHT0 + i, GL_CONSTANT_ATTENUATION, light.constantAttenuation);
                glLightf( GL_LIGHT0 + i, GL_LINEAR_ATTENUATION, light.linearAttenuation);
                glLightf( GL_LIGHT0 + i, GL_QUADRATIC_ATTENUATION, light.quadraticAttenuation);
            }
            else
            {
                Vector4f p = Vector4f(0, 0, 0, 2);
                glLightfv(GL_LIGHT0 + i, GL_POSITION, p.arrayof.ptr);
            }
        }
    }

    override void unbind()
    {
        foreach(i; 0..maxLightsPerReceiver)
            glDisable(GL_LIGHT0 + i);
        //glDisable(GL_LIGHTING);
    }
}

class LightManager: Owner
{
    DynamicArray!Light lights;
    Color4f ambientColor;
    
    this(Owner owner)
    {
        super(owner);
        
        ambientColor = Color4f(0.0f, 0.0f, 0.0f, 1.0f);
    }
    
    void freeLights()
    {
        foreach(light; lights)
            Delete(light);
        lights.free();
    }

    ~this()
    {
        freeLights();
    }

    Light addPointLight(Vector3f position, Color4f color)
    {
        Light light = pointLight(position, color);
        lights.append(light);
        //lightsToDelete.append(light);
        return light;
    }

    void calcLightBrightness(Light light, Vector3f objPos)
    {
        if (!light.enabled)
        {
            light.brightness = 0.0f;
        }
        else
        {
            Vector3f d = (light.position.xyz - objPos);
            float distSqr = d.lengthsqr;
            //if (light.highPriority && distSqr < 150) // 100 50
            //    light.brightness = float.max;
            //else
            //    light.brightness = 1.0f / distSqr;
            light.brightness = 1.0f / distSqr;
        }
    }
    
    void sortLights()
    {
        size_t j = 0;
        Light tmp;

        auto ldata = lights.data;

        foreach(i, v; ldata)
        {
            j = i;
            size_t k = i;

            while (k < ldata.length)
            {
                float b1 = ldata[j].brightness;
                float b2 = ldata[k].brightness;
                
                if (b2 > b1)
                    j = k;
                
                k++;
            }

            tmp = ldata[i];
            ldata[i] = ldata[j];
            ldata[j] = tmp;
        }
    }
}

/++
class LightManager
{
    DynamicArray!Light lights;
    DynamicArray!Light lightsToDelete;

    bool lightsVisible = false;
    bool lightsOn = true;
    bool useUpdateTreshold = false;
    Vector3f referencePoint = Vector3f(0, 0, 0);
    float updateThreshold = 400.0f;
    
    static bool sunEnabled = false;
    static Vector4f sunPosition = Vector4f(0, 1, 0, 0);
    static Color4f sunColor = Color4f(1, 1, 1, 1);
    static Color4f blackColor = Color4f(0, 0, 0, 1);

    Light addLight(Light light)
    {
        lights.append(light);
        return light;
    }

    Light addPointLight(Vector3f position)
    {
        Light light = pointLight(
            position,
            Color4f(1.0f, 1.0f, 1.0f, 1.0f),
            Color4f(0.1f, 0.1f, 0.1f, 1.0f));
        lights.append(light);
        lightsToDelete.append(light);
        return light;
    }

    void calcLighting(Scene s)
    {
        foreach(e; s.entities)
            if (e.visible && !e.shadeless)
                calcLighting(e);
    }

    void calcLighting(Entity e)
    {
        Vector3f ePos = e.getPosition();
        if (useUpdateTreshold)
        {
            if ((ePos - referencePoint).lengthsqr < updateThreshold)
                calcLighting(ePos);
        }
        else
            calcLighting(ePos);

        sortLights();

        e.numLights = 0;
        foreach(i; 0..maxLightsPerObject)
        if (i < lights.length)
        {
            e.lights[i] = lights.data[i];
            e.numLights++;
        }
    }

    void calcLighting(Vector3f pos)
    {
        auto ldata = lights.data;
        foreach(light; ldata)
            if (lightsOn || light.forceOn)
                calcBrightness(light, pos);
    }

    void calcBrightness(Light light, Vector3f objPos)
    {
        if (!light.enabled && !light.forceOn)
        {
            light.brightness = 0.0f;
        }
        else
        {
            Vector3f d = (light.position.xyz - objPos);
            float distSqr = d.lengthsqr;
            if (light.highPriority && distSqr < 150) // 100 50
                light.brightness = float.max;
            else
                light.brightness = 1.0f / distSqr;
        }
    }

    void sortLights()
    {
        size_t j = 0;
        Light tmp;

        auto ldata = lights.data;

        foreach(i, v; ldata)
        {
            j = i;
            size_t k = i;

            while (k < ldata.length)
            {
                float b1 = ldata[j].brightness;
                float b2 = ldata[k].brightness;
                
                if (b2 > b1)
                    j = k;
                
                k++;
            }

            tmp = ldata[i];
            ldata[i] = ldata[j];
            ldata[j] = tmp;
        }
    }

    static void bindLighting(Entity e)
    {
        glEnable(GL_LIGHTING);
        foreach(i; 0..maxLightsPerObject+1)
        {
            Vector4f p = Vector4f(0, 0, 0, 2);
            glLightfv(GL_LIGHT0 + i, GL_POSITION, p.arrayof.ptr);
        }
        
        foreach(i; 0..maxLightsPerObject)
        if (i < e.numLights)
        {
            auto light = e.lights[i];
            if (light.enabled)
            {
                glEnable(GL_LIGHT0 + i);
                glLightfv(GL_LIGHT0 + i, GL_POSITION, light.position.arrayof.ptr);
				glLightfv(GL_LIGHT0 + i, GL_SPECULAR, light.diffuseColor.arrayof.ptr);
                glLightfv(GL_LIGHT0 + i, GL_DIFFUSE, light.diffuseColor.arrayof.ptr);
                glLightfv(GL_LIGHT0 + i, GL_AMBIENT, light.ambientColor.arrayof.ptr);
                glLightf( GL_LIGHT0 + i, GL_CONSTANT_ATTENUATION, light.constantAttenuation);
                glLightf( GL_LIGHT0 + i, GL_LINEAR_ATTENUATION, light.linearAttenuation);
                glLightf( GL_LIGHT0 + i, GL_QUADRATIC_ATTENUATION, light.quadraticAttenuation);
            }
            else
            {
                Vector4f p = Vector4f(0, 0, 0, 2);
                glLightfv(GL_LIGHT0 + i, GL_POSITION, p.arrayof.ptr);
            }
        }
        
        if (sunEnabled)
        {
            glEnable(GL_LIGHT0 + maxLightsPerObject);
            glLightfv(GL_LIGHT0 + maxLightsPerObject, GL_POSITION, sunPosition.arrayof.ptr);
            glLightfv(GL_LIGHT0 + maxLightsPerObject, GL_DIFFUSE, sunColor.arrayof.ptr);
            glLightfv(GL_LIGHT0 + maxLightsPerObject, GL_SPECULAR, sunColor.arrayof.ptr);
        }
        else
        {
            glLightfv(GL_LIGHT0 + maxLightsPerObject, GL_DIFFUSE, blackColor.arrayof.ptr);
            glLightfv(GL_LIGHT0 + maxLightsPerObject, GL_SPECULAR, blackColor.arrayof.ptr);
        }
    }

    static void unbindLighting()
    {
        foreach(i; 0..maxLightsPerObject)
            glDisable(GL_LIGHT0 + i);
        glEnable(GL_LIGHT0 + maxLightsPerObject);
        glDisable(GL_LIGHTING);
    }
    
/*
    // TODO
    void draw(double dt)
    {
        // Draw lights
        if (lightsVisible)
        {
            glPointSize(5.0f);
            foreach(light; lights.data)
            if (light.debugDraw)
            {
                glColor4fv(light.diffuseColor.arrayof.ptr);
                glBegin(GL_POINTS);
                glVertex3fv(light.position.arrayof.ptr);
                glEnd();
            }
            glPointSize(1.0f);
        }
    }
*/

    void freeLights()
    {
        foreach(light; lightsToDelete)
            Delete(light);
        lights.free();
    }

    ~this()
    {
        freeLights();
    }
}
++/

