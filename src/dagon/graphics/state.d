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

module dagon.graphics.state;

import dlib.math.vector;
import dlib.math.matrix;
import dlib.geometry.frustum;
import dlib.image.color;

import dagon.core.bindings;
import dagon.core.time;
import dagon.graphics.material;
import dagon.graphics.shader;
import dagon.graphics.environment;
import dagon.graphics.light;
import dagon.graphics.pose;

struct GraphicsState
{
    Color4f debugColor;
    bool debugMode;
    
    int layer;
    float blurMask;
    float gbufferMask;

    Vector2f resolution;
    float zNear;
    float zFar;

    Vector3f cameraPosition;

    Matrix4x4f modelMatrix;
    Matrix4x4f invModelMatrix;
    Matrix4x4f invViewRotationMatrix;

    Matrix4x4f viewMatrix;
    Matrix4x4f invViewMatrix;

    Matrix4x4f projectionMatrix;
    Matrix4x4f invProjectionMatrix;

    Matrix4x4f modelViewMatrix;
    Matrix4x4f normalMatrix;
    
    Matrix4x4f prevViewMatrix;
    Matrix4x4f prevModelViewMatrix;
    
    Frustum frustum;

    Material material;
    Shader shader;
    Environment environment;
    Light light;
    Pose pose;

    bool colorMask;
    bool depthMask;

    bool culling;
    
    float opacity;

    GLuint colorTexture;
    GLuint depthTexture;
    GLuint normalTexture;
    GLuint pbrTexture;
    GLuint occlusionTexture;
    GLuint emissionTexture;
    GLuint texcoordTexture; // used only for terrains
    
    Time time;
    
    float localTime; // 0.0 .. 1.0

    void reset()
    {
        debugColor = Color4f(0.0f, 0.0f, 0.0f, 0.0f);
        debugMode = false;

        layer = 1;
        blurMask = 1.0f;
        gbufferMask = 1.0f;

        resolution = Vector2f(0.0f, 0.0f);
        zNear = 0.0f;
        zFar = 0.0f;

        cameraPosition = Vector3f(0.0f, 0.0f, 0.0f);

        modelMatrix = Matrix4x4f.identity;
        invModelMatrix = Matrix4x4f.identity;

        viewMatrix = Matrix4x4f.identity;
        invViewMatrix = Matrix4x4f.identity;
        invViewRotationMatrix = Matrix4x4f.identity;

        projectionMatrix = Matrix4x4f.identity;
        invProjectionMatrix = Matrix4x4f.identity;

        modelViewMatrix = Matrix4x4f.identity;
        normalMatrix = Matrix4x4f.identity;
        
        prevViewMatrix = Matrix4x4f.identity;
        prevModelViewMatrix = Matrix4x4f.identity;

        material = null;
        shader = null;
        environment = null;
        light = null;
        pose = null;

        colorMask = true;
        depthMask = true;

        culling = true;
        
        opacity = 1.0f;

        colorTexture = 0;
        depthTexture = 0;
        normalTexture = 0;
        pbrTexture = 0;
        occlusionTexture = 0;
        texcoordTexture = 0;
        
        time = Time(0.0, 0.0);
        localTime = 0.0f;
    }
}
