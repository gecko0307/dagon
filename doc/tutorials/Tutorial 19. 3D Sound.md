# Tutorial 19. 3D Sound

Starting from Dagon 0.32 a sound playback extension is provided, dagon:audio, which is based on a lightweight yet powerful [SoLoud](https://github.com/jarikomppa/soloud) engine. It supports both 2D and 3D sounds, and the extension makes working with it very easy.

Start with creating an `AudioManager` in your game class:

```d
class MyGame: Game
{
    AudioManager audioManager;
    
    this(uint windowWidth, uint windowHeight, bool fullscreen, string title, string[] args)
    {
        super(windowWidth, windowHeight, fullscreen, title, args);
        audioManager = New!AudioManager(this);
        currentScene = New!MyScene(this);
    }
}
```

TODO

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t19-3d-sound)
