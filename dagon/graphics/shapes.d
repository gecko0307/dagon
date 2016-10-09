module dagon.graphics.shapes;

import dlib.core.memory;
import dlib.math.vector;
import derelict.opengl.gl;
import derelict.opengl.glu;
import dagon.core.interfaces;
import dagon.core.ownership;

class ShapeSphere: Owner, Drawable
{
    uint displayList;

    this(float r, Owner owner)
    {
        super(owner);

        GLUquadricObj* quadric = gluNewQuadric();
        gluQuadricNormals(quadric, GLU_SMOOTH);
        gluQuadricTexture(quadric, GL_TRUE);

        displayList = glGenLists(1);
        glNewList(displayList, GL_COMPILE);
        gluSphere(quadric, r, 24, 16);
        glEndList();

        gluDeleteQuadric(quadric);
    }

    void update(double dt)
    {
    }

    void render()
    {
        glCallList(displayList);
    }

    ~this()
    {
        glDeleteLists(displayList, 1);
    }
}

/*
class ShapeBox: Drawable
{
    uint displayList;

    this(float sx, float sy, float sz)
    {
        this(Vector3f(sx, sy, sz));
    }

    this(Vector3f hsize)
    {
        displayList = glGenLists(1);
        glNewList(displayList, GL_COMPILE);

        Vector3f pmax = +hsize;
        Vector3f pmin = -hsize;

        glBegin(GL_QUADS);

        glTexCoord2f(0, 1); glNormal3f(0,0,1); glVertex3f(pmin.x,pmin.y,pmax.z);
        glTexCoord2f(1, 1); glNormal3f(0,0,1); glVertex3f(pmax.x,pmin.y,pmax.z);
        glTexCoord2f(1, 0); glNormal3f(0,0,1); glVertex3f(pmax.x,pmax.y,pmax.z);
        glTexCoord2f(0, 0); glNormal3f(0,0,1); glVertex3f(pmin.x,pmax.y,pmax.z);

        glTexCoord2f(0, 1); glNormal3f(1,0,0); glVertex3f(pmax.x,pmin.y,pmax.z);
        glTexCoord2f(1, 1); glNormal3f(1,0,0); glVertex3f(pmax.x,pmin.y,pmin.z);
        glTexCoord2f(1, 0); glNormal3f(1,0,0); glVertex3f(pmax.x,pmax.y,pmin.z);
        glTexCoord2f(0, 0); glNormal3f(1,0,0); glVertex3f(pmax.x,pmax.y,pmax.z);

        glTexCoord2f(0, 1); glNormal3f(0,1,0); glVertex3f(pmin.x,pmax.y,pmax.z);
        glTexCoord2f(1, 1); glNormal3f(0,1,0); glVertex3f(pmax.x,pmax.y,pmax.z);
        glTexCoord2f(1, 0); glNormal3f(0,1,0); glVertex3f(pmax.x,pmax.y,pmin.z);
        glTexCoord2f(0, 0); glNormal3f(0,1,0); glVertex3f(pmin.x,pmax.y,pmin.z);

        glTexCoord2f(0, 1); glNormal3f(0,0,-1); glVertex3f(pmin.x,pmin.y,pmin.z);
        glTexCoord2f(1, 1); glNormal3f(0,0,-1); glVertex3f(pmin.x,pmax.y,pmin.z);
        glTexCoord2f(1, 0); glNormal3f(0,0,-1); glVertex3f(pmax.x,pmax.y,pmin.z);
        glTexCoord2f(0, 0); glNormal3f(0,0,-1); glVertex3f(pmax.x,pmin.y,pmin.z);

        glTexCoord2f(0, 1); glNormal3f(0,-1,0); glVertex3f(pmin.x,pmin.y,pmin.z);
        glTexCoord2f(1, 1); glNormal3f(0,-1,0); glVertex3f(pmax.x,pmin.y,pmin.z);
        glTexCoord2f(1, 0); glNormal3f(0,-1,0); glVertex3f(pmax.x,pmin.y,pmax.z);
        glTexCoord2f(0, 0); glNormal3f(0,-1,0); glVertex3f(pmin.x,pmin.y,pmax.z);

        glTexCoord2f(0, 1); glNormal3f(-1,0,0); glVertex3f(pmin.x,pmin.y,pmin.z);
        glTexCoord2f(1, 1); glNormal3f(-1,0,0); glVertex3f(pmin.x,pmin.y,pmax.z);
        glTexCoord2f(1, 0); glNormal3f(-1,0,0); glVertex3f(pmin.x,pmax.y,pmax.z);
        glTexCoord2f(0, 0); glNormal3f(-1,0,0); glVertex3f(pmin.x,pmax.y,pmin.z);

        glEnd();

        glEndList();
    }

    override void draw(double dt)
    {
        glCallList(displayList);
    }

    ~this()
    {
        glDeleteLists(displayList, 1);
    }
}

class ShapeCylinder: Drawable
{
    // TODO: slices, stacks
    uint displayList;

    this(float h, float r)
    {
        GLUquadricObj* quadric = gluNewQuadric();
        gluQuadricNormals(quadric, GLU_SMOOTH);
        gluQuadricTexture(quadric, GL_TRUE);

        displayList = glGenLists(1);
        glNewList(displayList, GL_COMPILE);
        glTranslatef(0.0f, h * 0.5f, 0.0f);
        glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
        gluCylinder(quadric, r, r, h, 16, 2);
        gluQuadricOrientation(quadric, GLU_INSIDE);
        gluDisk(quadric, 0, r, 16, 1);
        gluQuadricOrientation(quadric, GLU_OUTSIDE);
        glTranslatef(0.0f, 0.0f, h);
        gluDisk(quadric, 0, r, 16, 1);
        glEndList();

        gluDeleteQuadric(quadric);
    }

    override void draw(double dt)
    {
        glCallList(displayList);
    }

    ~this()
    {
        glDeleteLists(displayList, 1);
    }
}

class ShapeCone: Drawable
{
    // TODO: slices, stacks
    uint displayList;

    this(float h, float r)
    {
        GLUquadricObj* quadric = gluNewQuadric();
        gluQuadricNormals(quadric, GLU_SMOOTH);
        gluQuadricTexture(quadric, GL_TRUE);

        displayList = glGenLists(1);
        glNewList(displayList, GL_COMPILE);
        glTranslatef(0.0f, 0.0f, -h * 0.5f);
        gluCylinder(quadric, r, 0.0f, h, 16, 2);
        gluQuadricOrientation(quadric, GLU_INSIDE);
        gluDisk(quadric, 0, r, 16, 1);
        glEndList();

        gluDeleteQuadric(quadric);
    }

    override void draw(double dt)
    {
        glCallList(displayList);
    }

    ~this()
    {
        glDeleteLists(displayList, 1);
    }
}

class ShapeEllipsoid: Drawable
{
    uint displayList;
    Vector3f radii;

    this(float rx, float ry, float rz)
    {
        this(Vector3f(rx, ry, rz));
    }

    this(Vector3f r)
    {
        radii = r;

        GLUquadricObj*  quadric = gluNewQuadric();
        gluQuadricNormals(quadric, GLU_SMOOTH);
        gluQuadricTexture(quadric, GL_TRUE);

        displayList = glGenLists(1);
        glNewList(displayList, GL_COMPILE);
        gluSphere(quadric, 1.0f, 24, 16);
        glEndList();

        gluDeleteQuadric(quadric);
    }

    override void draw(double dt)
    {
        glPushMatrix();
        glScalef(radii.x, radii.y, radii.z);
        glCallList(displayList);
        glPopMatrix();
    }

    ~this()
    {
        glDeleteLists(displayList, 1);
    }
}
*/
