/*
Copyright (c) 2016-2025 Timur Gafarov

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
 * Provides a dynamic type system.
 *
 * Description:
 * The `dagon.core.props` module defines the `DProperty` struct for storing
 * dynamically-typed property values, the `Properties` class for managing collections of
 * named properties, and utility functions for parsing and handling property
 * data. Properties can be numbers, vectors, or strings, and are used for
 * configuration, serialization, and runtime data storage.
 *
 * Copyright: Timur Gafarov 2016-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.core.props;

import std.stdio;
import std.ascii;
import std.conv;
import dlib.core.memory;
import dlib.core.ownership;
import dlib.container.array;
import dlib.container.dict;
import dlib.text.utils;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.image.color;
import dlib.text.str;
import dlib.text.lexer;

import dagon.core.logger;

/**
 * Supported property types.
 */
enum DPropType
{
    /// No value or unknown type.
    Undefined,

    /// Numeric value.
    Number,

    /// Vector value (e.g. Vector3f, Vector4f).
    Vector,

    /// String value.
    String
}

/**
 * Represents a single property value with type information.
 *
 * Description:
 * Provides conversion methods to various types
 * (string, double, float, int, bool, vector, color).
 */
struct DProperty
{
    /// The property type.
    DPropType type;

    /// The property name.
    string name;

    /// The property value as a string.
    string data;

    /// Returns the property value as a string.
    string toString() const
    {
        return data;
    }

    /// Returns the property value as a double.
    double toDouble() const
    {
        if (data.length)
            return to!double(data);
        else
            return double.nan;
    }

    /// Returns the property value as a float.
    float toFloat() const
    {
        if (data.length)
            return to!float(data);
        else
            return float.nan;
    }

    /// Returns the property value as an int.
    int toInt() const
    {
        if (data.length)
            return to!int(data);
        else
            return 0;
    }

    /// Returns the property value as an unsigned int.
    int toUInt() const
    {
        if (data.length)
            return to!uint(data);
        else
            return 0;
    }

    /// Returns the property value as a bool.
    bool toBool() const
    {
        if (data.length)
            return cast(bool)cast(int)(to!float(data));
        else
            return false;
    }

    /// Returns the property value as a Vector3f.
    Vector3f toVector3f() const
    {
        if (data.length)
            return Vector3f(data);
        else
            return Vector3f();
    }

    /// Returns the property value as a Vector4f.
    Vector4f toVector4f() const
    {
        if (data.length)
            return Vector4f(data);
        else
            return Vector4f();
    }

    /// Returns the property value as a Color4f.
    Color4f toColor4f() const
    {
        if (data.length)
            return Color4f(Vector4f(data));
        else
            return Color4f();
    }
    
    /// Returns the property value as Matrix3x3f.
    Matrix3x3f toMatrix3x3f() const
    {
        if (data.length)
            return Matrix3x3f(data);
        else
            return Matrix3x3f.identity;
    }
    
    /// Returns the property value as Matrix4x4f.
    Matrix4x4f toMatrix4x4f() const
    {
        if (data.length)
            return Matrix4x4f(data);
        else
            return Matrix4x4f.identity;
    }
}

/**
 * Stores and manages a collection of named properties.
 *
 * Description:
 * Supports parsing from string, serialization, property lookup, and iteration.
 */
class Properties: Owner
{
    /// Dictionary of property name to DProperty.
    Dict!(DProperty, string) props;

    /**
     * Constructs a new Properties object.
     *
     * Params:
     *   owner = The owner object.
     */
    this(Owner owner)
    {
        super(owner);
        props = dict!(DProperty, string);
    }

    /**
     * Parses properties from a string.
     *
     * Params:
     *   input = The string containing property definitions.
     * Returns:
     *   `true` if parsing succeeded, `false` otherwise.
     */
    bool parse(string input)
    {
        return parseProperties(input, this);
    }
    
    /**
     * Serializes all properties to a string.
     *
     * Returns:
     *   The serialized property data.
     */
    String serialize()
    {
        String output;
        foreach(k, v; props)
        {
            output ~= k;
            output ~= ": ";
            output ~= v.data;
            output ~= ";\n";
        }
        return output;
    }

    /**
     * Looks up a property by name.
     *
     * Params:
     *   name = The property name.
     * Returns:
     *   The property if found, or an undefined property otherwise.
     */
    DProperty opIndex(string name)
    {
        if (name in props)
            return props[name];
        else
            return DProperty(DPropType.Undefined, "");
    }

    /**
     * Sets a property value.
     *
     * Params:
     *   type  = The property type.
     *   name  = The property name.
     *   value = The property value as a string.
     */
    void set(DPropType type, string name, string value)
    {
        auto p = name in props;
        if (p)
        {
            Delete(p.name);
            Delete(p.data);
            auto nameCopy = copyStr(name);
            auto valueCopy = copyStr(value);
            props[nameCopy] = DProperty(type, nameCopy, valueCopy);
        }
        else
        {
            auto nameCopy = copyStr(name);
            auto valueCopy = copyStr(value);
            props[nameCopy] = DProperty(type, nameCopy, valueCopy);
        }
    }

    /**
     * Looks up a property by name using opDispatch.
     *
     * Params:
     *   s = The property name.
     * Returns:
     *   The property if found, or an undefined property otherwise.
     */
    DProperty opDispatch(string s)()
    {
        if (s in props)
            return props[s];
        else
            return DProperty(DPropType.Undefined, "");
    }

    /**
     * Checks if a property exists by name.
     *
     * Params:
     *   k = The property name.
     * Returns:
     *   Pointer to the property if found, `null` otherwise.
     */
    DProperty* opBinaryRight(string op)(string k) if (op == "in")
    {
        return (k in props);
    }

    /**
     * Removes a property by name.
     *
     * Params:
     *   name = The property name.
     */
    void remove(string name)
    {
        if (name in props)
        {
            auto n = props[name].name;
            Delete(props[name].data);
            props.remove(name);
            Delete(n);
        }
    }

    /**
     * Iterates over all properties.
     *
     * Params:
     *   dg = Delegate to call for each property (name, ref DProperty).
     * Returns:
     *   Always returns 0.
     */
    int opApply(int delegate(string, ref DProperty) dg)
    {
        foreach(k, v; props)
        {
            dg(k, v);
        }

        return 0;
    }

    /// Destructor. Frees all property data.
    ~this()
    {
        foreach(k, v; props)
        {
            Delete(v.data);
            Delete(v.name);
        }
        Delete(props);
    }
}

/**
 * Returns true if the string consists only of whitespace or newlines.
 *
 * Params:
 *   s = The string to check.
 * Returns:
 *   `true` if the string is whitespace, `false` otherwise.
 */
bool isWhiteStr(string s)
{
    bool res;
    foreach(c; s)
    {
        res = false;
        foreach(w; std.ascii.whitespace)
        {
            if (c == w)
                res = true;
        }

        if (c == '\n' || c == '\r')
            res = true;
    }
    return res;
}

/**
 * Returns true if the string is a valid identifier (starts with a letter or underscore).
 *
 * Params:
 *   s = The string to check.
 * Returns:
 *   `true` if valid identifier, `false` otherwise.
 */
bool isValidIdentifier(string s)
{
    return (isAlpha(s[0]) || s[0] == '_');
}

/**
 * Copies a string or array to a newly allocated buffer.
 *
 * Params:
 *   s = The string or array to copy.
 * Returns:
 *   The copied string.
 */
string copyStr(T)(T[] s)
{
    auto res = New!(char[])(s.length);
    foreach(i, c; s)
        res[i] = c;
    return cast(string)res;
}

/**
 * Parses a string containing property definitions and populates a `Properties`` object.
 *
 * Params:
 *   input = The string to parse.
 *   props = The Properties object to populate.
 * Returns:
 *   `true` if parsing succeeded, `false` otherwise.
 */
bool parseProperties(string input, Properties props)
{
    enum Expect
    {
        PropName,
        Colon,
        Semicolon,
        Value,
        String,
        Vector,
        Number
    }

    bool res = true;
    auto lexer = New!Lexer(input, [":", ";", "\"", "[", "]", ","]);

    lexer.ignoreNewlines = true;

    Expect expect = Expect.PropName;
    string propName;
    Array!char propValue;
    DPropType propType;

    while(true)
    {
        auto lexeme = lexer.getLexeme();
        if (lexeme.length == 0)
        {
            if (expect != Expect.PropName)
            {
                logError("Unexpected end of string");
                res = false;
            }
            break;
        }

        if (isWhiteStr(lexeme) && expect != Expect.String)
            continue;

        if (expect == Expect.PropName)
        {
            if (!isValidIdentifier(lexeme))
            {
                logError("Illegal identifier name \"%s\"", lexeme);
                res = false;
                break;
            }

            propName = lexeme;
            expect = Expect.Colon;
        }
        else if (expect == Expect.Colon)
        {
            if (lexeme != ":")
            {
                logError("Expected \":\", got \"%s\"", lexeme);
                res = false;
                break;
            }

            expect = Expect.Value;
        }
        else if (expect == Expect.Semicolon)
        {
            if (lexeme != ";")
            {
                logError("Expected \";\", got \"%s\"", lexeme);
                res = false;
                break;
            }

            props.set(propType, propName, cast(string)propValue.data);

            expect = Expect.PropName;
            propName = "";
            propValue.free();
        }
        else if (expect == Expect.Value)
        {
            if (lexeme == "\"")
            {
                propType = DPropType.String;
                expect = Expect.String;
            }
            else if (lexeme == "[")
            {
                propType = DPropType.Vector;
                expect = Expect.Vector;
                propValue.append(lexeme);
            }
            else
            {
                propType = DPropType.Number;
                propValue.append(lexeme);
                expect = Expect.Semicolon;
            }
        }
        else if (expect == Expect.String)
        {
            if (lexeme == "\"")
                expect = Expect.Semicolon;
            else
                propValue.append(lexeme);
        }
        else if (expect == Expect.Vector)
        {
            if (lexeme == "]")
                expect = Expect.Semicolon;

            propValue.append(lexeme);
        }
    }

    propValue.free();
    Delete(lexer);

    return res;
}
