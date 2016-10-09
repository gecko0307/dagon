module dagon.graphics.freeview;

import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.quaternion;

import derelict.sdl2.sdl;

import dagon.core.ownership;
import dagon.core.event;
import dagon.core.keycodes;
import dagon.graphics.tbcamera;

class Freeview: EventListener
{
    TrackballCamera camera;
    int prevMouseX;
    int prevMouseY;

    this(EventManager emngr, Owner owner)
    {
        super(emngr, owner);
        camera = new TrackballCamera();
        camera.pitch(45.0f);
        camera.turn(45.0f);
        camera.setZoom(20.0f);
    }

    void reset()
    {
        camera.reset();
        camera.pitch(45.0f);
        camera.turn(45.0f);
        camera.setZoom(20.0f);
        camera.update(1.0 / 60.0);
    }

    ~this()
    {
    }

    override void onMouseButtonDown(int button)
    {
        if (button == MB_MIDDLE)
        {
            prevMouseX = eventManager.mouseX;
            prevMouseY = eventManager.mouseY;
        }
    }
    
    override void onMouseWheel(int x, int y)
    {
        camera.zoom(cast(float)y * 0.2f);
    }

    void update(double dt)
    {
        processEvents();

        if (eventManager.mouseButtonPressed[MB_MIDDLE] && eventManager.keyPressed[KEY_LSHIFT])
        {
            float shift_x = (eventManager.mouseX - prevMouseX) * 0.1f;
            float shift_y = (eventManager.mouseY - prevMouseY) * 0.1f;
            Vector3f trans = camera.getUpVector * shift_y + camera.getRightVector * shift_x;
            camera.translateTarget(trans);
        }
        else if (eventManager.mouseButtonPressed[MB_MIDDLE] && eventManager.keyPressed[KEY_LCTRL])
        {
            float shift_x = (eventManager.mouseX - prevMouseX);
            float shift_y = (eventManager.mouseY - prevMouseY);
            camera.zoom((shift_x + shift_y) * 0.1f);
        }
        else if (eventManager.mouseButtonPressed[MB_MIDDLE])
        {                
            float turn_m = (eventManager.mouseX - prevMouseX);
            float pitch_m = -(eventManager.mouseY - prevMouseY);
            camera.pitch(pitch_m);
            camera.turn(turn_m);
        }

        prevMouseX = eventManager.mouseX;
        prevMouseY = eventManager.mouseY;
        
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
