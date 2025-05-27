# Tutorial 7. First Person Camera

To make, for example, a first person shooter, you can use built-in `FirstPersonViewComponent` on the camera:
```d
auto camera = addCamera();
camera.position = Vector3f(5.0f, 2.0f, 0.0f);
fpview = New!FirstPersonViewComponent(eventManager, camera);
```
Now the user can rotate the camera with mouse, but can't move. Let's add some input: 

```d
override void onUpdate(Time time)
{
    float speed = 5.0f * time.delta;
    if (inputManager.getButton("forward")) camera.move(-speed);
    if (inputManager.getButton("back")) camera.move(speed);
    if (inputManager.getButton("left")) camera.strafe(-speed);
    if (inputManager.getButton("right")) camera.strafe(speed);
}
```
`onUpdate` is called with fixed rate (60 times per second by default, so `time.delta` equals `1.0 / 60.0`).

You might also want to listen to Escape key press, so that the user can easily close the application:
```d
override void onKeyDown(int key)
{
    if (key == KEY_ESCAPE)
    {
        application.exit();
    }
}
```

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t7-first-person-camera)
