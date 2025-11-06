macro format = global.string.format;

const assets = {};
let eSuzanne;

global.scene.onBeforeLoad = func(scene)
{
    assets.suzanne = scene.addAsset("assets/suzanne.obj");
};

global.scene.onAfterLoad = func(scene)
{
    eSuzanne = scene.addEntity();
    eSuzanne.drawable = assets.suzanne.mesh;
    eSuzanne.position = [0, 1, 0];
};

global.scene.onUpdate = func(scene, deltaTime)
{
};

global.scene.onKeyDown = func(scene, key)
{
};
