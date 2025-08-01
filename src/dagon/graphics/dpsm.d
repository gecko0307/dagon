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
module dagon.graphics.dpsm;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.image.color;

import dagon.core.logger;
import dagon.core.bindings;
import dagon.core.time;
import dagon.graphics.shadowmap;
import dagon.graphics.light;

class DualParaboloidShadowMap: ShadowMap
{
    // TODO: store in DeferredRenderer
    uint shadowMapResolution = 1024;
    
    GLuint depthTextureArray;
    
    GLuint framebuffer1;
    GLuint framebuffer2;
    
    this(Light light, Owner owner)
    {
        super(owner);
        this.light = light;
        resize(shadowMapResolution);
    }
    
    ~this()
    {
        releaseBuffers();
    }
    
    override void resize(uint res)
    {
        this.resolution = res;
        
        releaseBuffers();
        
        glActiveTexture(GL_TEXTURE0);
        
        glGenTextures(1, &depthTextureArray);
        glBindTexture(GL_TEXTURE_2D_ARRAY, depthTextureArray);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
        glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_DEPTH_COMPONENT24, resolution, resolution, 2, 0, GL_DEPTH_COMPONENT, GL_FLOAT, null);
        
        glBindTexture(GL_TEXTURE_2D_ARRAY, 0);
        
        glGenFramebuffers(1, &framebuffer1);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer1);
        glDrawBuffer(GL_NONE);
        glReadBuffer(GL_NONE);
        glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTextureArray, 0, 0);
        
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (status != GL_FRAMEBUFFER_COMPLETE) {
            logError("Framebuffer ", framebuffer1, " incomplete: ", status);
        }
        
        glGenFramebuffers(1, &framebuffer2);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer2);
        glDrawBuffer(GL_NONE);
        glReadBuffer(GL_NONE);
        glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTextureArray, 0, 1);
        
        status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (status != GL_FRAMEBUFFER_COMPLETE) {
            logError("Framebuffer ", framebuffer2, " incomplete: ", status);
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
    
    void releaseBuffers()
    {
        if (glIsFramebuffer(framebuffer1))
            glDeleteFramebuffers(1, &framebuffer1);
        
        if (glIsFramebuffer(framebuffer2))
            glDeleteFramebuffers(1, &framebuffer2);
        
        if (glIsTexture(depthTextureArray))
            glDeleteTextures(1, &depthTextureArray);
    }
    
    override void update(Time t)
    {
    }
}
