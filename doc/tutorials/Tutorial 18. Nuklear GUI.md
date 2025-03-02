# Tutorial 18. Nuklear GUI

Dagon supports [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear), a minimalistic immediate mode toolkit written in pure ANSI C and licensed under public domain. Nuklear support in the engine is implemented as an optional extension, so it should be plugged in with `dagon:nuklear` dependency.

Interaction with the library is done with `NuklearGUI` object that binds to an `Entity`. As everything else, this should be done in a class derived from `Scene`:

```d
import dagon;
import dagon.ext.nuklear;
import dagon.ext.ftfont;

class UIScene: Scene
{
    FontAsset font;
    NuklearGUI ui;
    Entity uiEntity;
    
    override void beforeLoad()
    {
        font = this.addFontAsset("assets/fonts/DroidSans.ttf", 18);
    }
    
    override void afterLoad()
    {
        ui = New!NuklearGUI(eventManager, assetManager);
        ui.addFont(font, 18, ui.localeGlyphRanges);
        
        uiEntity = addEntityHUD();
        uiEntity.drawable = ui;
        uiEntity.visible = true;
        
        eventManager.showCursor(true);
    }
    
    override void onUpdate(Time time)
    {
        if (uiEntity.visible)
        {
            ui.update(time);
            layout();
        }
    }
    
    void layout()
    {
        //...
    }
}
```

Note that I used `ui.localeGlyphRanges` when adding the font. This means that Nuklear will load characters based on system locale (in addition to ASCII). Glyph range is just an array of `uint`, so instead of built-in `ui.localeGlyphRanges` you can use your own.

UI is entirely described in the `layout` method. For example, the following code renders a menu bar with a classic "File" menu:

```d
void layout()
{
    if (ui.begin("Menu", 
        NKRect(0, 0, eventManager.windowWidth, 40), 0))
    {
        ui.menubarBegin();
        {
            ui.layoutRowStatic(30, 40, 5);
            
            if (ui.menuBeginLabel("File", NK_TEXT_LEFT, 
                NKVec2(200, 200)))
            {
                ui.layoutRowDynamic(25, 1);
                if (ui.menuItemLabel("New",  NK_TEXT_LEFT))
                { /* do something */ }
                if (ui.menuItemLabel("Open", NK_TEXT_LEFT))
                { /* do something */ }
                if (ui.menuItemLabel("Save", NK_TEXT_LEFT))
                { /* do something */ }
                if (ui.menuItemLabel("Exit", NK_TEXT_LEFT))
                { application.exit(); }
                ui.menuEnd();
            }
        }
        ui.menubarEnd();
    }
    ui.end();
}
```

![menu](https://miro.medium.com/max/349/1*ipX6cxhZHQbkNqtD5eaSdQ.png)

![](https://github.com/gecko0307/dagon/blob/master/doc/tutorials/images/nuklear_menu.png?raw=true)

Layout can get pretty long, so it is feasible to break it into multiple methods — for example, one method per each widget.

If-blocks are used to bind actions to UI events. If some widget returns true, then it is clicked. However, Nuklear doesn’t respond to user input right out of the box — this is something that you have control over. As a bare minimum, you have to notify Nuklear about mouse button events:

```d
override void onMouseButtonDown(int button)
{
    bool unfocused = true;
    if (uiEntity.visible)
    {
        ui.inputButtonDown(button);
        unfocused = !ui.itemIsAnyActive();
    }
    view.active = unfocused;
}

override void onMouseButtonUp(int button)
{
    bool unfocused = true;
    if (uiEntity.visible)
    {
        ui.inputButtonUp(button);
        unfocused = !ui.itemIsAnyActive();
    }
    view.active = unfocused;
}
```

Mouse interaction is a little complicated if you use it somewhere outside of Nuklear — for example, to control the 3D camera that orbits the scene. In this case, you have to check UI focus as shown above: if no widget is touched by this mouse event, then the view component can be activated, and vice versa.

Nuklear supports multi-window layouts. Let’s add a window with a text field:

```d
if (ui.begin("Input", NKRect(100, 100, 230, 200),
    NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | 
    NK_WINDOW_TITLE | NK_WINDOW_SCALABLE))
{
    static int len = 4;
    static char[256] buffer = "test";
    ui.layoutRowDynamic(35, 1);
    ui.editString(NK_EDIT_FIELD, buffer.ptr, &len, 255, null);
}
ui.end();
```

In real application, of course, `buffer` should not be static variable in window's scope block, it should be accessible by external code.

Text input won't work until you add keyboard input:

```d
override void onTextInput(dchar codePoint)
{
    if (uiEntity.visible)
        ui.inputUnicode(codePoint);
}
```

Nuklear is directly compatible with Dagon's Unicode text input, which means that you can switch keyboard layout during the game and type non-Latin text. Keep in mind that the library can only output characters defined by the glyph range. Unfortunately, there is no dynamic/deferred glyph loading as for now.

You also have to add special actions for some keyboard events, such as backspace, delete and copy/paste combos, to make editing work as usual:

```d
override void onKeyDown(int key)
{
    if (uiEntity.visible)
    {
        if (key == KEY_BACKSPACE)
            ui.inputKeyDown(NK_KEY_BACKSPACE);
        else if (key == KEY_DELETE)
            ui.inputKeyDown(NK_KEY_DEL);
        else if (key == KEY_LEFT)
            ui.inputKeyDown(NK_KEY_LEFT);
        else if (key == KEY_RIGHT)
            ui.inputKeyDown(NK_KEY_RIGHT);
        else if (key == KEY_C && eventManager.keyPressed[KEY_LCTRL])
            ui.inputKeyDown(NK_KEY_COPY);
        else if (key == KEY_V && eventManager.keyPressed[KEY_LCTRL])
            ui.inputKeyDown(NK_KEY_PASTE);
        else if (key == KEY_A && eventManager.keyPressed[KEY_LCTRL])
            ui.inputKeyDown(NK_KEY_TEXT_SELECT_ALL);
    }
}
```

Copy/paste support (which is non-trivial taking UTF-8 into account) is provided by the extension, so you don't have to worry about it.
