# API Reference: Summary Index (`nosounit.pas`)

This unit manages the **Summary (Balance Index)**, which is the "State" of the blockchain (UTXO-like but account-based).

## Data Types
- `TSummaryData`: Packed record containing Noso address, Balance, Score, and Name (Customization).

## Balance Management

### `SummaryValidPay(Address: String; amount, blocknumber: Int64): Boolean`
The most critical validation function. Checks if an address has sufficient funds at a specific block height to perform a transaction.

### `SummaryPay(Address: String; amount, blocknumber: Int64)`
Debits an address in the summary index.

### `SummaryRecive(Address: String; amount, blocknumber: Int64)`
Credits an address in the summary index.

### `UpdateSummaryChanges()`
Flushes memory-cached balance changes to the `Summary.nos` file on disk.

## Indexing logic
- `CreateSumaryIndex()`: Builds a memory index to allow O(1) lookups for any address balance.
- `GetIndexPosition(...)`: Finds the offset in the summary file for a specific address.

## Backups
- `CreateSumaryBackup()`: Copies `Summary.nos` to `.bak`.
- `RestoreSumaryBackup()`: Restores from the backup file in case of corruption.
