/*
Copyright (c) 2019-2025 Timur Gafarov

Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dagon.render.postproc.shaders.brightpass;

import std.stdio;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.image.color;
import dlib.text.str;

import dagon.core.bindings;
import dagon.graphics.shader;
import dagon.graphics.state;

class BrightPassShader: Shader
{
   protected:
    String vs, fs;

    ShaderParameter!Vector2f viewSize;
    ShaderParameter!int brightpassEnabled;
    ShaderParameter!float brightpassLuminanceThreshold;
    ShaderParameter!int colorBuffer;

   public:
    bool enabled = true;
    float luminanceThreshold = 1.0f;
    
    this(Owner owner)
    {
        vs = Shader.load("data/__internal/shaders/BrightPass/BrightPass.vert.glsl");
        fs = Shader.load("data/__internal/shaders/BrightPass/BrightPass.frag.glsl");

        auto myProgram = New!ShaderProgram(vs, fs, this);
        super(myProgram, owner);
        
        viewSize = createParameter!Vector2f("viewSize");
        brightpassEnabled = createParameter!int("enabled");
        brightpassLuminanceThreshold = createParameter!float("luminanceThreshold");
        colorBuffer = createParameter!int("colorBuffer");
    }

    ~this()
    {
        vs.free();
        fs.free();
    }

    override void bindParameters(GraphicsState* state)
    {
        viewSize = state.resolution;
        brightpassEnabled = enabled;
        brightpassLuminanceThreshold = luminanceThreshold;

        // Texture 0 - color buffer
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, state.colorTexture);
        colorBuffer = 0;

        glActiveTexture(GL_TEXTURE0);

        super.bindParameters(state);
    }

    override void unbindParameters(GraphicsState* state)
    {
        super.unbindParameters(state);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, 0);

        glActiveTexture(GL_TEXTURE0);
    }
}
