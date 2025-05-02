# Dagon Development Guide

This guide will help you with modifying and extending the engine.

Dagon is fully modular: most of its components can be replaced with custom ones. You can override almost anything: make your own asset loaders, implement a custom render pipeline with your own shaders and techniques, and, overall, take much more control over your game than with other engines. You can even override the application's main loop (`Application.run`), the very heart of the engine, using your own timer. At the same time, Dagon is written in such a way that it is easy to use and doesn't require much boilerplate code and engineer-level understanding on the user side, so a number of design patterns should be adhered when extending the engine.

## Memory Management

Dagon mostly avoids using the garbage collector and manages all of its data manually with `New` and `Delete` functions. You are also expected to do so. You still can use garbage collected data in Dagon, but this may result in weird bugs, so you are strongly recommended to do things our way. Most part of the engine is built around dlib's ownership model — every object belongs to some other object (owner), and deleting the owner will delete all of its owned objects. This allows semi-automatic memory management — you have to manually delete only root owner, which usually is an `Application` or `Game` object.

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

Internally, `MmapPool` uses `mmap` on POSIX systems and `VirtualAlloc` on Windows to reserve large contiguous memory regions directly from the operating system. This avoids typical fragmentation issues of `malloc`, and makes allocation almost as fast as incrementing a pointer. However, it does not support individual deallocations — memory is freed per-region, not per-object. Technically, it is most efficient when you preallocate lots of data in advance and free the memory in batch. `MmapPool` is not suitable for frequently creating and destroying short-living objects.

Another advantage of region-based allocation is cache-friendliness. Since `MmapPool` allocates memory in large chunks, objects are typically placed close to each other in memory. This greatly improves spatial locality, which helps CPU caches work more efficiently. As a result, iteration-heavy systems may experience noticeable performance gains — simply because memory accesses are faster.

## Containers

TODO
