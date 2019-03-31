# Tutorial 8. Procedural Sky

In [[Tutorial 5|Tutorial 5. Environment Maps]], we have used Dagon's built-in sky object to show an environment map at the background. If you don't define an environment map, the engine will render a simple procedural sky instead:

![](https://www.dropbox.com/s/5ufo8udc1d08sca/sky.jpg?raw=1)

You can use `environment` object to change the day time:
```d
float sunPitch = -45.0f;
float sunTurn = 10.0f;

void sunControl(double dt)
{
    if (eventManager.keyPressed[KEY_DOWN]) sunPitch += 30.0f * dt;
    if (eventManager.keyPressed[KEY_UP]) sunPitch -= 30.0f * dt;
    if (eventManager.keyPressed[KEY_LEFT]) sunTurn += 30.0f * dt;
    if (eventManager.keyPressed[KEY_RIGHT]) sunTurn -= 30.0f * dt;
    environment.sunRotation = 
        rotationQuaternion(Axis.y, degtorad(sunTurn)) * 
        rotationQuaternion(Axis.x, degtorad(sunPitch));
}

override void onLogicsUpdate(double dt)
{
    sunControl(dt);
    cameraControl(dt);
}
```
![](https://www.dropbox.com/s/tpdvi4gnv3lol9e/dawn.jpg?raw=1)

The same scene can look quite different when using procedural sky and an environment map. The following is a comparison between the two:

![](https://www.dropbox.com/s/atf86mvebnqzg13/env-compare.jpg?raw=1)