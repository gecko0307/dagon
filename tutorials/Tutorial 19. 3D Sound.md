# Tutorial 19. 3D Sound

Starting from Dagon 0.32 a sound playback extension is provided, dagon:audio, which is based on a lightweight yet powerful [SoLoud](https://github.com/jarikomppa/soloud) engine. It supports both 2D and 3D sounds, and the extension makes working with it very easy.

Start with creating an `AudioManager` in your game class:

```d
import dagon.ext.audio;

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

In your scene create a sound and play it:

```d
class SoundScene: Scene
{
    MyGame game;
    AudioManager audio;
    Wav sound;
    
    this(MyGame game)
    {
        super(game);
        this.game = game;
        this.audio = game.audioManager;
    }
    
    override void beforeLoad()
    {
        sound = audio.loadSound("assets/sounds/sound.wav");
    }
    
    override void afterLoad()
    {
        audio.play(sound);
    }
    
    override void onUpdate(Time t)
    {
        audio.update(t);
    }
}
```

To play a spatial sound (which has a position in 3D space) there are two possible ways. A simpler method is to use `playAtPosition`:

```d
int voice = audio.playAtPosition(sound, Vector3f(1.0f, 2.0f, 3.0f));
```

Sound played this way can't change its position, so it can be more convenient to attach a sound source to Entity using a `SoundComponent`. The sound will automatically follow the Entity, which is especially useful for sources of continuous sound, such as speakers.

```d
SoundComponent soundComp = audio.addSoundTo(myEntity);
soundComp.play(sound);
```

For 3D sound to work, you need a listener, an Entity that is used for spatial perception. This is usually the camera used for rendering:

```d
audio.listener = camera;
```

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t19-3d-sound)
