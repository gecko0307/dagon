module dagon;

public
{
    import derelict.sdl2.sdl;
    import derelict.opengl.gl;
    import derelict.opengl.glu;
    import derelict.opengl.glext;
    import derelict.freetype.ft;

    import dlib.core.memory;
    import dlib.math.vector;
    import dlib.math.matrix;
    import dlib.math.affine;
    import dlib.math.quaternion;
    import dlib.math.utils;
    
    import dlib.image.color;

    import dlib.container.array;
    import dlib.container.dict;

    import dagon.core.ownership;
    import dagon.core.interfaces;
    import dagon.core.application;
    import dagon.core.event;
    import dagon.core.keycodes;
    import dagon.core.vfs;

    import dagon.resource.scene;
    import dagon.resource.asset;
    import dagon.resource.textasset;
    import dagon.resource.textureasset;
    import dagon.resource.iqm;

    import dagon.logics.entity;
    import dagon.logics.controller;
    import dagon.logics.behaviour;
    import dagon.logics.stdbehaviour;

    import dagon.graphics.rc;
    import dagon.graphics.tbcamera;
    import dagon.graphics.freeview;
    import dagon.graphics.shapes;
    import dagon.graphics.texture;
    import dagon.graphics.animmodel;
    import dagon.graphics.light;
}

