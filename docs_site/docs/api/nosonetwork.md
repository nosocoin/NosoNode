# API Reference: `nosonetwork.pas`

This unit handles the low-level P2P networking using Indy components.

## Data Types
- `Tconectiondata`: Packed record containing peer information (IP, Version, Hash data).
- `TThreadClientRead`: Thread for reading data from a specific peer slot.

## Global Constants
- `MaxConecciones = 99`: Maximum simultaneous peer connections.
- `MainnetVersion = '0.4.4'`: Target network version.

## Key Procedures

### `InitializeElements()`
Allocates memory for connection arrays and initializes critical sections.

### `StartConexThread(LSlot: Integer)`
Starts a reading thread for a newly connected peer.

### `CloseSlot(Slot: Integer)`
Properly disconnects a peer, kills the reading thread, and clears the slot data.

### `GetTotalConexiones(): Integer`
Returns the count of currently active peer connections.

### `TextToSlot(Slot: Integer; TextLine: String)`
Sends a raw string to a specific peer. This is the primary outbound messaging function.

## Server Events (`NodeServerEvents`)
- `OnConnect`: Triggered when a new peer connects to the node.
- `OnDisconnect`: Clean-up logic when a peer leaves.
- `OnExecute`: Main loop for handling incoming connections on the server side.

## Synchronization
Uses `CSIncomingArr` (array of critical sections per slot) to ensure thread-safe access to incoming message buffers.
