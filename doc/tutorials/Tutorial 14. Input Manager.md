# Tutorial 14. User Input and the Input Manager

Any game has some way of user interaction - via mouse, keyboard, or a gamepad. In Dagon, the simplest way to add user input is to listen to keyboard, mouse and gamepad events in your scene (or in any `EventListener` implementation) and take action when particular event occurs:

```d
class TestScene: Scene
{
    override void onKeyDown(int key)
    {
        if (key == KEY_UP)
        {
            // do something once when key is pressed
        }
    }
    
    override void onKeyUp(int key)
    {
        if (key == KEY_UP)
        {
            // do something once when key is released
        }
    }
    
    override void onMouseButtonDown(int btn)
    {
        if (btn == MB_LEFT)
        {
            // do something once when button is pressed
        }
    }
    
    override void onMouseButtonUp(int btn)
    {
        if (btn == MB_LEFT)
        {
            // do something once when button is released
        }
    }
    
    override void onJoystickButtonDown(int btn)
    {
        if (btn == GB_A)
        {
            // do something once when button is pressed
        }
    }
    
    override void onJoystickButtonUp(int btn)
    {
        if (btn == GB_A)
        {
            // do something once when button is released
        }
    }
    
    override void onJoystickAxisMotion(int axis, float value)
    {
        if (axis == GA_LEFTX)
        {
            // do something when axis is triggered
        }
    }
}
```

You can also use continuous checks via `eventManager` in `onUpdate` or any other method of your scene:

override void onUpdate(Time r)
{
    if (eventManager.keyPressed[KEY_UP])
    {
        // do something while key is pressed...
    }
    
    if (eventManager.mouseButtonPressed[MB_LEFT])
    {
        // do something while button is pressed...
    }
    
    if (eventManager.controllerButtonPressed[GB_A])
    {
        // do something while button is pressed...
    }
}

All key and button codes, such as KEY_UP and MB_LEFT, are in `dagon.core.keycodes`. Here's the cheatsheet for gamepad buttons/axes:

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/dagon_game_controller_constants.jpg?raw=true)

This approach is suitable only for simple demos. In a real game you'll want to give players a possibility to customize game controls, so you are not going to hardcode any keys or gamepad buttons in game code. Dagon provides an input manager that abstractizes the way how user interacts with the application. It allows to use abstract logic commands like "go forward", "jump", "fire", etc. Keyboard/gamepad mappings for these commands should be defined in a user-editable configuration file. The input manager is available in `EventManager` class as `inputManager` property. Any `EventListener` has a shortcut to it, so you can use it directly from your scene.

A logic command in this system is called "binding". Bindings are defined in `input.conf` file in your game's directory. The following is a content of a simple `input.conf` that you can copy to your project:

```
forward: "kb_w, kb_up, gb_b";
back: "kb_s, kb_down, gb_a";
left: "kb_a, kb_left";
right: "kb_d, kb_right";
jump: "kb_space";
interact: "kb_e";
```
Binding definition format consists of device type and name(or number) coresponding to button or axis of this device.

```
kb - keyboard (kb_up, kb_w, etc.)
ma - mouse axis (ma_0, etc.)
mb - mouse button (mb_1, etc.)
ga - gamepad axis (ga_leftx, ga_lefttrigger, etc.)
gb - gamepad button (gb_a, gb_x, etc.)
va - virtual axis, has special syntax, for example: va(kb_up, kb_down)
```

To use input manager, you don't need to subscribe to events, all is done with the `getButton` method:

```d
override void onUpdate(Time t)
{
    if (inputManager.getButton("forward"))
        character.move(-camera.directionAbsolute, speed);
    if (inputManager.getButton("jump"))
        character.jump();
}
```

`getButton` is a continuous check, there are also `getButtonDown` and `getButtonUp` to check if a binding is triggered or released, respectively.

There's also `getAxis` method that returns a value in -1..1 range, which is useful for analog controls, such as steering in racing games. For example, you can assign joystick axes and several virtual axes to `horizontal` and `vertical` bindings in your configuration:

```
horizontal: "ga_leftx, va(kb_right, kb_left), va(gb_dpright, gb_dpleft)";
vertical: "ga_lefty, va(kb_down, kb_up), va(gb_dpdown, gb_dpup)";
```

```d
override void onUpdate(Time t)
{
    spaceship.yaw(inputManager.getAxis("horizontal"));
    spaceship.pitch(inputManager.getAxis("vertical"));
}
```
