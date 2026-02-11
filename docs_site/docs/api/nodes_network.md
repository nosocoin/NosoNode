# API Reference: Nodes & Network logic (`mpmn.pas` & `mpred.pas`)

Handles Masternode verification and low-level socket management.

## `mpmn.pas` (Masternode Management)

### `TThreadMNVerificator` (Class)
A specialized thread for connecting to a peer to verify it is actually running a Masternode (Proof of Service).

### `CheckMNReport(LineText: String; block: Integer)`
Parses a Masternode advertisement message and validates the signature against the blockchain height.

### `GetMNodeFromString(StringData: String; out ToMNode: TMNode): Boolean`
Utility to deserialize Masternode data from a protocol string.

### `ClearMNsList()`
Resets the local Masternode directory.

## `mpred.pas` (Network Core)

### `LeerLineasDeClientes()`
Low-level scanner that checks all open socket slots for new data packets.

### `SyncWithMainnet()`
Logic for comparing local chain height with the network consensus and determining if a synchronization is required.

### `ConnectClient(Address, Port: String): Integer`
Initiates an outgoing connection to a peer and assigns it to the first available slot.

### `CloseSlot(Slot: Integer)`
Gracefully terminates a connection, clears buffers, and releases the slot for reuse.

### `ForceServer()`
Attempts to bind the TCP server to the configured port, even if the wallet is not fully synced (admin mode).

### `GetTotalConexiones(): Integer`
Returns the count of active socket connections (both incoming and outgoing).
