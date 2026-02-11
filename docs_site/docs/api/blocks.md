# API Reference: Blocks (`mpblock.pas` & `nosoblock.pas`)

These units manage the lifecycle of blocks, from creation to disk persistence.

## `nosoblock.pas` (Storage)

### `GetBlockTrxs(BlockNumber: Integer): TBlockOrdersArray`
Loads a `.blk` file from disk and deserializes the transaction array.

### `LoadBlockDataHeader(BlockNumber: Integer): BlockHeaderData`
Reads ONLY the header information of a block file (efficient for chain scanning).

### `UpdateBlockDatabase(): Boolean`
Synchronizes the local `blocks_db.nos` index with the `.blk` files found on disk.

### `GetBlockFromOrder(OrderID: String): Integer`
Queries the database index to find which block height contains a specific transaction.

## `mpblock.pas` (Logic)

### `BuildNewBlock(Numero: Integer; TimeStamp: Int64; ...)`
The primary engine for closing the current round and forging a new block.
- Calculates Miner reward.
- Processes PoS and Masternode rewards.
- Flushes the verified mempool to disk.

### `GetBlockMNs(BlockNumber: Integer): BlockArraysPos`
Returns the list of Masternodes that were credited in a specific block.

### `CrearBloqueCero()`
Initializes the "Genesis Block" (Block 0) with hardcoded values.
