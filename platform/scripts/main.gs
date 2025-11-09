const persistent = addPersistentStorage("data.conf");
print persistent.foo;
persistent.foo = "bar";

const assets = {};
let eSuzanne;

scene.onBeforeLoad = func(scene)
{
    assets.suzanne = scene.addAsset("assets/suzanne.obj");
};

scene.onAfterLoad = func(scene)
{
    eSuzanne = scene.addEntity();
    eSuzanne.drawable = assets.suzanne.mesh;
    eSuzanne.position = vector(0, 1, 0);
    eSuzanne.name = "Suzanne";
};

scene.onUpdate = func(scene, deltaTime)
{
};

scene.onKeyDown = func(scene, key)
{
};

scene.onUserEvent = func(scene, code)
{
};
