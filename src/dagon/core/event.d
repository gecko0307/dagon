/*
Copyright (c) 2014-2022 Timur Gafarov, Mateusz Muszyński

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dagon.core.event;

import std.stdio;
import std.ascii;
import std.conv;
import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.utils;
import dlib.container.array;
import dagon.core.bindings;
import dagon.core.input;

enum EventType
{
    KeyDown,
    KeyUp,
    TextInput,
    MouseMotion,
    MouseButtonDown,
    MouseButtonUp,
    MouseWheel,
    JoystickButtonDown,
    JoystickButtonUp,
    JoystickAxisMotion,
    Resize,
    FocusLoss,
    FocusGain,
    Quit,
    FileChange,
    DropFile,
    UserEvent
}

struct Event
{
    EventType type;
    int key;
    dchar unicode;
    int button;
    int joystickButton;
    int joystickAxis;
    float joystickAxisValue;
    int width;
    int height;
    int userCode;
    int mouseWheelX;
    int mouseWheelY;
    string filename;
}

class EventManager
{
    SDL_Window* window;

    enum maxNumEvents = 50;
    Event[maxNumEvents] eventStack;
    Event[maxNumEvents] userEventStack;
    uint numEvents;
    uint numUserEvents;

    bool running = true;

    bool[512] keyPressed = false;
    bool[512] keyUp = false;
    bool[512] keyDown = false;

    bool[255] mouseButtonPressed = false;
    bool[255] mouseButtonUp = false;
    bool[255] mouseButtonDown = false;

    bool[255] controllerButtonPressed = false;
    bool[255] controllerButtonUp = false;
    bool[255] controllerButtonDown = false;
    
    bool[255] joystickButtonPressed = false;
    bool[255] joystickButtonUp = false;
    bool[255] joystickButtonDown = false;

    Array!(bool*) toReset; // Used for resetting UP and DOWN events after end of frame

    int mouseX = 0;
    int mouseY = 0;
    int mouseRelX = 0;
    int mouseRelY = 0;
    bool enableKeyRepeat = false;

    double deltaTime = 0.0;
    uint deltaTimeMs = 0;

    uint windowWidth;
    uint windowHeight;
    bool windowFocused = true;

    SDL_GameController* controller = null;
    SDL_Joystick* joystick = null;
    
    int joystickAxisThreshold = 32639;

    InputManager inputManager;
    
    void delegate(SDL_Event* event) onProcessEvent;

    this(SDL_Window* win, uint winWidth, uint winHeight)
    {
        window = win;

        windowWidth = winWidth;
        windowHeight = winHeight;

        if(SDL_NumJoysticks() > 0)
        {
            SDL_GameControllerAddMappingsFromFile("gamecontrollerdb.txt");

            if (SDL_IsGameController(0))
            {
                controller = SDL_GameControllerOpen(0);

                if (SDL_GameControllerMapping(controller) is null)
                    writeln("Warning: no mapping found for controller!");

                SDL_GameControllerEventState(SDL_ENABLE);
            }
            else
            {
                joystick = SDL_JoystickOpen(0);
            }
        }

        toReset = Array!(bool*)();

        inputManager = New!InputManager(this);
    }

    ~this()
    {
        toReset.free();
        Delete(inputManager);
    }

    void exit()
    {
        running = false;
    }

    void addEvent(Event e)
    {
        if (numEvents < maxNumEvents)
        {
            eventStack[numEvents] = e;
            numEvents++;
        }
        else
            writeln("Warning: event stack overflow");
    }

    void generateFileChangeEvent(string filename)
    {
        Event e = Event(EventType.FileChange);
        e.filename = filename;
        addUserEvent(e);
    }

    void addUserEvent(Event e)
    {
        if (numUserEvents < maxNumEvents)
        {
            userEventStack[numUserEvents] = e;
            numUserEvents++;
        }
        else
            writeln("Warning: user event stack overflow");
    }

    void generateUserEvent(int code)
    {
        Event e = Event(EventType.UserEvent);
        e.userCode = code;
        addUserEvent(e);
    }

    bool gameControllerAvailable()
    {
        return (controller !is null);
    }

    bool joystickAvailable()
    {
        return (joystick !is null || controller !is null);
    }

    float gameControllerAxis(int axis)
    {
        return cast(float)(SDL_GameControllerGetAxis(controller, cast(SDL_GameControllerAxis)axis)) / 32768.0f;
    }

    float joystickAxis(int axis)
    {
        if (joystick)
        {
            double a = cast(double)(SDL_JoystickGetAxis(joystick, axis));
            return a / 32768.0f;
        }
        else if (controller)
        {
            return cast(float)(SDL_GameControllerGetAxis(controller, cast(SDL_GameControllerAxis)axis)) / 32768.0f;
        }
        else return 0.0;
    }

    void update()
    {
        numEvents = 0;

        mouseRelX = 0;
        mouseRelY = 0;

        for (uint i = 0; i < numUserEvents; i++)
        {
            Event e = userEventStack[i];
            addEvent(e);
        }

        numUserEvents = 0;

        SDL_Event event;

        while(SDL_PollEvent(&event))
        {
            if (onProcessEvent) onProcessEvent(&event);
            Event e;
            switch (event.type)
            {
                case SDL_KEYDOWN:
                    if (event.key.repeat && !enableKeyRepeat)
                        break;

                    keyPressed[event.key.keysym.scancode] = true;
                    keyDown[event.key.keysym.scancode] = true;
                    keyUp[event.key.keysym.scancode] = false;
                    toReset.insertBack(&keyDown[event.key.keysym.scancode]);

                    e = Event(EventType.KeyDown);
                    e.key = event.key.keysym.scancode;
                    addEvent(e);
                    break;

                case SDL_KEYUP:
                    keyPressed[event.key.keysym.scancode] = false;
                    keyDown[event.key.keysym.scancode] = false;
                    keyUp[event.key.keysym.scancode] = true;
                    toReset.insertBack(&keyUp[event.key.keysym.scancode]);

                    e = Event(EventType.KeyUp);
                    e.key = event.key.keysym.scancode;
                    addEvent(e);
                    break;

                case SDL_TEXTINPUT:
                    e = Event(EventType.TextInput);
                    char[] input = event.text.text;
                    if ((input[0] & 0x80) == 0)
                    {
                        e.unicode = input[0];
                    }
                    else if ((input[0] & 0xE0) == 0xC0)
                    {
                        e.unicode = ((input[0] & 0x1F) << 6) | (input[1] & 0x3F);
                    }
                    else if ((input[0] & 0xF0) == 0xE0)
                    {
                        e.unicode = ((input[0] & 0x0F) << 12) | ((input[1] & 0x3F) << 6) | (input[2] & 0x3F);
                    }
                    else if ((input[0] & 0xF8) == 0xF0)
                    {
                        e.unicode = (((input[0] & 0x0F) << 18) | ((input[1] & 0x3F) << 12) | ((input[2] & 0x3F) << 6) | (input[3] & 0x3F));
                    }
                    addEvent(e);
                    break;

                case SDL_MOUSEMOTION:
                    mouseX = event.motion.x;
                    mouseY = event.motion.y;
                    mouseRelX = event.motion.xrel;
                    mouseRelY = event.motion.yrel;
                    break;

                case SDL_MOUSEBUTTONDOWN:
                    mouseButtonPressed[event.button.button] = true;
                    mouseButtonDown[event.button.button] = true;
                    toReset.insertBack(&mouseButtonDown[event.button.button]);

                    e = Event(EventType.MouseButtonDown);
                    e.button = event.button.button;
                    addEvent(e);
                    break;

                case SDL_MOUSEBUTTONUP:
                    mouseButtonPressed[event.button.button] = false;
                    mouseButtonUp[event.button.button] = true;
                    toReset.insertBack(&mouseButtonUp[event.button.button]);

                    e = Event(EventType.MouseButtonUp);
                    e.button = event.button.button;
                    addEvent(e);
                    break;

                case SDL_MOUSEWHEEL:
                    e = Event(EventType.MouseWheel);
                    e.mouseWheelX = event.wheel.x;
                    e.mouseWheelY = event.wheel.y;
                    addEvent(e);
                    break;

                case SDL_JOYBUTTONDOWN:
                    if(joystick is null) break;
                    if (event.jbutton.state == SDL_PRESSED)
                    {
                        e = Event(EventType.JoystickButtonDown);
                        joystickButtonPressed[event.jbutton.button] = true;
                        joystickButtonDown[event.jbutton.button] = true;
                        toReset.insertBack(&joystickButtonDown[event.jbutton.button]);
                    }
                    else if (event.jbutton.state == SDL_RELEASED)
                    {
                        e = Event(EventType.JoystickButtonUp);
                        joystickButtonPressed[event.jbutton.button] = false;
                        joystickButtonUp[event.jbutton.button] = true;
                        toReset.insertBack(&joystickButtonUp[event.jbutton.button]);
                    }
                    e.joystickButton = event.jbutton.button;
                    addEvent(e);
                    break;

                case SDL_JOYBUTTONUP:
                    if(joystick is null) break;
                    if (event.jbutton.state == SDL_PRESSED)
                    {
                        e = Event(EventType.JoystickButtonDown);
                        joystickButtonPressed[event.jbutton.button] = true;
                        joystickButtonDown[event.jbutton.button] = true;
                        toReset.insertBack(&joystickButtonDown[event.jbutton.button]);
                    }
                    else if (event.jbutton.state == SDL_RELEASED)
                    {
                        e = Event(EventType.JoystickButtonUp);
                        joystickButtonPressed[event.jbutton.button] = false;
                        joystickButtonUp[event.jbutton.button] = true;
                        toReset.insertBack(&joystickButtonUp[event.jbutton.button]);
                    }
                    e.joystickButton = event.jbutton.button;
                    addEvent(e);
                    break;

                case SDL_CONTROLLERBUTTONDOWN:
                    controllerButtonPressed[event.cbutton.button] = true;
                    controllerButtonDown[event.cbutton.button] = true;
                    toReset.insertBack(&controllerButtonDown[event.cbutton.button]);

                    e = Event(EventType.JoystickButtonDown);
                    e.joystickButton = event.cbutton.button;
                    addEvent(e);
                    break;

                case SDL_CONTROLLERBUTTONUP:
                    controllerButtonPressed[event.cbutton.button] = false;
                    controllerButtonUp[event.cbutton.button] = true;
                    toReset.insertBack(&controllerButtonUp[event.cbutton.button]);

                    e = Event(EventType.JoystickButtonUp);
                    e.joystickButton = event.cbutton.button;
                    addEvent(e);
                    break;

                case SDL_CONTROLLERAXISMOTION:
                    // TODO: add state modification
                    e = Event(EventType.JoystickAxisMotion);
                    e.joystickAxis = event.caxis.axis;
                    int axisValue = event.caxis.value;
                    if (controller)
                    {
                        if (e.joystickAxis == 0)
                            axisValue = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_LEFTY);
                        if (e.joystickAxis == 1)
                            axisValue = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_LEFTX);
                    }
                    e.joystickAxisValue = 
                        cast(float)clamp(axisValue, -joystickAxisThreshold, joystickAxisThreshold) / cast(float)joystickAxisThreshold;
                    addEvent(e);
                    break;

                case SDL_WINDOWEVENT:
                    if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
                    {
                        windowWidth = event.window.data1;
                        windowHeight = event.window.data2;
                        e = Event(EventType.Resize);
                        e.width = windowWidth;
                        e.height = windowHeight;
                        addEvent(e);
                    }
                    else if (event.window.event == SDL_WINDOWEVENT_FOCUS_GAINED)
                    {
                        e = Event(EventType.FocusGain);
                        addEvent(e);
                    }
                    else if (event.window.event == SDL_WINDOWEVENT_FOCUS_LOST)
                    {
                        e = Event(EventType.FocusLoss);
                        addEvent(e);
                    }
                    break;

                case SDL_DROPFILE:
                    e = Event(EventType.DropFile);
                    e.filename = to!string(event.drop.file);
                    addEvent(e);
                    break;

                case SDL_QUIT:
                    exit();
                    e = Event(EventType.Quit);
                    addEvent(e);
                    break;

                default:
                    break;
            }
        }
    }

    protected int lastTime = 0;
    void updateTimer()
    {
        int currentTime = SDL_GetTicks();
        auto elapsedTime = currentTime - lastTime;
        lastTime = currentTime;
        deltaTimeMs = elapsedTime;
        deltaTime = cast(double)(elapsedTime) * 0.001;
    }

    void setMouse(int x, int y)
    {
        SDL_WarpMouseInWindow(window, x, y);
        mouseX = x;
        mouseY = y;
    }

    void setMouseToCenter()
    {
        float x = (cast(float)windowWidth) / 2;
        float y = (cast(float)windowHeight) / 2;
        setMouse(cast(int)x, cast(int)y);
    }

    int showCursor(bool mode)
    {
        return SDL_ShowCursor(mode);
    }

    int setRelativeMouseMode(bool mode)
    {
        return SDL_SetRelativeMouseMode(cast(SDL_bool)mode);
    }

    float aspectRatio()
    {
        return cast(float)windowWidth / cast(float)windowHeight;
    }

    void resetUpDown()
    {
        // reset all UP and DOWN events
        foreach(key; toReset)
        {
            *key = false;
        }
        toReset.removeBack(cast(uint)toReset.length);
    }
}

abstract class EventListener: Owner
{
    EventManager eventManager;
    InputManager inputManager;
    bool enabled = true;

    this(EventManager emngr, Owner owner)
    {
        super(owner);
        eventManager = emngr;
        if(emngr !is null)
            inputManager = emngr.inputManager;
    }

    protected void generateUserEvent(int code)
    {
        eventManager.generateUserEvent(code);
    }

    void processEvents(bool enableInputEvents = true)
    {
        if (!enabled)
            return;

        for (uint i = 0; i < eventManager.numEvents; i++)
        {
            Event* e = &eventManager.eventStack[i];
            processEvent(e, enableInputEvents);
        }
    }

    void processEvent(Event* e, bool enableInputEvents = true)
    {
        switch(e.type)
        {
            case EventType.KeyDown:
                if (enableInputEvents) onKeyDown(e.key);
                break;
            case EventType.KeyUp:
                if (enableInputEvents) onKeyUp(e.key);
                break;
            case EventType.TextInput:
                if (enableInputEvents) onTextInput(e.unicode);
                break;
            case EventType.MouseButtonDown:
                if (enableInputEvents) onMouseButtonDown(e.button);
                break;
            case EventType.MouseButtonUp:
                if (enableInputEvents) onMouseButtonUp(e.button);
                break;
            case EventType.MouseWheel:
                if (enableInputEvents) onMouseWheel(e.mouseWheelX, e.mouseWheelY);
                break;
            case EventType.JoystickButtonDown:
                if (enableInputEvents) onJoystickButtonDown(e.joystickButton);
                break;
            case EventType.JoystickButtonUp:
                if (enableInputEvents) onJoystickButtonUp(e.joystickButton);
                break;
            case EventType.JoystickAxisMotion:
                if (enableInputEvents) onJoystickAxisMotion(e.joystickAxis, e.joystickAxisValue);
                break;
            case EventType.Resize:
                onResize(e.width, e.height);
                break;
            case EventType.FocusLoss:
                onFocusLoss();
                break;
            case EventType.FocusGain:
                onFocusGain();
                break;
            case EventType.Quit:
                onQuit();
                break;
            case EventType.FileChange:
                onFileChange(e.filename);
                break;
            case EventType.DropFile:
                if (enableInputEvents) onDropFile(e.filename);
                break;
            case EventType.UserEvent:
                onUserEvent(e.userCode);
                break;
            default:
                break;
        }
    }

    void onKeyDown(int key) {}
    void onKeyUp(int key) {}
    void onTextInput(dchar code) {}
    void onMouseButtonDown(int button) {}
    void onMouseButtonUp(int button) {}
    void onMouseWheel(int x, int y) {}
    void onJoystickButtonDown(int button) {}
    void onJoystickButtonUp(int button) {}
    void onJoystickAxisMotion(int axis, float value) {}
    void onResize(int width, int height) {}
    void onFocusLoss() {}
    void onFocusGain() {}
    void onQuit() {}
    void onFileChange(string filename) {}
    void onDropFile(string filename) {}
    void onUserEvent(int code) {}
}
