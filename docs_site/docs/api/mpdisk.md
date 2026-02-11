# API Reference: `mpdisk.pas`

Manages system-level file interactions, integrity checks, and blockchain database maintenance.

## System Integrity

### `VerifyFiles()`
The standard startup routine. Checks if folders (`NOSODATA`, `logs`, `sent`) exist and ensures critical files (`wallet.pkw`, `nosocfg.psk`) are healthy.

### `CreateADV(saving: Boolean)`
Handles the creation and updating of the `AdvOpt.txt` (Advanced Options) file, which stores RPC settings and UI preferences.

## Blockchain Maintenance

### `CompleteSumary()`
Triggers a full re-scan of the blockchain. It iterates through every `.blk` file from block 0 and re-indexes all address balances.

### `RestoreBlockChain()`
Deletes local chain files and prepares the node to perform a full re-sync from peers.

## Serialization Helpers

### `UpdateSummaryChanges()`
Saves memory-cached balance changes to the binary `Summary.nos` file.

### `SaveCFGToFile(Content: String): Boolean`
Atomic write for the node configuration file.

## Utilities
- `ClearSumary()`: Wipes the balance index.
- `CreateSumaryBackup()`: Creates a `.bak` of the current balance index.
- `DeleteSentMsjs()`: Cleans up the P2P message history log.
