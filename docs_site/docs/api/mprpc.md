# API Reference: JSON-RPC (`mprpc.pas`)

Handles remote requests (API) for external wallets, explorers, and tools.

## Protocol Detail
NosoNode uses **JSON-RPC 2.0** over HTTP.

### Primary Methods:
- `getbalance`: Returns the balance, pending status, and score for an address.
- `getblockorders`: Returns all transactions within a specific block.
- `getmasternodes`: Returns the list of all currently active and verified masternodes.
- `sendfunds`: Allows an authorized remote user to issue a transaction.

## Implementation Functions

### `ParseRPCJSON(jsonreceived: String): String`
High-level parser that validates JSON structure and routes to internal `RPC_*` functions.

### `GetJSONErrorString(ErrorCode: Integer): String`
Maps internal error codes to standard JSON-RPC error messages (e.g., `401` -> `Invalid JSON request`).

### `BuildRPCResponse(mystring: String): String`
Helper to wrap internal Pascal results into a valid JSON string for return over HTTP.

## Security
- `setRPCpassword(newpassword: String)`: Updates the password requirement for RPC access.
- IP Whitelisting: Controlled via `IsRPCWhitelisted` (in `mpcoin.pas`).
