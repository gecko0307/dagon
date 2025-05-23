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

/**
 * The render pipeline abstraction for Dagon's rendering system.
 *
 * Description:
 * The `dagon.render.pipeline` module defines the `RenderPipeline` class,
 * which manages a sequence of render passes. The pipeline coordinates
 * the update and rendering of all registered render passes.
 *
 * Copyright: Timur Gafarov 2019-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.render.pipeline;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.container.array;
import dlib.math.matrix;

import dagon.core.bindings;
import dagon.core.event;
import dagon.core.time;
import dagon.graphics.entity;
import dagon.graphics.environment;
import dagon.render.pass;

__gshared GLuint currentFramebuffer = 0;

/**
 * Binds the given OpenGL framebuffer if it is not already bound.
 *
 * Params:
 *   fb = The OpenGL framebuffer object to bind.
 */
void bindFramebuffer(GLuint fb)
{
    if (fb != currentFramebuffer)
    {
        currentFramebuffer = fb;
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, fb);
    }
}

/**
 * Render pipeline for managing a sequence of render passes.
 */
class RenderPipeline: EventListener
{
    /// Array of render passes in the pipeline.
    Array!RenderPass passes;

    /// The rendering environment (fog, IBL, etc.).
    Environment environment;

    /// Enables debug rendering features.
    bool debugMode = false;

    /**
     * Constructs a render pipeline.
     *
     * Params:
     *   eventManager = The event manager for event processing.
     *   owner        = Owner object.
     */
    this(EventManager eventManager, Owner owner)
    {
        super(eventManager, owner);
    }

    /// Destructor. Frees all render passes.
    ~this()
    {
        passes.free();
    }

    /**
     * Adds a render pass to the pipeline.
     *
     * Params:
     *   pass = The render pass to add.
     */
    void addPass(RenderPass pass)
    {
        passes.append(pass);
    }

    /**
     * Removes a render pass from the pipeline.
     *
     * Params:
     *   pass = The render pass to remove.
     */
    void removePass(RenderPass pass)
    {
        passes.removeFirst(pass);
    }

    /**
     * Updates all active render passes in the pipeline.
     *
     * Params:
     *   t = Frame timing information.
     */
    void update(Time t)
    {
        processEvents();

        foreach(pass; passes.data)
        {
            if (pass.active)
                pass.update(t);
        }
    }

    /// Renders all active render passes in the pipeline.
    void render()
    {
        foreach(pass; passes.data)
        {
            if (pass.active)
                pass.render();
        }
    }
}
