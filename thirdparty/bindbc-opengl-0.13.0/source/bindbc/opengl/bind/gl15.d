
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.gl15;

import bindbc.loader : SharedLib;
import bindbc.opengl.config,
       bindbc.opengl.context;
import bindbc.opengl.bind.types;

public import bindbc.opengl.bind.gl14;

enum : uint {
    GL_BUFFER_SIZE                    = 0x8764,
    GL_BUFFER_USAGE                   = 0x8765,
    GL_QUERY_COUNTER_BITS             = 0x8864,
    GL_CURRENT_QUERY                  = 0x8865,
    GL_QUERY_RESULT                   = 0x8866,
    GL_QUERY_RESULT_AVAILABLE         = 0x8867,
    GL_ARRAY_BUFFER                   = 0x8892,
    GL_ELEMENT_ARRAY_BUFFER           = 0x8893,
    GL_ARRAY_BUFFER_BINDING           = 0x8894,
    GL_ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895,
    GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F,
    GL_READ_ONLY                      = 0x88B8,
    GL_WRITE_ONLY                     = 0x88B9,
    GL_READ_WRITE                     = 0x88BA,
    GL_BUFFER_ACCESS                  = 0x88BB,
    GL_BUFFER_MAPPED                  = 0x88BC,
    GL_BUFFER_MAP_POINTER             = 0x88BD,
    GL_STREAM_DRAW                    = 0x88E0,
    GL_STREAM_READ                    = 0x88E1,
    GL_STREAM_COPY                    = 0x88E2,
    GL_STATIC_DRAW                    = 0x88E4,
    GL_STATIC_READ                    = 0x88E5,
    GL_STATIC_COPY                    = 0x88E6,
    GL_DYNAMIC_DRAW                   = 0x88E8,
    GL_DYNAMIC_READ                   = 0x88E9,
    GL_DYNAMIC_COPY                   = 0x88EA,
    GL_SAMPLES_PASSED                 = 0x8914,
    GL_SRC1_ALPHA                     = 0x8589,
}

extern(System) @nogc nothrow {
    alias pglGenQueries = void function(GLsizei,GLuint*);
    alias pglDeleteQueries = void function(GLsizei,const(GLuint)*);
    alias pglIsQuery = GLboolean function(GLuint);
    alias pglBeginQuery = void function(GLenum,GLuint);
    alias pglEndQuery = void function(GLenum);
    alias pglGetQueryiv = void function(GLenum,GLenum,GLint*);
    alias pglGetQueryObjectiv = void function(GLuint,GLenum,GLint*);
    alias pglGetQueryObjectuiv = void function(GLuint,GLenum,GLuint*);
    alias pglBindBuffer = void function(GLenum,GLuint);
    alias pglDeleteBuffers = void function(GLsizei,const(GLuint)*);
    alias pglGenBuffers = void function(GLsizei,GLuint*);
    alias pglIsBuffer = GLboolean function(GLuint);
    alias pglBufferData = void function(GLenum,GLsizeiptr,const(GLvoid)*,GLenum);
    alias pglBufferSubData = void function(GLenum,GLintptr,GLsizeiptr,const(GLvoid)*);
    alias pglGetBufferSubData = void function(GLenum,GLintptr,GLsizeiptr,GLvoid*);
    alias pglMapBuffer = GLvoid* function(GLenum,GLenum);
    alias pglUnmapBuffer = GLboolean function(GLenum);
    alias pglGetBufferParameteriv = void function(GLenum,GLenum,GLint*);
    alias pglGetBufferPointerv = void function(GLenum,GLenum,GLvoid*);
}

__gshared {
    pglGenQueries glGenQueries;
    pglDeleteQueries glDeleteQueries;
    pglIsQuery glIsQuery;
    pglBeginQuery glBeginQuery;
    pglEndQuery glEndQuery;
    pglGetQueryiv glGetQueryiv;
    pglGetQueryObjectiv glGetQueryObjectiv;
    pglGetQueryObjectuiv glGetQueryObjectuiv;
    pglBindBuffer glBindBuffer;
    pglDeleteBuffers glDeleteBuffers;
    pglGenBuffers glGenBuffers;
    pglIsBuffer glIsBuffer;
    pglBufferData glBufferData;
    pglBufferSubData glBufferSubData;
    pglGetBufferSubData glGetBufferSubData;
    pglMapBuffer glMapBuffer;
    pglUnmapBuffer glUnmapBuffer;
    pglGetBufferParameteriv glGetBufferParameteriv;
    pglGetBufferPointerv glGetBufferPointerv;
}

package(bindbc.opengl) @nogc nothrow
bool loadGL15(SharedLib lib, GLSupport contextVersion)
{
    if(contextVersion > GLSupport.gl14) {
        lib.bindGLSymbol(cast(void**)&glGenQueries, "glGenQueries");
        lib.bindGLSymbol(cast(void**)&glDeleteQueries, "glDeleteQueries");
        lib.bindGLSymbol(cast(void**)&glIsQuery, "glIsQuery");
        lib.bindGLSymbol(cast(void**)&glBeginQuery, "glBeginQuery");
        lib.bindGLSymbol(cast(void**)&glEndQuery, "glEndQuery");
        lib.bindGLSymbol(cast(void**)&glGetQueryiv, "glGetQueryiv");
        lib.bindGLSymbol(cast(void**)&glGetQueryObjectiv, "glGetQueryObjectiv");
        lib.bindGLSymbol(cast(void**)&glGetQueryObjectuiv, "glGetQueryObjectuiv");
        lib.bindGLSymbol(cast(void**)&glBindBuffer, "glBindBuffer");
        lib.bindGLSymbol(cast(void**)&glDeleteBuffers, "glDeleteBuffers");
        lib.bindGLSymbol(cast(void**)&glGenBuffers, "glGenBuffers");
        lib.bindGLSymbol(cast(void**)&glIsBuffer, "glIsBuffer");
        lib.bindGLSymbol(cast(void**)&glBufferData, "glBufferData");
        lib.bindGLSymbol(cast(void**)&glBufferSubData, "glBufferSubData");
        lib.bindGLSymbol(cast(void**)&glGetBufferSubData, "glGetBufferSubData");
        lib.bindGLSymbol(cast(void**)&glMapBuffer, "glMapBuffer");
        lib.bindGLSymbol(cast(void**)&glUnmapBuffer, "glUnmapBuffer");
        lib.bindGLSymbol(cast(void**)&glGetBufferParameteriv, "glGetBufferParameteriv");
        lib.bindGLSymbol(cast(void**)&glGetBufferPointerv, "glGetBufferPointerv");
        if(errorCountGL() == 0) return true;
    }
    return false;
}