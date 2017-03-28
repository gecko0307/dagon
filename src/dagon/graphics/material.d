module dagon.graphics.material;

import dlib.core.memory;
import dlib.math.vector;
import dlib.image.color;
import dlib.container.dict;
import derelict.opengl.gl;
import dagon.core.ownership;
import dagon.graphics.texture;
import dagon.graphics.rc;

enum
{
    CBlack = Color4f(0.0f, 0.0f, 0.0f, 1.0f),
    CWhite = Color4f(1.0f, 1.0f, 1.0f, 1.0f),
    CRed = Color4f(1.0f, 0.0f, 0.0f, 1.0f),
    COrange = Color4f(1.0f, 0.5f, 0.0f, 1.0f),
    CYellow = Color4f(1.0f, 1.0f, 0.0f, 1.0f),
    CGreen = Color4f(0.0f, 1.0f, 0.0f, 1.0f),
    CCyan = Color4f(0.0f, 1.0f, 1.0f, 1.0f),
    CBlue = Color4f(0.0f, 0.0f, 1.0f, 1.0f),
    CPurple = Color4f(0.5f, 0.0f, 1.0f, 1.0f),
    CMagenta = Color4f(1.0f, 0.0f, 1.0f, 1.0f)
}

enum MaterialInputType
{
    Undefined,
    Bool,
    Integer,
    Float,
    Vec2,
    Vec3,
    Vec4
}

struct MaterialInput
{
    MaterialInputType type;
    union
    {
        bool asBool;
        int asInteger;
        float asFloat;
        Vector2f asVector2f;
        Vector3f asVector3f;
        Vector4f asVector4f;
    }
    Texture texture;
}

abstract class Material: Owner
{
    Dict!(MaterialInput, string) inputs;

    this(Owner o)
    {
        super(o);

        inputs = New!(Dict!(MaterialInput, string));
    }

    ~this()
    {
        Delete(inputs);
    }

    final void opDispatch(string name, T)(T value) @property
    {
        setInput(name, value);
    }

    final MaterialInput* setInput(T)(string name, T value)
    {
        MaterialInput input;
        static if (is(T == bool))
        {
            input.type = MaterialInputType.Bool;
            input.asBool = value;
        }
        else static if (is(T == int))
        {
            input.type = MaterialInputType.Integer;
            input.asInteger = value;
        }
        else static if (is(T == float) || is(T == double))
        {
            input.type = MaterialInputType.Float;
            input.asFloat = value;
        }
        else static if (is(T == Vector2f))
        {
            input.type = MaterialInputType.Vec2;
            input.asVector2f = value;
        }
        else static if (is(T == Vector3f))
        {
            input.type = MaterialInputType.Vec3;
            input.asVector3f = value;
        }
        else static if (is(T == Vector4f))
        {
            input.type = MaterialInputType.Vec4;
            input.asVector4f = value;
        }
        else static if (is(T == Color4f))
        {
            input.type = MaterialInputType.Vec4;
            input.asVector4f = value;
        }
        else static if (is(T == Texture))
        {
            input.texture = value;
            if (value.format == GL_LUMINANCE)
                input.type = MaterialInputType.Float;
            else if (value.format == GL_LUMINANCE_ALPHA)
                input.type = MaterialInputType.Vec2;
            else if (value.format == GL_RGB)
                input.type = MaterialInputType.Vec3;
            else if (value.format == GL_RGBA)
                input.type = MaterialInputType.Vec4;
        }
        else
        {
            input.type = MaterialInputType.Undefined;
        }

        inputs[name] = input;
        return (name in inputs);
    }

    void bind(RenderingContext* rc);
    void unbind();
}

