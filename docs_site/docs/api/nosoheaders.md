# API Reference: `nosoheaders.pas`

Manages the block header database (`blchhead.nos`), allowing quick verification of the blockchain height and hashes without loading full block data.

## Persistent Storage

### `AddRecordToHeaders(BlockNumber, BlockHash, SumHash): Boolean`
Appends a new block record to the end of the header file.

### `RemoveHeadersLastRecord(): Boolean`
Truncates the file by one record (used for rolling back forks).

### `GetHeadersAsMemStream(var LMs: TMemoryStream): Int64`
Downloads the entire header set into a stream for peer-to-peer sharing.

## Status Information

### `GetHeadersHeigth(): Integer`
Returns the current file height (Filesize - 1).

### `GetHeadersLastBlock(): Integer`
Finds the block number of the final record in the file.

### `SetResumenHash()`
Calculates and caches the MD5 hash of the header file for consensus checks.

## Handshake Support

### `LastHeadersString(FromBlock: Integer): String`
Constructs a formatted string containing the last ~100 blocks to help peers synchronize their headers quickly.

## Record Format
- `ResumenData`: Packed Record
  - `block`: Integer
  - `blockhash`: String[32]
  - `SumHash`: String[32]
