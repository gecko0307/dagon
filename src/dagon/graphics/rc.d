module dagon.graphics.rc;

import dlib.math.vector;
import dlib.math.matrix;
import derelict.opengl.gl;
import dagon.core.event;
import dagon.graphics.environment;
import dagon.graphics.material;

struct RenderingContext
{
    Vector3f position;
    Matrix3x3f rotation;
    Vector3f scaling;

    Matrix4x4f modelMatrix;
    Matrix4x4f invModelMatrix;

    Vector3f cameraPosition;

    Matrix4x4f viewMatrix;
    Matrix4x4f invViewMatrix;

    Matrix4x4f projectionMatrix;
    Matrix3x3f normalMatrix;

    EventManager eventManager;
    Environment environment;
    Material overrideMaterial;
    
    void init(EventManager emngr, Environment env)
    {
        position = Vector3f(0.0f, 0.0f, 0.0f);
        rotation = Matrix3x3f.identity;
        scaling = Vector3f(1.0f, 1.0f, 1.0f);
        modelMatrix = Matrix4x4f.identity;
        invModelMatrix = Matrix4x4f.identity;
        cameraPosition = Vector3f(0.0f, 0.0f, 0.0f);
        viewMatrix = Matrix4x4f.identity;
        invViewMatrix = Matrix4x4f.identity;
        projectionMatrix = Matrix4x4f.identity;
        normalMatrix = Matrix3x3f.identity;
        eventManager = emngr;
        environment = env;
        overrideMaterial = null;
    }

    void apply()
    {
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf(projectionMatrix.arrayof.ptr);
        glMatrixMode(GL_MODELVIEW);
        glLoadMatrixf(viewMatrix.arrayof.ptr);
    }
}

