# Tutorial 16. Decals

Decals are images that are projected to 3D surfaces, like real-world stickers or prints. In Dagon, decals can be used to implement a wide variety of dynamic surface detalization, including footprints, bullet holes, graffiti, foliage, blotches, smudges, etc.

Decal projection is a feature of Dagon's deferred rendering pipeline. To draw a decal, the engine renders an invisible box and uses the geomtry data from the G-buffer to project a texture to the rectangular area that the box covers (in screen space). The reconstructed model-space coordinates of this area are converted to texture coordinates. Then the decal texture is sampled and the resulting fragment is alpha-blended with the frame buffer.

Decal materials support additional textures: normal, roughness, metallic, and emission maps. This allows decals to have their own surface properties (otherwise they "inherit" the geometric information of the underlying surface from the G-buffer). Decals also can have just normal maps and no base color texture, which is useful to imitate footprints.

Due to the screen-space nature of the technique, it is not possible to directly restrict which objects are affected by decals (you don't want a character to walk through the decal projection box and suddenly have the decal appear on the character). Dagon solves this by differentiating static and dynamic entities in the scene. The engine first renders all entities with `dynamic` property set to `false`, then runs the decal projection pass, and then renders all entities with `dynamic` property set to `true`.

It's worth noting that deferred decals only work in the deferred stage of the rendering and are not compatible with forward-mode geometry (with blended materials or custom shaders).

TODO: example code
