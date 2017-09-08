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

class ShadowArea: Owner, Drawable
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
    Vector3f position;

    this(View view, Environment env, float w, float h, float start, float end, Owner o)
    {
        super(o);   
        this.width = w;
        this.height = h;
        this.start = start;
        this.end = end; 

        this.view = view;
        
        this.environment = env;

        depth = abs(start) + abs(end);
        this.box = New!ShapeBox(w * 0.5f, h * 0.5f, depth * 0.5f, this);
        
        this.position = Vector3f(0, 0, 0);

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
        auto t = translationMatrix(position);
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

        glPushMatrix();
        glMultMatrixf(invViewMatrix.arrayof.ptr);
        
        glPointSize(5.0f);
        glBegin(GL_POINTS);
        glVertex3f(0, 0, 0);
        glEnd();
        glPointSize(1.0f);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
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

/*
class ShadowMap: Owner
{
    uint size;
    BaseScene3D scene;
    ShadowArea area;

    Texture depthTexture;
    GLuint framebuffer;

    //bool useFBO = false;

    this(uint size, BaseScene3D scene, ShadowArea area, Owner o)
    {
        super(o);
        this.size = size;
        this.scene = scene;
        this.area = area;
        
        init();
    }
    
    void init()
    {
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
*/

class CascadedShadowMap: Owner, Drawable
{
    uint size;
    BaseScene3D scene;
    ShadowArea area1;
    ShadowArea area2;
    ShadowArea area3;
    
    Texture depthTexture;
    GLuint framebuffer;
    GLuint framebuffer2;
    GLuint framebuffer3;

    this(uint size, BaseScene3D scene, Owner o)
    {
        super(o);
        this.size = size;
        this.scene = scene;
        
        // TODO: user-defined projection sizes and depth range
        this.area1 = New!ShadowArea(scene.view, scene.environment, 10, 10, -100, 100, this);
        this.area2 = New!ShadowArea(scene.view, scene.environment, 30, 30, -100, 100, this);
        this.area3 = New!ShadowArea(scene.view, scene.environment, 100, 100, -100, 100, this);

        init();
    }
    
    Vector3f position()
    {
        return area1.position;
    }
    
    void position(Vector3f pos)
    {
        area1.position = pos;
        area2.position = pos;
        area3.position = pos;
    }

    void init()
    {
        depthTexture = New!Texture(this);
        
        glGenTextures(1, &depthTexture.tex);
        glBindTexture(GL_TEXTURE_2D_ARRAY, depthTexture.tex);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
        
        Color4f borderColor = Color4f(1, 1, 1, 1);
        
        glTexParameterfv(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_BORDER_COLOR, borderColor.arrayof.ptr);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
	    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_DEPTH_TEXTURE_MODE, GL_INTENSITY);

        // Use 3-layer texture array to store cascades
        glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_DEPTH_COMPONENT, size, size, 3, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, null);
        
        glBindTexture(GL_TEXTURE_2D_ARRAY, 0);

        glGenFramebuffers(1, &framebuffer);
	    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glDrawBuffer(GL_NONE);
	    glReadBuffer(GL_NONE);
        glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTexture.tex, 0, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        
        glGenFramebuffers(1, &framebuffer2);
	    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer2);
        glDrawBuffer(GL_NONE);
	    glReadBuffer(GL_NONE);
        glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTexture.tex, 0, 1);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        
        glGenFramebuffers(1, &framebuffer3);
	    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer3);
        glDrawBuffer(GL_NONE);
	    glReadBuffer(GL_NONE);
        glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTexture.tex, 0, 2);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
    
    ~this()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glDeleteFramebuffers(1, &framebuffer);
        glDeleteFramebuffers(1, &framebuffer2);
        glDeleteFramebuffers(1, &framebuffer3);
    }
    
    void update(double dt)
    {
        area1.update(dt);
        area2.update(dt);
        area3.update(dt);
    }
    
    void render(RenderingContext* rc)
    {
        glEnable(GL_DEPTH_TEST);
        
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

        glViewport(0, 0, size, size);
        glScissor(0, 0, size, size);
        glClear(GL_DEPTH_BUFFER_BIT);

        auto rcLocal = *rc;
        rcLocal.projectionMatrix = area1.projectionMatrix;
        rcLocal.viewMatrix = area1.viewMatrix;
        rcLocal.invViewMatrix = area1.invViewMatrix;
        rcLocal.normalMatrix = matrix4x4to3x3(rcLocal.invViewMatrix).transposed;
        rcLocal.apply();
        
        glShadeModel(GL_FLAT);
        glColorMask(0, 0, 0, 0);
        glDisable(GL_CULL_FACE);
        glPolygonOffset(3.0, 0.0);

        scene.renderEntities3D(&rcLocal);
         
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer2);

        glViewport(0, 0, size, size);
        glScissor(0, 0, size, size);
        glClear(GL_DEPTH_BUFFER_BIT);

        rcLocal.projectionMatrix = area2.projectionMatrix;
        rcLocal.viewMatrix = area2.viewMatrix;
        rcLocal.invViewMatrix = area2.invViewMatrix;
        rcLocal.normalMatrix = matrix4x4to3x3(rcLocal.invViewMatrix).transposed;
        rcLocal.apply();
        
        scene.renderEntities3D(&rcLocal);
        
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer3);

        glViewport(0, 0, size, size);
        glScissor(0, 0, size, size);
        glClear(GL_DEPTH_BUFFER_BIT);

        rcLocal.projectionMatrix = area3.projectionMatrix;
        rcLocal.viewMatrix = area3.viewMatrix;
        rcLocal.invViewMatrix = area3.invViewMatrix;
        rcLocal.normalMatrix = matrix4x4to3x3(rcLocal.invViewMatrix).transposed;
        rcLocal.apply();

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
