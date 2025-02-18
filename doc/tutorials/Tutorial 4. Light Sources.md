# Tutorial 4. Light Sources

The light we've used so far is sun light - that is, a directional light source that emits parallel rays. The engine also supports point lights - they are, in fact, area lights because you can specify their radius. They are created like this:
```d
auto light = addLight(LightType.AreaSphere);
light.position = Vector3f(0, 1, 0);
light.color = Color4f(1, 1, 1, 1);
light.energy = 1.0f;
light.radius = 0.1f;
light.volumeRadius = 5.0f;
```

![](https://2.bp.blogspot.com/-C_epqAkvAzY/Www9UBn1_sI/AAAAAAAADZc/8tmbq35vXkwtZ9eiyKsjTfsmv7mvo3gsQCLcBGAs/s1600/Untitled%2B5.jpg)

Keep in mind that point/area lights in Dagon rely on the deferred rendering system. This means that they affect only opaque (alpha-clipped) objects. Blended objects are not supported by deferred renderer, so they are drawn at a separate pipeline stage with fallback forward lighting shader that currently supports only one global sun light (`environment.sun`).

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial4)
