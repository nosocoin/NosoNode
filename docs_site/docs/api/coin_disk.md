# API Reference: Logic & Disk (`mpcoin.pas` & `mpdisk.pas`)

These units handle local validation and system-level file management.

## `mpcoin.pas` (Transaction Validation)

### `GetAddressAvailable(address: String): Int64`
Calculates the spendable balance of an address (Indexed Balance - Pending Outgoing Transactions).

### `AddArrayPoolTXs(order: TOrderData)`
Adds a transaction to the local mempool (`ArrayPoolTXs`). Performs preliminary validation against double-spending in the same block.

### `GetAddressPendingPays(Address: String): Int64`
Scans the mempool to find the total amount already committed by a specific address.

### `PendingRawInfo(ForRPC: Boolean): String`
Serializes the current mempool into a protocol-compatible string for peer distribution.

## `mpdisk.pas` (Storage Management)

### `VerifyFiles()`
The main integrity checker run at startup. Ensures folders exist and core data files (`wallet.pkw`, `nosocfg.psk`, `Summary.nos`) are present.

### `LoadADV()` / `CreateADV(saving: Boolean)`
Manages the advanced configuration file (`AdvOpt.txt`), which stores RPC passwords, form coordinates, and node settings.

### `RestoreBlockChain()`
Logic for flushing the local chain and triggering a resync (usually if a fork is detected).

### `CompleteSumary()`
Rebuilds the entire balance summary by scanning every block file from height 0. This is the "Full Rescan" procedure.
