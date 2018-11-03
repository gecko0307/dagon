
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.opengl.bind.types;

// Types defined by the core versions
alias GLenum = uint;
alias GLvoid = void;
alias GLboolean = ubyte;
alias GLbitfield = uint;
alias GLchar = char;
alias GLbyte = byte;
alias GLshort = short;
alias GLint = int;
alias GLsizei = int;
alias GLubyte = ubyte;
alias GLushort = ushort;
alias GLuint = uint;
alias GLhalf = ushort;
alias GLfloat = float;
alias GLclampf = float;
alias GLdouble = double;
alias GLclampd = double;
alias GLintptr = ptrdiff_t;
alias GLsizeiptr = ptrdiff_t;
alias GLint64 = long;
alias GLuint64 = ulong;
alias GLhandle = uint;

// Types defined in various extensions (declared here to avoid repetition)
alias GLint64EXT = GLint64;
alias GLuint64EXT = GLuint64;
alias GLintptrARB = GLintptr;
alias GLsizeiptrARB = GLsizeiptr;
alias GLcharARB = GLchar;
alias GLhandleARB = GLhandle;
alias GLhalfARB = GLhalf;
alias GLhalfNV = GLhalf;