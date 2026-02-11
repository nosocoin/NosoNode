# API Reference: Persistence (`nosowallcon.pas` & `nosoheaders.pas`)

Data management for the user's private keys and the global block headers.

## `nosowallcon.pas` (Wallet Controller)

### `CreateNewWallet(): Boolean`
Generates the initial `wallet.pkw` with a single secure EC address.

### `ImportAddressesFromBackup(BakFolder: String): Integer`
Scans a folder for `.pkw` files and merges unique addresses into the active wallet.

### `GetWalletAsStream(out LStream: TMemoryStream): Int64`
Returns the encrypted/binary wallet data.

### `WallAddIndex(Address: String): Integer`
Locates the index of a specific address within the memory-cached wallet array.

## `nosoheaders.pas` (Block Headers)

### `AddRecordToHeaders(BlockNumber, BlockHash, SumHash): Boolean`
Appends a new block's metadata to the header index.

### `GetHeadersLastBlock(): Integer`
Returns the highest block height currently stored in the headers file.

### `LastHeadersString(FromBlock: Integer): String`
Constructs the protocol response for peers requesting a "Head Update" (the last 100+ blocks).

### `SetHeadersFileName(Filename: String): Boolean`
Configures where the header index is stored (default `blchhead.nos`).
