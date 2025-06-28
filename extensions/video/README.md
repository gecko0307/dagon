# dagon:video

Adds support for video textures via [libVLC](https://www.videolan.org/vlc/libvlc.html).

## Usage

```d
import dagon;
import dagon.ext.video;

class MyScene: Scene
{
    VideoManager videoManager;
    
    this(GMyGame game)
    {
        super(game);
        this.videoManager = game.videoManager;
    }
    
    override void afterLoad()
    {
        video = New!Video(videoManager, 1920, 1080, assetManager);
        video.open("media/video.mp4");
        
        auto matVideo = addMaterial();
        matVideo.baseColorTexture = video.texture;
        matVideo.alphaTestThreshold = 0.0f;
        
        video.play();
    }
}

class MyGame: Game
{
    VideoManager videoManager;
    
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        videoManager = New!VideoManager(this);
        currentScene = New!MyScene(this);
    }
}

void main()
{
    VLCSupport sup = loadVLC();
    
    MyGame game = New!MyGame(1280, 720, false, "Dagon app", args);
    game.run();
    Delete(game);
}
```
