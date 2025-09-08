# Messaging System

Dagon's messaging module provides a framework for building concurrent applications using in-process microservices (called endpoints) that run in separate threads. The system provides asynchronous event handling and lock-free inter-thread communication. It combines ideas from the actor model, distributed architectures, and OS-level message passing.

## Architecture Overview
Unlike many frameworks that strictly separate synchronous and asynchronous workflows, Dagon introduces a unified messaging layer that seamlessly integrates both. This design combines the familiarity of an event bus with the scalability of the actor model. The system glues together both synchronous event delivery (`EventManager` and its single-threaded event queue) and asynchronous processing (`MessageBroker` and SPSC queues). Each endpoint behaves like an actor - it runs in its own thread, has an inbox and an outbox, and communicates only through messages and tasks. Endpoints can safely send messages back to the main thread, and the main thread can post messages to endpoints, all through the same API.

Features:
- Lock-free queues. Efficient single-producer single-consumer event queues for fast bidirectional communication
- Broadcast and direct messaging. Send messages to specific recipients or broadcast to all endpoints
- Threaded processing. Run blocking tasks in background using special worker endpoints and keep main game loop uninterrupted
- Flexible payloads. Messages can carry application-specific data.

## Use Cases
Some typical use cases include
- Networking. The network client should make requests in a background thread, enabling smooth gameplay even with a slow Internet connection
- Audio. If you build your own audio engine, it should also work in a dedicated thread, so that the sound output won't suffer from FPS drops
- Heavy I/O tasks such as reading/writing files, which can be offloaded to `Worker` endpoints to avoid blocking the main loop
- AI agents running heavy computations (e.g., A* pathfinding, decision trees) can also operate in background threads without blocking the game loop.

Remember that the system is asynchronous: unlike in `EventManager`, messages and tasks do not propagate immediately, and the order in which they are processed cannot be assumed. Messaging system can only serve as a basis for logic that don't strictly require immediate responses and tolerant for delays. There are many cases where asynchronous computations are not efficient at all:
- Strictly real-time data processing. If the renderer absolutely needs the data to be updated per-frame (like in animation), then you should do that in `onUpdate` methods rather than in the asynchronous event handlers
- Managing GPU resources. OpenGL API is not thread-safe, and using it requires synchronization with the renderer
- Deterministic logic. Mechanics where the order of events and their exact sequence are critical, such as simulations, turn-based combat, or replication logic
- Tight feedback loops. Any logic where the user expects an immediate response (character control, UI elements) should be executed synchronously.

## Key Concepts
- **Event**. The system operates on the same event structs as `dagon.core.event`. `Event` type represents a single occurrence - e.g., key press, window resize, a message.
- **Endpoint**. Base class for components that send and receive messages. The `Endpoint` uses inbox/outbox pattern with two lock-free SPSC event queues: it only writes to the outbox and reads from the inbox.
- **ThreadedEndpoint (Actor)**. An endpoint running in its own thread for asynchronous event processing. Think of it as a threaded analog of `EventListener`: it uses the same dynamic dispatch pattern with `processEvents` and event handler methods.
- **Worker**. A specialized threaded endpoint that executes tasks in the background. Unlike a generic `ThreadedEndpoint`, a `Worker` does not require custom event handling code, it acts as a universal executor in the worker pool managed by the message broker.
- **MessageBroker**. Central hub for distributing messages/tasks between endpoints/workers.
- **Address**. A string that identifies a message recipient (`ThreadedEndpoint` or `EventListener`). An empty address (`""`) is a special case: it means that the message is forwarded to all known recipients in the domain.
- **Domain**. Unlike traditional game event managers, Dagon's messaging system introduces domains as a lightweight routing mechanism. This allows endpoints and main-thread listeners to coexist in a single unified communication system. `Event.domain` is an integer tag that determines the routing layer: negative domain means inter-thread communication via endpoints, positive domain means synchronized messages via the main event bus. If `Event.domain` is negative, the message is distributed to the corresponding endpoint by the message broker. If `Event.domain` is positive, the message goes to the synchronized event bus and is dispatched by the `EventListener` with the corresponding address. Zero domain means circular message that goes to both layers. Applications can repurpose exact domain values to group messages or encode custom semantics (e.g., message classes, sender groups, or anything else).
- **Task**. A special event with a `callback` delegate for safe cross-thread invocation. It is used to call main thread functions in non-blocking way by queueing them for running by one of the workers. Endpoints, in contrast, can use tasks to safely modify game state from their threads by sending task events to the synchronized event bus (in this case the task should be handled manually in `onTask` method by the `EventListener`). Typically the task event is handled only by one listener to whom it is addressed. Tasks have domains in the same way as messages.
- **Payload**. An arbitrary pointer that can be passed with message events. Its access semantics is entirely up to the user - the system does not guarantee safe access to it and doesn't manage its ownership and lifetime. Ensure proper synchronization and memory management. In most cases, prefer managed data structures (unless performance requires raw data). For example, use payload pointer to carry a refernce to an owned class instance.

## Usage
A simple endpoint that just logs (asynchronously) all incoming messages and answers back:

```d
class Responder: ThreadedEndpoint
{
    this(string address, MessageBroker broker, Owner owner)
    {
        super(address, broker, owner);
    }
    
    override void onMessage(uint domain, string sender, string message, void* payload)
    {
        queueLog(LogLevel.Info, message);
        
        send("Scene", "Hi!", null, MessageDomain.MainThread);
    }
}

class TestScene: Scene
{
    Responder responder;
    
    override void afterLoad()
    {
        address = "Scene"; // important to receive messages!
        
        responder = New!Responder("Responder", eventManager.messageBroker, this);
        responder.run();
        
        eventManager.messageBroker.enabled = true; // broker is disabled by default for optimization
    }
    
    override void onKeyDown(int key)
    {
        send("Responder", "Hello, World!");
    }
    
    override void onMessage(int domain, string sender, string message, void* payload)
    {
        logInfo("Scene received from ", sender, ": ", message);
    }
}
```

Workers:

```d
class TestScene: Scene
{
    Worker worker1, worker2;
    
    override void afterLoad()
    {
        address = "Scene"; // important to receive messages!
        
        worker1 = New!Worker("Worker1", eventManager.messageBroker, this);
        worker2 = New!Worker("Worker2", eventManager.messageBroker, this);
        
        worker1.run();
        worker2.run();
        
        eventManager.messageBroker.enabled = true; // broker is disabled by default for optimization
    }
    
    void doSomethingThatBlocks(Object obj, void* payload)
    {
        logInfo("doSomethingThatBlocks");
    }
    
    override void onKeyDown(int key)
    {
        queueTask(&doSomethingThatBlocks);
    }
}
```
