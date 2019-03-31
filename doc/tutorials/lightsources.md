# Tutorial 4. Light Sources

The light we've used so far is sun light - that is, a directional light source that emits parallel rays. The engine also supports point lights - they are, in fact, area lights because you can specify their radius. They are created like this:
```d
auto light1 = createLightSphere(Vector3f(-2, 1, 0), Color4f(1.0f, 1.0f, 0.0f), 10.0f, 5.0f, 0.1f);
auto light2 = createLightSphere(Vector3f(2, 1, 0), Color4f(0.0f, 1.0f, 1.0f), 10.0f, 5.0f, 0.1f);
```
Parameters are the following: position, color, energy, coverage (light volume) radius, area radius.

![](https://2.bp.blogspot.com/-C_epqAkvAzY/Www9UBn1_sI/AAAAAAAADZc/8tmbq35vXkwtZ9eiyKsjTfsmv7mvo3gsQCLcBGAs/s1600/Untitled%2B5.jpg)

[Browse source code for this tutorial](https://github.com/gecko0307/dagon-tutorials/tree/master/tutorial4)