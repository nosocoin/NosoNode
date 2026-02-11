# API Reference: `nosopsos.pas`

Manages Protocol Service Objects (PSOs), which are used for extended protocol features like Masternode locking and voting.

## File & Stream Management

### `LoadPSOFileFromDisk(): Boolean`
Reads the `psos.dat` database and populates the internal arrays.

### `SavePSOFileToDisk(BlockNumber: Integer): Boolean`
Updates the disk storage with current PSO data.

### `GetPSOsAsMemStream(out LMs: TMemoryStream): Int64`
Exports the PSO database as a stream for P2P synchronization.

## Object Management

### `AddNewPSO(LMode, LOwner, LExpire, LParams): Boolean`
Registers a new active PSO on the blockchain.

### `GetPSOValue(LValue, LParams): String`
Utility for parsing specific values out of a PSO parameter string.

## Masternode Locking

### `IsLockedMN(Address: String): Boolean`
Checks if a specific address is currently locked by a PSO (preventing it from moving funds).

### `LockedMNsRawString(): String`
Generates a space-delimited string of all currently locked Masternode addresses.

## Record Format
- `TPSOData`: Packed Record containing `Mode`, `Owner`, `Expire`, `Hash`, `Members`, and `Params`.
