module main;

import std.stdio;
import std.conv;
import std.string;

import dagon.all;

class MovementController: Behaviour
{
    this(Entity e)
    {
        super(e);
    }

    override void update(double dt)
    {
        if (eventManager.keyPressed[KEY_LEFT])
            entity.behaviour!(Transformation).move(Vector3f(2.0 * dt, 0, 0));
        if (eventManager.keyPressed[KEY_RIGHT])
            entity.behaviour!(Transformation).move(Vector3f(-2.0 * dt, 0, 0));
    }
}

class My3DScene: Scene
{
    Entity sphere;
    Entity sphere2;

    RenderingContext rc;    
    Freeview freeview;

    this(SceneManager smngr)
    {
        super(smngr);

        freeview = New!Freeview(eventManager, this);
        freeview.camera.setZoom(6.0f);

        ShapeSphere shapeSphere = New!ShapeSphere(1.0f, this);

        sphere = New!Entity(eventManager, this);
        Transformation sphereTransform = New!Transformation(sphere);
        MovementController uc = New!MovementController(sphere);
        sphere.drawable = shapeSphere;

        sphere2 = New!Entity(eventManager, this);
        ParentRelation sphere2PR = New!ParentRelation(sphere2, sphere);
        Transformation sphere2Transform = New!Transformation(sphere2);
        sphere2.drawable = shapeSphere;
        
        rc.init(eventManager);
        rc.modelViewMatrix = translationMatrix(Vector3f(0.0f, 0.0f, 0.0f));
        rc.normalMatrix = matrix4x4to3x3(rc.modelViewMatrix.inverse).transposed;
        rc.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 100.0f);
    }

    override void onStart()
    {
        sphere.behaviour!(Transformation).reset();
        sphere2.behaviour!(Transformation).reset();
        sphere2.behaviour!(Transformation).position = Vector3f(0, 0, 2);
    }

    override void onEnd()
    {
    }

    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
            exitApplication();
        else if (key == KEY_2)
            sceneManager.setCurrentScene("bluescene");
    }

    override void onUpdate(double dt)
    {
        freeview.update(dt);
        sphere.update(dt);
        sphere2.update(dt);
    }

    override void onRender()
    {     
        glEnable(GL_DEPTH_TEST);
        rc.modelViewMatrix = freeview.viewMatrix();
        rc.normalMatrix = matrix4x4to3x3(rc.modelViewMatrix.inverse).transposed;
        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf(rc.projectionMatrix.arrayof.ptr);
        glMatrixMode(GL_MODELVIEW);
        glLoadMatrixf(rc.modelViewMatrix.arrayof.ptr);
        sphere.render();
        sphere2.render();
    } 
}

class BlueScene: Scene
{
    this(SceneManager smngr)
    {
        super(smngr);
    }

    override void onStart()
    {
    }

    override void onEnd()
    {
    }

    override void onKeyDown(int key)
    {
        if (key == SDL_SCANCODE_ESCAPE)
            exitApplication();
        else if (key == SDL_SCANCODE_1)
            sceneManager.setCurrentScene("myscene");
    }

    override void onUpdate(double dt)
    {
    }

    override void onRender()
    {     
        glEnable(GL_DEPTH_TEST);
        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    } 
}

class MyApplication: SceneApplication
{
    this(string[] args)
    {
        super(800, 600, args);

        My3DScene myscene = New!My3DScene(sceneManager);
        sceneManager.addScene(myscene, "myscene");

        BlueScene blueScene = New!BlueScene(sceneManager);
        sceneManager.addScene(blueScene, "bluescene");

        sceneManager.setCurrentScene("myscene");
    }
}

void main(string[] args)
{
    writeln(allocatedMemory);
    MyApplication app = New!MyApplication(args);
    app.run();
    Delete(app);
    writeln(allocatedMemory);
}

