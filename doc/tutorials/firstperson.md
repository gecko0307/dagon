# Tutorial 7. First Person Camera

To make, for example, a first person shooter, an appropriate `View` object should be used. Dagon has such an object - `FirstPersonView`:
```d
auto eCamera = createEntity3D();
eCamera.position = Vector3f(5.0f, 2.0f, 0.0f);
fpview = New!FirstPersonView(eventManager, eCamera, assetManager);
fpview.active = true;
view = fpview;
```
Now the user can rotate the camera with mouse, but can't move. Let's add some keyboard input: 

```d
void cameraControl(double dt)
{
    Vector3f forward = fpview.camera.characterMatrix.forward;
    Vector3f right = fpview.camera.characterMatrix.right; 
    float speed = 6.0f;
    Vector3f dir = Vector3f(0, 0, 0);
    if (eventManager.keyPressed[KEY_W]) dir += -forward;
    if (eventManager.keyPressed[KEY_S]) dir += forward;
    if (eventManager.keyPressed[KEY_A]) dir += -right;
    if (eventManager.keyPressed[KEY_D]) dir += right;
    fpview.camera.position += dir.normalized * speed * dt;
}
    
override void onLogicsUpdate(double dt)
{
    cameraControl(dt);
}
```
`onLogicsUpdate` is called with fixed rate (60 times per second by default, so `dt` equals `1.0 / 60.0`). If you want to use fully real-time update, override `onUpdate` method.

You might also want to listen to Escape key press, so that the user can easily close the application:
```d
override void onKeyDown(int key)
{
    if (key == KEY_ESCAPE)
    {
        exitApplication();
    }
}
```