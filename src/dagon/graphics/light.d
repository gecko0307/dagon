/*
Copyright (c) 2017-2025 Timur Gafarov

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
 * Defines the core lighting system of the engine.
 *
 * The `dagon.graphics.light` module provides the `Light` class,
 * which represents a light source in the scene and supports
 * various types (area sphere, area tube, sun, spot). Lights can
 * cast shadows, participate in volumetric scattering, and have
 * configurable color, energy, attenuation, and other parameters.
 *
 * Copyright: Timur Gafarov 2017-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.graphics.light;

import std.stdio;
import std.math;
import std.conv;
import std.random;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.quaternion;
import dlib.container.array;
import dlib.image.color;

import dagon.core.bindings;
import dagon.graphics.state;
import dagon.graphics.entity;
import dagon.graphics.shadowmap;
import dagon.graphics.csm;
import dagon.graphics.dpsm;

/**
 * Supported light types.
 */
enum LightType
{
    /// Spherical area light.
    AreaSphere = 1,

    /// Tubular area light.
    AreaTube = 2,

    /// Directional light.
    Sun = 3,

    /// Spot light.
    Spot = 4
}

/**
 * Represents a light source in the scene.
 *
 * Description:
 * Lights can be area lights, sun (directional), or spotlights. They support
 * shadow mapping, volumetric scattering, and various physical parameters.
 */
class Light: Entity
{
    /// If `true`, the light is currently shining (active).
    bool shining;

    /// The color of the light.
    Color4f color;

    /**
     * Attenuation radius of the light volume.
     * In a deferred rendering pipeline, this radius defines a sphere
     * that encompasses the area where the light's effect is visible.
     */
    float volumeRadius;

    /// Light radius (for area/tube lights).
    float radius;

    /// Light length (for tube lights).
    float length;

    /// Light energy (intensity multiplier).
    float energy;

    /// Outer cutoff angle for spotlights (degrees).
    float spotOuterCutoff;

    /// Inner cutoff angle for spotlights (degrees).
    float spotInnerCutoff;

    /// The type of this light.
    LightType type;

    /**
     * If `true`, enables shadow casting for this light.
     * Shadows are supported only for `Sun` lights at the moment.
     */
    bool shadowEnabled;

    /**
     * If `true`, enables volumetric scattering for this light.
     * Volumetric scattering is supported only for `Sun` lights at the moment.
     */
    bool scatteringEnabled;

    /// Volumetric scattering intensity.
    float scattering;

    /// Medium density for volumetric scattering.
    float mediumDensity;

    /// Number of samples for scattering calculations.
    uint scatteringSamples;

    /**
     * Maximum random step offset used for Monte-Carlo sampling
     * when using shadow in volumetric scattering.
     */
    float scatteringMaxRandomStepOffset;

    /// If `true`, scattering uses shadow information.
    bool scatteringUseShadow;

    /// The shadow map object for this light (if enabled).
    protected ShadowMap _shadowMap;

    /// Diffuse lighting factor.
    float diffuse;

    /// Specular lighting factor.
    float specular;

    /**
     * Constructs a new light with default parameters.
     *
     * Params:
     *   owner = The owner object.
     */
    this(Owner owner)
    {
        super(owner);
        visible = false;
        castShadow = false;
        shining = true;
        length = 1.0f;
        color = Color4f(1.0f, 1.0f, 1.0f, 1.0f);
        volumeRadius = 1.0f;
        radius = 0.0f;
        energy = 1.0f;
        spotOuterCutoff = 30.0f;
        spotInnerCutoff = 15.0f;
        type = LightType.AreaSphere;
        shadowEnabled = false;
        scatteringEnabled = false;
        scattering = 0.05f;
        mediumDensity = 0.5f;
        scatteringSamples = 20;
        scatteringMaxRandomStepOffset = 0.2f;
        scatteringUseShadow = false;
        diffuse = 1.0f;
        specular = 1.0f;
    }
    
    /**
     * Returns the shadow map for this light, creating it if necessary.
     *
     * Returns:
     *   The shadow map object, or `null` if shadows are not enabled.
     */
    ShadowMap shadowMap()
    {
        if (_shadowMap is null && shadowEnabled)
        {
            if (type == LightType.Sun)
                _shadowMap = New!CascadedShadowMap(this, this);
            else
                _shadowMap = New!DualParaboloidShadowMap(this, this);
        }
        
        return _shadowMap;
    }
}
