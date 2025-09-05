# Messaging System

Dagon's messaging module provides a framework for building concurrent applications using in-process microservices. The system provides asynchronous event handling and lock-free inter-thread communication. It combines ideas from the actor model, distributed architectures, and OS-level message passing.

## Features
- Lock-free queues. Efficient single-producer single-consumer event queues for fast communication
- Threaded processing. Run endpoints in parallel threads for asynchronous event handling
- Broadcast and direct messaging. Send messages to specific recipients or broadcast to all endpoints
- Main-thread task queue. Safely modify game state from background threads via tasks executed in the main thread
- Flexible payloads. Messages can carry application-specific data via an optional payload.

## Use Cases
- Networking. The network client should run in a background thread, enabling smooth gameplay even with a slow Internet connection
- Audio. If you build your own audio engine, it should also work in a dedicated thread, so that the sound output won't suffer from FPS drops
- Heavy I/O tasks such as reading or writing files or pipe I/O, that would otherwise block the main thread
- AI agents running heavy computations (e.g., A* pathfinding, decision trees) can operate in background threads without blocking the game loop.

Remember that the system is asynchronous: unlike in `EventManager`, events do not propagate immediately, and the order in which they are processed cannot be assumed. Messaging system can only serve as a basis for processes that don't strictly require immediate response from the engine and tolerant for delays.

## Key Concepts
- **Event**: the system operates on the same event structs as `dagon.core.event`. `Event` type represents a single occurrence (e.g., key press, window resize, a message)
- **Endpoint**: base class for components that send and receive messages. The `Endpoint` uses inbox/outbox pattern with two lock-free SPSC event queues: it only writes to the outbox and reads from the inbox
- **ThreadedEndpoint (Actor)**: an endpoint running in its own thread for asynchronous event processing. Think of it as a threaded analog of `EventListener`
- **MessageBroker**: central hub for distributing events and messages between endpoints
- **Address**: a string that identifies a message event receiver (`Endpoint` or `EventListener`). A reserved address `"broadcast"` is a special case: it means that the message is forwarded to all receivers
- **Domain**. Unlike traditional game event managers, Dagon's messaging system introduces domains as a lightweight routing mechanism. This allows endpoints and main-thread listeners to coexist in a single unified communication layer. `Event.domain` is an integer tag that determines the routing layer: zero means inter-thread communication via endpoints, non-zero means synchronized messages via the main event bus. If it is zero, the message is distributed to the corresponding endpoint by the message broker. Otherwise the message goes to the synchronized event bus and is dispatched by the `EventListener` with the corresponding address. Applications can repurpose non-zero domains to group messages or encode custom semantics (e.g., message classes, sender groups)
- **Task**: a special event with a delegate callback that is passed from the endpoint to the synchronized event bus. It is used to modify game state from background threads. The task should be handled manually in `onTaskEvent` method of the `EventListener`. Typically the task event is handled only by one listener to whom it is addressed
- **Payload**: an arbitrary pointer that can be passed with events. It is used in message and task events. Its access semantics is entirely up to the user - the system does not guarantee safe access to it and doesn't manage its ownership and lifetime. Ensure proper synchronization and memory management.

## Usage
TODO
