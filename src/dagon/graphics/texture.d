module dagon.graphics.texture;

import std.stdio;

import derelict.opengl.gl;
import derelict.opengl.glu;

import dlib.core.memory;
import dlib.image.image;
import dlib.math.vector;

import dagon.core.ownership;

class Texture: Owner
{
    GLuint tex;
    GLenum format;
    GLenum type;
    int width;
    int height;
    Vector2f translation;
    Vector2f scale;
    float rotation;

    this(Owner o)
    {
        super(o);
        translation = Vector2f(0.0f, 0.0f);
        scale = Vector2f(1.0f, 1.0f);
        rotation = 0.0f;
    }

    this(uint w, uint h, Owner o)
    {
        super(o);
        translation = Vector2f(0.0f, 0.0f);
        scale = Vector2f(1.0f, 1.0f);
        rotation = 0.0f;

        width = w;
        height = h;

        glGenTextures(1, &tex);
        glBindTexture(GL_TEXTURE_2D, tex);
        glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }


    this(SuperImage img, Owner o, bool genMipmaps = true)
    {
        super(o);
        translation = Vector2f(0.0f, 0.0f);
        scale = Vector2f(1.0f, 1.0f);
        rotation = 0.0f;
        createFromImage(img, genMipmaps);
    }

    void createFromImage(SuperImage img, bool genMipmaps = true)
    {
        if (glIsTexture(tex))
            glDeleteTextures(1, &tex);

        width = img.width;
        height = img.height;

        GLint intFormat;
        type = GL_UNSIGNED_BYTE;

        switch (img.pixelFormat)
        {
            case PixelFormat.L8:     intFormat = GL_LUMINANCE8;        format = GL_LUMINANCE; break;
            case PixelFormat.LA8:    intFormat = GL_LUMINANCE8_ALPHA8; format = GL_LUMINANCE_ALPHA; break;
            case PixelFormat.RGB8:   intFormat = GL_RGB8;              format = GL_RGB; break;
            case PixelFormat.RGBA8:  intFormat = GL_RGBA8;             format = GL_RGBA; break;
            default:
                writefln("Unsupported pixel format %s", img.pixelFormat);
                return;
        }

        glGenTextures(1, &tex);
        glBindTexture(GL_TEXTURE_2D, tex);

        if (genMipmaps)
        {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        }
        else
        {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        }

        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

        gluBuild2DMipmaps(GL_TEXTURE_2D,
            intFormat, width, height, format,
            type, cast(void*)img.data.ptr);
    }

    void bind()
    {
        glEnable(GL_TEXTURE_2D);
        if (glIsTexture(tex))
            glBindTexture(GL_TEXTURE_2D, tex);
        glMatrixMode(GL_TEXTURE);
        glPushMatrix();
        glLoadIdentity();
        glTranslatef(translation.x, translation.y, 0);
        glRotatef(rotation, 0.0f, 0.0f, 1.0f);
        glScalef(scale.x, scale.y, 0);
        glMatrixMode(GL_MODELVIEW);
    }

    void unbind()
    {
        glMatrixMode(GL_TEXTURE);
        glPopMatrix();
        glMatrixMode(GL_MODELVIEW);

        glBindTexture(GL_TEXTURE_2D, 0);
        glDisable(GL_TEXTURE_2D);
    }
    
    bool valid()
    {
        return cast(bool)glIsTexture(tex);
    }

    void release()
    {
        if (glIsTexture(tex))
            glDeleteTextures(1, &tex);
    }

    ~this()
    {
        release();
    }

    void copyRendered()
    {
        glBindTexture(GL_TEXTURE_2D, tex);
        glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, width, height);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
}

