module dagon.graphics.clustered;

import std.math;
import std.conv;
import std.random;

import dlib.core.memory;
import dlib.math.vector;
import dlib.container.array;
import dlib.image.color;

import derelict.opengl.gl;
import derelict.opengl.glext;

//import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.graphics.view;
import dagon.graphics.rc;

float clampf(float x, float mi, float ma)
{
    if (x < mi) return mi;
    else if (x > ma) return ma;
    else return x;
}

struct Box
{
    Vector2f pmin;
    Vector2f pmax;
}

struct Circle
{
    Vector2f center;
    float radius;
}

Box cellBox(uint x, uint y, float cellSize, float domainWidth)
{
    Box b;
    b.pmin = Vector2f(x, y) * cellSize - domainWidth * 0.5f;
    b.pmax = b.pmin + cellSize;
    return b;
}

bool circleBoxIsec(Circle c, Box b)
{
    if (c.center.x > b.pmin.x && c.center.x < b.pmax.x &&
        c.center.y > b.pmin.y && c.center.y < b.pmax.y)
        return true; // sphere's center is inside the box

    Vector2f closest = c.center;
    for (int i = 0; i < 2; i++)
    {
        float v = c.center[i];
        if (v < b.pmin[i]) v = b.pmin[i];
        if (v > b.pmax[i]) v = b.pmax[i];
        closest[i] = v;
    }

    return (distance(c.center, closest) <= c.radius);
}

struct LightSource
{
    Vector3f position;
    Vector3f color;
    float radius;
}

enum uint maxLightsPerNode = 32;

struct LightCluster
{
    Box box;
    
    uint[maxLightsPerNode] lights;
    uint numLights = 0;
}

class ClusteredLightManager: Owner
{
    View view;
    
    DynamicArray!LightSource lightSources;
    LightCluster[] clusterData;
    
    uint[] clusters;
    Vector3f[] lights;
    uint[] lightIndices;
    
    Vector2f clustersPosition;
    float sceneSize = 200.0f;
    float clusterSize;
    uint domainSize = 100;
    
    uint numLightAttributes = 4;
    
    uint maxNumLights = 512;
    uint maxNumIndices = 2048;
    
    GLuint clusterTexture;
    GLuint lightTexture;
    GLuint indexTexture;
    
    this(View v, Owner o)
    {
        super(o);
        view = v;
        
        clusterSize = sceneSize / cast(float)domainSize;
        clustersPosition = Vector2f(-sceneSize * 0.5f, -sceneSize * 0.5f);
        clusterData = New!(LightCluster[])(domainSize * domainSize);
        
        foreach(y; 0..domainSize)
        foreach(x; 0..domainSize)
        {
            LightCluster* c = &clusterData[y * domainSize + x];
            c.box = cellBox(x, y, clusterSize, sceneSize);
            c.numLights = 0;
        }

        clusters = New!(uint[])(domainSize * domainSize);
        
        foreach(ref c; clusters)
            c = 0;
        
        lights = New!(Vector3f[])(maxNumLights * numLightAttributes);
        foreach(ref l; lights)
            l = Vector3f(0, 0, 0);

        lightIndices = New!(uint[])(maxNumIndices);
        
        // 2D texture to store light clusters
        glEnable(GL_TEXTURE_2D);
        glGenTextures(1, &clusterTexture);
        glBindTexture(GL_TEXTURE_2D, clusterTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_R32UI, domainSize, domainSize, 0, GL_RED_INTEGER, GL_UNSIGNED_INT, clusters.ptr);
        glBindTexture(GL_TEXTURE_2D, 0);
        glDisable(GL_TEXTURE_2D);

        // 2D texture to store light data
        glEnable(GL_TEXTURE_2D);
        glGenTextures(1, &lightTexture);
        glBindTexture(GL_TEXTURE_2D, lightTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB32F, maxNumLights, numLightAttributes, 0, GL_RGB, GL_FLOAT, lights.ptr);
        glBindTexture(GL_TEXTURE_2D, 0);
        glDisable(GL_TEXTURE_2D);
        
        // 1D texture to store light indices per cluster
        glEnable(GL_TEXTURE_1D);
        glGenTextures(1, &indexTexture);
        glBindTexture(GL_TEXTURE_1D, indexTexture);
        glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage1D(GL_TEXTURE_1D, 0, GL_R32UI, maxNumIndices, 0, GL_RED_INTEGER, GL_UNSIGNED_INT, lightIndices.ptr);
        glBindTexture(GL_TEXTURE_1D, 0);
        glDisable(GL_TEXTURE_1D);
    }
    
    ~this()
    {
        if (glIsTexture(clusterTexture))
            glDeleteTextures(1, &clusterTexture);
            
        if (glIsTexture(lightTexture))
            glDeleteTextures(1, &lightTexture);
            
        if (glIsTexture(indexTexture))
            glDeleteTextures(1, &indexTexture);
    
        Delete(clusters);
        Delete(lights);
        Delete(lightIndices);
        
        lightSources.free();
        Delete(clusterData);
    }
    
    void addLight(Vector3f position, Color4f color, float radius)
    {
        lightSources.append(LightSource(position, color.rgb, radius));
    }
    
    void bindClusterTexture()
    {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, clusterTexture);
    }
    void unbindClusterTexture()
    {
        glBindTexture(GL_TEXTURE_2D, 0);
        glDisable(GL_TEXTURE_2D);
    }
    
    void bindLightTexture()
    {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, lightTexture);
    }
    void unbindLightTexture()
    {
        glBindTexture(GL_TEXTURE_2D, 0);
        glDisable(GL_TEXTURE_2D);
    }
    
    void bindIndexTexture()
    {
        glEnable(GL_TEXTURE_1D);
        glBindTexture(GL_TEXTURE_1D, indexTexture);
    }
    void unbindIndexTexture()
    {
        glBindTexture(GL_TEXTURE_1D, 0);
        glDisable(GL_TEXTURE_1D);
    }

    void update()
    {
        foreach(ref v; clusters)
            v = 0;
            
        foreach(ref c; clusterData)
        {        
            c.numLights = 0;
        }

        foreach(i, light; lightSources)
        if (i < maxNumLights)
        {        
            Vector3f lightPosEye = light.position * view.viewMatrix;
            
            lights[cast(uint)i] = lightPosEye;
            lights[maxNumLights + cast(uint)i] = light.color;
            lights[maxNumLights * 2 + cast(uint)i] = Vector2f(light.radius, 0, 0);

            Vector2f lightPosXZ = Vector2f(light.position.x, light.position.z);
            Circle lightCircle = Circle(lightPosXZ, light.radius);
            
            uint x1 = cast(uint)clampf(floor((lightCircle.center.x - lightCircle.radius + sceneSize * 0.5f) / clusterSize), 0, domainSize-1);
            uint y1 = cast(uint)clampf(floor((lightCircle.center.y - lightCircle.radius + sceneSize * 0.5f) / clusterSize), 0, domainSize-1);
            uint x2 = cast(uint)clampf(x1 + ceil(lightCircle.radius + lightCircle.radius) + 1, 0, domainSize-1);
            uint y2 = cast(uint)clampf(y1 + ceil(lightCircle.radius + lightCircle.radius) + 1, 0, domainSize-1);

            foreach(y; y1..y2)
            foreach(x; x1..x2)
            {
                Box b = cellBox(x, y, clusterSize, sceneSize);
                if (circleBoxIsec(lightCircle, b))
                {
                    auto c = &clusterData[y * domainSize + x];
                    if (c.numLights < maxLightsPerNode)
                    {
                        c.lights[c.numLights] = cast(uint)i;
                        c.numLights = c.numLights + 1;
                    }
                }
            }
        }
        
        uint offset = 0;
        foreach(ci, ref c; clusterData)
        if (offset < maxNumIndices)
        {
            if (offset + c.numLights > maxNumIndices)
            {
                offset = maxNumIndices - c.numLights;
                c.numLights = maxNumIndices - offset;
            }
        
            if (c.numLights)
            {                
                foreach(i; 0..c.numLights)
                    lightIndices[offset + cast(uint)i] = c.lights[i];

                clusters[ci] = offset | (c.numLights << 16);
                
                offset += c.numLights;
            }
            else
            {
                clusters[ci] = 0;
            }
        }

        glBindTexture(GL_TEXTURE_2D, clusterTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, domainSize, domainSize, GL_RED_INTEGER, GL_UNSIGNED_INT, clusters.ptr);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_2D, lightTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, maxNumLights, numLightAttributes, GL_RGB, GL_FLOAT, lights.ptr);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_1D, indexTexture);
        glTexSubImage1D(GL_TEXTURE_1D, 0, 0, maxNumIndices, GL_RED_INTEGER, GL_UNSIGNED_INT, lightIndices.ptr);
        glBindTexture(GL_TEXTURE_1D, 0);
    }
}
