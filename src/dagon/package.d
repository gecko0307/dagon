module dagon;

public
{
    import derelict.sdl2.sdl;
    import derelict.opengl.gl;
    import derelict.opengl.glu;
    import derelict.opengl.glext;
    import derelict.freetype.ft;

    import dlib.core;
    import dlib.math;
    import dlib.geometry;
    import dlib.image;
    import dlib.container;

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
    import dagon.resource.obj;
    import dagon.resource.iqm;
    import dagon.resource.fontasset;

    import dagon.logics.entity;
    import dagon.logics.controller;
    import dagon.logics.behaviour;
    import dagon.logics.stdbehaviour;

    import dagon.graphics.rc;
    import dagon.graphics.tbcamera;
    import dagon.graphics.freeview;
    import dagon.graphics.fpcamera;
    import dagon.graphics.fpview;
    import dagon.graphics.shapes;
    import dagon.graphics.texture;
    import dagon.graphics.animmodel;
    import dagon.graphics.light;
    import dagon.graphics.material;
    import dagon.graphics.environment;
    import dagon.graphics.mesh;
    import dagon.graphics.view;
    import dagon.graphics.particles;
    import dagon.graphics.shadow;
    import dagon.graphics.clustered;
    import dagon.graphics.framebuffer;
    import dagon.graphics.postproc;
    
    import dagon.graphics.materials.generic;
    import dagon.graphics.materials.fixed;
    import dagon.graphics.materials.bp;
    import dagon.graphics.materials.bpclustered;
    import dagon.graphics.materials.sky;
    
    import dagon.graphics.filters.fxaa;
    import dagon.graphics.filters.lens;

    import dagon.ui.font;
    import dagon.ui.ftfont;
    import dagon.ui.textline;

    import dagon.templates.basescene;
}

