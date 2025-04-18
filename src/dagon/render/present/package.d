/*
Copyright (c) 2019-2024 Timur Gafarov

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

module dagon.render.present;

import dlib.core.memory;
import dlib.core.ownership;

import dagon.core.event;
import dagon.core.time;
import dagon.core.bindings;
import dagon.resource.scene;
import dagon.render.renderer;
import dagon.render.pass;
import dagon.render.framebuffer;
import dagon.render.present.presentpass;

class PresentRenderer: Renderer
{
    Framebuffer _inputBuffer;
    PresentPass passPresent;

    this(EventManager eventManager, Framebuffer inputBuffer, Owner owner)
    {
        super(eventManager, owner);

        this._inputBuffer = inputBuffer;
        passPresent = New!PresentPass(pipeline);
        passPresent.view = view;
        passPresent.inputBuffer = inputBuffer;
    }
    
    void inputBuffer(Framebuffer b)
    {
        _inputBuffer = b;
        passPresent.inputBuffer = b;
    }

    Framebuffer inputBuffer()
    {
        return _inputBuffer;
    }
    
    override void render()
    {
        super.render();
    }
}
