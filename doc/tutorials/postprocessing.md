# Tutorial 9. Post-processing

Post-processing stack is a part of `Renderer` class. You only have to enable and configure any filters you wish.
```d
renderer.hdr.autoExposure = true;

renderer.ssao.enabled = true;

renderer.motionBlur.enabled = true;

renderer.glow.enabled = true;
renderer.glow.brightness = 0.6;
renderer.glow.radius = 5;

renderer.lensDistortion.enabled = true;
renderer.lensDistortion.dispersion = 0.2;

renderer.antiAliasing.enabled = true;
```
This is how the game may look with all filters on:

![](https://www.dropbox.com/s/v1asklo9tialmm8/postprocessing.jpg?raw=1)