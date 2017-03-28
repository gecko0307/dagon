module dagon.graphics.fpview;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;

import dagon.core.ownership;
import dagon.core.event;

import dagon.graphics.fpcamera;
import dagon.graphics.view;

class FirstPersonView: EventListener, View
{
    FirstPersonCamera camera;  

    this(EventManager emngr, Vector3f camPos, Owner owner)
    {
        super(emngr, owner);

        camera = New!FirstPersonCamera(camPos, this);
    }

    void update(double dt)
    {
        processEvents();

        int hWidth = eventManager.windowWidth / 2;
        int hHeight = eventManager.windowHeight / 2;
        float turn_m = -(hWidth - eventManager.mouseX) * 0.1f;
        float pitch_m = (hHeight - eventManager.mouseY) * 0.1f;
        camera.pitch += pitch_m;
        camera.turn += turn_m;
        float pitchLimitMax = 60.0f;
        float pitchLimitMin = -60.0f;
        if (camera.pitch > pitchLimitMax)
            camera.pitch = pitchLimitMax;
        else if (camera.pitch < pitchLimitMin)
            camera.pitch = pitchLimitMin;
        eventManager.setMouseToCenter();
        camera.update(dt);
    }

    Matrix4x4f viewMatrix()
    {
        return camera.viewMatrix();
    }
    
    Matrix4x4f invViewMatrix()
    {
        return camera.invViewMatrix();
    }
}

