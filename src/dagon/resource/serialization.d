module dagon.resource.serialization;

import std.traits;
import std.bitmanip;

import dlib.core.stream;

// Stream-based serialization and deserialization

struct Series(T, bool fixedSize = false)
{
    union
    {
        T _value;
        static if (isDynamicArray!T)
            ubyte[] _bytes;
        else
            ubyte[T.sizeof] _bytes;
    }

    this(T val)
    {
        value = val;
    }

    T opAssign(T val)
    {
        return (value = val);
    }

    this(InputStream istrm)
    {
        readFrom(istrm);
    }

    @property T value(T v)
    {
        static if (isIntegral!T)
        {
            _bytes = nativeToLittleEndian!T(v);
        }
        else
            _value = v;
        return _value;
    }

    @property T value()
    {
        T res;
        static if (isIntegral!T)
        {
            res = littleEndianToNative!T(_bytes);
        }
        else
            res = _value;
        return res;
    }

    size_t writeTo(OutputStream ostrm)
    {
        size_t n = 0;
        static if (isDynamicArray!T)
        {
            n += Series!(uint)(cast(uint)_value.length).writeTo(ostrm);
            foreach(v; _value)
                n += Series!(Unqual!(typeof(v)))(v).writeTo(ostrm);
            return n;
        }
        else
        static if (is(T == struct) || is(T == class))
        {
            static if (is(T == class))
                if (_value is null)
                    throw new Exception("null reference in input");

            // TODO: make automatic check
            static if (is(T == struct) && fixedSize)
            {
                n = ostrm.writeBytes(_bytes.ptr, _bytes.length);
            }
            else
            {
                foreach(v; _value.tupleof)
                    n += Series!(typeof(v))(v).writeTo(ostrm);
            }
            return n;
        }
        else
        {
            return ostrm.writeBytes(_bytes.ptr, _bytes.length);
        }
    }

    size_t readFrom(InputStream istrm)
    {
        static if (isSomeString!T)
        {
            uint len = Series!(uint)(istrm).value;
            size_t pos = 4;
            ubyte[] buff = new ubyte[len];
            istrm.fillArray(buff);
            T str = cast(T)buff;
            _value = str;
            pos += len;
            return pos;
        }
        else
        static if (isDynamicArray!T)
        {
            uint len = Series!(uint)(istrm).value;
            size_t pos = 4;
            alias FT = ForeachType!T;
            if (len == 0)
                return pos;

            _value = new FT[len];

            foreach(ref v; _value)
            {
                Series!(FT) se;
                size_t s = se.readFrom(istrm);
                v = se.value;
                pos += s;
            }

            return pos;
        }
        else
        static if (is(T == struct) || is(T == class))
        {
            size_t pos = 0;
            static if (is(T == class))
                if (_value is null)
                    throw new Exception("null reference in output");

            static if (is(T == struct) && fixedSize)
            {
                pos += istrm.readBytes(_bytes.ptr, T.sizeof);
            }
            else
            foreach(ref v; _value.tupleof)
            {
                Series!(typeof(v)) se;
                static if (is(typeof(v) == class))
                {
                    if (v is null)
                        throw new Exception("null reference in output");
                    se._value = v;
                }
                size_t s = se.readFrom(istrm);
                v = se.value;
                pos += s;
            }

            return pos;
        }
        else
        {
            return istrm.readBytes(_bytes.ptr, T.sizeof);
        }
    }
}

T read(T, bool fixedSize = false)(InputStream istrm)
{
    auto s = Series!(T, fixedSize)(istrm);
    return s.value;
}

size_t write(T, bool fixedSize = false)(InputStream istrm, T val)
{
    auto s = Series!(T, fixedSize)(val);
    return s.writeTo(istrm);
}

