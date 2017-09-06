module dagon.graphics.environment;

import dlib.image.color;
import dlib.math.vector;
import dlib.math.quaternion;
import dlib.math.interpolation;
import dagon.core.ownership;

class Environment: Owner
{
    // TODO: change/interpolate parameters based on object position?
    
    Color4f backgroundColor = Color4f(0.1f, 0.1f, 0.1f, 1.0f);
    Color4f ambientConstant = Color4f(0.1f, 0.1f, 0.1f, 1.0f);
    // TODO: ambient map (cubemap and equirectangular map)

    Color4f fogColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
    float fogStart = 20.0f;
    float fogEnd = 100.0f;
    
    Color4f sunZenithColor = Color4f(0.7, 0.7, 0.6, 1.0);
    Color4f sunHorizonColor = Color4f(0.8, 0.3, 0.0, 1.0);
    Quaternionf sunRotation;

    // TODO: shadow map (CSM)

    this(Owner o)
    {
        super(o);
        
        sunRotation = rotationQuaternion(Axis.x, degtorad(-45.0f)); //Quaternionf.identity;
    }
    
    Vector3f sunDirection()
    {
        return sunRotation.rotate(Vector3f(0, 0, 1));
    }

    Color4f sunColor()
    {
        return lerpColorsBySunAngle(sunZenithColor, sunHorizonColor);
    }
    
    Color4f lerpColorsBySunAngle(Color4f atZenith, Color4f atHorizon)
    {
        float s = dot(sunDirection, Vector3f(0.0, 1.0, 0.0));
        Vector3f sunColor;
        if (s < 0.01f)
            sunColor = Vector3f(0.0f, 0.0f, 0.0f);
        else if (s < 0.08f)
        {
            sunColor = lerp(atHorizon, atZenith, s);
            sunColor = lerp(sunColor, Vector3f(0.0f, 0.0f, 0.0f), (0.07f - (s - 0.01f)) / 0.07f);
        }
        else
            sunColor = lerp(Vector3f(atHorizon), Vector3f(atZenith), s);
        return Color4f(sunColor.x, sunColor.y, sunColor.z, 1.0f);
    }
}
