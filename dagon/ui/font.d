module dagon.ui.font;

abstract class Font
{
    float height;
    float width(string str);
    void render(string str);
}

