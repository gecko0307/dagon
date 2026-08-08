module dagon.ext.server;

import core.stdc.stdlib;
import std.stdio;

import dlib.core.memory;
import dlib.core.ownership;
import dagon.ext.security;
import enet;

struct Client
{
    ENetPeer* peer;
    STPSession* session;
}

/*
 * STP Server
 */
class NetworkServer: Owner
{
    ushort port = 1234;
    ENetAddress enetAddress;
    ENetHost* enetServer;
    STPServer stpServer;
    
    this(ushort port, Owner owner = null)
    {
        super(owner);
        
        if (!stpServer.loadOrGenerateServerKeys("keys/server.private.key", "keys/server.public.key"))
            exit(1);
        
        if (enet_initialize() != 0)
            exit(1);
        
        enetAddress = ENetAddress(ENET_HOST_ANY, port);
        enetServer = enet_host_create(&enetAddress, 32, 2, 0, 0); // 32 clients, 2 channels
        if (enetServer is null)
            exit(1);
        
        writeln("Server started on port ", port);
    }
    
    ~this()
    {
        enet_host_destroy(enetServer);
        enet_deinitialize();
    }
    
    void onClientConnect(Client client)
    {
        //
    }
    
    void onClientDisconnect(Client client)
    {
        //
    }
    
    void onClientMessage(Client client, string message)
    {
        //
    }
    
    void sendMessage(Client client, string message)
    {
        // TODO: encode using temporary static buffer instead of a dynamically allocated one
        ubyte[] msg = client.session.encodeServerMessage(message);
        ENetPacket* packet = enet_packet_create(msg.ptr, msg.length, ENET_PACKET_FLAG_RELIABLE);
        enet_peer_send(client.peer, 0, packet);
        enet_host_flush(enetServer);
        Delete(msg);
    }
    
    void run()
    {
        ENetEvent event;
        while(1)
        {
            while (enet_host_service(enetServer, &event, 1000) > 0)
            {
                if (event.type == ENET_EVENT_TYPE_CONNECT)
                {
                    writeln("Client connected");
                    // TODO: use a session pool
                    STPSession* session = New!STPSession();
                    event.peer.data = session;
                }
                else if (event.type == ENET_EVENT_TYPE_RECEIVE)
                {
                    STPSession* session = cast(STPSession*)event.peer.data;
                    
                    if (!session.established)
                    {
                        STPHandshakeResponse response;
                        if (event.packet.dataLength == STPHandshakeRequest.sizeof)
                        {
                            STPHandshakeRequest request;
                            request = *(cast(STPHandshakeRequest*)event.packet.data);
                            
                            if (!stpServerValidateHandshakeRequest(&request))
                                // Decline
                                stpServerHandshake(&stpServer, session, &response, STPHandshakeStatus.Declined, STPHandshakeError.ProtocolMismatch);
                            
                            // Save client's ephemeral data
                            session.peerPublicKey = request.clientEphemeralPublicKey;
                            session.peerRandom = request.clientRandom;
                            
                            // Accept the handshake and generate server's ephemeral data
                            stpServerHandshake(&stpServer, session, &response);
                            session.computeSharedSecret();
                            
                            // Derive session keys
                            serverDeriveKeys(session);
                            
                            session.established = true;
                        }
                        else
                            // Decline
                            stpServerHandshake(&stpServer, session, &response, STPHandshakeStatus.Declined, STPHandshakeError.ProtocolMismatch);
                        
                        // Send response packet
                        enet_packet_destroy(event.packet);
                        ENetPacket* packet = enet_packet_create(&response, STPHandshakeResponse.sizeof, ENET_PACKET_FLAG_RELIABLE);
                        enet_peer_send(event.peer, 0, packet);
                        enet_host_flush(enetServer);
                        
                        onClientConnect(Client(event.peer, session));
                    }
                    else
                    {
                        ubyte[] payload = event.packet.data[0..event.packet.dataLength];
                        string plaintext;
                        if (session.decodeClientMessage(payload, plaintext))
                        {
                            onClientMessage(Client(event.peer, session), plaintext);
                            Delete(plaintext);
                        }
                        else
                            writeln("Decoding failed! Packet is invalid");
                        enet_packet_destroy(event.packet);
                    }
                }
                else if (event.type == ENET_EVENT_TYPE_DISCONNECT)
                {
                    STPSession* session = cast(STPSession*)event.peer.data;
                    onClientDisconnect(Client(event.peer, session));
                    if (session !is null)
                    {
                        session.wipe();
                        Delete(session);
                        event.peer.data = null;
                    }
                }
            }
        }
    }
}
