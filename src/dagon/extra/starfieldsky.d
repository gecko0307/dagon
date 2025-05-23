/*
Copyright (c) 2024-2025 Timur Gafarov

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

module dagon.extra.starfieldsky;

import std.stdio;
import std.math;
import std.conv;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.image.color;
import dlib.text.str;

import dagon.core.bindings;
import dagon.graphics.state;
import dagon.graphics.shader;

class StarfieldSkyShader: Shader
{
   protected:
    String vs, fs;
    
    ShaderParameter!Matrix4x4f modelViewMatrix;
    ShaderParameter!Matrix4x4f projectionMatrix;
    ShaderParameter!Matrix4x4f normalMatrix;
    ShaderParameter!Matrix4x4f viewMatrix;
    ShaderParameter!Matrix4x4f invViewMatrix;
    ShaderParameter!Matrix4x4f prevModelViewMatrix;
    
    ShaderParameter!float gbufferMask;
    ShaderParameter!float blurMask;
    
    ShaderParameter!Color4f ssSpaceColor;
    ShaderParameter!float ssStarsThreshold;
    ShaderParameter!float ssStarsBrightness;
    ShaderParameter!float ssStarsTwinkleSpeed;
    
    ShaderParameter!float localTime;
    
    ShaderParameter!Vector3f sunDirection;
    ShaderParameter!Color4f sunColor;
    
   public:
    Color4f spaceColor = Color4f(0.0f, 0.0f, 0.0f, 1.0f);
    float starsThreshold = 0.995f;
    float starsBrightness = 8.0f;
    float starsTwinkleSpeed = 1.0f;
    
    Vector3f defaultSunDirection = Vector3f(-1.0f, -1.0f, -1.0f).normalized;
    Color4f defaultSunColor = Color4f(1.0f, 1.0f, 1.0f, 1.0f);

    this(Owner owner)
    {
        vs = Shader.load("data/__internal/shaders/StarfieldSky/StarfieldSky.vert.glsl");
        fs = Shader.load("data/__internal/shaders/StarfieldSky/StarfieldSky.frag.glsl");

        auto myProgram = New!ShaderProgram(vs, fs, this);
        super(myProgram, owner);
        
        modelViewMatrix = createParameter!Matrix4x4f("modelViewMatrix");
        projectionMatrix = createParameter!Matrix4x4f("projectionMatrix");
        normalMatrix = createParameter!Matrix4x4f("normalMatrix");
        viewMatrix = createParameter!Matrix4x4f("viewMatrix");
        invViewMatrix = createParameter!Matrix4x4f("invViewMatrix");
        prevModelViewMatrix = createParameter!Matrix4x4f("prevModelViewMatrix");
        
        gbufferMask = createParameter!float("gbufferMask");
        blurMask = createParameter!float("blurMask");
        
        ssSpaceColor = createParameter!Color4f("spaceColor");
        ssStarsThreshold = createParameter!float("starsThreshold");
        ssStarsBrightness = createParameter!float("starsBrightness");
        ssStarsTwinkleSpeed = createParameter!float("starsTwinkleSpeed");
        
        localTime = createParameter!float("localTime");
        
        sunDirection = createParameter!Vector3f("sunDirection");
        sunColor = createParameter!Color4f("sunColor");
    }

    ~this()
    {
        vs.free();
        fs.free();
    }

    override void bindParameters(GraphicsState* state)
    {
        modelViewMatrix = &state.modelViewMatrix;
        projectionMatrix = &state.projectionMatrix;
        normalMatrix = &state.normalMatrix;
        viewMatrix = &state.viewMatrix;
        invViewMatrix = &state.invViewMatrix;
        prevModelViewMatrix = &state.prevModelViewMatrix;
        
        gbufferMask = state.gbufferMask;
        blurMask = state.blurMask;
        
        ssSpaceColor = spaceColor;
        ssStarsThreshold = starsThreshold;
        ssStarsBrightness = starsBrightness;
        ssStarsTwinkleSpeed = starsTwinkleSpeed;
        
        localTime = state.localTime;
        
        if (state.material.sun)
        {
            sunDirection = state.material.sun.directionAbsolute;
            sunColor = state.material.sun.color;
        }
        else if (state.environment.sun)
        {
            sunDirection = state.environment.sun.directionAbsolute;
            sunColor = state.environment.sun.color;
        }
        else
        {
            sunDirection = -defaultSunDirection;
            sunColor = defaultSunColor;
        }
        
        super.bindParameters(state);
    }

    override void unbindParameters(GraphicsState* state)
    {
        super.unbindParameters(state);
    }
}
