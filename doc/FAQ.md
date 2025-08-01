# Frequiently Asked Questions

## Why Dagon doesn't support multiple graphics APIs?
Support for multiple graphics backends (such as Direct3D + different versions of OpenGL + Metal + whatever) brings little benefit, but requires huge resources to implement and maintain. It also limits the GPU features that can be used by the application to a common denominator across all target platforms. Using multiple APIs won't make the engine faster and more reliable, won't add new features, but will increase code complexity and introduce too many otherwise unnecessary abstractions, which is something we would like to avoid.

## Why not Vulkan?
Due to the specificity of Vulkan's architecture, it is not a drop-in OpenGL replacement for an engine like Dagon. OpenGL functionality doesn't map one-to-one to Vulkan, the engine would be heavily adapted and rewritten in many places, and some important features may be dropped. Also Vulkan support will tightly bind the engine's logic to Vulkan's structures and execution models in their current state of affair, which is a bad thing in the long run, because the API is new and will most likely change.
