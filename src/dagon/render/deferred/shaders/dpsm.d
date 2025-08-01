/*
Copyright (c) 2025 Timur Gafarov

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

module dagon.render.deferred.shaders.dpsm;

import std.stdio;
import std.math;
import std.algorithm;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.image.color;
import dlib.text.str;

import dagon.core.bindings;
import dagon.graphics.material;
import dagon.graphics.shader;
import dagon.graphics.state;
import dagon.graphics.pose;

class DualParaboloidShadowShader: Shader
{
   protected:
    String vs, fs;
    
    ShaderParameter!Matrix4x4f modelMatrix;
    ShaderParameter!Vector4f lightPosition;
    ShaderParameter!float lightRadius;
    ShaderParameter!float direction;
    
    ShaderParameter!int skinned;
    GLint boneMatricesLocation;
    
   public:
    float paraboloidDirection = 1.0f;
    
    this(Owner owner)
    {
        vs = Shader.load("data/__internal/shaders/DualParaboloidShadow/DualParaboloidShadow.vert.glsl");
        fs = Shader.load("data/__internal/shaders/DualParaboloidShadow/DualParaboloidShadow.frag.glsl");

        auto prog = New!ShaderProgram(vs, fs, this);
        super(prog, owner);
        
        modelMatrix = createParameter!Matrix4x4f("modelMatrix");
        lightPosition = createParameter!Vector4f("lightPosition");
        lightRadius = createParameter!float("lightRadius");
        direction = createParameter!float("direction");
        
        skinned = createParameter!int("skinned");
        // TODO: ShaderParameter specialization for uniform arrays
        boneMatricesLocation = glGetUniformLocation(prog.program, "boneMatrices[0]");
    }

    ~this()
    {
        vs.free();
        fs.free();
    }

    override void bindParameters(GraphicsState* state)
    {
        Material mat = state.material;
        
        modelMatrix = &state.modelMatrix;
        
        Vector4f lightPos = Vector4f(state.light.positionAbsolute);
        lightPos.w = 1.0f;
        lightPosition = lightPos;
        
        lightRadius = max(0.001f, state.light.volumeRadius);
        
        direction = paraboloidDirection;
        
        if (state.pose)
        {
            Pose pose = state.pose;
            if (pose.boneMatrices.length)
            {
                int numBones = cast(int)pose.boneMatrices.length;
                if (numBones > 128)
                    numBones = 128;
                glUniformMatrix4fv(boneMatricesLocation, numBones, GL_FALSE, pose.boneMatrices[0].arrayof.ptr);
                
                skinned = true;
            }
            else
            {
                skinned = false;
            }
        }
        else
        {
            skinned = false;
        }

        super.bindParameters(state);
    }
}
