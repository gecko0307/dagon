module textbuffer;

import dlib.math.utils;

// Fixed-capacity, always zero-terminated text buffer.
struct TextBuffer(size_t capacity)
{
    char[capacity] data = 0;
    size_t length;

    void clear()
    {
        length = 0;
        data[0] = 0;
    }

    void set(const(char)[] text)
    {
        clear();
        append(text);
    }

    void append(const(char)[] text)
    {
        size_t count = min2(text.length, capacity - 1 - length);
        data[length..length + count] = text[0..count];
        length += count;
        data[length] = 0;
    }

    void truncate(size_t newLength)
    {
        if (newLength < length)
        {
            length = newLength;
            data[length] = 0;
        }
    }

    const(char)[] slice() const { return data[0..length]; }
    const(char)* cstr() const { return data.ptr; }
}
