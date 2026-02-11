# API Reference: Block Management (`mpblock.pas` & `nosoblock.pas`)

These units handle the lifecycle of blocks, from creation to storage on disk.

## `mpblock.pas` (Chain Operations)

### `BuildNewBlock()`
The primary logic for assembling a new block at the end of a round. Collects pending transactions, performs final validation, and calculates the summary update.

### `SaveBlockToDisk(BlockData: BlockHeaderData; TrxArray: array of TOrderData)`
Writes a block and its associated transactions to a binary `.blk` file.

### `LoadBlockFromDisk(BlockNum: Integer; out BlockData: BlockHeaderData; out TrxArray: array of TOrderData)`
Reads a block from the `NOSODATA` directory.

## `nosoblock.pas` (Structural logic)

### `GetBlockHeadersAsStream(out LStream: TMemoryStream): Int64`
Serializes the block header for network propagation.

### `CreateGenesysBlock()`
Initializes the blockchain with the hardcoded "Genesis" block (0).

### `GetLastBlockNumber(): Integer`
Returns the height of the current local chain.

## Data Structures
- `BlockHeaderData`: Packed Record (Details in [DATA_STRUCTURES](../DATA_STRUCTURES.md)).
