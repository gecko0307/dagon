
//          Copyright 2018 - 2021 Michael D. Parker
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.sdl.net;

import bindbc.sdl.config;
static if(bindSDLNet):

import bindbc.sdl.config;
import bindbc.sdl.bind.sdlversion : SDL_version;

enum SDLNetSupport {
    noLibrary,
    badLibrary,
    sdlNet200 = 200,
    sdlNet201 = 201,
}

enum ubyte SDL_NET_MAJOR_VERSION = 2;
enum ubyte SDL_NET_MINOR_VERSION = 0;

version(SDL_Net_201) {
    enum sdlNetSupport = SDLNetSupport.sdlNet201;
    enum SDL_NET_PATCHLEVEL = 1;
}
else {
    enum sdlNetSupport = SDLNetSupport.sdlNet200;
    enum SDL_NET_PATCHLEVEL = 0;
}

alias SDLNet_Version = SDL_version;

@nogc nothrow void SDL_NET_VERSION(SDL_version* X) {
    X.major = SDL_NET_MAJOR_VERSION;
    X.minor = SDL_NET_MINOR_VERSION;
    X.patch = SDL_NET_PATCHLEVEL;
}

struct IPaddress {
    uint host;
    ubyte port;
}

enum {
    INADDR_ANY = 0x00000000,
    INADDR_NONE = 0xFFFFFFFF,
    INADDR_LOOPBACK = 0x7f000001,
    INADDR_BROADCAST = 0xFFFFFFFF,
}

alias TCPsocket = void*;

enum SDLNET_MAX_UDPCHANNELS = 32;
enum SDLNET_MAX_UDPADRESSES = 4;

alias UDPsocket = void*;

struct UDPpacket {
    int channel;
    ubyte* data;
    int len;
    int maxlen;
    int status;
    IPaddress address;
}

struct _SDLNet_SocketSet;
alias _SDLNet_SocketSet* SDLNet_SocketSet;

struct _SDLNet_GenericSocket {
    int ready;
}
alias SDLNet_GenericSocket = _SDLNet_GenericSocket*;

@nogc nothrow {
    int SDLNet_TCP_AddSocket(SDLNet_SocketSet set,void* sock) {
        return SDLNet_AddSocket(set,cast(SDLNet_GenericSocket)sock);
    }
    alias SDLNet_UDP_AddSocket = SDLNet_TCP_AddSocket;

    int SDLNet_TCP_DelSocket(SDLNet_SocketSet set,void* sock) {
        return SDLNet_DelSocket(set,cast(SDLNet_GenericSocket)sock);
    }
    alias SDLNet_UDP_DelSocket = SDLNet_TCP_DelSocket;

    bool SDLNet_SocketReady(void* sock) {
        return sock && (cast(SDLNet_GenericSocket)sock).ready != 0;
    }
}

static if(staticBinding) {
    extern(C) @nogc nothrow {
        const(SDLNet_Version)* SDLNet_Linked_Version();
        int SDLNet_Init();
        void SDLNet_Quit();
        int SDLNet_ResolveHost(IPaddress* address, const(char)* host, ushort port);
        const(char)* SDLNet_ResolveIP(const(IPaddress)* ip);
        int SDLNet_GetLocalAddresses(IPaddress* addresses, int maxcount);
        TCPsocket SDLNet_TCP_Open(IPaddress* ip);
        TCPsocket SDLNet_TCP_Accept(TCPsocket server);
        IPaddress* SDLNet_TCP_GetPeerAddress(TCPsocket sock);
        int SDLNet_TCP_Send(TCPsocket sock, const(void)* data, int len);
        int SDLNet_TCP_Recv(TCPsocket sock, void* data, int len);
        void SDLNet_TCP_Close(TCPsocket sock);
        UDPpacket* SDLNet_AllocPacket(int size);
        int SDLNet_ResizePacket(UDPpacket* packet, int newsize);
        void SDLNet_FreePacket(UDPpacket* packet);
        UDPpacket** SDLNet_AllocPacketV(int howmany, int size);
        void SDLNet_FreePacketV(UDPpacket** packetV);
        UDPsocket SDLNet_UDP_Open(ushort port);
        void SDLNet_UDP_SetPacketLoss(UDPsocket sock, int percent);
        int SDLNet_UDP_Bind(UDPsocket sock, int channel, const(IPaddress)* address);
        void SDLNet_UDP_Unbind(UDPsocket sock, int channel);
        IPaddress* SDLNet_UDP_GetPeerAddress(UDPsocket sock, int channel);
        int SDLNet_UDP_SendV(UDPsocket sock, UDPpacket** packets, int npackets);
        int SDLNet_UDP_Send(UDPsocket sock, int channel, UDPpacket* packet);
        int SDLNet_UDP_RecvV(UDPsocket sock, UDPpacket** packets);
        int SDLNet_UDP_Recv(UDPsocket sock, UDPpacket* packet);
        void SDLNet_UDP_Close(UDPsocket sock);
        SDLNet_SocketSet SDLNet_AllocSocketSet(int maxsockets);
        int SDLNet_AddSocket(SDLNet_SocketSet set, SDLNet_GenericSocket sock);
        int SDLNet_DelSocket(SDLNet_SocketSet set, SDLNet_GenericSocket sock);
        int SDLNet_CheckSockets(SDLNet_SocketSet set, uint timeout);
        void SDLNet_FreeSocketSet(SDLNet_SocketSet set);
        void SDLNet_SetError(const(char)* fmt, ...);
        const(char)* SDLNet_GetError();
    }
}
else {
    import bindbc.loader;

    extern(C) @nogc nothrow {
        alias pSDLNet_Linked_Version = const(SDLNet_Version)* function();
        alias pSDLNet_Init = int function();
        alias pSDLNet_Quit = void function();
        alias pSDLNet_ResolveHost = int function(IPaddress* address, const(char)* host, ushort port);
        alias pSDLNet_ResolveIP = const(char)* function(const(IPaddress)* ip);
        alias pSDLNet_GetLocalAddresses = int function(IPaddress* addresses, int maxcount);
        alias pSDLNet_TCP_Open = TCPsocket function(IPaddress* ip);
        alias pSDLNet_TCP_Accept = TCPsocket function(TCPsocket server);
        alias pSDLNet_TCP_GetPeerAddress = IPaddress* function(TCPsocket sock);
        alias pSDLNet_TCP_Send = int function(TCPsocket sock, const(void)* data, int len);
        alias pSDLNet_TCP_Recv = int function(TCPsocket sock, void* data, int len);
        alias pSDLNet_TCP_Close = void function(TCPsocket sock);
        alias pSDLNet_AllocPacket = UDPpacket* function(int size);
        alias pSDLNet_ResizePacket = int function(UDPpacket* packet, int newsize);
        alias pSDLNet_FreePacket = void function(UDPpacket* packet);
        alias pSDLNet_AllocPacketV = UDPpacket** function(int howmany, int size);
        alias pSDLNet_FreePacketV = void function(UDPpacket** packetV);
        alias pSDLNet_UDP_Open = UDPsocket function(ushort port);
        alias pSDLNet_UDP_SetPacketLoss = void function(UDPsocket sock, int percent);
        alias pSDLNet_UDP_Bind = int function(UDPsocket sock, int channel, const(IPaddress)* address);
        alias pSDLNet_UDP_Unbind = void function(UDPsocket sock, int channel);
        alias pSDLNet_UDP_GetPeerAddress = IPaddress* function(UDPsocket sock, int channel);
        alias pSDLNet_UDP_SendV = int function(UDPsocket sock, UDPpacket** packets, int npackets);
        alias pSDLNet_UDP_Send = int function(UDPsocket sock, int channel, UDPpacket* packet);
        alias pSDLNet_UDP_RecvV = int function(UDPsocket sock, UDPpacket** packets);
        alias pSDLNet_UDP_Recv = int function(UDPsocket sock, UDPpacket* packet);
        alias pSDLNet_UDP_Close = void function(UDPsocket sock);
        alias pSDLNet_AllocSocketSet = SDLNet_SocketSet function(int maxsockets);
        alias pSDLNet_AddSocket = int function(SDLNet_SocketSet set, SDLNet_GenericSocket sock);
        alias pSDLNet_DelSocket = int function(SDLNet_SocketSet set, SDLNet_GenericSocket sock);
        alias pSDLNet_CheckSockets = int function(SDLNet_SocketSet set, uint timeout);
        alias pSDLNet_FreeSocketSet = void function(SDLNet_SocketSet set);
        alias pSDLNet_SetError = void function(const(char)* fmt, ...);
        alias pSDLNet_GetError = const(char)* function();
    }

    __gshared {
        pSDLNet_Linked_Version SDLNet_Linked_Version;
        pSDLNet_Init SDLNet_Init;
        pSDLNet_Quit SDLNet_Quit;
        pSDLNet_ResolveHost SDLNet_ResolveHost;
        pSDLNet_ResolveIP SDLNet_ResolveIP;
        pSDLNet_GetLocalAddresses SDLNet_GetLocalAddresses;
        pSDLNet_TCP_Open SDLNet_TCP_Open;
        pSDLNet_TCP_Accept SDLNet_TCP_Accept;
        pSDLNet_TCP_GetPeerAddress SDLNet_TCP_GetPeerAddress;
        pSDLNet_TCP_Send SDLNet_TCP_Send;
        pSDLNet_TCP_Recv SDLNet_TCP_Recv;
        pSDLNet_TCP_Close SDLNet_TCP_Close;
        pSDLNet_AllocPacket SDLNet_AllocPacket;
        pSDLNet_ResizePacket SDLNet_ResizePacket;
        pSDLNet_FreePacket SDLNet_FreePacket;
        pSDLNet_AllocPacketV SDLNet_AllocPacketV;
        pSDLNet_FreePacketV SDLNet_FreePacketV;
        pSDLNet_UDP_Open SDLNet_UDP_Open;
        pSDLNet_UDP_SetPacketLoss SDLNet_UDP_SetPacketLoss;
        pSDLNet_UDP_Bind SDLNet_UDP_Bind;
        pSDLNet_UDP_Unbind SDLNet_UDP_Unbind;
        pSDLNet_UDP_GetPeerAddress SDLNet_UDP_GetPeerAddress;
        pSDLNet_UDP_SendV SDLNet_UDP_SendV;
        pSDLNet_UDP_Send SDLNet_UDP_Send;
        pSDLNet_UDP_RecvV SDLNet_UDP_RecvV;
        pSDLNet_UDP_Recv SDLNet_UDP_Recv;
        pSDLNet_UDP_Close SDLNet_UDP_Close;
        pSDLNet_AllocSocketSet SDLNet_AllocSocketSet;
        pSDLNet_AddSocket SDLNet_AddSocket;
        pSDLNet_DelSocket SDLNet_DelSocket;
        pSDLNet_CheckSockets SDLNet_CheckSockets;
        pSDLNet_FreeSocketSet SDLNet_FreeSocketSet;
        pSDLNet_SetError SDLNet_SetError;
        pSDLNet_GetError SDLNet_GetError;
    }

    private {
        SharedLib lib;
        SDLNetSupport loadedVersion;
    }

@nogc nothrow:
    void unloadSDLNet()
    {
        if(lib != invalidHandle) {
            lib.unload();
        }
    }

    SDLNetSupport loadedSDLNetVersion() { return loadedVersion; }

    bool isSDLNetLoaded()
    {
        return  lib != invalidHandle;
    }


    SDLNetSupport loadSDLNet()
    {
        version(Windows) {
            const(char)[][1] libNames = ["SDL2_net.dll"];
        }
        else version(OSX) {
            const(char)[][6] libNames = [
                "libSDL2_net.dylib",
                "/usr/local/lib/libSDL2_net.dylib",
                "../Frameworks/SDL2_net.framework/SDL2_net",
                "/Library/Frameworks/SDL2_net.framework/SDL2_net",
                "/System/Library/Frameworks/SDL2_net.framework/SDL2_net",
                "/opt/local/lib/libSDL2_net.dylib"
            ];
        }
        else version(Posix) {
            const(char)[][6] libNames = [
                "libSDL2_net.so",
                "/usr/local/lib/libSDL2_net.so",
                "libSDL2-2.0_net.so",
                "/usr/local/lib/libSDL2-2.0_net.so",
                "libSDL2-2.0_net.so.0",
                "/usr/local/lib/libSDL2-2.0_net.so.0"
            ];
        }
        else static assert(0, "bindbc-sdl is not yet supported on this platform.");

        SDLNetSupport ret;
        foreach(name; libNames) {
            ret = loadSDLNet(name.ptr);
            if(ret != SDLNetSupport.noLibrary) break;
        }
        return ret;
    }

    SDLNetSupport loadSDLNet(const(char)* libName)
    {
        lib = load(libName);
        if(lib == invalidHandle) {
            return SDLNetSupport.noLibrary;
        }

        auto errCount = errorCount();
        loadedVersion = SDLNetSupport.badLibrary;

        lib.bindSymbol(cast(void**)&SDLNet_Linked_Version,"SDLNet_Linked_Version");
        lib.bindSymbol(cast(void**)&SDLNet_Init,"SDLNet_Init");
        lib.bindSymbol(cast(void**)&SDLNet_Quit,"SDLNet_Quit");
        lib.bindSymbol(cast(void**)&SDLNet_ResolveHost,"SDLNet_ResolveHost");
        lib.bindSymbol(cast(void**)&SDLNet_ResolveIP,"SDLNet_ResolveIP");
        lib.bindSymbol(cast(void**)&SDLNet_GetLocalAddresses,"SDLNet_GetLocalAddresses");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_Open,"SDLNet_TCP_Open");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_Accept,"SDLNet_TCP_Accept");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_GetPeerAddress,"SDLNet_TCP_GetPeerAddress");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_Send,"SDLNet_TCP_Send");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_Recv,"SDLNet_TCP_Recv");
        lib.bindSymbol(cast(void**)&SDLNet_TCP_Close,"SDLNet_TCP_Close");
        lib.bindSymbol(cast(void**)&SDLNet_AllocPacket,"SDLNet_AllocPacket");
        lib.bindSymbol(cast(void**)&SDLNet_ResizePacket,"SDLNet_ResizePacket");
        lib.bindSymbol(cast(void**)&SDLNet_FreePacket,"SDLNet_FreePacket");
        lib.bindSymbol(cast(void**)&SDLNet_AllocPacketV,"SDLNet_AllocPacketV");
        lib.bindSymbol(cast(void**)&SDLNet_FreePacketV,"SDLNet_FreePacketV");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Open,"SDLNet_UDP_Open");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_SetPacketLoss,"SDLNet_UDP_SetPacketLoss");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Bind,"SDLNet_UDP_Bind");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Unbind,"SDLNet_UDP_Unbind");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_GetPeerAddress,"SDLNet_UDP_GetPeerAddress");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_SendV,"SDLNet_UDP_SendV");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Send,"SDLNet_UDP_Send");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_RecvV,"SDLNet_UDP_RecvV");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Recv,"SDLNet_UDP_Recv");
        lib.bindSymbol(cast(void**)&SDLNet_UDP_Close,"SDLNet_UDP_Close");
        lib.bindSymbol(cast(void**)&SDLNet_AllocSocketSet,"SDLNet_AllocSocketSet");
        lib.bindSymbol(cast(void**)&SDLNet_AddSocket,"SDLNet_AddSocket");
        lib.bindSymbol(cast(void**)&SDLNet_DelSocket,"SDLNet_DelSocket");
        lib.bindSymbol(cast(void**)&SDLNet_CheckSockets,"SDLNet_CheckSockets");
        lib.bindSymbol(cast(void**)&SDLNet_FreeSocketSet,"SDLNet_FreeSocketSet");
        lib.bindSymbol(cast(void**)&SDLNet_SetError,"SDLNet_SetError");
        lib.bindSymbol(cast(void**)&SDLNet_GetError,"SDLNet_GetError");

        if(errorCount() == errCount) loadedVersion = sdlNetSupport;

        return loadedVersion;
    }
}