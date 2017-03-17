module dagon.graphics.rc;

import dlib.math.matrix;

import dagon.core.event;

struct RenderingContext
{
    Matrix4x4f viewMatrix;
    Matrix4x4f invViewMatrix;

    //Matrix4x4f modelViewMatrix;
    Matrix4x4f projectionMatrix;
    Matrix3x3f normalMatrix;

    EventManager eventManager;
    
    void init(EventManager emngr)
    {
        viewMatrix = Matrix4x4f.identity;
        invViewMatrix = Matrix4x4f.identity;
        projectionMatrix = Matrix4x4f.identity;
        normalMatrix = Matrix3x3f.identity;
        eventManager = emngr;
    }
}
