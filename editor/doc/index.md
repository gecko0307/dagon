# Dagon Editor

Dagon Editor is a scene editor for building 3D scenes from models. It is written using Dagon Engine itself, providing a WYSIWYG workflow: with the same renderer settings, a scene looks the same in the editor and in the engine.

Dagon Editor is focused on scene editing. Unlike a complete game development environment such as Unity or Godot, it does not manage projects or impose a particular project structure. How you organize and use the data created in the editor is up to you.

## Documentation

Choose a topic to get started.

### Viewport

Learn how to navigate the 3D scene, select entities, use the transform gizmo, and work with snapping.

[Read Viewport guide →](viewport.html)

## Getting Started

The Editor uses a familiar level-editor layout. The Viewport is in the center, with the Inspector on the left, Properties on the right, and the Asset Browser at the bottom. The menu bar and toolbar are at the top.

The Asset Browser is disabled until the scene has been saved, because it uses the scene file's parent directory as its asset root. Save the scene with **Ctrl+S** or choose **File → Save as...** to enable it.

To import a model, copy it into the asset root directory (a subdirectory such as `meshes` or `models` is recommended), then drag and drop it into the Viewport.
