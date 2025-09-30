# dagon:gscript

Experimental scripting engine based on [GScript3](https://github.com/gecko0307/gscript3) VM. No built-in compiler yet, scripts have to be compiled with `gs` compiler:

`gc -c -i test.gs`

The resulting *.gsc file can be then loaded to the VM (see below).

## Basic Embedding

```d
import gscript;

GsVirtualMachine vm = New!GsVirtualMachine(owner);
ubyte[] code = cast(ubyte[])std.file.read("scripts/test.gsc");
Array!GsInstruction program = loadBytecode(code);
vm.load(program.data);
vm.run();
program.free();
```

## Binding Functions

TODO

## Binding Objects

TODO

## Script Runner Service

TODO
