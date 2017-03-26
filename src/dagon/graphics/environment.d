module dagon.graphics.environment;

import dlib.image.color;
import dagon.core.ownership;

class Environment: Owner
{
    // TODO: change/interpolate parameters based on object position?

    Color4f ambientConstant = Color4f(0.25f, 0.25f, 0.25f, 1.0f);
    // TODO: ambient map (cubemap and equirectangular map)

    Color4f fogColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
    float fogStart = 10.0f;
    float fogEnd = 50.0f;

    // TODO: shadow map (CSM)

    this(Owner o)
    {
        super(o);
    }
}
