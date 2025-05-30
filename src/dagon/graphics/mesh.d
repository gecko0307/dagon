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
 * Defines mesh data structure and utilities.
 *
 * Description:
 * The `dagon.graphics.mesh` module provides the `Mesh` class for storing
 * and rendering 3D geometry (indexed triangle mesh). The module also defines
 * the `VertexAttrib` enumeration for standard attribute locations used in the engine,
 * and the `TriangleSet` interface for triangle iteration.
 * Meshes support bounding box calculation, normal generation, and OpenGL VAO/VBO management.
 *
 * Copyright: Timur Gafarov 2017-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.graphics.mesh;

import std.math;
import std.algorithm;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.geometry.triangle;
import dlib.math.vector;
import dlib.geometry.aabb;

import dagon.core.bindings;
import dagon.graphics.drawable;

/**
 * Enumerates vertex attribute locations for mesh data.
 */
enum VertexAttrib
{
    Vertices = 0,
    Normals = 1,
    Texcoords = 2,
    Bones = 3,
    Weights = 4
}

/**
 * Interface for objects that provide access to a set of triangles.
 */
interface TriangleSet
{
    /**
     * Iterates over all triangles in the set.
     *
     * Params:
     *   dg = Delegate to call for each triangle.
     * Returns:
     *   0 if iteration completed, or the value returned by the delegate if nonzero.
     */
    int opApply(scope int delegate(Triangle t) dg);
}

/**
 * Represents a 3D mesh with vertex and index data,
 * supporting rendering and triangle iteration.
 *
 * The `Mesh` class stores vertex positions, normals,
 * texture coordinates, and triangle indices.
 * It supports bounding box calculation, normal generation,
 * OpenGL VAO/VBO management, and implements the `Drawable`
 * and `TriangleSet` interfaces.
 */
class Mesh: Owner, Drawable, TriangleSet
{
    /// True if mesh data is ready for rendering.
    bool dataReady = false;

    /// True if OpenGL buffers are prepared and mesh can be rendered.
    bool canRender = false;
    
    // TODO: make these DynamicArrays:

    /// Array of vertex positions.
    Vector3f[] vertices;

    /// Array of vertex normals.
    Vector3f[] normals;

    /// Array of texture coordinates.
    Vector2f[] texcoords;

    /// Array of triangle indices (each element is a uint[3]).
    uint[3][] indices;
    
    /// Axis-aligned bounding box for the mesh.
    AABB boundingBox;
    
    /// OpenGL vertex array object.
    GLuint vao = 0;

    /// OpenGL vertex buffer object for positions.
    GLuint vbo = 0;

    /// OpenGL vertex buffer object for normals.
    GLuint nbo = 0;

    /// OpenGL vertex buffer object for texture coordinates.
    GLuint tbo = 0;

    /// OpenGL element array object for indices.
    GLuint eao = 0;
    
    /**
     * Constructs a mesh with the given owner.
     *
     * Params:
     *   owner = The owner object.
     */
    this(Owner owner)
    {
        super(owner);
    }
    
    /// Destructor. Releases all mesh data and OpenGL resources.
    ~this()
    {
        if (vertices.length) Delete(vertices);
        if (normals.length) Delete(normals);
        if (texcoords.length) Delete(texcoords);
        if (indices.length) Delete(indices);
        
        if (canRender)
        {
            glDeleteVertexArrays(1, &vao);
            glDeleteBuffers(1, &vbo);
            glDeleteBuffers(1, &nbo);
            glDeleteBuffers(1, &tbo);
            glDeleteBuffers(1, &eao);
        }
    }
    
    /**
     * Calculates the axis-aligned bounding box for the mesh.
     *
     * Sets the `boundingBox` member based on the furthest vertex extents.
     */
    void calcBoundingBox()
    {
        float maxDimension = 0.0f;
        
        foreach(v; vertices)
        {
            float ax = abs(v.x);
            float ay = abs(v.y);
            float az = abs(v.z);
            if (ax > maxDimension) maxDimension = ax;
            if (ay > maxDimension) maxDimension = ay;
            if (az > maxDimension) maxDimension = az;
        }
        
        Vector3f furthest = Vector3f(maxDimension, maxDimension, maxDimension);

        boundingBox = boxFromMinMaxPoints(-furthest, furthest);
    }
    
    /**
     * Returns the triangle at the specified face index.
     *
     * Params:
     *   faceIndex = The index of the triangle to retrieve.
     * Returns:
     *   The triangle at the given index.
     */
    Triangle getTriangle(size_t faceIndex)
    {
        uint[3] f = indices[faceIndex];
        Triangle tri;
        tri.v[0] = vertices[f[0]];
        tri.v[1] = vertices[f[1]];
        tri.v[2] = vertices[f[2]];
        tri.n[0] = normals[f[0]];
        tri.n[1] = normals[f[1]];
        tri.n[2] = normals[f[2]];
        tri.t1[0] = texcoords[f[0]];
        tri.t1[1] = texcoords[f[1]];
        tri.t1[2] = texcoords[f[2]];
        tri.normal = (tri.n[0] + tri.n[1] + tri.n[2]) / 3.0f;
        return tri;
    }
    
    /**
     * Iterates over all triangles in the mesh.
     *
     * Params:
     *   dg = Delegate to call for each triangle.
     * Returns:
     *   0 if iteration completed, or the value returned by the delegate if nonzero.
     */
    int opApply(scope int delegate(Triangle t) dg)
    {
        int result = 0;

        foreach(i, ref f; indices)
        {
            Triangle tri = getTriangle(i);
            result = dg(tri);
            if (result)
                break;
        }

        return result;
    }
    
    /**
     * Generates smooth vertex normals for the mesh based on triangle geometry.
     * Overwrites the `normals` array with computed normals.
     */
    void generateNormals()
    {
        if (normals.length == 0)
            return;
    
        normals[] = Vector3f(0.0f, 0.0f, 0.0f);
    
        foreach(i, ref f; indices)
        {
            Vector3f v0 = vertices[f[0]];
            Vector3f v1 = vertices[f[1]];
            Vector3f v2 = vertices[f[2]];
            
            Vector3f p = cross(v1 - v0, v2 - v0);
            
            normals[f[0]] += p;
            normals[f[1]] += p;
            normals[f[2]] += p;
        }
        
        foreach(i, n; normals)
        {
            normals[i] = n.normalized;
        }
    }
    
    /**
     * Prepares OpenGL VAO and VBOs for rendering the mesh.
     * Uploads vertex, normal, texcoord, and index data to the GPU.
     * Sets up attribute pointers and enables rendering.
     */
    void prepareVAO()
    {
        if (!dataReady)
            return;

        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * float.sizeof * 3, vertices.ptr, GL_STATIC_DRAW); 

        glGenBuffers(1, &nbo);
        glBindBuffer(GL_ARRAY_BUFFER, nbo);
        glBufferData(GL_ARRAY_BUFFER, normals.length * float.sizeof * 3, normals.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &tbo);
        glBindBuffer(GL_ARRAY_BUFFER, tbo);
        glBufferData(GL_ARRAY_BUFFER, texcoords.length * float.sizeof * 2, texcoords.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &eao);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eao);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * uint.sizeof * 3, indices.ptr, GL_STATIC_DRAW);

        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eao);
    
        glEnableVertexAttribArray(VertexAttrib.Vertices);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glVertexAttribPointer(VertexAttrib.Vertices, 3, GL_FLOAT, GL_FALSE, 0, null);
    
        glEnableVertexAttribArray(VertexAttrib.Normals);
        glBindBuffer(GL_ARRAY_BUFFER, nbo);
        glVertexAttribPointer(VertexAttrib.Normals, 3, GL_FLOAT, GL_FALSE, 0, null);
    
        glEnableVertexAttribArray(VertexAttrib.Texcoords);
        glBindBuffer(GL_ARRAY_BUFFER, tbo);
        glVertexAttribPointer(VertexAttrib.Texcoords, 2, GL_FLOAT, GL_FALSE, 0, null);

        glBindVertexArray(0);
        
        canRender = true;
    }
    
    /**
     * Renders the mesh using the provided graphics pipeline state.
     *
     * Params:
     *   state = Pointer to the current graphics pipeline state.
     */
    void render(GraphicsState* state)
    {
        if (canRender)
        {
            glBindVertexArray(vao);
            glDrawElements(GL_TRIANGLES, cast(uint)indices.length * 3, GL_UNSIGNED_INT, cast(void*)0);
            glBindVertexArray(0);
        }
    }
}
