module dagon.ui.ftfont;

import std.stdio;

import std.string;
import std.ascii;
import std.utf;
import std.file;

import dlib.core.memory;
import dlib.core.stream;
import dlib.container.dict;
import dlib.text.utf8;

import derelict.opengl.gl;
import derelict.freetype.ft;

import dagon.core.ownership;
import dagon.ui.font;

struct Glyph
{
    bool valid;
    GLuint textureId = 0;
    FT_Glyph ftGlyph = null;
    int width = 0;
    int height = 0;
    FT_Pos advanceX = 0;
}

int nextPowerOfTwo(int a)
{
    int rval = 1;
    while(rval < a)
        rval <<= 1;
    return rval;
}

final class FreeTypeFont: Font
{
    FT_Face ftFace;
    FT_Library ftLibrary;
    Dict!(Glyph, dchar) glyphs;

    this(uint height)
    {
        this.height = height;

        if (FT_Init_FreeType(&ftLibrary))
            throw new Exception("FT_Init_FreeType failed");
    }

    void createFromFile(string filename)
    {
        if (!exists(filename))
            throw new Exception("Cannot find font file " ~ filename);

        if (FT_New_Face(ftLibrary, toStringz(filename), 0, &ftFace))
            throw new Exception("FT_New_Face failed (there is probably a problem with your font file)");

        FT_Set_Char_Size(ftFace, cast(int)height << 6, cast(int)height << 6, 96, 96);
        glyphs = New!(Dict!(Glyph, dchar));
    }

    void createFromMemory(ubyte[] buffer)
    {
        if (FT_New_Memory_Face(ftLibrary, buffer.ptr, cast(uint)buffer.length, 0, &ftFace))
            throw new Exception("FT_New_Face failed (there is probably a problem with your font file)");

        FT_Set_Char_Size(ftFace, cast(int)height << 6, cast(int)height << 6, 96, 96);
        glyphs = New!(Dict!(Glyph, dchar));
    }

    void preloadASCII()
    {
        enum ASCII_CHARS = 128;
        foreach(i; 0..ASCII_CHARS)
        {
            GLuint tex;
            glGenTextures(1, &tex);
            loadGlyph(i, tex);
        }
    }

    ~this()
    {
        foreach(i, glyph; glyphs)
            glDeleteTextures(1, &glyph.textureId);
        Delete(glyphs);
    }

    void free()
    {
        Delete(this);
    }

    uint loadGlyph(dchar code, GLuint texId)
    {
        FT_Glyph glyph;

        uint charIndex = FT_Get_Char_Index(ftFace, code);

        if (charIndex == 0)
        {
            //TODO: if character wasn't found in font file
        }

        auto res = FT_Load_Glyph(ftFace, charIndex, FT_LOAD_DEFAULT);

        if (res)
            throw new Exception(format("FT_Load_Glyph failed with code %s", res));

        if (FT_Get_Glyph(ftFace.glyph, &glyph))
            throw new Exception("FT_Get_Glyph failed");

        FT_Glyph_To_Bitmap(&glyph, FT_Render_Mode.FT_RENDER_MODE_NORMAL, null, 1);
        FT_BitmapGlyph bitmapGlyph = cast(FT_BitmapGlyph)glyph;

        FT_Bitmap bitmap = bitmapGlyph.bitmap;

        int width = nextPowerOfTwo(bitmap.width);
        int height = nextPowerOfTwo(bitmap.rows);

        GLubyte[] img = New!(GLubyte[])(2 * width * height);

        foreach(j; 0..height)
        foreach(i; 0..width)
        {
            img[2 * (i + j * width)] = 255;
            img[2 * (i + j * width) + 1] =
                (i >= bitmap.width || j >= bitmap.rows)?
                 0 : bitmap.buffer[i + bitmap.width * j];
        }

        glBindTexture(GL_TEXTURE_2D, texId);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        glTexImage2D(GL_TEXTURE_2D,
            0, GL_RGBA, width, height,
            0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, img.ptr);

        Delete(img);

        Glyph g = Glyph(true, texId, glyph, width, height, ftFace.glyph.advance.x);
        glyphs[code] = g;

        return charIndex;
    }

    dchar loadChar(dchar code)
    {
        GLuint tex;
        glGenTextures(1, &tex);
        loadGlyph(code, tex);
        return code;
    }

    float renderGlyph(dchar code)
    {
        Glyph glyph;
        if (code in glyphs)
            glyph = glyphs[code];
        else
            glyph = glyphs[loadChar(code)];

        //if (!glyph.valid)
        //    return 0.0f;

        FT_BitmapGlyph bitmapGlyph = cast(FT_BitmapGlyph)(glyph.ftGlyph);
        FT_Bitmap bitmap = bitmapGlyph.bitmap;

        glBindTexture(GL_TEXTURE_2D, glyph.textureId);

        glPushMatrix();
        glTranslatef(bitmapGlyph.left, 0, 0);

        float chWidth = cast(float)bitmap.width;
        float chHeight = cast(float)bitmap.rows;
        float texWidth = cast(float)glyph.width;
        float texHeight = cast(float)glyph.height;

        glTranslatef(0, bitmapGlyph.top - bitmap.rows, 0);
        float x = 0.5f / texWidth + chWidth / texWidth;
        float y = 0.5f / texHeight + chHeight / texHeight;
        glBegin(GL_QUADS);
            glTexCoord2f(0, 0); glVertex2f(0, bitmap.rows);
            glTexCoord2f(0, y); glVertex2f(0, 0);
            glTexCoord2f(x, y); glVertex2f(bitmap.width, 0);
            glTexCoord2f(x, 0); glVertex2f(bitmap.width, bitmap.rows);
        glEnd();
        glPopMatrix();
        float shift = glyph.advanceX >> 6;
        glTranslatef(shift, 0, 0);

        glBindTexture(GL_TEXTURE_2D, 0);

        return shift;
    }

    int glyphAdvance(dchar code)
    {
        Glyph glyph;
        if (code in glyphs)
            glyph = glyphs[code];
        else
            glyph = glyphs[loadChar(code)];
        return cast(int)(glyph.advanceX >> 6);
    }

    override void render(string str)
    {
        UTF8Decoder dec = UTF8Decoder(str);
        int ch;
        do
        {
            ch = dec.decodeNext();
            if (ch == 0 || ch == UTF8_END || ch == UTF8_ERROR) break;
            dchar code = ch;
            if (code.isASCII)
            {
                if (code.isPrintable)
                    renderGlyph(code);
            }
            else
                renderGlyph(code);
        } while(ch != UTF8_END && ch != UTF8_ERROR);
    }

    override float width(string str)
    {
        float width = 0.0f;
        UTF8Decoder dec = UTF8Decoder(str);
        int ch;
        do
        {
            ch = dec.decodeNext();
            if (ch == 0 || ch == UTF8_END || ch == UTF8_ERROR) break;
            dchar code = ch;
            if (code.isASCII)
            {
                if (code.isPrintable)
                    width += glyphAdvance(code);
            }
            else
                width += glyphAdvance(code);
        } while(ch != UTF8_END && ch != UTF8_ERROR);

        return width;
    }
}

