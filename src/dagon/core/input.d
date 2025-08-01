/*
Copyright (c) 2019-2025 Mateusz Muszyński

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

/**
 * Provides an input manager.
 *
 * Description:
 * The `dagon.core.input` module defines input binding types, the `Binding` struct, 
 * and the `InputManager` class, which allows mapping named actions to keyboard, 
 * mouse, and gamepad inputs, as well as querying button and axis states.
 *
 * Copyright: Mateusz Muszyński 2019-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Mateusz Muszyński
 */
module dagon.core.input;

import std.stdio;
import std.ascii;
import std.conv: to;
import std.math: abs;
import std.algorithm.searching: startsWith;
import std.string: isNumeric;
import dlib.core.memory;
import dlib.core.ownership;
import dlib.container.dict;
import dlib.container.array;
import dlib.text.lexer;
import dlib.text.str;
import dagon.core.event;
import dagon.core.bindings;
import dagon.core.keycodes;
import dagon.core.config;
import dagon.core.logger;

/**
 * All supported input binding types.
 */
enum BindingType
{
    /// No binding.
    None,

    /// Keyboard key.
    Keyboard,

    /// Mouse button.
    MouseButton,

    /// Mouse axis (movement).
    MouseAxis,

    /// Gamepad button.
    GamepadButton,

    /// Gamepad axis.
    GamepadAxis,

    /// Virtual axis (composed from two buttons).
    VirtualAxis
}

/**
 * Represents a single input binding.
 *
 * Description:
 * A binding can be a keyboard key, mouse button, mouse axis, 
 * gamepad button, gamepad axis, or a virtual axis composed from two buttons.
 */
struct Binding
{
    /// The type of the binding.
    BindingType type;
    union
    {
        /// Keyboard key code.
        int key;

        /// Mouse or gamepad button code.
        int button;

        /// Mouse or gamepad axis index.
        int axis;

        private struct Vaxis
        {
            /// Type for positive direction.
            BindingType typePos;

            /// Code for positive direction.
            int pos;

            /// Type for negative direction.
            BindingType typeNeg;

            /// Code for negative direction.
            int neg;
        }

        /// Virtual axis data.
        Vaxis vaxis;
    }
}

/**
 * Replaces all occurrences of `srcElement` with `destElement` in the given array.
 *
 * Params:
 *   arr = The array to modify.
 *   srcElement = The element to replace.
 *   destElement = The replacement element.
 * Returns:
 *   The number of elements replaced.
 */
size_t replaceInArray(T)(T[] arr, T srcElement, T destElement)
{
    size_t numReplaced = 0;
    
    for (size_t i = 0; i < arr.length; i++)
    {
        if (arr[i] == srcElement)
        {
            arr[i] = destElement;
            numReplaced++;
        }
    }
    
    return numReplaced;
}

/**
 * Manages input bindings and queries input state.
 *
 * Description:
 * Loads input configuration from file, allows mapping
 * named actions to multiple bindings, and provides methods
 * to query button and axis states.
 */
class InputManager
{
    /// The event manager used for input state.
    EventManager eventManager;

    /// Dictionary mapping action names to arrays of bindings.
    alias Bindings = Array!Binding;
    Dict!(Bindings, string) bindings;

    /// The configuration object for input bindings.
    Configuration config;

    /**
     * Constructs an InputManager and loads input bindings from "input.conf".
     *
     * Params:
     *   em = The event manager to use for input state.
     */
    this(EventManager em)
    {
        eventManager = em;
        bindings = dict!(Bindings, string)();

        config = New!Configuration(eventManager.application.vfs, null);
        if (!config.fromFile("input.conf"))
        {
            logWarning("No \"input.conf\" found");
        }

        foreach(name, value; config.props.props)
        {
            addBindings(name, value.data);
        }
    }

    /// Destructor. Frees all bindings and configuration resources.
    ~this()
    {
        foreach(name, bind; bindings)
        {
            bind.free();
        }
        Delete(bindings);
        Delete(config);
    }

    /**
     * Parses a single binding from a lexer.
     *
     * Params:
     *   lexer = The lexer containing the binding string.
     * Returns:
     *   The parsed Binding.
     */
    private Binding parseBinding(Lexer lexer)
    {
        // Binding format consist of device type and name(or number)
        // coresponding to button or axis of this device
        // eg. kb_up, kb_w, ma_0, mb_1, gb_a, gb_x, ga_leftx, ga_lefttrigger
        // kb -> keybaord, by name
        // ma -> mouse axis, by number
        // mb -> mouse button, by number
        // ga -> gamepad axis, by name
        // gb -> gamepad button, by name
        // va -> virtual axis, special syntax: va(kb_up, kb_down)

        BindingType type = BindingType.None;
        int result = -1;

        auto lexeme = lexer.getLexeme();

        switch(lexeme)
        {
            case "kb": type = BindingType.Keyboard; break;
            case "ma": type = BindingType.MouseAxis; break;
            case "mb": type = BindingType.MouseButton; break;
            case "ga": type = BindingType.GamepadAxis; break;
            case "gb": type = BindingType.GamepadButton; break;
            case "va": type = BindingType.VirtualAxis; break;

            default: goto fail;
        }

        lexeme = lexer.getLexeme();

        if (type != BindingType.VirtualAxis)
        {
            if (lexeme != "_")
                goto fail;

            lexeme = lexer.getLexeme();

            if(lexeme.isNumeric)
            {
                result = to!int(lexeme);
            }
            else
            {
                String svalue = String(lexeme);
                replaceInArray(svalue.data.data, '+', ' ');
                const(char)* cvalue = svalue.ptr;
                switch(type)
                {
                    case BindingType.Keyboard:      result = cast(int)SDL_GetScancodeFromName(cvalue); break;
                    case BindingType.GamepadAxis:   result = cast(int)SDL_GameControllerGetAxisFromString(cvalue); break;
                    case BindingType.GamepadButton: result = cast(int)SDL_GameControllerGetButtonFromString(cvalue); break;
                    default: break;
                }

                svalue.free();
            }

            if (type != BindingType.None || result > 0)
                return Binding(type, result);
        }
        else
        {
            // Virtual axis
            if (lexeme != "(")
                goto fail;

            Binding pos = parseBinding(lexer);

            if (pos.type != BindingType.Keyboard &&
               pos.type != BindingType.MouseButton &&
               pos.type != BindingType.GamepadButton)
                goto fail;

            lexeme = lexer.getLexeme();
            if (lexeme != ",")
                goto fail;

            Binding neg = parseBinding(lexer);

            if (neg.type != BindingType.Keyboard &&
               neg.type != BindingType.MouseButton &&
               neg.type != BindingType.GamepadButton)
                goto fail;

            lexeme = lexer.getLexeme();

            if (lexeme != ")")
                goto fail;

            Binding bind = Binding(type);
            bind.vaxis.typePos = pos.type;
            bind.vaxis.pos = pos.key;
            bind.vaxis.typeNeg = neg.type;
            bind.vaxis.neg = neg.key;
            return bind;
        }

    fail:
        return Binding(BindingType.None, -1);
    }

    /**
     * Adds one or more bindings for the given action name.
     *
     * Params:
     *   name = The action name.
     *   value = The binding string (may contain multiple bindings).
     */
    void addBindings(string name, string value)
    {
        auto lexer = New!Lexer(value, ["_", ",", "(", ")"]);
        lexer.ignoreWhitespaces = true;

        while(true)
        {
            Binding b = parseBinding(lexer);
            if (b.type == BindingType.None && b.key == -1)
            {
                writefln("Error: wrong binding format \"%s\"", value);
                break;
            }

            if (auto binding = name in bindings)
            {
                binding.insertBack(b);
            }
            else
            {
                auto binds = Bindings();
                binds.insertBack(b);
                bindings[name] = binds;
            }

            auto lexeme = lexer.getLexeme();
            if (lexeme == ",")
                continue;

            if (lexeme == "")
                break;
        }

        Delete(lexer);
    }

    /**
     * Removes all bindings for the given action name.
     *
     * Params:
     *   name = The action name.
     */
    void clearBindings(string name)
    {
        if (auto binding = name in bindings)
        {
            binding.removeBack(cast(uint)binding.length);
        }
    }

    /**
     * Checks if the given binding is currently pressed.
     *
     * Params:
     *   binding = The binding to check.
     * Returns:
     *   `true` if pressed, `false` otherwise.
     */
    bool getButton(Binding binding)
    {
        switch(binding.type)
        {
            case BindingType.Keyboard:
                if (eventManager.keyPressed[binding.key]) return true;
                break;

            case BindingType.MouseButton:
                if (eventManager.mouseButtonPressed[binding.button]) return true;
                break;

            case BindingType.GamepadButton:
                if (eventManager.controllerButtonPressed[binding.button]) return true;
                break;

            default:
                break;
        }

        return false;
    }

    /**
     * Checks if any binding for the given action name is currently pressed.
     *
     * Params:
     *   name = The action name.
     * Returns:
     *   `true` if pressed, `false` otherwise.
     */
    bool getButton(string name)
    {
        auto b = name in bindings;
        if (!b)
            return false;

        for(int i = 0; i < b.length; i++)
        {
            if (getButton((*b)[i])) return true;
        }

        return false;
    }

    /**
     * Checks if any binding for the given action name was released this frame.
     *
     * Params:
     *   name = The action name.
     * Returns:
     *   `true` if released, `false` otherwise.
     */
    bool getButtonUp(string name)
    {
        auto b = name in bindings;
        if (!b)
            return false;

        for(int i = 0; i < b.length; i++)
        {
            auto binding = (*b)[i];
            switch(binding.type)
            {
                case BindingType.Keyboard:
                    if (eventManager.keyUp[binding.key]) return true;
                    break;

                case BindingType.MouseButton:
                    if (eventManager.mouseButtonUp[binding.button]) return true;
                    break;

                case BindingType.GamepadButton:
                    if (eventManager.controllerButtonUp[binding.button]) return true;
                    break;

                default:
                    break;
            }
        }

        return false;
    }

    /**
     * Checks if any binding for the given action name was pressed this frame.
     *
     * Params:
     *   name = The action name.
     * Returns:
     *   `true` if pressed this frame, `false` otherwise.
     */
    bool getButtonDown(string name)
    {
        auto b = name in bindings;
        if (!b)
            return false;

        for(int i = 0; i < b.length; i++)
        {
            auto binding = (*b)[i];

            switch(binding.type)
            {
                case BindingType.Keyboard:
                    if (eventManager.keyDown[binding.key]) return true;
                    break;

                case BindingType.MouseButton:
                    if (eventManager.mouseButtonDown[binding.button]) return true;
                    break;

                case BindingType.GamepadButton:
                    if (eventManager.controllerButtonDown[binding.button]) return true;
                    break;

                default:
                    break;
            }
        }

        return false;
    }

    /**
     * Gets the axis value for the given action name.
     *
     * For analog axes, returns the current value. For virtual axes, returns -1, 0, or 1.
     *
     * Params:
     *   name = The action name.
     * Returns:
     *   The axis value in the range [-1, 1].
     */
    float getAxis(string name)
    {
        auto b = name in bindings;
        if (!b)
            return false;

        float result = 0.0f;
        float aresult = 0.0f; // absolute result

        for(int i = 0; i < b.length; i++)
        {
            auto binding = (*b)[i];
            float value = 0.0f;

            switch(binding.type)
            {
                case BindingType.MouseAxis:
                    if (binding.axis == 0)
                        value = eventManager.mouseRelX / (eventManager.windowWidth * 0.5f); // map to -1 to 1 range
                    else if (binding.axis == 1)
                        value = eventManager.mouseRelY / (eventManager.windowHeight * 0.5f);
                    break;

                case BindingType.GamepadAxis:
                    if (eventManager.gameControllerAvailable)
                        value = eventManager.gameControllerAxis(binding.axis);
                    break;

                case BindingType.VirtualAxis:
                    value  = getButton(*cast(Binding*)(&binding.vaxis.typePos)) ?  1.0f : 0.0f;
                    value += getButton(*cast(Binding*)(&binding.vaxis.typeNeg)) ? -1.0f : 0.0f;
                    break;

                default:
                    break;
            }
            float avalue = abs(value);
            if (avalue > aresult)
            {
                result = value;
                aresult = avalue;
            }
        }

        return result;
    }
}
