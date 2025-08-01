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

module dagon.render.deferred.passes.shadow;

import std.stdio;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;

import dagon.core.bindings;
import dagon.core.time;
import dagon.graphics.entity;
import dagon.graphics.camera;
import dagon.graphics.light;
import dagon.graphics.dpsm;
import dagon.graphics.csm;
import dagon.graphics.shader;
import dagon.render.pipeline;
import dagon.render.pass;
import dagon.render.deferred.shaders.csm;
import dagon.render.deferred.shaders.dpsm;

class PassShadow: RenderPass
{
    EntityGroup lightGroup;
    CascadedShadowShader csmShader;
    DualParaboloidShadowShader dpsmShader;
    Camera camera;

    this(RenderPipeline pipeline)
    {
        super(pipeline);
        csmShader = New!CascadedShadowShader(this);
        dpsmShader = New!DualParaboloidShadowShader(this);
        state.colorMask = false;
        state.culling = false;
    }

    override void update(Time t)
    {
        super.update(t);

        if (lightGroup)
        {
            foreach(entity; lightGroup)
            {
                Light light = cast(Light)entity;
                if (light && camera)
                {
                    if (light.shadowEnabled)
                    {
                        CascadedShadowMap csm = cast(CascadedShadowMap)light.shadowMap;
                        if (csm)
                            csm.camera = camera;
                        
                        light.shadowMap.update(t);
                    }
                }
            }
        }
    }

    override void render()
    {
        if (group && lightGroup)
        {
            foreach(entity; lightGroup)
            {
                Light light = cast(Light)entity;
                if (light)
                {
                    if (light.shadowEnabled)
                    {
                        state.light = light;
                        CascadedShadowMap csm = cast(CascadedShadowMap)light.shadowMap;
                        DualParaboloidShadowMap dpsm = cast(DualParaboloidShadowMap)light.shadowMap;
                        
                        if (light.type == LightType.Sun && csm)
                            renderCSM(csm);
                        else if (dpsm)
                            renderDPSM(dpsm);
                    }
                }
            }
        }
    }

    void renderEntities(Shader shader)
    {
        foreach(entity; group)
        if (entity.visible && entity.castShadow)
        {
            state.modelMatrix = entity.absoluteTransformation;
            state.modelViewMatrix = state.viewMatrix * state.modelMatrix;
            state.normalMatrix = state.modelViewMatrix.inverse.transposed;
            state.shader = shader;
            state.opacity = 1.0f;
            state.environment = pipeline.environment;
            state.pose = entity.pose;

            if (entity.material)
                entity.material.bind(&state);
            else
                defaultMaterial.bind(&state);

            shader.bindParameters(&state);

            if (entity.drawable)
                entity.drawable.render(&state);

            shader.unbindParameters(&state);

            if (entity.material)
                entity.material.unbind(&state);
            else
                defaultMaterial.unbind(&state);
        }
    }

    void renderCSM(CascadedShadowMap csm)
    {
        state.resolution = Vector2f(csm.resolution, csm.resolution);
        state.zNear = csm.area[0].zStart;
        state.zFar = csm.area[0].zEnd;

        state.cameraPosition = csm.area[0].position;

        glScissor(0, 0, csm.resolution, csm.resolution);
        glViewport(0, 0, csm.resolution, csm.resolution);

        csmShader.bind();

        glPolygonOffset(3.0, 0.0);
        glDisable(GL_CULL_FACE);

        state.viewMatrix = csm.area[0].viewMatrix;
        state.invViewMatrix = csm.area[0].invViewMatrix;
        state.projectionMatrix = csm.area[0].projectionMatrix;
        state.invProjectionMatrix = csm.area[0].projectionMatrix.inverse;
        bindFramebuffer(csm.framebuffer1);
        glClear(GL_DEPTH_BUFFER_BIT);
        renderEntities(csmShader);

        state.viewMatrix = csm.area[1].viewMatrix;
        state.invViewMatrix = csm.area[1].invViewMatrix;
        state.projectionMatrix = csm.area[1].projectionMatrix;
        state.invProjectionMatrix = csm.area[1].projectionMatrix.inverse;
        bindFramebuffer(csm.framebuffer2);
        glClear(GL_DEPTH_BUFFER_BIT);
        renderEntities(csmShader);

        state.viewMatrix = csm.area[2].viewMatrix;
        state.invViewMatrix = csm.area[2].invViewMatrix;
        state.projectionMatrix = csm.area[2].projectionMatrix;
        state.invProjectionMatrix = csm.area[2].projectionMatrix.inverse;
        bindFramebuffer(csm.framebuffer3);
        glClear(GL_DEPTH_BUFFER_BIT);
        renderEntities(csmShader);

        glEnable(GL_CULL_FACE);
        glPolygonOffset(0.0, 0.0);

        csmShader.unbind();
    }
    
    void renderDPSM(DualParaboloidShadowMap dpsm)
    {
        state.resolution = Vector2f(dpsm.resolution, dpsm.resolution);
        state.light = dpsm.light;
        
        glScissor(0, 0, dpsm.resolution, dpsm.resolution);
        glViewport(0, 0, dpsm.resolution, dpsm.resolution);
        
        dpsmShader.bind();
        
        glPolygonOffset(3.0, 0.0);
        glDisable(GL_CULL_FACE);
        
        dpsmShader.paraboloidDirection = 1.0f;
        bindFramebuffer(dpsm.framebuffer1);
        glClear(GL_DEPTH_BUFFER_BIT);
        renderEntities(dpsmShader);
        
        dpsmShader.paraboloidDirection = -1.0f;
        bindFramebuffer(dpsm.framebuffer2);
        glClear(GL_DEPTH_BUFFER_BIT);
        renderEntities(dpsmShader);
        
        glEnable(GL_CULL_FACE);
        glPolygonOffset(0.0, 0.0);
        
        dpsmShader.unbind();
    }
}
