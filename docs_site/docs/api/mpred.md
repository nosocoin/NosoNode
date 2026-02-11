# API Reference: `mpred.pas` (Network Engine)

The core engine for managing multiple P2P socket connections and synchronizing them with the mainnet.

## Socket Management

### `ConnectClient(Address, Port: String): Integer`
Initializes an outgoing TCP connection. It reserves a slot and begins the P2P handshake.

### `CloseSlot(Slot: Integer)`
Gracefully terminates a connection, clearing its buffers and freeing the slot for new peers.

### `ReserveSlot(): Integer` / `IsSlotFree(Slot: Integer): Boolean`
Internal management of the `MaxConecciones` pool.

## Mainnet Synchronization

### `SyncWithMainnet()`
The primary synchronization loop. Compares the local block height to the network consensus and decides if blocks or headers need to be downloaded.

### `LeerLineasDeClientes()`
A thread-safe scanner that polls all active slots for incoming data packets.

## Server Control

### `ForceServer()`
Attempts to bind and activate the TCP server listener.

### `StopServer()`
Gracefully shuts down the listening server.

## Status Accessors
- `GetTotalConexiones(): Integer`: Count of active socket peers.
- `GetSlotIP(Slot: Integer): String`: Returns the IP address of a peer in a specific slot.
- `VerifyConnectionStatus()`: Checks for timeouts and "dead" connections in the pool.
