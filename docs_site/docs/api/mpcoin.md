# API Reference: `mpcoin.pas`

Handles the core transaction (coin) logic, including mempool management and address balance summaries.

## Address Balances

### `GetAddressAvailable(address: String): Int64`
Calculates the current spendable balance (Indexed - Pending Pays).

### `GetAddressPendingPays(Address: String): Int64`
Returns the total amount currently committed in outgoing transactions sitting in the local mempool.

### `GetAddressBalanceIndexed(Address: String): Int64`
Retrieves the balance of an address from the latest block summary on disk.

## Mempool (Pending Transactions)

### `AddArrayPoolTXs(order: TOrderData)`
Adds a transaction to the local pool. Performs checks to ensure it doesn't double-spend within the same block round.

### `ClearAllPending()`
Resets the mempool. Usually done after a new block is accepted or when a re-sync occurs.

### `PendingRawInfo(ForRPC: Boolean): String`
Serializes the current mempool into a protocol-safe string for sharing with peers.

## Logic Helpers
- `CheckImportKeys(wallet: String): Integer`: Attempts to recover and import keys from external files.
- `TranxAlreadyPending(TrxHash: String): Boolean`: Checks if a specific transaction is already in the local pool.
- `IsRPCWhitelisted(IP: String): Boolean`: Security check for remote API access.
