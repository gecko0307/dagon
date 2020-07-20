//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.nv.nv_44;

import bindbc.loader;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

// NV_command_list
version (GL_NV) enum useNVCommandList = true;
else version (GL_NV_command_list) enum useNVCommandList = true;
else enum useNVCommandList = false;

static if (useNVCommandList) {
    private bool _hasNVCommandList;
    bool hasNVCommandList() { return _hasNVCommandList; }

    enum uint GL_TERMINATE_SEQUENCE_COMMAND_NV = 0x0000;
    enum uint GL_NOP_COMMAND_NV = 0x0001;
    enum uint GL_DRAW_ELEMENTS_COMMAND_NV = 0x0002;
    enum uint GL_DRAW_ARRAYS_COMMAND_NV = 0x0003;
    enum uint GL_DRAW_ELEMENTS_STRIP_COMMAND_NV = 0x0004;
    enum uint GL_DRAW_ARRAYS_STRIP_COMMAND_NV = 0x0005;
    enum uint GL_DRAW_ELEMENTS_INSTANCED_COMMAND_NV = 0x0006;
    enum uint GL_DRAW_ARRAYS_INSTANCED_COMMAND_NV = 0x0007;
    enum uint GL_ELEMENT_ADDRESS_COMMAND_NV = 0x0008;
    enum uint GL_ATTRIBUTE_ADDRESS_COMMAND_NV = 0x0009;
    enum uint GL_UNIFORM_ADDRESS_COMMAND_NV = 0x000a;
    enum uint GL_BLEND_COLOR_COMMAND_NV = 0x000b;
    enum uint GL_STENCIL_REF_COMMAND_NV = 0x000c;
    enum uint GL_LINE_WIDTH_COMMAND_NV = 0x000d;
    enum uint GL_POLYGON_OFFSET_COMMAND_NV = 0x000e;
    enum uint GL_ALPHA_REF_COMMAND_NV = 0x000f;
    enum uint GL_VIEWPORT_COMMAND_NV = 0x0010;
    enum uint GL_SCISSOR_COMMAND_NV = 0x0011;
    enum uint GL_FRONT_FACE_COMMAND_NV = 0x0012;

    extern (System) @nogc nothrow {
        alias pglCreateStatesNV = void function(GLsizei,GLuint*);
        alias pglDeleteStatesNV = void function(GLsizei,const uint*);
        alias pglIsStateNV = GLboolean function(GLuint);
        alias pglStateCaptureNV = void function(GLuint,GLenum mode);
        alias pglGetCommandHeaderNV = GLuint function(GLenum,GLuint);
        alias pglGetStageIndexNV = GLushort function(GLenum);
        alias pglDrawCommandsNV = void function(GLenum,GLuint,const GLintptr*,const GLsizei*,GLuint);
        alias pglDrawCommandsAddressNV = void function(GLenum,const GLuint64*,const GLsizei*,GLuint);
        alias pglDrawCommandsStatesNV = void function(GLuint,const GLintptr*,const GLsizei*,const GLuint*,const GLuint*,GLuint);
        alias pglDrawCommandsStatesAddressNV = void function(const GLuint64*,const GLsizei*,const GLuint*,const GLuint*,GLuint);
        alias pglCreateCommandListsNV = void function(GLsizei,GLuint*);
        alias pglDeleteCommandListsNV = void function(GLsizei,const GLuint*);
        alias pglIsCommandListNV = GLboolean function(GLuint);
        alias pglListDrawCommandsStatesClientNV = void function(GLuint,GLuint,const GLvoid**,const GLsizei*,const GLuint*,const GLuint*,GLuint);
        alias pglCommandListSegmentsNV = void function(GLuint,GLuint);
        alias pglCompileCommandListNV = void function(GLuint);
        alias pglCallCommandListNV = void function(GLuint);
    }

    __gshared {
        pglCreateStatesNV glCreateStatesNV;
        pglDeleteStatesNV glDeleteStatesNV;
        pglIsStateNV glIsStateNV;
        pglStateCaptureNV glStateCaptureNV;
        pglGetCommandHeaderNV glGetCommandHeaderNV;
        pglGetStageIndexNV glGetStageIndexNV;
        pglDrawCommandsNV glDrawCommandsNV;
        pglDrawCommandsAddressNV glDrawCommandsAddressNV;
        pglDrawCommandsStatesNV glDrawCommandsStatesNV;
        pglDrawCommandsStatesAddressNV glDrawCommandsStatesAddressNV;
        pglCreateCommandListsNV glCreateCommandListsNV;
        pglDeleteCommandListsNV glDeleteCommandListsNV;
        pglIsCommandListNV glIsCommandListNV;
        pglListDrawCommandsStatesClientNV glListDrawCommandsStatesClientNV;
        pglCommandListSegmentsNV glCommandListSegmentsNV;
        pglCompileCommandListNV glCompileCommandListNV;
        pglCallCommandListNV glCallCommandListNV;
    }

    private @nogc nothrow
    bool loadNVCommandList(SharedLib lib, GLSupport contextVersion)
    {
        lib.bindGLSymbol(cast(void**)&glCreateStatesNV, "glCreateStatesNV");
        lib.bindGLSymbol(cast(void**)&glDeleteStatesNV, "glDeleteStatesNV");
        lib.bindGLSymbol(cast(void**)&glIsStateNV, "glIsStateNV");
        lib.bindGLSymbol(cast(void**)&glStateCaptureNV, "glStateCaptureNV");
        lib.bindGLSymbol(cast(void**)&glGetCommandHeaderNV, "glGetCommandHeaderNV");
        lib.bindGLSymbol(cast(void**)&glGetStageIndexNV, "glGetStageIndexNV");
        lib.bindGLSymbol(cast(void**)&glDrawCommandsNV, "glDrawCommandsNV");
        lib.bindGLSymbol(cast(void**)&glDrawCommandsAddressNV, "glDrawCommandsAddressNV");
        lib.bindGLSymbol(cast(void**)&glDrawCommandsStatesNV, "glDrawCommandsStatesNV");
        lib.bindGLSymbol(cast(void**)&glDrawCommandsStatesAddressNV, "glDrawCommandsStatesAddressNV");
        lib.bindGLSymbol(cast(void**)&glCreateCommandListsNV, "glCreateCommandListsNV");
        lib.bindGLSymbol(cast(void**)&glDeleteCommandListsNV, "glDeleteCommandListsNV");
        lib.bindGLSymbol(cast(void**)&glIsCommandListNV, "glIsCommandListNV");
        lib.bindGLSymbol(cast(void**)&glListDrawCommandsStatesClientNV, "glListDrawCommandsStatesClientNV");
        lib.bindGLSymbol(cast(void**)&glCommandListSegmentsNV, "glCommandListSegmentsNV");
        lib.bindGLSymbol(cast(void**)&glCompileCommandListNV, "glCompileCommandListNV");
        lib.bindGLSymbol(cast(void**)&glCallCommandListNV, "glCallCommandListNV");
        return resetErrorCountGL();
    }
} else enum hasNVCommandList = false;

package @nogc nothrow
void loadNV_44(SharedLib lib, GLSupport contextVersion)
{
    static if(useNVCommandList) _hasNVCommandList =
            hasExtension(contextVersion, "GL_NV_command_list") &&
            lib.loadNVCommandList(contextVersion);
}
