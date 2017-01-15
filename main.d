module main;

import std.stdio;
import std.conv;
import std.string;

import dagon.all;

import dmech.geometry;
import dmech.rigidbody;
import dmech.world;

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

class RigidBodyController: Behaviour
{
    RigidBody rbody;
    uint shapeIndex = 0;
    Transformation transformation;

    this(Entity e, RigidBody b, uint shapeIndex = 0)
    {
        super(e);
        rbody = b;
        this.shapeIndex = shapeIndex;
        
        if (entity.behaviour!(Transformation) is null)
        {
            auto t = New!Transformation(entity);
            t.position = b.position;
            t.rotation = b.orientation;
            transformation = t;
        }
        else
        {
            transformation = entity.behaviour!(Transformation);
            b.position = transformation.position;
            b.orientation = transformation.rotation;
        }
        
        transformation.autoUpdate = false;
    }

    override void update(double dt)
    {            
        transformation.tmatrix = rbody.shapes[shapeIndex].transformation;
    }
}

class My3DScene: Scene
{
    LightManager lightManager;
    
    Entity sphere;
    Entity sphere2;

    RenderingContext rc;    
    Freeview freeview;

    TextAsset text;
    TextureAsset tex;
    IQMAsset iqm;

    Entity animmodel;
    Actor actor;

    Entity boxE;
    
    PhysicsWorld world;
    double physicsTimer;
    enum fixedTimeStep = 1.0 / 60.0;

    this(SceneManager smngr)
    {
        super(smngr);
        assetManager.mountDirectory("data");
        assetManager.mountDirectory("data/testmodel");

        assetManager.liveUpdate = true;
    }

    override void onAssetsRequest()
    {
        text = addTextAsset("data/test.txt");
        tex = addTextureAsset("data/stone.png");
        iqm = New!IQMAsset();
        addAsset(iqm, "data/testmodel/testmodel.iqm");
    }
    
    Entity createEntity3D()
    {
        Entity e = New!Entity(eventManager, this);
        auto t = New!Transformation(e);
        auto lr = New!LightReceiver(e, lightManager);
        return e;
    }

    override void onAllocate()
    {
        lightManager = New!LightManager(this);
        lightManager.addPointLight(Vector3f(3, 3, 0), Color4f(1.0, 0.0, 0.0, 1.0));
        lightManager.addPointLight(Vector3f(-3, 3, 0), Color4f(0.0, 1.0, 1.0, 1.0));
    
        freeview = New!Freeview(eventManager, this);
        freeview.camera.setZoom(6.0f);

        ShapeSphere shapeSphere = New!ShapeSphere(1.0f, this);

        sphere2 = createEntity3D();
        sphere2.behaviour!(Transformation).position = Vector3f(0, 0, -3);
        sphere2.drawable = shapeSphere;

        actor = New!Actor(iqm.model, this);
        animmodel = createEntity3D();
        Transformation animTransform = New!Transformation(animmodel);
        animmodel.drawable = actor;

        world = New!PhysicsWorld();
        
        RigidBody bGround = world.addStaticBody(Vector3f(0.0f, -1.0f, 0.0f));
        gGround = New!GeomBox(Vector3f(40.0f, 1.0f, 40.0f));
        world.addShapeComponent(bGround, gGround, Vector3f(0.0f, 0.0f, 0.0f), 1.0f);

        ShapeBox shapeBox = New!ShapeBox(1, 1, 1, this);
        boxE = createEntity3D();
        boxE.drawable = shapeBox;
        boxE.behaviour!(Transformation).position = Vector3f(0, 5, 3);
        
        bBox = world.addDynamicBody(Vector3f(0, 5, 3), 0.0f);
        gBox = New!GeomBox(Vector3f(1.0f, 1.0f, 1.0f));
        world.addShapeComponent(bBox, gBox, Vector3f(0.0f, 0.0f, 0.0f), 1.0f);
        RigidBodyController rbc = New!RigidBodyController(boxE, bBox);
    }
    
    RigidBody bGround;
    Geometry gGround;
    
    Geometry gBox;
    RigidBody bBox;
    
    override void onRelease()
    {
        Delete(world);
        Delete(gGround);
        Delete(gBox);
    }

    override void onStart()
    {
        rc.init(eventManager);
        rc.projectionMatrix = perspectiveMatrix(60.0f, eventManager.aspectRatio, 0.1f, 100.0f);

        writeln(text.text);

        tex.texture.scale = Vector2f(2.0f, 2.0f);
        
        actor.play();
        
        physicsTimer = 0.0;
    }

    override void onEnd()
    {
    }

    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
            exitApplication();
        else if (key == KEY_2)
            sceneManager.loadAndSwitchToScene("bluescene");
    }
    
    void doLogics()
    {
    }

    override void onUpdate(double dt)
    {
        physicsTimer += dt;
        if (physicsTimer >= fixedTimeStep)
        {
            doLogics();
            physicsTimer -= fixedTimeStep;
            world.update(fixedTimeStep);
        }
        
    
        freeview.update(dt);
        sphere2.update(dt);
        animmodel.update(dt);
        boxE.update(dt);

        rc.viewMatrix = freeview.viewMatrix();
        rc.invViewMatrix = freeview.invViewMatrix();
        rc.normalMatrix = matrix4x4to3x3(rc.invViewMatrix).transposed;
    }

    Vector4f lightDir = Vector4f(0, 1, 0, 0);

    override void onRender()
    {     
        glEnable(GL_DEPTH_TEST);

        glViewport(0, 0, eventManager.windowWidth, eventManager.windowHeight);
        glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf(rc.projectionMatrix.arrayof.ptr);
        glMatrixMode(GL_MODELVIEW);
        glLoadMatrixf(rc.viewMatrix.arrayof.ptr);
        tex.texture.bind();
        boxE.render();
        tex.texture.unbind();
        sphere2.render();
        animmodel.render();
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
        if (key == KEY_ESCAPE)
            exitApplication();
        else if (key == KEY_1)
            sceneManager.loadAndSwitchToScene("myscene");
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

        sceneManager.loadAndSwitchToScene("myscene");
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

