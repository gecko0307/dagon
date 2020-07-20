# Demo of D bingings to nuklear library

## Prebuilding

Before using these demo you need to build `nukear` library. On linux you can do it by running script `prebuild.sh`. This script builds `nuklear` library in `build` directory and install building artifacts into `lib` and `include` directories. These artifacts need to be built once only after project cloning. `SDL` library should be install using system package manager.

## Configurations

There are two configuration: `dynamic` and `static`. The demo uses SDL and nuklear libraries. In dynamic configuration these libraries are used as shared/dynamic libraries (.so/.dll). In static configuration these libraries are used as static libraries (.a). Note: in fact SDL2 library is/could be linked statically to shared library.
Dynamic configuration:
```
cd demo
dub # or dub --config=dynamic
```
Static configuration:
```
cd demo
dub --config=static
```