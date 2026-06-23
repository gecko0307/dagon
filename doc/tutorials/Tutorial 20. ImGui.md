# Tutorial 23. ImGui

Dagon supports [Dear ImGui](https://github.com/ocornut/imgui), the most popular immediate UI toolkit. It allows to implement sophisticated user interfaces, turning Dagon into generic application framework. ImGui supports windows, tab-based window docking, all kinds of widgets, menus, tables, grid view, image display, drag and drop mechanics, color pickers, and much more. While you can use ImGui as a main UI toolkit for your game, it is best suited for development tools, such as in-game editors, configurators and debug overlays.

ImGui support is implemented as `dagon:imgui` extension.

TODO: simple usage example.

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/t20-imgui)

A real-world usage example is Dagon's in-development [editor](https://github.com/gecko0307/dagon/tree/master/editor). Most of its functionality isn't working yet, but it has a functioning multi-window interface with a render view integration and some editable scene properties.
