module dagon.graphics.fpview;

import dlib.core.memory;
import dlib.math.vector;
import dlib.math.matrix;

import derelict.sdl2.sdl;

import dagon.core.ownership;
import dagon.core.event;

import dagon.graphics.fpcamera;
import dagon.graphics.view;

class FirstPersonView: EventListener, View
{
    FirstPersonCamera camera;
    int oldMouseX = 0;
    int oldMouseY = 0;
    bool _active = false;

    this(EventManager emngr, Vector3f camPos, Owner owner)
    {
        super(emngr, owner);

        camera = New!FirstPersonCamera(camPos, this);
    }

    void update(double dt)
    {
        processEvents();
                
        if (_active)
        {            
            float turn_m =  (eventManager.mouseRelX) * 0.2f;
            float pitch_m = (eventManager.mouseRelY) * 0.2f;
        
            camera.pitch += pitch_m;
            camera.turn += turn_m;
            float pitchLimitMax = 60.0f;
            float pitchLimitMin = -60.0f;
            if (camera.pitch > pitchLimitMax)
                camera.pitch = pitchLimitMax;
            else if (camera.pitch < pitchLimitMin)
                camera.pitch = pitchLimitMin;
        }
        
        camera.update(dt);
    }
    
    void active(bool v)
    {
        if (v)
        {
            oldMouseX = eventManager.mouseX;
            oldMouseY = eventManager.mouseY;
            SDL_SetRelativeMouseMode(1);
        }
        else
        {
            SDL_SetRelativeMouseMode(0);
            eventManager.setMouse(oldMouseX, eventManager.windowHeight - oldMouseY);
        }
        
        _active = v;
    }
    
    bool active()
    {
        return _active;
    }

    Matrix4x4f viewMatrix()
    {
        return camera.viewMatrix();
    }
    
    Matrix4x4f invViewMatrix()
    {
        return camera.invViewMatrix();
    }
    
    Vector3f cameraPosition()
    {
        return camera.position;
    }
}
