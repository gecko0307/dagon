# Viewport

The Viewport is the central area of Dagon Editor. It renders the 3D scene and lets you select entities, navigate the camera, and transform objects.

## Mouse and Keyboard Controls

| Input | Action |
|:--|:--|
| Left mouse button (single click) | Select an entity. Shift + click allows you to select multiple entities. |
| Left mouse button (press and hold) | Orbit the camera. Hold Left Ctrl to zoom in or out. Drag a gizmo axis to transform an entity. |
| Right mouse button (press and hold) | Pan the camera. |
| Mouse wheel | Zoom in or out. |
| Delete | Delete the selected entity. |
| Ctrl + Z | Undo an operation. |
| Ctrl + Y | Redo an operation. |

## Transform Gizmo

A red-green-blue manipulator that appears when an entity is selected is called a *gizmo*. It allows you to move, rotate, or scale entities. Switch the transformation mode using the corresponding toolbar buttons.

Left-click a gizmo axis and drag the mouse to transform the entity along that axis.

## Snapping

Hold Left Ctrl while transforming an entity to snap the transformation to discrete steps. The snapping increment can be adjusted on the toolbar.

The default increments are:

- **Move:** 1 m
- **Rotate:** 15°
- **Scale:** 0.1
