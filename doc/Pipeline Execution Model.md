# Pipeline Execution Model

Render pipeline is a heart of any 3D visualization. Pipeline execution model describes the sequence of operations for transforming 3D data into a 2D image displayed on a screen. It is typically divided into several conceptual stages, involving both CPU and GPU processing. In Dagon, "pipeline" term refers to `dagon.render.pipeline.Pipeline` class, an abstraction that manages a sequence of `RenderPass` objects. A pass binds a render target, a shader with corresponding parameters, prepares a `GraphicsState` structure and finally makes a series of draw calls for a certain subset of entities in the scene.

## 1. Binding a Render Target

TODO

## 2. Binding a Shader

TODO

## 3. Preparing GraphicsState

`GraphicsState` structure encapsulates all context information needed for a draw call. Its main purpose is to store per-frame changing state such as transformation matrices, and currently bound rendering parameters such as `Material`, `Environment`, `Pose`, etc. 

## 4. Drawing

TODO
