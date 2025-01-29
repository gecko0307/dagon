module main;

import dagon;
import scene;

// Application class, create your scenes here
class MyGame: Game
{
    MyScene myScene;
    
    this(uint windowWidth, uint windowHeight, bool fullscreen, string title, string[] args)
    {
        super(windowWidth, windowHeight, fullscreen, title, args);
        myScene = New!MyScene(this);
        currentScene = myScene;
    }
}

void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, false, "Dagon template application", args);
    game.run();
    Delete(game);
}
