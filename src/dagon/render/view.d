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
 * Provides the `RenderView` abstraction for Dagon's rendering system.
 *
 * The `dagon.render.view` module defines the `RenderView` class, which
 * encapsulates camera, viewport, and projection settings for a render pass.
 * The class supports perspective and orthographic projections, viewport
 * resizing, and provides access to view, projection, and camera matrices.
 * This abstraction is used for rendering scenes.
 *
 * Copyright: Timur Gafarov 2019-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.render.view;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.utils;

import dagon.core.bindings;
import dagon.graphics.camera;

import dagon.render.pipeline;

/// Projection types for RenderView.
enum: uint
{
    /// Perspective projection.
    Perspective = 0,

    /// Orthographic projection (world units).
    Ortho = 1,

    /// Orthographic projection (screen units).
    OrthoScreen = 2
}

/**
 * Encapsulates camera, viewport, and projection settings for a render pass.
 */
class RenderView: Owner
{
    /// The camera used for rendering.
    Camera camera;

    /// Viewport position X coordinate.
    uint x;

    /// Viewport position Y coordinate.
    uint y;

    /// Viewport width in pixels.
    uint width;

    /// Viewport height in pixels.
    uint height;

    /// Aspect ratio of the viewport.
    float aspectRatio;

    /// Projection type (Perspective, Ortho, OrthoScreen).
    uint projection = Perspective;

    /// Scale for orthographic projection.
    float orthoScale = 1.0f;

    /// Render pipeline used for this view.
    RenderPipeline pipeline;
    
    /**
     * Constructs a render view with the given viewport and owner.
     *
     * Params:
     *   x       = Viewport position X coordinate (pixels).
     *   y       = Viewport position Y coordinate (pixels).
     *   width   = Viewport width (pixels).
     *   height  = Viewport height (pixels).
     *   owner   = Owner object.
     */
    this(uint x, uint y, uint width, uint height, Owner owner)
    {
        super(owner);
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        aspectRatio = cast(float)width / cast(float)height;
    }
    
    /// Destructor.
    ~this()
    {
    }
    
    /// Returns the view matrix for the current camera.
    Matrix4x4f viewMatrix()
    {
        if (camera)
            return camera.viewMatrix();
        else
            return Matrix4x4f.identity;
    }
    
    /// Returns the inverse view matrix for the current camera.
    Matrix4x4f invViewMatrix()
    {
        if (camera)
            return camera.invViewMatrix();
        else
            return Matrix4x4f.identity;
    }
    
    /// Returns the projection matrix for the current projection type.
    Matrix4x4f projectionMatrix()
    {
        float fov = 60.0f;
        float zNear = 0.01f;
        float zFar = 1000.0f;
        if (camera)
        {
            fov = camera.fov;
            zNear = camera.zNear;
            zFar = camera.zFar;
        }
        
        if (projection == Perspective)
            return perspectiveMatrix(fov, aspectRatio, zNear, zFar);
        else if (projection == OrthoScreen)
            return orthoMatrix(0.0f, width, height, 0.0f, 0.0f, zFar);
        else if (projection == Ortho)
            return orthoMatrix(-orthoScale * aspectRatio, orthoScale * aspectRatio, -orthoScale, orthoScale, -zFar * 0.5f, zFar * 0.5f);
        else
            return Matrix4x4f.identity;
    }
    
    /// Returns the near clipping plane distance.
    float zNear()
    {
        if (camera)
            return camera.zNear;
        else
            return 0.01f;
    }
    
    /// Returns the far clipping plane distance.
    float zFar()
    {
        if (camera)
            return camera.zFar;
        else
            return 1000.0f;
    }
    
    /// Returns the absolute camera position in world space.
    Vector3f cameraPosition()
    {
        if (camera)
            return camera.positionAbsolute;
        else
            return Vector3f(0.0f, 0.0f, 0.0f);
    }
    
    /// Sets the viewport position.
    void setPosition(uint x, uint y)
    {
        this.x = x;
        this.y = y;
    }
    
    /// Resizes the viewport and updates the aspect ratio.
    void resize(uint width, uint height)
    {
        this.width = width;
        this.height = height;
        aspectRatio = cast(float)width / cast(float)height;
    }

    // TODO: pixel to ray
    // TODO: point to pixel
    // TODO: pixel visible
}
