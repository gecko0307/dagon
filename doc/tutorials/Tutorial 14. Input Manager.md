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
    
    override void onControllerButtonDown(int btn)
    {
        if (btn == GB_A)
        {
            // do something once when button is pressed
        }
    }
    
    override void onControllerButtonUp(int btn)
    {
        if (btn == GB_A)
        {
            // do something once when button is released
        }
    }
    
    override void onControllerAxisMotion(int axis, float value)
    {
        if (axis == GA_LEFTX)
        {
            // do something when axis is triggered
        }
    }
}
```

You can also use continuous checks via `eventManager` in `onUpdate` or any other method of your scene:

```d
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
```

All key and button codes, such as KEY_UP and MB_LEFT, are in `dagon.core.keycodes`. Here's the cheatsheet for gamepad buttons/axes, using Xbox-style gamepad as a reference:

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

Binding definition format consists of device type and name (or number) coresponding to button or axis of this device.

- `kb` - keyboard (`kb_up`, `kb_w`, etc.)
- `ma` - mouse axis (`ma_0`, etc.)
- `mb` - mouse button (`mb_1`, etc.)
- `ga` - gamepad axis (`ga_leftx`, `ga_lefttrigger`, etc.)
- `gb` - gamepad button (`gb_a`, `gb_x`, etc.)
- `va` - virtual axis, has special syntax, for example: `va(kb_up, kb_down)`

`ga` and `gb` bindings accept optional gamepad index, for example: `gb[0]_x` or `ga[1]_lefty`. Up to 4 gamepads are supported.

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

There's also `getAxis` method that returns a value in -1..1 range, which is useful for analog controls, such as steering in racing games. For example, you can assign gamepad axes and several virtual axes to `horizontal` and `vertical` bindings in your configuration:

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

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t14-input-manager)

## Appendix: supported key names
- `kb_a` .. `kb_z`, `kb_0` .. `kb_9`
- `kb_-`, `kb_=`, `kb_[`, `kb_]`, `kb_\`, `kb_#`, `kb_;`, `kb_'`, `kb_\``, `kb_,`, `kb_.`, `kb_/`
- `kb_return`, `kb_escape`, `kb_backspace`, `kb_delete`, `kb_tab`, `kb_space`, `kb_capsLock`
- `kb_f1` .. `kb_f24`
- `kb_printscreen`, `kb_scrolllock`, `kb_numlock`, `kb_pause`, `kb_insert`, `kb_home`, `kb_pageup`, `kb_pagedown`, `kb_end`
- `kb_left`, `kb_right`, `kb_up`, `kb_down`
- `kb_left_ctrl`, `kb_left_shift`, `kb_left_alt`, `kb_left_gui`
- `kb_right_ctrl`, `kb_right_shift`, `kb_right_alt`, `kb_right_gui`
- `kb_keypad_0` .. `kb_keypad_9`
- `kb_keypad_/`, `kb_keypad_*`, `kb_keypad_-`, `kb_keypad_+`, `kb_keypad_=`, `kb_keypad_enter`, `kb_keypad_.`, `kb_keypad_,`, `kb_keypad_00`, `kb_keypad_000`
- `kb_keypad_(`, `kb_keypad_)`, `kb_keypad_{`, `kb_keypad_}`, `kb_keypad_tab`, `kb_keypad_backspace`
- `kb_keypad_a`, `kb_keypad_b`, `kb_keypad_c`, `kb_keypad_d`, `kb_keypad_e`, `kb_keypad_f`
- `kb_keypad_xor`, `kb_keypad_^`, `kb_keypad_%`, `kb_keypad_<`, `kb_keypad_>`, `kb_keypad_&`, `kb_keypad_&&`, `kb_keypad_|`, `kb_keypad_||`, `kb_keypad_:`, `kb_keypad_#`, `kb_keypad_space`, `kb_keypad_@`, `kb_keypad_!`
- `kb_keypad_memstore`, `kb_keypad_memrecall`, `kb_keypad_memclear`, `kb_keypad_memadd`, `kb_keypad_memsubtract`, `kb_keypad_memmultiply`, `kb_keypad_memdivide`
- `kb_keypad_+/-`, `kb_keypad_clear`, `kb_keypad_clearentry`, `kb_keypad_binary`, `kb_keypad_octal`, `kb_keypad_decimal`, `kb_keypad_hexadecimal`
- `kb_mediaplay`, `kb_mediapause`, `kb_mediarecord`, `kb_mediafastforward`, `kb_mediarewind`, `kb_mediatracknext`, `kb_mediatrackprevious`, `kb_mediastop`, `kb_mediaplaypause`, `kb_mediaselect`
- `kb_nonusbackslash`, `kb_application`, `kb_power`
- `kb_execute`, `kb_help`, `kb_menu`, `kb_select`, `kb_stop`, `kb_again`, `kb_undo`, `kb_cut`, `kb_copy`, `kb_paste`, `kb_find`, `kb_mute`, `kb_volumeup`, `kb_volumedown`
- `kb_international_1` .. `kb_international_9`
- `kb_language_1` ..`kb_language_9`
- `kb_alterase`, `kb_sysreq`, `kb_cancel`, `kb_clear`, `kb_prior`, `kb_separator`, `kb_out`, `kb_oper`, `kb_clear_/_again`, `kb_crsel`, `kb_exsel`
- `kb_thousandsseparator`, `kb_decimalseparator`, `kb_currencyunit`, `kb_currencysubunit`
- `kb_modeswitch`, `kb_sleep`, `kb_wake`, `kb_channelup`, `kb_channeldown`
- `kb_eject`, 
- `kb_ac_new`, `kb_ac_open`, `kb_ac_close`, `kb_ac_exit`, `kb_ac_save`, `kb_ac_print`, `kb_ac_properties`, `kb_ac_search`, `kb_ac_home`, `kb_ac_back`, `kb_ac_forward`, `kb_ac_stop`, `kb_ac_refresh`, `kb_ac_bookmarks`
- `kb_softleft`, `kb_softright`
- `kb_call`, `kb_endcall`

## Appendix: supported mouse button and axis names
- `mb_left`, `mb_middle`, `mb_right`, `mb_x1`, `mb_x2`
- `ma_x`, `ma_y`

## Appendix: supported gamepad button and axis names
- `gb_dpup`, `gb_dpdown`, `gb_dpleft`, `gb_dpright`
- `gb_a`, `gb_b`, `gb_x`, `gb_y`
- `gb_back`, `gb_guide`, `gb_start`
- `gb_leftstick`, `gb_rightstick`
- `gb_leftshoulder`, `gb_rightshoulder`
- `gb_misc` (Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Amazon Luna microphone button)
- `gb_paddle1`, `gb_paddle2`, `gb_paddle3`, `gb_paddle4` (Xbox Elite paddles in order, facing the back: upper left, upper right, lower left, lower right)
- `gb_touchpad` (PS4/PS5 touchpad button)
- `ga_leftx`, `ga_lefty`
- `ga_rightx`, `ga_righty`
- `ga_triggerleft`, `ga_triggerright`
