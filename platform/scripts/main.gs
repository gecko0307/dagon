macro format = global.string.format;

macro LogLevelAll = 0;
macro LogLevelDebug = 1;
macro LogLevelInfo = 2;
macro LogLevelWarning = 3;
macro LogLevelError = 4;
macro LogLevelFatalError = 5;

global.timer = 0.0;
global.seconds = 0.0;

global.scene.onBeforeLoad = func(scene)
{
    global.log(LogLevelInfo, scene.name);
};

global.scene.onUpdate = func(scene, deltaTime)
{
    global.timer += deltaTime;
    if (global.timer >= 1.0)
    {
        global.timer = 0.0;
        global.seconds += 1.0;
    }
};

global.scene.onKeyDown = func(scene, key)
{
    global.log(LogLevelInfo, key);
};
