module dagon.graphics.view;

import dlib.math.vector;
import dlib.math.matrix;
import dagon.graphics.rc;

interface View
{
    void update(double dt);
    Matrix4x4f viewMatrix();
    Matrix4x4f invViewMatrix();
    Vector3f cameraPosition();

    final void prepareRC(RenderingContext* rc)
    {
        rc.viewMatrix = viewMatrix();
        rc.invViewMatrix = invViewMatrix();
        rc.normalMatrix = matrix4x4to3x3(rc.invViewMatrix).transposed;
        rc.cameraPosition = cameraPosition();
    }
}
