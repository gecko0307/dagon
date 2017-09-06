module dagon.graphics.shadow;

import std.stdio;
import std.math;
import std.conv;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.image.color;
import dlib.image.unmanaged;
import dlib.image.render.shapes;

import derelict.opengl.gl;
import derelict.opengl.glext;

import dagon.core.interfaces;
import dagon.core.ownership;
import dagon.logics.entity;
import dagon.logics.behaviour;
import dagon.graphics.shapes;
import dagon.graphics.texture;
import dagon.graphics.view;
import dagon.graphics.rc;
import dagon.graphics.environment;

import dagon.templates.basescene;

class ShadowArea: Behaviour
{
    Environment environment;
    Matrix4x4f biasMatrix;
    Matrix4x4f projectionMatrix;
    Matrix4x4f viewMatrix;
    Matrix4x4f invViewMatrix;
    Matrix4x4f shadowMatrix;
    float width;
    float height;
    float depth;
    float start;
    float end;
    float scale = 1.0f;
    ShapeBox box;
    View view;

    this(Entity e, View view, Environment env, float w, float h, float start, float end)
    {
        super(e);   
        this.width = w;
        this.height = h;
        this.start = start;
        this.end = end; 

        this.view = view;
        
        this.environment = env;

        depth = abs(start) + abs(end);
        this.box = New!ShapeBox(w * 0.5f, h * 0.5f, depth * 0.5f, this);

        this.biasMatrix = matrixf(
            0.5f, 0.0f, 0.0f, 0.5f,
            0.0f, 0.5f, 0.0f, 0.5f,
            0.0f, 0.0f, 0.5f, 0.5f,
            0.0f, 0.0f, 0.0f, 1.0f,
        );

        float hw = w * 0.5f;
        float hh = h * 0.5f;
        this.projectionMatrix = orthoMatrix(-hw, hw, -hh, hh, start, end);
        
        this.shadowMatrix = Matrix4x4f.identity;
        this.viewMatrix = Matrix4x4f.identity;
        this.invViewMatrix = Matrix4x4f.identity;
    }

    override void update(double dt)
    {
        //viewMatrix = entity.invTransformation;
        //invViewMatrix = entity.transformation;
        auto t = translationMatrix(entity.position);
        auto r = environment.sunRotation.toMatrix4x4;
        invViewMatrix = t * r;
        viewMatrix = invViewMatrix.inverse;
        shadowMatrix = scaleMatrix(Vector3f(scale, scale, 1.0f)) * biasMatrix * projectionMatrix * viewMatrix * view.invViewMatrix;
    }

    override void render(RenderingContext* rc)
    {
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        glEnable(GL_LINE_STIPPLE);
        glLineStipple(1, 0xF0F0);

        glColor4f(1.0f, 1.0f, 0.0f, 1.0f);

        glPointSize(5.0f);
        glBegin(GL_POINTS);
        glVertex3f(0, 0, 0);
        glEnd();
        glPointSize(1.0f);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

        glPushMatrix();
        glTranslatef(0, 0, -depth * 0.5f - start);
        box.render(rc);

        glColor4f(1.0f, 1.0f, 0.0f, 1.0f);
        glBegin(GL_LINES);
        glVertex3f(0, 0, -depth * 0.5f);
        glVertex3f(0, 0, depth * 0.5f);
        glEnd();
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

        glPopMatrix();
        glLineStipple(1, 1);
        glDisable(GL_LINE_STIPPLE);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }
}

class ShadowMap: Owner
{
    uint size;
    BaseScene3D scene;
    ShadowArea area;

    Texture depthTexture;
    GLuint framebuffer;

    bool useFBO = false;

    this(uint size, BaseScene3D scene, ShadowArea area, Owner o)
    {
        super(o);
        this.size = size;
        this.scene = scene;
        this.area = area;
        
        depthTexture = New!Texture(this);
        
        glGenTextures(1, &depthTexture.tex);
        glBindTexture(GL_TEXTURE_2D, depthTexture.tex);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
        
        Color4f borderColor = Color4f(1, 1, 1, 1);
        
        glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor.arrayof.ptr);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
	    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        
        glTexParameteri(GL_TEXTURE_2D, GL_DEPTH_TEXTURE_MODE, GL_INTENSITY);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, size, size, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, null);
        
        glBindTexture(GL_TEXTURE_2D, 0);

        glGenFramebuffers(1, &framebuffer);
	    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glDrawBuffer(GL_NONE);
	    glReadBuffer(GL_NONE);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTexture.tex, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
    
    ~this()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glDeleteFramebuffers(1, &framebuffer);
    }

    void render(RenderingContext* rc)
    {
        glEnable(GL_DEPTH_TEST);
        
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

        glViewport(0, 0, size, size);
        glScissor(0, 0, size, size);
        glClear(GL_DEPTH_BUFFER_BIT);

        auto rcLocal = *rc;
        rcLocal.projectionMatrix = area.projectionMatrix;
        rcLocal.viewMatrix = area.viewMatrix;
        rcLocal.invViewMatrix = area.invViewMatrix;
        rcLocal.normalMatrix = matrix4x4to3x3(rcLocal.invViewMatrix).transposed;
        rcLocal.apply();
        
        glShadeModel(GL_FLAT);
        glColorMask(0, 0, 0, 0);
        //glCullFace(GL_FRONT);
        glDisable(GL_CULL_FACE);
        glPolygonOffset(3.0, 0.0); //3

        scene.renderEntities3D(&rcLocal);
        
        glPolygonOffset(0.0, 0.0);
        glCullFace(GL_BACK);
        glEnable(GL_CULL_FACE);
        glShadeModel(GL_SMOOTH);
        glColorMask(1, 1, 1, 1);
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        glDisable(GL_DEPTH_TEST);
    }
}
