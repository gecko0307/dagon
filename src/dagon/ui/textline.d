module dagon.ui.textline;

import derelict.opengl.gl;
import derelict.opengl.glu;
import derelict.freetype.ft;

import dlib.core.memory;
import dlib.math.vector;
import dlib.image.color;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.ui.font;

enum Alignment
{
    Left,
    Right,
    Center
}

class TextLine: Owner, Drawable
{
    Font font;
    float scaling;
    Alignment alignment;
    Color4f color;
    string text;
    float width;
    float height;

    this(Font font, string text, Owner o)
    {
        super(o);
        this.font = font;
        this.text = text;
        this.scaling = 1.0f;
        this.width = font.width(text);
        this.height = font.height;
        this.alignment = Alignment.Left;
        this.color = Color4f(0, 0, 0);
    }

    override void update(double dt)
    {
    }

    override void render()
    {
        glPushAttrib(GL_LIST_BIT | GL_CURRENT_BIT  | GL_ENABLE_BIT | GL_TRANSFORM_BIT);
        glDisable(GL_LIGHTING);
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glColor4f(color.r, color.g, color.b, color.a);

        glPushMatrix();
        if (alignment == Alignment.Center)
            glTranslatef(-width * 0.5f, 0, 0);
        if (alignment == Alignment.Right)
            glTranslatef(-width, 0, 0);
        glScalef(scaling, scaling, scaling);
        font.render(text);
        glPopMatrix();
        glPopAttrib();
    }

    void setFont(Font font)
    {
        this.font = font;
        this.width = font.width(text);
        this.height = font.height;
    }

    void setText(string text)
    {
        this.text = text;
        this.width = font.width(text);
    }
}

