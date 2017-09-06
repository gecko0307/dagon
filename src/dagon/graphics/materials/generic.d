module dagon.graphics.materials.generic;

import dlib.core.memory;
import dlib.math.vector;
import dlib.image.color;
import derelict.opengl.gl;
import derelict.opengl.glext;
import dagon.core.ownership;
import dagon.graphics.material;
import dagon.graphics.materials.fixed;
import dagon.graphics.rc;

// TODO: output modes

interface GenericMaterialBackend
{
    void bind(GenericMaterial mat, RenderingContext* rc);
    void unbind(GenericMaterial mat);
}

enum int SF_None = 0;
enum int SF_PCF3 = 1;
enum int SF_PCF5 = 2;

class GenericMaterial: Material
{
    protected GenericMaterialBackend _backend;
    protected FixedPipelineBackend fixedBackend;

    this(Owner o)
    {
        super(o);

        setInput("diffuse", Color4f(0.8f, 0.8f, 0.8f, 1.0f));
        setInput("specular", Color4f(1.0f, 1.0f, 1.0f, 1.0f));
        setInput("shadeless", false);
        setInput("emit", Color4f(0.0f, 0.0f, 0.0f, 1.0f));
        setInput("alpha", 1.0f);
        setInput("brightness", 1.0f);
        setInput("roughness", 0.5f);
        setInput("metallic", 0.0f);
        setInput("normal", Vector3f(0.0f, 0.0f, 1.0f));
        setInput("height", 0.0f);
        setInput("parallaxEnabled", false);
        setInput("parallaxScale", 0.03f);
        setInput("parallaxBias", -0.01f);
        setInput("shadowsEnabled", true);
        setInput("shadowFilter", SF_None);
        setInput("fogEnabled", true);

        fixedBackend = New!FixedPipelineBackend(this);
        _backend = fixedBackend;
    }

    GenericMaterialBackend backend()
    {
        return _backend;
    }

    void backend(GenericMaterialBackend b)
    {
        _backend = b;
    }

    override void bind(RenderingContext* rc)
    {
        if (_backend)
            _backend.bind(this, rc);
    }

    override void unbind()
    {
        if (_backend)
            _backend.unbind(this);
    }
}
