# Tutorial 13. Custom Shaders

Dagon's material system can be extended using custom GLSL shaders. It is recommended to use GLSL 4.0 (`#version 400 core`).

TODO: shader creation

Limitations:
* Custom shaders are not supported by the deferred rendering pipeline, so objects using them are rendered using forward pipeline. If you want to use lighting in a custom shader, you'll have to implement your own light sorting/batching system.
* Decals work only with deferred pipeline, so they are not placed on objects with custom shaders.