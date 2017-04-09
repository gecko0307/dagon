module dagon.templates.basescene;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.affine;
import dlib.image.color;
import dlib.container.array;

import derelict.opengl.gl;

import dagon.resource.scene;
import dagon.graphics.light;
import dagon.graphics.environment;
import dagon.graphics.rc;
import dagon.graphics.view;
import dagon.logics.entity;

class BaseScene3D: Scene
{
    LightManager lightManager;
    Environment environment;
    Color4f backgroundColor; // TODO: move this to Environment

    RenderingContext rc3d; 
    RenderingContext rc2d; 
    View view;

    DynamicArray!Entity entities3D;
    DynamicArray!Entity entities2D;

    this(SceneManager smngr)
    {
        super(smngr);
        backgroundColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
    }

    Entity createEntity2D()
    {
        Entity e = New!Entity(eventManager, this);
        entities2D.append(e);
        return e;
    }
    
    Entity createEntity3D()
    {
        Entity e = New!Entity(eventManager, this);
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
        lightManager = New!LightManager(this);
        environment = New!Environment(this);
    }
    
    override void onRelease()
    {
        entities3D.free();
        entities2D.free();
    }

    override void onStart()
    {
        rc3d.init(eventManager, environment);
        rc3d.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 100.0f);

        rc2d.init(eventManager, environment);
        rc2d.projectionMatrix = orthoMatrix(0.0f, eventManager.windowWidth, 0.0f, eventManager.windowHeight, 0.0f, 100.0f);
    }

    override void onUpdate(double dt)
    {
        if (view)
        {
            view.update(dt);
            view.prepareRC(&rc3d);
        }

        foreach(e; entities3D)
            e.update(dt);

        foreach(e; entities2D)
            e.update(dt);
    }

    override void onRender()
    {     
        glEnable(GL_DEPTH_TEST);

        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        rc3d.apply();

        foreach(e; entities3D)
            e.render(&rc3d);

        glDisable(GL_DEPTH_TEST); 

        rc2d.apply();

        foreach(e; entities2D)
            e.render(&rc2d);
    } 
}

