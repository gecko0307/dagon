module dagon.core.libs;

public
{
    import bindbc.sdl;
    import bindbc.opengl;
    
    version(NoFreetype)
    {
    }
    else
    {
        import bindbc.freetype;
    }
    
    version(NoNuklear)
    {
    }
    else
    {
        import bindbc.nuklear;
    }
}
