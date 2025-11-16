# Newton Dynamics

[Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics) is an Open Source real-time physics engine by Julio Jerez and Alain Suero. It provides great performance and stability, and it's C API makes possible to integrate it into any game engine. Dagon uses Newton 3.14.

Newton wrapper in Dagon is implemented in dagon:newton extension, which makes creating physical worlds very easy. See Tutorial 10 for basic usage of the extension.

All native Newton functions are available for direct use. Unfortunately, there isn't much official documentation on them.

## World

`int NewtonWorldGetVersion();`

Returns the Newton library version number in three-digit decimal format (x.xx). The first digit is major version number (interface changes among other things). The second digit is minor version number (new features, and bug fixes). The third digit is patch version.

---

`int NewtonWorldFloatSize();`

Returns the current size of of float value in bytes.

---

`int NewtonGetMemoryUsed();`

Returns the exact amount of memory use by the engine and any given time time.

---

`void NewtonSetMemorySystem(NewtonAllocMemory mallocFunc, NewtonFreeMemory freeFunc);`

Defines memory allocation callbacks for Newton objects.

Parameters:
`mallocFunc` - a pointer to the memory allocator callback function. If this parameter is `null` the standard `malloc` function is used.
`freeFunc` - a pointer to the memory release callback function. If this parameter is `null` the standard `free` function is used.

---

`NewtonWorld* NewtonCreate();`

Creates an instance of the Newton world. This function must be called before any of the other API functions.

---

`void NewtonDestroy(const NewtonWorld* newtonWorld)`

Destroys an instance of the Newton world.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`void NewtonDestroyAllBodies(const NewtonWorld* newtonWorld);`

Removes all bodies and joints from the Newton world (but keeps group IDs and material pairs).

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`NewtonPostUpdateCallback NewtonGetPostUpdateCallback(const NewtonWorld* newtonWorld);`

---

`void NewtonSetPostUpdateCallback(const NewtonWorld* newtonWorld,  NewtonPostUpdateCallback callback);`

---

void* NewtonAlloc(int sizeInBytes);

---

void NewtonFree(void* ptr);

---

`void NewtonLoadPlugins(const NewtonWorld* newtonWorld, const char* plugInPath);`

---

`void NewtonUnloadPlugins(const NewtonWorld* newtonWorld);`

---

`void* NewtonCurrentPlugin(const NewtonWorld* newtonWorld);`

---

`void* NewtonGetFirstPlugin(const NewtonWorld* newtonWorld);`

---

`void* NewtonGetPreferedPlugin(const NewtonWorld* newtonWorld);`

---

`void* NewtonGetNextPlugin(const NewtonWorld* newtonWorld);`

---

`const char* NewtonGetPluginString(const NewtonWorld* newtonWorld, const void* plugin);`

---

`void NewtonSelectPlugin(const NewtonWorld* newtonWorld, const void* plugin);`

---

`dFloat NewtonGetContactMergeTolerance(const NewtonWorld* newtonWorld);`

---

`void NewtonSetContactMergeTolerance(const NewtonWorld* newtonWorld, dFloat tolerance);`

---

`void NewtonInvalidateCache(const NewtonWorld* newtonWorld);`

---

`void NewtonSetSolverIterations(const NewtonWorld* newtonWorld,  int model);`

---

`int NewtonGetSolverIterations(const NewtonWorld* newtonWorld);`

---

`void NewtonSetParallelSolverOnLargeIsland(const NewtonWorld* newtonWorld, int mode);`

---

`int NewtonGetParallelSolverOnLargeIsland(const NewtonWorld* newtonWorld);`

---

`int NewtonGetBroadphaseAlgorithm(const NewtonWorld* newtonWorld);`

---

`void NewtonSelectBroadphaseAlgorithm(const NewtonWorld* newtonWorld, int algorithmType);`

---

`void NewtonResetBroadphase(const NewtonWorld* newtonWorld);`

---

`void NewtonUpdate(const NewtonWorld* newtonWorld, dFloat timestep);`

Advance the simulation by a given time step. This function calls `NewtonCollisionUpdate` at the lower level to get the colliding contacts.

Parameters:

- `newtonWorld` - the pointer to the Newton world.
- `timestep` - time step in seconds.

---

`void NewtonUpdateAsync(const NewtonWorld* newtonWorld, dFloat timestep);`

---

`void NewtonWaitForUpdateToFinish(const NewtonWorld* newtonWorld);`

---

`int NewtonGetNumberOfSubsteps(const NewtonWorld* newtonWorld);`

---

`void NewtonSetNumberOfSubsteps(const NewtonWorld* newtonWorld, int subSteps);`

---

`dFloat NewtonGetLastUpdateTime(const NewtonWorld* newtonWorld);`

---

`void NewtonSerializeToFile(const NewtonWorld* newtonWorld, const char* filename, NewtonOnBodySerializationCallback bodyCallback, void* bodyUserData);`

---

`void NewtonDeserializeFromFile(const NewtonWorld* newtonWorld, const char* filename, NewtonOnBodyDeserializationCallback bodyCallback, void* bodyUserData);`

---

`void NewtonSerializeScene(const NewtonWorld* newtonWorld, NewtonOnBodySerializationCallback bodyCallback, void* bodyUserData, NewtonSerializeCallback serializeCallback, void* serializeHandle);`

---

`void NewtonDeserializeScene(const NewtonWorld* newtonWorld, NewtonOnBodyDeserializationCallback bodyCallback, void* bodyUserData, NewtonDeserializeCallback serializeCallback, void* serializeHandle);`

---

`NewtonBody* NewtonFindSerializedBody(const NewtonWorld* newtonWorld, int bodySerializedID);`

---

`void NewtonSetJointSerializationCallbacks(const NewtonWorld* newtonWorld, NewtonOnJointSerializationCallback serializeJoint, NewtonOnJointDeserializationCallback deserializeJoint);`

---

`void NewtonGetJointSerializationCallbacks(const NewtonWorld* newtonWorld, NewtonOnJointSerializationCallback* serializeJoint, NewtonOnJointDeserializationCallback* deserializeJoint);`

---

`void NewtonWorldCriticalSectionLock(const NewtonWorld* newtonWorld, int threadIndex);`

Blocks all other threads from executing the same subsequent code simultaneously.

This function should be used to prevent race conditions when a callback is executed from a mutithreaded loop. In general, most callbacks are only thread-safe when they do not write to memory outside their scope. For example, the application can modify properties of object pointed by the arguments or call functions that are allowed to be called from such callback. There are cases, however, when the application need to collect data for the client logic, example of such cases include collecting debug information or data for feedback. In these situations it is possible that the same critical code could be executed at the same time by several threads causing unpredictable side effects. Do it is necessary to block all of the threads from executing this code at once.

It is important that the critical section wrapped by functions `NewtonWorldCriticalSectionLock` and `NewtonWorldCriticalSectionUnlock` is kept small if the application is using the multithreaded functionality of the engine.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`void NewtonWorldCriticalSectionUnlock(const NewtonWorld* newtonWorld);`

Unblocks critical section.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`void NewtonSetThreadsCount(const NewtonWorld* newtonWorld, int threads);`

Set the maximum number of thread the engine is allowed to use by the application.

Parameters:

- `newtonWorld` - the pointer to the Newton world.
- `threads` - max number of threads. if `threads` is set to a value larger that then number of logical CPUs in the system, the `threads` will be clamped to the number of logical CPUs.

---

`int NewtonGetThreadsCount(const NewtonWorld* newtonWorld);`

Gets the total number of threads running in the engine. The maximum number of threads is the maximum number of CPUs in the system.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`int NewtonGetMaxThreadsCount(const NewtonWorld* newtonWorld);`

Get the maximum number of thread abialble. This function will always return 1 in the single-threaded version of the library.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`void NewtonDispachThreadJob(const NewtonWorld* newtonWorld, NewtonJobTask task, void* usedData, const char* functionName);`

---

`void NewtonSyncThreadJobs(const NewtonWorld* newtonWorld);`

---

`int NewtonAtomicAdd(int* ptr, int value);`

---

`int NewtonAtomicSwap(int* ptr, int value);`

---

`void NewtonYield();`

---

`void NewtonSetIslandUpdateEvent(const NewtonWorld* newtonWorld, NewtonIslandUpdate islandUpdate);`

Sets a function to be called on each island update. This function will be called just after the array of bodies making up an island is scanned for collisions, and before the bodies are accepted for solving and integrating. The callback may return 1 to validate the array, or 0 to skip solving (on the current step only).

This functionality can be used to implement real-time physics LOD. For example, the application can determine the AABB of island and check against the view frustum. If the entire island AABB is invisible then the application can suspend simulation.

The application should not modify positions and velocities, or create or destroy any body or joint during this function call. Doing so will result in unpredictable malfunctions.

Parameters:

- `newtonWorld` - the pointer to the Newton world.

---

`void NewtonWorldForEachJointDo(const NewtonWorld* newtonWorld, NewtonJointIterator callback, void* userData);`

Iterates thought joints in the world and calls the callback for each of them.

This function affects the performance of Newton. The application should call this function only for debugging or for serialization purposes.

Parameters:

- `newtonWorld` - the pointer to the Newton world.
- `callback` - callback function.
- `userData` - user-defined data pointer that is passed to the callback.

---

`void NewtonWorldForEachBodyInAABBDo(const NewtonWorld* newtonWorld, const dFloat* p0, const dFloat* p1, NewtonBodyIterator callback, void* userData);`

Iterates thought bodies in the world that intersect the given AABB and calls the callback for each of them.

The function is efficient for relatively small AABB volumes, however in case where the AABB contains most of the objects in the scene, the overhead of scanning the internal broadface collision plus the AABB test make this function more expensive.

Parameters:

- `newtonWorld` - the pointer to the Newton world.
- `p0` - pointer to the vector of 3 floats that hold minimum point of the AABB.
- `p1` - pointer to the vector of 3 floats that hold maximum point of the AABB.
- `callback` - callback function.
- `userData` - user-defined data pointer that is passed to the callback.

---

`void NewtonWorldSetUserData(const NewtonWorld* newtonWorld, void* userData)`

Store a user defined data value with the world.

Parameters:
- `newtonWorld` - pointer to the world object.
- `userData` - pointer to the data.

---

`void* NewtonWorldGetUserData(const NewtonWorld* newtonWorld)`

Retrieve a user-defined value previously stored with the world.

Parameters:
- newtonWorld - pointer to the world object.

---

void* NewtonWorldAddListener(const NewtonWorld* newtonWorld, const char* nameId, void* listenerUserData);

---
