# Dagon Development Guide

This guide will help you with modifying and extending the engine.

Dagon is fully modular: most of its components can be replaced with custom ones. You can override almost anything: make your own asset loaders, implement a custom render pipeline with your own shaders and techniques, and, overall, take much more control over your game than with other engines. You can even override the application's main loop (`Application.run`), the very heart of the engine, using your own timer. At the same time, Dagon is written in such a way that it is easy to use and doesn't require much boilerplate code and engineer-level understanding on the user side, so a number of design patterns should be adhered when extending the engine. Extending Dagon also requires getting familiar with dlib's best coding practices.

## Memory Management

Dagon mostly avoids using the garbage collector and manages all of its data manually with `New` and `Delete` functions. You are also expected to do so. You still can use garbage collected data in Dagon, but this may result in weird bugs, so you are strongly recommended to do things our way. Most part of the engine is built around dlib's ownership model—every object belongs to some other object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management — you have to manually delete only root owner, which usually is an `Application` or `Game` object.

```d
class MyClass: Owner
{
    this(Owner owner)
    {
        super(owner);
    }
}
```

When creating objects with ownership mechanism, it is important to know:
- Who logically owns them? (an `Application`/`Game`? a `Scene`? an `AssetManager`? an `Entity`?)
- Do other objects access them? When can they be safely deleted without breaking the references?

Thanks to dlib, Dagon also supports custom allocators. The default one is based on good old `malloc`, which is reliable and general-purpose, but not especially fast when it comes to allocating thousands of small objects during startup or scene loading. For such cases, you can switch to a region-based allocator `MmapPool`, which allocates memory linearly and frees it all at once. This approach can significantly speed up loading game data and reduce memory fragmentation.

```d
void main()
{
    globalAllocator = MmapPool.instance;
}
```

Note that the global allocator should be set strictly at the start of the application, before creating a `Game` object.

Internally, `MmapPool` uses `mmap` on POSIX systems and `VirtualAlloc` on Windows to reserve large contiguous memory regions directly from the operating system. This avoids typical fragmentation issues of `malloc`, and makes allocation almost as fast as incrementing a pointer. However, it does not support individual deallocations—memory is freed per-region, not per-object. Technically, it is most efficient when you preallocate lots of data in advance and free the memory in batch. `MmapPool` is not suitable for frequently creating and destroying short-living objects.

Another advantage of region-based allocation is cache-friendliness. Since `MmapPool` allocates memory in large chunks, objects are typically placed close to each other in memory. This greatly improves spatial locality, which helps CPU caches work more efficiently. As a result, iteration-heavy systems may experience noticeable performance gains—simply because memory accesses are faster.

## Memory profiling

dlib includes a simple built-in memory profiler that helps you to debug memory leaks. Usage is the following:

```d
void main()
{
    debug enableMemoryProfiler(true);
    // Run your code...
    debug printMemoryLeaks();
}
```

`printMemoryLeaks` will output a list of manually-allocated objects that were not deleted. Each entry is hinted with type name, size in bytes, and location (file and line) the object was allocated at.

## Error Handling

Exceptions are common mean of error handling, but we recommend against using them. They tend to increase code complexity, they are hard to manage properly, and they make applications crash too often. In D they are also tied to OOP and garbage collector. We recommend a simpler alternative—Go-style error tuples. They can be easily constructed using `Compound` type:

```d
import dlib.core.compound;

Compound!(Data, string) doSomething()
{
    Data data;

    // Process data

    if (someErrorOccured)
        return compound(data, "Error message");
    else
        return compound(data, "");
}

auto res = doSomething();
if (res[1].length)
    writeln(res[1]);
else
    // use res[0]
```

You can use nested functions to finalize your data before returning an error:

```
Compound!(Data, string) doSomething()
{
    Data data;

    Compound!(Data, string) error(string errorMsg)
    {
        // Finalize data...

        return compound(data, errorMsg);
    }

    // Process data...

    if (someErrorOccured)
        return error("Error message");
    else
        return compound(data, "");
}
```

## Containers

Dagon uses containers from dlib, which provides GC-free alternatives to D's native dynamic and associative arrays—`dlib.container.array` and `dlib.container.dict`, respectively.

```d
import dlib.container.array;

Array!int a;
a ~= 10;
a ~= [11, 12, 13];
foreach(i, ref v; a)
    writeln(v);
a.removeBack(1);
assert(a.length == 2);
a.free();
```

```d
import dlib.container.dict;

Dict!(int, string) d = New!(Dict!(int, string))();
d["key1"] = 10;
d["key2"] = 20;
Delete(d);
```

## Strings

While Dagon mostly relies on the standard `string` type, there're also cases when dlib's `String` type is used—for example, when parsing data or constructing new strings in runtime. `String` is designed to be mutable and it doesn't use GC. It is filly compatible with the native `string` type.

```d
import dlib.text.str;

String s = "hello";
s ~= ", world";
s ~= '!';
string dStr = s;
assert(dStr == "hello, world!");
s.free();
```

It also uses SSO (short string optimization), so that strings of less than 128 bytes live entirely on the stack and don't allocate memory. Another advantage is that `String` is implicitly zero-terminated, so it can be passed to C libraries without onerous `toStringz`.
