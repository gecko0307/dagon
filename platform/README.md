# Dagon Platform

Dagon Platform will be a simple stand-alone game creation suite based on Dagon and [GScript3](https://github.com/gecko0307/gscript3). It is not finished yet, only the most basic features are exposed to the scripting engine at the moment.

The Platform consists of a pre-made Dagon application that executes user-provided script (`scripts/main.gsc`). The main script should be compiled to bytecode using `gs` compiler:

```
gs -c -i scripts/main.gs
```

The script works by registering custom event listeners to the `global.scene` object (or simply `scene` because `global` object is implicit). Events are basically the same as in `EventListener` in Dagon:

```
scene.onBeforeLoad = func(scene) {};
scene.onAfterLoad = func(scene) {};
scene.onUpdate = func(scene, deltaTime) {};
scene.onKeyDown = func(scene, key) {};
scene.onKeyUp = func(scene, key) {};
scene.onTextInput = func(scene, code) {};
scene.onMouseButtonDown = func(scene, button) {};
scene.onMouseButtonUp = func(scene, button) {};
scene.onMouseWheel = func(scene, x, y) {};
scene.onControllerButtonDown = func(scene, deviceIndex, button) {};
scene.onControllerButtonUp = func(scene, deviceIndex, button) {};
scene.onControllerAxisMotion = func(scene, deviceIndex, axis, value) {};
scene.onResize = func(scene, width, height) {};
scene.onFocusLoss = func(scene) {};
scene.onFocusGain = func(scene) {};
scene.onDropFil = funce(scene, filename) {};
scene.onUserEvent = func(scene, code) {};
scene.onTimerEvent = func(scene, timerID, userCode) {};
scene.onQuit = func(scene) {};
```

The following scene methods are currently available:

```
scene.addAsset(filename);
scene.addEntity();
```
