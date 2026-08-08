# dagon:server

A simple secure UDP server on top of [ENet](http://enet.bespin.org/). Uses the same mechanism as `dagon:network`.

Currently this extension provides only the basic transport layer. An actual game protocol should be implemented on user side, as well as a database driver and any related functionality.

## Usage

```d
import std.stdio;

import dlib.core.memory;
import dlib.core.ownership;

import dagon.ext.server;

class TestServer: NetworkServer
{
    this(Owner owner = null)
    {
        // Bind to port 1234
        super(1234, owner);
    }
    
    // Called after a successful handshake
    override void onClientConnect(Client client)
    {
    }
    
    // Called when client is disconnected
    override void onClientDisconnect(Client client)
    {
    }
    
    // Called when server receives a message from a client
    override void onClientMessage(Client client, string message)
    {
        writeln("[Client] ", message);
        sendMessage(client, "Hello from TestServer!");
    }
}

void main(string[] args)
{
    TestServer server = New!TestServer();
    server.run();
    Delete(server);
}
```
