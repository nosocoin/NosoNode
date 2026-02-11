# API Reference: `mpprotocol.pas` (Exhaustive)

This unit implements the high-level P2P protocol logic, message construction, and transaction validation.

## Protocol Core

### `ParseProtocolLines()`
The main dispatcher for incoming P2P messages. Routes commands like `$PING`, `$GETPENDING`, `BLOCKZIP`, etc., to their respective handlers.

### `PTC_SendLine(Slot: Int64; Message: String)`
Low-level wrapper to send a raw string to a specific network slot via the `CanalCliente`.

### `ProtocolLine(tipo: Integer): String`
Generates a protocol-headered message. `tipo` codes:
- `0`: Only headers
- `3`: Ping
- `5`: Get nodes
- `18`: Get head update
- `30`: Get config data

## Transaction Handling

### `ValidateTrfr(order: TOrderData; Origen: String): Integer`
Deep validation of a transaction. Checks signature, timestamp, sender balance, and potential duplication. Returns `0` if valid, otherwise an error code.

### `PTC_Order(TextLine: String): String`
Constructs a transaction message string for network propagation.

### `INC_PTC_Order(TextLine: String; connection: Integer)`
Handles an incoming transaction from a peer.

### `GetOrderFromString(textLine: String; out ThisData: TOrderData): Boolean`
Deserializes a space-delimited protocol string into a `TOrderData` record.

## Block & Chain Sync

### `PTC_SendBlocks(Slot: Integer; TextLine: String)`
Responds to a peer's request for blocks by sending the local chain segments.

### `INC_PTC_Custom(TextLine: String; connection: Integer)`
Processes incoming customization requests (alias assignments).

### `IsAddressLocked(LAddress: String): Boolean`
Checks if an address is temporarily locked (e.g., during a pending transaction to prevent double-spending).

### `IsOrderIDAlreadyProcessed(OrderText: String): Boolean`
Cache-check to avoid reprocessing the same transaction multiple times.

## Utility
- `GetPingString()`: Generates the specialized string used in the `$PING` handshake.
- `IsValidProtocol(line: String): Boolean`: Quick check if a packet starts with the `PSK ` signature.
- `GetOrderDetails(orderid: string): TOrderGroup`: Retrieves full details of a transaction from local storage.
