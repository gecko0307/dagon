# Event System

Dagon encourages event-driven programming and includes its own real-time event queue based on SDL input. While SDL assumes a single listener that polls for events via `SDL_PollEvent`, Dagon's event manager aggregates SDL events into its own queue, allowing an unlimited number of listener objects (inheriting from `EventListener`) to poll for events. In contrast to many similar systems, Dagon's event system doesn't require event listeners to be registered. Instead, all listeners access the global queue and, if enabled, respond to events via dynamic dispatch in real time. For engine's built-in game objects this is done automatically, but if you create your own `EventListener`s, you have full control over their dispatching process.

## Events

Most part of the system relies on SDL input events, such as keyboard, mouse and gamepad input, system notifications and window events. There are also a number of custom events for internal message passing. All events are unified under a common `Event` structure.

A list of supported event types:

### Keyboard
- `KeyDown`, `KeyUp` - keyboard key pressed/released. Reports key codes (via `Event.key`) defined as `KEY_*` constants in `dagon.core.keycodes` (equivalent to `SDL_Scancode`)
- `TextInput` - alphanumeric keyboard is used to type text. This event respects system-wide keyboard layout and reports a 32-bit Unicode codepoint (via `Event.unicode`)

### Mouse
- `MouseMotion` - mouse cursor is moved inside an application window. This event doesn't propagate to the listeners - instead, it updates `EventManager.mouseX` and `EventManager.mouseY`, mouse pointer coordinates relative to the window
- `MouseButtonDown`, `MouseButtonUp` - mouse button pressed/released. Reports mouse button codes (via `Event.button`) defined as `MB_*` constants in `dagon.core.keycodes` (equivalent to `SDL_MouseButtonFlags`)
- `MouseWheel` - mouse wheel scrolled. Reports via `Event.mouseWheelX`, `Event.mouseWheelY`

### Gamepad
- `JoystickButtonDown`, `JoystickButtonUp` - joystick button pressed/released. Reports a button number (via `Event.joystickButton`)
- `ControllerButtonDown`, `ControllerButtonUp` - controller button pressed/released. Reports a button type (via `Event.controllerButton`) defined as `GB_*` constants in `dagon.core.keycodes` (equivalent to `SDL_GameControllerButton`)
- `ControllerAxisMotion` - controller axis moved. Reports an axis type (via `Event.controllerAxis`) defined as `GA_*` constants in `dagon.core.keycodes` (equivalent to `SDL_GameControllerAxis`), and an axis value (via `Event.controllerAxisValue`) as floating-point in -1..1 range. SDL reports axis values as integers - Dagon normalizes them, so that these values can be used properly in further calculations. You can fine-tune normalization by changing `EventManager.controllerAxisThreshold` (32639 by default), though this is usually not needed for most of the devices
- `ControllerAdd`, `ControllerRemove` - controller plugged/unplugged. Reports `Event.controllerDeviceIndex`

### Window
- `Resize` - window is resized. Reports new size as `Event.width`, `Event.height`
- `FocusLoss`, `FocusGain` - window lost or gained focus. These are useful to take action when the user is not interacting with the game. Reports no data
- `Quit` - the window is closed. In this case the application will automatically terminate, but the game code can do something before the imminent exit (cleanup or graceful shutdown). Reports no data
- `DropFile` - the user dragged and dropped a file into the application window. Useful for editors or custom import features. Reports `Event.filename`

### Filesystem
- `FileChange` - emitted when an asset is modified by an external application (if the file is being monitored for changes). Reports `Event.filename`

### Logic flow
- `Message` - a message is received from the `MessageBroker`. See the Messaging System documentation for details. Reports `Event.message`, `Event.sender`, `Event.domain`, `Event.payload`
- `Task` - a task is received from the `MessageBroker`. See the Messaging System documentation for details. Reports `Event.callback`, `Event.sender`, `Event.domain`, `Event.payload`
- `UserEvent` - a user event is emitted. User events carry user-defined signed integer codes (`Event.code`). All negative codes are reserved to Dagon's internals. Currently, one negative code is defined, `DagonEvent.Exit` (-1)

### Misc
- `Log` - an asynchronous log event. It doesn't propagate to the listeners - instead, it is immediately handled by the `EventManager` itself
- `Cancelled` - event is obsolete and should be ignored (special status for internal use). Cancelled events don't propagate to the listeners.

## Joysticks vs Controllers

Dagon, like SDL, provides two abstraction layers to work with game input devices - joysticks and controllers. The distinction between them lies in the level of standardization.

Joystick is an abstraction of any gaming device with buttons and axes that can be connected to the system. It does not require the device to support standardized control schemes. A "joystick" can be anything: a steering wheel, an arcade pad, a controller from a rare manufacturer. SDL API simply reports button or axe number, but does not interpret their functions (e.g. which joystick is the left or right stick).

Controller is a joystick that SDL recognizes as a "standard gamepad" (XInput, DualShock, Switch Pro, etc.). Controllers have fixed standard buttons and axes: A/B/X/Y, left and right triggers, sticks, d-pad. SDL allows the application to access buttons by action type, rather than by number. Controller API is very convenient for adapting the input logic to different devices - the code is the same for all controllers that SDL recognizes.
