# dagon:security

Secure transport protocol (STP) for client-server online games designed to run on top of UDP.

Features:
- Focused on real-time use (gaming, streaming, telephony, IoT);
- Uses modern cryptographic algorithms;
- The "pinned certificate" principle: the key for verifying the server's electronic signature is created once, embedded in the client, and does not change (or changes with client updates);
- Uses a system-wide cryptographically secure RNG;

# Specification

## Step 1. Handshake
The Diffie-Hellman protocol on elliptic curves (X25519) is used.

1. When a connection is initiated, both parties (client and server) generate pairs of ephemeral 32-byte X25519 keys and random 32-byte one-time numbers: `server_public_key`, `server_random`, `client_public_key`, `client_random`.
2. The client sends `client_public_key` and `client_random` to the server.
3. The server generates a string `client_public_key + client_random + server_public_key + server_random` and signs it with its long-term EdDSA/Ed25519 private key (64 bytes) to protect against MITM attacks. `server_public_key` and `server_random`, along with the signature, are sent to the client.
4. The client generates an identical string and verifies the signature using the server's 32-byte EdDSA/Ed25519 public key. If the verification fails, the server is considered fake, and the handshake is stopped.
5. Both parties calculate a 32-byte shared secret using X25519.

## Step 2. Key Derivation
The BLAKE2b keyed hash function (keyed mode) is used for key derivation.

1. A shared 64-byte master key is calculated from a mixture of the shared secret, ephemeral public keys, and random nonces of both parties:

```
context = "stp:v1:master:" + client_public_key + client_random + server_public_key + server_random;
master_key = BLAKE2b_keyed(key=shared_secret, context, 64);
```

2. The master key is used to derive shared encryption keys:

- `client_encryption_key (32 bytes) = BLAKE2b_keyed(key=master_key, "client_enc", 32)` - key for encrypting packets from the client to the server;
- `server_encryption_key (32 bytes) = BLAKE2b_keyed(key=master_key, "server_enc", 32)` - key for encrypting packets from the server to the client.

Using separate `client_encryption_key` and `server_encryption_key` prevents reuse of the same key in both directions of transmission. String tags ensure that the keys are independent, even though they are calculated from the same secret.

## Step 3. Sending and Receiving Messages
After successful server signature verification and session key generation, the protocol switches to message transfer mode.

The ChaCha20-Poly1305 IETF AEAD algorithm is used for message encryption. The message text is encrypted with the sending party's key.

The packet consists of:
- An unencrypted header, which currently consists only of a unique nonce. The packet header is transmitted in ChaCha20-Poly1305 as Additional Authenticated Data (AAD), making it tamper-proof even though it is not encrypted;
- A 16-byte authentication code (Poly1305 MAC);
- Ciphertext;

The nonce is a 12-byte number used for ChaCha20-Poly1305 encryption. It includes a 64-bit monotonic counter (padded with zeros to 96 bits) that increments with each packet sent. The receiving party also maintains a counter of received messages. If the nonce from an incoming packet does not match the expected one, the message is discarded before decryption.

If a message fails ChaCha20-Poly1305 authentication, it is discarded as invalid.
