module main;

import std.file;
import dagon;
import gscript;

class CoreScene: Scene, GsObject
{
    CoreGame game;
    Dict!(GsDynamic, string) storage;
    GsDynamic[4] scriptCallArgs;
    
    Camera camera;
    FirstPersonViewComponent fpview;

    this(CoreGame game)
    {
        super(game);
        this.game = game;
        address = "CoreScene";
        storage = dict!(GsDynamic, string);
        scriptCallArgs[0] = GsDynamic(this);
    }
    
    ~this()
    {
        Delete(storage);
    }
    
    GsDynamic get(string key)
    {
        switch(key)
        {
            case "name":
                return GsDynamic(address);
            default:
                auto v = key in storage;
                if (v)
                    return *v;
                else
                    return GsDynamic();
        }
    }
    
    void set(string key, GsDynamic value)
    {
        storage[key] = value;
    }
    
    bool contains(string key)
    {
        switch(key)
        {
            case "name":
                return true;
            default:
                if ((key in storage) !is null)
                    return true;
                else
                    return false;
        }
    }
    
    void setPrototype(GsObject)
    {
        // No-op
    }
    
    void triggerScriptEvent(string name, GsDynamic[] args)
    {
        GsDynamic* eventHandler = name in storage;
        if (eventHandler)
        {
            if (eventHandler.type == GsDynamicType.String)
                game.vm.call(eventHandler.asString, args);
        }
    }

    override void beforeLoad()
    {
        aOBJSuzanne = addOBJAsset("assets/suzanne.obj");
        
        triggerScriptEvent("onBeforeLoad", scriptCallArgs[0..1]);
    }

    override void afterLoad()
    {
        camera = addCamera();
        camera.position = Vector3f(0.0f, 1.8f, 5.0f);
        fpview = New!FirstPersonViewComponent(eventManager, camera);
        game.renderer.activeCamera = camera;

        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 10.0f;
        sun.pitch(-45.0f);
        sun.shadowMap.resize(1024);
        
        auto ePlane = addEntity();
        ePlane.drawable = New!ShapePlane(10, 10, 1, assetManager);
        
        triggerScriptEvent("onAfterLoad", scriptCallArgs[0..1]);
    }
    
    override void onUpdate(Time t)
    {
        // Camera movement
        float speed = 5.0f * t.delta;
        if (inputManager.getButton("forward")) camera.move(-speed);
        if (inputManager.getButton("back")) camera.move(speed);
        if (inputManager.getButton("left")) camera.strafe(-speed);
        if (inputManager.getButton("right")) camera.strafe(speed);
        
        scriptCallArgs[1] = GsDynamic(t.delta);
        triggerScriptEvent("onUpdate", scriptCallArgs[0..2]);
    }
    
    override void onKeyDown(int key)
    {
        scriptCallArgs[1] = GsDynamic(key);
        triggerScriptEvent("onKeyDown", scriptCallArgs[0..2]);
    }
    
    override void onKeyUp(int key)
    {
        scriptCallArgs[1] = GsDynamic(key);
        triggerScriptEvent("onKeyUp", scriptCallArgs[0..2]);
    }
    
    override void onTextInput(dchar code)
    {
        scriptCallArgs[1] = GsDynamic(code);
        triggerScriptEvent("onTextInput", scriptCallArgs[0..2]);
    }
    
    override void onMouseButtonDown(int button)
    {
        scriptCallArgs[1] = GsDynamic(button);
        triggerScriptEvent("onMouseButtonDown", scriptCallArgs[0..2]);
    }
    
    override void onMouseButtonUp(int button)
    {
        fpview.active = !fpview.active;
        eventManager.showCursor(!fpview.active);
        fpview.prevMouseX = eventManager.mouseX;
        fpview.prevMouseY = eventManager.mouseY;
        
        scriptCallArgs[1] = GsDynamic(button);
        triggerScriptEvent("onMouseButtonUp", scriptCallArgs[0..2]);
    }
    
    override void onMouseWheel(int x, int y)
    {
        scriptCallArgs[1] = GsDynamic(x);
        scriptCallArgs[2] = GsDynamic(y);
        triggerScriptEvent("onMouseWheel", scriptCallArgs[0..3]);
    }
    
    override void onControllerButtonDown(uint deviceIndex, int btn)
    {
        scriptCallArgs[1] = GsDynamic(deviceIndex);
        scriptCallArgs[2] = GsDynamic(btn);
        triggerScriptEvent("onControllerButtonDown", scriptCallArgs[0..3]);
    }
    
    override void onControllerButtonUp(uint deviceIndex, int btn)
    {
        scriptCallArgs[1] = GsDynamic(deviceIndex);
        scriptCallArgs[2] = GsDynamic(btn);
        triggerScriptEvent("onControllerButtonUp", scriptCallArgs[0..3]);
    }
    
    override void onControllerAxisMotion(uint deviceIndex, int axis, float value)
    {
        scriptCallArgs[1] = GsDynamic(deviceIndex);
        scriptCallArgs[2] = GsDynamic(axis);
        scriptCallArgs[3] = GsDynamic(value);
        triggerScriptEvent("onControllerAxisMotion", scriptCallArgs[0..4]);
    }
    
    override void onResize(int width, int height)
    {
        scriptCallArgs[1] = GsDynamic(width);
        scriptCallArgs[2] = GsDynamic(height);
        triggerScriptEvent("onResize", scriptCallArgs[0..3]);
    }
    
    override void onFocusLoss()
    {
        triggerScriptEvent("onFocusLoss", scriptCallArgs[0..1]);
    }
    
    override void onFocusGain()
    {
        triggerScriptEvent("onFocusGain", scriptCallArgs[0..1]);
    }
    
    override void onDropFile(string filename)
    {
        scriptCallArgs[1] = GsDynamic(filename);
        triggerScriptEvent("onDropFile", scriptCallArgs[0..2]);
    }
    
    override void onUserEvent(int code)
    {
        scriptCallArgs[1] = GsDynamic(code);
        triggerScriptEvent("onUserEvent", scriptCallArgs[0..2]);
    }
    
    override void onTimerEvent(int timerID, int userCode)
    {
        scriptCallArgs[1] = GsDynamic(timerID);
        scriptCallArgs[2] = GsDynamic(userCode);
        triggerScriptEvent("onTimerEvent", scriptCallArgs[0..3]);
    }
    
    override void onMessage(int domain, string sender, string message, void* payload)
    {
        logInfo("Scene received from ", sender, ": ", message);
    }
    
    override void onQuit()
    {
        triggerScriptEvent("onQuit", scriptCallArgs[0..1]);
    }
}

class CoreGame: Game
{
    CoreScene coreScene;
    
    GsVirtualMachine vm;
    GsInstruction[] scriptProgram;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        
        eventManager.messageBroker.enabled = true;
        
        coreScene = New!CoreScene(this);
        currentScene = coreScene;
        
        vm = New!GsVirtualMachine(this);
        vm.set("log", GsDynamic(&vmLog));
        vm.set("send", GsDynamic(&vmSend));
        vm.set("scene", GsDynamic(coreScene));
        
        ubyte[] code = cast(ubyte[])std.file.read("scripts/main.gsc");
        scriptProgram = loadBytecode(code);
        if (scriptProgram.length)
        {
            vm.load(scriptProgram);
            vm.run();
        }
    }
    
    GsDynamic vmLog(GsDynamic[] args)
    {
        auto logLevel = cast(LogLevel)cast(uint)args[1].asNumber;
        auto message = args[2].toString;
        log(logLevel, message);
        return GsDynamic();
    }
    
    GsDynamic vmSend(GsDynamic[] args)
    {
        auto recipient = args[1].asString;
        auto message = args[2].asString;
        queueMessage(recipient, message, null, 1);
        return GsDynamic();
    }
}

void main(string[] args)
{
    CoreGame game = New!CoreGame(1280, 720, false, "Dagon Platform", args);
    game.run();
    Delete(game);
    debug logDebug("Leaked memory: ", allocatedMemory, " byte(s)");
}
