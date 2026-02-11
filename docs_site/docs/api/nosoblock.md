# API Reference: `nosoblock.pas`

Structural and structural and initialization logic for Noso blocks.

## Initialization

### `CreateGenesysBlock()`
The routine that generates the first block (0) and sets the initial coin supply and project reward structures.

## Synchronization

### `GetBlockHeadersAsStream(out LStream: TMemoryStream): Int64`
Downloads block metadata into a stream for peer sharing.

### `GetLastBlockNumber(): Integer`
Returns the height of the most recent block saved on disk.

## Persistence Helpers
- `GetBlockFilename(BlockNum: Integer): String`: Returns the relative path (e.g., `NOSODATA/12345.blk`).
- `SaveBlockHeaders(Headers: BlockHeaderData)`: Persists block metadata separately from transaction data.
