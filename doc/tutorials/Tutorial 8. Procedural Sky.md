# Tutorial 8. Procedural Sky

We already learned how to add a skybox to the scene in Tutorial 5. Instead of showing a static environment map, it can render procedural sky using a specialized shader.

Dagon implements [Rayleigh sky model](https://en.wikipedia.org/wiki/Rayleigh_sky_model) that simulates the sun light scattering in the atmosphere. Using it is very simple; just create the shader and assign to the skybox material's `shader`.

```d
auto eSky = addEntity();
eSky.layer = EntityLayer.Background;
auto psync = New!PositionSync(eventManager, eSky, camera);
eSky.drawable = New!ShapeBox(Vector3f(1.0f, 1.0f, 1.0f), assetManager);
eSky.scaling = Vector3f(100.0f, 100.0f, 100.0f);
eSky.material = addMaterial();
eSky.material.depthWrite = false;
eSky.material.useCulling = false;
eSky.material.shader = New!RayleighShader(assetManager);
eSky.gbufferMask = 0.0f;
```

Also make sure that the sun light is assigned to `environment.sun` because Rayleigh shader relies on it as the light source:

```
environment.sun = sun;
```
