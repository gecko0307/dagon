module dagon.core.interfaces;

public import dagon.graphics.rc;

interface Drawable
{
    void update(double dt);
    void render(RenderingContext* rc);
}
