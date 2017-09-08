module dagon.templates.basescene;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.transformation;
import dlib.image.color;
import dlib.container.array;

import derelict.opengl.gl;

import dagon.resource.scene;
import dagon.graphics.light;
import dagon.graphics.environment;
import dagon.graphics.rc;
import dagon.graphics.view;
import dagon.logics.entity;

import std.stdio;

class BaseScene3D: Scene
{
    LightManager lightManager;
    Environment environment;

    RenderingContext rc3d; 
    RenderingContext rc2d; 
    View view;

    DynamicArray!Entity entities3D;
    DynamicArray!Entity entities2D;

    double timer;
    double fixedTimeStep = 1.0 / 60.0;

    this(SceneManager smngr)
    {
        super(smngr);
    }

    Entity createEntity2D()
    {
        Entity e = New!Entity(eventManager, assetManager);
        entities2D.append(e);
        return e;
    }
    
    Entity createEntity3D()
    {
        Entity e = New!Entity(eventManager, assetManager);
        auto lr = New!LightReceiver(e, lightManager);
        entities3D.append(e);
        return e;
    }

    Light addPointLight(Vector3f position, Color4f color)
    {
        Light light = lightManager.addPointLight(position, color);
        return light;
    }

    override void onAllocate()
    {    
        lightManager = New!LightManager(assetManager);
        environment = New!Environment(assetManager);
    }
    
    override void onRelease()
    {
        entities3D.free();
        entities2D.free();
    }

    override void onStart()
    {
        rc3d.init(eventManager, environment);
        rc3d.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 500.0f);

        rc2d.init(eventManager, environment);
        rc2d.projectionMatrix = orthoMatrix(0.0f, eventManager.windowWidth, 0.0f, eventManager.windowHeight, 0.0f, 100.0f);

        timer = 0.0;
    }

    void onLogicsUpdate(double dt)
    {
    }

    override void onUpdate(double dt)
    {
        foreach(e; entities3D)
            e.processEvents();

        foreach(e; entities2D)
            e.processEvents();

        timer += dt;
        if (timer >= fixedTimeStep)
        {
            timer -= fixedTimeStep;

            if (view)
            {
                view.update(fixedTimeStep);
                view.prepareRC(&rc3d);
            }

            onLogicsUpdate(fixedTimeStep);
            environment.update(dt);

            foreach(e; entities3D)
                e.update(fixedTimeStep);

            foreach(e; entities2D)
                e.update(fixedTimeStep);
        }
    }

    void renderEntities3D(RenderingContext* rc)
    {
        glEnable(GL_DEPTH_TEST);
        foreach(e; entities3D)
            e.render(rc);
    }

    void renderEntities2D(RenderingContext* rc)
    {
        glDisable(GL_DEPTH_TEST);
        foreach(e; entities2D)
            e.render(rc);
    }
    
    void prepareRender()
    {
        glEnable(GL_SCISSOR_TEST);
        glScissor(0, 0, eventManager.windowWidth, eventManager.windowHeight);

        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(environment.backgroundColor.r, environment.backgroundColor.g, environment.backgroundColor.b, environment.backgroundColor.a);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }

    override void onRender()
    {     
        prepareRender();
        rc3d.apply();
        renderEntities3D(&rc3d);
        rc2d.apply();
        renderEntities2D(&rc2d);
    } 
}
