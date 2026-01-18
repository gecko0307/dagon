# Video

Dagon supports video playback via dagon:video extension which is based on libVLC, a free video framework which is part of the [VLC Media Player](https://github.com/videolan/vlc). It supports all popular video formats. The video is decoded to OpenGL texture and can be used in the engine just as any normal texture.

## Libraries and Plugins

The extension depends on `libvlccore.dll` and `libvlc.dll` (`libvlccore.so.9`, `libvlc.so` and `libidn.so.11` under Linux). Also a number of plugins are necessary for libVLC to work properly. They are stored in `plugins` folder under Windows and `plugins_linux` folder under Linux.

## Usage

dagon:video provides two classes: `VideoManager` and `Video`. The underlying `Texture` object is available as `Video.texture` property. To open a video, call `Video.open`, to start playing—`Video.play`.

Simple use case—fullscreen video (for splash screens, cutscenes, etc.):

```d
import dagon;
import dagon.ext.video;

class MyScene: Scene
{
    MyGame game;
    Video video;
    FullscreenMediaView videoView;
    bool videoIsPlaying = false;
    
    this(MyGame game)
    {
        super(game);
        this.game = game;
    }
    
    override void afterLoad()
    {
        video = New!Video(game.videoManager, 1920, 1080, assetManager);
        video.open("media/video.mp4");
        
        videoView = addWidget!FullscreenMediaView();
        videoView.setMediaTexture(video.texture);
        
        video.play();
        videoIsPlaying = true;
    }
    
    override void onUpdate(Time t)
    {
        if (videoIsPlaying)
        {
            video.update();
            if (video.isEnded)
            {
                videoIsPlaying = false;
                videoView.visible = false;
                // do something
            }
        }
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

void main(string[] args)
{
    VLCSupport sup = loadVLC();
    
    MyGame game = New!MyGame(1280, 720, false, "Dagon video demo", args);
    game.run();
    Delete(game);
}
```

Video texture playing on a 3D plane:

```d
import dagon;
import dagon.ext.video;

class MyScene: Scene
{
    MyGame game;
    Video video;
    bool canPlayVideo = false;
    bool videoIsPlaying = false;
    
    this(MyGame game)
    {
        super(game);
        this.game = game;
    }
    
    override void afterLoad()
    {
        auto camera = addCamera();
        auto freeview = New!FreeviewComponent(eventManager, camera);
        freeview.setZoom(5);
        freeview.setRotation(30.0f, -45.0f, 0.0f);
        freeview.translationStiffness = 0.25f;
        freeview.rotationStiffness = 0.25f;
        freeview.zoomStiffness = 0.25f;
        game.renderer.activeCamera = camera;
        
        auto sun = addLight(LightType.Sun);
        sun.shadowEnabled = true;
        sun.energy = 5.0f;
        sun.pitch(-45.0f);
        
        video = New!Video(game.videoManager, 1920, 1080, assetManager);
        canPlayVideo = video.open("media/video.mp4");
        
        auto matVideo = addMaterial();
        matVideo.baseColorTexture = video.texture;
        matVideo.alphaTestThreshold = 0.0f;
        
        auto ePlane = addEntity();
        float videoAspectRatio = 1920.0f / 1080.0f;
        ePlane.drawable = New!ShapePlane(10 * videoAspectRatio, 10, 1, assetManager);
        ePlane.material = matVideo;
        
        if (canPlayVideo)
        {
            video.play();
            videoIsPlaying = true;
        }
    }
    
    override void onUpdate(Time t)
    {
        if (videoIsPlaying)
        {
            video.update();
            if (video.isEnded)
            {
                videoIsPlaying = false;
                // do something
            }
        }
    }
}
```
