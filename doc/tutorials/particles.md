# Tutorial 12. Particles

Particles are a set of small, same-shaped objects whos movement is ruled by simple dynamics laws and random factors of varying influence. They are useful for simulating fire, smoke, dust, explosions, fireworks, water splashes, etc. By default particles in Dagon are billboards (camera-oriented quads), but you can use any Entity as a particle. Billboard particles can be soft (gradually blended with underlying environment based on depth distance to avoid ugly clipping). Particles also drop shadows, which can be partially transparent using alpha cutout.

**Warning: particles module is currently actively developed, so API may change.**

To create a particle system, attach `ParticleSystem` modifier to your entity:
```d
auto particles = createEntity3D();
auto particleSystem = New!ParticleSystem(particles, 50);
```
Particles will render poorly without a dedicated material, so create one:
```d
auto mParticle = createParticleMaterial();
mParticle.diffuse = aTexParticle.texture;
mParticle.shadeless = true;
mParticle.depthWrite = false;
mParticle.blending = Transparent;
particleSystem.material = mParticle;
```
Particles can be shaded using procedural or user-defined normal map. Because they are blended objects, they can't use deferred shading and so are shaded using only sun light. To render shaded particles, set the following material properties:
```d
mParticle.shadeless = false;
mParticle.particleSphericalNormal = true;
```
`particleSphericalNormal` switches simple procedural normal map that treats billboard as a hemisphere. To get more interesting results, custom normal map can be used:
```d
mParticle.particleSphericalNormal = false;
mParticle.normal = aTexParticleNormal.texture;
```
To simulate different effects, random factors can be used - such as initial direction randomness, initial position radius, lifetime range, speed range, and size range:
```d
particleSystem.initialDirectionRandomFactor = 1.0f;
particleSystem.initialDirection = Vector3f(0.0f, 1.0f, 0.0f);
particleSystem.initialPositionRandomRadius = 0.0f;
particleSystem.minLifetime = 1.0f;
particleSystem.maxLifetime = 3.0f;
particleSystem.minInitialSpeed = 1.0f;
particleSystem.maxInitialSpeed = 5.0f;
particleSystem.minSize = 0.25f;
particleSystem.maxSize = 1.0f;
particleSystem.scaleStep = Vector3f(1.0f, 1.0f, 1.0f);
```
`initialDirectionRandomFactor` (from 0 to 1) controls the distribution of initial particle directions. At 0, all particles are emitted along `initialDirection`. At 1, newly emitted particle's direction is fully random. At 0.5, direction is distributed along an `initialDirection`-oriented hemisphere.

`initialPositionRandomRadius` controls the radius of a sphere inside which particles can be randomly spawn. The center of this sphere is entity's local origin.

`minLifetime`, `maxLifetime` determine minimum and maximum lifetime of a particle in seconds. Actual lifetime is a random value in this range.

`minInitialSpeed`, `maxInitialSpeed` determine minimum and maximum initial speed of a particle in m/s. Actual initial speed is a random value in this range.

`minSize`, `maxSize` determine minimum and maximum initial half-size of a particle billboard. Actual initial half-size is a random value in this range.

`scaleStep` is a vector determining half-size change speed. A value of `Vector3f(0, 0, 0)` means no change.

As already stated, you can render any object as a particle:
```d
particleSystem.particleEntity = myEntity;
```